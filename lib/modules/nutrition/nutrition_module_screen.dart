import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/age_calculator.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../../reports/weekly_meal_plan_pdf_builder.dart';
import '../../utils/config_storage.dart';
import '../growth/growth_assessment.dart';
import 'food_exchange_data.dart';
import 'nutrition_calculator.dart';
import 'nutrition_data.dart';
import 'meal_plan_data.dart';
import 'weekly_meal_plan_generator.dart';

/// Halaman Modul Standalone: Nutrisi & Meal Plan Pediatrik.
class NutritionModuleScreen extends StatefulWidget {
  final Patient? initialPatient;

  const NutritionModuleScreen({super.key, this.initialPatient});

  @override
  State<NutritionModuleScreen> createState() => _NutritionModuleScreenState();
}

class _NutritionModuleScreenState extends State<NutritionModuleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Patient? _selectedPatient;
  String? _selectedPatientId;

  final _weightController = TextEditingController(text: '10.0');
  final _heightController = TextEditingController(text: '75.0');
  final _idealWeightController = TextEditingController(text: '7.5');
  final _noteController = TextEditingController();

  String _sex = 'L';
  double _ageMonths = 12.0;

  /// Usia pasien terpilih (kronologis + koreksi) untuk label panduan makan.
  /// Null pada mode simulasi (slider murni manual).
  AgeResult? _patientAge;
  bool _isMalnourished = false;
  bool _catchUpAutoDetected = false;
  String? _textureOverride; // null = ikuti usia; 'saring' | 'lembik' | 'keluarga'

  /// Penanda urutan pemuatan data pasien. Hasil query pasien lama yang
  /// datang terlambat tidak boleh menimpa data pasien yang sedang dipilih.
  int _patientLoadToken = 0;
  bool _patientDataMissing = false;

  static const String _defaultWeight = '10.0';
  static const String _defaultHeight = '75.0';

  static const Set<String> _defaultCarbs = {'Nasi Beras Giling', 'Kentang', 'Roti Putih'};
  static const Set<String> _defaultAnimals = {'Daging Ayam tanpa Kulit', 'Telur Ayam', 'Ikan Segar (Kembung/Mas/Kakap)'};
  static const Set<String> _defaultPlants = {'Tempe', 'Tahu'};
  static const Set<String> _defaultVeggies = {'Wortel', 'Bayam', 'Brokoli', 'Labu Siam / Labu Air'};
  static const Set<String> _defaultFruits = {'Pisang Ambon / Kepok', 'Alpukat', 'Pepaya'};

  Set<String> _selectedCarbsNames = {..._defaultCarbs};
  Set<String> _selectedAnimalNames = {..._defaultAnimals};
  Set<String> _selectedPlantNames = {..._defaultPlants};
  Set<String> _selectedVegNames = {..._defaultVeggies};
  Set<String> _selectedFruitNames = {..._defaultFruits};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _syncIdealWeight();
    _loadSavedSelections();

    final initial = widget.initialPatient;
    if (initial != null) {
      _loadPatientData(initial);
    }
  }

  void _syncIdealWeight() {
    final h = double.tryParse(_heightController.text) ?? 75.0;
    final bbi = PediatricNutritionCalculator.calculateIdealWeight(
      heightCm: h,
      sex: _sex,
      ageMonths: _ageMonths,
    );
    _idealWeightController.text = bbi.toStringAsFixed(1);
  }

  void _loadPatientData(Patient p) {
    // Naikkan token agar hasil query pasien sebelumnya diabaikan bila masih
    // berjalan (mis. dokter cepat berganti pasien di dropdown).
    final token = ++_patientLoadToken;
    final age = AgeCalculator.calculate(
      birthDate: p.birthDate,
      examDate: DateTime.now(),
      gestationalWeeks: p.gestationalWeeks,
    );

    setState(() {
      _selectedPatient = p;
      _selectedPatientId = p.id;
      _sex = p.sex;
      _patientAge = age;
      // Arahan dokter: panduan makanan (tekstur, porsi, resep, menu)
      // mengikuti usia koreksi selama koreksi prematur berlaku.
      _ageMonths = age.foodAgeMonths.toDouble();
      // Reset status catch-up agar tidak terbawa dari pasien sebelumnya;
      // akan terisi otomatis dari status gizi pemeriksaan terakhir.
      _isMalnourished = false;
      _catchUpAutoDetected = false;
      _patientDataMissing = false;
      _textureOverride = null;
      // Jangan tampilkan BB/TB/catatan milik pasien sebelumnya.
      _weightController.text = _defaultWeight;
      _heightController.text = _defaultHeight;
      _noteController.clear();
    });
    _syncIdealWeight();

    // Ambil data pertumbuhan terakhir pasien bila ada
    final repo = context.read<AppRepository>();
    repo.watchExaminations(p.id).first.then((exams) {
      if (!mounted || token != _patientLoadToken) return;
      if (exams.isEmpty) {
        setState(() => _patientDataMissing = true);
        return;
      }
      repo.getGrowthForExam(exams.first.id).then((g) {
        if (!mounted || token != _patientLoadToken) return;
        if (g == null) {
          setState(() => _patientDataMissing = true);
          return;
        }
        // Deteksi indikasi catch-up dari status gizi WHO pemeriksaan
        // terakhir (definisi sama dengan layar Pertumbuhan & PDF).
        final assessment = GrowthAssessment.fromMeasurement(
          birthDate: p.birthDate,
          examDate: exams.first.examDate,
          gestationalWeeks: p.gestationalWeeks,
          sex: p.sex,
          m: g,
        );
        setState(() {
          _patientDataMissing = false;
          if (g.weightKg != null) _weightController.text = g.weightKg.toString();
          if (g.heightCm != null) {
            _heightController.text = g.heightCm.toString();
            _syncIdealWeight();
          }
          _isMalnourished = assessment.indicatesMalnutrition;
          _catchUpAutoDetected = assessment.indicatesMalnutrition;
        });
      });
    });
  }

  Future<void> _loadSavedSelections() async {
    try {
      final savedCarbs =
          await ConfigStorage.getStringList('nutrition_selected_carbs');
      final savedAnimals =
          await ConfigStorage.getStringList('nutrition_selected_animals');
      final savedPlants =
          await ConfigStorage.getStringList('nutrition_selected_plants');
      final savedVeggies =
          await ConfigStorage.getStringList('nutrition_selected_veggies');
      final savedFruits =
          await ConfigStorage.getStringList('nutrition_selected_fruits');

      if (!mounted) return;
      setState(() {
        if (savedCarbs != null && savedCarbs.isNotEmpty) {
          _selectedCarbsNames = savedCarbs.toSet();
        }
        if (savedAnimals != null && savedAnimals.isNotEmpty) {
          _selectedAnimalNames = savedAnimals.toSet();
        }
        if (savedPlants != null && savedPlants.isNotEmpty) {
          _selectedPlantNames = savedPlants.toSet();
        }
        if (savedVeggies != null && savedVeggies.isNotEmpty) {
          _selectedVegNames = savedVeggies.toSet();
        }
        if (savedFruits != null && savedFruits.isNotEmpty) {
          _selectedFruitNames = savedFruits.toSet();
        }
      });
    } catch (_) {}
  }

  Future<void> _saveSelections() async {
    try {
      await ConfigStorage.setStringList(
          'nutrition_selected_carbs', _selectedCarbsNames.toList());
      await ConfigStorage.setStringList(
          'nutrition_selected_animals', _selectedAnimalNames.toList());
      await ConfigStorage.setStringList(
          'nutrition_selected_plants', _selectedPlantNames.toList());
      await ConfigStorage.setStringList(
          'nutrition_selected_veggies', _selectedVegNames.toList());
      await ConfigStorage.setStringList(
          'nutrition_selected_fruits', _selectedFruitNames.toList());
    } catch (_) {}
  }

  Future<void> _resetDefaultSelections() async {
    setState(() {
      _selectedCarbsNames = {..._defaultCarbs};
      _selectedAnimalNames = {..._defaultAnimals};
      _selectedPlantNames = {..._defaultPlants};
      _selectedVegNames = {..._defaultVeggies};
      _selectedFruitNames = {..._defaultFruits};
    });
    await _saveSelections();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilihan bahan makanan dikembalikan ke default'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _idealWeightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AppRepository>();
    final weight = double.tryParse(_weightController.text) ?? 10.0;
    final height = double.tryParse(_heightController.text) ?? 75.0;
    final idealWeight = double.tryParse(_idealWeightController.text) ??
        PediatricNutritionCalculator.calculateIdealWeight(
          heightCm: height,
          sex: _sex,
          ageMonths: _ageMonths,
        );

    final nutResult = PediatricNutritionCalculator.calculate(
      weightKg: weight,
      heightCm: height,
      ageMonths: _ageMonths,
      sex: _sex,
      idealWeightKg: idealWeight,
      isMalnourished: _isMalnourished,
    );

    final portionGuide = MealPlanRepository.getPortionGuide(_ageMonths);
    final recipes = MealPlanRepository.getRecipesForAge(_ageMonths);

    final selectedCarbs = FoodExchangeRepository.carbsList
        .where((i) => _selectedCarbsNames.contains(i.name))
        .toList();
    final selectedAnimalProteins = FoodExchangeRepository.allAnimalProtein
        .where((i) => _selectedAnimalNames.contains(i.name))
        .toList();
    final selectedPlantProteins = FoodExchangeRepository.plantProteinList
        .where((i) => _selectedPlantNames.contains(i.name))
        .toList();
    final selectedVeggies = FoodExchangeRepository.veggiesList
        .where((i) => _selectedVegNames.contains(i.name))
        .toList();
    final selectedFruits = FoodExchangeRepository.fruitsList
        .where((i) => _selectedFruitNames.contains(i.name))
        .toList();

    final weeklyPlan = WeeklyMealPlanGenerator.generate7DayPlan(
      ageMonths: _ageMonths,
      selectedCarbs: selectedCarbs.isNotEmpty ? selectedCarbs : null,
      selectedAnimalProteins: selectedAnimalProteins.isNotEmpty ? selectedAnimalProteins : null,
      selectedPlantProteins: selectedPlantProteins.isNotEmpty ? selectedPlantProteins : null,
      selectedVeggies: selectedVeggies.isNotEmpty ? selectedVeggies : null,
      selectedFruits: selectedFruits.isNotEmpty ? selectedFruits : null,
      nutResult: nutResult,
      textureOverride: _textureOverride,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrisi & Meal Plan Pediatrik'),
        actions: [
          IconButton(
            tooltip: 'Cetak Meal Plan 7 Hari (PDF)',
            icon: const Icon(Icons.picture_as_pdf, color: Colors.teal),
            onPressed: () => _printWeeklyMealPlanPdf(nutResult, weeklyPlan),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amberAccent,
          indicatorWeight: 3.0,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.calculate), text: 'Kalkulator Gizi'),
            Tab(icon: Icon(Icons.calendar_view_week), text: 'Meal Plan 7 Hari'),
            Tab(icon: Icon(Icons.restaurant), text: 'Panduan Porsi'),
            Tab(icon: Icon(Icons.menu_book), text: 'Resep MPASI'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Selector Pasien & Input Parameter Fisik
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StreamBuilder<List<Patient>>(
                          stream: repo.watchPatients(),
                          builder: (context, snap) {
                            final patients = snap.data ?? [];
                            final activeId = (snap.hasData && snap.data!.any((p) => p.id == _selectedPatientId))
                                ? _selectedPatientId
                                : null;

                            return DropdownButton<String?>(
                              isExpanded: true,
                              hint: const Text('Pilih Pasien Terdaftar (Opsional)'),
                              value: activeId,
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('Simulasi Konseling Gizi Cepat'),
                                ),
                                ...patients.map(
                                  (p) => DropdownMenuItem<String?>(
                                    value: p.id,
                                    child: Text('${p.name} (${p.sex})'),
                                  ),
                                ),
                              ],
                              onChanged: (id) {
                                if (id != null) {
                                  final p = patients
                                      .firstWhere((item) => item.id == id);
                                  _loadPatientData(p);
                                } else {
                                  setState(() {
                                    // Batalkan pemuatan pasien yang masih
                                    // berjalan saat beralih ke mode simulasi.
                                    _patientLoadToken++;
                                    _selectedPatientId = null;
                                    _selectedPatient = null;
                                    _patientAge = null;
                                    _isMalnourished = false;
                                    _catchUpAutoDetected = false;
                                    _patientDataMissing = false;
                                    _textureOverride = null;
                                    _weightController.text = _defaultWeight;
                                    _heightController.text = _defaultHeight;
                                    _noteController.clear();
                                  });
                                  _syncIdealWeight();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedPatient != null && _patientDataMissing) ...[
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            size: 14, color: Colors.orange.shade800),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Belum ada data BB/TB dari pemeriksaan pasien ini — masukkan manual. Nilai awal bukan data pasien.',
                            style: TextStyle(fontSize: 10.5, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const ValueKey('weight_field'),
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Berat (kg)',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          key: const ValueKey('height_field'),
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Tinggi (cm)',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) {
                            setState(() {
                              _syncIdealWeight();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          // Key per nilai agar tampilan ikut berubah saat
                          // pasien terpilih berganti jenis kelamin
                          // (initialValue saja tidak memperbarui field).
                          key: ValueKey('gender_$_sex'),
                          initialValue: _sex,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'L', child: Text('Laki')),
                            DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                _sex = v;
                                _syncIdealWeight();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _ageMonths.clamp(1.0, 60.0),
                          min: 1.0,
                          max: 60.0,
                          divisions: 59,
                          label: '${_ageMonths.round()} bln',
                          onChanged: (v) => setState(() {
                            _ageMonths = v;
                            _syncIdealWeight();
                          }),
                        ),
                      ),
                      Text(
                        _patientAge?.correctionApplied == true
                            ? 'Usia koreksi: ${_ageMonths.round()} bln'
                            : 'Usia: ${_ageMonths.round()} bln',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (_patientAge?.correctionApplied == true) ...[
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            size: 14, color: Colors.teal.shade800),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Kronologis ${_patientAge!.chronologicalMonths} bln '
                            '• Koreksi ${_patientAge!.correctedMonths} bln — '
                            'tekstur, porsi, resep & menu mengikuti usia '
                            'koreksi. Geser slider untuk simulasi manual.',
                            style: TextStyle(
                                fontSize: 10.5, color: Colors.teal.shade900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Konten Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: KALKULATOR GIZI KLINIK
                _buildCalculatorTab(nutResult),

                // TAB 2: MEAL PLAN 7 HARI (SENIN S/D MINGGU)
                _buildWeeklyMealPlanTab(weeklyPlan, nutResult),

                // TAB 3: PANDUAN PORSI SATTER
                _buildPortionTab(portionGuide, weeklyPlan, nutResult),

                // TAB 4: RESEP MPASI KEMENKES 2023
                _buildRecipeTab(recipes),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.print),
            label: const Text('Cetak & Bagikan Meal Plan 7 Hari (PDF)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            onPressed: () => _printWeeklyMealPlanPdf(nutResult, weeklyPlan),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorTab(NutritionCalculationResult nutResult) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          color: Colors.teal.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kebutuhan Gizi Harian (RDA × BB Ideal - Standar IDAI / AAP)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                ),
                const Divider(),
                _resultRow('Kebutuhan Energi (RDA × BBI)', '${nutResult.eerKcal.round()} kcal/hari (${nutResult.energyRdaPerKg.round()} kcal/kg)', isBold: true),
                _resultRow('Kebutuhan Protein Harian', '${nutResult.proteinGrams.toStringAsFixed(1)} g/hari (${nutResult.proteinRdaPerKg} g/kg BBI)'),
                _resultRow('Kebutuhan Cairan (Holliday-Segar)', '${nutResult.fluidMl.round()} mL/hari'),
                _resultRow('Berat Badan Ideal (BBI)', nutResult.idealWeightLabel),
                _resultRow('Usia Tinggi (Height Age)', nutResult.heightAgeLabel),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: CheckboxListTile(
            title: const Text('Indikasi Gagal Tumbuh / Stunting / Wasting'),
            subtitle: Text(
              _catchUpAutoDetected && _isMalnourished
                  ? 'Terdeteksi otomatis dari status gizi pemeriksaan terakhir — dapat diubah manual'
                  : 'Aktifkan perhitungan kalori Catch-Up Growth',
            ),
            value: _isMalnourished,
            onChanged: (v) => setState(() {
              _isMalnourished = v ?? false;
              _catchUpAutoDetected = false;
            }),
          ),
        ),
        if (_isMalnourished) ...[
          const SizedBox(height: 8),
          Card(
            color: Colors.deepOrange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      const Text('Target Catch-Up Growth', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepOrange)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idealWeightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Berat Badan Ideal P50 (kg)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  _resultRow('Kalori Catch-Up Growth', '${nutResult.catchUpEnergyKcal?.round() ?? '-'} kcal/hari', isBold: true),
                  _resultRow('Protein Catch-Up Growth', '${nutResult.catchUpProteinGrams?.toStringAsFixed(1) ?? '-'} g/hari'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeeklyMealPlanTab(List<SingleDayMealPlan> weeklyPlan, NutritionCalculationResult nutResult) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Card Ringkasan Patokan Target Kalori & Protein
        Card(
          color: nutResult.needsCatchUp ? Colors.deepOrange.shade50 : Colors.teal.shade50,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: nutResult.needsCatchUp ? Colors.deepOrange.shade300 : Colors.teal.shade300,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: nutResult.needsCatchUp ? Colors.deepOrange : Colors.teal,
                  foregroundColor: Colors.white,
                  child: Icon(nutResult.needsCatchUp ? Icons.trending_up : Icons.restaurant, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nutResult.needsCatchUp
                            ? 'Patokan Meal Plan: Catch-Up Growth (Kejar Tumbuh)'
                            : 'Patokan Meal Plan: Kebutuhan Gizi Standar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: nutResult.needsCatchUp ? Colors.deepOrange.shade900 : Colors.teal.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nutResult.needsCatchUp
                            ? '🎯 Target Kalori: ${nutResult.targetEnergyKcal.round()} kcal/hari | Protein: ${nutResult.targetProteinGram.toStringAsFixed(1)} g/hari (BB Ideal: ${nutResult.idealWeightLabel})'
                            : '🎯 Target Kalori: ${nutResult.eerKcal.round()} kcal/hari | Protein: ${nutResult.proteinGrams.toStringAsFixed(1)} g/hari (BB Ideal: ${nutResult.idealWeightLabel})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: nutResult.needsCatchUp ? Colors.deepOrange.shade800 : Colors.teal.shade800,
                        ),
                      ),
                      if (nutResult.needsCatchUp) ...[
                        const SizedBox(height: 2),
                        Text(
                          'RDA Pemeliharaan Standar: ${nutResult.eerKcal.round()} kcal/hari. Menu difokuskan pada densitas energi tinggi.',
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700),
                        ),
                      ],
                      if (weeklyPlan.isNotEmpty && weeklyPlan.first.totalKcal > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Estimasi menu contoh: ±${weeklyPlan.first.totalKcal.round()} kkal/hari terhitung (makanan padat + susu terhitung) | ${weeklyPlan.first.macroSummary}. Kekurangan dari target dipenuhi ASI/susu on demand.',
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Pilihan tekstur (arahan dokter: bubur saring / nasi lembik / keluarga)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tekstur Makanan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    ChoiceChip(
                      label: const Text('Ikuti Usia', style: TextStyle(fontSize: 11)),
                      selected: _textureOverride == null,
                      onSelected: (_) => setState(() => _textureOverride = null),
                    ),
                    ChoiceChip(
                      label: const Text('Bubur Saring', style: TextStyle(fontSize: 11)),
                      selected: _textureOverride == 'saring',
                      onSelected: (_) => setState(() => _textureOverride = 'saring'),
                    ),
                    ChoiceChip(
                      label: const Text('Nasi Lembik', style: TextStyle(fontSize: 11)),
                      selected: _textureOverride == 'lembik',
                      onSelected: (_) => setState(() => _textureOverride = 'lembik'),
                    ),
                    ChoiceChip(
                      label: const Text('Makanan Keluarga', style: TextStyle(fontSize: 11)),
                      selected: _textureOverride == 'keluarga',
                      onSelected: (_) => setState(() => _textureOverride = 'keluarga'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Komponen wajib setiap hari: protein hewani di tiap makan utama, sayur & buah, lemak tambahan (minyak/santan), dan susu — pilihan susu: ASI, PKMK, PDK, atau UHT plain sesuai advis dokter.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Card Pemilihan Penukar Multi-Select (Mode Centang Bahan yang Ada di Rumah)
        Card(
          color: Colors.teal.shade50,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fact_check, color: Colors.teal, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Centang Bahan Makanan yang Tersedia di Rumah:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 6,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(color: Colors.teal.shade700),
                        ),
                        icon: Icon(Icons.swap_horiz, size: 15, color: Colors.teal.shade800),
                        label: Text('Tabel Penukar', style: TextStyle(fontSize: 11, color: Colors.teal.shade800, fontWeight: FontWeight.bold)),
                        onPressed: () => _showFoodExchangeDialog(context),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          visualDensity: VisualDensity.compact,
                          foregroundColor: Colors.grey.shade700,
                        ),
                        icon: const Icon(Icons.restart_alt, size: 15),
                        label: const Text('Reset', style: TextStyle(fontSize: 11)),
                        onPressed: _resetDefaultSelections,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Centang lebih dari satu bahan agar menu 7 hari bervariasi dan dirotasi secara otomatis.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const Divider(height: 16),

                // 1. Karbohidrat
                const Text('🍚 Karbohidrat Tersedia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: FoodExchangeRepository.carbsList.map((item) {
                    final isSelected = _selectedCarbsNames.contains(item.name);
                    return FilterChip(
                      selected: isSelected,
                      label: Text('${item.name} (${item.displayUrt})', style: const TextStyle(fontSize: 11)),
                      selectedColor: Colors.teal.shade100,
                      checkmarkColor: Colors.teal.shade800,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCarbsNames.add(item.name);
                          } else {
                            if (_selectedCarbsNames.length > 1) {
                              _selectedCarbsNames.remove(item.name);
                            }
                          }
                        });
                        _saveSelections();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // 2. Protein Hewani
                const Text('🍗 Protein Hewani Tersedia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: FoodExchangeRepository.allAnimalProtein.map((item) {
                    final isSelected = _selectedAnimalNames.contains(item.name);
                    return FilterChip(
                      selected: isSelected,
                      label: Text('${item.name} (${item.displayUrt})', style: const TextStyle(fontSize: 11)),
                      selectedColor: Colors.amber.shade100,
                      checkmarkColor: Colors.amber.shade900,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAnimalNames.add(item.name);
                          } else {
                            if (_selectedAnimalNames.length > 1) {
                              _selectedAnimalNames.remove(item.name);
                            }
                          }
                        });
                        _saveSelections();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // 3. Protein Nabati
                const Text('🥦 Protein Nabati Tersedia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: FoodExchangeRepository.plantProteinList.map((item) {
                    final isSelected = _selectedPlantNames.contains(item.name);
                    return FilterChip(
                      selected: isSelected,
                      label: Text('${item.name} (${item.displayUrt})', style: const TextStyle(fontSize: 11)),
                      selectedColor: Colors.green.shade100,
                      checkmarkColor: Colors.green.shade900,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPlantNames.add(item.name);
                          } else {
                            if (_selectedPlantNames.length > 1) {
                              _selectedPlantNames.remove(item.name);
                            }
                          }
                        });
                        _saveSelections();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                const Text('🥗 Sayuran Tersedia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: FoodExchangeRepository.veggiesList.map((item) {
                    final isSelected = _selectedVegNames.contains(item.name);
                    return FilterChip(
                      selected: isSelected,
                      label: Text('${item.name} (${item.displayUrt})', style: const TextStyle(fontSize: 11)),
                      selectedColor: Colors.lightGreen.shade100,
                      checkmarkColor: Colors.lightGreen.shade900,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedVegNames.add(item.name);
                          } else {
                            if (_selectedVegNames.length > 1) {
                              _selectedVegNames.remove(item.name);
                            }
                          }
                        });
                        _saveSelections();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                const Text('🍎 Buah-buahan Tersedia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: FoodExchangeRepository.fruitsList.map((item) {
                    final isSelected = _selectedFruitNames.contains(item.name);
                    return FilterChip(
                      selected: isSelected,
                      label: Text('${item.name} (${item.displayUrt})', style: const TextStyle(fontSize: 11)),
                      selectedColor: Colors.orange.shade100,
                      checkmarkColor: Colors.orange.shade900,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedFruitNames.add(item.name);
                          } else {
                            if (_selectedFruitNames.length > 1) {
                              _selectedFruitNames.remove(item.name);
                            }
                          }
                        });
                        _saveSelections();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Catatan dokter yang ikut tercetak di PDF meal plan.
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              key: const ValueKey('doctor_note_field'),
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Catatan Dokter (tercetak di PDF)',
                hintText: 'Mis. kontrol ulang 2 minggu, naikkan porsi bila BB naik…',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        ...weeklyPlan.map((dayPlan) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                child: Text(dayPlan.dayName.substring(0, 3), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              title: Text('${dayPlan.dayName}: ${dayPlan.theme}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(
                dayPlan.totalKcal > 0
                    ? '${dayPlan.sessions.length} Waktu Makan • ±${dayPlan.totalKcal.round()} kkal • ${dayPlan.macroSummary}'
                    : '${dayPlan.sessions.length} Waktu Makan',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              children: dayPlan.sessions.map((session) {
                return ListTile(
                  dense: true,
                  leading: Chip(
                    label: Text(session.time, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.zero,
                  ),
                  title: Text('${session.sessionName} - ${session.menuName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.description, style: const TextStyle(fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        session.kcal > 0
                            ? 'Porsi: ${session.portionUrt} (±${session.kcal.round()} kkal)'
                            : 'Porsi: ${session.portionUrt}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  void _showFoodExchangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.swap_horiz, color: Colors.teal),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Tabel Bahan Makanan Penukar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          content: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: _buildFoodExchangeTab(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFoodExchangeTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('Daftar Bahan Makanan Penukar (Standar Ahli Gizi / NutriSurvey)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal)),
        const SizedBox(height: 8),
        _exchangeSectionCard('Golongan I: Karbohidrat (175 Kal, 4g Protein, 40g KH)', FoodExchangeRepository.carbsList, Colors.amber),
        _exchangeSectionCard('Golongan II-A: Protein Hewani Rendah Lemak (50 Kal, 7g Protein, 2g Lemak)', FoodExchangeRepository.animalProteinLowFat, Colors.blue),
        _exchangeSectionCard('Golongan II-B: Protein Hewani Sedang Lemak (75 Kal, 7g Protein, 5g Lemak)', FoodExchangeRepository.animalProteinMedFat, Colors.orange),
        _exchangeSectionCard('Golongan II-C: Protein Hewani Tinggi Lemak (150 Kal, 7g Protein, 13g Lemak)', FoodExchangeRepository.animalProteinHighFat, Colors.red),
        _exchangeSectionCard('Golongan III: Protein Nabati (75 Kal, 5g Protein, 3g Lemak, 7g KH)', FoodExchangeRepository.plantProteinList, Colors.green),
        _exchangeSectionCard('Golongan IV: Sayuran A & B (25–50 Kal, 1–3g Protein, 100g/1 Gelas)', FoodExchangeRepository.veggiesList, Colors.lightGreen.shade700),
        _exchangeSectionCard('Golongan V: Buah-buahan (50 Kal, 12g KH)', FoodExchangeRepository.fruitsList, Colors.deepOrange),
        _exchangeSectionCard('Golongan VI: Susu & Olahan (125 Kal, 7g Protein)', FoodExchangeRepository.milkList, Colors.purple),
      ],
    );
  }

  Widget _exchangeSectionCard(String title, List<FoodExchangeItem> items, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
        children: items.map((item) {
          return ListTile(
            dense: true,
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Ukuran / Berat: ${item.displayUrt} ${item.notes != null ? "(${item.notes})" : ""}'),
            trailing: Text('${item.calories.round()} Kal', style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPortionTab(
    PortionGuide guide,
    List<SingleDayMealPlan> weeklyPlan,
    NutritionCalculationResult nutResult,
  ) {
    final sampleDay = weeklyPlan.isNotEmpty ? weeklyPlan.first : null;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Acuan utama: takaran yang benar-benar dipakai pada menu 7 hari.
        // Sebelumnya tab ini hanya menampilkan rentang umum per usia,
        // sehingga bisa berbeda dengan Meal Plan (sumber takaran ganda).
        Card(
          color: Colors.teal.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.teal.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Porsi Hasil Hitung Target Kalori (Acuan Utama)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Target ${nutResult.targetEnergyKcal.round()} kkal/hari • '
                  'protein ${nutResult.targetProteinGram.toStringAsFixed(1)} g/hari'
                  '${nutResult.needsCatchUp ? ' (kejar tumbuh)' : ''}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.teal.shade900),
                ),
                const SizedBox(height: 2),
                Text(
                  sampleDay == null
                      ? 'Belum ada menu contoh.'
                      : 'Contoh ${sampleDay.dayName}: ±${sampleDay.totalKcal.round()} kkal terhitung',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
                const Divider(),
                if (sampleDay != null)
                  ...sampleDay.sessions.map((s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 96,
                              child: Text(
                                '${s.sessionName} (${s.time})',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(s.portionUrt, style: const TextStyle(fontSize: 11)),
                            ),
                            if (s.kcal > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  '${s.kcal.round()} kkal',
                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.teal.shade800),
                                ),
                              ),
                          ],
                        ),
                      )),
                const SizedBox(height: 6),
                Text(
                  'Takaran ini sama dengan tab Meal Plan 7 Hari dan PDF. Bila berbeda dengan tabel umum di bawah, ikuti takaran hasil hitung ini.',
                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Referensi umum per kelompok usia (bukan target individual).
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Panduan Porsi Umum per Usia (Referensi)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  'Kelompok ${guide.ageGroupLabel} • Tekstur: ${guide.textureLabel}',
                  style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Rentang umum untuk konseling. Ini bukan target individual — gunakan porsi hasil hitung di atas bila BB/TB anak sudah diukur.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _portionCard('Karbohidrat', guide.carbs, Icons.rice_bowl, Colors.orange),
        _portionCard('Protein Hewani (Utama)', guide.animalProtein, Icons.set_meal, Colors.red),
        _portionCard('Protein Nabati', guide.plantProtein, Icons.eco, Colors.green),
        _portionCard('Sayur & Buah', guide.veggiesFruit, Icons.local_florist, Colors.purple),
        _portionCard('Lemak Tambahan', guide.fatAdded, Icons.water_drop, Colors.amber),
        _portionCard('Susu / Cairan', guide.milkFluid, Icons.local_cafe, Colors.blue),
        if (_ageMonths <= 24.0) ...[
          const SizedBox(height: 12),
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal.shade200),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.verified, color: Colors.teal),
              title: const Text(
                '7 Rekomendasi Emas MPASI WHO Guideline (2023)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
              ),
              subtitle: const Text(
                'Standar Resmi Pangan Anak 6–23 Bulan (WHO Complementary Feeding 2023)',
                style: TextStyle(fontSize: 11, color: Colors.teal),
              ),
              children: whoComplementaryFeedingPrinciples.map((p) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.teal.shade700,
                            child: Text(
                              '${p.number}',
                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p.title,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: Text(
                          p.recommendation,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 2),
                      ...p.details.map((d) => Padding(
                            padding: const EdgeInsets.only(left: 28, top: 2),
                            child: Text('• $d', style: TextStyle(fontSize: 11, color: Colors.grey.shade800)),
                          )),
                      const Divider(height: 14),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _portionCard(String title, String val, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(val),
      ),
    );
  }

  Widget _buildRecipeTab(List<MpasiRecipe> recipes) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Card(
            color: Colors.amber.shade50,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.amber.shade300),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.menu_book, color: Colors.deepOrange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Resep MPASI Padat Nutrisi: Buku Resep Makanan Lokal Kemenkes RI (2023) diselaraskan dengan Standar Keragaman Pangan Harian & Bebas Gula Tambahan WHO Guideline (2023).',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final r = recipes[i - 1];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.restaurant_menu, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Usia: ${r.ageGroup}  |  Tekstur: ${r.texture}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Divider(),
                const Text('Bahan-bahan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ...r.ingredients.map((ing) => Text('• $ing', style: const TextStyle(fontSize: 12))),
                const SizedBox(height: 8),
                const Text('Cara Membuat:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(r.instructions, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _resultRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: Colors.teal.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printWeeklyMealPlanPdf(
    NutritionCalculationResult nutResult,
    List<SingleDayMealPlan> weeklyPlan,
  ) async {
    final dummyPatient = _selectedPatient ??
        Patient(
          id: 'simulasi',
          name: 'Anak (Konseling Gizi)',
          birthDate: DateTime.now().subtract(Duration(days: (_ageMonths * 30.4).round())),
          sex: _sex,
          createdAt: DateTime.now(),
          isPremature: false,
          hasDownSyndrome: false,
        );

    final selectedCarbs = FoodExchangeRepository.carbsList
        .where((i) => _selectedCarbsNames.contains(i.name))
        .toList();
    final selectedAnimalProteins = FoodExchangeRepository.allAnimalProtein
        .where((i) => _selectedAnimalNames.contains(i.name))
        .toList();
    final selectedPlantProteins = FoodExchangeRepository.plantProteinList
        .where((i) => _selectedPlantNames.contains(i.name))
        .toList();
    final selectedVeggies = FoodExchangeRepository.veggiesList
        .where((i) => _selectedVegNames.contains(i.name))
        .toList();
    final selectedFruits = FoodExchangeRepository.fruitsList
        .where((i) => _selectedFruitNames.contains(i.name))
        .toList();

    WeeklyMealPlanPdfBuilder.showPdfPreview(
      context: context,
      patient: dummyPatient,
      nutResult: nutResult,
      weeklyPlan: weeklyPlan,
      selectedCarbs: selectedCarbs,
      selectedAnimalProteins: selectedAnimalProteins,
      selectedPlantProteins: selectedPlantProteins,
      selectedVeggies: selectedVeggies,
      selectedFruits: selectedFruits,
      selectedCarb: selectedCarbs.firstOrNull,
      selectedAnimalProtein: selectedAnimalProteins.firstOrNull,
      selectedPlantProtein: selectedPlantProteins.firstOrNull,
      customNote: _noteController.text,
    );
  }
}

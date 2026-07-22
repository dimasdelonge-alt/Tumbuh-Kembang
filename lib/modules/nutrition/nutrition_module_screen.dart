import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/age_calculator.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../../reports/weekly_meal_plan_pdf_builder.dart';
import 'food_exchange_data.dart';
import 'nutrition_calculator.dart';
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
  final _idealWeightController = TextEditingController(text: '9.5');
  final _noteController = TextEditingController();

  String _sex = 'L';
  double _ageMonths = 12.0;
  bool _isMalnourished = false;

  final Set<String> _selectedCarbsNames = {'Nasi Beras Giling', 'Kentang', 'Roti Putih'};
  final Set<String> _selectedAnimalNames = {'Daging Ayam tanpa Kulit', 'Telur Ayam', 'Ikan Segar (Kembung/Mas/Kakap)'};
  final Set<String> _selectedPlantNames = {'Tempe', 'Tahu'};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    if (widget.initialPatient != null) {
      _selectedPatient = widget.initialPatient;
      _selectedPatientId = widget.initialPatient!.id;
      _loadPatientData(widget.initialPatient!);
    }
  }

  void _loadPatientData(Patient p) {
    _sex = p.sex;
    final age = AgeCalculator.calculate(
      birthDate: p.birthDate,
      examDate: DateTime.now(),
      gestationalWeeks: p.gestationalWeeks,
    );
    _ageMonths = age.chronologicalMonths.toDouble();

    // Ambil data pertumbuhan terakhir pasien bila ada
    final repo = context.read<AppRepository>();
    repo.watchExaminations(p.id).first.then((exams) {
      if (exams.isNotEmpty) {
        repo.getGrowthForExam(exams.first.id).then((g) {
          if (g != null && mounted) {
            setState(() {
              if (g.weightKg != null) _weightController.text = g.weightKg.toString();
              if (g.heightCm != null) _heightController.text = g.heightCm.toString();
            });
          }
        });
      }
    });
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
    final idealWeight = double.tryParse(_idealWeightController.text) ?? weight;

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

    final weeklyPlan = WeeklyMealPlanGenerator.generate7DayPlan(
      ageMonths: _ageMonths,
      selectedCarbs: selectedCarbs.isNotEmpty ? selectedCarbs : null,
      selectedAnimalProteins: selectedAnimalProteins.isNotEmpty ? selectedAnimalProteins : null,
      selectedPlantProteins: selectedPlantProteins.isNotEmpty ? selectedPlantProteins : null,
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
                                setState(() {
                                  _selectedPatientId = id;
                                  if (id != null) {
                                    final p = patients.firstWhere((item) => item.id == id);
                                    _selectedPatient = p;
                                    _loadPatientData(p);
                                  } else {
                                    _selectedPatient = null;
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Tinggi (cm)',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _sex,
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
                            if (v != null) setState(() => _sex = v);
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
                          onChanged: (v) => setState(() => _ageMonths = v),
                        ),
                      ),
                      Text(
                        'Usia: ${_ageMonths.round()} bln',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
                _buildPortionTab(portionGuide),

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
                const Text('Kebutuhan Gizi Harian (AAP Handbook 2011)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                const Divider(),
                _resultRow('Kebutuhan Energi (EER WHO)', '${nutResult.eerKcal.round()} kcal/hari', isBold: true),
                _resultRow('Kebutuhan Protein Harian', '${nutResult.proteinGrams.toStringAsFixed(1)} g/hari (${nutResult.proteinRdaPerKg} g/kg)'),
                _resultRow('Kebutuhan Cairan (Holliday-Segar)', '${nutResult.fluidMl.round()} mL/hari'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: CheckboxListTile(
            title: const Text('Indikasi Gagal Tumbuh / Stunting / Wasting'),
            subtitle: const Text('Aktifkan perhitungan kalori Catch-Up Growth'),
            value: _isMalnourished,
            onChanged: (v) => setState(() => _isMalnourished = v ?? false),
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
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(color: Colors.teal.shade700),
                      ),
                      icon: Icon(Icons.swap_horiz, size: 16, color: Colors.teal.shade800),
                      label: Text('Tabel Penukar', style: TextStyle(fontSize: 11, color: Colors.teal.shade800, fontWeight: FontWeight.bold)),
                      onPressed: () => _showFoodExchangeDialog(context),
                    ),
                  ],
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
                      label: Text('${item.name} (${item.urt})', style: const TextStyle(fontSize: 11)),
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
                      label: Text('${item.name} (${item.urt})', style: const TextStyle(fontSize: 11)),
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
                      label: Text('${item.name} (${item.urt})', style: const TextStyle(fontSize: 11)),
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
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Daftar 7 Hari
        ...weeklyPlan.map((dayPlan) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                child: Text(dayPlan.dayName.substring(0, 3), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              title: Text(dayPlan.dayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(dayPlan.theme, style: const TextStyle(fontSize: 12, color: Colors.teal)),
              children: dayPlan.sessions.map((s) {
                return ListTile(
                  dense: true,
                  leading: Text(s.time, style: const TextStyle(fontWeight: FontWeight.bold)),
                  title: Text('${s.sessionName}: ${s.menuName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${s.description}\n[Porsi: ${s.portionUrt}]'),
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
            subtitle: Text('Berat: ${item.grams.round()}g | URT: ${item.urt} ${item.notes != null ? "(${item.notes})" : ""}'),
            trailing: Text('${item.calories.round()} Kal', style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPortionTab(PortionGuide guide) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Panduan Porsi Satter (${guide.ageGroupLabel})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Tekstur Makanan: ${guide.textureLabel}', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w600)),
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
      itemCount: recipes.length,
      itemBuilder: (context, i) {
        final r = recipes[i];
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: Colors.teal.shade900)),
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

    await WeeklyMealPlanPdfBuilder.shareWeeklyMealPlanPdf(
      patient: dummyPatient,
      nutResult: nutResult,
      weeklyPlan: weeklyPlan,
      selectedCarb: selectedCarbs.firstOrNull,
      selectedAnimalProtein: selectedAnimalProteins.firstOrNull,
      selectedPlantProtein: selectedPlantProteins.firstOrNull,
      customNote: _noteController.text,
    );
  }
}

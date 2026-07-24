import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../../data/repository.dart';
import 'denver_calculator.dart';
import 'denver_chart_painter.dart';
import 'denver_data.dart';
import 'denver_model.dart';

class DenverScreen extends StatefulWidget {
  final Patient patient;
  final Examination examination;

  const DenverScreen({
    super.key,
    required this.patient,
    required this.examination,
  });

  @override
  State<DenverScreen> createState() => _DenverScreenState();
}

class _DenverScreenState extends State<DenverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ui.Image? _chartImage;
  bool _isLoadingImage = true;

  double _ageInMonths = 0.0;
  bool _usedCorrectedAge = false;

  final Map<String, DenverItemEvaluation> _answers = {};
  bool _isSaving = false;

  late final TextEditingController _behaviorNotesCtrl;
  late final TextEditingController _fearNotesCtrl;
  late final TextEditingController _envResponseCtrl;
  List<double> _previousAgeLines = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _behaviorNotesCtrl = TextEditingController();
    _fearNotesCtrl = TextEditingController();
    _envResponseCtrl = TextEditingController();
    _calculateAge();
    _loadChartImage();
    _loadExistingResult();
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _behaviorNotesCtrl.dispose();
    _fearNotesCtrl.dispose();
    _envResponseCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final repo = Provider.of<AppRepository>(context, listen: false);
    final history = await repo.denverHistory(widget.patient.id);
    final lines = <double>[];
    for (final item in history) {
      if (item.exam.id != widget.examination.id) {
        lines.add(item.denver.ageInMonths);
      }
    }
    if (mounted) {
      setState(() {
        _previousAgeLines = lines;
      });
    }
  }

  void _calculateAge() {
    final res = DenverCalculator.calculateTestAge(
      birthDate: widget.patient.birthDate,
      testDate: widget.examination.examDate,
      isPremature: widget.patient.isPremature,
      gestationalWeeks: widget.patient.gestationalWeeks,
    );
    setState(() {
      _ageInMonths = res['ageInMonths'] as double;
      _usedCorrectedAge = res['usedCorrectedAge'] as bool;
    });
  }

  Future<void> _loadChartImage() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/denver/denver_chart_blank.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo fi = await codec.getNextFrame();
      setState(() {
        _chartImage = fi.image;
        _isLoadingImage = false;
      });
    } catch (e) {
      debugPrint('Error loading denver chart image: $e');
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  Future<void> _loadExistingResult() async {
    final repo = Provider.of<AppRepository>(context, listen: false);
    final existing = await repo.getDenverResultForExamination(widget.examination.id);
    if (existing != null) {
      try {
        final Map<String, dynamic> jsonMap =
            jsonDecode(existing.answersJson) as Map<String, dynamic>;
        setState(() {
          jsonMap.forEach((key, value) {
            switch (value) {
              case 'P':
                _answers[key] = DenverItemEvaluation.pass;
                break;
              case 'F':
                _answers[key] = DenverItemEvaluation.fail;
                break;
              case 'R':
                _answers[key] = DenverItemEvaluation.refusal;
                break;
              case 'NO':
                _answers[key] = DenverItemEvaluation.noOpportunity;
                break;
            }
          });
          _behaviorNotesCtrl.text = existing.behaviorNotes ?? '';
          _fearNotesCtrl.text = existing.fearNotes ?? '';
          _envResponseCtrl.text = existing.environmentResponseNotes ?? '';
        });
      } catch (e) {
        debugPrint('Error loading existing denver result: $e');
      }
    }
  }

  Future<void> _saveResult() async {
    if (_answers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Belum ada item Denver II yang diisi.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final assessment = DenverCalculator.analyze(
      ageInMonths: _ageInMonths,
      usedCorrectedAge: _usedCorrectedAge,
      answers: _answers,
    );

    final Map<String, String> answersJsonMap = {};
    _answers.forEach((key, eval) {
      answersJsonMap[key] = eval.code;
    });

    final repo = Provider.of<AppRepository>(context, listen: false);
    await repo.saveDenverResult(
      examinationId: widget.examination.id,
      patientId: widget.patient.id,
      ageInMonths: _ageInMonths,
      usedCorrectedAge: _usedCorrectedAge,
      cautionsCount: assessment.cautionsCount,
      delaysCount: assessment.delaysCount,
      globalResult: assessment.globalResult.name,
      answersJson: jsonEncode(answersJsonMap),
      behaviorNotes: _behaviorNotesCtrl.text.trim().isEmpty ? null : _behaviorNotesCtrl.text.trim(),
      fearNotes: _fearNotesCtrl.text.trim().isEmpty ? null : _fearNotesCtrl.text.trim(),
      environmentResponseNotes: _envResponseCtrl.text.trim().isEmpty ? null : _envResponseCtrl.text.trim(),
    );

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Hasil Denver II berhasil disimpan (${assessment.globalResult.label}).'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessment = DenverCalculator.analyze(
      ageInMonths: _ageInMonths,
      usedCorrectedAge: _usedCorrectedAge,
      answers: _answers,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skrining Denver II'),
        backgroundColor: const Color(0xFF0148A0),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(icon: Icon(Icons.show_chart), text: 'Grafik Visual'),
            Tab(text: 'Personal Sosial'),
            Tab(text: 'Motorik Halus'),
            Tab(text: 'Bahasa'),
            Tab(text: 'Motorik Kasar'),
            Tab(icon: Icon(Icons.psychology), text: 'Observasi Perilaku'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildPatientInfoHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVisualChartTab(assessment),
                _buildSectorListTab(DenverSector.personalSocial),
                _buildSectorListTab(DenverSector.fineMotorAdaptive),
                _buildSectorListTab(DenverSector.language),
                _buildSectorListTab(DenverSector.grossMotor),
                _buildBehaviorNotesTab(),
              ],
            ),
          ),
          _buildBottomSummaryPanel(assessment),
        ],
      ),
    );
  }

  Widget _buildPatientInfoHeader() {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.child_care, color: Color(0xFF0148A0), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patient.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Usia Uji: ${_ageInMonths.toStringAsFixed(1)} Bulan'
                  '${_usedCorrectedAge ? " (Koreksi Prematur)" : ""}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveResult,
            icon: const Icon(Icons.save, size: 18),
            label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0148A0),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualChartTab(DenverAssessmentResult assessment) {
    if (_isLoadingImage) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.amber.shade50,
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Garis merah menunjukkan usia anak. Geser/zoom diagram untuk melihat posisi item.',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            maxScale: 4.0,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.0 / 1.414, // Proporsi formulir A4 tegak
                child: CustomPaint(
                  painter: DenverChartPainter(
                    image: _chartImage,
                    ageInMonths: _ageInMonths,
                    usedCorrectedAge: _usedCorrectedAge,
                    answers: _answers,
                    previousAgeLines: _previousAgeLines,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectorListTab(DenverSector sector) {
    final allItems = DenverData.getItemsBySector(sector);

    // Sesuai prosedur Denver II:
    // 1. Tampilkan item yang dipotong garis usia (p25 <= usia <= p90) → wajib diuji
    // 2. Tampilkan 3 item di kiri garis (usia > p90) → sudah seharusnya bisa, harus diuji
    // 3. Item di kanan garis (p25 > usia) → tidak wajib, tapi tampilkan s/d 1 item
    //    terdekat kanan jika ada (untuk cek advanced)
    final List<DenverItem> leftItems = allItems
        .where((it) => it.p90 < _ageInMonths)
        .toList()
      ..sort((a, b) => b.p90.compareTo(a.p90));
    final left3 = leftItems.take(3).toList().reversed.toList();

    final crossingItems =
        allItems.where((it) => it.p25 <= _ageInMonths && it.p90 >= _ageInMonths).toList();

    final rightItems = allItems.where((it) => it.p25 > _ageInMonths).toList()
      ..sort((a, b) => a.p25.compareTo(b.p25));
    final right1 = rightItems.take(1).toList();

    final items = [...left3, ...crossingItems, ...right1];

    if (items.isEmpty) {
      return const Center(
        child: Text('Tidak ada item yang relevan untuk usia ini.'),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFFE8F0FE),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Color(0xFF0148A0)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Menampilkan ${items.length} item relevan untuk usia ${_ageInMonths.toStringAsFixed(1)} bulan '
                  '(3 kiri + dipotong garis + 1 kanan)',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF0148A0)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];

        final eval = _answers[item.id];
        final DenverItemStatus? status = eval != null
            ? DenverCalculator.evaluateItemStatus(
                item: item,
                ageInMonths: _ageInMonths,
                evaluation: eval,
              )
            : null;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: status == DenverItemStatus.delayed
                  ? Colors.red.shade300
                  : status == DenverItemStatus.caution
                      ? Colors.orange.shade300
                      : Colors.grey.shade200,
              width: status == DenverItemStatus.delayed || status == DenverItemStatus.caution ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${index + 1}. ${item.title}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (item.reportableByParent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'R (Lapor Ortu)',
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),
                      ),
                  ],
                ),
                if (item.instructions != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.instructions!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Norma: 25% (${item.p25}b) - 50% (${item.p50}b) - 75% (${item.p75}b) - 90% (${item.p90}b)',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    const Spacer(),
                    if (status != null) _buildStatusChip(status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildResponseButton(item.id, DenverItemEvaluation.pass, 'P (Lulus)', Colors.green, eval),
                    _buildResponseButton(item.id, DenverItemEvaluation.fail, 'F (Gagal)', Colors.red, eval),
                    _buildResponseButton(item.id, DenverItemEvaluation.refusal, 'R (Menolak)', Colors.orange, eval),
                    _buildResponseButton(item.id, DenverItemEvaluation.noOpportunity, 'NO (Tak Ada)', Colors.grey, eval),
                  ],
                ),
              ],
            ),
          ),
        );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(DenverItemStatus status) {
    Color bg;
    Color fg;
    switch (status) {
      case DenverItemStatus.advanced:
        bg = Colors.purple.shade100;
        fg = Colors.purple.shade800;
        break;
      case DenverItemStatus.normal:
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
        break;
      case DenverItemStatus.caution:
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade900;
        break;
      case DenverItemStatus.delayed:
        bg = Colors.red.shade100;
        fg = Colors.red.shade900;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  Widget _buildResponseButton(
    String itemId,
    DenverItemEvaluation eval,
    String label,
    Color color,
    DenverItemEvaluation? currentEval,
  ) {
    final bool isSelected = currentEval == eval;

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _answers.remove(itemId);
          } else {
            _answers[itemId] = eval;
          }
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color, width: isSelected ? 2 : 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummaryPanel(DenverAssessmentResult assessment) {
    Color cardBg;
    Color textFg;
    switch (assessment.globalResult) {
      case DenverGlobalResult.normal:
        cardBg = Colors.green.shade50;
        textFg = Colors.green.shade900;
        break;
      case DenverGlobalResult.suspect:
        cardBg = Colors.red.shade50;
        textFg = Colors.red.shade900;
        break;
      case DenverGlobalResult.untestable:
        cardBg = Colors.orange.shade50;
        textFg = Colors.orange.shade900;
        break;
    }

    return Container(
      color: cardBg,
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KESIMPULAN: ${assessment.globalResult.label}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textFg,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Caution (Peringatan): ${assessment.cautionsCount}  |  Delay (Keterlambatan): ${assessment.delaysCount}',
                    style: TextStyle(fontSize: 11, color: textFg),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Observasi Perilaku Khusus Saat Pengujian',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0148A0),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Catat respon dan perilaku anak selama pemeriksaan Denver II (opsional).',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _behaviorNotesCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Perilaku Khusus / Menonjol',
              hintText: 'Contoh: Hiperaktif, sulit konsentrasi, kooperatif',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_search),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fearNotesCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Ketakutan / Kecemasan',
              hintText: 'Contoh: Takut dokter/orang asing, cemas',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sentiment_very_dissatisfied),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _envResponseCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Respon Terhadap Sekeliling',
              hintText: 'Contoh: Responsif terhadap suara, kontak mata baik',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.visibility),
            ),
          ),
        ],
      ),
    );
  }
}

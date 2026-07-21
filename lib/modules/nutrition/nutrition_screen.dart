import 'package:flutter/material.dart';
import '../growth/nutrition_classifier.dart';
import 'nutrition_calculator.dart';
import 'nutrition_data.dart';

/// Layar detail Pemenuhan Nutrisi (Asuhan Nutrisi Pediatrik).
class NutritionScreen extends StatelessWidget {
  final NutritionRequirement requirement;
  final int ageMonths;
  final double weightKg;
  final double heightCm;
  final String patientName;

  const NutritionScreen({
    super.key,
    required this.requirement,
    required this.ageMonths,
    required this.weightKg,
    required this.heightCm,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Asuhan Nutrisi Pediatrik',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Pasien
          _buildPatientHeader(),
          const SizedBox(height: 16),

          // 1. Kebutuhan Nutrisi Harian
          _buildNutritionSummary(),
          const SizedBox(height: 16),

          // 2. Status Gizi & Intervensi
          _buildStatusCard(),
          const SizedBox(height: 16),

          // 3. Panduan MPASI
          _buildMpasiCard(),
          const SizedBox(height: 16),

          // 4. Basic Feeding Rules IDAI
          _buildFeedingRulesCard(),
          const SizedBox(height: 16),

          // 5. Suplementasi
          _buildSupplementCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade700, Colors.orange.shade400],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.restaurant, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Usia: ${(ageMonths / 12.0).toStringAsFixed(1)} tahun ($ageMonths bulan) '
                  '| BB: ${weightKg.toStringAsFixed(1)} kg '
                  '| TB: ${heightCm.toStringAsFixed(1)} cm',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    final r = requirement;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, color: Colors.orange.shade800),
                const SizedBox(width: 8),
                Text(
                  'Kebutuhan Nutrisi Harian',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Berdasarkan RDA (Permenkes RI No. 28/2019) × BB Ideal',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            _kvRow(Icons.local_fire_department, 'Energi Target',
                r.energyLabel, Colors.red.shade700),
            _kvRow(Icons.egg, 'Protein Target',
                r.proteinLabel, Colors.brown.shade700),
            _kvRow(Icons.water_drop, 'Cairan Harian (Holliday-Segar)',
                r.fluidLabel, Colors.blue.shade700),
            const Divider(height: 16),
            _kvRow(Icons.monitor_weight, 'BB Ideal (W_ideal)',
                r.idealWeightLabel, Colors.teal.shade700),
            _kvRow(Icons.access_time, 'Height Age',
                '${r.heightAgeMonths.toStringAsFixed(1)} bulan '
                '(${(r.heightAgeMonths / 12.0).toStringAsFixed(1)} tahun)',
                Colors.purple.shade700),
            _kvRow(Icons.table_chart, 'Kelompok AKG',
                r.akgEntry.label, Colors.indigo.shade700),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Text(
                'Catatan: Kebutuhan dihitung berdasarkan BB Ideal '
                '(${r.idealWeightLabel}) pada Height Age '
                '(${(r.heightAgeMonths / 12.0).toStringAsFixed(1)} thn), '
                'bukan BB aktual (${weightKg.toStringAsFixed(1)} kg).',
                style: TextStyle(fontSize: 10, color: Colors.amber.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kvRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final r = requirement;
    final statusColor = r.needsIntervention
        ? Colors.red
        : (r.nutritionStatus == NutritionStatus.overweight ||
                r.nutritionStatus == NutritionStatus.obese)
            ? Colors.orange
            : Colors.green;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  r.needsIntervention
                      ? Icons.warning_amber
                      : Icons.check_circle,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status Gizi & Intervensi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: statusColor.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (r.waterlowPercentage != null)
              Text(
                'Waterlow: ${r.waterlowPercentage!.toStringAsFixed(1)}% '
                '(BB aktual / BB ideal × 100)',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.shade300),
              ),
              child: Text(
                r.interventionAdvice,
                style: TextStyle(
                  fontSize: 11,
                  color: statusColor.shade900,
                  fontWeight: r.needsIntervention
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMpasiCard() {
    final g = requirement.mpasiGuidance;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.baby_changing_station,
                    color: Colors.green.shade800),
                const SizedBox(width: 8),
                Text(
                  'Panduan Pemberian Makan (${g.label})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Tekstur', g.texture),
            _infoRow('Frekuensi', g.frequency),
            _infoRow('Porsi', g.portion),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                g.notes,
                style: TextStyle(fontSize: 11, color: Colors.green.shade900),
              ),
            ),
            if (g.menuExamples.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Contoh Ide Resep MPASI (Kemenkes RI 2023):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 6),
              ...g.menuExamples.map((recipe) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.restaurant_menu, size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            recipe,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingRulesCard() {
    // Group by category
    final categories = <String, List<FeedingRule>>{};
    for (final r in feedingRules) {
      categories.putIfAbsent(r.category, () => []).add(r);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.rule, color: Colors.indigo.shade800),
          title: Text(
            'Basic Feeding Rules IDAI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.indigo.shade900,
            ),
          ),
          subtitle: const Text(
            '10 Aturan Dasar Makan Anak',
            style: TextStyle(fontSize: 11),
          ),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          children: categories.entries.map((e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    e.key.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.indigo.shade700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ...e.value.map((rule) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${rule.number}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rule.title,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rule.description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSupplementCard() {
    final r = requirement;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medication, color: Colors.purple.shade800),
                const SizedBox(width: 8),
                Text(
                  'Rekomendasi Suplementasi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.purple.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Berdasarkan Rekomendasi IDAI',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            _supplementTile(r.ironSupp, Colors.red.shade700),
            const SizedBox(height: 8),
            _supplementTile(r.vitDSupp, Colors.amber.shade800),
          ],
        ),
      ),
    );
  }

  Widget _supplementTile(SupplementGuidance supp, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            supp.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          _infoRow('Dosis', supp.dose),
          _infoRow('Indikasi', supp.indication),
          _infoRow('Durasi', supp.duration),
          const SizedBox(height: 4),
          Text(
            supp.notes,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

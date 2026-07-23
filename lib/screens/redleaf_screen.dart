import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/redleaf/redleaf_data.dart';
import '../modules/redleaf/redleaf_model.dart';
import '../reports/pdf_report_service.dart';

/// Layar interaktif Redleaf Milestones Checklist.
class RedleafScreen extends StatefulWidget {
  final String examinationId;
  final int? ageMonths;

  const RedleafScreen({
    super.key,
    required this.examinationId,
    this.ageMonths,
  });

  @override
  State<RedleafScreen> createState() => _RedleafScreenState();
}

class _RedleafScreenState extends State<RedleafScreen>
    with SingleTickerProviderStateMixin {
  late RedleafAgeGroup _selectedAgeGroup;
  late TabController _tabController;

  final Map<String, bool> _checkedItems = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final initialAge = widget.ageMonths ?? 48;
    _selectedAgeGroup = getRedleafAgeGroupForAge(initialAge);
    _initTabController();
    _loadExisting();
  }

  void _initTabController() {
    _tabController = TabController(
      length: _selectedAgeGroup.domains.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    final repo = context.read<AppRepository>();
    final existing = await repo.getScreening(widget.examinationId, 'redleaf');

    if (existing != null && mounted) {
      try {
        final m = jsonDecode(existing.answersJson) as Map<String, dynamic>;
        setState(() {
          m.forEach((k, v) {
            if (v is bool) {
              _checkedItems[k] = v;
            }
          });
          if (existing.variantLabel != null) {
            final found = redleafAgeGroups.firstWhere(
              (g) => g.id == existing.variantLabel,
              orElse: () => _selectedAgeGroup,
            );
            if (found.id != _selectedAgeGroup.id) {
              _selectedAgeGroup = found;
              _tabController.dispose();
              _initTabController();
            }
          }
        });
      } catch (_) {}
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  void _onAgeGroupChanged(RedleafAgeGroup group) {
    if (group.id == _selectedAgeGroup.id) return;
    setState(() {
      _selectedAgeGroup = group;
      _tabController.dispose();
      _initTabController();
    });
  }

  String _getItemKey(String domainId, int number) {
    return '${_selectedAgeGroup.id}_${domainId}_$number';
  }

  /// Filter items sesuai usia anak (window sub-usia 0–12 bln, bukan kumulatif).
  List<RedleafItem> _filteredItems(RedleafDomain domain) {
    return filterRedleafItemsForAge(domain.items, widget.ageMonths);
  }

  int get _totalItemsInCurrentGroup {
    int total = 0;
    for (final d in _selectedAgeGroup.domains) {
      total += _filteredItems(d).length;
    }
    return total;
  }

  int get _checkedItemsInCurrentGroup {
    int count = 0;
    for (final d in _selectedAgeGroup.domains) {
      for (final item in _filteredItems(d)) {
        final key = _getItemKey(d.id, item.number);
        if (_checkedItems[key] == true) {
          count++;
        }
      }
    }
    return count;
  }

  Future<void> _save() async {
    final repo = context.read<AppRepository>();
    final checkedCount = _checkedItemsInCurrentGroup;
    final totalCount = _totalItemsInCurrentGroup;

    final percentage = totalCount > 0 ? (checkedCount / totalCount) * 100 : 100;
    int riskLevel = 0;
    if (percentage < 50) {
      riskLevel = 2;
    } else if (percentage < 75) {
      riskLevel = 1;
    }

    final entry = ScreeningResultsCompanion(
      examinationId: Value(widget.examinationId),
      instrumentId: const Value('redleaf'),
      score: Value(checkedCount),
      totalItems: Value(totalCount),
      riskLevel: Value(riskLevel),
      answersJson: Value(jsonEncode(_checkedItems)),
      variantLabel: Value(_selectedAgeGroup.id),
    );

    await repo.upsertScreening(entry);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Checklist Redleaf berhasil disimpan ($checkedCount/$totalCount milestone tercapai)'),
          backgroundColor: Colors.teal.shade700,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _printStimulation() async {
    final repo = context.read<AppRepository>();
    final exam = await repo.getExamination(widget.examinationId);
    if (exam != null) {
      final patient = await repo.getPatient(exam.patientId);
      if (patient != null) {
        await PdfReportService.generateAndPrintRedleafStimulation(
          patient: patient,
          ageGroup: _selectedAgeGroup,
          checkedItems: _checkedItems,
          examDate: exam.examDate,
          childAgeMonths: widget.ageMonths,
          context: context,
        );
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Data pasien tidak ditemukan untuk cetak stimulasi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redleaf Milestones Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Cetak Panduan Stimulasi Ortu',
            onPressed: _printStimulation,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ageMonths != null
                          ? 'Usia anak: ${widget.ageMonths} bln · ${_selectedAgeGroup.name}'
                          : 'Kelompok Usia: ${_selectedAgeGroup.name}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tercapai: $_checkedItemsInCurrentGroup / $_totalItemsInCurrentGroup Milestone',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Simpan'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Age Group Selector Chips
                Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: redleafAgeGroups.map((group) {
                        final isSelected = group.id == _selectedAgeGroup.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(
                              group.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            onSelected: (_) => _onAgeGroupChanged(group),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Domain Tabs
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: _selectedAgeGroup.domains.map((d) {
                      return Tab(text: d.name);
                    }).toList(),
                  ),
                ),

                const Divider(height: 1),

                // Milestone Cards List
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _selectedAgeGroup.domains.map((domain) {
                      final items = _filteredItems(domain);
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            'Tidak ada indikator milestone untuk domain ini pada usia yang dipilih.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final key = _getItemKey(domain.id, item.number);
                          final isChecked = _checkedItems[key] ?? false;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: isChecked ? 2 : 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isChecked
                                    ? Colors.teal.shade400
                                    : Colors.grey.shade300,
                                width: isChecked ? 1.5 : 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Checkbox and Bold Title
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _checkedItems[key] = !isChecked;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: isChecked,
                                          activeColor: Colors.teal.shade700,
                                          onChanged: (val) {
                                            setState(() {
                                              _checkedItems[key] = val ?? false;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              '${item.number}. ${item.title}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: isChecked
                                                    ? Colors.teal.shade800
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 16),

                                  // 2. Target Section
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade800,
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Target: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          TextSpan(text: item.target),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // 3. Yang dapat dilakukan orang tua / pengasuh
                                  if (item.parentTips.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        'Yang dapat dilakukan orang tua / pengasuh:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ...item.parentTips.map((tip) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 3, bottom: 3),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.teal)),
                                            Expanded(
                                              child: Text(
                                                tip,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade700,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

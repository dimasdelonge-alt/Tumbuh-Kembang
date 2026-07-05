// Model data untuk Redleaf Milestones Checklist.

class RedleafItem {
  final int number;
  final String title;
  final String target;
  final List<String> parentTips;

  /// Sub-usia dalam bulan (opsional, digunakan untuk filter di dalam age group).
  final int? minMonth;
  final int? maxMonth;

  const RedleafItem({
    required this.number,
    required this.title,
    required this.target,
    required this.parentTips,
    this.minMonth,
    this.maxMonth,
  });
}

class RedleafDomain {
  final String id;
  final String name;
  final List<RedleafItem> items;

  const RedleafDomain({
    required this.id,
    required this.name,
    required this.items,
  });
}

class RedleafAgeGroup {
  final String id;
  final String name;
  final int minAgeMonths;
  final int maxAgeMonths;
  final List<RedleafDomain> domains;

  const RedleafAgeGroup({
    required this.id,
    required this.name,
    required this.minAgeMonths,
    required this.maxAgeMonths,
    required this.domains,
  });
}

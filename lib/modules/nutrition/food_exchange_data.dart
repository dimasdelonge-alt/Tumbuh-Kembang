/// Model Bahan Makanan Penukar.
class FoodExchangeItem {
  final String name;
  final String group; // 'Karbohidrat' | 'Protein Hewani Rendah Lemak' | 'Protein Hewani Sedang Lemak' | 'Protein Hewani Tinggi Lemak' | 'Protein Nabati' | 'Sayuran'
  final double grams;
  final String urt; // Ukuran Rumah Tangga (mis. "3/4 gelas", "1 ptg sedang", "2 sdm")
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final String? notes; // mis. "Na+", "Ko+", "Pr+", "S+"

  const FoodExchangeItem({
    required this.name,
    required this.group,
    required this.grams,
    required this.urt,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.notes,
  });
}

/// Master Data Bahan Makanan Penukar (Daftar Penukar Ahli Gizi / Kemenkes).
class FoodExchangeRepository {
  // GOLONGAN I: KARBOHIDRAT (1 Satuan = 175 Kal, 4g Protein, 40g Karbohidrat)
  static const List<FoodExchangeItem> carbsList = [
    FoodExchangeItem(name: 'Nasi Beras Giling', group: 'Karbohidrat', grams: 100, urt: '3/4 gelas', calories: 175, protein: 4, fat: 0, carbs: 40),
    FoodExchangeItem(name: 'Kentang', group: 'Karbohidrat', grams: 210, urt: '2 buah besar', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'K+'),
    FoodExchangeItem(name: 'Roti Putih', group: 'Karbohidrat', grams: 70, urt: '3 iris', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'Na+'),
    FoodExchangeItem(name: 'Singkong', group: 'Karbohidrat', grams: 120, urt: '1 1/2 potong', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'S+'),
    FoodExchangeItem(name: 'Ubi Jalar Kuning', group: 'Karbohidrat', grams: 135, urt: '1 biji sedang', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'S++'),
    FoodExchangeItem(name: 'Makaroni', group: 'Karbohidrat', grams: 50, urt: '1/2 gelas', calories: 175, protein: 4, fat: 0, carbs: 40),
    FoodExchangeItem(name: 'Bihun', group: 'Karbohidrat', grams: 50, urt: '1/2 gelas', calories: 175, protein: 4, fat: 0, carbs: 40),
    FoodExchangeItem(name: 'Mie Basah', group: 'Karbohidrat', grams: 200, urt: '2 gelas', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'Na+'),
    FoodExchangeItem(name: 'Tepung Beras', group: 'Karbohidrat', grams: 50, urt: '8 sdm', calories: 175, protein: 4, fat: 0, carbs: 40),
    FoodExchangeItem(name: 'Tepung Tapioka / Sagu', group: 'Karbohidrat', grams: 50, urt: '8 sdm', calories: 175, protein: 4, fat: 0, carbs: 40),
    FoodExchangeItem(name: 'Biskuit', group: 'Karbohidrat', grams: 40, urt: '4 buah besar', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'Na+'),
    FoodExchangeItem(name: 'Jagung Segar', group: 'Karbohidrat', grams: 125, urt: '3 biji sedang', calories: 175, protein: 4, fat: 0, carbs: 40, notes: 'S++'),
  ];

  // GOLONGAN II-A: PROTEIN HEWANI RENDAH LEMAK (1 Satuan = 50 Kal, 7g Protein, 2g Lemak)
  static const List<FoodExchangeItem> animalProteinLowFat = [
    FoodExchangeItem(name: 'Daging Ayam tanpa Kulit', group: 'Protein Hewani Rendah Lemak', grams: 40, urt: '1 ptg sedang', calories: 50, protein: 7, fat: 2, carbs: 0),
    FoodExchangeItem(name: 'Ikan Segar (Kembung/Mas/Kakap)', group: 'Protein Hewani Rendah Lemak', grams: 40, urt: '1 ptg sedang', calories: 50, protein: 7, fat: 2, carbs: 0),
    FoodExchangeItem(name: 'Ikan Lele', group: 'Protein Hewani Rendah Lemak', grams: 40, urt: '1/2 ekor sedang', calories: 50, protein: 7, fat: 2, carbs: 0),
    FoodExchangeItem(name: 'Putih Telur Ayam', group: 'Protein Hewani Rendah Lemak', grams: 65, urt: '2 1/2 butir', calories: 50, protein: 7, fat: 2, carbs: 0),
    FoodExchangeItem(name: 'Udang Segar', group: 'Protein Hewani Rendah Lemak', grams: 35, urt: '5 ekor sedang', calories: 50, protein: 7, fat: 2, carbs: 0, notes: 'Ko+'),
    FoodExchangeItem(name: 'Cumi-cumi', group: 'Protein Hewani Rendah Lemak', grams: 45, urt: '1 ekor kecil', calories: 50, protein: 7, fat: 2, carbs: 0),
    FoodExchangeItem(name: 'Daging Asap', group: 'Protein Hewani Rendah Lemak', grams: 20, urt: '1 lembar', calories: 50, protein: 7, fat: 2, carbs: 0),
  ];

  // GOLONGAN II-B: PROTEIN HEWANI SEDANG LEMAK (1 Satuan = 75 Kal, 7g Protein, 5g Lemak)
  static const List<FoodExchangeItem> animalProteinMedFat = [
    FoodExchangeItem(name: 'Telur Ayam', group: 'Protein Hewani Sedang Lemak', grams: 25, urt: '1 butir', calories: 75, protein: 7, fat: 5, carbs: 0),
    FoodExchangeItem(name: 'Hati Ayam', group: 'Protein Hewani Sedang Lemak', grams: 75, urt: '1 ptg sedang', calories: 75, protein: 7, fat: 5, carbs: 0, notes: 'Pr+'),
    FoodExchangeItem(name: 'Daging Sapi', group: 'Protein Hewani Sedang Lemak', grams: 60, urt: '1 ptg sedang', calories: 75, protein: 7, fat: 5, carbs: 0, notes: 'Ko+'),
    FoodExchangeItem(name: 'Telur Puyuh', group: 'Protein Hewani Sedang Lemak', grams: 30, urt: '5 butir', calories: 75, protein: 7, fat: 5, carbs: 0),
    FoodExchangeItem(name: 'Bakso Daging', group: 'Protein Hewani Sedang Lemak', grams: 50, urt: '10 biji sedang', calories: 75, protein: 7, fat: 5, carbs: 0),
    FoodExchangeItem(name: 'Hati Sapi', group: 'Protein Hewani Sedang Lemak', grams: 60, urt: '1 ptg sedang', calories: 75, protein: 7, fat: 5, carbs: 0, notes: 'Ko+, Pr+'),
    FoodExchangeItem(name: 'Daging Kambing', group: 'Protein Hewani Sedang Lemak', grams: 50, urt: '1 ptg sedang', calories: 75, protein: 7, fat: 5, carbs: 0),
  ];

  // GOLONGAN II-C: PROTEIN HEWANI TINGGI LEMAK (1 Satuan = 150 Kal, 7g Protein, 13g Lemak)
  static const List<FoodExchangeItem> animalProteinHighFat = [
    FoodExchangeItem(name: 'Daging Ayam dengan Kulit', group: 'Protein Hewani Tinggi Lemak', grams: 40, urt: '1 ptg sedang', calories: 150, protein: 7, fat: 13, carbs: 0, notes: 'Ko+'),
    FoodExchangeItem(name: 'Bebek', group: 'Protein Hewani Tinggi Lemak', grams: 45, urt: '1 ptg sedang', calories: 150, protein: 7, fat: 13, carbs: 0, notes: 'Pr+'),
    FoodExchangeItem(name: 'Telur Bebek', group: 'Protein Hewani Tinggi Lemak', grams: 55, urt: '1 butir', calories: 150, protein: 7, fat: 13, carbs: 0, notes: 'Ko+'),
    FoodExchangeItem(name: 'Sosis', group: 'Protein Hewani Tinggi Lemak', grams: 50, urt: '1/2 potong', calories: 150, protein: 7, fat: 13, carbs: 0, notes: 'Na++'),
    FoodExchangeItem(name: 'Corned Beef', group: 'Protein Hewani Tinggi Lemak', grams: 45, urt: '3 sdm', calories: 150, protein: 7, fat: 13, carbs: 0, notes: 'Na+'),
  ];

  // GOLONGAN III: PROTEIN NABATI (1 Satuan = 75 Kal, 5g Protein, 3g Lemak, 7g Karbohidrat)
  static const List<FoodExchangeItem> plantProteinList = [
    FoodExchangeItem(name: 'Tempe', group: 'Protein Nabati', grams: 50, urt: '2 ptg sedang', calories: 75, protein: 5, fat: 3, carbs: 7, notes: 'S+'),
    FoodExchangeItem(name: 'Tahu', group: 'Protein Nabati', grams: 110, urt: '1 biji besar', calories: 75, protein: 5, fat: 3, carbs: 7),
    FoodExchangeItem(name: 'Kacang Hijau', group: 'Protein Nabati', grams: 20, urt: '2 sdm', calories: 75, protein: 5, fat: 3, carbs: 7, notes: 'S++'),
    FoodExchangeItem(name: 'Kacang Kedelai', group: 'Protein Nabati', grams: 25, urt: '2 1/2 sdm', calories: 75, protein: 5, fat: 3, carbs: 7, notes: 'S+'),
    FoodExchangeItem(name: 'Kacang Merah', group: 'Protein Nabati', grams: 20, urt: '2 sdm', calories: 75, protein: 5, fat: 3, carbs: 7, notes: 'S+'),
    FoodExchangeItem(name: 'Oncom', group: 'Protein Nabati', grams: 40, urt: '2 ptg kecil', calories: 75, protein: 5, fat: 3, carbs: 7, notes: 'S++'),
    FoodExchangeItem(name: 'Kacang Tanah', group: 'Protein Nabati', grams: 15, urt: '2 sdm', calories: 75, protein: 5, fat: 3, carbs: 7),
  ];

  // GOLONGAN IV: SAYURAN A (Kalori Sangat Rendah)
  static const List<String> veggiesFree = [
    'Bayam', 'Gambas (Oyong)', 'Ketimun', 'Tomat', 'Labu Air', 'Slada', 'Lobak', 'Jamur Kuping', 'Baligo'
  ];

  /// Mengambil gabungan seluruh Protein Hewani.
  static List<FoodExchangeItem> get allAnimalProtein => [
        ...animalProteinLowFat,
        ...animalProteinMedFat,
        ...animalProteinHighFat,
      ];
}

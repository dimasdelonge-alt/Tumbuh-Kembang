# RECAP — Aplikasi Skrining Tumbuh Kembang Anak

Dokumen ini ringkasan lengkap proyek agar sesi chat baru langsung punya konteks penuh tanpa kehilangan riwayat. Baca ini dulu sebelum melanjutkan.

## Konteks proyek
- Aplikasi dipesan seorang **dokter spesialis anak** untuk skrining tumbuh kembang anak. Dokter mengirim PRD lengkap + folder materi PDF.
- **Prinsip yang dipegang ketat:** data medis SELALU dari sumber terverifikasi (tabel WHO resmi, PDF Kemenkes/dokter). TIDAK PERNAH mengarang koefisien, norma, atau konten klinis. Bila data tak tersedia/terverifikasi, fitur ditunda dan ditanyakan ke dokter — bukan ditebak.

## Stack teknis
- **Flutter** (Android utama, Web sekunder), offline-first.
- **drift** (SQLite, jalan di Android & Web) — DB lokal.
- **provider** (state), **fl_chart** (grafik), **pdf** + **printing** (laporan).
- **firebase_core** + **cloud_firestore** — sinkronisasi cloud real-time.
- Package name: `tumbang`. Target awal: Android (APK debug sukses dibuild).
- **Web hosting:** GitHub Pages → `https://dimasdelonge-alt.github.io/Tumbuh-Kembang/`
  - Build: `flutter build web --pwa-strategy none --base-href "/Tumbuh-Kembang/"`
  - Deploy: init git di `build/web/`, force push ke branch `gh-pages`.
- **Catatan build penting:** `path_provider_foundation` di-pin ke **2.4.4** di `dependency_overrides` (pubspec.yaml). Versi >=2.5.0 menarik `objective_c` yang punya native build hook & membuat `build_runner` gagal. Jangan naikkan.
- **Catatan web penting:** `SharedPreferences` TIDAK boleh dipakai langsung di web (plugin registration gagal → `MissingPluginException`). Gunakan `ConfigStorage` (`lib/utils/config_storage.dart`) yang pakai conditional import: `window.localStorage` di web, `SharedPreferences` di mobile.
- Codegen drift: `dart run build_runner build`. Setelah ubah skema DB, regen.

## Lokasi materi dokter (sumber data)
`C:\Users\Administrator\Downloads\Compressed\screening`
- Folder klaster usia (Neonatal, Bayi-Balita, Usia Sekolah, Remaja) + file di root.
- File kunci: `BUKU PEDOMAN SDIDTK revisi 28032022 (1) (2) - Copy.pdf` (root), KPSP, M-CHAT, KMME, TDD/TDL, GPPH, CARS (+interpretasi), Denver II, SPPAHI, Fenton 2013, CDC 2000.
- Ekstraksi PDF: pakai Python `pypdf`, skrip di `C:\Users\ADMINI~1\AppData\Local\Temp\kilo\extract_pdf.py`.

## Verifikasi terkini
- `flutter analyze`: 0 error, 0 warning.
- **110 unit test lolos** (`flutter test`).
- `flutter build apk --debug`: sukses. Skema DB versi **7**.
- Versi aplikasi: **12.0.0+12**.

---

## FITUR YANG SUDAH JADI & TERUJI

### Inti
- **Database pasien** (Modul 1): tambah/edit/cari; riwayat prematur, usia gestasi, Down syndrome, TB Ayah/Ibu. (`patient_form_screen.dart`, `dashboard_screen.dart`). Mendukung pencatatan data awal lahir (BB/TB/LK Lahir) yang langsung ter-plot sebagai baseline 0-bulan pada grafik pertumbuhan.
- **Sesi Skrining Cepat (Anonim)**: Tab "Skrining Cepat" di dashboard untuk melangsungkan skrining instan tanpa pendaftaran formal (disimpan sebagai pasien anonim dengan kode rekam medis `'ANONIM'`).
- **Backup & Restore Manual (JSON)**: Menu pengaturan untuk mengekspor database lokal menjadi satu file cadangan `.json` (diunduh langsung di Web; dibagikan via sharing panel di Mobile) dan mengimpornya kembali dengan validasi format dan transaksi aman. (`backup_service.dart`, `file_helper.dart`, `settings_screen.dart`)
- **Sinkronisasi Cloud Firebase (Modul Sync)**: Real-time bi-directional sync antara perangkat perawat & dokter via Firestore. (`services/sync_service.dart`, `settings_screen.dart`)
- **Age engine** (Modul 2): usia kronologis + **usia koreksi prematur** otomatis (berhenti di 24 bulan; aterm >=37 mgg tak dikoreksi). (`core/age_calculator.dart`)
- **Pemeriksaan/kunjungan** (Modul 14 dasar): hub per kunjungan (`examination_screen.dart`), riwayat di `patient_detail_screen.dart`.
- **Identitas Dokter & Tanda Tangan Digital (Auto QR Code Barcode)**: Menu pengaturan identitas dokter (Nama & No. SIP) dengan format pengesahan QR Code verifikasi digital otomatis atau upload gambar tanda tangan basah custom. (`settings_screen.dart`, `reports/pdf_report_service.dart`)

### Pertumbuhan (Modul 3) — `modules/growth/`
- Z-score metode LMS: BB/U, TB/U, BB/TB, IMT/U, LK/U. (`zscore_calculator.dart`)
- Data WHO asli sebagai aset JSON di `assets/who/` (LMS, dalam bulan):
  - 0–5 thn dari paket `pygrowup` (turunan WHO resmi).
  - **5–19 thn (WHO 2007 / AnthroPlus)** untuk TB/U & IMT/U dari paket `zscorer` (`wgsrData.csv`).
- **Klasifikasi status gizi age-aware** (`nutrition_classifier.dart`): ambang IMT/U beda untuk 0–5 thn vs >5 thn WHO 2007.
- `growth_assessment.dart` = SATU sumber kebenaran pipeline usia→ageDays→Z-score→status.
- **UX Form Pertumbuhan (`growth_screen.dart`)**: Menghapus `Navigator.pop()` otomatis saat tombol "Simpan Pengukuran & TPG" ditekan agar layar tetap terbuka dan pengguna bisa langsung meninjau Z-score, kurva CDC 2000, atau detail asuhan nutrisi.

### Asuhan Nutrisi Pediatrik / Pemenuhan Nutrisi — `modules/nutrition/`
- **Kebutuhan Nutrisi Target**: Energi & Protein harian ($\text{RDA} \times W_{ideal}$) mengacu pada **Permenkes RI No. 28/2019 (AKG)**. Status BB/TB diselaraskan secara konsisten dengan standar WHO/Kemenkes RI.
- **Kebutuhan Cairan Harian**: Perhitungan otomatis dengan rumus **Holliday-Segar** ($100\text{ ml/kg}$ 10 kg pertama, $+50\text{ ml/kg}$ 10 kg kedua, $+20\text{ ml/kg}$ sisanya).
- **Edukasi Pemberian Makan & MPASI**: Panduan tekstur, frekuensi, dan porsi per usia serta **Contoh Ide Resep MPASI Kaya Protein Hewani (Buku Resep Lokal Kemenkes RI 2023)** dan **Basic Feeding Rules IDAI** (10 aturan dasar makan).
- **Rekomendasi Suplementasi**: Dosis otomatis **Zat Besi (Fe)** (2 mg/kgBB/hari) & **Vitamin D** (400–600 IU/hari) sesuai acuan IDAI.
- **Alert Intervensi Gizi**: Panduan penanganan medis/rujukan untuk kondisi Gizi Kurang atau Gizi Buruk (Waterlow/WHO).
- **Integrasi UI & PDF**: Kartu ringkasan di `growth_screen.dart`, layar detail `nutrition_screen.dart`, dan cetakan Laporan PDF (`pdf_report_service.dart`).
- **Sanitasi Font PDF**: Modul cetak PDF dilengkapi Unicode sanitizer (`_clean` helper) untuk mengeliminasi karakter non-ASCII (`–`, `—`, `•`, `≥`, `≤`) agar tidak terjadi glitch kotak ber-tanda X pada engine font Helvetica bawaan.

### KPSP (Modul 4) — `modules/kpsp/`
- 16 form usia (3–72 bln) lengkap, skoring (9–10 Sesuai, 7–8 Meragukan, <=6 Penyimpangan), analisis domain. (`kpsp_data.dart`, `kpsp_model.dart`, `kpsp_screen.dart`)

### Estimasi Usia Perkembangan (Modul 5) — `modules/kpsp/`
- `developmental_age.dart`: metode batas-bawah — usia form tertinggi di mana semua item satu domain "Ya". Disclaimer tampil (bukan diagnosis formal).
- `developmental_age_service.dart`: helper bersama untuk analisis usia perkembangan.

### Smart Stimulation (Modul 6/9) — `modules/stimulation/`
- Database stimulasi dari **SDIDTK revisi 2022** (Tabel 3.7), 10 kelompok umur × 4 bidang. (`stimulation_data.dart`)
- Matching berbasis **jawaban KPSP aktual per domain**.

### Instrumen skrining generik — `modules/screening/`
- **KMME** (mental emosional, 12 item) — `data/kmme_data.dart`
- **TDD** (tes daya dengar, per kelompok usia) — `data/tdd_data.dart`
- **M-CHAT-R** (autisme, 20 item, item 2/5/12 terbalik) — `data/mchat_data.dart`
- **M-CHAT-R/F Follow-Up (Wawancara Tahap 2)**: Alur wawancara interaktif 20 panduan pertanyaan resmi Indonesia (`mchat_followup_data.dart`, `mchat_followup_screen.dart`).
- **GPPH** (Abbreviated Conners, 10 item skala 0–3, ambang >=13) — `data/gpph_data.dart`
- **SPPAHI** (35 item skala 0–3, cut-off per penilai: Dokter >=22 / Ortu >=30 / Guru >=29) — `data/sppahi_data.dart`

### TDL (tes daya lihat) — `modules/vision/tdl.dart`
- Form catat baris poster "E" per mata (poster fisik tetap dipakai).

### CARS (autisme) — `modules/autism/cars.dart`
- 15 area, skala 1–4 step 0,5; <30 non-autistik, 30–36,5 ringan-sedang, >=37 berat.

### Denver II (Skrining Perkembangan) — `modules/denver/`
- 120 item 4 sektor. Kanvas visualisasi diagram batang `denver_chart_blank.png` dengan **Garis Usia Vertikal** otomatis.
- Clinical calculation engine (`denver_calculator.dart`), proteksi hak cipta (`utils/denver_license.dart`), integrasi Tab Hasil Pemeriksaan & PDF.

### Fenton 2013 Preterm Growth Chart — `modules/fenton/`
- Kurva pertumbuhan khusus bayi prematur (22–50 minggu gestasi PMA).
- Gambar resmi Fenton 2013 Laki-laki (`fenton_boys.jpg`) & Perempuan (`fenton_girls.jpg`).
- **Kanvas Interaktif & Tren Longitudinal**: Menggambar garis vertikal usia PMA merah, memplot titik BB, PB, LK, serta menghubungkan garis kurva pertumbuhan antar-kunjungan.
- **Render PDF**: Gambar kurva Fenton resolusi tinggi beserta titik & garis tren otomatis masuk ke cetakan PDF.

### Kurva CDC 2000 & Tinggi Potensi Genetik (TPG) — `modules/cdc/`
- Kurva pertumbuhan tinggi & berat badan CDC 2000 untuk anak usia 2–20 tahun (`cdc_boys.jpg` & `cdc_girls.jpg`).
- **Kalkulator TPG (`cdc_calculator.dart`)**:
  - Anak Laki-Laki: `((TB Ibu + 13) + TB Ayah) / 2` $\pm 8.5\text{ cm}$
  - Anak Perempuan: `((TB Ayah - 13) + TB Ibu) / 2` $\pm 8.5\text{ cm}$
  - Evaluasi real-time TPG dikhususkan untuk usia 2–20 tahun (anak < 2 tahun menampilkan pesan informatif bahwa CDC berlaku mulai 2 tahun).
- **Plotting Ganda Interaktif & Presisi Tinggi (`cdc_chart_painter.dart`, `cdc_screen.dart`)**:
  - **Tinggi Badan (Stature-for-Age)**: Diplot di kurva atas dengan titik/garis **Biru Tua** (`115.0 cm`).
  - **Berat Badan (Weight-for-Age)**: Diplot di kurva bawah dengan titik/garis **Oranye** (`15.0 kg`). Pemetaan skala Y bawah menggunakan rumus *piecewise grid-matched* (10–35 kg & 35–105 kg) yang 100% sejajar dengan angka grid poster CDC.
  - **Garis Usia Vertikal (Red Age Line)**: Diperpanjang menembus grafik atas (Stature) hingga grafik bawah (Weight).
  - **Arsir Area Potensi Genetik**: Area TPG ($\text{TPG} \pm 8.5\text{ cm}$) diarsir hijau transparan dengan garis batas min/max dan target solid.
  - **Keterbacaan Label TPG**: Angka label batas TPG (`175` & `158`) berwarna **Merah Marun (`Colors.red.shade900`)** dengan efek *white outline shadow* agar tetap kontras dan mudah dibaca di layar PWA/smartphone vertikal.
- **Penyimpanan DB**: Kolom `fatherHeightCm` & `motherHeightCm` pada tabel `Patients` (Skema DB v7).
- **Cetak PDF**: Gambar kurva CDC 2000 + plotting ganda + arsir TPG trajektori penuh + riwayat anak otomatis ter-render di PDF.

### Laporan & tren
- **Laporan PDF** (Modul 16): identitas, usia, antropometri+Z-score, KPSP, skrining (KMME/M-CHAT/GPPH/SPPAHI), TDL, CARS, Denver II, **Fenton 2013**, **CDC 2000 & TPG**, **Asuhan Nutrisi Pediatrik (Resep MPASI Kemenkes 2023)**, kesimpulan red-flag, program stimulasi, **Tanda Tangan Digital (QR Code / Custom Image)**. (`reports/report_builder.dart`, `reports/pdf_report_service.dart`)
- **Anti-Orphan Container**: Mencegah blok tanda tangan terpisah sendirian di halaman kedua PDF.

## Skema DB (drift, v7) — `data/database.dart`
Patients (`fatherHeightCm`, `motherHeightCm`), Examinations, GrowthMeasurements, KpspResults, ScreeningResults, VisionResults, CarsResults, DenverResults. Migrasi additive v1→v7 (aman).

---

## CARA KERJA YANG DISUKAI USER
- Bahasa Indonesia. Kerja bertahap + verifikasi (analyze → test → build apk) tiap fitur. Jujur soal keterbatasan data; jangan mengarang medis.
- Setiap selesai fitur besar, tawarkan local code review.
- **JANGAN buka browser sub-agent.** User yang test sendiri.

## LANGKAH BERIKUTNYA
1. ✅ **KPSP Stimulation Fix** -> **Selesai.**
2. ✅ **M-CHAT-R/F Follow-Up (Tahap 2)** -> **Selesai.**
3. ✅ **Denver II Module** -> **Selesai.**
4. ✅ **Fenton 2013 Preterm Growth Chart Module** -> **Selesai.**
5. ✅ **Identitas Dokter & Tanda Tangan Digital (Auto QR Code)** -> **Selesai.**
6. ✅ **Kurva CDC 2000 & Tinggi Potensi Genetik (TPG) Module (Stature & Weight Plotting)** -> **Selesai.**
7. ✅ **Asuhan Nutrisi Pediatrik & Ide Resep MPASI Kemenkes 2023** -> **Selesai.**
8. Pematangan UI/UX & uji coba lapangan oleh dokter.

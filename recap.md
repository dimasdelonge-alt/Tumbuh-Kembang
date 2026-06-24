# RECAP — Aplikasi Skrining Tumbuh Kembang Anak

Dokumen ini ringkasan lengkap proyek agar sesi chat baru langsung punya konteks
penuh tanpa kehilangan riwayat. Baca ini dulu sebelum melanjutkan.

## Konteks proyek
- Aplikasi dipesan seorang **dokter spesialis anak** untuk skrining tumbuh
  kembang anak. Dokter mengirim PRD lengkap + folder materi PDF.
- **Prinsip yang dipegang ketat:** data medis SELALU dari sumber terverifikasi
  (tabel WHO resmi, PDF Kemenkes/dokter). TIDAK PERNAH mengarang koefisien,
  norma, atau konten klinis. Bila data tak tersedia/terverifikasi, fitur
  ditunda dan ditanyakan ke dokter — bukan ditebak.

## Stack teknis
- **Flutter** (Android utama, Web sekunder), offline-first.
- **drift** (SQLite, jalan di Android & Web) — DB lokal.
- **provider** (state), **fl_chart** (grafik), **pdf** + **printing** (laporan).
- **firebase_core** + **cloud_firestore** — sinkronisasi cloud real-time.
- Package name: `tumbang`. Target awal: Android (APK debug sukses dibuild).
- **Web hosting:** GitHub Pages → `https://dimasdelonge-alt.github.io/Tumbuh-Kembang/`
  - Build: `flutter build web --pwa-strategy none --base-href "/Tumbuh-Kembang/"`
  - Deploy: init git di `build/web/`, force push ke branch `gh-pages`.
- **Catatan build penting:** `path_provider_foundation` di-pin ke **2.4.4** di
  `dependency_overrides` (pubspec.yaml). Versi >=2.5.0 menarik `objective_c`
  yang punya native build hook & membuat `build_runner` gagal. Jangan naikkan.
- **Catatan web penting:** `SharedPreferences` TIDAK boleh dipakai langsung di
  web (plugin registration gagal → `MissingPluginException`). Gunakan
  `ConfigStorage` (`lib/utils/config_storage.dart`) yang pakai conditional
  import: `window.localStorage` di web, `SharedPreferences` di mobile.
- Codegen drift: `dart run build_runner build`. Setelah ubah skema DB, regen.

## Lokasi materi dokter (sumber data)
`C:\Users\Administrator\Downloads\Compressed\screening`
- Folder klaster usia (Neonatal, Bayi-Balita, Usia Sekolah, Remaja) + file di root.
- File kunci: `BUKU PEDOMAN SDIDTK revisi 28032022 (1) (2) - Copy.pdf` (root),
  KPSP, M-CHAT, KMME, TDD/TDL, GPPH, CARS (+interpretasi), Denver II, SPPAHI.
- Ekstraksi PDF: pakai Python `pypdf`, skrip di
  `C:\Users\ADMINI~1\AppData\Local\Temp\kilo\extract_pdf.py`.

## Verifikasi terkini
- `flutter analyze`: 0 error, 0 warning (≈12 info gaya-kode saja).
- **79 unit test lolos** (`flutter test`).
- `flutter build apk --debug`: sukses. Skema DB sudah di versi **5**.

---

## FITUR YANG SUDAH JADI & TERUJI

### Inti
- **Database pasien** (Modul 1): tambah/edit/cari; riwayat prematur, usia gestasi, Down syndrome, dll. (`patient_form_screen.dart`, `dashboard_screen.dart`). Mendukung pencatatan data awal lahir (BB/TB/LK Lahir) yang langsung ter-plot sebagai baseline 0-bulan pada grafik pertumbuhan.
- **Sesi Skrining Cepat (Anonim)**: Tab "Skrining Cepat" di dashboard untuk melangsungkan skrining instan tanpa pendaftaran formal (disimpan sebagai pasien anonim dengan kode rekam medis `'ANONIM'`).
- **Backup & Restore Manual (JSON)**: Menu pengaturan untuk mengekspor database lokal menjadi satu file cadangan `.json` (diunduh langsung di Web; dibagikan via sharing panel di Mobile) dan mengimpornya kembali dengan validasi format dan transaksi aman. (`backup_service.dart`, `file_helper.dart`, `settings_screen.dart`)
- **Sinkronisasi Cloud Firebase (Modul Sync)**: Real-time bi-directional sync antara perangkat perawat & dokter via Firestore. (`services/sync_service.dart`, `settings_screen.dart`)
  - **Outbound:** setiap insert/update/delete di `AppRepository` otomatis push ke Firestore (`patients`, `examinations`, `growthMeasurements`, `kpspResults`, `screeningResults`, `visionResults`, `carsResults`).
  - **Inbound:** listener `.snapshots().listen(...)` per koleksi → tulis ke SQLite lokal via `insertOnConflictUpdate`. UI otomatis update karena Drift watchers.
  - **Konfigurasi dinamis:** user masukkan API Key, Project ID, App ID di halaman Pengaturan. Disimpan di `ConfigStorage` (localStorage di web). Firebase di-init saat runtime, tanpa hardcode.
  - **Firebase project:** `tumbuh-kembang-klinik` (Firestore aktif, rules: test mode).
  - **Status:** ✅ Build & deploy selesai. **Belum ditest end-to-end oleh user.**
- **Age engine** (Modul 2): usia kronologis + **usia koreksi prematur** otomatis (berhenti di 24 bulan; aterm >=37 mgg tak dikoreksi). (`core/age_calculator.dart`)
- **Pemeriksaan/kunjungan** (Modul 14 dasar): hub per kunjungan (`examination_screen.dart`), riwayat di `patient_detail_screen.dart`.

### Pertumbuhan (Modul 3) — `modules/growth/`
- Z-score metode LMS: BB/U, TB/U, BB/TB, IMT/U, LK/U. (`zscore_calculator.dart`)
- Data WHO asli sebagai aset JSON di `assets/who/` (LMS, dalam bulan):
  - 0–5 thn dari paket `pygrowup` (turunan WHO resmi).
  - **5–19 thn (WHO 2007 / AnthroPlus)** untuk TB/U & IMT/U dari paket
    `zscorer` (`wgsrData.csv`) — diverifikasi cocok dgn data 0–5 di overlap.
  - IMT dihitung otomatis; BB/U, BB/TB, LK/U hanya 0–5 thn (return null di luar
    rentang via `enforceBounds`).
- **Klasifikasi status gizi age-aware** (`nutrition_classifier.dart`): ambang
  IMT/U beda untuk 0–5 thn (overweight >+2) vs >5 thn WHO 2007 (overweight >+1).
- `growth_assessment.dart` = SATU sumber kebenaran pipeline usia→ageDays→
  Z-score→status (dipakai layar input, tren, laporan). Kurva: `growth_chart.dart`.

### KPSP (Modul 4) — `modules/kpsp/`
- 16 form usia (3–72 bln) lengkap, skoring (9–10 Sesuai, 7–8 Meragukan,
  <=6 Penyimpangan), analisis domain. (`kpsp_data.dart`, `kpsp_model.dart`,
  `kpsp_screen.dart`)

### Estimasi Usia Perkembangan (Modul 5) — `modules/kpsp/`
- `developmental_age.dart`: metode batas-bawah — usia form tertinggi di mana
  semua item satu domain "Ya". Disclaimer tampil (bukan diagnosis formal).
- `developmental_age_service.dart`: helper bersama (parse jawaban → pilih usia
  pembanding koreksi/kronologis → analyze), dukung filter `asOf` (laporan
  historis akurat). Dipakai layar tren & laporan PDF.

### Smart Stimulation (Modul 6/9) — `modules/stimulation/`
- Database stimulasi dari **SDIDTK revisi 2022** (Tabel 3.7), 10 kelompok umur × 4 bidang. (`stimulation_data.dart`)
- Matching berbasis **jawaban KPSP aktual per domain** (jawaban "Tidak" -> stimulasi usia saat ini; semua "Ya" -> stimulasi satu tingkat usia di atasnya). (`stimulation.dart`). Muncul di layar modul pemeriksaan sebagai menu visual **"Stimulasi (Saran Aktivitas)"** dan tercetak di laporan PDF.

### Instrumen skrining generik — `modules/screening/`
Arsitektur generik (`instrument.dart`): tipe respon biner / Likert 0–3,
opsi penilai + cut-off per penilai, registry (`registry.dart`), tabel DB
`ScreeningResults`. UI generik `screening_screen.dart`.
- **KMME** (mental emosional, 12 item, bebas) — `data/kmme_data.dart`
- **TDD** (tes daya dengar, per kelompok usia, bebas) — `data/tdd_data.dart`
- **M-CHAT-R** (autisme, 20 item, item 2/5/12 terbalik, berhak cipta, pakai
  klinik sendiri) — `data/mchat_data.dart`
- **GPPH** (Abbreviated Conners, 10 item skala 0–3, ambang >=13, bebas Kemenkes)
  — `data/gpph_data.dart`
- **SPPAHI** (35 item skala 0–3, cut-off per penilai: Dokter >=22 / Ortu >=30 /
  Guru >=29) — `data/sppahi_data.dart`

### TDL (tes daya lihat) — `modules/vision/tdl.dart`
- Form catat baris poster "E" per mata (poster fisik tetap dipakai). 4 baris;
  tidak capai baris ke-3 → kemungkinan gangguan. Tabel DB `VisionResults`.

### CARS (autisme) — `modules/autism/cars.dart`
- 15 area, skala 1–4 step 0,5; <30 non-autistik, 30–36,5 ringan-sedang,
  >=37 berat. Berhak cipta (notice tampil). Tabel DB `CarsResults` (skor REAL).
  Layar `cars_screen.dart`.

### Laporan & tren
- **Laporan PDF** (Modul 16): identitas, usia, antropometri+Z-score, KPSP,
  skrining (KMME/M-CHAT/GPPH/SPPAHI), TDL, CARS, kesimpulan red-flag, program
  stimulasi, tanda tangan. (`reports/report_builder.dart`,
  `reports/pdf_report_service.dart`)
- **Tren longitudinal** (Modul 14): grafik Z-score BB/U & TB/U, skor KPSP,
  estimasi usia perkembangan + stimulasi antar kunjungan.
  (`screens/longitudinal_screen.dart`)

## Skema DB (drift, v5) — `data/database.dart`
Patients, Examinations, GrowthMeasurements, KpspResults, ScreeningResults
(+ kolom `variantLabel` untuk band usia TDD / penilai SPPAHI), VisionResults,
CarsResults. Migrasi additive v1→v5 (aman, hanya createTable/addColumn).

---

## TERBLOKIR — MENUNGGU DATA/KEPUTUSAN DOKTER

Semua butuh file/data spesifik yang belum tersedia & TIDAK BOLEH dikarang.

### 1. Fenton (kurva bayi prematur)
- Dokter setuju "ambil dari sumber resmi". Tapi data LMS Fenton 2013 yang bisa
  diverifikasi TIDAK ditemukan di paket open-source (sudah dicoba beberapa repo;
  `childsds` malah berisi Olsen, bukan Fenton).
- **Butuh:** file Excel/LMS resmi dari **fenton.ucalgary.ca** (6 set: BB/PB/LK ×
  L/P, per minggu usia 22–50). Mesin Z-score & usia koreksi sudah siap pakai.

### 2. Denver II
- Dokter setuju integrasikan & berlisensi memakainya. Dokter menjelaskan bahwa
  **"125 item itu penulisan ulang sesuai diagram batang"** — artinya tiap item
  punya rentang usia (titik di mana 25%/50%/75%/90% anak lulus) yang dibaca dari
  grafik batang formulir Denver II.
- PDF di folder HANYA berisi metode/cara interpretasi
  (Normal/Caution/Delayed/Untestable), BUKAN data 125 item + norma usianya.
- **Butuh:** data 125 item Denver II — daftar item per 4 domain (Personal Social,
  Fine Motor Adaptive, Language, Gross Motor) beserta **rentang usia tiap item**
  (umur 25/50/75/90% lulus) hasil penulisan ulang dari diagram batang.
  Tanpa angka usia per item ini, interpretasi Denver II tak bisa dihitung akurat.
- **Rencana implementasi (saat data ada):** model item {domain, p25,p50,p75,p90},
  hitung garis umur → tandai tiap item Advanced/Normal/Caution/Delayed →
  interpretasi global (Normal: tak ada delay & maks 1 caution; Suspek: >=1 delay
  atau >=2 caution; Untestable). Pakai usia koreksi prematur. Bisa juga
  menyumbang ke estimasi usia perkembangan (lebih akurat dari KPSP).

### 3. M-CHAT-R/F Follow-Up (wawancara tahap 2)
- Dokter setuju didigitalkan. Tapi file "follow-up" di folder ternyata
  **M-CHAT versi lama 23 item**, BUKAN wawancara Follow-Up tahap 2 (bercabang).
- **Butuh:** dokumen M-CHAT-R/F Follow-Up resmi (pertanyaan lanjutan per item
  gagal). M-CHAT-R 20 item tahap 1 sudah jadi.

### 4. CDC growth chart (opsional)
- Bisa diambil dari sumber resmi CDC bila dokter mau. WHO 0–19 thn sudah cukup.

---

## RENCANA KE DEPAN (sudah disepakati DITUNDA)
- **Tele-screening via QR/web:** orang tua isi lewat scan QR, dokter konfirmasi.
  Butuh **server online** (tak bisa murni offline) — bahas terpisah, biaya
  server/akun/keamanan data. Untuk kini pengisian di perangkat dokter.
- **Kop/identitas klinik di PDF:** nama klinik, alamat, logo, dokter, no. SIP.
  Dokter kirim saat siap; lalu tambahkan ke header `pdf_report_service.dart`.

## CARA KERJA YANG DISUKAI USER
- Bahasa Indonesia. Kerja bertahap + verifikasi (analyze → test → build apk)
  tiap fitur. Jujur soal keterbatasan data; jangan mengarang medis.
- Setiap selesai fitur besar, tawarkan local code review.
- File pertanyaan ke dokter: `PERTANYAAN_UNTUK_DOKTER.md` (selalu diperbarui).
- **JANGAN buka browser sub-agent.** User yang test sendiri.

## LANGKAH BERIKUTNYA
1. ✅ ~~Sinkronisasi Cloud Firebase~~ → **sudah diimplementasi, tinggal test.**
   - User buka https://dimasdelonge-alt.github.io/Tumbuh-Kembang/
   - Pengaturan → isi 3 field Firebase → Aktifkan Sinkronisasi Cloud.
   - Test: buat pasien di device 1, cek muncul di device 2.
2. Bila dokter kirim file Fenton → implementasi modul Fenton preterm.
3. Bila dokter kirim data 125 item Denver II → implementasi Denver II.
4. Bila dokter kirim M-CHAT-R/F Follow-Up → alur follow-up tahap 2.
5. Bila dokter kirim kop klinik → header laporan PDF.
6. Pematangan UI/UX & uji coba lapangan oleh dokter.

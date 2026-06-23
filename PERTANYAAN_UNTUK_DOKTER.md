# Status & Tindak Lanjut — Aplikasi Skrining Tumbuh Kembang

Dokumen ini memperbarui daftar pertanyaan sebelumnya, mencatat **apa yang sudah
dikerjakan** berdasarkan jawaban dokter, dan **apa yang masih menunggu** dari
dokter. Ditulis dalam bahasa non-teknis.

---

## Sudah jadi & sudah diuji (per pembaruan ini)

- Data pasien + hitung usia (termasuk **usia koreksi** prematur)
- Pertumbuhan WHO:
  - **0–5 tahun**: BB/U, TB/U, BB/TB, IMT/U, LK/U + grafik + status gizi
  - **5–19 tahun**: TB/U & **IMT/U** (IMT dihitung otomatis) memakai
    referensi WHO 2007 — **BARU**, sesuai arahan dokter
  - Ambang status IMT otomatis menyesuaikan usia (0–5 thn vs >5 thn)
- KPSP (16 form usia, 3–72 bulan)
- **KMME** (mental emosional)
- **TDD** (tes daya dengar) — per kelompok usia
- **M-CHAT-R** (skrining autisme, 20 item) — untuk pemakaian klinik sendiri
- **GPPH** (Abbreviated Conners, skala 0–3, ambang ≥13)
- **SPPAHI** (Skala Perilaku Hiperaktif, 35 item) — cut-off otomatis sesuai
  penilai (Dokter ≥22 / Orang tua ≥30 / Guru ≥29) — **BARU**
- **CARS** (skrining autisme, 15 area, skala 1–4 step 0,5) — berhak cipta,
  catatan hak cipta ditampilkan, untuk pemakaian klinik sendiri — **BARU**
- **TDL** (tes daya lihat, form catat baris poster "E" per mata)
- **Estimasi usia perkembangan** dari KPSP (pakai usia koreksi untuk prematur
  < 2 tahun)
- **Program stimulasi otomatis** (SDIDTK 2022): saran aktivitas per bidang
  berdasarkan **usia perkembangan** anak (bukan usia kronologis)
- Grafik tren antar kunjungan + laporan PDF (pertumbuhan, skrining, TDL,
  CARS, usia perkembangan, **dan program stimulasi** ikut tercetak)

Semua diverifikasi: **76 uji otomatis lolos**, dan aplikasi berhasil dibangun
(APK Android).

---

## Jawaban dokter yang SUDAH ditindaklanjuti (lengkap)

- **A1 (dipakai sendiri):** M-CHAT-R aman; catatan hak cipta tetap ditampilkan.
- **B3–B5 (GPPH):** skala 0=tidak ada, 1=kadang, 2=sering, 3=selalu; total
  **≥13 → kemungkinan GPPH/ADHD → rujuk** (versi Kemenkes, bebas).
- **C6–C8 (TDL):** form catat hasil; poster "E" asli tetap dipakai, 4 baris,
  tidak capai baris ke-3 → kemungkinan gangguan → periksa ulang → rujuk.
- **D9, D10 (usia perkembangan):** metode lulus-penuh-per-bidang; pembanding
  pakai usia koreksi (prematur <2 thn) atau kronologis (≥2 thn).
- **D12–D14 (stimulasi):** database dibuat dari **Buku Pedoman SDIDTK revisi
  28 Maret 2022** (file di folder root). Materi disederhanakan bahasanya,
  dikelompokkan per bidang per usia perkembangan; saran muncul untuk bidang
  yang tertinggal. (Catatan: isi Tabel 3.7 pada revisi 2022 identik dengan
  versi 2021.)
- **"Di atas 5 tahun pakai WHO IMT/U":** sudah diterapkan (IMT dihitung
  otomatis dari BB & TB).
- **G17/G19 (QR online & kop klinik):** **ditunda** sesuai arahan dokter —
  fokus offline dulu agar bisa ditest.
- **SPPAHI (setuju):** sudah dibuat dari file SPPAHI yang dokter kirim. 35 item,
  cut-off otomatis menyesuaikan penilai (Dokter ≥22 / Orang tua ≥30 / Guru ≥29).
- **CARS (setuju):** sudah dibuat. 15 area, skala 1–4 (boleh 0,5);
  <30 non-autistik, 30–36,5 ringan-sedang, ≥37 berat. Catatan hak cipta tampil.

---

## MASIH MENUNGGU dari dokter (untuk pengembangan berikutnya)

### 1. Fenton (kurva bayi prematur) — butuh FILE DATA
Dokter setuju "ambil dari sumber resmi". Namun kami **tidak menemukan data LMS
Fenton 2013 yang bisa diverifikasi** dari paket open-source (sudah dicoba
beberapa sumber). Karena ini untuk bayi prematur (populasi rentan), kami
**tidak akan menyalin angka dari ingatan** — risiko salah terlalu besar.

Mohon kirimkan **file resmi Fenton 2013** dari situs resmi
(fenton.ucalgary.ca → "Fenton preterm growth chart" → file Excel/LMS data).
Biasanya berisi 6 set: BB / Panjang / Lingkar Kepala × laki-laki & perempuan,
per minggu usia 22–50. Begitu file diterima, implementasi cepat (mesin Z-score
& usia koreksi sudah siap).

### 2. CDC — konfirmasi
- **CDC growth chart**: butuh data angka tabel (LMS). Kami bisa ambil dari
  sumber resmi CDC bila dokter setuju. (WHO 0–19 thn sudah jalan; CDC opsional.)

### 3. M-CHAT-R/F follow-up & Denver II — butuh data/keputusan
- **M-CHAT follow-up:** dokter setuju didigitalkan. Tetapi file di folder
  ternyata **M-CHAT versi lama 23 item**, BUKAN wawancara Follow-Up (tahap 2)
  resmi M-CHAT-R/F. Mohon kirim **dokumen M-CHAT-R/F Follow-Up resmi** (daftar
  pertanyaan lanjutan per item gagal) bila ingin alur follow-up yang benar.
- **Denver II:** dokter setuju integrasikan. Tetapi PDF di folder hanya berisi
  **cara/metode interpretasi**, BUKAN data 125 item + norma usianya (usia di
  mana 25%/50%/75%/90% anak lulus). Data itu inti Denver II dan berhak cipta.
  Mohon kirim **file data 125 item Denver II** (atau tabel normanya). Tanpa itu
  kami tidak bisa membuat Denver II yang akurat dan tidak akan mengarangnya.

### 4. Rencana ke depan (sudah disepakati ditunda)
- **Tele-screening via QR/web**: butuh server online; dibahas terpisah nanti.
- **Kop/identitas klinik** di PDF (nama, alamat, logo, dokter, SIP): kirim saat
  siap.

---

## Catatan
Semua yang sudah jadi memakai sumber resmi (tabel WHO, PDF Kemenkes/dokter) —
tidak ada konten medis yang dikarang. Materi stimulasi diambil dari Buku
Pedoman SDIDTK revisi 28 Maret 2022 lalu disederhanakan bahasanya, tanpa
menambah aktivitas di luar pedoman.

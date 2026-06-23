// Data stimulasi per kelompok usia per bidang.
//
// Ditranskrip & disederhanakan dari Tabel 3.7 Buku Pedoman Pelaksanaan SDIDTK
// Anak (Kemenkes, revisi 28 Maret 2022): "Tahapan perkembangan, stimulasi, dan
// red flags". Isi Tabel 3.7 pada revisi 2022 identik dengan versi 2021.
// Domain dipetakan ke domain KPSP: gerak kasar, gerak halus, bicara & bahasa,
// sosialisasi & kemandirian.
//
// Panggil [registerStimulationData] sekali saat startup.

import '../kpsp/kpsp_model.dart' show KpspDomain;
import 'stimulation.dart';

const _gk = KpspDomain.gerakKasar;
const _gh = KpspDomain.gerakHalus;
const _bb = KpspDomain.bicaraBahasa;
const _sk = KpspDomain.sosialisasiKemandirian;

final List<StimulationBand> _bands = [
  // ---------------- 0-2 bulan ----------------
  StimulationBand(minMonths: 0, maxMonths: 2, label: '0-2 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Melatih mengangkat kepala',
        howTo: 'Telungkupkan bayi, gerakkan mainan berwarna cerah/buat suara '
            'gembira di depannya agar ia belajar mengangkat kepala dan dada.'),
    StimulationActivity(domain: _gk, title: 'Menahan kepala tetap tegak',
        howTo: 'Gendong bayi posisi tegak menghadap ke depan sambil menunjuk '
            'benda menarik, agar ia belajar menahan kepalanya tegak.'),
    StimulationActivity(domain: _gh, title: 'Meraba dan memegang benda',
        howTo: 'Sentuhkan mainan kecil berbunyi/berwarna cerah ke punggung '
            'jari bayi, amati cara ia memegang. Jaga benda tidak tertelan.'),
    StimulationActivity(domain: _gh, title: 'Menggantung benda berwarna',
        howTo: 'Gantungkan mainan ~30 cm di atas bayi agar ia tertarik melihat '
            'dan menggerakkan tangan-kakinya sebagai reaksi.'),
    StimulationActivity(domain: _bb, title: 'Mengenali berbagai suara',
        howTo: 'Ajak bicara dan bernyanyi; perdengarkan suara anggota keluarga, '
            'binatang, dan sebagainya.'),
    StimulationActivity(domain: _bb, title: 'Menirukan ocehan bayi',
        howTo: 'Tirukan ocehan dan mimik muka bayi sesering mungkin agar terjadi '
            'komunikasi dua arah.'),
    StimulationActivity(domain: _sk, title: 'Menunjukkan rasa tertarik',
        howTo: 'Sesering mungkin ajak bayi tersenyum, tatap matanya, balas '
            'senyumnya, dan ajak bermain cilukba.'),
    StimulationActivity(domain: _sk, title: 'Memberi rasa aman & nyaman',
        howTo: 'Beri pelukan, belaian, ayunan; ajak bicara dengan nada lembut '
            'saat menyusui, mandi, atau berpakaian.'),
  ]),

  // ---------------- 3-5 bulan ----------------
  StimulationBand(minMonths: 3, maxMonths: 5, label: '3-5 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Melatih kontrol kepala',
        howTo: 'Gendong bayi posisi tegak menghadap ke depan agar otot lehernya '
            'menguat.'),
    StimulationActivity(domain: _gk, title: 'Melatih bayi duduk',
        howTo: 'Dudukkan bayi di kursi bersandaran; bila sudah tegak, dudukkan '
            'di lantai beralas tanpa sandaran.'),
    StimulationActivity(domain: _gk, title: 'Melatih berguling',
        howTo: 'Letakkan mainan cerah di sisi bayi lalu pindahkan perlahan ke '
            'sisi lain; bantu silangkan paha agar badan ikut miring.'),
    StimulationActivity(domain: _gh, title: 'Meraih dan memegang mainan',
        howTo: 'Beri mainan dalam jangkauan agar bayi meraih, menggenggam, dan '
            'menggoyangkannya.'),
    StimulationActivity(domain: _bb, title: 'Mencari sumber suara',
        howTo: 'Buat suara dari arah berbeda agar bayi mencari sumbernya; '
            'tirukan suara yang ia keluarkan.'),
    StimulationActivity(domain: _sk, title: 'Mengamati & meniru ekspresi',
        howTo: 'Tatap wajah bayi, buat ekspresi (senyum, kerut dahi) agar ia '
            'menirukannya; respons ungkapan kasih sayangnya.'),
  ]),

  // ---------------- 6-8 bulan ----------------
  StimulationBand(minMonths: 6, maxMonths: 8, label: '6-8 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Melatih merangkak',
        howTo: 'Letakkan mainan di luar jangkauan agar bayi merangkak ke arahnya '
            'memakai kedua tangan dan lutut.'),
    StimulationActivity(domain: _gk, title: 'Melatih berdiri',
        howTo: 'Dari posisi duduk, tarik bayi ke posisi berdiri; ulangi sambil '
            'berpegangan pada meja/kursi.'),
    StimulationActivity(domain: _gh, title: 'Memegang mainan di kedua tangan',
        howTo: 'Beri mainan di satu tangan lalu mainan lain di tangan yang sama '
            'agar ia memindahkan dan memegang dua mainan.'),
    StimulationActivity(domain: _gh, title: 'Memasukkan benda ke wadah',
        howTo: 'Ajari memasukkan benda ke wadah (kaleng/botol), lalu '
            'mengeluarkannya kembali. Pastikan benda aman/tidak tertelan.'),
    StimulationActivity(domain: _bb, title: 'Membacakan buku cerita',
        howTo: 'Bacakan buku bergambar berwarna setiap hari beberapa menit, '
            'sebutkan nama benda dengan ejaan benar (tidak cadel).'),
    StimulationActivity(domain: _bb, title: 'Mengucapkan kata sederhana',
        howTo: 'Ulangi suara bayi jadi kata bermakna; mis. saat ia berkata '
            '"bah", ucapkan "botol" atau "buku".'),
    StimulationActivity(domain: _sk, title: 'Bermain sosialisasi',
        howTo: 'Ajak bersalaman/tepuk tangan; lambaikan tangan "da-dah" saat '
            'ada yang pergi dan bantu bayi membalas.'),
    StimulationActivity(domain: _sk, title: 'Mengajarkan sebab-akibat',
        howTo: 'Saat bayi menjatuhkan mainan, ambil dan kembalikan; ini '
            'mengajarkan konsep sebab-akibat.'),
  ]),

  // ---------------- 9-11 bulan ----------------
  StimulationBand(minMonths: 9, maxMonths: 11, label: '9-11 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Duduk, merangkak, berdiri',
        howTo: 'Sediakan tempat luas & aman; latih bayi duduk, merangkak, dan '
            'berdiri berpegangan.'),
    StimulationActivity(domain: _gk, title: 'Berjalan berpegangan',
        howTo: 'Letakkan mainan favorit agak jauh agar bayi berjalan '
            'berpegangan pada perabot untuk meraihnya.'),
    StimulationActivity(domain: _gh, title: 'Menyusun balok',
        howTo: 'Ajari bayi menyusun beberapa balok/kotak (bisa dari karton atau '
            'kaleng kecil kosong).'),
    StimulationActivity(domain: _gh, title: 'Menggambar/mencoret',
        howTo: 'Beri krayon dan kertas; ajak bayi mencoret-coret bebas.'),
    StimulationActivity(domain: _bb, title: 'Menirukan kata-kata',
        howTo: 'Sebutkan kata yang diketahui artinya (minum, susu, mandi) dan '
            'buat agar bayi menirukan; puji bila ia mengucapkannya.'),
    StimulationActivity(domain: _bb, title: 'Bermain dengan boneka',
        howTo: 'Berpura-pura boneka berbicara kepada bayi agar bayi mau '
            'berbicara balik dengan boneka.'),
    StimulationActivity(domain: _sk, title: 'Cilukba & petak umpet',
        howTo: 'Tutupi wajah dengan kain lalu singkirkan sambil berkata '
            '"cilukba" saat wajah terlihat lagi.'),
    StimulationActivity(domain: _sk, title: 'Permainan giliran',
        howTo: 'Ajak bayi bermain "giliranku, giliranmu", mis. menggelindingkan '
            'bola bergantian.'),
  ]),

  // ---------------- 12-17 bulan ----------------
  StimulationBand(minMonths: 12, maxMonths: 17, label: '12-17 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Berjalan mundur',
        howTo: 'Bila anak sudah berjalan tanpa pegangan, beri mainan tarik agar '
            'ia melangkah mundur untuk memperhatikannya.'),
    StimulationActivity(domain: _gk, title: 'Naik-turun tangga',
        howTo: 'Ajari jalan naik tangga sambil berpegangan dinding/pegangan; '
            'temani saat pertama kali.'),
    StimulationActivity(domain: _gk, title: 'Menendang & melempar bola',
        howTo: 'Tunjukkan cara melempar dan menangkap bola besar, lalu ajak '
            'menendang bola.'),
    StimulationActivity(domain: _gh, title: 'Menyusun balok',
        howTo: 'Ajari menyusun balok kecil (±2,5 cm) ke atas tanpa '
            'menjatuhkannya.'),
    StimulationActivity(domain: _gh, title: 'Menggambar garis',
        howTo: 'Beri krayon dan kertas; tunjukkan cara menggambar garis ke atas, '
            'bawah, dan melintang. Puji saat ia mencoba menyalin.'),
    StimulationActivity(domain: _bb, title: 'Mengenal nama benda & tubuh',
        howTo: 'Ajari nama bagian tubuh dan benda sekitar; minta anak menunjuk '
            'dan menirukan penyebutannya.'),
    StimulationActivity(domain: _bb, title: 'Membacakan buku cerita',
        howTo: 'Bacakan setiap hari; biarkan anak membalik halaman dan bergantian '
            'menyebut nama gambar.'),
    StimulationActivity(domain: _sk, title: 'Makan & melepas baju sendiri',
        howTo: 'Tunjukkan cara memegang sendok dan melepas pakaian; biarkan anak '
            'mencoba sendiri, bantu bila perlu.'),
    StimulationActivity(domain: _sk, title: 'Menirukan pekerjaan rumah',
        howTo: 'Saat menyapu/membersihkan rumah, ajak anak menirukan; beri ia '
            'lap atau sapu kecil.'),
  ]),

  // ---------------- 18-23 bulan ----------------
  StimulationBand(minMonths: 18, maxMonths: 23, label: '18-23 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Keseimbangan satu kaki',
        howTo: 'Ajari berdiri dengan satu kaki bergantian; ia boleh berpegangan '
            'pada Anda/kursi pada awalnya.'),
    StimulationActivity(domain: _gk, title: 'Berlari & melompat',
        howTo: 'Latih anak berjalan, berlari, melompat, serta naik-turun tangga '
            'dengan aman.'),
    StimulationActivity(domain: _gh, title: 'Bermain puzzle sederhana',
        howTo: 'Beri puzzle 2-3 potong; bantu anak menyusunnya.'),
    StimulationActivity(domain: _gh, title: 'Menggambar bentuk',
        howTo: 'Tunjukkan cara menggambar garis, bulatan, dan wajah memakai '
            'krayon/spidol.'),
    StimulationActivity(domain: _bb, title: 'Bercerita dari gambar',
        howTo: 'Perlihatkan buku/majalah bergambar; ceritakan dengan kata '
            'sederhana dan minta anak menceritakan apa yang dilihatnya.'),
    StimulationActivity(domain: _bb, title: 'Perintah sederhana',
        howTo: 'Beri perintah 1 langkah dengan kata sederhana, mis. "Tolong '
            'bawakan kaos kaki merah"; tunjukkan caranya.'),
    StimulationActivity(domain: _sk, title: 'Bermain dengan teman sebaya',
        howTo: 'Ajak bermain bersama teman (mis. petak umpet) agar anak belajar '
            'aturan dan giliran.'),
    StimulationActivity(domain: _sk, title: 'Berpakaian sendiri',
        howTo: 'Biarkan anak memakai dan melepas pakaian sendiri sejauh yang '
            'ia bisa.'),
  ]),

  // ---------------- 24-35 bulan ----------------
  StimulationBand(minMonths: 24, maxMonths: 35, label: '24-35 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Melompat dengan dua kaki',
        howTo: 'Beri batas (handuk/garis kapur) agar anak melompat jauh dengan '
            'kedua kaki bersamaan.'),
    StimulationActivity(domain: _gk, title: 'Melempar & menangkap bola',
        howTo: 'Lempar bola besar ke arah anak dan minta ia melemparkannya '
            'kembali.'),
    StimulationActivity(domain: _gh, title: 'Mengelompokkan benda',
        howTo: 'Beri aneka benda (kancing, koin, benda berwarna); minta anak '
            'memilih dan mengelompokkan menurut jenis/warna.'),
    StimulationActivity(domain: _gh, title: 'Proyek seni & menempel',
        howTo: 'Ajak menggunting gambar dari majalah dan menempelnya; lakukan '
            'proyek seni dengan krayon/cat.'),
    StimulationActivity(domain: _bb, title: 'Membacakan & bertanya 5W1H',
        howTo: 'Bacakan buku cerita; setelah selesai ajukan pertanyaan siapa, '
            'apa, kapan, di mana, mengapa, bagaimana.'),
    StimulationActivity(domain: _bb, title: 'Mendorong bicara dua kata',
        howTo: 'Ajak bicara dengan kalimat 2 kata berejaan benar; dorong anak '
            'mengucapkan kata dibanding menunjuk.'),
    StimulationActivity(domain: _sk, title: 'Toilet training',
        howTo: 'Ajari memberitahu bila ingin BAK/BAB, dampingi, dan ajarkan cara '
            'membersihkan diri.'),
    StimulationActivity(domain: _sk, title: 'Berpakaian & makan sendiri',
        howTo: 'Ajari berpakaian sendiri dan makan dengan sendok-garpu; beri '
            'kesempatan memilih pakaiannya.'),
  ]),

  // ---------------- 36-47 bulan ----------------
  StimulationBand(minMonths: 36, maxMonths: 47, label: '36-47 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Berjalan di garis lurus',
        howTo: 'Buat garis lurus (tali rafia/kapur) dan tunjukkan cara berjalan '
            'di atasnya sambil merentangkan tangan untuk keseimbangan.'),
    StimulationActivity(domain: _gk, title: 'Melompat satu kaki',
        howTo: 'Tunjukkan cara melompat dengan satu kaki, lalu melompat '
            'melintasi ruangan bergantian kaki.'),
    StimulationActivity(domain: _gh, title: 'Menggunting',
        howTo: 'Beri gunting anak dan gambar besar untuk latihan menggunting.'),
    StimulationActivity(domain: _gh, title: 'Menggambar & menulis',
        howTo: 'Ajari menggambar garis, bulatan, segi empat, serta menulis huruf, '
            'angka, dan nama anak.'),
    StimulationActivity(domain: _bb, title: 'Mengenal huruf',
        howTo: 'Tempel huruf besar dari koran/majalah pada karton; sebutkan satu '
            'per satu dan minta anak mengulanginya.'),
    StimulationActivity(domain: _bb, title: 'Bercerita & menjawab',
        howTo: 'Bacakan cerita setiap hari; dorong anak bertanya dan bercerita '
            'tentang dirinya, jawab dengan beberapa kata.'),
    StimulationActivity(domain: _sk, title: 'Mencuci tangan & mandi sendiri',
        howTo: 'Tunjukkan cara memakai sabun dan membasuh; setelah bisa, ajari '
            'mandi sendiri.'),
    StimulationActivity(domain: _sk, title: 'Bersosialisasi & empati',
        howTo: 'Ajak ke tempat banyak anak agar bersosialisasi; bicarakan emosi '
            'anak dan dorong ia mengenali perasaan orang lain.'),
  ]),

  // ---------------- 48-59 bulan ----------------
  StimulationBand(minMonths: 48, maxMonths: 59, label: '48-59 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Permainan gerak aktif',
        howTo: 'Ajak balap karung, engklek, lompat tali, dan menari mengikuti '
            'musik bersama teman sebaya.'),
    StimulationActivity(domain: _gh, title: 'Menggambar, menggunting, menempel',
        howTo: 'Ajari menggambar orang/bentuk; beri kesempatan menceritakan apa '
            'yang dibuat secara berurutan.'),
    StimulationActivity(domain: _gh, title: 'Konsep angka & ukuran',
        howTo: 'Buat kartu angka 1-10; minta anak menghitung benda kecil dan '
            'mengurutkan benda dari kecil ke besar / sedikit ke banyak.'),
    StimulationActivity(domain: _bb, title: 'Melengkapi kalimat & tata bahasa',
        howTo: 'Buat kalimat tentang kegiatan bersama lalu minta anak '
            'melengkapinya; gunakan kata "pertama", "kedua", "akhirnya".'),
    StimulationActivity(domain: _bb, title: 'Mengenal warna, hari, simbol',
        howTo: 'Ajari mengenali warna benda, menyebut nama hari, dan simbol di '
            'tanda-tanda jalan/tempat umum.'),
    StimulationActivity(domain: _sk, title: 'Membentuk kemandirian',
        howTo: 'Beri kesempatan mengunjungi tetangga/teman tanpa ditemani lalu '
            'minta bercerita; latih sikat gigi & berpakaian sendiri.'),
    StimulationActivity(domain: _sk, title: 'Bermain peran',
        howTo: 'Ajak bermain "belanja di toko" dengan uang kertas mainan, '
            'bergantian jadi pembeli dan penjual.'),
  ]),

  // ---------------- 60-72 bulan ----------------
  StimulationBand(minMonths: 60, maxMonths: 72, label: '60-72 bulan', activities: [
    StimulationActivity(domain: _gk, title: 'Permainan halang rintang',
        howTo: 'Ajak berjalan-jalan, bermain berburu, dan halang rintang di '
            'sekitar rumah atau taman. Lanjutkan permainan gerak usia 48-59 bln.'),
    StimulationActivity(domain: _gh, title: 'Kerajinan tangan',
        howTo: 'Sediakan tanah liat/lilin mainan; bantu anak membuat berbagai '
            'bentuk dan minta ia menceritakan hasilnya.'),
    StimulationActivity(domain: _gh, title: 'Proyek seni & menggambar',
        howTo: 'Sediakan krayon, kertas, cat, gunting; dorong anak menggambar '
            'dan membuat proyek seni dengan beragam alat.'),
    StimulationActivity(domain: _bb, title: 'Memprediksi cerita',
        howTo: 'Saat membacakan cerita, minta anak menebak apa yang terjadi '
            'selanjutnya dan menceritakan gambar yang dilihat.'),
    StimulationActivity(domain: _bb, title: 'Konsep waktu',
        howTo: 'Buat "jam" dari karton dan kalender; bantu anak mengenal '
            'jam, hari, minggu, dan bulan lewat kegiatan sehari-hari.'),
    StimulationActivity(domain: _sk, title: 'Urutan kegiatan & kemandirian',
        howTo: 'Bantu anak memahami urutan langkah (mis. mencuci tangan, '
            'menyiapkan makanan); libatkan dalam acara makan keluarga.'),
  ]),
];

/// Memuat data stimulasi ke pustaka.
void registerStimulationData() {
  if (StimulationLibrary.isLoaded) return;
  StimulationLibrary.bands = List.unmodifiable(_bands);
}

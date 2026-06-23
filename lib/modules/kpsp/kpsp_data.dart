// Data 16 formulir KPSP (usia 3-72 bulan).
//
// Ditranskrip dari Buku Panduan KPSP (CSL FK Unhas 2018) / SDIDTK DEPKES.
// Domain tiap item ditetapkan mengikuti pembagian sektor KPSP: gerak kasar,
// gerak halus, bicara & bahasa, sosialisasi & kemandirian.
//
// Panggil [registerKpspForms] sekali saat startup untuk memuat semua form
// ke dalam KpspData.

import 'kpsp_model.dart';

const _gk = KpspDomain.gerakKasar;
const _gh = KpspDomain.gerakHalus;
const _bb = KpspDomain.bicaraBahasa;
const _sk = KpspDomain.sosialisasiKemandirian;

final List<KpspForm> _allForms = [
  // ---------------- 3 bulan ----------------
  const KpspForm(ageMonths: 3, questions: [
    KpspQuestion(1, 'Pada waktu bayi telentang, apakah masing-masing lengan dan tungkai bergerak dengan mudah?', _gk),
    KpspQuestion(2, 'Pada waktu bayi telentang, apakah ia melihat dan menatap wajah anda?', _sk),
    KpspQuestion(3, 'Apakah bayi dapat mengeluarkan suara-suara lain (ngoceh), di samping menangis?', _bb),
    KpspQuestion(4, 'Pada waktu bayi telentang, apakah ia dapat mengikuti gerakan anda dengan menggerakkan kepalanya dari kanan/kiri ke tengah?', _gh),
    KpspQuestion(5, 'Pada waktu bayi telentang, apakah ia dapat mengikuti gerakan anda dengan menggerakkan kepalanya dari satu sisi hampir sampai pada sisi yang lain?', _gh),
    KpspQuestion(6, 'Pada waktu anda mengajak bayi berbicara dan tersenyum, apakah ia tersenyum kembali kepada anda?', _sk),
    KpspQuestion(7, 'Pada waktu bayi telungkup di alas datar, apakah ia dapat mengangkat kepalanya?', _gk),
    KpspQuestion(8, 'Pada waktu bayi telungkup di alas datar, apakah ia dapat mengangkat kepalanya sehingga membentuk sudut 45 derajat?', _gk),
    KpspQuestion(9, 'Pada waktu bayi telungkup di alas datar, apakah ia dapat mengangkat kepalanya dengan tegak?', _gk),
    KpspQuestion(10, 'Apakah bayi suka tertawa keras walau tidak digelitik atau diraba-raba?', _bb),
  ]),

  // ---------------- 6 bulan ----------------
  const KpspForm(ageMonths: 6, questions: [
    KpspQuestion(1, 'Pada waktu bayi telentang, apakah ia dapat mengikuti gerakan anda dengan menggerakkan kepala sepenuhnya dari satu sisi ke sisi yang lain?', _gh),
    KpspQuestion(2, 'Dapatkah bayi mempertahankan posisi kepala dalam keadaan tegak dan stabil?', _gk),
    KpspQuestion(3, 'Sentuhkan pensil di punggung tangan atau ujung jari bayi. Apakah bayi dapat menggenggam pensil itu selama beberapa detik?', _gh),
    KpspQuestion(4, 'Ketika bayi telungkup di alas datar, apakah ia dapat mengangkat dada dengan kedua lengannya sebagai penyangga?', _gk),
    KpspQuestion(5, 'Pernahkah bayi mengeluarkan suara gembira bernada tinggi atau memekik tetapi bukan menangis?', _bb),
    KpspQuestion(6, 'Pernahkah bayi berbalik paling sedikit dua kali, dari telentang ke telungkup atau sebaliknya?', _gk),
    KpspQuestion(7, 'Pernahkah anda melihat bayi tersenyum ketika melihat mainan yang lucu, gambar atau binatang peliharaan saat ia bermain sendiri?', _sk),
    KpspQuestion(8, 'Dapatkah bayi mengarahkan matanya pada benda kecil sebesar kacang, kismis atau uang logam?', _gh),
    KpspQuestion(9, 'Dapatkah bayi meraih mainan yang diletakkan agak jauh namun masih dalam jangkauan tangannya?', _gh),
    KpspQuestion(10, 'Pada posisi telentang, pegang kedua tangannya lalu tarik perlahan ke posisi duduk. Dapatkah bayi mempertahankan lehernya secara kaku?', _gk),
  ]),

  // ---------------- 9 bulan ----------------
  const KpspForm(ageMonths: 9, questions: [
    KpspQuestion(1, 'Pada posisi telentang, pegang kedua tangannya lalu tarik perlahan ke posisi duduk. Dapatkah bayi mempertahankan lehernya secara kaku?', _gk),
    KpspQuestion(2, 'Pernahkah anda melihat bayi memindahkan mainan/kue kering dari satu tangan ke tangan yang lain?', _gh),
    KpspQuestion(3, 'Tarik perhatian bayi dengan selendang/sapu tangan, kemudian jatuhkan ke lantai. Apakah bayi mencoba mencarinya?', _sk),
    KpspQuestion(4, 'Apakah bayi dapat memungut dua benda, dan masing-masing tangan memegang satu benda pada saat bersamaan?', _gh),
    KpspQuestion(5, 'Jika anda mengangkat bayi melalui ketiaknya ke posisi berdiri, dapatkah ia menyangga sebagian berat badan dengan kedua kakinya?', _gk),
    KpspQuestion(6, 'Dapatkah bayi memungut benda-benda kecil seperti kismis/kacang dengan gerakan miring atau menggerapai?', _gh),
    KpspQuestion(7, 'Tanpa disangga, dapatkah bayi duduk sendiri selama 60 detik?', _gk),
    KpspQuestion(8, 'Apakah bayi dapat makan kue kering sendiri?', _sk),
    KpspQuestion(9, 'Saat bayi bermain sendiri dan anda diam-diam datang dari belakang, apakah ia menengok ke belakang seperti mendengar kedatangan anda (suara perlahan/bisikan)?', _bb),
    KpspQuestion(10, 'Letakkan mainan yang diinginkannya di luar jangkauan, apakah ia mencoba mendapatkannya dengan mengulurkan lengan atau badannya?', _gh),
  ]),

  // ---------------- 12 bulan ----------------
  const KpspForm(ageMonths: 12, questions: [
    KpspQuestion(1, 'Jika anda bersembunyi lalu muncul dan menghilang berulang di hadapan anak, apakah ia mencari atau mengharapkan anda muncul kembali?', _sk),
    KpspQuestion(2, 'Letakkan pensil di telapak tangan bayi lalu coba ambil perlahan. Sulitkah anda mendapatkan pensil itu kembali?', _gh),
    KpspQuestion(3, 'Apakah anak dapat berdiri selama 30 detik atau lebih dengan berpegangan pada kursi/meja?', _gk),
    KpspQuestion(4, 'Apakah anak dapat mengatakan 2 suku kata yang sama, misalnya "ma-ma", "da-da", "pa-pa"?', _bb),
    KpspQuestion(5, 'Apakah anak dapat mengangkat badannya ke posisi berdiri tanpa bantuan anda?', _gk),
    KpspQuestion(6, 'Apakah anak dapat membedakan anda dengan orang yang belum dikenal (malu/ragu saat bertemu orang baru)?', _sk),
    KpspQuestion(7, 'Apakah anak dapat mengambil benda kecil seperti kacang/kismis dengan meremas di antara ibu jari dan jarinya?', _gh),
    KpspQuestion(8, 'Apakah anak dapat duduk sendiri tanpa bantuan?', _gk),
    KpspQuestion(9, 'Sebut 2-3 kata yang dapat ditiru anak. Apakah ia mencoba meniru menyebutkan kata-kata tadi?', _bb),
    KpspQuestion(10, 'Tanpa bantuan, apakah anak dapat mempertemukan dua kubus kecil yang ia pegang?', _gh),
  ]),

  // ---------------- 15 bulan ----------------
  const KpspForm(ageMonths: 15, questions: [
    KpspQuestion(1, 'Tanpa bantuan, apakah anak dapat mempertemukan dua kubus kecil yang ia pegang?', _gh),
    KpspQuestion(2, 'Apakah anak dapat jalan sendiri atau jalan dengan berpegangan?', _gk),
    KpspQuestion(3, 'Tanpa bantuan, apakah anak dapat bertepuk tangan atau melambai-lambai?', _sk),
    KpspQuestion(4, 'Apakah anak dapat mengatakan "papa" saat memanggil/melihat ayahnya, atau "mama" saat memanggil/melihat ibunya?', _bb),
    KpspQuestion(5, 'Dapatkah anak berdiri sendiri tanpa berpegangan selama kira-kira 5 detik?', _gk),
    KpspQuestion(6, 'Dapatkah anak berdiri sendiri tanpa berpegangan selama 30 detik atau lebih?', _gk),
    KpspQuestion(7, 'Tanpa berpegangan, apakah anak dapat membungkuk untuk memungut mainan di lantai dan berdiri kembali?', _gk),
    KpspQuestion(8, 'Apakah anak dapat menunjukkan apa yang diinginkannya tanpa menangis/merengek (menunjuk, menarik, atau bersuara)?', _bb),
    KpspQuestion(9, 'Apakah anak dapat berjalan di sepanjang ruangan tanpa jatuh atau terhuyung-huyung?', _gk),
    KpspQuestion(10, 'Apakah anak dapat mengambil benda kecil seperti kacang/kismis dengan ibu jari dan jari telunjuk?', _gh),
  ]),

  // ---------------- 18 bulan ----------------
  const KpspForm(ageMonths: 18, questions: [
    KpspQuestion(1, 'Tanpa bantuan, apakah anak dapat bertepuk tangan atau melambai-lambai?', _sk),
    KpspQuestion(2, 'Apakah anak dapat mengatakan "papa" saat memanggil/melihat ayahnya, atau "mama" saat memanggil/melihat ibunya?', _bb),
    KpspQuestion(3, 'Apakah anak dapat berdiri sendiri tanpa berpegangan selama kira-kira 5 detik?', _gk),
    KpspQuestion(4, 'Apakah anak dapat berdiri sendiri tanpa berpegangan selama 30 detik atau lebih?', _gk),
    KpspQuestion(5, 'Tanpa berpegangan, apakah anak dapat membungkuk untuk memungut mainan di lantai dan berdiri kembali?', _gk),
    KpspQuestion(6, 'Apakah anak dapat menunjukkan apa yang diinginkannya tanpa menangis/merengek (menunjuk, menarik, atau bersuara)?', _bb),
    KpspQuestion(7, 'Apakah anak dapat berjalan di sepanjang ruangan tanpa jatuh atau terhuyung-huyung?', _gk),
    KpspQuestion(8, 'Apakah anak dapat mengambil benda kecil seperti kacang/kismis dengan ibu jari dan jari telunjuk?', _gh),
    KpspQuestion(9, 'Jika anda menggelindingkan bola ke anak, apakah ia menggelindingkan/melemparkan kembali bola pada anda?', _gh),
    KpspQuestion(10, 'Apakah anak dapat memegang sendiri cangkir/gelas dan minum tanpa tumpah?', _sk),
  ]),

  // ---------------- 21 bulan ----------------
  const KpspForm(ageMonths: 21, questions: [
    KpspQuestion(1, 'Tanpa berpegangan, apakah anak dapat membungkuk untuk memungut mainan di lantai dan berdiri kembali?', _gk),
    KpspQuestion(2, 'Apakah anak dapat menunjukkan apa yang diinginkannya tanpa menangis/merengek (menunjuk, menarik, atau bersuara)?', _bb),
    KpspQuestion(3, 'Apakah anak dapat berjalan di sepanjang ruangan tanpa jatuh atau terhuyung-huyung?', _gk),
    KpspQuestion(4, 'Apakah anak dapat mengambil benda kecil seperti kacang/kismis dengan ibu jari dan jari telunjuk?', _gh),
    KpspQuestion(5, 'Jika anda menggelindingkan bola ke anak, apakah ia menggelindingkan/melemparkan kembali bola pada anda?', _gh),
    KpspQuestion(6, 'Apakah anak dapat memegang sendiri cangkir/gelas dan minum tanpa tumpah?', _sk),
    KpspQuestion(7, 'Jika anda sedang melakukan pekerjaan rumah tangga, apakah anak meniru apa yang anda lakukan?', _sk),
    KpspQuestion(8, 'Apakah anak dapat meletakkan satu kubus di atas kubus yang lain tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(9, 'Apakah anak dapat mengucapkan paling sedikit 3 kata yang mempunyai arti selain "papa" dan "mama"?', _bb),
    KpspQuestion(10, 'Apakah anak dapat berjalan mundur 5 langkah atau lebih tanpa kehilangan keseimbangan?', _gk),
  ]),

  // ---------------- 24 bulan ----------------
  const KpspForm(ageMonths: 24, questions: [
    KpspQuestion(1, 'Jika anda sedang melakukan pekerjaan rumah tangga, apakah anak meniru apa yang anda lakukan?', _sk),
    KpspQuestion(2, 'Apakah anak dapat meletakkan 1 kubus di atas kubus yang lain tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(3, 'Apakah anak dapat mengucapkan paling sedikit 3 kata yang mempunyai arti selain "papa" dan "mama"?', _bb),
    KpspQuestion(4, 'Apakah anak dapat berjalan mundur 5 langkah atau lebih tanpa kehilangan keseimbangan?', _gk),
    KpspQuestion(5, 'Dapatkah anak melepas pakaiannya seperti baju, rok, atau celana (topi & kaos kaki tidak dinilai)?', _sk),
    KpspQuestion(6, 'Dapatkah anak berjalan naik tangga sendiri (tegak/berpegangan dinding atau pegangan tangga)?', _gk),
    KpspQuestion(7, 'Tanpa bantuan, dapatkah anak menunjuk dengan benar paling sedikit satu bagian badannya (rambut, mata, hidung, mulut, dll)?', _bb),
    KpspQuestion(8, 'Dapatkah anak makan nasi sendiri tanpa banyak tumpah?', _sk),
    KpspQuestion(9, 'Dapatkah anak membantu memungut mainannya sendiri atau membantu mengangkat piring jika diminta?', _sk),
    KpspQuestion(10, 'Dapatkah anak menendang bola kecil (sebesar bola tenis) ke depan tanpa berpegangan? Mendorong tidak dinilai.', _gk),
  ]),

  // ---------------- 30 bulan ----------------
  const KpspForm(ageMonths: 30, questions: [
    KpspQuestion(1, 'Dapatkah anak melepas pakaiannya seperti baju, rok, atau celana (topi & kaos kaki tidak dinilai)?', _sk),
    KpspQuestion(2, 'Dapatkah anak berjalan naik tangga sendiri (tegak/berpegangan dinding atau pegangan tangga)?', _gk),
    KpspQuestion(3, 'Tanpa bantuan, dapatkah anak menunjuk dengan benar paling sedikit satu bagian badannya?', _bb),
    KpspQuestion(4, 'Dapatkah anak makan nasi sendiri tanpa banyak tumpah?', _sk),
    KpspQuestion(5, 'Dapatkah anak membantu memungut mainannya sendiri atau membantu mengangkat piring jika diminta?', _sk),
    KpspQuestion(6, 'Dapatkah anak menendang bola kecil (sebesar bola tenis) ke depan tanpa berpegangan? Mendorong tidak dinilai.', _gk),
    KpspQuestion(7, 'Bila diberi pensil, apakah anak mencoret-coret kertas tanpa bantuan/petunjuk?', _gh),
    KpspQuestion(8, 'Dapatkah anak meletakkan 4 kubus satu per satu di atas kubus yang lain tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(9, 'Dapatkah anak menggunakan 2 kata saat berbicara seperti "minta minum", "mau tidur"? ("Terima kasih"/"Dada" tidak dinilai)', _bb),
    KpspQuestion(10, 'Apakah anak dapat menyebut 2 di antara gambar-gambar (mis. bola, kucing, dll) tanpa bantuan?', _bb),
  ]),

  // ---------------- 36 bulan ----------------
  const KpspForm(ageMonths: 36, questions: [
    KpspQuestion(1, 'Bila diberi pensil, apakah anak mencoret-coret kertas tanpa bantuan/petunjuk?', _gh),
    KpspQuestion(2, 'Dapatkah anak meletakkan 4 kubus satu per satu di atas kubus yang lain tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(3, 'Dapatkah anak menggunakan 2 kata saat berbicara seperti "minta minum", "mau tidur"? ("Terima kasih"/"Dada" tidak dinilai)', _bb),
    KpspQuestion(4, 'Apakah anak dapat menyebut 2 di antara gambar-gambar tanpa bantuan?', _bb),
    KpspQuestion(5, 'Dapatkah anak melempar bola lurus ke arah perut atau dada anda dari jarak 1,5 meter?', _gk),
    KpspQuestion(6, 'Ikuti perintah tanpa isyarat: "Letakkan kertas ini di lantai", "di kursi", "Berikan kertas ini kepada ibu". Dapatkah anak melaksanakan ketiganya?', _bb),
    KpspQuestion(7, 'Buat garis lurus ke bawah sepanjang minimal 2,5 cm. Suruh anak menggambar garis lain di sampingnya. Dapatkah ia menirunya?', _gh),
    KpspQuestion(8, 'Letakkan kertas seukuran buku di lantai. Apakah anak dapat melompati lebar kertas dengan kedua kaki bersamaan tanpa didahului lari?', _gk),
    KpspQuestion(9, 'Dapatkah anak mengenakan sepatunya sendiri?', _sk),
    KpspQuestion(10, 'Dapatkah anak mengayuh sepeda roda tiga sejauh sedikitnya 3 meter?', _gk),
  ]),

  // ---------------- 42 bulan ----------------
  const KpspForm(ageMonths: 42, questions: [
    KpspQuestion(1, 'Dapatkah anak mengenakan sepatunya sendiri?', _sk),
    KpspQuestion(2, 'Dapatkah anak mengayuh sepeda roda tiga sejauh sedikitnya 3 meter?', _gk),
    KpspQuestion(3, 'Setelah makan, apakah anak mencuci dan mengeringkan tangannya dengan baik sehingga anda tidak perlu mengulanginya?', _sk),
    KpspQuestion(4, 'Suruh anak berdiri satu kaki tanpa berpegangan (beri 3 kali kesempatan). Dapatkah ia mempertahankan keseimbangan 2 detik atau lebih?', _gk),
    KpspQuestion(5, 'Letakkan kertas seukuran buku di lantai. Apakah anak dapat melompati panjang kertas dengan kedua kaki bersamaan tanpa didahului lari?', _gk),
    KpspQuestion(6, 'Tanpa membantu/menyebut "lingkaran", suruh anak menggambar contoh lingkaran. Dapatkah anak menggambar lingkaran?', _gh),
    KpspQuestion(7, 'Dapatkah anak meletakkan 8 kubus satu per satu tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(8, 'Apakah anak dapat bermain petak umpet, ular naga, atau permainan lain di mana ia ikut bermain dan mengikuti aturan?', _sk),
    KpspQuestion(9, 'Dapatkah anak mengenakan celana panjang, kemeja, baju, atau kaos kaki tanpa dibantu (tidak termasuk kancing/gesper/ikat pinggang)?', _sk),
    KpspQuestion(10, 'Dapatkah anak menyebutkan nama lengkapnya tanpa dibantu?', _bb),
  ]),

  // ---------------- 48 bulan ----------------
  const KpspForm(ageMonths: 48, questions: [
    KpspQuestion(1, 'Dapatkah anak mengayuh sepeda roda tiga sejauh sedikitnya 3 meter?', _gk),
    KpspQuestion(2, 'Setelah makan, apakah anak mencuci dan mengeringkan tangannya dengan baik sehingga anda tidak perlu mengulanginya?', _sk),
    KpspQuestion(3, 'Suruh anak berdiri satu kaki tanpa berpegangan (beri 3 kali kesempatan). Dapatkah ia mempertahankan keseimbangan 2 detik atau lebih?', _gk),
    KpspQuestion(4, 'Letakkan kertas seukuran buku di lantai. Apakah anak dapat melompati panjang kertas dengan kedua kaki bersamaan tanpa didahului lari?', _gk),
    KpspQuestion(5, 'Tanpa membantu/menyebut "lingkaran", suruh anak menggambar contoh lingkaran. Dapatkah anak menggambar lingkaran?', _gh),
    KpspQuestion(6, 'Dapatkah anak meletakkan 8 kubus satu per satu tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(7, 'Apakah anak dapat bermain petak umpet, ular naga, atau permainan lain di mana ia ikut bermain dan mengikuti aturan?', _sk),
    KpspQuestion(8, 'Dapatkah anak mengenakan celana panjang, kemeja, baju, atau kaos kaki tanpa dibantu (tidak termasuk kancing/gesper/ikat pinggang)?', _sk),
    KpspQuestion(9, 'Dapatkah anak menyebutkan nama lengkapnya tanpa dibantu?', _bb),
    KpspQuestion(10, 'Tanpa bantuan, apakah anak dapat mengancingkan bajunya atau pakaian boneka?', _gh),
  ]),

  // ---------------- 54 bulan ----------------
  const KpspForm(ageMonths: 54, questions: [
    KpspQuestion(1, 'Dapatkah anak meletakkan 8 kubus satu per satu tanpa menjatuhkannya (kubus 2,5-5 cm)?', _gh),
    KpspQuestion(2, 'Apakah anak dapat bermain petak umpet, ular naga, atau permainan lain di mana ia ikut bermain dan mengikuti aturan?', _sk),
    KpspQuestion(3, 'Dapatkah anak mengenakan celana panjang, kemeja, baju, atau kaos kaki tanpa dibantu (tidak termasuk kancing/gesper/ikat pinggang)?', _sk),
    KpspQuestion(4, 'Dapatkah anak menyebutkan nama lengkapnya tanpa dibantu?', _bb),
    KpspQuestion(5, 'Tanyakan: "Apa yang kamu lakukan jika kedinginan? jika lapar? jika lelah?" Jawab YA bila anak menjawab ketiganya dengan benar (bukan isyarat).', _bb),
    KpspQuestion(6, 'Apakah anak dapat mengancingkan bajunya atau pakaian boneka?', _gh),
    KpspQuestion(7, 'Suruh anak berdiri satu kaki tanpa berpegangan (3 kali kesempatan). Dapatkah ia mempertahankan keseimbangan 6 detik atau lebih?', _gk),
    KpspQuestion(8, 'Perlihatkan 2 garis. Tanyakan mana yang lebih panjang (ulangi dengan memutar lembar). Dapatkah anak menunjuk garis yang lebih panjang 3 kali dengan benar?', _gh),
    KpspQuestion(9, 'Suruh anak menggambar meniru contoh (tanda silang/+) di kertas kosong, 3 kali kesempatan. Apakah anak dapat menggambar seperti contoh?', _gh),
    KpspQuestion(10, 'Ikuti perintah tanpa isyarat: "di atas lantai", "di bawah kursi", "di depan kamu", "di belakang kamu". Jawab YA hanya jika anak mengerti arti keempatnya.', _bb),
  ]),

  // ---------------- 60 bulan ----------------
  const KpspForm(ageMonths: 60, questions: [
    KpspQuestion(1, 'Tanyakan: "Apa yang kamu lakukan jika kedinginan? jika lapar? jika lelah?" Jawab YA bila anak menjawab ketiganya dengan benar (bukan isyarat).', _bb),
    KpspQuestion(2, 'Apakah anak dapat mengancingkan bajunya atau pakaian boneka?', _gh),
    KpspQuestion(3, 'Suruh anak berdiri satu kaki tanpa berpegangan (3 kali kesempatan). Dapatkah ia mempertahankan keseimbangan 6 detik atau lebih?', _gk),
    KpspQuestion(4, 'Perlihatkan 2 garis. Tanyakan mana yang lebih panjang (ulangi dengan memutar lembar). Dapatkah anak menunjuk garis yang lebih panjang 3 kali dengan benar?', _gh),
    KpspQuestion(5, 'Suruh anak menggambar meniru contoh di kertas kosong, 3 kali kesempatan. Apakah anak dapat menggambar seperti contoh?', _gh),
    KpspQuestion(6, 'Ikuti perintah tanpa isyarat: "di atas lantai", "di bawah kursi", "di depan kamu", "di belakang kamu". Jawab YA hanya jika anak mengerti arti keempatnya.', _bb),
    KpspQuestion(7, 'Apakah anak bereaksi tenang dan tidak rewel (tanpa menangis/menggelayut) saat anda meninggalkannya?', _sk),
    KpspQuestion(8, 'Tanpa menunjuk/membantu, katakan: "Tunjukkan segi empat merah/kuning/biru/hijau". Dapatkah anak menunjuk keempat warna dengan benar?', _bb),
    KpspQuestion(9, 'Suruh anak melompat dengan satu kaki beberapa kali tanpa berpegangan. Apakah ia dapat melompat 2-3 kali dengan satu kaki?', _gk),
    KpspQuestion(10, 'Dapatkah anak sepenuhnya berpakaian sendiri tanpa bantuan?', _sk),
  ]),

  // ---------------- 66 bulan ----------------
  const KpspForm(ageMonths: 66, questions: [
    KpspQuestion(1, 'Suruh anak menggambar meniru contoh di kertas kosong, 3 kali kesempatan. Apakah anak dapat menggambar seperti contoh?', _gh),
    KpspQuestion(2, 'Ikuti perintah tanpa isyarat: "di atas lantai", "di bawah kursi", "di depan kamu", "di belakang kamu". Jawab YA hanya jika anak mengerti arti keempatnya.', _bb),
    KpspQuestion(3, 'Apakah anak bereaksi tenang dan tidak rewel (tanpa menangis/menggelayut) saat anda meninggalkannya?', _sk),
    KpspQuestion(4, 'Tanpa menunjuk/membantu, katakan: "Tunjukkan segi empat merah/kuning/biru/hijau". Dapatkah anak menunjuk keempat warna dengan benar?', _bb),
    KpspQuestion(5, 'Suruh anak melompat dengan satu kaki beberapa kali tanpa berpegangan. Apakah ia dapat melompat 2-3 kali dengan satu kaki?', _gk),
    KpspQuestion(6, 'Dapatkah anak sepenuhnya berpakaian sendiri tanpa bantuan?', _sk),
    KpspQuestion(7, 'Suruh anak menggambar orang. Hitung bagian tubuh yang tergambar (pasangan dihitung satu). Dapatkah anak menggambar sedikitnya 3 bagian tubuh?', _gh),
    KpspQuestion(8, 'Pada gambar orang tersebut, dapatkah anak menggambar sedikitnya 6 bagian tubuh?', _gh),
    KpspQuestion(9, 'Lengkapi kalimat: "Jika kuda besar maka tikus ...", "Jika api panas maka es ...", "Jika ibu wanita maka ayah ...". Apakah anak menjawab benar (kecil, dingin, pria)?', _bb),
    KpspQuestion(10, 'Apakah anak dapat menangkap bola kecil sebesar bola tenis hanya dengan kedua tangannya? (Bola besar tidak dinilai)', _gk),
  ]),

  // ---------------- 72 bulan ----------------
  const KpspForm(ageMonths: 72, questions: [
    KpspQuestion(1, 'Tanpa menunjuk/membantu, katakan: "Tunjukkan segi empat merah/kuning/biru/hijau". Dapatkah anak menunjuk keempat warna dengan benar?', _bb),
    KpspQuestion(2, 'Suruh anak melompat dengan satu kaki beberapa kali tanpa berpegangan. Apakah ia dapat melompat 2-3 kali dengan satu kaki?', _gk),
    KpspQuestion(3, 'Dapatkah anak sepenuhnya berpakaian sendiri tanpa bantuan?', _sk),
    KpspQuestion(4, 'Suruh anak menggambar orang. Hitung bagian tubuh yang tergambar (pasangan dihitung satu). Dapatkah anak menggambar sedikitnya 3 bagian tubuh?', _gh),
    KpspQuestion(5, 'Pada gambar orang tersebut, dapatkah anak menggambar sedikitnya 6 bagian tubuh?', _gh),
    KpspQuestion(6, 'Lengkapi kalimat: "Jika kuda besar maka tikus ...", "Jika api panas maka es ...", "Jika ibu wanita maka ayah ...". Apakah anak menjawab benar (kecil, dingin, pria)?', _bb),
    KpspQuestion(7, 'Apakah anak dapat menangkap bola kecil sebesar bola tenis hanya dengan kedua tangannya? (Bola besar tidak dinilai)', _gk),
    KpspQuestion(8, 'Suruh anak berdiri satu kaki tanpa berpegangan (3 kali kesempatan). Dapatkah ia mempertahankan keseimbangan 11 detik atau lebih?', _gk),
    KpspQuestion(9, 'Suruh anak menggambar meniru contoh di kertas kosong, 3 kali kesempatan. Apakah anak dapat menggambar seperti contoh?', _gh),
    KpspQuestion(10, 'Tanyakan: "Sendok dibuat dari apa? Sepatu? Pintu?" Jawab YA bila anak menjawab ketiganya dengan benar.', _bb),
  ]),
];

/// Memuat semua form KPSP ke dalam KpspData.
void registerKpspForms() {
  if (KpspData.isLoaded) return;
  for (final f in _allForms) {
    KpspData.register(f);
  }
}

// Data 16 formulir KPSP (usia 3-72 bulan).
//
// Ditranskrip dari BUKU PEDOMAN SDIDTK Kemenkes RI 2022.
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
    KpspQuestion(1, 'Pada saat bayi terlentang, apakah masing-masing lengan dan tungkai bergerak dengan mudah? Jawab \'Tidak\' bila salah satu atau kedua tungkai atau lengan bayi bergerak tak terarah atau tak terkendali.', _gk),
    KpspQuestion(2, 'Jangan membuat suara apapun. Pada saat bayi terlentang apakah ia melihat dan menatap wajah Anda?', _sk),
    KpspQuestion(3, 'Pada saat Anda mengajak bayi berbicara dan tersenyum, apakah ia tersenyum kembali kepada Anda?', _sk),
    KpspQuestion(4, 'Apakah bayi dapat mengeluarkan suara-suara lain (mengoceh) selain menangis?', _bb),
    KpspQuestion(5, 'Apakah bayi suka tertawa keras walau tidak digelitik atau diraba-raba?', _bb),
    KpspQuestion(6, 'Ambil gulungan wool merah, lalu letakkan di atas wajah di depan mata bayi. Gerakkan wool dari samping kiri ke kanan kepala atau sebaliknya. Apakah ia dapat mengikuti gerakan Anda dengan menggerakkan kepalanya dari kanan atau kiri ke tengah?', _gh, imagePath: 'assets/kpsp/kpsp_3_6.png'),
    KpspQuestion(7, 'Ambil gulungan wool merah, lalu letakkan di atas wajah di depan mata bayi. Gerakkan wool dari samping kiri ke kanan kepala atau sebaliknya. Apakah ia dapat mengikuti gerakan Anda dengan menggerakkan kepalanya dari satu sisi hampir sampai pada sisi yang lain?', _gh, imagePath: 'assets/kpsp/kpsp_3_7.png'),
    KpspQuestion(8, 'Pada saat bayi tengkurap di alas yang datar, apakah ia dapat mengangkat kepalanya seperti pada gambar?', _gk, imagePath: 'assets/kpsp/kpsp_3_8.png'),
    KpspQuestion(9, 'Pada saat bayi tengkurap di alas yang datar, apakah ia dapat mengangkat kepalanya sehingga membentuk sudut 45˚ seperti pada gambar?', _gk, imagePath: 'assets/kpsp/kpsp_3_9.png'),
    KpspQuestion(10, 'Pada saat bayi tengkurap di alas yang datar, apakah ia dapat mengangkat kepalanya dengan tegak seperti pada gambar?', _gk, imagePath: 'assets/kpsp/kpsp_3_10.png'),
  ]),

  // ---------------- 6 bulan ----------------
  const KpspForm(ageMonths: 6, questions: [
    KpspQuestion(1, 'Bayi diposisikan terlentang. Ambil gulungan wool merah, letakkan di atas wajah di depan mata bayi. Gerakkan wool dari samping kiri ke kanan kepala. Apakah ia dapat mengikuti gerakan Anda dengan menggerakkan kepala sepenuhnya dari satu ke sisi yang lain?', _gh, imagePath: 'assets/kpsp/kpsp_6_1.png'),
    KpspQuestion(2, 'Pada posisi bayi terlentang, pegang kedua tangannya lalu tarik perlahan ke posisi duduk. Dapatkah bayi mempertahankan lehernya secara kaku seperti pada gambar? Jawab \'Tidak\' bila kepala bayi jatuh kembali seperti gambar.', _gk, imagePath: 'assets/kpsp/kpsp_6_2.png'),
    KpspQuestion(3, 'Ketika bayi tengkurap di alas yang datar, apakah ia dapat mengangkat dada dengan kedua lengannya sebagai penyangga seperti pada gambar?', _gk, imagePath: 'assets/kpsp/kpsp_6_3.png'),
    KpspQuestion(4, 'Bayi dipangku orang tua atau pengasuh. Dapatkah bayi mempertahankan posisi kepala dalam keadaan tegak dan stabil? Jawab \'Tidak\' bila kepala bayi cenderung jatuh ke kanan, kiri, atau ke dadanya.', _gk),
    KpspQuestion(5, 'Bayi dipangku orang tua atau pengasuh. Sentuhkan pensil di punggung tangan atau ujung jari bayi (jangan meletakkan di atas telapak tangan bayi). Apakah bayi dapat menggenggam pensil itu selama beberapa detik?', _gh, imagePath: 'assets/kpsp/kpsp_6_5.png'),
    KpspQuestion(6, 'Bayi dipangku orang tua atau pengasuh. Dapatkah bayi mengarahkan matanya pada benda kecil sebesar kacang, kismis atau uang logam? Jawab \'Tidak\' jika ia tidak dapat mengarahkan matanya.', _gh),
    KpspQuestion(7, 'Bayi dipangku orang tua atau pengasuh. Dapatkah bayi meraih mainan yang diletakkan agak jauh namun masih berada dalam jangkauan tangannya?', _gh),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, pernahkah bayi berbalik paling sedikit 2 kali, dari terlentang ke tengkurap atau sebaliknya?', _gk),
    KpspQuestion(9, 'Tanyakan kepada orang tua atau pengasuh, pernahkah bayi mengeluarkan suara gembira bernada tinggi atau memekik tetapi bukan menangis?', _bb),
    KpspQuestion(10, 'Tanyakan kepada orang tua atau pengasuh, pernahkah orang tua atau pengasuh melihat bayi tersenyum ketika melihat mainan yang lucu, gambar, atau binatang peliharaan pada saat ia bermain sendiri?', _sk),
  ]),

  // ---------------- 9 bulan ----------------
  const KpspForm(ageMonths: 9, questions: [
    KpspQuestion(1, 'Bayi dipangku orang tua atau pengasuh, Taruh kismis di atas meja. Dapatkah bayi memungut dengan tangannya benda-benda kecil seperti kismis, kacang-kacangan, potongan biskuit dengan gerakan miring atau menggerapai seperti gambar?', _gh, imagePath: 'assets/kpsp/kpsp_9_1.png'),
    KpspQuestion(2, 'Bayi dipangku orang tua atau pengasuh. Taruh 2 kubus di atas meja, buat agar bayi dapat memungut dan memegang kubus pada masing-masing tangannya. Dapatkah ia melakukannya?', _gh),
    KpspQuestion(3, 'Bayi dipangku orang tua atau pengasuh. Tarik perhatian bayi dengan memperlihatkan gulungan wool merah, kemudian jatuhkan ke lantai. Apakah bayi mencoba mencari benda tersebut, misalnya mencari di bawah meja atau di belakang kursi?', _gh),
    KpspQuestion(4, 'Bayi dipangku orang tua atau pengasuh. Letakkan suatu mainan yang diinginkan bayi di luar jangkauannya, apakah ia mencoba mendapatkan mainan dengan mengulurkan lengan atau badannya?', _sk),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah bayi menengok ke belakang seperti mendengar kedatangan seseorang pada saat bayi sedang bermain sendiri dan seseorang diam-diam datang berdiri di belakangnya? Suara keras tidak ikut dihitung. Jawab \'Ya\' hanya jika melihat reaksinya terhadap suara yang perlahan atau bisikan.', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mengatakan 2 suku kata yang sama, misalnya: "Ma-ma", "Da-da" atau "Pa-pa"? Jawab \'Ya\' bila ia dapat mengeluarkan salah satu suara tersebut.', _bb),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, apakah bayi dapat makan kue kering sendiri?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh apakah pernah melihat bayi memindahkan mainan atau kue kering dari satu tangan ke tangan yang lain? Benda-benda panjang seperti sendok atau kerincingan bertangkai tidak ikut dinilai.', _gh),
    KpspQuestion(9, 'Tanpa disangga oleh bantal, kursi atau dinding, dapatkah bayi duduk sendiri selama 60 detik?', _gk, imagePath: 'assets/kpsp/kpsp_9_9.png'),
    KpspQuestion(10, 'Jika Anda mengangkat bayi melalui ketiaknya ke posisi berdiri, dapatkah ia menyangga sebagian berat badan dengan kedua kakinya? Jawab \'Ya\' bila ia mencoba berdiri dan sebagian berat badan tertumpu pada kedua kakinya.', _gk),
  ]),

  // ---------------- 12 bulan ----------------
  const KpspForm(ageMonths: 12, questions: [
    KpspQuestion(1, 'Bayi dipangku orang tua atau pengasuh. Letakkan pensil di telapak tangan anak. Coba ambil pensil tersebut dengan perlahan-lahan. Apakah anak menggenggam pensil dengan erat dan Anda merasa kesulitan mendapatkan pensil itu kembali?', _gh),
    KpspQuestion(2, 'Bayi dipangku orang tua atau pengasuh. Letakkan kismis di atas meja. Dapatkah anak memungut dengan tangannya benda-benda kecil seperti kismis, kacang-kacangan, potongan biskuit dengan gerakan miring atau menggerapai seperti gambar?', _gh, imagePath: 'assets/kpsp/kpsp_12_2.png'),
    KpspQuestion(3, 'Bayi dipangku orang tua atau pengasuh. Berikan 2 kubus kepada bayi. Tanpa bantuan, apakah anak dapat mempertemukan 2 kubus kecil yang ia pegang?', _gh),
    KpspQuestion(4, 'Sebut 2-3 kata yang dapat ditiru oleh anak (tidak perlu kata-kata yang lengkap). Apakah ia mencoba meniru kata-kata tadi?', _bb),
    KpspQuestion(5, 'Tanyakan kepada ibu atau pengasuh, apakah anak dapat mengangkat badannya ke posisi berdiri tanpa bantuan?', _gk),
    KpspQuestion(6, 'Tanyakan kepada ibu atau pengasuh, apakah anak dapat duduk sendiri tanpa bantuan dari posisi tidur atau tengkurap?', _gk),
    KpspQuestion(7, 'Tanyakan kepada ibu atau pengasuh, apakah anak dapat memahami makna kata \'jangan\'?', _bb),
    KpspQuestion(8, 'Tanyakan kepada ibu atau pengasuh, apakah anak akan mencari atau terlihat mengharapkan muncul kembali jika ibu atau pengasuh bersembunyi di belakang sesuatu atau di pojok, kemudian muncul dan menghilang secara berulang-ulang di hadapan anak?', _sk),
    KpspQuestion(9, 'Tanyakan kepada ibu atau pengasuh, apakah anak dapat membedakan ibu atau pengasuh dengan orang yang belum ia kenal? Ia akan menunjukkan sikap malu-malu atau ragu-ragu pada saat permulaan bertemu dengan orang yang belum dikenalnya.', _sk),
    KpspQuestion(10, 'Berdirikan anak. Apakah anak dapat berdiri dengan berpegangan pada kursi atau meja selama 30 detik atau lebih?', _gk),
  ]),

  // ---------------- 15 bulan ----------------
  const KpspForm(ageMonths: 15, questions: [
    KpspQuestion(1, 'Bayi dipangku orang tua atau pengasuh. Berikan 2 kubus kepada anak. Tanpa bantuan, apakah anak dapat mempertemukan 2 kubus kecil yang ia pegang?', _gh),
    KpspQuestion(2, 'Bayi dipangku orang tua atau pengasuh. Berikan sebuah kubus dan cangkir. Apakah anak dapat memasukkan 1 kubus ke dalam cangkir?', _gh),
    KpspQuestion(3, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat berjalan dengan berpegangan?', _gk),
    KpspQuestion(4, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mengatakan \'papa\' ketika ia memanggil atau melihat ayahnya, atau mengatakan \'mama\' jika memanggil atau melihat ibunya? Jawab \'Ya\' bila anak mengatakan salah satu di antaranya.', _bb),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mengucapkan 1 kata yang bermakna selain \'mama\', \'papa\', atau nama panggilan orang?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat bertepuk tangan atau melambai-lambai tanpa bantuan? Jawab \'Tidak\' bila ia membutuhkan bantuan.', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat menunjukkan apa yang diinginkannya tanpa menangis atau merengek? Jawab \'Ya\' bila ia menunjuk, menarik atau mengeluarkan suara yang menyenangkan.', _sk),
    KpspQuestion(8, 'Coba berdirikan anak. Apakah anak dapat berdiri sendiri tanpa berpegangan selama 30 detik atau lebih?', _gk),
    KpspQuestion(9, 'Letakkan kubus di lantai, tanpa berpegangan atau menyentuh lantai, apakah anak dapat membungkuk untuk memungut kubus di lantai dan kemudian berdiri kembali?', _gk),
    KpspQuestion(10, 'Apakah anak dapat berjalan di sepanjang ruangan tanpa jatuh atau terhuyung-huyung?', _gk),
  ]),

  // ---------------- 18 bulan ----------------
  const KpspForm(ageMonths: 18, questions: [
    KpspQuestion(1, 'Bayi dipangku orang tua atau pengasuh. Berikan anak sebuah pensil dan kertas. Apakah anak dapat mencoret-coret kertas tanpa bantuan atau petunjuk?', _gh),
    KpspQuestion(2, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat menyebutkan sedikitnya 3 kata yang bermakna?', _bb),
    KpspQuestion(3, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat menunjukkan apa yang diinginkannya tanpa menangis atau merengek?', _sk),
    KpspQuestion(4, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat minum dari cangkir atau gelas sendiri tanpa banyak yang tumpah?', _sk),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah anak suka meniru bila ibu atau pengasuh sedang melakukan pekerjaan rumah tangga (merapikan mainan, menyapu, dll)?', _sk),
    KpspQuestion(6, 'Gelindingkan bola tenis ke arah anak. Apakah anak dapat menggelindingkan atau melempar bola tersebut kembali kepada Anda?', _gh),
    KpspQuestion(7, 'Letakkan kubus di lantai, tanpa berpegangan atau menyentuh lantai, apakah anak dapat membungkuk untuk memungut kubus di lantai dan kemudian berdiri kembali?', _gk),
    KpspQuestion(8, 'Minta anak untuk berjalan sepanjang ruangan. Dapatkah ia berjalan tanpa terhuyung-huyung atau terjatuh?', _gk),
    KpspQuestion(9, 'Dapatkah anak berjalan mundur minimal 5 langkah tanpa kehilangan keseimbangan?', _gk),
    KpspQuestion(10, 'Berikan anak perintah berikut ini dengan bantuan telunjuk atau isyarat: "Ambil kertas" "Ambil pensil" "Tutup pintu" Dapatkah anak melakukan perintah tersebut dengan bantuan telunjuk atau isyarat?', _bb),
  ]),

  // ---------------- 21 bulan ----------------
  const KpspForm(ageMonths: 21, questions: [
    KpspQuestion(1, 'Bayi dipangku orang tua atau pengasuh. Berikan anak sebuah pensil dan kertas. Apakah anak dapat mencoret-coret kertas tanpa bantuan atau petunjuk?', _gh),
    KpspQuestion(2, 'Bayi dipangku orang tua atau pengasuh. Minta anak untuk menyusun kubus. Apakah anak dapat menyusun 2 kubus?', _gh),
    KpspQuestion(3, 'Bayi dipangku orang tua atau pengasuh. Tunjukkan gambar di bawah pada anak dan minta ia untuk menunjuk gambar sesuai dengan yang Anda sebutkan namanya. Apakah anak dapat menunjuk minimal 1 gambar?', _bb, imagePath: 'assets/kpsp/kpsp_21_3.png'),
    KpspQuestion(4, 'Bayi dipangku orang tua atau pengasuh. Tanpa bimbingan, petunjuk, atau bantuan Anda, dapatkah anak menunjuk paling sedikit 1 bagian tubuhnya dengan benar (rambut, mata, hidung, mulut, atau bagian badan yang lain)?', _bb),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mengucapkan minimal 7 kata yang mempunyai arti (selain kata \'mama\' dan \'papa\')?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat minum dari cangkir atau gelas sendiri tanpa banyak yang tumpah?', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, apakah anak suka meniru bila ibu atau pengasuh sedang melakukan pekerjaan rumah tangga (merapikan mainan, menyapu, dll)?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat berlari tanpa terjatuh?', _gk),
    KpspQuestion(9, 'Letakkan kubus di lantai, tanpa berpegangan atau menyentuh lantai, apakah anak dapat membungkuk untuk memungut kubus di lantai dan kemudian berdiri kembali?', _gk),
    KpspQuestion(10, 'Dapatkah anak berjalan mundur minimal 5 langkah tanpa kehilangan keseimbangan?', _gk),
  ]),

  // ---------------- 24 bulan ----------------
  const KpspForm(ageMonths: 24, questions: [
    KpspQuestion(1, 'Bayi dipangku orang tua atau pengasuh. Berikan anak sebuah pensil dan kertas. Apakah anak dapat mencoret-coret kertas tanpa bantuan atau petunjuk?', _gh),
    KpspQuestion(2, 'Bayi dipangku orang tua atau pengasuh. Minta anak untuk menyusun kubus. Apakah anak dapat menyusun 4 kubus?', _gh),
    KpspQuestion(3, 'Bayi dipangku orang tua atau pengasuh. Tanpa bimbingan, petunjuk, atau bantuan Anda, dapatkah anak menunjuk paling sedikit 2 bagian tubuhnya dengan benar (rambut, mata, hidung, mulut, atau bagian badan yang lain)?', _bb),
    KpspQuestion(4, 'Tanyakan kepada orang tua atau pengasuh, apakah anak mampu menggabungkan 2 kata berbeda ketika berbicara, misalnya "Minum susu" atau "Main bola"? "Terima kasih" dan "Da-dah" tidak termasuk.', _bb),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat melepas pakaiannya seperti baju, rok, atau celana?', _sk),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat makan dengan menggunakan sendok sendiri tanpa banyak yang tumpah?', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat berlari tanpa terjatuh?', _gk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat berjalan naik tangga sendiri? Jawab \'Ya\' jika ia naik tangga dengan posisi tegak atau berpegangan pada dinding atau pegangan tangga. Jawab \'Tidak\' jika ia naik tangga dengan merangkak, orang tua tidak memperbolehkan anak naik tangga, atau anak harus berpegangan pada seseorang.', _gk),
    KpspQuestion(9, 'Letakkan bola tenis di depan kaki anak. Apakah ia dapat menendang ke depan tanpa berpegangan pada apapun?', _gk),
    KpspQuestion(10, 'Ikuti perintah dengan seksama. Jangan memberi isyarat dengan telunjuk atau mata pada saat memberikan perintah berikut ini: "Ambil kertas" "Ambil pensil" "Tutup pintu" Dapatkah anak melakukan perintah tersebut?', _bb),
  ]),

  // ---------------- 30 bulan ----------------
  const KpspForm(ageMonths: 30, questions: [
    KpspQuestion(1, 'Beri kubus di depan anak. Dapatkah anak menyusun 4 buah kubus menyerupai kereta api dengan cerobong asap (dicontohkan)?', _gh),
    KpspQuestion(2, 'Buat garis lurus ke bawah sepanjang sekurang-kurangnya 2,5 cm. Minta anak untuk menggambar garis lain di samping garis ini.', _gh, imagePath: 'assets/kpsp/kpsp_30_2.png'),
    KpspQuestion(3, 'Tanpa bimbingan, petunjuk, atau bantuan Anda, dapatkah anak menyebut 2 gambar di antara gambar-gambar di bawah dengan benar? Menyebut dengan suara binatang tidak ikut dinilai.', _bb, imagePath: 'assets/kpsp/kpsp_30_3.png'),
    KpspQuestion(4, 'Tanpa bimbingan, petunjuk, atau bantuan Anda, dapatkah anak menunjuk 4 gambar di antara gambar-gambar di atas ini dengan benar ketika Anda sebutkan namanya?', _bb, imagePath: 'assets/kpsp/kpsp_animals.jpeg'),
    KpspQuestion(5, 'Tanpa bimbingan, petunjuk, atau bantuan Anda, dapatkah anak menunjuk paling sedikit 6 bagian tubuhnya?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat memahami perintah yang terdiri dari 2 langkah, misalnya "Tolong ambil bola dan berikan kepada Ayah"?', _bb),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak berpakaian sendiri seperti baju, rok, celana (topi dan kaos kaki tidak ikut dinilai)?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak bermain peran, misalnya menyuapi boneka?', _sk),
    KpspQuestion(9, 'Letakkan bola tenis di depan kaki anak. Dapatkah anak menendang ke depan tanpa berpegangan pada apapun? Mendorong bola tidak ikut dinilai.', _gk),
    KpspQuestion(10, 'Minta anak untuk melompat atau mengangkat kedua kakinya pada saat bersamaan. Dapatkah ia melakukannya?', _gk),
  ]),

  // ---------------- 36 bulan ----------------
  const KpspForm(ageMonths: 36, questions: [
    KpspQuestion(1, 'Beri kubus di depan anak. Dapatkah anak menyusun 6 buah kubus satu persatu di atas kubus yang lain tanpa menjatuhkan kubus tersebut?', _gh),
    KpspQuestion(2, 'Buat garis lurus ke bawah sepanjang sekurang-kurangnya 2,5 cm. Minta anak untuk menggambar garis lain di samping garis ini.', _gh, imagePath: 'assets/kpsp/kpsp_36_2.png'),
    KpspQuestion(3, 'Tanpa bimbingan, petunjuk, atau bantuan Anda, dapatkah anak menyebut 4 gambar di antara gambar-gambar di bawah ini dengan benar? Menyebut dengan suara binatang tidak ikut dinilai.', _bb, imagePath: 'assets/kpsp/kpsp_36_3.png'),
    KpspQuestion(4, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat memahami perintah yang terdiri dari 2 langkah, misalnya "Tolong ambil bola dan berikan kepada Ayah"?', _bb),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah sebagian dari bicara anak dapat dipahami oleh orang asing (yang tidak bertemu setiap hari)?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak merangkai kalimat sederhana yang terdiri dari minimal 3 kata, misalnya "Aku makan roti" atau "Ibu minta susu"?', _bb),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak menggosok gigi dengan bantuan?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak mengenakan baju, celana, atau sepatu sendiri (tidak termasuk mengancing dan menali)?', _sk),
    KpspQuestion(9, 'Berikan kepada anak sebuah bola tenis. Minta ia untuk melemparkan ke arah dada Anda. Dapatkah anak melempar bola dengan lurus ke arah perut atau dada Anda dari jarak 1,5 meter?', _gk),
    KpspQuestion(10, 'Letakkan selembar kertas seukuran buku ini di atas lantai. Apakah anak dapat melompati bagian lebar kertas dengan mengangkat kedua kakinya secara bersamaan tanpa didahului lari?', _gk),
  ]),

  // ---------------- 42 bulan ----------------
  const KpspForm(ageMonths: 42, questions: [
    KpspQuestion(1, 'Buat garis lurus ke bawah sepanjang sekurang-kurangnya 2,5 cm. Minta anak untuk menggambar garis lain di samping garis ini.', _gh, imagePath: 'assets/kpsp/kpsp_42_1.png'),
    KpspQuestion(2, 'Beri kubus di depan anak. Dapatkah anak menyusun 8 buah kubus satu persatu di atas kubus yang lain tanpa menjatuhkannya?', _gh),
    KpspQuestion(3, 'Tunjukkan anak gambar di bawah ini dan tanyakan: "Mana yang dapat terbang?" "Mana yang dapat mengeong?" "Mana yang dapat bicara?" "Mana yang dapat menggonggong?" "Mana yang dapat meringkik?" Apakah anak dapat menunjuk 2 kegiatan yang sesuai?', _bb, imagePath: 'assets/kpsp/kpsp_42_3.png'),
    KpspQuestion(4, 'Tanyakan kepada anak pertanyaan berikut ini satu persatu: "Apa yang kamu lakukan bila kedinginan?" Jawaban: pakai jaket, pakai selimut "Apa yang kamu lakukan bila kamu kelelahan?" Jawaban: tidur, berbaring, istirahat "Apa yang kamu lakukan bila kamu merasa lapar?" Jawaban: makan "Apa yang kamu lakukan bila kamu merasa haus?" Jawaban: minum Apakah anak dapat menjawab 3 pertanyaan dengan benar tanpa gerakan dan isyarat?', _bb),
    KpspQuestion(5, 'Minta anak untuk menyebut 1 warna. Dapatkah anak menyebut 1 warna dengan benar?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mencuci tangannya sendiri dengan baik setelah makan?', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak menyebut nama teman bermain di luar rumah atau saudara yang tidak tinggal serumah?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak mengenakan kaos (T-shirt) tanpa dibantu?', _sk),
    KpspQuestion(9, 'Letakkan selembar kertas seukuran buku ini di atas lantai. Apakah anak dapat melompati bagian lebar kertas dengan mengangkat kedua kakinya secara bersamaan tanpa didahului lari?', _gk),
    KpspQuestion(10, 'Minta anak untuk berdiri 1 kaki tanpa berpegangan. Jika perlu tunjukkan caranya dan beri anak kesempatan sebanyak 3 kali. Dapatkah ia mempertahankan keseimbangan dalam waktu 1 detik atau lebih?', _gk),
  ]),

  // ---------------- 48 bulan ----------------
  const KpspForm(ageMonths: 48, questions: [
    KpspQuestion(1, 'Berikan contoh membuat jembatan dari 3 buah kubus, yaitu dengan meletakkan 2 kubus dengan sedikit jarak (kira kira satu jari), lalu letakkan balok ketiga di atas kedua balok sehingga terbentuk seperti jembatan. Minta anak untuk melakukan. Dapatkan anak melakukannya?', _gh, imagePath: 'assets/kpsp/kpsp_48_1.png'),
    KpspQuestion(2, 'Beri pensil dan kertas. Jangan membantu anak dan jangan menyebut lingkaran. Buatlah lingkaran di atas kertas tersebut. Minta anak menirunya. Dapatkah anak menggambar lingkaran?', _gh, imagePath: 'assets/kpsp/kpsp_48_2.png'),
    KpspQuestion(3, 'Tunjukkan anak gambar di bawah ini dan tanyakan: "Yang mana yang dapat terbang?" "Yang mana yang dapat mengeong?" "Yang mana yang dapat bicara?" "Yang mana yang dapat menggonggong?" "Yang mana yang dapat meringkik?" Apakah anak dapat menunjuk 2 kegiatan yang sesuai?', _bb, imagePath: 'assets/kpsp/kpsp_48_3.png'),
    KpspQuestion(4, 'Dapatkah anak menyebut nama lengkapnya tanpa dibantu? Jawab \'Tidak\' jika ia menyebut sebagian namanya atau ucapannya sulit dimengerti.', _bb),
    KpspQuestion(5, 'Mengenal konsep angka satu Letakkan 5 kubus di atas meja dan selembar kertas di samping kubus. Katakan kepada anak "Ambil 1 kubus dan letakkan di atas kertas". Setelah anak selesai meletakkan, tanyakan "Ada berapa banyak kubus di atas kertas?" Dapatkah anak melakukan dengan hanya mengambil satu kubus dan bisa menyebutkan "Satu"?', _bb),
    KpspQuestion(6, 'Tanyakan kepada anak pertanyaan di bawah satu persatu: "Apa kegunaan kursi?" Jawaban: untuk duduk "Apa kegunaan cangkir?" Jawaban: untuk minum "Apa kegunaan pensil?" Jawaban: untuk mencoret, menulis, menggambar Dapatkah anak menjawab ketiga pertanyaan terkait kegunaan benda tersebut dengan benar?', _bb),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak mengikuti peraturan permainan saat bermain dengan teman-temannya (misal: ular tangga, petak umpet, dll)?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak mengenakan kaos (T-shirt) tanpa dibantu?', _sk),
    KpspQuestion(9, 'Letakkan selembar kertas seukuran buku ini di atas lantai. Apakah anak dapat melompati bagian lebar kertas dengan mengangkat kedua kakinya secara bersamaan tanpa didahului lari?', _gk),
    KpspQuestion(10, 'Minta anak untuk berdiri 1 kaki tanpa berpegangan. Jika perlu tunjukkan caranya dan beri anak kesempatan sebanyak 3 kali. Dapatkah ia mempertahankan keseimbangan dalam waktu 2 detik atau lebih?', _gk),
  ]),

  // ---------------- 54 bulan ----------------
  const KpspForm(ageMonths: 54, questions: [
    KpspQuestion(1, 'Jangan mengoreksi atau membantu anak. Jangan menyebut kata "Lebih panjang". Perlihatkan gambar kedua garis ini pada anak. Tanyakan: "Mana garis yang lebih panjang?" Minta anak menunjuk garis yang lebih panjang. Setelah anak menunjuk, putar lembar ini dan ulangi pertanyaan tersebut. Apakah anak dapat menunjuk garis yang lebih panjang sebanyak 3 kali dengan benar?', _gh, imagePath: 'assets/kpsp/kpsp_54_1.png'),
    KpspQuestion(2, 'Jangan membantu anak dan jangan memberitahu nama gambar ini. Minta anak untuk menggambar seperti contoh di kertas kosong yang tersedia. Berikan 3 kali kesempatan. Apakah anak dapat menggambar + seperti contoh di bawah?', _gh, imagePath: 'assets/kpsp/kpsp_54_2.png'),
    KpspQuestion(3, 'Berikan anak pensil dan kertas lalu katakan kepada anak "Buatlah gambar orang" (anak laki-laki, anak perempuan, papa, mama, dll). Jangan memberi perintah lebih dari itu. Jangan bertanya atau mengingatkan anak bila ada bagian yang belum tergambar. Dalam memberi nilai, hitunglah berapa bagian tubuh yang tergambar. Untuk bagian tubuh yang berpasangan seperti mata, telinga, lengan, dan kaki, setiap pasang dinilai 1 bagian. Pastikan anak telah menyelesaikan gambar sebelum memberikan penilaian. Dapatkah anak menggambar orang dengan sedikitnya 3 bagian tubuh? Jawaban \'Ya\': Jawaban \'Tidak\':', _gh, imagePath: 'assets/kpsp/kpsp_54_3.png'),
    KpspQuestion(4, 'Memahami konsep 2 warna Minta anak untuk menyebutkan 2 warna. Dapatkah anak menyebut 2 warna dengan benar?', _bb),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah bicara anak mampu dipahami seluruhnya oleh orang lain (yang tidak bertemu setiap hari)?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak mengikuti peraturan permainan saat bermain dengan teman- temannya (misal: ular tangga, petak umpet, dll)?', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak menggosok gigi tanpa dibantu?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mengancingkan bajunya atau pakaian boneka?', _sk),
    KpspQuestion(9, 'Mengenal konsep 2 kata depan Minta anak untuk mengikuti perintah di bawah, jangan memberi isyarat. "Ambil benda (misalnya kertas, balok) dan letakkan di atas meja" "Ambil benda (misalnya kertas, balok) dan letakkan di bawah meja" "Ambil benda (misalnya kertas, balok) dan letakkan di depan ibu" "Ambil benda (misalnya kertas, balok) dan letakkan di samping ibu" "Ambil benda (misalnya kertas, balok) dan letakkan di belakang ibu" Dapatkah anak melakukan sedikitnya 2 perintah (memahami 2 kata depan)?', _bb),
    KpspQuestion(10, 'Minta anak untuk berdiri 1 kaki tanpa berpegangan. Jika perlu tunjukkan caranya dan beri anak kesempatan sebanyak 3 kali. Dapatkah ia mempertahankan keseimbangan dalam waktu 2 detik atau lebih?', _gk),
  ]),

  // ---------------- 60 bulan ----------------
  const KpspForm(ageMonths: 60, questions: [
    KpspQuestion(1, 'Perlihatkan gambar kedua garis ini pada anak. Tanyakan: "Mana garis yang lebih panjang?" Minta anak menunjuk garis yang lebih panjang. Setelah anak menunjuk, putar lembar ini dan ulangi pertanyaan tersebut. Apakah anak dapat menunjuk garis yang lebih panjang sebanyak 3 kali dengan benar?', _gh, imagePath: 'assets/kpsp/kpsp_60_1.png'),
    KpspQuestion(2, 'Berikan anak pensil dan kertas lalu katakan kepada anak "Buatlah gambar orang" (anak laki-laki, anak perempuan, papa, mama, dll). Jangan memberi perintah lebih dari itu. Jangan bertanya atau mengingatkan anak bila ada bagian yang belum tergambar. Dalam memberi nilai, hitunglah berapa bagian tubuh yang tergambar. Untuk bagian tubuh yang berpasangan seperti mata, telinga, lengan dan kaki, setiap pasang dinilai 1 bagian. Pastikan anak telah menyelesaikan gambar sebelum memberikan penilaian. Dapatkah anak menggambar orang dengan sedikitnya 3 bagian tubuh? Jawaban \'Ya\': Jawaban \'Tidak\':', _gh, imagePath: 'assets/kpsp/kpsp_60_2.png'),
    KpspQuestion(3, 'Memahami konsep 4 warna Minta anak untuk menyebutkan 4 warna. Dapatkah anak menyebut keempat warna tersebut dengan benar?', _bb),
    KpspQuestion(4, 'Tanyakan kepada anak pertanyaan berikut ini satu persatu: "Apa yang kamu lakukan saat kedinginan?" Jawaban: pakai jaket, pakai selimut "Apa yang kamu lakukan saat kelelahan?" Jawaban: tidur, berbaring, istirahat "Apa yang kamu lakukan saat merasa lapar?" Jawaban: makan "Apa yang kamu lakukan saat merasa haus?" Jawaban: minum Dapatkah anak menjawab 3 pertanyaan terkait kata sifat tersebut dengan benar?', _bb),
    KpspQuestion(5, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat mengancingkan bajunya atau pakaian boneka?', _sk),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak bereaksi dengan tenang dan tidak rewel (tanpa menangis atau menggelayut) pada saat ditinggal oleh orang tua atau pengasuh?', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak sepenuhnya berpakaian sendiri tanpa dibantu?', _sk),
    KpspQuestion(8, 'Mengenal konsep 4 kata depan Minta anak untuk mengikuti perintah di bawah, jangan memberi isyarat: "Ambil benda (misalnya kertas, balok) dan letakkan di atas meja" "Ambil benda (misalnya kertas, balok) dan letakkan di bawah meja" "Ambil benda (misalnya kertas, balok) dan letakkan di depan ibu" "Ambil benda (misalnya kertas, balok) dan letakkan di samping ibu" "Ambil benda (misalnya kertas, balok) dan letakkan di belakang ibu" Dapatkah anak melakukan sedikitnya 4 perintah (memahami 4 kata depan)?', _bb),
    KpspQuestion(9, 'Minta anak untuk berdiri 1 kaki tanpa berpegangan. Jika perlu tunjukkan caranya dan beri anak kesempatan sebanyak 3 kali. Dapatkah ia mempertahankan keseimbangan dalam waktu 4 detik atau lebih?', _gk),
    KpspQuestion(10, 'Minta anak untuk melompat dengan 1 kaki beberapa kali tanpa berpegangan (lompatan dengan 2 kaki tidak ikut dinilai). Dapatkah anak melompat 2-3 kali dengan 1 kaki?', _gk),
  ]),

  // ---------------- 66 bulan ----------------
  const KpspForm(ageMonths: 66, questions: [
    KpspQuestion(1, 'Menggambar + Jangan membantu anak dan jangan memberitahu nama gambar ini. Minta anak untuk menggambar seperti contoh di kertas kosong yang tersedia. Berikan 3 kali kesempatan. Apakah anak dapat menggambar + seperti contoh di bawah?', _gh, imagePath: 'assets/kpsp/kpsp_66_1.png'),
    KpspQuestion(2, 'Menggambar kotak dengan dicontohkan Berikan kepada anak pensil dan kertas. Tunjukkan kepada anak contoh gambar di bawah. Anda bisa mencontohkan cara membuat kotak. Dapatkah anak menggambar kotak seperti contoh di bawah?', _gh, imagePath: 'assets/kpsp/kpsp_66_2.png'),
    KpspQuestion(3, 'Menggambar orang dengan sedikitnya 6 bagian tubuh Berikan anak pensil dan kertas lalu katakan kepada anak "Buatlah gambar orang" (anak laki-laki, anak perempuan, papa, mama, dll). Jangan memberi perintah lebih dari itu. Jangan bertanya atau mengingatkan anak bila ada bagian yang belum tergambar. Dalam memberi nilai, hitunglah berapa bagian tubuh yang tergambar. Untuk bagian tubuh yang berpasangan seperti mata, telinga, lengan dan kaki, setiap pasang dinilai 1 bagian. Pastikan anak telah menyelesaikan gambar sebelum memberikan penilaian. Dapatkah anak menggambar orang dengan sedikitnya 6 bagian tubuh? Jawaban \'Ya\': Jawaban \'Tidak\':', _gh, imagePath: 'assets/kpsp/kpsp_66_3.png'),
    KpspQuestion(4, 'Mengetahui konsep angka 5 Letakkan 8 kubus di atas meja dan selembar kertas di samping kubus. Katakan kepada anak "Ambil 5 kubus dan letakkan di atas kertas". Setelah anak selesai meletakkan, tanyakan "Ada berapa banyak kubus di atas kertas?" Dapatkah anak melakukannya?', _bb),
    KpspQuestion(5, 'Memahami/mengartikan 5 kata Pastikan anak mendengar pemeriksa lalu katakan "Saya akan mengucapkan 1 kata dan saya ingin kamu menyebutkan apa arti kata itu". Setiap kata dapat diberikan sebanyak 3 kali bila perlu. Pemeriksa dapat mengatakan "Beritahu saya sesuatu tentang itu" tetapi jangan tanya apa kegunaannya. Tanyalah setiap kata dalam satu waktu. "Apakah bola itu?" "Apakah sungai itu?" "Apakah meja itu?" "Apakah mobil/motor itu?" "Apakah rumah itu?" "Apakah pisang itu?" "Apakah pintu itu?" "Apakah atap itu?" Anak dikatakan dapat mengartikan jika anak mengartikan yang sesuai dalam istilah: 1) kegunaan, 2) bentuk, 3) terbuat dari apa, 4) kategori umum. Dapatkah anak mengartikan 5 kata yang sesuai?', _bb),
    KpspQuestion(6, 'Mengetahui konsep analogi berlawanan Minta anak untuk melengkapi kalimat di bawah ini, jangan membantu kecuali mengulang pertanyaan: "Jika kuda besar, maka tikus...?" Jawaban: kecil "Jika api panas, maka es...?" Jawaban: dingin "Jika ibu seorang wanita, maka ayah seorang..." Jawaban: pria, laki- laki Apakah anak menjawab ketiga pertanyaan dengan benar?', _bb),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, apakah anak bereaksi dengan tenang dan tidak rewel (tanpa menangis atau menggelayut) pada saat ditinggal oleh orang tua atau pengasuh?', _sk),
    KpspQuestion(8, 'Tanyakan kepada orang tua atau pengasuh, dapatkah anak sepenuhnya berpakaian sendiri tanpa dibantu?', _sk),
    KpspQuestion(9, 'Minta anak untuk berdiri 1 kaki tanpa berpegangan. Jika perlu tunjukkan caranya dan beri anak kesempatan sebanyak 3 kali. Dapatkah ia mempertahankan keseimbangan dalam waktu 6 detik atau lebih?', _gk),
    KpspQuestion(10, 'Apakah anak dapat menangkap bola kecil sebesar bola tenis atau bola kasti hanya dengan menggunakan kedua tangannya?', _gk),
  ]),

  // ---------------- 72 bulan ----------------
  const KpspForm(ageMonths: 72, questions: [
    KpspQuestion(1, 'Menggambar kotak tanpa dicontohkan Berikan kepada anak pensil dan kertas. Tunjukkan kepada anak contoh gambar di bawah. Tanpa menyebutkan nama dan tanpa mencontohkan atau menggerakkan jari telunjuk atau pensil untuk menunjukkan bagaimana cara menggambarnya, katakan kepada anak "Gambarlah yang seperti gambar ini". Lihat contoh di bawah untuk menilai gambar anak. Dapatkah anak menggambar kotak seperti contoh di bawah?', _gh, imagePath: 'assets/kpsp/kpsp_72_1.png'),
    KpspQuestion(2, 'Menggambar orang dengan sedikitnya 6 bagian tubuh Berikan anak pensil dan kertas lalu katakan kepada anak "Buatlah gambar orang" (anak laki-laki, anak perempuan, papa, mama, dll). Jangan memberi perintah lebih dari itu. Jangan bertanya atau mengingatkan anak bila ada bagian yang belum tergambar. Dalam memberi nilai, hitunglah berapa bagian tubuh yang tergambar. Untuk bagian tubuh yang berpasangan seperti mata, telinga, lengan dan kaki, setiap pasang dinilai 1 bagian. Pastikan anak telah menyelesaikan gambar sebelum memberikan penilaian. Dapatkah anak menggambar orang dengan sedikitnya 6 bagian tubuh? Jawaban \'Ya\': Jawaban \'Tidak\':', _gh, imagePath: 'assets/kpsp/kpsp_72_2.png'),
    KpspQuestion(3, 'Mengetahui konsep analogi berlawanan Minta anak untuk melengkapi kalimat di bawah ini, jangan membantu kecuali mengulang pertanyaan: "Jika kuda besar, maka tikus...?" Jawaban: kecil "Jika api panas, maka es...?" Jawaban: dingin "Jika ibu seorang wanita, maka ayah seorang..." Jawaban: pria, laki- laki "Jika pagi ada matahari, malam ada..." Jawaban: bulan Apakah anak menjawab ketiga pertanyaan dengan benar?', _bb),
    KpspQuestion(4, 'Memahami/mengartikan 7 kata Pastikan anak mendengar pemeriksa lalu katakan "Saya akan mengucapkan 1 kata dan saya ingin kamu menyebutkan apa arti kata itu". Setiap kata dapat diberikan sebanyak 3 kali bila perlu. Pemeriksa dapat mengatakan "Beritahu saya sesuatu tentang itu" tetapi jangan tanya apa kegunaannya. Tanyalah setiap kata dalam satu waktu. "Apakah bola itu?" "Apakah sungai itu?" "Apakah meja itu?" "Apakah mobil/motor itu?" "Apakah rumah itu?" "Apakah pisang itu?" "Apakah pintu itu?" "Apakah atap itu?" Anak dikatakan dapat mengartikan jika anak mengartikan yang sesuai dalam istilah: 1) kegunaan, 2) bentuk, 3) terbuat dari apa, 4) kategori umum. Dapatkah anak mengartikan 7 kata yang sesuai?', _bb),
    KpspQuestion(5, 'Mengetahui komposisi benda Isi titik-titik di bawah ini dengan jawaban anak. Jangan membantu kecuali mengulangi pertanyaan sampai 3 kali bila anak menanyakannya. "Sendok dibuat dari apa?" Jawaban: besi, baja, plastik, kayu "Sepatu dibuat dari apa?" Jawaban: kulit, karet, kain, plastik, kayu "Pintu dibuat dari apa?" Jawaban: kayu, besi, kaca Apakah anak dapat menjawab ketiga pertanyaan diatas dengan benar?', _bb),
    KpspQuestion(6, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat menggosok giginya tanpa bantuan?', _sk),
    KpspQuestion(7, 'Tanyakan kepada orang tua atau pengasuh, apakah anak dapat menyiapkan dan mengambil makanan tanpa bantuan, termasuk menggunakan mangkok, sendok, menuangkan makanan dan susu ke mangkok tanpa banyak tumpah? Jawab \'Ya\' jika anak dapat melakukannya, termasuk menuangkan susu dari beberapa jenis kotak atau wadah makanan.', _sk),
    KpspQuestion(8, 'Apakah anak dapat menangkap bola kecil sebesar bola tenis atau bola kasti hanya dengan menggunakan kedua tangannya?', _gk),
    KpspQuestion(9, 'Tunjukkan kepada anak bagaimana cara berjalan di garis lurus dengan menempatkan tumit dari 1 kaki di depan jari kaki lain. Berjalanlah 8 langkah, lalu minta anak untuk melakukannya. Berikan contoh dan kesempatan sebanyak 3 kali bila perlu. Dapatkah anak melakukannya sebanyak 4 langkah atau lebih dengan meletakkan tumit tidak lebih dari 2,5 cm dari jari kaki lain tanpa berpegangan?', _gk),
    KpspQuestion(10, 'Minta anak untuk berdiri 1 kaki tanpa berpegangan. Jika perlu tunjukkan caranya dan beri anak kesempatan sebanyak 3 kali. Dapatkah ia mempertahankan keseimbangan dalam waktu 11 detik atau lebih?', _gk),
  ]),

];

/// Memuat semua form KPSP ke dalam KpspData.
void registerKpspForms() {
  if (KpspData.isLoaded) return;
  for (final f in _allForms) {
    KpspData.register(f);
  }
}

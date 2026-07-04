import 'redleaf_model.dart';

/// Data Redleaf Milestones Checklist 100% lengkap dari buku "Developmental Milestones of Young Children" (Karen Petty, PhD).
final List<RedleafAgeGroup> redleafAgeGroups = [
  const RedleafAgeGroup(
    id: '0_12m',
    name: '0 - 12 Bulan',
    minAgeMonths: 0,
    maxAgeMonths: 12,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Refleks Rooting (Mencari Puting)',
            target: 'Target: Anak mampu menunjukkan Refleks Rooting (Mencari Puting).',
            parentTips: [
              'Sentuhkan pipi bayi dengan lembut untuk memicu refleks rooting saat menyusui.',
              'Jaga lingkungan yang tenang dan nyaman agar bayi tidak terlalu sering terkejut oleh suara keras.',
              'Perhatikan refleks bayi secara rutin dan konsultasikan ke dokter jika refleks tidak muncul.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bereaksi terhadap Suara Keras',
            target: 'Target: Anak mampu bereaksi terhadap Suara Keras.',
            parentTips: [
              'Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).',
              'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.',
              'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Bayi Terkejut atau Diam saat Mendengar Suara Keras',
            target: 'Target: Anak mampu bayi Terkejut atau Diam saat Mendengar Suara Keras.',
            parentTips: [
              'Sentuhkan pipi bayi dengan lembut untuk memicu refleks rooting saat menyusui.',
              'Jaga lingkungan yang tenang dan nyaman agar bayi tidak terlalu sering terkejut oleh suara keras.',
              'Perhatikan refleks bayi secara rutin dan konsultasikan ke dokter jika refleks tidak muncul.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mengangkat dan Menahan Kepala',
            target: 'Target: Anak mampu mengangkat dan Menahan Kepala.',
            parentTips: [
              'Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.',
              'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.',
              'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Membuat Gerakan Lengan Cepat dan Tersentak',
            target: 'Target: Anak mampu membuat Gerakan Lengan Cepat dan Tersentak.',
            parentTips: [
              'Biarkan lengan dan tangan bayi bebas bergerak (tidak dibedong terlalu ketat) untuk melatih koordinasi.',
              'Gantungkan mainan berwarna cerah yang aman di atas tempat tidur bayi agar ia tertarik meraih.',
              'Pastikan tangan bayi selalu bersih karena ia sering memasukkan tangan ke mulut sebagai eksplorasi.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Membawa Tangan ke Wajah',
            target: 'Target: Anak mampu membawa Tangan ke Wajah.',
            parentTips: [
              'Biarkan lengan dan tangan bayi bebas bergerak (tidak dibedong terlalu ketat) untuk melatih koordinasi.',
              'Gantungkan mainan berwarna cerah yang aman di atas tempat tidur bayi agar ia tertarik meraih.',
              'Pastikan tangan bayi selalu bersih karena ia sering memasukkan tangan ke mulut sebagai eksplorasi.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menggerakkan Kepala ke Kanan-Kiri saat Tengkurap',
            target: 'Target: Anak mampu menggerakkan Kepala ke Kanan-Kiri saat Tengkurap.',
            parentTips: [
              'Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.',
              'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.',
              'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Tersenyum pada Orang Asing',
            target: 'Target: Anak mampu tersenyum pada orang asing (belum menunjukkan kecemasan terhadap orang asing).',
            parentTips: [
              'Nikmati fase sosial ini karena bayi masih terbuka pada semua orang.',
              'Ajak bayi berinteraksi dengan berbagai orang dalam lingkungan yang aman.',
              'Perkenalkan bayi pada teman dan keluarga besar secara bertahap.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Berceloteh dan Tertawa untuk Menarik Perhatian',
            target: 'Target: Anak mampu berceloteh dan tertawa untuk menarik perhatian orang dewasa.',
            parentTips: [
              'Respons celoteh dan tawa bayi dengan antusias dan penuh perhatian.',
              'Ajak bayi bermain interaktif (cilukba, tepuk tangan) yang mengundang tawa.',
              'Berikan respons positif setiap kali bayi berusaha berkomunikasi melalui suara.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Membalas Senyuman dengan Senyuman',
            target: 'Target: Anak mampu membalas senyuman orang lain dengan senyuman.',
            parentTips: [
              'Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.',
              'Ajak bayi bermain ekspresi wajah (tersenyum, membuat mimik lucu) secara bergantian.',
              'Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Mengikuti Benda Bergerak dengan Mata',
            target: 'Target: Anak mampu mengikuti benda bergerak dengan mata.',
            parentTips: [
              'Gerakkan mainan berwarna cerah perlahan dari kiri ke kanan di depan mata bayi.',
              'Gunakan benda kontras tinggi (hitam-putih) untuk menarik perhatian visual bayi.',
              'Bertatap muka langsung dengan bayi dan gerakkan kepala perlahan agar bayi mengikuti.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Merespons Suara Keras',
            target: 'Target: Anak mampu merespons suara keras di sekitarnya.',
            parentTips: [
              'Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).',
              'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.',
              'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Menggenggam dan Memegang Benda Sebentar',
            target: 'Target: Anak mampu menggenggam dan memegang benda dalam waktu singkat.',
            parentTips: [
              'Berikan mainan yang aman untuk digenggam (kerincingan, mainan gigit, bola kecil empuk).',
              'Letakkan benda di dekat tangan bayi untuk memicu respons menggenggam.',
              'Latih kemampuan menggenggam bertahap dari benda besar ke benda kecil seiring pertumbuhannya.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Membawa Tangan ke Garis Tengah Tubuh saat Telentang',
            target: 'Target: Anak mampu membawa tangan ke garis tengah tubuh saat posisi telentang.',
            parentTips: [
              'Biarkan lengan dan tangan bayi bebas bergerak untuk melatih koordinasi tangan.',
              'Gantungkan mainan di atas bayi agar ia tertarik meraih ke arah tengah tubuhnya.',
              'Amati apakah bayi mulai mempertemukan kedua tangannya di depan dada sebagai tanda perkembangan.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Memutar Kepala ke Kiri-Kanan Tanpa Kepala Bergoyang',
            target: 'Target: Anak mampu memutar kepala ke kiri dan kanan tanpa kepala bergoyang.',
            parentTips: [
              'Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.',
              'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.',
              'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Menahan Kepala Tegak saat Digendong',
            target: 'Target: Anak mampu menahan kepala tegak dan stabil saat digendong.',
            parentTips: [
              'Gendong bayi dalam posisi tegak secara bertahap untuk melatih kekuatan otot leher.',
              'Pastikan selalu menopang kepala bayi saat mengangkat dan memindahkan posisinya.',
              'Perhatikan perkembangan kontrol kepala bayi dan konsultasikan ke dokter jika ada keterlambatan.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Bermain dengan Tangan dan Mengamati Mainan',
            target: 'Target: Anak mampu bermain dengan tangan dan memegang serta mengamati mainan.',
            parentTips: [
              'Berikan mainan yang ringan dan mudah digenggam agar bayi bisa mengamatinya.',
              'Biarkan bayi mengeksplorasi mainan dengan tangan dan mulutnya secara aman.',
              'Ajak bayi bermain dengan mainan berwarna cerah yang mengeluarkan bunyi lembut.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Meraih Benda-benda',
            target: 'Target: Anak mampu meraih benda-benda di sekitarnya.',
            parentTips: [
              'Letakkan mainan dalam jangkauan bayi untuk memotivasi gerakan meraih.',
              'Gantungkan mainan di atas tempat tidur bayi agar ia tertarik mengulurkan tangan.',
              'Berikan pujian saat bayi berhasil meraih benda untuk memperkuat motivasinya.',
            ],
          ),
          RedleafItem(
            number: 19,
            title: 'Mendorong Kaki ke Permukaan Keras saat Diletakkan',
            target: 'Target: Anak mampu mendorong kaki ke bawah saat kaki diletakkan di permukaan keras.',
            parentTips: [
              'Pegang bayi dalam posisi berdiri di pangkuan Anda agar ia bisa mendorong kakinya.',
              'Biarkan telapak kaki bayi menyentuh permukaan datar secara bertahap.',
              'Amati respons kaki bayi sebagai tanda kesiapan untuk menopang berat badan.',
            ],
          ),
          RedleafItem(
            number: 20,
            title: 'Refleks Rooting Mulai Berkurang atau Hilang',
            target: 'Target: Anak menunjukkan refleks rooting yang mulai berkurang atau hilang.',
            parentTips: [
              'Perhatikan bahwa berkurangnya refleks rooting adalah tanda perkembangan normal.',
              'Mulai perkenalkan pola makan yang lebih teratur seiring berkurangnya refleks ini.',
              'Konsultasikan ke dokter jika refleks masih sangat kuat di usia 4 bulan ke atas.',
            ],
          ),
          RedleafItem(
            number: 21,
            title: 'Mengikuti Benda Jauh dengan Mata',
            target: 'Target: Anak mampu mengikuti benda yang jauh dengan mata.',
            parentTips: [
              'Tunjukkan benda-benda menarik dari jarak yang semakin jauh secara bertahap.',
              'Ajak bayi melihat ke luar jendela atau ke taman untuk melatih penglihatan jarak jauh.',
              'Gerakkan benda berwarna cerah di berbagai jarak untuk merangsang fokus visual bayi.',
            ],
          ),
          RedleafItem(
            number: 22,
            title: 'Mengangkat Kepala saat Posisi Telentang',
            target: 'Target: Anak mampu mengangkat kepala saat posisi telentang.',
            parentTips: [
              'Ajak bayi bermain saat telentang dengan menunjukkan mainan di atas kepalanya.',
              'Latih otot leher bayi secara bertahap dengan sering berganti posisi (telentang dan tengkurap).',
              'Berikan waktu bermain di lantai yang cukup untuk memperkuat otot leher dan punggung.',
            ],
          ),
          RedleafItem(
            number: 23,
            title: 'Otot Leher Sudah Berkembang Kuat',
            target: 'Target: Anak menunjukkan otot leher yang sudah berkembang kuat.',
            parentTips: [
              'Berikan variasi posisi bermain (tengkurap, telentang, duduk ditopang) untuk memperkuat otot leher.',
              'Gendong bayi dalam posisi tegak secara bertahap untuk melatih kontrol kepala.',
              'Perhatikan milestone kontrol kepala dan konsultasikan jika ada keterlambatan.',
            ],
          ),
          RedleafItem(
            number: 24,
            title: 'Menopang Dada dengan Bertumpu pada Lengan Bawah',
            target: 'Target: Anak mampu menopang dada terangkat dengan bertumpu pada lengan bawah saat tengkurap.',
            parentTips: [
              'Berikan waktu tengkurap dan letakkan mainan di depan bayi agar ia termotivasi mengangkat dada.',
              'Bantu bayi memposisikan lengan bawahnya sebagai tumpuan saat tengkurap.',
              'Lakukan tummy time secara rutin 3-5 menit beberapa kali sehari untuk memperkuat otot lengan dan dada.',
            ],
          ),
          RedleafItem(
            number: 25,
            title: 'Berguling dari Tengkurap ke Samping',
            target: 'Target: Anak mampu berguling dari posisi tengkurap ke posisi menyamping.',
            parentTips: [
              'Berikan waktu tengkurap yang cukup dan letakkan mainan di samping bayi untuk memotivasi berguling.',
              'Bantu bayi berlatih berguling dengan lembut memegang pinggulnya dan membantu gerakan memutar.',
              'Pastikan area bermain aman dan empuk (gunakan matras atau selimut tebal) saat bayi berlatih berguling.',
            ],
          ),
          RedleafItem(
            number: 26,
            title: 'Berguling dari Tengkurap ke Telentang',
            target: 'Target: Anak mampu berguling dari posisi tengkurap ke posisi telentang.',
            parentTips: [
              'Letakkan mainan menarik di samping bayi saat tengkurap agar ia termotivasi berguling.',
              'Bantu dengan lembut gerakan pinggul bayi untuk mengajarkan pola berguling.',
              'Pastikan area bermain aman dan empuk saat bayi berlatih berguling.',
            ],
          ),
          RedleafItem(
            number: 27,
            title: 'Berguling dari Telentang ke Tengkurap',
            target: 'Target: Anak mampu berguling dari posisi telentang ke posisi tengkurap.',
            parentTips: [
              'Letakkan mainan di samping bayi saat telentang untuk memotivasi berguling ke arah tengkurap.',
              'Gerakkan mainan perlahan dari atas ke samping agar bayi terdorong memutar tubuhnya.',
              'Berikan alas empuk yang luas agar bayi bebas berlatih berguling dengan aman.',
            ],
          ),
          RedleafItem(
            number: 28,
            title: 'Berdiri dengan Bantuan/Pegangan',
            target: 'Target: Anak mampu berdiri dengan bantuan atau pegangan.',
            parentTips: [
              'Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.',
              'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.',
              'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.',
            ],
          ),
          RedleafItem(
            number: 29,
            title: 'Membawa Kaki ke Mulut saat Telentang',
            target: 'Target: Anak mampu membawa kaki ke mulut dengan mudah saat posisi telentang.',
            parentTips: [
              'Biarkan bayi bermain dengan kakinya secara bebas sebagai bentuk eksplorasi tubuh.',
              'Pastikan kaki bayi bersih karena ia senang memasukkan jari kaki ke mulut.',
              'Amati fleksibilitas dan koordinasi bayi sebagai tanda perkembangan motorik yang baik.',
            ],
          ),
          RedleafItem(
            number: 30,
            title: 'Memindahkan Benda dari Satu Tangan ke Tangan Lain',
            target: 'Target: Anak mampu memindahkan benda dari satu tangan ke tangan yang lain.',
            parentTips: [
              'Berikan mainan kecil yang aman untuk dipindah-pindahkan antar tangan.',
              'Ajak bayi bermain dengan dua mainan sekaligus agar ia berlatih memindahkan benda.',
              'Perhatikan perkembangan koordinasi tangan bayi sebagai tanda kematangan motorik halus.',
            ],
          ),
          RedleafItem(
            number: 31,
            title: 'Menggunakan Jari Kaki dan Tangan untuk Mendorong Maju',
            target: 'Target: Anak mampu menggunakan jari kaki dan tangan untuk mendorong tubuh maju atau berputar.',
            parentTips: [
              'Berikan permukaan lantai yang aman dan cukup luas agar bayi bisa bergerak bebas.',
              'Letakkan mainan sedikit di luar jangkauan untuk memotivasi bayi mendorong tubuhnya maju.',
              'Ikut bermain di lantai bersama bayi untuk memberi semangat dan contoh gerakan.',
            ],
          ),
          RedleafItem(
            number: 32,
            title: 'Mencoba Merangkak (Perut dan Kaki Masih Menyeret)',
            target: 'Target: Anak mampu mencoba merangkak meskipun perut dan kaki masih menyeret.',
            parentTips: [
              'Letakkan mainan favorit di depan bayi (sedikit di luar jangkauan) untuk memotivasi gerakan merangkak.',
              'Berikan permukaan yang aman untuk merangkak (matras, karpet, lantai yang bersih).',
              'Ikut merangkak bersama bayi sebagai contoh dan ajak bermain mengejar untuk memotivasi gerak.',
            ],
          ),
          RedleafItem(
            number: 33,
            title: 'Merangkak dengan Tangan dan Lutut',
            target: 'Target: Anak mampu merangkak dengan tangan dan lutut dari satu tempat ke tempat lain.',
            parentTips: [
              'Letakkan mainan favorit di depan bayi (sedikit di luar jangkauan) untuk memotivasi gerakan merangkak.',
              'Berikan permukaan yang aman untuk merangkak (matras, karpet, lantai yang bersih).',
              'Ikut merangkak bersama bayi sebagai contoh dan ajak bermain mengejar untuk memotivasi gerak.',
            ],
          ),
          RedleafItem(
            number: 34,
            title: 'Bergerak ke Posisi Duduk Sendiri',
            target: 'Target: Anak mampu bergerak ke posisi duduk secara mandiri.',
            parentTips: [
              'Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.',
              'Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.',
              'Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh.',
            ],
          ),
          RedleafItem(
            number: 35,
            title: 'Menggenggam Benda Kecil',
            target: 'Target: Anak mampu menggenggam benda-benda kecil dengan jari.',
            parentTips: [
              'Berikan benda kecil yang aman (sereal puff, potongan buah lembut) untuk latihan jemari.',
              'Awasi bayi dengan ketat saat bermain benda kecil untuk mencegah bahaya tersedak.',
              'Latih genggaman pincer (ibu jari dan telunjuk) dengan aktivitas memungut benda kecil.',
            ],
          ),
          RedleafItem(
            number: 36,
            title: 'Duduk Tanpa Bantuan',
            target: 'Target: Anak mampu duduk tanpa bantuan dengan stabil.',
            parentTips: [
              'Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.',
              'Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.',
              'Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh.',
            ],
          ),
          RedleafItem(
            number: 37,
            title: 'Dapat Ditarik ke Posisi Berdiri (Belum Bisa Menopang Sendiri)',
            target: 'Target: Anak dapat ditarik ke posisi berdiri namun belum bisa menopang tubuh sendiri.',
            parentTips: [
              'Pegang kedua tangan bayi dan bantu ia berdiri perlahan untuk melatih kekuatan kaki.',
              'Jangan memaksakan bayi berdiri terlalu lama jika ia belum siap menopang berat badan.',
              'Amati kesiapan kaki bayi dan lakukan latihan berdiri secara bertahap setiap hari.',
            ],
          ),
          RedleafItem(
            number: 38,
            title: 'Berdiri Sejenak Tanpa Pegangan',
            target: 'Target: Anak mampu berdiri sejenak tanpa pegangan.',
            parentTips: [
              'Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.',
              'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.',
              'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.',
            ],
          ),
          RedleafItem(
            number: 39,
            title: 'Berjalan dengan Bantuan',
            target: 'Target: Anak mampu berjalan dengan bantuan orang dewasa.',
            parentTips: [
              'Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.',
              'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.',
              'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.',
            ],
          ),
          RedleafItem(
            number: 40,
            title: 'Berjalan Sendiri Tanpa Bantuan',
            target: 'Target: Anak mampu berjalan sendiri tanpa bantuan di permukaan datar.',
            parentTips: [
              'Pastikan area berjalan anak aman dari benda tajam dan lantai tidak licin.',
              'Berikan pujian dan semangat setiap kali anak berhasil melangkah sendiri.',
              'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.',
            ],
          ),
          RedleafItem(
            number: 41,
            title: 'Grasps small items',
            target: 'Target: Anak mampu grasps small items.',
            parentTips: [
              'Berikan mainan yang aman untuk digenggam (kerincingan, mainan gigit, bola kecil empuk).',
              'Letakkan benda di dekat tangan bayi untuk memicu respons menggenggam.',
              'Latih kemampuan menggenggam bertahap dari benda besar ke benda kecil seiring pertumbuhannya.',
            ],
          ),
          RedleafItem(
            number: 42,
            title: 'Duduk Tanpa Bantuan',
            target: 'Target: Anak mampu duduk Tanpa Bantuan.',
            parentTips: [
              'Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.',
              'Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.',
              'Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh.',
            ],
          ),
          RedleafItem(
            number: 43,
            title: 'Mampu be pulled to feet but cant support self',
            target: 'Target: Anak mampu mampu be pulled to feet but cant support self.',
            parentTips: [
              'Sediakan ruang bermain yang aman dan luas untuk anak melatih kemampuan fisik dan motoriknya.',
              'Dampingi anak saat berlatih keterampilan baru dan berikan contoh gerakan yang benar.',
              'Berikan pujian atas setiap kemajuan motorik anak dan jangan memaksakan jika belum siap.',
            ],
          ),
          RedleafItem(
            number: 44,
            title: 'May stand momentarily without support',
            target: 'Target: Anak mampu may stand momentarily without support.',
            parentTips: [
              'Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.',
              'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.',
              'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.',
            ],
          ),
          RedleafItem(
            number: 45,
            title: 'Berjalan with assistance',
            target: 'Target: Anak mampu berjalan with assistance.',
            parentTips: [
              'Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.',
              'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.',
              'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.',
            ],
          ),
          RedleafItem(
            number: 46,
            title: 'Berjalan Sendiri',
            target: 'Target: Anak mampu berjalan Sendiri.',
            parentTips: [
              'Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.',
              'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.',
              'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mengeluarkan Suara Cooing sebagai Respons Bicara Orang Dewasa',
            target: 'Target: Anak mampu mengeluarkan suara cooing sebagai respons terhadap suara orang dewasa.',
            parentTips: [
              'Ajak bayi',
              'dengan menirukan suaranya dan menambahkan kata-kata baru.',
              'Respons setiap suara bayi dengan suara balik untuk merangsang komunikasi dua arah.',
              'Nyanyikan lagu-lagu lembut dan bacakan buku cerita untuk merangsang perkembangan bahasa.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menunjukkan sense of trust',
            target: 'Target: Anak mampu menunjukkan sense of trust.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.',
              'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.',
              'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menunjukkan attachment (responds positively) to significant adults',
            target: 'Target: Anak mampu menunjukkan attachment (responds positively) to significant adults.',
            parentTips: [
              'Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.',
              'Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.',
              'Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Membuat eye contact',
            target: 'Target: Anak mampu membuat eye contact.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Babies make kontak mata for several seconds with pengasuhnya',
            target: 'Target: Anak mampu babies make kontak mata for several seconds with pengasuhnya.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'One to Three Months',
            target: 'Target: Anak mampu one to Three Months.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.',
              'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.',
              'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mengeluarkan Suara Kuu (Cooing)',
            target: 'Target: Anak mampu mengeluarkan Suara Kuu (Cooing).',
            parentTips: [
              'Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.',
              'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.',
              'Ajak bayi \\',
              'dengan menirukan suaranya dan menambahkan kata-kata baru.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Smiles at the sound of suara yang dikenal',
            target: 'Target: Anak mampu smiles at the sound of suara yang dikenal.',
            parentTips: [
              'Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).',
              'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.',
              'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Tracks moving persons or objects',
            target: 'Target: Anak mampu tracks moving persons or objects.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Cries to demand attention',
            target: 'Target: Anak mampu cries to demand attention.',
            parentTips: [
              'Respons tangisan bayi/anak dengan segera dan tenang untuk membangun rasa aman.',
              'Kenali pola tangisan anak (lapar, mengantuk, tidak nyaman) dan tangani penyebabnya.',
              'Ajarkan anak mengenali dan mengekspresikan emosi dengan kata-kata sebagai pengganti tangisan/marah.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Smiles at strangers',
            target: 'Target: Anak mampu smiles at strangers.',
            parentTips: [
              'Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.',
              'Ajak bayi \\',
              'dengan suara lembut dan ekspresi wajah yang ramah.',
              'Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Infants do not fear strangers pada usia ini and often smile at unwajah yang dikenal',
            target: 'Target: Anak mampu infants do not fear strangers pada usia ini and often smile at unwajah yang dikenal.',
            parentTips: [
              'Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.',
              'Ajak bayi \\',
              'dengan suara lembut dan ekspresi wajah yang ramah.',
              'Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Melihat dan Mendengarkan dengan Tujuan',
            target: 'Target: Anak mampu melihat dan mendengarkan dengan tujuan tertentu.',
            parentTips: [
              'Ajak bayi mengamati benda dan suara di sekitarnya sambil menyebutkan nama benda tersebut.',
              'Berikan mainan yang mengeluarkan suara berbeda untuk merangsang pendengaran bayi.',
              'Respons perhatian bayi terhadap suara atau benda dengan antusiasme untuk memperkuat minatnya.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Membedakan Suara Orang-orang Penting',
            target: 'Target: Anak mampu membedakan suara orang-orang penting dan familiar di sekitarnya.',
            parentTips: [
              'Sering ajak bayi bicara dan nyanyikan lagu agar ia mengenali suara orang tua.',
              'Perhatikan respons bayi yang berbeda terhadap suara orang yang dikenal vs orang asing.',
              'Ajak anggota keluarga dekat sering berbicara dan bermain dengan bayi.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Membedakan Nada Suara dan Emosi',
            target: 'Target: Anak mampu membedakan nada suara dan emosi yang disampaikan.',
            parentTips: [
              'Gunakan nada suara yang bervariasi saat berbicara dengan bayi (gembira, lembut, tegas).',
              'Perhatikan respons bayi terhadap berbagai nada suara Anda.',
              'Hindari nada suara keras atau marah di dekat bayi karena ia sudah bisa merasakan emosi.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Bermain Permainan dengan Orang Dewasa dan Anak Lebih Besar',
            target: 'Target: Anak mampu bermain permainan dengan orang dewasa dan anak yang lebih besar.',
            parentTips: [
              'Ajak bermain cilukba, tepuk tangan, dan permainan sederhana lainnya.',
              'Libatkan kakak atau saudara yang lebih besar dalam bermain bersama bayi.',
              'Respons tawa dan antusiasme bayi saat bermain untuk memperkuat interaksi sosial.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Mulai Merasa Cemas saat Berpisah dari Pengasuh (Separation Anxiety)',
            target: 'Target: Anak mulai menunjukkan kecemasan saat berpisah dari pengasuh utama.',
            parentTips: [
              'Berikan pelukan dan kata-kata menenangkan saat anak merasa cemas berpisah.',
              'Latih perpisahan singkat secara bertahap (titip ke nenek 15 menit, lalu bertahap lebih lama).',
              'Selalu ucapkan salam perpisahan singkat dan yakinkan anak bahwa Anda akan kembali.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Mulai Cemas terhadap Orang Asing (Stranger Anxiety)',
            target: 'Target: Anak mulai menunjukkan kecemasan di hadapan orang asing.',
            parentTips: [
              'Perkenalkan orang baru secara bertahap dengan kehadiran orang tua di samping anak.',
              'Jangan memaksa bayi berinteraksi dengan orang asing jika ia menunjukkan ketakutan.',
              'Pahami bahwa stranger anxiety adalah tanda perkembangan kognitif yang normal.',
            ],
          ),
          RedleafItem(
            number: 19,
            title: 'Bermain dengan Orang Lain dan Memulai Interaksi Sosial',
            target: 'Target: Anak mampu bermain dengan orang lain dan memulai interaksi sosial.',
            parentTips: [
              'Ajak bayi bermain permainan interaktif (cilukba, puk-puk, genggam-lepas).',
              'Respons setiap inisiatif bermain bayi dengan antusiasme dan tawa.',
              'Sediakan waktu bermain bersama secara rutin setiap hari.',
            ],
          ),
          RedleafItem(
            number: 20,
            title: 'Mengekspresikan Emosi melalui Gestur dan Ekspresi Wajah',
            target: 'Target: Anak mampu mengekspresikan emosi (senang, sedih, marah, terkejut) melalui gestur dan ekspresi wajah.',
            parentTips: [
              'Respons ekspresi emosi bayi dengan menamai emosi tersebut (',
              ').',
              'Tunjukkan berbagai ekspresi wajah pada bayi dan biarkan ia menirunya.',
              'Berikan respons yang konsisten terhadap emosi bayi untuk membangun kepercayaan.',
            ],
          ),
          RedleafItem(
            number: 21,
            title: 'Mengeksplorasi Lingkungan Sekitar',
            target: 'Target: Anak mampu mengeksplorasi lingkungan sekitarnya dengan aktif.',
            parentTips: [
              'Sediakan lingkungan yang aman untuk dieksplorasi bayi (baby-proofing rumah).',
              'Dampingi bayi saat mengeksplorasi dan biarkan ia menyentuh berbagai tekstur.',
              'Ajak bayi ke area baru (taman, halaman) untuk memperluas pengalaman eksplorasi.',
            ],
          ),
          RedleafItem(
            number: 22,
            title: 'Mulai feel anxiety on separation from orang dewasa yang dikenal (separation anxiety)',
            target: 'Target: Anak mampu mulai feel anxiety on separation from orang dewasa yang dikenal (separation anxiety).',
            parentTips: [
              'Berikan pelukan dan kata-kata menenangkan saat anak merasa takut atau cemas.',
              'Perkenalkan orang baru secara bertahap dengan kehadiran orang tua di samping anak.',
              'Latih perpisahan singkat secara bertahap (misal: titip ke nenek 15 menit, lalu bertahap lebih lama).',
            ],
          ),
          RedleafItem(
            number: 23,
            title: 'Explores environment',
            target: 'Target: Anak mampu explores environment.',
            parentTips: [
              'Dampingi anak saat berlatih explores environment.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Memahami bahwa Menangis Mendatangkan Kenyamanan',
            target: 'Target: Anak menunjukkan pemahaman bahwa menangis akan mendatangkan kenyamanan dari pengasuh.',
            parentTips: [
              'Respons tangisan bayi dengan segera untuk membangun rasa aman dan kepercayaan.',
              'Konsistensi dalam merespons kebutuhan bayi membantu perkembangan kognitif awal.',
              'Perhatikan pola tangisan bayi untuk memahami kebutuhannya (lapar, mengantuk, popok basah).',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mengeluarkan Suara Kuu (Cooing)',
            target: 'Target: Anak mampu mengeluarkan Suara Kuu (Cooing).',
            parentTips: [
              'Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.',
              'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.',
              'Ajak bayi \\',
              'dengan menirukan suaranya dan menambahkan kata-kata baru.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Makes squealing and gurgling sounds',
            target: 'Target: Anak mampu makes squealing and gurgling sounds.',
            parentTips: [
              'Dampingi anak saat berlatih makes squealing and gurgling sounds.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Tertawa Keras',
            target: 'Target: Anak mampu tertawa keras sebagai ekspresi kegembiraan.',
            parentTips: [
              'Ajak bayi bermain permainan yang mengundang tawa (cilukba, gelitik lembut).',
              'Respons tawa bayi dengan tawa dan ekspresi gembira untuk memperkuat interaksi.',
              'Ciptakan momen-momen menyenangkan yang membuat bayi tertawa setiap hari.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bereksperimen dengan Suara yang Lebih Panjang dan Bervariasi',
            target: 'Target: Anak mampu bereksperimen dengan vokalisasi yang lebih panjang dan bervariasi.',
            parentTips: [
              'Ajak bayi',
              'dengan menirukan suaranya dan menambah variasi baru.',
              'Nyanyikan lagu dengan nada naik-turun untuk merangsang variasi suara bayi.',
              'Berikan respons antusias terhadap setiap suara baru yang dikeluarkan bayi.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menggunakan Intonasi dalam Suara',
            target: 'Target: Anak mampu menggunakan intonasi (nada naik-turun) dalam suara yang dikeluarkan.',
            parentTips: [
              'Bicaralah pada bayi dengan intonasi yang bervariasi agar ia meniru pola suara.',
              'Bacakan buku cerita dengan ekspresi dan intonasi yang menarik.',
              'Perhatikan bagaimana bayi mulai meniru pola nada bicara orang dewasa.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Merespons saat Namanya Dipanggil',
            target: 'Target: Anak mampu merespons (menoleh/tersenyum) saat namanya dipanggil.',
            parentTips: [
              'Sering panggil nama bayi saat berbicara dan bermain dengannya.',
              'Pastikan memanggil nama bayi dengan nada hangat dan kontak mata langsung.',
              'Berikan respons positif (senyum, pelukan) saat bayi menoleh merespons namanya.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mengembangkan Kosakata Reseptif (Pemahaman Bahasa)',
            target: 'Target: Anak mampu mengembangkan kosakata reseptif dan memahami kata-kata yang didengar.',
            parentTips: [
              'Sebutkan nama benda-benda di sekitar saat beraktivitas (',
              ').',
              'Beri instruksi sederhana dan amati pemahaman bayi (',
              ').',
              'Bacakan buku bergambar sambil menunjuk dan menyebutkan nama benda di dalamnya.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Mengucapkan Setidaknya Satu Kata',
            target: 'Target: Anak mampu mengucapkan setidaknya satu kata yang bermakna.',
            parentTips: [
              'Sebutkan nama benda-benda di sekitar saat beraktivitas secara berulang.',
              'Respons upaya bicara anak dengan antusias dan ulangi kata yang benar tanpa menyalahkan.',
              'Ajak bernyanyi lagu-lagu sederhana yang mengulang kata-kata untuk memperkaya kosakata.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Menggunakan Gestur atau Menunjuk untuk Berkomunikasi',
            target: 'Target: Anak mampu menggunakan gestur atau menunjuk untuk berkomunikasi.',
            parentTips: [
              'Ajarkan isyarat sederhana (melambaikan tangan, menggeleng, mengangguk) dalam konteks sehari-hari.',
              'Respons saat anak menunjuk benda dengan menyebutkan nama benda tersebut.',
              'Gunakan gerakan tangan dan ekspresi wajah saat berbicara untuk memperkuat pemahaman bahasa.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Mendengarkan Lagu, Cerita, atau Sajak dengan Minat',
            target: 'Target: Anak mampu mendengarkan lagu, cerita, atau sajak dengan penuh minat.',
            parentTips: [
              'Bacakan buku cerita bergambar menarik secara rutin setiap hari.',
              'Nyanyikan lagu-lagu anak bersama dan ajak anak menghafal syair sederhana.',
              'Putar musik anak-anak dan perhatikan respons bayi terhadap irama dan melodi.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Meniru Suara-suara yang Didengar',
            target: 'Target: Anak mampu meniru suara-suara yang didengar dari lingkungan sekitarnya.',
            parentTips: [
              'Tirukan suara binatang dan benda (kucing: meong, mobil: brum-brum) dan ajak bayi menirunya.',
              'Ucapkan kata-kata sederhana dengan jelas dan perlahan agar bayi bisa mendengar dan menirunya.',
              'Berikan respons antusias saat bayi berhasil meniru suara baru.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Gestures or points to communicate',
            target: 'Target: Anak mampu gestures or points to communicate.',
            parentTips: [
              'Dampingi anak saat berlatih gestures or points to communicate.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Listens to songs, stories, or rhymes with interest',
            target: 'Target: Anak mampu listens to songs, stories, or rhymes with interest.',
            parentTips: [
              'Dampingi anak saat berlatih listens to songs, stories, or rhymes with interest.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Babies enjoy being read to and pay attention to played or sung music.',
            target: 'Target: Anak mampu babies enjoy being read to and pay attention to played or sung music..',
            parentTips: [
              'Dampingi anak saat berlatih babies enjoy being read to and pay attention to played or sung music..',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Imitates sounds',
            target: 'Target: Anak mampu imitates sounds.',
            parentTips: [
              'Dampingi anak saat berlatih imitates sounds.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan understanding that crying brings comfort',
            target: 'Target: Anak mampu menunjukkan understanding that crying brings comfort.',
            parentTips: [
              'Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.',
              'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.',
              'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Prefers black-and-white or high-contrast patterns',
            target: 'Target: Anak mampu prefers black-and-white or high-contrast patterns.',
            parentTips: [
              'Dampingi anak saat berlatih prefers black-and-white or high-contrast patterns.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengeksplorasi Lingkungan Sekitar',
            target: 'Target: Anak mampu mengeksplorasi Lingkungan Sekitar.',
            parentTips: [
              'Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).',
              'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.',
              'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menyadari Tangan dan Kaki sebagai Bagian Tubuhnya',
            target: 'Target: Anak mulai menyadari bahwa tangan dan kaki adalah bagian dari tubuhnya.',
            parentTips: [
              'Biarkan bayi menatap dan mengamati tangannya sendiri sebagai bentuk eksplorasi.',
              'Ajak bermain dengan jari-jari bayi sambil menyebutkan nama anggota tubuh.',
              'Kenakan kaos kaki berwarna cerah agar bayi tertarik memperhatikan kakinya.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Merespons Bayangan Sendiri di Cermin',
            target: 'Target: Anak mampu merespons bayangan dirinya sendiri di cermin.',
            parentTips: [
              'Letakkan cermin yang aman di dekat bayi saat bermain di lantai.',
              'Ajak bayi melihat cermin bersama sambil menyebutkan nama-nama bagian wajah.',
              'Perhatikan respons bayi (tersenyum, menyentuh cermin) sebagai tanda perkembangan kesadaran diri.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mengantisipasi Kejadian yang Akan Terjadi',
            target: 'Target: Anak mampu mengantisipasi kejadian yang akan terjadi (makan, mandi, tidur).',
            parentTips: [
              'Gunakan rutinitas harian yang konsisten agar bayi bisa memprediksi aktivitas berikutnya.',
              'Ceritakan kegiatan yang akan dilakukan sebelum memulai (',
              ').',
              'Perhatikan reaksi antisipasi bayi (tersenyum saat melihat botol susu) sebagai tanda kognitif.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Tertarik Memanipulasi Mainan dan Benda',
            target: 'Target: Anak menunjukkan ketertarikan untuk memanipulasi mainan dan benda di sekitarnya.',
            parentTips: [
              'Berikan mainan yang bisa ditekan, diputar, atau ditarik untuk merangsang eksplorasi.',
              'Biarkan bayi mengeksplorasi mainan dengan caranya sendiri (memutar, membalik, meremas).',
              'Berikan mainan dengan fungsi sebab-akibat (tekan tombol = suara) untuk merangsang pemahaman.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Menyelidiki Benda dengan Memukul, Mengguncang, dan Melempar',
            target: 'Target: Anak mampu menyelidiki benda dengan cara memukul, mengguncang, dan melempar.',
            parentTips: [
              'Berikan benda-benda yang aman untuk dipukul dan diguncang (kerincingan, drum mainan).',
              'Jangan melarang bayi melempar benda, tetapi sediakan benda yang aman untuk dilempar (bola busa).',
              'Dampingi bayi saat bermain dan ajarkan perbedaan benda yang boleh dan tidak boleh dilempar.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Tertarik pada Benda dengan Bagian Bergerak',
            target: 'Target: Anak menunjukkan ketertarikan pada benda yang memiliki bagian bergerak.',
            parentTips: [
              'Berikan mainan dengan roda, engsel, atau bagian yang bisa digerakkan.',
              'Ajak bayi mengamati benda bergerak (mobil-mobilan, kincir angin mainan) dan jelaskan gerakannya.',
              'Sediakan mainan bertekstur dan berlevel yang merangsang eksplorasi motorik halus.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Tertarik Bermain Permainan Sederhana',
            target: 'Target: Anak menunjukkan ketertarikan untuk bermain permainan sederhana.',
            parentTips: [
              'Ajak bermain cilukba, tepuk tangan, dan permainan interaktif sederhana lainnya.',
              'Bermain susun-bongkar balok atau memasukkan bola ke wadah bersama bayi.',
              'Respons antusiasme bayi saat bermain untuk memperkuat minat bermainnya.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Merespons Kata "Tidak"',
            target: 'Target: Anak mampu merespons kata "tidak" dari orang dewasa.',
            parentTips: [
              'Gunakan kata',
              'dengan nada tegas tapi lembut saat ada bahaya.',
              'Konsisten dalam memberikan batasan agar bayi memahami makna larangan.',
              'Alihkan perhatian bayi ke aktivitas yang aman setelah mengatakan',
              '.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Melambaikan Tangan (Da-da)',
            target: 'Target: Anak mampu melambaikan tangan sebagai isyarat perpisahan.',
            parentTips: [
              'Contohkan gerakan melambaikan tangan setiap kali berpisah atau menyapa.',
              'Ajak bayi melambaikan tangan saat orang keluar atau masuk rumah.',
              'Berikan pujian saat bayi berhasil melambaikan tangan sendiri.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Mencari Mainan yang Disembunyikan (Object Permanence)',
            target: 'Target: Anak mampu mencari mainan yang disembunyikan di bawah selimut atau di balik benda.',
            parentTips: [
              'Ajak bermain cilukba dengan menyembunyikan wajah di balik tangan atau kain.',
              'Sembunyikan mainan di bawah selimut dan ajak bayi mencarinya untuk melatih pemahaman objek permanen.',
              'Berikan pujian saat bayi berhasil menemukan mainan yang disembunyikan.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Gestures or points to communicate',
            target: 'Target: Anak mampu gestures or points to communicate.',
            parentTips: [
              'Ajarkan isyarat sederhana (melambaikan tangan, menggeleng, mengangguk) dalam konteks sehari-hari.',
              'Respons saat anak menunjuk benda dengan menyebutkan nama benda tersebut.',
              'Gunakan gerakan tangan dan ekspresi wajah saat berbicara untuk memperkuat pemahaman bahasa.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Mendengarkan to songs, stories, or rhymes with interest',
            target: 'Target: Anak mampu mendengarkan to songs, stories, or rhymes with interest.',
            parentTips: [
              'Bacakan buku cerita bergambar menarik secara rutin setiap hari.',
              'Ajak anak menceritakan kembali alur cerita yang didengarnya dengan bahasanya sendiri.',
              'Nyanyikan lagu-lagu anak bersama dan ajak anak menghafal syair sederhana.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Babies enjoy being read to and pay attention to played or sung music',
            target: 'Target: Anak mampu babies enjoy being read to and pay attention to played or sung music.',
            parentTips: [
              'Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.',
              'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.',
              'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Meniru sounds',
            target: 'Target: Anak mampu meniru sounds.',
            parentTips: [
              'Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).',
              'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.',
              'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Menunjukkan understanding that objects have purpose',
            target: 'Target: Anak mampu menunjukkan understanding that objects have purpose.',
            parentTips: [
              'Dampingi anak saat berlatih menunjukkan understanding that objects have purpose.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Rasa Ingin Tahu',
            target: 'Target: Anak menunjukkan rasa ingin tahu terhadap benda dan orang di sekitarnya.',
            parentTips: [
              'Berikan benda-benda baru dengan tekstur dan warna berbeda untuk dieksplorasi bayi.',
              'Respons rasa ingin tahu bayi dengan antusiasme dan menyebutkan nama benda yang diminatinya.',
              'Ajak bayi ke lingkungan baru secara berkala untuk merangsang rasa ingin tahunya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menunjukkan Ketekunan dalam Berusaha',
            target: 'Target: Anak menunjukkan ketekunan dalam berusaha mencapai sesuatu.',
            parentTips: [
              'Jangan langsung membantu bayi saat ia berusaha meraih benda — beri waktu untuk mencoba.',
              'Berikan dorongan verbal (',
              ') saat bayi berusaha melakukan sesuatu.',
              'Puji usaha bayi, bukan hanya hasilnya, untuk membangun semangat pantang menyerah.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengeksplorasi Lingkungan dengan Aktif',
            target: 'Target: Anak mampu mengeksplorasi lingkungan sekitar secara aktif.',
            parentTips: [
              'Sediakan lingkungan yang aman dan merangsang untuk dieksplorasi bayi.',
              'Dampingi bayi saat mengeksplorasi dan biarkan ia menyentuh berbagai benda aman.',
              'Ajak bayi ke area baru (taman, halaman) untuk memperluas pengalaman eksplorasi.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Sengaja Mencari dan Meraih Benda yang Menarik',
            target: 'Target: Anak mampu secara sengaja mencari dan meraih benda yang menarik perhatiannya.',
            parentTips: [
              'Letakkan benda menarik dalam jangkauan bayi untuk memotivasi gerakan meraih.',
              'Amati benda-benda yang menarik perhatian bayi sebagai tanda perkembangan preferensi.',
              'Berikan pujian saat bayi berhasil meraih benda yang diinginkan untuk memperkuat motivasi.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Infants choose and reach for desired toys, objects, or persons.',
            target: 'Target: Anak mampu infants choose and reach for desired toys, objects, or persons..',
            parentTips: [
              'Dampingi anak saat berlatih infants choose and reach for desired toys, objects, or persons..',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '1_year',
    name: '1 Tahun (12-24 Bulan)',
    minAgeMonths: 12,
    maxAgeMonths: 24,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Kelekatan pada Orang Tua atau Anggota Keluarga',
            target: 'Target: Anak menunjukkan tanda-tanda kelekatan pada orang tua atau anggota keluarga.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari (bermain, bercerita, memeluk).',
              'Tunjukkan kasih sayang melalui pelukan, ciuman, dan kata-kata pujian yang tulus.',
              'Libatkan anak dalam kegiatan keluarga bersama untuk memperkuat ikatan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bermain Sejajar (Parallel Play) dengan Teman Sebaya',
            target: 'Target: Anak bermain secara sejajar berdampingan dengan teman sebaya.',
            parentTips: [
              'Ajak anak bermain bersama teman sebaya di rumah atau taman secara rutin.',
              'Pahami bahwa bermain sejajar (di samping teman tapi belum berinteraksi) adalah hal normal di usia ini.',
              'Dampingi anak saat bermain bersama dan bantu jika ada konflik.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mulai Meniru Kakak atau Teman Sebaya',
            target: 'Target: Anak mulai meniru perilaku kakak atau teman sebayanya.',
            parentTips: [
              'Berikan kesempatan anak berinteraksi dengan kakak atau anak yang lebih besar.',
              'Awasi agar perilaku yang ditiru adalah perilaku positif.',
              'Puji anak saat meniru perilaku baik seperti berbagi atau membantu.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mulai Bercanda dengan Orang Dewasa',
            target: 'Target: Anak mulai menunjukkan tanda-tanda bercanda dengan orang dewasa.',
            parentTips: [
              'Respons humor anak dengan tertawa dan antusiasme.',
              'Ajak bermain permainan lucu seperti cilukba atau membuat ekspresi konyol.',
              'Nikmati momen humor bersama anak untuk memperkuat ikatan emosional.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Berbagi Mainan atau Barang Miliknya',
            target: 'Target: Anak mampu berbagi mainan atau barang miliknya dengan orang lain.',
            parentTips: [
              'Contohkan perilaku berbagi dalam kehidupan sehari-hari.',
              'Ajak bermain permainan yang membutuhkan giliran untuk melatih berbagi.',
              'Berikan pujian spesifik saat anak berhasil berbagi dengan teman.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Memahami Makna Kata "Tidak"',
            target: 'Target: Anak memahami makna kata "tidak" dari orang dewasa.',
            parentTips: [
              'Gunakan kata',
              'secara konsisten dan tegas namun lembut.',
              'Jelaskan alasan di balik larangan dengan bahasa sederhana.',
              'Alihkan perhatian anak ke aktivitas yang diperbolehkan setelah melarang.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mulai Berani Berpisah dari Pengasuh',
            target: 'Target: Anak mulai berani memulai perpisahan singkat dari pengasuh.',
            parentTips: [
              'Dorong kemandirian anak dengan membiarkannya bermain sendiri di area yang aman.',
              'Berikan ruang eksplorasi sambil tetap memastikan anak merasa aman.',
              'Puji keberanian anak saat ia bermain mandiri tanpa pengasuh di dekatnya.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mencari Orang Dewasa Penting saat Merasa Tidak Aman',
            target: 'Target: Anak mencari orang dewasa penting saat merasa tidak aman atau butuh kenyamanan.',
            parentTips: [
              'Selalu tersedia dan responsif saat anak membutuhkan kenyamanan.',
              'Berikan pelukan dan kata-kata menenangkan saat anak datang mencari Anda.',
              'Bangun kepercayaan bahwa Anda selalu ada saat dibutuhkan.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Bermain dengan Anak Seusia',
            target: 'Target: Anak mampu bermain dengan anak-anak seusianya.',
            parentTips: [
              'Sediakan kesempatan bermain bersama teman sebaya secara rutin.',
              'Dampingi anak saat bermain dan bantu menyelesaikan konflik.',
              'Ajarkan cara bergiliran dan berbagi mainan.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Menunjukkan Rasa Percaya pada Pengasuh',
            target: 'Target: Anak menunjukkan rasa percaya pada pengasuh utamanya.',
            parentTips: [
              'Respons kebutuhan anak secara konsisten untuk membangun kepercayaan.',
              'Jaga rutinitas harian yang teratur agar anak merasa aman.',
              'Tunjukkan kasih sayang melalui sentuhan lembut dan kata-kata hangat.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Menunjukkan Kelekatan pada Orang Dewasa Penting',
            target: 'Target: Anak menunjukkan kelekatan pada orang dewasa penting di sekitarnya.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari.',
              'Libatkan semua anggota keluarga dalam perawatan anak.',
              'Berikan perhatian penuh saat berinteraksi dengan anak.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Menunjukkan Stres saat Berpisah dari Keluarga',
            target: 'Target: Anak menunjukkan tanda-tanda stres saat anggota keluarga memulai perpisahan.',
            parentTips: [
              'Ucapkan salam perpisahan singkat dan yakinkan anak bahwa Anda akan kembali.',
              'Latih perpisahan singkat secara bertahap (15 menit, lalu tambah durasi).',
              'Jangan pergi diam-diam — selalu berpamitan agar anak belajar percaya.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Mencuci Muka dan Tangan Sendiri',
            target: 'Target: Anak mampu mencuci muka dan tangan sendiri.',
            parentTips: [
              'Sediakan bangku kecil agar anak bisa menjangkau wastafel.',
              'Ajarkan langkah mencuci tangan (basahi, sabun, gosok, bilas, keringkan).',
              'Jadikan cuci tangan sebagai rutinitas sebelum makan dan setelah bermain.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Menunjukkan Kemampuan Mengatasi Stres yang Meningkat',
            target: 'Target: Anak menunjukkan kemampuan mengatasi stres yang semakin meningkat.',
            parentTips: [
              'Ajarkan teknik menenangkan diri sederhana (tarik napas, peluk boneka).',
              'Berikan kenyamanan dan dukungan saat anak mengalami stres.',
              'Pahami bahwa tantrum adalah hal normal di usia ini dan respons dengan tenang.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Melempar Bola dari Atas Kepala',
            target: 'Target: Anak mampu melempar bola dari atas kepala.',
            parentTips: [
              'Sediakan bola lembut (bola busa/pantai) sesuai ukuran tangan anak untuk bermain lempar tangkap.',
              'Latih secara bertahap mulai dari jarak dekat lalu perlahan jauhkan jarak lemparan.',
              'Ajak bermain memantulkan bola ke lantai atau mengarahkan lemparan ke sasaran keranjang.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Makan Sendiri dengan Sendok',
            target: 'Target: Anak mampu makan sendiri menggunakan sendok.',
            parentTips: [
              'Sediakan peralatan makan anak (sendok kecil, gelas bertutup, piring anti tumpah).',
              'Biarkan anak mencoba makan sendiri meski berantakan sebagai latihan kemandirian.',
              'Dampingi anak saat makan dan berikan contoh cara menggunakan sendok yang benar.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Mulai Berpakaian Sendiri',
            target: 'Target: Anak mampu mulai mencoba berpakaian sendiri.',
            parentTips: [
              'Sediakan pakaian yang mudah dikenakan (kaos, celana elastis) untuk latihan.',
              'Beri waktu dan kesabaran saat anak belajar berpakaian sendiri.',
              'Berikan pujian atas setiap usaha berpakaian sendiri meskipun belum sempurna.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Mulai Latihan ke Toilet (Toilet Training)',
            target: 'Target: Anak mulai menunjukkan kesiapan untuk latihan ke toilet.',
            parentTips: [
              'Perhatikan tanda kesiapan toilet training (bisa duduk stabil, popok kering 2 jam, menunjukkan minat).',
              'Sediakan potty/pispot anak yang nyaman dan ajak anak duduk secara teratur.',
              'Jangan memaksa atau menghukum saat anak gagal — berikan pujian saat berhasil.',
            ],
          ),
          RedleafItem(
            number: 19,
            title: 'Mulai dress self',
            target: 'Target: Anak mampu mulai dress self.',
            parentTips: [
              'Dampingi anak saat berlatih mulai dress self.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 20,
            title: 'May begin toilet training',
            target: 'Target: Anak mampu may begin toilet training.',
            parentTips: [
              'Dampingi anak saat berlatih may begin toilet training.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mengikuti Mainan Bergerak dan Menemukan yang Tersembunyi Sebagian',
            target: 'Target: Anak mampu mengikuti mainan yang bergerak dan menemukannya jika tersembunyi sebagian.',
            parentTips: [
              'Ajak bermain cilukba dan sembunyikan mainan di bawah kain.',
              'Latih anak mencari benda yang sebagian tersembunyi untuk melatih pemahaman objek permanen.',
              'Berikan pujian saat anak berhasil menemukan mainan yang disembunyikan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menutup Pintu',
            target: 'Target: Anak mampu menutup pintu sebagai tanda pemahaman fungsi benda.',
            parentTips: [
              'Pastikan pintu dilengkapi penahan agar jari anak tidak terjepit.',
              'Ajak anak membuka dan menutup pintu lemari kecil sebagai latihan pemahaman.',
              'Jelaskan fungsi pintu (',
              ') untuk memperkaya pemahaman.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menggunakan Satu Suara untuk Mewakili Banyak Benda',
            target: 'Target: Anak mampu menggunakan satu suara untuk mewakili beberapa benda atau gestur.',
            parentTips: [
              'Pahami bahwa ini adalah tahap normal perkembangan bahasa — anak generalisasi suara.',
              'Bantu anak dengan menyebutkan nama benda yang benar saat ia menggunakan suara umum.',
              'Jangan mengoreksi secara berlebihan — cukup ulangi kata yang tepat dengan santai.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Berbicara dalam Jargon atau Frasa Tidak Bermakna',
            target: 'Target: Anak mampu berbicara dalam jargon (rangkaian suara mirip percakapan tapi belum bermakna).',
            parentTips: [
              'Respons jargon anak seolah Anda memahami percakapannya untuk mendorong komunikasi.',
              'Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat sederhana.',
              'Bacakan buku cerita bergambar secara rutin untuk merangsang perkembangan bahasa.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Memahami Lebih Banyak Kata daripada yang Bisa Diucapkan',
            target: 'Target: Anak memahami lebih banyak kata daripada yang mampu ia ucapkan.',
            parentTips: [
              'Terus ajak bicara anak meskipun ia belum bisa membalas dengan kata-kata.',
              'Beri instruksi sederhana (',
              ') untuk menguji pemahamannya.',
              'Bacakan buku dan tunjuk gambar sambil menyebutkan nama benda.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Memahami dan Merespons Instruksi Sederhana',
            target: 'Target: Anak mampu memahami dan merespons instruksi sederhana.',
            parentTips: [
              'Berikan instruksi satu langkah (',
              ',',
              ').',
              'Gunakan kalimat pendek dan jelas saat memberikan instruksi.',
              'Berikan pujian saat anak berhasil mengikuti instruksi sederhana.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mengucapkan "Hai',
            target: 'Target: Anak mampu mengucapkan kata-kata sosial seperti "hai',
            parentTips: [
              'Contohkan penggunaan kata-kata sosial dalam konteks yang tepat setiap hari.',
              'Ucapkan',
              'saat berpisah dan',
              'saat bertemu untuk mengajarkan konteks.',
              'Puji anak saat ia menggunakan kata-kata ini secara tepat.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mulai Mengekspresikan Perasaan dengan Kata-kata',
            target: 'Target: Anak mulai mengekspresikan perasaannya menggunakan kata-kata sederhana.',
            parentTips: [
              'Bantu anak menamai emosi yang dirasakan (',
              ',',
              ').',
              'Respons upaya anak mengekspresikan perasaan dengan validasi dan empati.',
              'Contohkan cara mengekspresikan perasaan dengan kata-kata dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menggunakan Frasa 2-3 Kata',
            target: 'Target: Anak mampu menggunakan frasa yang terdiri dari 2-3 kata.',
            parentTips: [
              'Perluas kalimat anak (jika anak bilang',
              ', respons',
              ').',
              'Ajak anak menceritakan apa yang dilihat dan dilakukan dengan kata-kata sederhana.',
              'Bacakan buku cerita dan ajak anak mengulangi frasa-frasa pendek.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Memiliki Kosakata 20 hingga 300 Kata',
            target: 'Target: Anak memiliki kosakata 20 hingga 300 kata.',
            parentTips: [
              'Sebutkan nama benda-benda di sekitar saat beraktivitas bersama anak.',
              'Ajak bernyanyi lagu-lagu anak yang mengulang kata-kata sederhana.',
              'Bacakan buku cerita bergambar dan ajak anak menyebut nama benda di gambar.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Menunjukkan attachment to significant adults',
            target: 'Target: Anak mampu menunjukkan attachment to significant adults.',
            parentTips: [
              'Dampingi anak saat berlatih menunjukkan attachment to significant adults.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Menunjukkan signs of stress when family members initiate separation',
            target: 'Target: Anak mampu menunjukkan signs of stress when family members initiate separation.',
            parentTips: [
              'Dampingi anak saat berlatih menunjukkan signs of stress when family members initiate separation.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Washes face and hands',
            target: 'Target: Anak mampu washes face and hands.',
            parentTips: [
              'Dampingi anak saat berlatih washes face and hands.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Berdiri on satu kaki with help',
            target: 'Target: Anak mampu berdiri on satu kaki with help.',
            parentTips: [
              'Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.',
              'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.',
              'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Fokus pada Aktivitas yang Menarik Minatnya',
            target: 'Target: Anak mampu fokus pada beberapa aktivitas yang menarik minatnya.',
            parentTips: [
              'Biarkan anak menyelesaikan aktivitas yang diminatinya tanpa terlalu banyak interupsi.',
              'Sediakan lingkungan yang tenang saat anak sedang fokus bermain.',
              'Amati aktivitas yang paling menarik minat anak dan sediakan lebih banyak variasi.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mengambil Inisiatif (Misalnya Mencari Mainan yang Hilang)',
            target: 'Target: Anak mampu mengambil inisiatif seperti mencari mainan yang hilang.',
            parentTips: [
              'Beri waktu anak untuk mencari sendiri benda yang hilang sebelum membantu.',
              'Puji inisiatif anak (',
              ').',
              'Dorong anak untuk mencoba memecahkan masalah sederhana secara mandiri.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Uses one sound to stand for more than one gesture or object',
            target: 'Target: Anak mampu uses one sound to stand for more than one gesture or object.',
            parentTips: [
              'Dampingi anak saat berlatih uses one sound to stand for more than one gesture or object.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Membalik Halaman Buku',
            target: 'Target: Anak mampu membalik halaman buku.',
            parentTips: [
              'Bacakan buku cerita bergambar dan biarkan anak membalik halaman buku sendiri.',
              'Pilih buku dengan halaman tebal (board book) untuk anak yang masih belajar membalik halaman.',
              'Jadikan membaca buku bersama sebagai rutinitas harian yang menyenangkan.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mulai Mengenali Warna-warna',
            target: 'Target: Anak mulai mengenali warna-warna dasar.',
            parentTips: [
              'Sebutkan nama warna benda saat beraktivitas (',
              ',',
              ').',
              'Ajak bermain mengelompokkan benda berdasarkan warna.',
              'Gunakan buku bergambar untuk mengenalkan warna-warna dasar.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menikmati Bermain Wadah (Container Play)',
            target: 'Target: Anak menikmati bermain memasukkan dan mengeluarkan benda dari wadah.',
            parentTips: [
              'Sediakan wadah dan benda-benda aman untuk dimasukkan dan dikeluarkan.',
              'Berikan mainan susun-tumpuk (nesting toys) untuk melatih pemahaman ukuran.',
              'Ajak bermain memasukkan bola ke dalam keranjang atau benda ke dalam kotak.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mengenali Bayangan Diri di Cermin',
            target: 'Target: Anak mampu mengenali bayangan dirinya sendiri di cermin.',
            parentTips: [
              'Ajak anak berdiri di depan cermin dan tunjukkan bagian-bagian tubuhnya.',
              'Bermain ekspresi wajah di depan cermin bersama anak.',
              'Puji anak saat ia mengenali dirinya di cermin (',
              ').',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Initiates separation from caregivers',
            target: 'Target: Anak mampu initiates separation from caregivers.',
            parentTips: [
              'Berikan pelukan dan kata-kata menenangkan saat anak merasa takut atau cemas.',
              'Perkenalkan orang baru secara bertahap dengan kehadiran orang tua di samping anak.',
              'Latih perpisahan singkat secara bertahap (misal: titip ke nenek 15 menit, lalu bertahap lebih lama).',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Melihat for home base or significant adult',
            target: 'Target: Anak mampu melihat for home base or significant adult.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.',
              'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.',
              'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Bermain with other toddlers',
            target: 'Target: Anak mampu bermain with other toddlers.',
            parentTips: [
              'Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.',
              'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.',
              'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Closes doors',
            target: 'Target: Anak mampu closes doors.',
            parentTips: [
              'Dampingi anak saat berlatih closes doors.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mengucapkan Mama dan Papa',
            target: 'Target: Anak mampu mengucapkan Mama dan Papa.',
            parentTips: [
              'Sebutkan nama benda-benda di sekitar saat beraktivitas (\\',
              ').',
              'Respons upaya bicara anak dengan antusias dan ulangi kata yang benar tanpa menyalahkan.',
              'Ajak bernyanyi lagu-lagu sederhana yang mengulang kata-kata untuk memperkaya kosakata.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menunjukkan Kreativitas dengan Menggunakan Benda secara Baru',
            target: 'Target: Anak menunjukkan kreativitas dengan menggunakan benda untuk fungsi baru.',
            parentTips: [
              'Biarkan anak menggunakan benda untuk bermain pura-pura (kotak jadi mobil, selimut jadi tenda).',
              'Sediakan benda-benda sederhana (kotak, kain, sendok) untuk merangsang kreativitas.',
              'Puji ide kreatif anak dan ikut bermain menggunakan imajinasi.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menunjukkan Rasa Ingin Tahu yang Meningkat',
            target: 'Target: Anak menunjukkan rasa ingin tahu yang semakin meningkat.',
            parentTips: [
              'Respons pertanyaan dan rasa penasaran anak dengan antusias.',
              'Ajak anak mengeksplorasi hal-hal baru di lingkungan sekitar.',
              'Sediakan benda dan pengalaman baru secara berkala untuk merangsang rasa ingin tahu.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bersedia Mencoba Aktivitas dan Pengalaman Baru',
            target: 'Target: Anak bersedia mencoba aktivitas dan pengalaman baru.',
            parentTips: [
              'Dorong anak mencoba hal baru dengan dukungan dan pendampingan.',
              'Jangan memaksa jika anak belum siap — beri waktu dan coba lagi nanti.',
              'Puji keberanian anak saat ia mencoba sesuatu yang baru.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Meningkatnya Minat dan Kemandirian dalam Menyelesaikan Tugas Sederhana',
            target: 'Target: Anak menunjukkan meningkatnya minat dan kemandirian dalam menyelesaikan tugas sederhana.',
            parentTips: [
              'Libatkan anak dalam tugas rumah tangga sederhana (merapikan mainan, menaruh piring di wastafel).',
              'Beri waktu anak menyelesaikan tugas sendiri tanpa langsung membantu.',
              'Berikan pujian spesifik atas usaha dan kemandirian anak.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mengekspresikan Pilihan dan Preferensi',
            target: 'Target: Anak mampu mengekspresikan pilihan dan preferensinya.',
            parentTips: [
              'Berikan pilihan sederhana setiap hari (',
              ').',
              'Hormati pilihan anak selama pilihan tersebut aman dan wajar.',
              'Puji anak saat ia mampu mengekspresikan keinginannya dengan jelas.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Tracks a toy that is being moved and can retrieve it if its in partial view',
            target: 'Target: Anak mampu tracks a toy that is being moved and can retrieve it if its in partial view.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menutup doors',
            target: 'Target: Anak mampu menutup doors.',
            parentTips: [
              'Ajak anak bermain permainan edukatif yang merangsang berpikir (puzzle, tebak-tebakan, hitung benda).',
              'Libatkan anak dalam aktivitas sehari-hari yang mengembangkan kemampuan kognitif (memasak, berkebun).',
              'Berikan pertanyaan terbuka yang merangsang anak berpikir dan mengeksplorasi jawaban sendiri.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengikuti simple commands from adults or anak yang lebih besar',
            target: 'Target: Anak mampu mengikuti simple commands from adults or anak yang lebih besar.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Membalik Halaman Buku',
            target: 'Target: Anak mampu membalik Halaman Buku.',
            parentTips: [
              'Bacakan buku cerita bergambar dan biarkan anak membalik halaman buku sendiri.',
              'Pilih buku dengan halaman tebal (board book) untuk anak yang masih belajar membalik halaman.',
              'Jadikan membaca buku bersama sebagai rutinitas harian yang menyenangkan.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mulai recognize colors',
            target: 'Target: Anak mampu mulai recognize colors.',
            parentTips: [
              'Sediakan krayon, pensil warna, dan kertas gambar yang cukup luas untuk anak berkreasi.',
              'Contohkan menggambar bentuk-bentuk dasar (garis, lingkaran, kotak) dan ajak anak menirunya.',
              'Latih motorik halus dengan aktivitas mewarnai, menebalkan garis, dan menulis di udara dengan jari.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menikmati container play',
            target: 'Target: Anak mampu menikmati container play.',
            parentTips: [
              'Sediakan wadah dengan tutup ulir (toples plastik) untuk anak latihan membuka dan menutup.',
              'Biarkan anak mencoba memutar gagang pintu dengan pengawasan untuk melatih kekuatan pergelangan.',
              'Ajak bermain memasukkan dan mengeluarkan benda dari berbagai wadah untuk melatih motorik halus.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Toddlers enjoy putting objects into containers and using nesting toys',
            target: 'Target: Anak mampu toddlers enjoy putting objects into containers and using nesting toys.',
            parentTips: [
              'Sediakan wadah dengan tutup ulir (toples plastik) untuk anak latihan membuka dan menutup.',
              'Biarkan anak mencoba memutar gagang pintu dengan pengawasan untuk melatih kekuatan pergelangan.',
              'Ajak bermain memasukkan dan mengeluarkan benda dari berbagai wadah untuk melatih motorik halus.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mengenali own image in a mirror',
            target: 'Target: Anak mampu mengenali own image in a mirror.',
            parentTips: [
              'Beri kesempatan anak memilih sendiri aktivitas atau pakaian yang ingin dikenakan.',
              'Dorong anak melakukan tugas sederhana sendiri (merapikan mainan, memakai sepatu).',
              'Hargai usaha kemandirian anak meskipun hasilnya belum sempurna dan berikan bimbingan lembut.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '2_years',
    name: '2 Tahun (24-36 Bulan)',
    minAgeMonths: 24,
    maxAgeMonths: 36,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mengendarai Mainan Roda Empat dengan Mudah',
            target: 'Target: Anak mampu mengendarai mainan roda empat dengan mudah.',
            parentTips: [
              'Sediakan mainan roda empat yang aman dan sesuai ukuran anak.',
              'Awasi anak saat mengendarai mainan beroda di area yang aman dan rata.',
              'Berikan pujian saat anak berhasil mengendarai mainan beroda dengan lancar.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Berlari dengan Mudah dan Jarang Terjatuh',
            target: 'Target: Anak mampu berlari dengan mudah dan jarang terjatuh.',
            parentTips: [
              'Ajak anak bermain kejar-kejaran di area terbuka yang aman.',
              'Latih anak berlari dengan permainan lomba lari pendek.',
              'Pastikan anak memakai sepatu yang nyaman dan tidak licin saat berlari.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Berdiri Berjinjit',
            target: 'Target: Anak mampu berdiri berjinjit.',
            parentTips: [
              'Ajak anak bermain meraih benda yang sedikit lebih tinggi untuk melatih berjinjit.',
              'Latih keseimbangan berjinjit dengan meniru gerakan balerina.',
              'Pastikan area latihan aman dan bebas dari benda yang bisa terjatuh.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Memalu atau Memukul dengan Alat (Hammering)',
            target: 'Target: Anak mampu memalu atau memukul benda menggunakan alat mainan.',
            parentTips: [
              'Sediakan mainan palu dan pasak kayu untuk melatih koordinasi tangan-mata.',
              'Dampingi anak saat bermain palu untuk memastikan keamanan.',
              'Ajarkan kontrol kekuatan saat memukul benda.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bermain Aktivitas Fisik (Exercise Play)',
            target: 'Target: Anak mampu terlibat dalam bermain aktivitas fisik aktif.',
            parentTips: [
              'Ajak anak bermain di luar ruangan (berlari, melompat, memanjat) setiap hari.',
              'Sediakan peralatan bermain aman (bola, seluncuran kecil, ayunan).',
              'Batasi waktu layar dan ganti dengan aktivitas fisik yang menyenangkan.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menunjukkan Minat pada Latihan Toilet',
            target: 'Target: Anak menunjukkan minat pada latihan ke toilet.',
            parentTips: [
              'Perhatikan tanda kesiapan (bisa duduk stabil, popok kering 2 jam, menunjukkan minat).',
              'Sediakan potty/pispot anak yang nyaman dan mudah dijangkau.',
              'Berikan pujian saat anak berhasil dan jangan menghukum saat gagal.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Membuka Pintu dengan Memutar Gagang',
            target: 'Target: Anak mampu membuka pintu dengan memutar gagang atau kenop pintu.',
            parentTips: [
              'Pastikan pintu dilengkapi penahan agar jari anak tidak terjepit.',
              'Pasang pengunci keamanan pada pintu yang mengarah ke area berbahaya.',
              'Ajak anak melatih memutar gagang pintu sebagai latihan motorik halus.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Membalik Halaman Buku Satu per Satu',
            target: 'Target: Anak mampu membalik halaman buku satu per satu.',
            parentTips: [
              'Bacakan buku cerita dan biarkan anak membalik halaman sendiri.',
              'Pilih buku dengan halaman tipis untuk melatih keterampilan motorik halus.',
              'Jadikan membaca buku bersama sebagai rutinitas menyenangkan.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Sudah Menunjukkan Preferensi Tangan (Kanan/Kiri)',
            target: 'Target: Anak sudah menunjukkan preferensi penggunaan tangan dominan.',
            parentTips: [
              'Amati tangan mana yang lebih sering digunakan anak saat memegang benda.',
              'Jangan memaksa anak menggunakan tangan tertentu — biarkan berkembang alami.',
              'Sediakan alat tulis dan peralatan yang sesuai dengan tangan dominan anak.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Memegang Krayon dan Spidol dengan Mudah',
            target: 'Target: Anak mampu memegang krayon dan spidol dengan mudah.',
            parentTips: [
              'Sediakan krayon tebal yang nyaman untuk tangan anak.',
              'Bimbing anak memegang alat tulis dengan genggaman 3 jari (ibu jari, telunjuk, jari tengah).',
              'Latih motorik halus dengan aktivitas meremas playdough dan menjimpit manik-manik.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Menggunakan Cat, Tanah Liat, dan Adonan untuk Berkreasi',
            target: 'Target: Anak mampu menggunakan cat, tanah liat, dan adonan untuk berkreasi.',
            parentTips: [
              'Sediakan cat air, playdough, dan tanah liat yang aman untuk anak.',
              'Biarkan anak berkreasi bebas tanpa harus membuat bentuk sempurna.',
              'Gunakan celemek dan alas koran untuk menjaga kebersihan area bermain.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Menumpuk Mainan dengan Mudah',
            target: 'Target: Anak mampu menumpuk mainan dengan mudah dan membuat menara lebih tinggi.',
            parentTips: [
              'Sediakan balok kayu/plastik berwarna untuk membangun menara.',
              'Ajak anak menyelesaikan puzzle sesuai usia (4-8 keping).',
              'Bermain membangun bersama dan pandu anak menyusun balok dari besar ke kecil.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Menunjukkan Minat pada Menggambar dan Mencoret',
            target: 'Target: Anak menunjukkan minat pada aktivitas menggambar dan mencoret.',
            parentTips: [
              'Sediakan krayon, pensil warna, dan kertas gambar untuk anak berkreasi.',
              'Contohkan menggambar bentuk-bentuk dasar (garis, lingkaran) dan ajak anak menirunya.',
              'Pajang hasil karya anak di dinding untuk memberikan rasa bangga dan motivasi.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Sudah Terlatih ke Toilet (Toilet Trained)',
            target: 'Target: Anak sudah terlatih ke toilet secara mandiri.',
            parentTips: [
              'Tetap dampingi anak ke toilet dan bantu jika diperlukan.',
              'Ajarkan cara membersihkan diri setelah ke toilet.',
              'Buat jadwal toilet yang teratur untuk membantu anak.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Mengendarai Sepeda Roda Tiga',
            target: 'Target: Anak mampu mengendarai sepeda roda tiga.',
            parentTips: [
              'Sediakan sepeda roda tiga yang sesuai tinggi badan anak.',
              'Awasi anak saat mengendarai sepeda di area aman dan rata.',
              'Gunakan helm sebagai perlengkapan keselamatan saat bersepeda.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'toilet trained',
            target: 'Target: Anak mampu toilet trained.',
            parentTips: [
              'Dampingi anak saat berlatih toilet trained.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Rides a trike',
            target: 'Target: Anak mampu rides a trike.',
            parentTips: [
              'Dampingi anak saat berlatih rides a trike.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mandiri dalam Mandi, Gosok Gigi, Berpakaian, dan Memilih Baju',
            target: 'Target: Anak menunjukkan kemandirian dalam mandi, gosok gigi, berpakaian, dan memilih pakaian.',
            parentTips: [
              'Biarkan anak memilih sendiri pakaian yang ingin dikenakan dari 2-3 pilihan.',
              'Ajarkan langkah-langkah mandi dan gosok gigi secara bertahap.',
              'Berikan waktu cukup dan kesabaran saat anak belajar berpakaian sendiri.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Tertarik pada Bagian Tubuh dan Anatomi',
            target: 'Target: Anak menunjukkan ketertarikan pada bagian tubuh dan anatomi.',
            parentTips: [
              'Ajarkan nama-nama bagian tubuh melalui lagu dan permainan (',
              ').',
              'Jawab pertanyaan anak tentang tubuh dengan jujur dan sederhana sesuai usianya.',
              'Gunakan buku bergambar tentang tubuh manusia yang sesuai usia anak.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengalami Tantrum (Ledakan Emosi)',
            target: 'Target: Anak mengalami tantrum sebagai bagian normal perkembangan emosional.',
            parentTips: [
              'Tetap tenang saat anak tantrum dan pastikan ia aman.',
              'Jangan memarahi atau menghukum saat tantrum — tunggu sampai tenang lalu bicarakan.',
              'Ajarkan cara mengekspresikan emosi dengan kata-kata (',
              ').',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Bermain Sejajar (Parallel Play) dengan Teman',
            target: 'Target: Anak bermain sejajar berdampingan dengan teman sebaya.',
            parentTips: [
              'Sediakan kesempatan bermain bersama teman sebaya secara rutin.',
              'Pahami bahwa bermain sejajar masih normal di usia ini.',
              'Dampingi anak saat bermain dan bantu menyelesaikan konflik jika ada.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mampu Mengenali dan Menceritakan Perasaan Sendiri',
            target: 'Target: Anak mampu mengenali dan menceritakan perasaan pribadinya.',
            parentTips: [
              'Bantu anak menamai emosi yang dirasakan (',
              ',',
              ').',
              'Dengarkan saat anak bercerita tentang perasaannya tanpa menghakimi.',
              'Ajarkan cara mengekspresikan emosi dengan cara yang sehat.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mampu Mengenali dan Membicarakan Perasaan Orang Lain',
            target: 'Target: Anak mampu mengenali dan membicarakan perasaan orang lain.',
            parentTips: [
              'Tunjukkan ekspresi orang lain dan ajak anak menebak perasaan mereka.',
              'Bacakan cerita dan diskusikan perasaan tokoh dalam cerita.',
              'Contohkan empati dalam kehidupan sehari-hari (',
              ').',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menunjukkan Minat untuk Membantu',
            target: 'Target: Anak menunjukkan minat untuk membantu orang lain.',
            parentTips: [
              'Libatkan anak dalam tugas rumah tangga sederhana (merapikan mainan, menyiram tanaman).',
              'Berikan pujian spesifik saat anak membantu (',
              ').',
              'Contohkan perilaku membantu dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Bisa Mengucapkan Aturan tapi Belum Konsisten Mengikutinya',
            target: 'Target: Anak bisa mengucapkan aturan tetapi belum konsisten mengikutinya.',
            parentTips: [
              'Buat aturan yang sederhana, jelas, dan konsisten.',
              'Ingatkan aturan dengan lembut tanpa marah saat anak lupa.',
              'Berikan pujian saat anak berhasil mengikuti aturan.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menunjukkan Rasa Bangga atas Pencapaian',
            target: 'Target: Anak menunjukkan rasa bangga atas pencapaian (terutama fisik).',
            parentTips: [
              'Rayakan pencapaian anak dengan pujian spesifik dan antusias.',
              'Dorong anak untuk mencoba hal-hal baru dan rayakan keberaniannya.',
              'Pajang hasil karya anak untuk membangun rasa bangga.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Mulai Menunjukkan Rasa Hormat pada Orang Lain dan Barang Milik Orang',
            target: 'Target: Anak mulai menunjukkan rasa hormat pada orang lain dan barang milik orang lain.',
            parentTips: [
              'Contohkan cara memperlakukan barang orang lain dengan hati-hati.',
              'Ajarkan kata',
              ',',
              ', dan',
              'dalam konteks sehari-hari.',
              'Jelaskan konsep kepemilikan dengan bahasa sederhana.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Tertarik pada Dunia Luar',
            target: 'Target: Anak menunjukkan ketertarikan pada dunia luar dan lingkungan sekitar.',
            parentTips: [
              'Ajak anak berjalan-jalan ke taman, kebun, atau lingkungan baru.',
              'Jawab pertanyaan anak tentang hal-hal di sekitar dengan antusias dan sederhana.',
              'Biarkan anak mengeksplorasi alam (menyentuh daun, mengamati serangga) dengan aman.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Minat pada Tulisan dan Buku',
            target: 'Target: Anak menunjukkan minat pada tulisan dan buku.',
            parentTips: [
              'Bacakan buku cerita bergambar secara rutin setiap hari.',
              'Sediakan buku-buku dengan gambar berwarna dan cerita menarik sesuai usia.',
              'Biarkan anak memilih sendiri buku yang ingin dibacakan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mulai Berbicara Sendiri (Private Speech)',
            target: 'Target: Anak mulai berbicara sendiri saat bermain sebagai cara berpikir.',
            parentTips: [
              'Pahami bahwa berbicara sendiri saat bermain adalah hal normal dan tanda perkembangan kognitif.',
              'Jangan menyela saat anak berbicara sendiri selama bermain.',
              'Perhatikan apa yang dibicarakan anak sebagai cara memahami pikirannya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mampu Menyebut Nama Benda yang Menarik Perhatian',
            target: 'Target: Anak mampu menggunakan kata-kata untuk menamai benda yang menarik perhatiannya.',
            parentTips: [
              'Sebutkan nama benda-benda di sekitar saat beraktivitas bersama anak.',
              'Tanyakan',
              'sambil menunjuk benda untuk melatih kosakata.',
              'Puji anak saat ia berhasil menyebut nama benda dengan benar.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menggabungkan Kata Benda dan Kata Kerja dalam Kalimat Sederhana',
            target: 'Target: Anak mampu menggabungkan kata benda dan kata kerja dalam kalimat sederhana.',
            parentTips: [
              'Perluas kalimat anak: jika ia berkata',
              ', respons',
              '.',
              'Ajak anak bercakap-cakap tentang kegiatan sehari-hari menggunakan kalimat lengkap.',
              'Bacakan buku cerita dan ajukan pertanyaan terbuka tentang isi cerita.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mengulang Pertanyaan yang Didengar (Echolalia)',
            target: 'Target: Anak mengulang pertanyaan yang didengar sebagai cara belajar bahasa.',
            parentTips: [
              'Pahami bahwa mengulang pertanyaan adalah tahap normal perkembangan bahasa.',
              'Jawab pertanyaan yang diulang anak dengan sabar dan jelas.',
              'Contohkan cara menjawab pertanyaan dengan kalimat yang benar.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mampu identify and talk about others feelings',
            target: 'Target: Anak mampu mampu identify and talk about others feelings.',
            parentTips: [
              'Bantu anak menamai emosi yang dirasakan (senang, sedih, marah, takut, kecewa).',
              'Dengarkan cerita dan keluh kesah anak tanpa langsung menghakimi atau menyalahkan.',
              'Ajarkan teknik menenangkan diri (tarik napas dalam-dalam, hitung 1-10) saat emosi mulai meningkat.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menunjukkan interest in helping',
            target: 'Target: Anak mampu menunjukkan interest in helping.',
            parentTips: [
              'Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).',
              'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.',
              'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mampu recite rules but cannot follow them consistently',
            target: 'Target: Anak mampu mampu recite rules but cannot follow them consistently.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Although older toddlers can verbalize rules, they dont always follow them.',
            target: 'Target: Anak mampu although older toddlers can verbalize rules, they dont always follow them.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Pura-pura Membaca Buku',
            target: 'Target: Anak mampu pura-pura membaca buku.',
            parentTips: [
              'Sediakan buku bergambar dan biarkan anak',
              'cerita sendiri.',
              'Contohkan membaca buku dengan suara dan ekspresi yang menarik.',
              'Puji anak saat ia meniru kegiatan membaca.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mampu do simple sorting',
            target: 'Target: Anak mampu mampu do simple sorting.',
            parentTips: [
              'Ajak anak mengelompokkan benda berdasarkan warna, bentuk geometri, atau ukuran.',
              'Sediakan kartu pasangan gambar untuk melatih kemampuan mencocokkan yang identik.',
              'Minta anak membantu memilah pakaian bersih atau merapikan mainan sesuai jenisnya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengenali and names colors',
            target: 'Target: Anak mampu mengenali and names colors.',
            parentTips: [
              'Sediakan krayon, pensil warna, dan kertas gambar yang cukup luas untuk anak berkreasi.',
              'Contohkan menggambar bentuk-bentuk dasar (garis, lingkaran, kotak) dan ajak anak menirunya.',
              'Latih motorik halus dengan aktivitas mewarnai, menebalkan garis, dan menulis di udara dengan jari.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Meletakkan nouns and verbs together in simple sentences',
            target: 'Target: Anak mampu meletakkan nouns and verbs together in simple sentences.',
            parentTips: [
              'Perluas kalimat anak: jika ia berkata \\',
              ', respons \\',
              '.',
              'Ajak anak bercakap-cakap tentang kegiatan sehari-hari menggunakan kalimat lengkap.',
              'Bacakan buku cerita dan ajukan pertanyaan terbuka tentang isi cerita.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'I do it and Her hit me are examples of toddlers expressions at this stage of',
            target: 'Target: Anak mampu i do it and Her hit me are examples of toddlers expressions at this stage of.',
            parentTips: [
              'Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat yang jelas.',
              'Bacakan buku cerita bergambar secara rutin dan ajak anak bercerita ulang.',
              'Respons setiap upaya bicara anak dengan antusias untuk memotivasi perkembangan bahasanya.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menggunakan Ucapan yang Bisa Dipahami Orang Lain',
            target: 'Target: Anak mampu menggunakan ucapan yang bisa dipahami orang lain.',
            parentTips: [
              'Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat jelas.',
              'Respons upaya bicara anak dengan antusias tanpa mengkritik pengucapan.',
              'Bacakan buku cerita secara rutin untuk memperkaya kosakata dan pengucapan.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menggunakan Suara Keras dan Pelan',
            target: 'Target: Anak mampu menggunakan suara keras dan suara pelan sesuai konteks.',
            parentTips: [
              'Ajak bermain permainan',
              'dan',
              'untuk melatih kontrol suara.',
              'Contohkan kapan harus berbicara pelan (di perpustakaan) dan kapan boleh keras (di taman).',
              'Puji anak saat ia mampu mengontrol volume suaranya sesuai situasi.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Memahami Sebagian Besar Hal yang Dikatakan Orang Lain',
            target: 'Target: Anak mampu memahami sebagian besar hal yang dikatakan orang lain.',
            parentTips: [
              'Berikan instruksi dua langkah sederhana (',
              ').',
              'Ajak anak berdiskusi tentang kejadian sehari-hari dengan bahasa sederhana.',
              'Beri pujian saat anak menunjukkan pemahaman terhadap apa yang Anda katakan.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menggunakan a loud and soft voice',
            target: 'Target: Anak mampu menggunakan a loud and soft voice.',
            parentTips: [
              'Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat yang jelas.',
              'Bacakan buku cerita bergambar secara rutin dan ajak anak bercerita ulang.',
              'Respons setiap upaya bicara anak dengan antusias untuk memotivasi perkembangan bahasanya.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Memahami most things said by others',
            target: 'Target: Anak mampu memahami most things said by others.',
            parentTips: [
              'Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.',
              'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.',
              'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Mulai show respect for other people and possessions',
            target: 'Target: Anak mampu mulai show respect for other people and possessions.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.',
              'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.',
              'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Is interested in the outside world',
            target: 'Target: Anak mampu is interested in the outside world.',
            parentTips: [
              'Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).',
              'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.',
              'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Asks questions',
            target: 'Target: Anak mampu asks questions.',
            parentTips: [
              'Dampingi anak saat berlatih asks questions.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Whos that? Where did Daddy go? and Wheres his mommy? are typical questions',
            target: 'Target: asked by older toddlers.',
            parentTips: [
              'Dampingi anak saat berlatih whos that? where did daddy go? and wheres his mommy? are typical questions.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Creates imaginary friends',
            target: 'Target: Anak mampu creates imaginary friends.',
            parentTips: [
              'Dampingi anak saat berlatih creates imaginary friends.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Follows more complex commands from adults',
            target: 'Target: Anak mampu follows more complex commands from adults.',
            parentTips: [
              'Dampingi anak saat berlatih follows more complex commands from adults.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan curiosity and interest in actively exploring the environment',
            target: 'Target: Anak mampu menunjukkan curiosity and interest in actively exploring the environment.',
            parentTips: [
              'Dampingi anak saat berlatih menunjukkan curiosity and interest in actively exploring the environment.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mampu Mengelompokkan Benda secara Sederhana',
            target: 'Target: Anak mampu mengelompokkan benda secara sederhana.',
            parentTips: [
              'Ajak anak mengelompokkan benda berdasarkan warna, bentuk, atau ukuran.',
              'Sediakan kartu pasangan gambar untuk melatih kemampuan mencocokkan.',
              'Minta anak membantu memilah mainan sesuai jenisnya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengenali dan Menyebutkan Nama Warna',
            target: 'Target: Anak mampu mengenali dan menyebutkan nama warna.',
            parentTips: [
              'Sebutkan nama warna benda saat beraktivitas (',
              ',',
              ').',
              'Ajak bermain mengelompokkan benda berdasarkan warna.',
              'Gunakan krayon berwarna dan ajak anak menyebut nama warnanya.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mengulang Lagu Anak dan Sajak Sederhana',
            target: 'Target: Anak mampu mengulang lagu anak dan sajak sederhana.',
            parentTips: [
              'Nyanyikan lagu-lagu anak bersama secara rutin.',
              'Ajak anak menghafal sajak dan nyanyian pendek.',
              'Puji anak saat ia berhasil mengulang bagian dari lagu.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bernyanyi Bagian dari Lagu Sederhana',
            target: 'Target: Anak mampu bernyanyi bagian dari lagu sederhana.',
            parentTips: [
              'Nyanyikan lagu bersama anak dan biarkan ia melanjutkan bagian yang dikenalnya.',
              'Pilih lagu dengan lirik sederhana dan berulang.',
              'Ajak anak bernyanyi sambil bergerak untuk membuatnya lebih menyenangkan.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menunjukkan an interest in shapes',
            target: 'Target: Anak mampu menunjukkan an interest in shapes.',
            parentTips: [
              'Sediakan krayon, pensil warna, dan kertas gambar yang cukup luas untuk anak berkreasi.',
              'Contohkan menggambar bentuk-bentuk dasar (garis, lingkaran, kotak) dan ajak anak menirunya.',
              'Latih motorik halus dengan aktivitas mewarnai, menebalkan garis, dan menulis di udara dengan jari.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '3_years',
    name: '3 Tahun (36-48 Bulan)',
    minAgeMonths: 36,
    maxAgeMonths: 48,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Swings arms when walking',
            target: 'Target: Anak mampu swings arms when walking.',
            parentTips: [
              'Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.',
              'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.',
              'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Melompat dengan Kedua Kaki',
            target: 'Target: Anak mampu melompat dari lantai menggunakan kedua kaki secara bersamaan.',
            parentTips: [
              'Bermain menirukan lompatan kelinci atau katak bersama anak di atas alas yang empuk.',
              'Buat garis-garis pembatas sederhana di lantai dan ajak anak melompat melaluinya.',
              'Beri pujian atas keseimbangan dan kekuatan anak setiap kali ia mendarat dengan aman.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengendarai Mainan Roda Tiga',
            target: 'Target: Anak mampu mengendarai dan mengayuh mainan roda tiga.',
            parentTips: [
              'Pilih sepeda roda tiga yang ukurannya pas sehingga kaki anak bisa menjangkau pedal dengan nyaman.',
              'Bimbing anak cara mengayuh dan mengarahkan setang di tempat yang rata dan aman dari lalu lintas.',
              'Pakaikan pelindung keselamatan seperti helm mini saat anak bermain sepeda.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Berjalan on a balance beam or line',
            target: 'Target: Anak mampu berjalan on a balance beam or line.',
            parentTips: [
              'Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.',
              'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.',
              'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menjaga Keseimbangan or hops on satu kaki',
            target: 'Target: Anak mampu menjaga Keseimbangan or hops on satu kaki.',
            parentTips: [
              'Ajak bermain melompati rintangan rendah (tali, bilah kayu) yang dipasang 10-20 cm dari lantai.',
              'Latih lompat tali dengan memutar tali perlahan sambil bernyanyi bersama anak.',
              'Bermain permainan engklek atau lompat-lompatan di area yang aman dengan alas empuk.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menggunakan Coba-coba (Trial and Error) untuk Memecahkan Masalah',
            target: 'Target: Anak mampu menggunakan cara coba-coba untuk memecahkan masalah yang lebih kompleks.',
            parentTips: [
              'Beri waktu anak mencoba menyelesaikan masalah sendiri sebelum membantu.',
              'Dorong anak mencoba berbagai cara saat menghadapi kesulitan.',
              'Puji usaha anak meskipun belum berhasil — proses lebih penting dari hasil.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Lebih Banyak Bermain Pura-pura (Pretend Play)',
            target: 'Target: Anak lebih banyak terlibat dalam bermain pura-pura.',
            parentTips: [
              'Sediakan properti bermain peran (kostum, peralatan masak mainan, boneka).',
              'Ikut bermain pura-pura bersama anak dan kembangkan cerita dari imajinasi anak.',
              'Dukung kreativitas anak saat bermain imajinatif.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Menggunakan Kata "Tidak" dengan Tegas',
            target: 'Target: Anak mampu menggunakan kata "tidak" untuk mengekspresikan keinginan.',
            parentTips: [
              'Pahami bahwa mengatakan',
              'adalah tanda kemandirian yang normal.',
              'Berikan pilihan alih-alih perintah langsung (',
              ').',
              'Tetap konsisten dengan batasan yang penting meski anak menolak.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Mampu Bercerita tentang Buku',
            target: 'Target: Anak mampu bercerita tentang buku yang dibaca bersama.',
            parentTips: [
              'Bacakan buku cerita dan ajak anak menceritakan kembali apa yang terjadi.',
              'Tanyakan pertanyaan tentang cerita (',
              ').',
              'Biarkan anak menceritakan cerita dengan bahasanya sendiri.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Mampu Menyebutkan Usia Sendiri',
            target: 'Target: Anak mampu menyebutkan usia sendiri.',
            parentTips: [
              'Latih anak menyebutkan usianya dengan menunjukkan jari.',
              'Ajak anak merayakan ulang tahun dan jelaskan konsep usia.',
              'Puji anak saat ia berhasil menyebutkan usianya.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Mengetahui Nama Depan dan Nama Belakang',
            target: 'Target: Anak mampu mengetahui nama depan dan nama belakangnya.',
            parentTips: [
              'Sering menyebut nama lengkap anak dalam percakapan sehari-hari.',
              'Latih anak memperkenalkan diri dengan nama lengkap.',
              'Tulis nama anak di barang-barang miliknya untuk pengenalan huruf.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Mengingat Pengalaman Masa Lalu',
            target: 'Target: Anak mampu mengingat dan menceritakan pengalaman masa lalu.',
            parentTips: [
              'Ajak anak bercerita tentang kegiatan yang sudah dilakukan (',
              ').',
              'Lihat foto bersama dan ajak anak menceritakan apa yang terjadi.',
              'Puji kemampuan anak mengingat kejadian yang sudah lewat.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Sering Bertanya ("Apa itu?',
            target: 'Target: Anak sering bertanya tentang hal-hal di sekitarnya.',
            parentTips: [
              'Tanggapi setiap pertanyaan anak dengan antusias dan sabar.',
              'Jawab dengan bahasa yang mudah dipahami anak.',
              'Dorong anak terus bertanya untuk merangsang rasa ingin tahunya.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Memiliki Teman Imajiner',
            target: 'Target: Anak memiliki teman imajiner sebagai bagian perkembangan kreativitas.',
            parentTips: [
              'Pahami bahwa teman imajiner adalah hal normal dan tanda kreativitas.',
              'Ikut bermain dan akui keberadaan teman imajiner anak tanpa berlebihan.',
              'Perhatikan jika teman imajiner menjadi pelarian dari masalah sosial.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Mengikuti Perintah yang Lebih Kompleks dari Orang Dewasa',
            target: 'Target: Anak mampu mengikuti perintah yang lebih kompleks dari orang dewasa.',
            parentTips: [
              'Berikan instruksi dua langkah (',
              ').',
              'Gunakan kalimat yang jelas dan sederhana saat memberikan instruksi.',
              'Berikan pujian saat anak berhasil mengikuti instruksi kompleks.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Mengikuti more complex commands from adults',
            target: 'Target: Anak mampu mengikuti more complex commands from adults.',
            parentTips: [
              'Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.',
              'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.',
              'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Mulai stay dry while sleeping',
            target: 'Target: Anak mampu mulai stay dry while sleeping.',
            parentTips: [
              'Dampingi anak saat berlatih mulai stay dry while sleeping.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Naps less frequently',
            target: 'Target: Anak mampu naps less frequently.',
            parentTips: [
              'Dampingi anak saat berlatih naps less frequently.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 19,
            title: 'Completes toilet training',
            target: 'Target: Anak mampu completes toilet training.',
            parentTips: [
              'Dampingi anak saat berlatih completes toilet training.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berbicara when spoken to',
            target: 'Target: Anak mampu berbicara when spoken to.',
            parentTips: [
              'Sebutkan nama benda-benda di sekitar saat beraktivitas (\\',
              ').',
              'Respons upaya bicara anak dengan antusias dan ulangi kata yang benar tanpa menyalahkan.',
              'Ajak bernyanyi lagu-lagu sederhana yang mengulang kata-kata untuk memperkaya kosakata.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bermain Sendiri (Solitary Play)',
            target: 'Target: Anak mampu asyik bermain sendiri untuk waktu tertentu tanpa merasa cemas.',
            parentTips: [
              'Sediakan ruang bermain yang aman dan mainan edukatif yang merangsang imajinasi (seperti lego atau balok).',
              'Biarkan anak menikmati waktunya bermain sendiri tanpa terlalu banyak interupsi dari orang dewasa.',
              'Tetap awasi anak dari kejauhan untuk memastikan keamanannya saat bermain.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Bermain Berdampingan (Parallel Play)',
            target: 'Target: Anak mampu bermain di dekat teman sebayanya dengan mainan yang mirip meski belum banyak berinteraksi.',
            parentTips: [
              'Ajak anak bermain di taman atau area bermain bersama anak seusianya secara rutin.',
              'Sediakan mainan yang cukup untuk setiap anak untuk menghindari perebutan mainan.',
              'Pahami bahwa bermain berdampingan adalah tahap sosial yang penting sebelum anak mulai berinteraksi penuh.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mulai engage in associative play',
            target: 'Target: Anak mampu mulai engage in associative play.',
            parentTips: [
              'Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.',
              'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.',
              'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bermain with familiar peers often',
            target: 'Target: Anak mampu bermain with familiar peers often.',
            parentTips: [
              'Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.',
              'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.',
              'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Bermain with unfamiliar peers',
            target: 'Target: Anak mampu bermain with unfamiliar peers.',
            parentTips: [
              'Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.',
              'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.',
              'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menikmati playing with adults as well as peers',
            target: 'Target: Anak mampu menikmati playing with adults as well as peers.',
            parentTips: [
              'Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.',
              'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.',
              'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mulai show perspective taking',
            target: 'Target: Anak mampu mulai show perspective taking.',
            parentTips: [
              'Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.',
              'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.',
              'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menyukai praise',
            target: 'Target: Anak mampu menyukai praise.',
            parentTips: [
              'Berikan pujian spesifik atas usaha dan proses, bukan hanya hasil (\\',
              ').',
              'Dorong anak mencoba hal baru dan yakinkan bahwa gagal adalah bagian dari proses belajar.',
              'Tunjukkan ekspresi bangga dan berikan pelukan saat anak menyelesaikan tantangan.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Begins turn taking',
            target: 'Target: Anak mampu begins turn taking.',
            parentTips: [
              'Ajak bermain permainan yang membutuhkan giliran (ular tangga, ludo, petak umpet).',
              'Buat aturan rumah sederhana yang konsisten dan jelaskan alasan di balik setiap aturan.',
              'Berikan pujian spesifik saat anak berhasil berbagi atau menunggu gilirannya dengan sabar.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Menyusun Balok-Balok Kecil',
            target: 'Target: Anak mampu membangun menara atau susunan menggunakan beberapa balok kecil.',
            parentTips: [
              'Sediakan berbagai balok kayu atau plastik berukuran kecil yang berwarna-warni.',
              'Tantang anak menyusun balok setinggi mungkin tanpa roboh untuk melatih kehati-hatian tangan.',
              'Ajak anak meniru pola susunan sederhana yang Anda buat untuk melatih konsentrasi.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Memukul Pasak dengan Palu Mainan',
            target: 'Target: Anak mampu mengarahkan dan memukul pasak mainan menggunakan palu mainan.',
            parentTips: [
              'Sediakan mainan',
              'kayu atau plastik yang aman dan kokoh.',
              'Ajarkan anak memegang palu mainan dengan benar dan mengincar pasak dengan tepat.',
              'Latih kontrol kekuatan tangan anak agar tidak memukul terlalu keras.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Meniru dan Menggambar Bentuk Sederhana',
            target: 'Target: Anak mampu meniru coretan membentuk lingkaran, garis tegak, atau huruf sederhana.',
            parentTips: [
              'Sediakan buku gambar kosong serta spidol warna-warni yang mudah digenggam.',
              'Gambarkan bentuk lingkaran besar di kertas dan minta anak menggambar lingkaran kecil di dalamnya.',
              'Latih gerakan menulis di atas pasir atau tepung menggunakan jari untuk melatih motorik halus.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Berlatih Membuka/Menutup Ritsleting dan Kancing',
            target: 'Target: Anak mampu menarik ritsleting, menekan kancing jepret, dan belajar memasang kancing baju.',
            parentTips: [
              'Berikan pakaian beritsleting besar atau kancing besar untuk mempermudah latihan mandiri.',
              'Gunakan boneka kain atau papan aktivitas yang dilengkapi ritsleting dan kancing sebagai sarana latihan.',
              'Beri dukungan verbal dan bantu anak jika ia merasa kesulitan agar tidak frustrasi.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Menggunakan Gunting Khusus Anak',
            target: 'Target: Anak mampu memotong kertas menggunakan gunting berujung tumpul secara aman.',
            parentTips: [
              'Gunakan gunting plastik khusus balita yang tidak tajam dan hanya bisa memotong kertas.',
              'Pegang kertas dengan erat dan pandu anak menggunting lurus mengikuti garis tebal yang sudah digambar.',
              'Ajarkan anak aturan keselamatan memegang gunting (hanya untuk kertas, tidak boleh untuk rambut atau kulit).',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Membuat Coretan Kuas, Pena, atau Spidol',
            target: 'Target: Anak mampu membuat goresan warna menggunakan kuas cat, pena, pensil, atau spidol.',
            parentTips: [
              'Sediakan cat air non-toksik, kuas besar, dan kertas gambar lebar.',
              'Biarkan anak bebas mengeksplorasi sapuan kuas atau guratan spidol untuk melatih kelenturan pergelangan tangan.',
              'Pajang hasil karya goresan kuas anak sebagai bentuk apresiasi.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Berusaha Memakai Baju Sendiri',
            target: 'Target: Anak mampu mencoba mengenakan kaos longgar, celana karet, atau kaos kaki sendiri.',
            parentTips: [
              'Sediakan pakaian yang longgar dan mudah dipakai (seperti celana pinggang karet).',
              'Berikan instruksi langkah demi langkah (',
              ').',
              'Beri pujian atas setiap usaha anak meskipun posisi pakaian masih terbalik.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Mulai Tidak Mengompol Saat Tidur',
            target: 'Target: Anak mampu menahan buang air kecil atau tetap kering sepanjang malam saat tidur.',
            parentTips: [
              'Batasi minum air putih terlalu banyak menjelang waktu tidur malam anak.',
              'Ajak anak buang air kecil di toilet sesaat sebelum ia naik ke tempat tidur.',
              'Gunakan sprei pelapis anti air (perlak) dan tetap berikan pujian ketika anak bangun pagi dengan popok kering.',
            ],
          ),
          RedleafItem(
            number: 19,
            title: 'Frekuensi Tidur Siang Berkurang',
            target: 'Target: Anak mulai membutuhkan tidur siang yang lebih sedikit atau hanya sekali sehari.',
            parentTips: [
              'Sesuaikan rutinitas harian anak dengan pola tidur siang yang lebih singkat agar tidak mengganggu tidur malamnya.',
              'Sediakan aktivitas tenang di siang hari (membaca buku atau merakit balok) jika anak tidak mengantuk.',
              'Pastikan anak tetap mendapatkan istirahat malam yang cukup (10-12 jam).',
            ],
          ),
          RedleafItem(
            number: 20,
            title: 'Menyelesaikan Latihan Toilet (Toilet Training)',
            target: 'Target: Anak berhasil mengontrol keinginan buang air dan mengomunikasikannya sebelum ke toilet.',
            parentTips: [
              'Lakukan toilet training secara konsisten dengan mengajak anak ke toilet setiap 2 jam sekali.',
              'Gunakan celana dalam biasa (bukan popok sekali pakai) agar anak merasakan basah saat mengompol.',
              'Sabar dan hindari memarahi anak jika terjadi kecelakaan mengompol.',
            ],
          ),
          RedleafItem(
            number: 21,
            title: 'Knows own gender and that of others',
            target: 'Target: Anak mampu knows own gender and that of others.',
            parentTips: [
              'Dampingi anak saat berlatih knows own gender and that of others.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 22,
            title: 'Says I love you without prompting',
            target: 'Target: Anak mampu says i love you without prompting.',
            parentTips: [
              'Dampingi anak saat berlatih says i love you without prompting.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 23,
            title: 'Makes simple choices (between two objects)',
            target: 'Target: Anak mampu makes simple choices (between two objects).',
            parentTips: [
              'Dampingi anak saat berlatih makes simple choices (between two objects).',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 24,
            title: 'Engages in pretend play',
            target: 'Target: Anak mampu engages in pretend play.',
            parentTips: [
              'Dampingi anak saat berlatih engages in pretend play.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Kemandirian',
            target: 'Target: Anak mampu menunjukkan sikap mandiri dalam melakukan aktivitas sehari-hari.',
            parentTips: [
              'Beri kesempatan anak memilih sendiri aktivitas bermain atau pakaian yang ingin dikenakan.',
              'Dorong anak melakukan tugas sederhana sendiri seperti merapikan mainan miliknya atau memakai sepatu.',
              'Hargai setiap usaha kemandirian anak meskipun hasilnya belum sempurna dan berikan bimbingan lembut.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bermain Sendiri (Solitary Play)',
            target: 'Target: Anak mampu asyik bermain sendiri untuk waktu tertentu tanpa merasa cemas.',
            parentTips: [
              'Sediakan ruang bermain yang aman dan mainan edukatif yang merangsang imajinasi (seperti lego atau balok).',
              'Biarkan anak menikmati waktunya bermain sendiri tanpa terlalu banyak interupsi dari orang dewasa.',
              'Tetap awasi anak dari kejauhan untuk memastikan keamanannya saat bermain.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Bermain Berdampingan (Parallel Play)',
            target: 'Target: Anak mampu bermain di dekat teman sebayanya dengan mainan yang mirip meski belum banyak berinteraksi.',
            parentTips: [
              'Ajak anak bermain di taman atau area bermain bersama anak seusianya secara rutin.',
              'Sediakan mainan yang cukup untuk setiap anak untuk menghindari perebutan mainan.',
              'Pahami bahwa bermain berdampingan adalah tahap sosial yang penting sebelum anak mulai berinteraksi penuh.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mulai Bermain Asosiatif (Associative Play)',
            target: 'Target: Anak mulai berinteraksi dengan teman saat bermain, seperti berbagi mainan dan berkomunikasi, tetapi belum memiliki aturan kelompok.',
            parentTips: [
              'Ajak anak bermain permainan yang melibatkan interaksi sederhana, seperti membangun menara balok bersama atau mewarnai bersama.',
              'Dorong anak untuk meminjamkan mainannya dan meminta izin dengan sopan saat ingin meminjam mainan teman.',
              'Bantu anak mengatasi konflik kecil yang muncul dengan mengajarkan solusi damai.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Sering Bermain dengan Teman yang Sudah Dikenal',
            target: 'Target: Anak mampu bermain dengan akrab bersama teman sebaya yang sudah sering ditemuinya.',
            parentTips: [
              'Atur jadwal bermain bersama (playdate) secara rutin dengan tetangga atau kerabat yang seumuran dengan anak.',
              'Dukung anak membangun hubungan pertemanan yang lebih erat dengan menyediakan aktivitas berkelompok.',
              'Amati cara anak berinteraksi dengan temannya dan berikan contoh perilaku ramah.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Bermain dengan Teman yang Baru Dikenal',
            target: 'Target: Anak mampu beradaptasi dan mulai bermain dengan teman baru di lingkungan baru.',
            parentTips: [
              'Dampingi anak saat berada di lingkungan baru (seperti taman bermain baru) untuk membantunya merasa aman.',
              'Bantu anak menyapa teman baru dengan mencontohkan kalimat sederhana (',
              ').',
              'Berikan pujian ketika anak berani menyapa atau berbagi mainan dengan teman baru.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menikmati Bermain dengan Orang Dewasa Maupun Teman Sebaya',
            target: 'Target: Anak merasa senang dan nyaman saat bermain bersama orang tua/orang dewasa lainnya serta anak seusianya.',
            parentTips: [
              'Luangkan waktu untuk ikut serta dalam dunia imajinasi anak (misalnya ikut bermain peran atau merakit balok).',
              'Ajak anak bermain permainan fisik bersama orang tua seperti lempar tangkap bola atau kejar-kejaran.',
              'Jaga keseimbangan antara mendampingi anak bermain dan membiarkannya bersosialisasi dengan teman sebayanya.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mulai Memahami Sudut Pandang Orang Lain (Perspective Taking)',
            target: 'Target: Anak mulai menyadari dan menunjukkan pemahaman bahwa orang lain memiliki perasaan dan keinginan yang berbeda.',
            parentTips: [
              'Gunakan buku cerita bergambar untuk mendiskusikan emosi tokoh (',
              ').',
              'Ajarkan anak berempati ketika melihat orang lain atau temannya sedih dengan memberikan pelukan atau kata-kata hiburan.',
              'Contohkan sikap menghargai perbedaan keinginan dalam kehidupan sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menyukai Pujian atas Usahanya',
            target: 'Target: Anak merasa senang, termotivasi, dan bangga saat menerima pujian positif atas tindakannya.',
            parentTips: [
              'Berikan pujian yang spesifik dan tulus atas usaha anak, bukan hanya hasil akhirnya (',
              ').',
              'Gunakan kata-kata positif dan pelukan hangat untuk memperkuat perilaku baik anak.',
              'Hindari pujian berlebihan yang tidak realistis agar anak belajar menilai usahanya dengan jujur.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Mulai Belajar Menunggu Giliran (Turn Taking)',
            target: 'Target: Anak mampu menunggu gilirannya saat bermain di bawah bimbingan orang dewasa.',
            parentTips: [
              'Mainkan permainan sederhana bersama anak yang membutuhkan giliran, seperti menyusun balok bergantian atau bermain ular tangga.',
              'Gunakan pengukur waktu (timer) atau nyanyian singkat untuk membantu anak memahami kapan gilirannya tiba.',
              'Berikan pujian atas kesabaran anak saat menunggu gilirannya dengan tenang.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Berbagi dan Bergantian Mainan',
            target: 'Target: Anak mampu meminjamkan mainan miliknya kepada teman dan bermain bergantian.',
            parentTips: [
              'Ajarkan konsep kepemilikan dan berbagi dengan bahasa yang mudah dipahami (',
              ').',
              'Contohkan perilaku berbagi dalam aktivitas sehari-hari, seperti membagi makanan secara adil.',
              'Puji anak secara khusus ketika ia berinisiatif membagikan mainannya kepada orang lain.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Mulai Mengekspresikan Perasaan dengan Kata-kata',
            target: 'Target: Anak mampu menyebutkan emosi yang sedang dirasakannya menggunakan kata-kata sederhana.',
            parentTips: [
              'Bantu anak mengidentifikasi dan menamai perasaannya saat sedang emosi (',
              ').',
              'Dengarkan dengan penuh perhatian saat anak mencoba menceritakan apa yang dirasakannya.',
              'Ajarkan cara yang aman untuk menyalurkan emosi negatif, seperti menarik napas dalam-dalam.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Merasa Gembira Sebagian Besar Waktu',
            target: 'Target: Anak menunjukkan suasana hati yang positif dan gembira dalam aktivitas kesehariannya.',
            parentTips: [
              'Ciptakan lingkungan rumah yang penuh kasih sayang, ceria, bebas dari stres, dan aman bagi anak.',
              'Jaga rutinitas harian anak (makan, tidur, bermain) agar tetap teratur sehingga ia merasa aman dan nyaman.',
              'Ajak anak tertawa bersama melalui lelucon ringan, bernyanyi, atau menari bersama.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Three-year-olds ability to concentrate on self-chosen activities increases',
            target: 'Target: Anak mampu three-year-olds ability to concentrate on self-chosen activities increases.',
            parentTips: [
              'Gunakan sepatu mainan besar dengan tali tebal berwarna cerah untuk latihan membuat simpul.',
              'Ajarkan metode \\',
              '(loop and tie) langkah demi langkah secara perlahan.',
              'Beri pujian dan dorongan kesabaran saat anak berhasil mengikat tali sepatunya sendiri.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bercerita atau Menceritakan Kisah Sederhana',
            target: 'Target: Anak mampu menceritakan kisah pendek atau menceritakan kembali peristiwa yang dialaminya.',
            parentTips: [
              'Bacakan buku cerita secara teratur lalu minta anak menceritakan kembali kisahnya dengan bahasanya sendiri.',
              'Tanyakan urutan kejadian yang dialaminya hari ini (',
              ').',
              'Bantu anak merangkai cerita dengan memberikan kata penghubung seperti',
              'atau',
              '.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menikmati Sajak Berima dan Lagu Anak',
            target: 'Target: Anak mampu mendengarkan dan menikmati sajak berima serta lagu-lagu anak.',
            parentTips: [
              'Nyanyikan lagu-lagu berima bersama anak secara rutin.',
              'Bacakan puisi anak atau sajak pendek dengan intonasi yang menarik dan ceria.',
              'Ajak anak melengkapi kata berima di akhir baris sajak harian.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menyukai Mempelajari Kata-kata Baru',
            target: 'Target: Anak senang dan tertarik untuk mempelajari serta menirukan kata-kata baru yang didengarnya.',
            parentTips: [
              'Kenalkan kosakata baru saat beraktivitas atau berjalan-jalan (',
              ').',
              'Jelaskan arti kata baru dengan kalimat sederhana yang mudah dimengerti.',
              'Gunakan kata baru tersebut berulang kali dalam percakapan agar anak hafal.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Sering Bertanya untuk Mencari Tahu',
            target: 'Target: Anak aktif mengajukan pertanyaan seperti "Apa ini?',
            parentTips: [
              'Tanggapi setiap pertanyaan anak dengan sabar dan antusias.',
              'Berikan jawaban logis yang jujur dan mudah dicerna sesuai usia anak.',
              'Dorong anak untuk ikut memikirkan jawabannya terlebih dahulu (',
              ').',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Berbicara dalam Kalimat Berisi 3-4 Kata',
            target: 'Target: Anak mampu merangkai kalimat sederhana yang terdiri dari 3-4 kata untuk berkomunikasi.',
            parentTips: [
              'Tanggapi ucapan pendek anak dengan menggunakan struktur kalimat yang benar dan lengkap.',
              'Ajak anak berbicara tentang kegiatan harian (',
              ',',
              ').',
              'Beri contoh kalimat pendek yang baik saat anak meminta sesuatu.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Berbicara dalam Kalimat Berisi Hingga 7 Kata',
            target: 'Target: Anak mampu berkomunikasi menggunakan kalimat yang lebih panjang hingga 7 kata.',
            parentTips: [
              'Perluas kalimat yang diucapkan anak agar menjadi lebih panjang dan lengkap.',
              'Ajak anak berdiskusi mengenai isi buku cerita dengan kalimat yang bervariasi.',
              'Biarkan anak mengekspresikan keinginannya dalam kalimat yang utuh.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mulai Menggunakan Tata Bahasa yang Benar',
            target: 'Target: Anak mulai menggunakan tata bahasa yang tepat dalam kalimatnya secara bertahap.',
            parentTips: [
              'Hindari menyalahkan atau menertawakan jika tata bahasa anak keliru.',
              'Ulangi ucapan anak dengan susunan kalimat yang benar sebagai contoh (',
              ').',
              'Bacakan buku cerita yang memiliki kalimat terstruktur dengan baik.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Memahami Makna Sebagian Besar Kata Anak Usia Dini',
            target: 'Target: Anak memahami arti sebagian besar kata yang umum digunakan dalam lingkungan anak usia dini.',
            parentTips: [
              'Kenalkan berbagai kata benda, kata sifat, dan kata kerja melalui kegiatan sehari-hari.',
              'Gunakan benda nyata atau gambar saat mengenalkan arti dari suatu kata baru.',
              'Latih pemahaman anak dengan memintanya menunjukkan benda sesuai sifatnya (misal:',
              ').',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Menggunakan Bahasa untuk Bersosialisasi',
            target: 'Target: Anak mampu menggunakan bahasa secara sosial seperti menyapa orang lain, mengucapkan terima kasih, atau meminta izin.',
            parentTips: [
              'Ajarkan kebiasaan menyapa teman atau tetangga saat bertemu.',
              'Contohkan ucapan sopan seperti',
              ',',
              ', dan',
              'secara konsisten dalam keluarga.',
              'Latih anak meminta izin sebelum meminjam mainan orang lain.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Menyukai Buku yang Memiliki Foto Objek Nyata',
            target: 'Target: Anak menikmati membaca buku yang menampilkan gambar atau foto dari benda/makhluk hidup nyata.',
            parentTips: [
              'Sediakan buku ensiklopedia anak bergambar foto hewan, tanaman, atau kendaraan asli.',
              'Ajak anak mencocokkan foto di buku dengan benda asli yang ada di sekitar rumah.',
              'Diskusikan detail foto di buku tersebut bersama anak (',
              ').',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Menyukai Buku Cerita Bergambar',
            target: 'Target: Anak menikmati mendengarkan cerita dari buku yang kaya akan ilustrasi bergambar menarik.',
            parentTips: [
              'Jadikan kegiatan membaca buku cerita bergambar sebagai rutinitas harian yang menyenangkan.',
              'Biarkan anak menunjuk gambar dan menebak isi cerita berdasarkan ilustrasi tersebut.',
              'Tanyakan pendapat anak mengenai gambar favoritnya di buku.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Menyukai Bernyanyi Lagu Sederhana yang Berulang',
            target: 'Target: Anak senang menyanyikan lagu-lagu pendek yang liriknya mudah diingat dan diulang-ulang.',
            parentTips: [
              'Nyanyikan lagu-lagu anak populer secara berulang-ulang bersama anak.',
              'Gunakan gerakan tubuh atau ekspresi wajah saat bernyanyi agar lebih menyenangkan.',
              'Ajak anak membuat variasi lirik sederhana dari lagu favoritnya.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Names simple shapes',
            target: 'Target: Anak mampu names simple shapes.',
            parentTips: [
              'Dampingi anak saat berlatih names simple shapes.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Has increasing memory',
            target: 'Target: Anak mampu has increasing memory.',
            parentTips: [
              'Dampingi anak saat berlatih has increasing memory.',
              'Berikan pujian atas usaha dan ketekunan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mulai Mengeksplorasi Hal Baru atau Ide Secara Sengaja',
            target: 'Target: Anak mampu menjelajahi lingkungan sekitar, mencoba mainan baru, atau mewujudkan ide bermainnya secara sengaja.',
            parentTips: [
              'Fasilitasi rasa ingin tahu anak dengan menyediakan beragam media eksplorasi yang aman (seperti pasir, air, balok).',
              'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.',
              'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menghadapi Situasi dengan Fleksibilitas yang Meningkat',
            target: 'Target: Anak mampu menyesuaikan diri atau mencari cara alternatif ketika menghadapi perubahan situasi atau kesulitan saat bermain.',
            parentTips: [
              'Ajarkan anak untuk beralih ke aktivitas lain jika rencana awalnya tidak berjalan lancar.',
              'Bantu anak menemukan solusi alternatif saat menemui jalan buntu saat memecahkan masalah bermain.',
              'Latih anak menghadapi transisi jadwal harian dengan pemberitahuan singkat sebelumnya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menciptakan Fungsi Baru untuk Suatu Benda',
            target: 'Target: Anak mampu menggunakan benda sehari-hari untuk tujuan bermain kreatif lainnya (misalnya menggunakan kursi sebagai benteng).',
            parentTips: [
              'Sediakan benda-benda sederhana (seperti kotak kardus kosong, kain) untuk merangsang kreativitas bermain peran anak.',
              'Berikan pujian atas gagasan kreatif anak dalam menggunakan objek dengan cara tidak biasa.',
              'Dukung imajinasi anak dengan ikut menggunakan benda tersebut sesuai fungsi imajiner yang ia ciptakan.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '4_years',
    name: '4 Tahun (48-60 Bulan)',
    minAgeMonths: 48,
    maxAgeMonths: 60,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berpakaian dengan Sedikit Bantuan',
            target: 'Target: Anak mampu mengenakan pakaian dan celana sendiri dengan hanya membutuhkan sedikit bantuan orang dewasa.',
            parentTips: [
              'Letakkan pakaian anak di tempat yang mudah dijangkaunya agar ia bisa bersiap-siap secara mandiri.',
              'Bantu anak hanya saat ia kesulitan menyelaraskan bagian kancing atau ritsleting yang rumit.',
              'Sediakan pakaian dengan pengancing yang mudah dibuka-tutup untuk melatih kemandiriannya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Berlari dengan Mudah dan Berhenti dengan Cepat',
            target: 'Target: Anak mampu berlari kencang, mengubah arah, dan berhenti secara mendadak dengan seimbang.',
            parentTips: [
              'Bermain permainan',
              'di mana anak harus berhenti berlari saat mendengar aba-aba tertentu.',
              'Sediakan ruang terbuka yang bebas hambatan agar anak bebas berlari tanpa risiko menabrak barang.',
              'Gunakan sepatu olahraga yang pas dan nyaman agar anak tidak mudah terpeleset.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Melempar Bola dengan Akurasi dan Jarak yang Lebih Baik',
            target: 'Target: Anak mampu melempar bola ke sasaran tertentu dengan kekuatan lengan yang meningkat.',
            parentTips: [
              'Ajak anak bermain lempar sasaran dengan menembak botol plastik kosong menggunakan bola dari jarak beberapa meter.',
              'Contohkan cara memposisikan lengan saat melempar agar bola terarah dengan baik.',
              'Gunakan bola dengan berbagai ukuran untuk melatih kekuatan genggaman dan lemparan.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mengayuh dan Mengemudikan Sepeda Roda Tiga dengan Mudah',
            target: 'Target: Anak mampu mengayuh pedal dan mengarahkan setang sepeda roda tiga tanpa kesulitan.',
            parentTips: [
              'Buat rute meliuk-liuk sederhana menggunakan kapur tulis di lantai untuk dilalui sepeda roda tiga anak.',
              'Puji kemampuannya berbelok dengan mulus saat mengemudikan sepedanya.',
              'Pakaikan pelindung keselamatan seperti helm mini saat anak bermain sepeda.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mulai Mengayuh dan Mengarahkan Sepeda Roda Dua dengan Roda Bantu',
            target: 'Target: Anak mampu mengendarai sepeda roda dua yang dilengkapi dengan roda penyeimbang di sisi kanan dan kiri.',
            parentTips: [
              'Pasang roda bantu yang kokoh pada sepeda anak untuk membantunya merasa aman.',
              'Latih anak mengayuh maju dan mengerem sepeda secara bertahap di jalur yang rata.',
              'Dampingi anak di sampingnya untuk memberikan rasa aman saat ia mulai mengayuh.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Berkembang Fisik dengan Cepat dan Mulai Mencoba Sepeda Roda Dua',
            target: 'Target: Anak menunjukkan perkembangan fisik yang cepat dan siap mencoba sepeda roda dua tanpa roda bantu.',
            parentTips: [
              'Jika keseimbangan anak sudah cukup baik, mulailah melepas roda bantu secara bertahap.',
              'Pegang punggung anak saat ia berlatih menjaga keseimbangan di atas sepeda roda dua.',
              'Latih anak di area terbuka yang luas dan berlapis rumput agar aman jika terjatuh.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menyusun Puzzle dengan Mudah',
            target: 'Target: Anak mampu menyelesaikan susunan puzzle dengan kepingan yang lebih banyak (12-20 keping) tanpa kesulitan.',
            parentTips: [
              'Sediakan berbagai gambar puzzle yang menarik dan sesuai dengan minat anak.',
              'Biarkan anak memecahkan susunan kepingan secara mandiri untuk melatih kemampuan pemecahan masalah.',
              'Berikan bantuan minimal hanya berupa petunjuk arah atau posisi kepingan.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Meniru, Menggunting, Menempel, dan Melukis Menggunakan Kuas',
            target: 'Target: Anak mampu melakukan aktivitas seni terkoordinasi seperti meniru gambar, menggunting kertas, menempelkan, dan melukis kuas dengan rapi.',
            parentTips: [
              'Sediakan aneka kertas warna-warni, lem, gunting anak, dan cat air untuk berkreasi bersama membuat kolase.',
              'Latih cara memegang kuas cat seperti memegang pensil untuk memperkuat motorik halus.',
              'Pajang hasil karya anak di tempat yang terlihat agar ia merasa bangga.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menulis Nama Sendiri',
            target: 'Target: Anak mampu menuliskan nama depannya sendiri secara terbaca menggunakan pensil atau spidol.',
            parentTips: [
              'Latih anak menebalkan garis pembentuk namanya terlebih dahulu secara bertahap.',
              'Beri contoh penulisan nama depannya di kertas dengan huruf cetak besar yang jelas dan biarkan anak menirunya.',
              'Sediakan alat tulis dengan berbagai warna menarik agar anak bersemangat berlatih.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menjadi Lebih Bertanggung Jawab',
            target: 'Target: Anak menunjukkan sikap lebih bertanggung jawab atas tindakan dan barang pribadinya.',
            parentTips: [
              'Berikan tugas harian ringan yang konsisten seperti menaruh baju kotor di keranjang.',
              'Dorong anak untuk membereskan mainannya sendiri setelah selesai bermain.',
              'Puji usaha anak saat ia berhasil menyelesaikan tanggung jawab kecilnya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Terutama Bermain Secara Asosiatif',
            target: 'Target: Anak lebih sering terlibat dalam bermain bersama teman di mana mereka saling berinteraksi dan berbagi mainan.',
            parentTips: [
              'Fasilitasi aktivitas bermain kelompok seperti membuat prakarya bersama atau bermain pasir bersama teman sebaya.',
              'Bantu anak belajar berkompromi saat menentukan mainan yang akan dimainkan bersama.',
              'Dorong anak untuk saling meminjamkan mainan dengan sopan.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Memiliki Rentang Perhatian yang Semakin Panjang',
            target: 'Target: Anak mampu berkonsentrasi pada satu aktivitas (seperti mendengarkan cerita atau merakit mainan) untuk waktu yang lebih lama.',
            parentTips: [
              'Bacakan buku cerita yang memiliki alur cerita sedikit lebih panjang dan menarik.',
              'Biarkan anak menyelesaikan proyek mainannya (seperti merakit balok) tanpa terlalu banyak interupsi.',
              'Batasi waktu layar agar konsentrasi alami anak dapat berkembang dengan baik.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mulai Mengembangkan Kesabaran',
            target: 'Target: Anak mampu mengendalikan emosi dan belajar bersabar menunggu sesuatu.',
            parentTips: [
              'Latih kesabaran anak dengan menggunakan pengukur waktu (timer) saat mengantre mainan.',
              'Jelaskan konsep menunggu dengan bahasa yang positif (',
              ').',
              'Berikan pujian ketika anak berhasil menunggu gilirannya dengan tenang.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Memahami Konsep Perbedaan Laki-laki dan Perempuan',
            target: 'Target: Anak memahami perbedaan fisik dan identitas diri laki-laki serta perempuan dengan benar.',
            parentTips: [
              'Jawab pertanyaan anak tentang perbedaan jenis kelamin secara alami, jujur, dan sederhana.',
              'Jelaskan bahwa anak laki-laki maupun perempuan memiliki kesempatan yang sama dalam belajar dan bermain.',
              'Gunakan buku cerita bergambar untuk membantu menjelaskan perbedaan gender secara positif.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mulai Membangun Hubungan Pertemanan',
            target: 'Target: Anak mulai menunjukkan preferensi terhadap teman bermain tertentu dan membangun jalinan persahabatan.',
            parentTips: [
              'Dukung persahabatan anak dengan mengundang teman bermain favoritnya ke rumah secara berkala.',
              'Ajarkan cara menghargai perasaan teman saat bermain bersama.',
              'Bantu anak memahami pentingnya berbaikan setelah bertengkar kecil.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mulai Mampu Memahami Perasaan Orang Lain',
            target: 'Target: Anak menunjukkan kemampuan berempati dan memahami situasi dari sudut pandang orang lain.',
            parentTips: [
              'Diskusikan perasaan orang lain saat beraktivitas harian (',
              ').',
              'Gunakan buku cerita untuk melatih kepekaan emosi anak terhadap para tokoh cerita.',
              'Contohkan sikap peduli dan menolong di depan anak sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Terbiasa Mengantre and Menunggu Giliran',
            target: 'Target: Anak mampu menunggu gilirannya dengan tertib saat bermain bersama orang lain.',
            parentTips: [
              'Ajak anak bermain papan permainan keluarga yang memerlukan giliran teratur.',
              'Ajarkan anak mengantre di tempat umum seperti saat bermain seluncuran di taman.',
              'Berikan penguatan positif saat ia menunjukkan sikap sabar menunggu.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Terlibat dalam Bermain Kelompok',
            target: 'Target: Anak mampu berpartisipasi aktif dalam permainan kelompok yang terorganisasi.',
            parentTips: [
              'Libatkan anak dalam permainan kelompok sederhana seperti petak umpet bersama teman-temannya.',
              'Ajarkan aturan bermain kelompok dan pentingnya mengikuti aturan tersebut.',
              'Bantu anak belajar menerima kekalahan dalam permainan secara suportif.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Bermain Peran (Role Play)',
            target: 'Target: Anak aktif melakukan permainan peran dengan meniru profesi atau karakter tertentu secara imajinatif.',
            parentTips: [
              'Sediakan kostum sederhana atau peralatan mainan profesi (seperti alat dokter mainan).',
              'Ikut serta dalam permainan peran anak dan biarkan ia memimpin alur ceritanya.',
              'Puji daya imajinasi dan penokohan kreatif yang ditunjukkan anak.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Menggunakan Kata-kata untuk Menyelesaikan Konflik',
            target: 'Target: Anak mampu menggunakan komunikasi verbal untuk mengatasi perselisihan alih-alih menggunakan tindakan fisik.',
            parentTips: [
              'Ajarkan kalimat tegas namun sopan saat terjadi konflik (',
              ').',
              'Bimbing anak membicarakan masalahnya dengan teman secara baik-baik.',
              'Contohkan penyelesaian masalah dengan tenang saat Anda berdiskusi di rumah.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Menunjukkan Rasa Takut yang Wajar',
            target: 'Target: Anak menunjukkan ekspresi takut pada situasi yang tidak dikenal atau hal yang menakutkan baginya.',
            parentTips: [
              'Validasi perasaan takutnya dan berikan pelukan hangat untuk menenangkannya.',
              'Jangan mengejek ketakutan anak, tetapi bantu ia memahami situasinya secara logis.',
              'Temani anak saat ia harus menghadapi situasi yang ditakutinya secara perlahan.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Mungkin Meniru Kata-kata yang Kurang Sopan',
            target: 'Target: Anak sesekali meniru ucapan kurang sopan yang didengarnya dari lingkungan.',
            parentTips: [
              'Tanggapi dengan tenang tanpa reaksi berlebihan agar anak tidak mengulangi kata tersebut hanya untuk mencari perhatian.',
              'Jelaskan secara tegas bahwa kata tersebut kurang baik dan tidak sopan untuk diucapkan.',
              'Berikan alternatif kata yang lebih baik untuk mengekspresikan kekesalan anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berbicara dalam Kalimat Berisi 6-10 Kata',
            target: 'Target: Anak mampu merangkai kalimat yang lebih kompleks dan panjang (6 hingga 10 kata) saat bercakap-cakap.',
            parentTips: [
              'Ajak anak mendiskusikan pengalamannya hari ini menggunakan kalimat lengkap.',
              'Tanggapi cerita anak dengan antusias dan tanyakan detail kejadiannya.',
              'Bacakan buku cerita secara teratur untuk memperkaya susunan kalimat anak.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bernyanyi Lagu yang Lebih Rumit dan Menyukai Sajak Gerak Jari',
            target: 'Target: Anak mampu menyanyikan lagu anak yang memiliki melodi atau lirik lebih panjang, serta menyukai permainan gerak jari.',
            parentTips: [
              'Ajarkan lagu anak yang memiliki lirik bercerita atau melodi yang bervariasi.',
              'Latih koordinasi motorik dan bahasa anak dengan bermain permainan gerak jari (seperti',
              ').',
              'Nyanyikan lagu-lagu berima bersama anak saat waktu senggang.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menceritakan Kisah Sederhana Secara Berurutan',
            target: 'Target: Anak mampu menceritakan kembali sebuah kejadian atau isi buku cerita dengan urutan waktu yang jelas.',
            parentTips: [
              'Minta anak menceritakan kembali alur buku cerita yang baru saja dibaca bersama.',
              'Bantu anak merangkai kronologi kejadian dengan pertanyaan pemandu (',
              ').',
              'Dengarkan cerita anak dengan penuh perhatian dan berikan respon positif.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mengeja Huruf-huruf Nama Sendiri',
            target: 'Target: Anak mampu menyebutkan urutan huruf pembentuk nama depannya secara verbal.',
            parentTips: [
              'Tempelkan nama anak di dinding kamarnya dan tunjuk satu per satu hurufnya sambil dieja bersama.',
              'Latih mengeja nama lewat lagu sederhana yang dinyanyikan bersama.',
              'Ajak anak menyusun huruf-huruf namanya menggunakan mainan huruf magnet tempel.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menggunakan Ucapan yang Sesuai dengan Konteks',
            target: 'Target: Anak mampu menggunakan bahasa dan nada suara yang tepat sesuai dengan situasi sosial dan lawan bicaranya.',
            parentTips: [
              'Contohkan cara berbicara yang sopan dan ramah di depan umum.',
              'Ingatkan anak dengan lembut jika suaranya terlalu keras di ruangan yang tenang.',
              'Latih anak mendengarkan saat orang lain sedang berbicara sebelum ia mulai menyahut.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mengikuti Petunjuk Tiga Langkah',
            target: 'Target: Anak mampu memahami dan melakukan instruksi yang terdiri dari tiga langkah berturut-turut.',
            parentTips: [
              'Berikan instruksi bertahap yang jelas (',
              ').',
              'Latih anak melakukan tugas harian secara mandiri menggunakan instruksi beruntun.',
              'Berikan pujian ketika anak berhasil menyelesaikan seluruh instruksi tanpa lupa.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menyebutkan Istilah "Kemarin" dan "Besok" dengan Benar',
            target: 'Target: Anak mampu memahami perbedaan waktu lampau dan yang akan datang serta menggunakannya secara tepat.',
            parentTips: [
              'Diskusikan rencana hari esok kepada anak sebelum ia tidur malam.',
              'Ingatkan anak tentang kegiatan menyenangkan yang ia lakukan kemarin.',
              'Gunakan kalender anak bergambar untuk membantu memahami konsep hari.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mengetahui Nama Depan dan Nama Belakang Sendiri',
            target: 'Target: Anak mampu menyebutkan nama lengkapnya (nama depan dan nama belakang) saat ditanya.',
            parentTips: [
              'Sering-seringlah menanyakan nama lengkap anak dalam permainan pengenalan diri sederhana.',
              'Latih anak memperkenalkan diri secara lengkap kepada kerabat baru.',
              'Tuliskan nama lengkap anak bersama-sama di buku gambarnya.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Mengucapkan Kata dan Bunyi Huruf dengan Benar',
            target: 'Target: Anak mampu melafalkan sebagian besar kata dengan jelas dan artikulasi yang tepat.',
            parentTips: [
              'Bicara dengan artikulasi yang jelas di depan anak dan hindari menggunakan bahasa bayi.',
              'Perbaiki ucapan anak yang kurang tepat dengan mengulangi kata yang benar secara lembut.',
              'Konsultasikan ke dokter jika anak masih mengalami kesulitan melafalkan banyak bunyi huruf dasar.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Menggunakan Kata Ganti Secara Tepat dalam Kalimat',
            target: 'Target: Anak mampu menggunakan kata ganti orang (aku, kamu, dia, mereka, kita) secara tepat dalam kalimatnya.',
            parentTips: [
              'Contohkan penggunaan kata ganti orang yang benar saat bercakap-cakap dengan anak.',
              'Koreksi secara halus jika anak tertukar menggunakan kata ganti orang saat bercerita.',
              'Bacakan buku cerita yang kaya akan dialog antar tokoh untuk melatih konsep kata ganti.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mulai Menalan Sederhana',
            target: 'Target: Anak mampu menghubungkan sebab-akibat sederhana dan membuat perkiraan logis dalam aktivitasnya.',
            parentTips: [
              'Tanyakan pertanyaan pemantik seperti',
              'atau',
              '.',
              'Bimbing anak mencari solusi dari masalah sederhana yang ia temui saat bermain.',
              'Diskusikan hubungan sebab-akibat ketika melakukan aktivitas sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bermain dengan Tema yang Lebih Berkembang',
            target: 'Target: Anak mampu memainkan permainan peran dengan alur skenario fiksi yang lebih terstruktur.',
            parentTips: [
              'Sediakan aksesoris mainan peran sederhana (seperti cangkir plastik atau kostum dokter mainan).',
              'Ikutlah bergabung dalam skenario bermain peran anak dengan memerankan tokoh tertentu.',
              'Dukung imajinasi anak saat ia menyusun cerita petualangannya sendiri.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Memahami Konsep Sederhana',
            target: 'Target: Anak memahami arah posisi (atas-bawah, depan-belakang) dan perbandingan kuantitas dasar.',
            parentTips: [
              'Latih konsep posisi dengan menyembunyikan mainan lalu beri instruksi petunjuk (',
              ').',
              'Gunakan balok mainan untuk menjelaskan konsep',
              'dan',
              '.',
              'Ajak anak merapikan mainan dengan meletakkannya',
              'atau',
              'keranjang.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Memahami Konsep Usia',
            target: 'Target: Anak mampu membandingkan umur sederhana antara dirinya dan orang lain.',
            parentTips: [
              'Gunakan perayaan ulang tahun anggota keluarga sebagai momen menjelaskan konsep usia dan angka tahunnya.',
              'Ajak anak membandingkan tingginya dengan adiknya atau teman sebaya yang berbeda usia.',
              'Diskusikan urutan pertumbuhan dari bayi hingga dewasa.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Memahami Konsep Jumlah Benda',
            target: 'Target: Anak mampu menghitung dan memahami makna jumlah benda nyata hingga setidaknya 5 benda.',
            parentTips: [
              'Ajak anak menghitung jumlah piring saat menata meja makan bersama.',
              'Minta anak mengambilkan sejumlah benda tertentu (',
              ').',
              'Bermain mencocokkan jumlah benda dengan angka mainan yang sesuai.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Memahami Konsep Ukuran',
            target: 'Target: Anak memahami perbandingan dimensi ukuran (besar-kecil, tinggi-rendah).',
            parentTips: [
              'Ajak anak membandingkan ukuran berbagai benda di taman (',
              ').',
              'Gunakan mainan susun gelas untuk mengajarkan urutan ukuran dari yang terbesar hingga terkecil.',
              'Beri kesempatan anak melabeli ukuran mainannya.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Memahami Konsep Berat',
            target: 'Target: Anak mampu membedakan benda yang berat dan ringan saat memegangnya.',
            parentTips: [
              'Letakkan buah melon dan apel di kedua tangan anak, lalu minta menebak mana yang lebih berat.',
              'Bermain membandingkan mainan plastik dan mainan kayu yang ukurannya sama.',
              'Bahas konsep berat saat membawa barang belanjaan bersama anak.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Memahami Konsep Pengelompokan Warna',
            target: 'Target: Anak terampil mengelompokkan benda-benda berdasarkan kesamaan warnanya.',
            parentTips: [
              'Sediakan mainan kancing baju warna-warni dan minta anak memilahnya ke dalam mangkok sesuai warnanya.',
              'Ajak anak menyortir kaos kaki bersih berdasarkan warnanya setelah dicuci.',
              'Bermain menebak warna barang-barang di sekitar ruangan.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Memahami Konsep Bentuk Geometri',
            target: 'Target: Anak mampu mengenali dan menyebutkan bentuk lingkaran, persegi, dan segitiga di sekitarnya.',
            parentTips: [
              'Ajak anak berburu bentuk geometri di rumah (seperti jam dinding lingkaran atau jendela persegi).',
              'Gunakan cetakan kue berbentuk segitiga atau bintang saat memasak bersama.',
              'Latih menggambar bentuk-bentuk geometri dasar menggunakan krayon.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Memahami Konsep Tekstur Benda',
            target: 'Target: Anak peka membedakan tekstur permukaan (kasar, halus, lembut, licin).',
            parentTips: [
              'Sediakan kain flanel, kertas pasir, dan spons cuci piring untuk diraba anak demi mengenalkan tekstur.',
              'Ajak anak menyentuh permukaan batang pohon dan daun saat bermain di taman.',
              'Gunakan kata-kata deskriptif seperti',
              'saat mengelus bulu boneka.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Memahami Konsep Jarak',
            target: 'Target: Anak memahami konsep jarak jauh dan dekat secara sederhana.',
            parentTips: [
              'Bahas perjalanan menuju rumah nenek untuk menjelaskan makna',
              '(butuh kendaraan) dan',
              '(bisa jalan kaki).',
              'Ajak anak melempar bola ke sasaran dekat dan sasaran jauh.',
              'Bandingkan posisi parkir mobil yang dekat pintu masuk dengan yang jauh.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Mengelompokkan atau Mengategorikan Benda',
            target: 'Target: Anak mampu memilah benda berdasarkan kategori fungsi (makanan, mainan, atau pakaian).',
            parentTips: [
              'Libatkan anak menyortir mainan ke dalam wadah yang berbeda sesuai jenisnya.',
              'Ajak anak merapikan bahan makanan belanjaan bersama (misal buah dipisahkan dari sayur).',
              'Bermain tebak-tebakan kelompok benda mana yang tidak sejenis.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Mengurutkan Benda secara Runtut',
            target: 'Target: Anak mampu menyusun benda berurutan berdasarkan ukuran atau pola waktu.',
            parentTips: [
              'Sediakan beberapa boneka dengan berbagai ukuran, minta anak menyusunnya dari terpendek ke tertinggi.',
              'Latih anak mengurutkan foto perkembangan dirinya dari bayi hingga sekarang.',
              'Ajarkan konsep urutan rutinitas pagi (bangun tidur, sikat gigi, sarapan).',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Mengenali Pola Sederhana',
            target: 'Target: Anak mampu mengidentifikasi dan meniru pola berulang sederhana.',
            parentTips: [
              'Susun balok mainan dengan pola selang-seling warna (merah-biru-merah), lalu minta anak melanjutkan.',
              'Ajak anak membuat gelang manik-manik dengan pola warna berulang.',
              'Tepuk tangan dengan pola ketukan berulang dan minta anak menirunya.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Menghitung Benda dengan Suara Nyaring',
            target: 'Target: Anak mampu menghitung jumlah benda secara verbal dari 1 hingga 10 sambil menunjuk bendanya.',
            parentTips: [
              'Latih anak menghitung jumlah anak tangga saat menaikinya bersama Anda secara ceria.',
              'Hitung jumlah buah apel di dalam keranjang belanjaan.',
              'Gunakan lagu berhitung untuk mempermudah ingatan anak.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Tertarik pada Huruf-huruf Alfabet',
            target: 'Target: Anak menunjukkan minat pada simbol huruf, menanyakan nama huruf, atau mencoba mengenali huruf depannya.',
            parentTips: [
              'Pasang poster huruf alfabet berwarna menarik di dinding kamar tidur anak.',
              'Gunakan biskuit atau mainan berbentuk huruf untuk memancing ketertarikannya.',
              'Nyanyikan lagu alfabet bersama dengan penuh semangat.',
            ],
          ),
          RedleafItem(
            number: 17,
            title: 'Mengembangkan Literasi Dini',
            target: 'Target: Anak gemar membuka buku bergambar, menceritakan gambar, atau menirukan proses membaca.',
            parentTips: [
              'Bacakan buku cerita bergambar secara rutin sebelum tidur malam.',
              'Ajak anak menceritakan kembali isi gambar di dalam buku menggunakan bahasanya sendiri.',
              'Sediakan perpustakaan mini dengan rak buku ramah jangkauan anak.',
            ],
          ),
          RedleafItem(
            number: 18,
            title: 'Mengidentifikasi Warna',
            target: 'Target: Anak mampu menyebutkan nama warna-warna dasar dengan tepat saat ditunjukkan.',
            parentTips: [
              'Tanyakan warna pakaian yang dikenakan anak setiap hari.',
              'Berikan krayon warna-warni dan biarkan ia menggambar sambil mengenalkan warna.',
              'Ajak anak bermain tebak warna buah-buahan di supermarket.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mengerjakan Tugas Meskipun Ada Gangguan',
            target: 'Target: Anak mampu tetap fokus menyelesaikan aktivitasnya meskipun ada kebisingan atau interupsi kecil di sekitarnya.',
            parentTips: [
              'Ciptakan suasana tenang saat anak sedang asyik menyelesaikan sebuah prakarya.',
              'Berikan pujian khusus ketika anak berhasil menyelesaikan tugasnya hingga tuntas tanpa terganggu.',
              'Latih konsentrasi anak secara bertahap mulai dari durasi waktu yang pendek.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mencari dan Menerima Bantuan serta Informasi',
            target: 'Target: Anak berani meminta tolong kepada orang dewasa ketika menemui kesulitan serta mau mendengarkan petunjuk bantuan.',
            parentTips: [
              'Sambut pertanyaan atau permintaan tolong anak dengan ramah agar ia merasa aman mencari bantuan.',
              'Dorong anak mengungkapkan kesulitannya secara verbal (',
              ').',
              'Ajarkan anak menerima informasi atau solusi baru dengan sikap yang baik.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menawarkan Ide dan Saran',
            target: 'Target: Anak aktif mengusulkan ide-ide kreatif atau memberikan saran saat sedang bermain atau berdiskusi.',
            parentTips: [
              'Tanyakan pendapat anak mengenai kegiatan apa yang ingin dilakukan bersama di akhir pekan.',
              'Dengarkan usulan ide kreatif anak dengan antusias dan cobalah untuk mempraktikkannya.',
              'Beri kesempatan anak memimpin permainan dengan idenya sendiri.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menerapkan Pengalaman Masa Lalu pada Situasi Baru',
            target: 'Target: Anak mampu menggunakan pemahaman dari kejadian sebelumnya untuk menyelesaikan tantangan baru.',
            parentTips: [
              'Ajak anak mengingat kembali cara ia memecahkan masalah sebelumnya (',
              ').',
              'Bimbing anak menghubungkan informasi lama dengan tugas baru yang sedang dikerjakannya.',
              'Diskusikan pelajaran yang didapat anak setelah ia berhasil memecahkan suatu masalah.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '5_years',
    name: '5 Tahun (60-72 Bulan)',
    minAgeMonths: 60,
    maxAgeMonths: 72,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Melempar Bola ke Sasaran',
            target: 'Target: Anak mampu melempar bola dengan terarah menggunakan teknik lemparan dari atas maupun bawah tangan ke sasaran yang ditentukan.',
            parentTips: [
              'Buat target sasaran berupa lingkaran di dinding atau keranjang di lantai.',
              'Latih anak melakukan lemparan dari atas kepala dan bawah lengan secara bergantian.',
              'Gunakan bola yang empuk untuk melatih kekuatan dan ketepatan lemparan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menangkap Bola Lemparan atau Pantulan',
            target: 'Target: Anak mampu menangkap bola kecil yang dilempar langsung atau dipantulkan dari jarak 1-2 meter menggunakan kedua tangannya.',
            parentTips: [
              'Gunakan bola tenis atau bola busa empuk agar anak tidak takut menangkap.',
              'Lemparkan bola secara perlahan dan bimbing anak merapatkan tangannya saat bola mendekat.',
              'Latih anak menangkap bola pantul yang memantul dari dinding.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menjaga Keseimbangan Tubuh dengan Baik',
            target: 'Target: Anak mampu menjaga keseimbangan dengan berdiri satu kaki hingga 10 detik atau berjalan di atas garis sempit.',
            parentTips: [
              'Bermain tebak-tebakan burung bangau (berdiri satu kaki) bersama keluarga.',
              'Buat jalur lurus menggunakan selotip di lantai dan minta anak berjalan di atasnya dengan tumit menyentuh jari kaki.',
              'Latih berjalan di permukaan yang bervariasi seperti pasir atau matras.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menggunakan Tangan Dominan',
            target: 'Target: Anak secara konsisten menunjukkan preferensi penggunaan salah satu tangan (kanan atau kiri) untuk menggambar atau makan.',
            parentTips: [
              'Amati tangan mana yang paling sering digunakan anak saat menulis atau memegang sendok.',
              'Dukung kebiasaan tangan dominannya tanpa memaksa anak kidal berpindah tangan.',
              'Latih koordinasi tangan dominan dengan kegiatan menggunting atau memasang kancing.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Melompati Rintangan Tanpa Jatuh',
            target: 'Target: Anak mampu melompati rintangan setinggi 20-25 cm secara mandiri menggunakan kedua kaki bersamaan.',
            parentTips: [
              'Letakkan kardus mainan kecil atau guling rendah sebagai rintangan lompatan.',
              'Contohkan cara menekuk lutut sebelum dan sesudah melompat agar mendarat dengan aman.',
              'Pastikan area bermain bebas dari benda keras atau tajam.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menggunakan Otot Besar untuk Berbagai Aktivitas Fisik',
            target: 'Target: Anak terampil mengkoordinasikan gerakan motorik kasar seperti berlari cepat, skip (melompat berirama), berguling, menendang, dan melompat.',
            parentTips: [
              'Sediakan ruang bermain di luar rumah seperti lapangan rumput agar anak leluasa bergerak.',
              'Ajak bermain sepak bola sederhana atau kejar-kejaran bersama teman sebaya.',
              'Latih kelenturan tubuh anak dengan gerakan merangkak atau berguling di atas matras.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Belajar Melompat Tali',
            target: 'Target: Anak mampu melakukan gerakan lompat tali tunggal secara berulang.',
            parentTips: [
              'Mulailah dengan tali yang diputar perlahan oleh dua orang dewasa dan anak melompatinya saat menyentuh lantai.',
              'Ajarkan koordinasi ketukan kaki dengan irama tali yang berputar.',
              'Berikan pujian atas setiap keberhasilan anak melompati tali.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Belajar Mengikat Tali Sepatu',
            target: 'Target: Anak mampu membuat simpul dan belajar mengikat tali sepatunya.',
            parentTips: [
              'Gunakan model sepatu latihan kayu atau karton tebal dengan tali yang berwarna kontras.',
              'Ajarkan langkah demi langkah membuat simpul dasar secara sabar.',
              'Latih kelenturan jari anak dengan meronce manik-manik sebelum belajar mengikat tali.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Mulai Mengikat Tali Sepatu Secara Mandiri',
            target: 'Target: Anak terbiasa mengencangkan dan mengikat tali sepatu atau pakaiannya secara mandiri.',
            parentTips: [
              'Ajarkan metode simpul',
              '(loop and tie) secara perlahan dan berulang.',
              'Berikan waktu ekstra bagi anak untuk memakai sepatunya sendiri sebelum pergi.',
              'Gunakan sepatu dengan tali yang tidak terlalu licin.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Mengendarai Sepeda Roda Dua',
            target: 'Target: Anak mampu mengendarai sepeda roda dua tanpa roda bantu dengan seimbang.',
            parentTips: [
              'Dampingi anak saat awal melepas roda bantu sepedanya.',
              'Pegang bahu atau punggung anak dengan lembut untuk memberikan rasa aman saat ia mulai mengayuh.',
              'Pakaikan pelindung keselamatan lengkap seperti helm dan pelindung lutut.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Memegang Alat Tulis dengan Genggaman 3 Jari',
            target: 'Target: Anak memegang pensil atau krayon menggunakan jari jempol, telunjuk, dan jari tengah secara ergonomis.',
            parentTips: [
              'Berikan pensil segitiga berukuran pendek agar anak secara alami menggunakan genggaman tiga jari.',
              'Bimbing posisi jari yang benar saat anak menggambar atau menulis.',
              'Latih kekuatan jari-jari dengan meremas playdough atau menjepit jemuran.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berbagi dan Bergantian Mainan',
            target: 'Target: Anak mampu berbagi mainan dan menunggu gilirannya dengan sabar saat bermain bersama teman.',
            parentTips: [
              'Ajak anak bermain papan permainan keluarga (seperti ular tangga) untuk melatih konsep giliran.',
              'Puji kesabaran anak secara khusus saat ia rela berbagi mainan miliknya dengan teman.',
              'Diskusikan pentingnya sikap murah hati dan berbagi dalam hubungan pertemanan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bermain Permainan Beraturan Sederhana',
            target: 'Target: Anak mampu memahami dan mematuhi aturan dasar dalam permainan terstruktur (seperti petak umpet).',
            parentTips: [
              'Jelaskan aturan permainan secara ringkas dan jelas sebelum permainan dimulai.',
              'Bantu anak mengelola emosi dan kekecewaannya jika ia kalah dalam permainan.',
              'Berikan apresiasi atas sikap sportif anak yang mengikuti aturan main dengan jujur.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mematuhi dan Membuat Aturan Sederhana',
            target: 'Target: Anak mampu mengikuti aturan yang berlaku dan berpartisipasi membuat kesepakatan sederhana saat bermain.',
            parentTips: [
              'Libatkan anak dalam membuat kesepakatan harian di rumah (seperti merapikan tempat tidur).',
              'Bahas konsekuensi logis secara lembut jika ada aturan yang disepakati bersama dilanggar.',
              'Konsisten dalam menerapkan aturan rumah agar anak merasa aman dan terbiasa.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Bermain Bersama Teman Sebaya',
            target: 'Target: Anak mampu berinteraksi secara positif, bekerja sama, dan menjalin pertemanan dengan teman seusianya.',
            parentTips: [
              'Fasilitasi kegiatan bermain kelompok dengan teman sebaya di taman atau halaman rumah.',
              'Ajarkan cara menyelesaikan konflik kecil atau perebutan mainan lewat kompromi.',
              'Latih cara menyapa dan mengajak teman baru bermain dengan sopan.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bermain Mandiri Secara Positif',
            target: 'Target: Anak mampu asyik bermain sendiri secara konstruktif dan menyelesaikan tugas tanpa ketergantungan penuh.',
            parentTips: [
              'Sediakan sudut bermain khusus dengan buku gambar, krayon, atau balok susun.',
              'Biarkan anak mengeksplorasi imajinasinya sendiri tanpa selalu diarahkan oleh orang dewasa.',
              'Tetap awasi anak dari jarak aman tanpa mengganggu fokus permainannya.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mengekspresikan Emosi Diri',
            target: 'Target: Anak mampu menyadari, menamai, dan mengekspresikan emosi diri menggunakan kata-kata yang pantas.',
            parentTips: [
              'Bantu anak menamai perasaannya saat sedang kesal atau marah (',
              ').',
              'Ajarkan teknik menenangkan diri seperti menarik napas dalam-dalam sebelum berbicara.',
              'Dengarkan penjelasan anak mengenai perasaannya tanpa langsung menyalahkan.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Berani Mencoba Hal Baru',
            target: 'Target: Anak menunjukkan rasa percaya diri untuk mencoba aktivitas, makanan, atau lingkungan baru yang belum dikenal.',
            parentTips: [
              'Berikan semangat dan dorongan positif saat anak ragu mencoba hal baru.',
              'Yakinkan anak bahwa melakukan kesalahan atau kegagalan awal adalah bagian normal dari belajar.',
              'Dampingi anak saat mencoba makanan baru secara perlahan tanpa memaksakannya.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Merespons Pujian dengan Baik',
            target: 'Target: Anak menerima pujian dengan rasa bangga yang wajar dan termotivasi mempertahankan perilaku baik.',
            parentTips: [
              'Berikan pujian tulus yang berfokus pada usaha dan kerja keras anak (',
              ').',
              'Tunjukkan ekspresi bangga melalui senyuman, acungan jempol, atau pelukan hangat.',
              'Hindari pujian berlebihan yang tidak sesuai fakta agar anak belajar menilai dirinya secara realistis.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Memiliki Inisiatif dan Kemandirian',
            target: 'Target: Anak berinisiatif memulai aktivitas harian sendiri (seperti mencuci tangan) tanpa harus diperintah.',
            parentTips: [
              'Letakkan perlengkapan harian (seperti sabun cuci tangan) di tempat yang mudah dijangkau anak.',
              'Biarkan anak mengambil keputusan kecil sendiri (misal: memilih buku yang ingin dibaca).',
              'Berikan tugas-tugas rumah tangga ringan untuk memupuk rasa tanggung jawabnya.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Peka terhadap Perasaan Orang Lain (Empati)',
            target: 'Target: Anak mampu merasakan kesedihan atau kegembiraan orang lain dan menunjukkan sikap peduli.',
            parentTips: [
              'Ajak anak menghibur atau membantu temannya yang sedang terjatuh atau menangis.',
              'Diskusikan perasaan tokoh dalam buku cerita yang sedang dibaca bersama.',
              'Contohkan sikap peduli dan empati kepada tetangga atau anggota keluarga sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Hubungan Erat dengan Keluarga dan Saudara',
            target: 'Target: Anak menunjukkan ikatan emosional yang erat serta sikap kasih sayang kepada keluarga.',
            parentTips: [
              'Luangkan waktu berkumpul bersama keluarga secara rutin tanpa gawai untuk mengobrol.',
              'Latih anak bekerja sama dengan saudaranya dalam merapikan mainan bersama.',
              'Ciptakan momen-momen kebersamaan yang hangat seperti piknik keluarga atau berkebun bersama.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berbagi dan Bergantian Mainan',
            target: 'Target: Anak mampu berbagi mainan dan menunggu gilirannya dengan sabar saat bermain bersama teman.',
            parentTips: [
              'Ajak anak bermain papan permainan keluarga (seperti ular tangga) untuk melatih konsep giliran.',
              'Puji kesabaran anak secara khusus saat ia rela berbagi mainan miliknya dengan teman.',
              'Diskusikan pentingnya sikap murah hati dan berbagi dalam hubungan pertemanan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Berbicara Lancar dengan Kalimat Rinci',
            target: 'Target: Anak mampu menceritakan suatu kejadian secara lancar menggunakan kalimat yang kompleks dan mendetail.',
            parentTips: [
              'Dengarkan dengan penuh perhatian saat anak menceritakan kegiatannya tanpa memotong.',
              'Tanggapi dengan memperluas deskripsi anak (',
              ').',
              'Ajak anak menceritakan runtutan kegiatannya dari pagi hingga sore.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Berargumen dan Menggunakan Kata "Karena"',
            target: 'Target: Anak mampu memberikan alasan yang jelas atas pendapatnya menggunakan konjungsi sebab-akibat ("karena").',
            parentTips: [
              'Tanyakan alasan di balik keputusan atau keinginan anak (',
              ').',
              'Latih anak mengekspresikan pikirannya secara logis dalam percakapan sehari-hari.',
              'Respons argumen anak dengan penjelasan yang masuk akal.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mengarang Cerita Sendiri',
            target: 'Target: Anak mampu mengarang dan menceritakan kisah khayalan buatannya sendiri dengan alur yang runtut.',
            parentTips: [
              'Berikan kata pemantik cerita (',
              ') dan biarkan anak berimajinasi melanjutkannya.',
              'Dukung anak membuat buku cerita sederhana sendiri dengan gambar dan tulisan tangannya.',
              'Rekam suara anak saat bercerita lalu putar kembali agar ia bisa mendengarnya.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bercakap-cakap Lancar dengan Orang Dewasa',
            target: 'Target: Anak mampu melakukan percakapan timbal balik yang bermakna dan mengalir lancar bersama orang dewasa.',
            parentTips: [
              'Ajak anak berdiskusi ringan tentang berbagai topik saat makan bersama atau di perjalanan.',
              'Gunakan tata bahasa yang baik dan hindari menyederhanakan bahasa terlalu berlebihan.',
              'Berikan respon yang menghargai cara berpikir dan opini anak.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Memiliki Kosakata yang Luas',
            target: 'Target: Anak memahami dan mampu menggunakan berbagai kosakata baru dalam kehidupan sehari-hari.',
            parentTips: [
              'Bacakan buku dengan tema yang bervariasi (seperti ensiklopedia anak atau dongeng rakyat).',
              'Jelaskan arti kata-kata sulit yang baru didengar anak dengan analogi sederhana.',
              'Gunakan kosakata baru tersebut secara berulang dalam percakapan keluarga.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menggunakan Bahasa untuk Mengatur Permainan',
            target: 'Target: Anak mampu menggunakan bahasa untuk memimpin, membagi peran, atau menyusun aturan bermain bersama temannya.',
            parentTips: [
              'Biarkan anak belajar menyelesaikan pembagian peran bermain secara mandiri dengan teman-temannya.',
              'Contohkan cara memimpin atau mengarahkan teman secara santun dan ramah.',
              'Ajak bermain peran di mana anak bertugas menjadi pemimpin aktivitas (misal: guru).',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Sering Mengajukan Pertanyaan',
            target: 'Target: Anak aktif bertanya mengenai berbagai hal untuk memuaskan rasa ingin tahunya.',
            parentTips: [
              'Sambut setiap pertanyaan kritis anak dengan sabar dan penuh minat.',
              'Jika Anda tidak tahu jawabannya, ajak anak mencari tahu bersama di buku atau internet aman.',
              'Ajukan balik pertanyaan terbuka untuk merangsang rasa penasaran anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menghitung 20+ Benda Secara Akurat',
            target: 'Target: Anak mampu menghitung jumlah benda nyata secara bersuara dan tepat hingga angka 20 atau lebih.',
            parentTips: [
              'Ajak anak menghitung kancing baju, kerikil, atau manik-manik saat bermain.',
              'Pastikan jari anak menunjuk benda yang dihitung secara runtut tanpa melompati angka.',
              'Mainkan permainan tebak jumlah benda yang ada di sekitar rumah.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menggunakan Istilah Pengukuran',
            target: 'Target: Anak mampu menggunakan istilah perbandingan ukuran (lebih berat, lebih panjang, lebih lama) secara tepat.',
            parentTips: [
              'Ajak anak membandingkan panjang dua tali mainan atau ranting kayu.',
              'Gunakan timbangan gantungan sederhana untuk melihat benda mana yang lebih berat.',
              'Diskusikan konsep durasi waktu (',
              ').',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Memahami Konsep Utuh dan Separuh',
            target: 'Target: Anak memahami konsep pembagian suatu benda utuh menjadi dua bagian sama besar (separuh/setengah).',
            parentTips: [
              'Libatkan anak saat memotong buah apel atau roti tawar menjadi dua bagian sama besar.',
              'Jelaskan konsep',
              'dan',
              'menggunakan media konkret.',
              'Gunakan playdough untuk membuat bentuk bulat utuh lalu dipotong menjadi setengah.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mencocokkan Benda dengan Mudah',
            target: 'Target: Anak mampu mencocokkan benda yang identik atau memiliki relasi fungsional dengan cepat.',
            parentTips: [
              'Ajak anak bermain permainan memori kartu dengan memasangkan gambar yang sama.',
              'Minta anak memasangkan sepatu atau kaos kaki bersih sesuai dengan warna dan polanya.',
              'Latih pencocokan objek dengan benda-benda rumah tangga (tutup toples dengan toplesnya).',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mengenal Nama Mata Uang',
            target: 'Target: Anak mampu membedakan beberapa pecahan mata uang rupiah berbentuk koin maupun kertas.',
            parentTips: [
              'Tunjukkan perbedaan fisik koin dan uang kertas rupiah kepada anak.',
              'Jelaskan fungsi uang sebagai alat pembayaran secara sederhana melalui permainan jual-beli mainan.',
              'Latih anak mengenali angka nominal yang tertera pada uang.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Memperkirakan Jumlah Benda dalam Kelompok',
            target: 'Target: Anak mampu memperkirakan atau menebak jumlah benda dalam sebuah wadah tanpa menghitung satu per satu.',
            parentTips: [
              'Letakkan beberapa kelereng dalam gelas plastik transparan dan minta anak memperkirakan jumlahnya.',
              'Tanyakan perbandingan kuantitas secara visual (',
              ').',
              'Hitung bersama setelah anak menebak untuk memverifikasi hasilnya.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menggambar Bentuk Geometri dan Figur Manusia',
            target: 'Target: Anak mampu menggambar bentuk geometri dasar secara mandiri dan menggambar figur manusia dengan detail bagian tubuh minimal 6 bagian.',
            parentTips: [
              'Ajak anak menggambar potret diri atau potret keluarga bersama-sama.',
              'Diskusikan bagian tubuh yang perlu digambar (',
              ').',
              'Sediakan kertas gambar lebar dan pensil warna yang nyaman digenggam.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mengelompokkan dan Menyusun Benda Berurutan',
            target: 'Target: Anak mampu mengelompokkan benda berdasarkan beberapa sifat sekaligus dan mengurutkannya secara teratur.',
            parentTips: [
              'Minta anak menyusun mainan balok berdasarkan warna dan mengurutkannya dari yang terpendek hingga terpanjang.',
              'Latih anak merapikan peralatan makan sendok dan garpu sesuai urutan ukurannya.',
              'Gunakan benda alam seperti daun untuk diurutkan berdasarkan gradasi ukuran.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Tertarik pada Gerakan Kreatif Mengikuti Musik',
            target: 'Target: Anak menunjukkan minat mengekspresikan diri melalui gerakan tari kreasi mengikuti irama musik.',
            parentTips: [
              'Putar musik anak yang ceria dan menarilah bersama-sama di ruang tengah.',
              'Dukung anak menciptakan gerakan tari imajinatifnya sendiri dan berikan apresiasi.',
              'Gunakan selendang atau pita warna-warni sebagai properti menari agar lebih menarik.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Keterbukaan Belajar Hal Baru',
            target: 'Target: Anak menunjukkan minat antusias dan berani mencoba hal atau aktivitas pembelajaran baru.',
            parentTips: [
              'Fasilitasi rasa ingin tahu anak dengan menyediakan beragam buku cerita edukatif atau mainan sains sederhana.',
              'Dampingi ia saat mencoba aktivitas atau lingkungan belajar yang baru untuk memberikan rasa aman.',
              'Berikan dukungan positif atas setiap usaha belajarnya tanpa menuntut kesempurnaan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Belajar Melalui Aktivitas Bermain',
            target: 'Target: Anak mampu menyerap informasi dan memecahkan tantangan kognitif secara efektif melalui permainan edukatif.',
            parentTips: [
              'Gunakan media bermain peran (seperti pasar-pasaran) untuk mengajarkan konsep berhitung dasar.',
              'Ajak anak bermain teka-teki logika atau tebak kata bersama keluarga.',
              'Pilihlah mainan konstruktif yang merangsang anak berpikir taktis.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Membedakan Kenyataan dan Khayalan',
            target: 'Target: Anak mampu membedakan hal yang nyata terjadi dengan hal yang hanya ada dalam imajinasi atau cerita fantasi.',
            parentTips: [
              'Diskusikan perbedaan tokoh fiksi di televisi/buku dengan dunia nyata (',
              ').',
              'Dorong anak tetap berimajinasi sehat sambil mengingatkan batasan dunia nyata.',
              'Jawab rasa penasaran anak mengenai keaslian suatu fenomena dengan logis.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Tertarik pada Lingkungan Sekitar dan Dunia Luar',
            target: 'Target: Anak menunjukkan rasa peduli dan ketertarikan tinggi untuk mengeksplorasi fenomena alam di sekitarnya.',
            parentTips: [
              'Ajak anak berkebun di halaman rumah dan biarkan ia menyiram tanaman atau mengamati cacing tanah.',
              'Sediakan kaca pembesar anak-anak untuk mengamati detail daun atau serangga secara aman.',
              'Jelaskan fenomena alam sederhana seperti terjadinya hujan atau pelangi.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mulai Mengorganisasi Informasi untuk Mengingat',
            target: 'Target: Anak mulai menggunakan strategi sederhana (seperti pengelompokan) untuk membantunya mengingat informasi.',
            parentTips: [
              'Latih anak mengingat barang belanjaan dengan mengelompokkannya (',
              ').',
              'Ajak bermain tebak-tebakan posisi benda untuk menguji daya ingat jangka pendeknya.',
              'Gunakan lagu atau singkatan menyenangkan untuk menghafal hal sederhana.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '6_years',
    name: '6 Tahun',
    minAgeMonths: 72,
    maxAgeMonths: 84,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berpartisipasi Aktif dalam Aktivitas Fisik yang Kuat',
            target: 'Target: Anak bersemangat dan kuat melakukan berbagai aktivitas fisik dinamis (seperti berlari kencang atau memanjat) secara teratur.',
            parentTips: [
              'Fasilitasi permainan luar ruangan yang aktif seperti bermain sepak bola atau berenang.',
              'Beri kesempatan anak bermain di wahana panjat tebing anak-anak dengan pengawasan.',
              'Dukung anak mengikuti kelas olahraga terstruktur jika ia berminat.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mengendarai Sepeda Tanpa Roda Bantu',
            target: 'Target: Anak mampu mengendarai sepeda roda dua dengan seimbang dan lancar tanpa bantuan roda kecil tambahan.',
            parentTips: [
              'Temani anak berlatih mengayuh sepeda di area datar yang bebas lalu lintas.',
              'Ajarkan cara mengerem sepeda secara aman sebelum berbelok.',
              'Puji keberhasilan anak menjaga keseimbangannya saat bersepeda.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mengikat Tali Sepatu Sendiri',
            target: 'Target: Anak mampu membuat simpul dan mengikat tali sepatunya secara mandiri dengan rapi.',
            parentTips: [
              'Latih membuat simpul tali sepatu secara rutin sebelum pergi ke luar rumah.',
              'Gunakan tali sepatu yang berbahan katun lembut agar ikatannya tidak mudah lepas.',
              'Berikan dorongan semangat jika anak masih merasa kesulitan melakukan putaran tali.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Melakukan Aktivitas Motorik Halus yang Rumit',
            target: 'Target: Anak terampil melakukan aktivitas tangan terkoordinasi seperti melipat kertas origami atau membuat prakarya.',
            parentTips: [
              'Ajarkan seni melipat kertas (origami) bentuk hewan sederhana bersama anak.',
              'Sediakan gunting khusus anak-anak untuk memotong pola gambar yang meliuk.',
              'Ajak merakit mainan balok kecil atau lego sesuai dengan buku petunjuknya.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menulis Angka dan Huruf dengan Semakin Akurat',
            target: 'Target: Anak mampu menuliskan barisan angka dan huruf secara rapi, proporsional, dan mudah dibaca.',
            parentTips: [
              'Sediakan buku tulis bergaris untuk membantunya melatih ukuran huruf yang proporsional.',
              'Ingatkan posisi memegang pensil yang benar dan posisi duduk yang tegak saat menulis.',
              'Berikan koreksi lembut jika anak menulis huruf secara terbalik (seperti huruf b dan d).',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menulis Nama Sendiri',
            target: 'Target: Anak mampu mengeja dan menuliskan nama lengkapnya sendiri dengan urutan huruf yang benar.',
            parentTips: [
              'Ajak anak menuliskan namanya di setiap lembar karya gambar buatannya.',
              'Latih menulis nama lengkapnya pada barang-barang miliknya seperti label buku.',
              'Puji ketelitian anak dalam menyusun huruf-huruf namanya.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mudah Berteman dengan Orang Lain',
            target: 'Target: Anak mampu memulai interaksi, menyapa, dan menjalin pertemanan baru dengan teman sebaya secara percaya diri.',
            parentTips: [
              'Berikan kesempatan anak bersosialisasi di taman bermain atau lingkungan baru.',
              'Contohkan cara menyapa teman baru secara sopan (',
              ').',
              'Bimbing anak memahami pentingnya mendengarkan teman saat berbicara.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mematuhi Aturan Sebagian Besar Waktu',
            target: 'Target: Anak memahami pentingnya aturan sosial dan mematuhinya secara konsisten dalam situasi umum.',
            parentTips: [
              'Berikan aturan rumah yang jelas dan diskusikan manfaat mematuhinya bersama anak.',
              'Konsisten dalam memberikan konsekuensi yang mendidik jika anak melanggar aturan.',
              'Berikan apresiasi saat anak mengikuti aturan tanpa harus diingatkan.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Bermain Terutama dengan Teman Bergender Sama',
            target: 'Target: Anak menunjukkan kecenderungan memilih teman bermain dengan gender yang sama secara alami.',
            parentTips: [
              'Hargai preferensi pertemanan anak sambil tetap mendorong sikap inklusif terhadap semua teman.',
              'Sediakan permainan kelompok yang bisa dimainkan bersama anak laki-laki dan perempuan.',
              'Ajarkan pentingnya saling menghargasi perbedaan.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mengembangkan Kemampuan Melihat Sudut Pandang Orang Lain',
            target: 'Target: Anak mulai memahami bahwa orang lain memiliki perasaan dan pikiran yang berbeda dari dirinya.',
            parentTips: [
              'Ajak anak mendiskusikan perasaan temannya saat terjadi perselisihan (',
              ').',
              'Bacakan buku cerita dan tanyakan mengapa tokoh dalam cerita tersebut bertindak demikian.',
              'Latih empati anak dengan mencontohkan sikap peduli sehari-hari.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mulai Mengorganisasi Informasi untuk Mengingat',
            target: 'Target: Anak mulai menggunakan strategi sederhana (seperti pengelompokan) untuk membantunya mengingat informasi.',
            parentTips: [
              'Latih anak mengingat barang belanjaan dengan mengelompokkannya (',
              ').',
              'Ajak bermain tebak-tebakan posisi benda untuk menguji daya ingat jangka pendeknya.',
              'Gunakan lagu atau singkatan menyenangkan untuk menghafal hal sederhana.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menunjukkan Variasi Suasana Hati yang Beragam',
            target: 'Target: Anak mampu mengekspresikan berbagai emosi (seperti bahagia, frustrasi, atau antusias) dengan lebih jelas.',
            parentTips: [
              'Validasi perasaan anak ketika ia sedang mengalami suasana hati yang kurang baik.',
              'Ajarkan cara menyalurkan emosi negatif dengan cara yang aman (seperti menulis atau menggambar).',
              'Berikan waktu bagi anak untuk menenangkan diri sebelum mengajaknya berdiskusi.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Berpakaian Sendiri Secara Lengkap',
            target: 'Target: Anak mampu memilih, memakai, mengancingkan, dan merapikan seluruh pakaiannya sendiri tanpa bantuan.',
            parentTips: [
              'Sediakan pakaian yang mudah dipakai anak untuk melatih kemandiriannya.',
              'Biarkan anak berlatih memakai seragam sekolahnya sendiri di pagi hari.',
              'Berikan pujian atas usahanya merapikan penampilannya sendiri.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Merawat Barang-barang Milik Sendiri',
            target: 'Target: Anak menunjukkan rasa tanggung jawab untuk merapikan dan menjaga barang pribadi atau perlengkapan sekolahnya.',
            parentTips: [
              'Sediakan tempat penyimpanan khusus yang mudah dijangkau anak untuk menaruh barangnya.',
              'Biasakan anak merapikan tas dan alat tulisnya sendiri setelah belajar.',
              'Ingatkan anak dengan lembut jika ia lupa meletakkan kembali barangnya di tempat semula.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menggunakan Tata Bahasa yang Tepat dan Benar',
            target: 'Target: Anak mampu berkomunikasi menggunakan struktur kalimat yang lengkap, logis, dan tata bahasa yang baik.',
            parentTips: [
              'Berikan contoh berbicara dengan struktur kalimat yang lengkap dan runtut.',
              'Perbaiki kekeliruan tata bahasa anak secara lembut dengan mengulangi kalimatnya secara benar.',
              'Bacakan buku cerita yang memiliki struktur tata bahasa yang kaya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Sering Mengajukan Pertanyaan Kritis',
            target: 'Target: Anak aktif bertanya mengenai cara kerja suatu benda, sebab-akibat, dan konsep di sekitarnya.',
            parentTips: [
              'Tanggapi pertanyaan kritis anak dengan jawaban yang logis dan mudah dipahami.',
              'Ajak anak mencari tahu jawaban bersama melalui buku ensiklopedia anak.',
              'Gunakan pertanyaan anak sebagai pemantik diskusi yang lebih mendalam.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Bercerita atau Menceritakan Kisah secara Runtut',
            target: 'Target: Anak mampu menceritakan kembali dongeng atau kejadian nyata secara terperinci dengan urutan kronologis yang jelas.',
            parentTips: [
              'Minta anak menceritakan pengalaman serunya di sekolah atau tempat bermain hari ini.',
              'Berikan pertanyaan pemandu untuk membantunya melengkapi detail ceritanya.',
              'Berikan apresiasi atas usahanya bercerita dengan ekspresif.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Terlibat dalam Percakapan Orang Dewasa',
            target: 'Target: Anak mampu berpartisipasi aktif dalam obrolan keluarga dan menanggapi pembicaraan secara relevan.',
            parentTips: [
              'Libatkan anak dalam obrolan santai keluarga di meja makan.',
              'Hargai pendapat anak ketika ia memberikan masukan dalam percakapan.',
              'Gunakan kata-kata yang sopan agar anak meniru cara berkomunikasi yang baik.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menggunakan Bahasa untuk Menyelesaikan Masalah',
            target: 'Target: Anak mampu menggunakan kalimat verbal untuk menyelesaikan ketidaksepakatan atau mengekspresikan keberatan.',
            parentTips: [
              'Dorong anak untuk mengungkapkan perasaannya secara lisan alih-alih merengek atau marah.',
              'Ajarkan anak cara bernegosiasi sederhana saat berebut mainan (',
              ').',
              'Bantu memediasi penyelesaian masalah dengan berdiskusi tenang.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Memiliki Rentang Perhatian 20-30 Menit',
            target: 'Target: Anak mampu fokus dan konsentrasi menyelesaikan suatu tugas (seperti membaca atau merakit mainan) selama 20 hingga 30 menit.',
            parentTips: [
              'Batasi gangguan layar digital sebelum anak mulai mengerjakan aktivitas belajar.',
              'Ajak anak menyelesaikan tugas meja yang tenang seperti merakit puzzle atau mewarnai secara mandiri.',
              'Berikan jeda istirahat singkat jika anak mulai menunjukkan tanda-tanda jenuh.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Bermain Permainan dengan Aturan yang Jelas',
            target: 'Target: Anak mampu bermain permainan papan atau olahraga bersama teman dengan mengikuti seluruh aturan main secara tertib.',
            parentTips: [
              'Ajak bermain permainan papan keluarga seperti ludo atau ular tangga untuk melatih kepatuhan aturan.',
              'Latih sikap sportif anak saat menerima kemenangan atau kekalahan dalam permainan.',
              'Jelaskan manfaat aturan bermain demi kenyamanan bersama seluruh pemain.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Membedakan Kiri dan Kanan',
            target: 'Target: Anak mampu menentukan arah kiri dan kanan pada bagian tubuhnya maupun lingkungan sekitarnya.',
            parentTips: [
              'Ajarkan lagu anak-anak yang membedakan gerakan tangan kanan dan tangan kiri secara ceria.',
              'Beri penanda sederhana seperti gelang benang di pergelangan tangan kanan untuk membantunya mengingat.',
              'Latih arah saat berjalan-jalan santai (',
              ').',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Memiliki Kesadaran Waktu',
            target: 'Target: Anak memahami konsep jam, menit, serta pembagian waktu pagi, siang, sore, dan malam.',
            parentTips: [
              'Gunakan jam dinding bergambar kartun di kamar anak untuk melatih konsep jarum jam.',
              'Diskusikan jadwal aktivitas harian dengan mengaitkannya pada angka jam (',
              ').',
              'Kenalkan konsep menit secara sederhana dengan timer alarm.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mengetahui Konsep Musim dan Cuaca',
            target: 'Target: Anak memahami pergantian musim (kemarau dan hujan) serta penyesuaian pakaian atau aktivitas yang tepat.',
            parentTips: [
              'Amati perubahan cuaca di luar rumah bersama anak dan diskusikan ciri-cirinya.',
              'Jelaskan mengapa kita memakai payung saat hujan dan memakai pakaian tipis saat cuaca panas.',
              'Kenalkan fenomena alam sederhana yang berhubungan dengan musim.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menghitung Lebih dari 50 Benda',
            target: 'Target: Anak mampu menyebutkan urutan bilangan secara verbal secara akurat hingga angka 50 atau lebih.',
            parentTips: [
              'Ajak anak menghitung jumlah ubin lantai atau pagar rumah saat berjalan-jalan di sekitar kompleks.',
              'Gunakan mainan manik-manik atau balok susun dalam jumlah banyak untuk dihitung bersama.',
              'Latih kelancaran menghitung dengan permainan estafet angka.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Menghitung Lompat Dua, Lima, dan Sepuluh',
            target: 'Target: Anak mampu melakukan pembilangan lompat (2, 4, 6... atau 5, 10, 15...) secara runtut.',
            parentTips: [
              'Gunakan benda konkret (seperti kelereng) dan kelompokkan dua-dua untuk dihitung lompat bersama.',
              'Gunakan tabel angka berwarna untuk membantu anak memvisualisasikan pola angka lompat.',
              'Ajak bernyanyi lagu matematika tentang deret angka lompat.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mengeja dan Membaca Kata Baru',
            target: 'Target: Anak mampu membaca kata baru yang belum dikenal dengan mengeja bunyi hurufnya (fonik).',
            parentTips: [
              'Latih membaca buku cerita bergambar dengan menunjuk suku kata secara bertahap.',
              'Gunakan kartu suku kata bergambar untuk melatih penggabungan bunyi huruf.',
              'Puji kegigihan anak mengeja kata-kata baru yang panjang.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Membaca Kata Familiar dengan Sekilas',
            target: 'Target: Anak mampu langsung membaca kata-kata pendek yang sering ditemuinya tanpa perlu mengeja kembali.',
            parentTips: [
              'Tuliskan kata-kata harian yang sering ditemui pada kartu pengingat (flashcards) di kamar.',
              'Ajak anak membaca papan petunjuk jalan atau kemasan makanan yang sudah dikenalnya.',
              'Bermain mencocokkan kata dengan gambar ilustrasi secara cepat.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Menulis Cerita Sederhana',
            target: 'Target: Anak mampu merangkai beberapa kalimat pendek menjadi sebuah cerita sederhana yang bermakna.',
            parentTips: [
              'Minta anak menuliskan cerita pendek mengenai gambar yang baru saja dibuatnya.',
              'Sediakan buku catatan khusus bermotif menarik untuk jurnal harian sederhana anak.',
              'Bantu anak menyusun ejaan kata yang masih sulit ia tulis sendiri.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Mengenali Berbagai Nominal Uang',
            target: 'Target: Anak mampu mengidentifikasi nilai mata uang koin dan kertas rupiah yang umum digunakan sehari-hari.',
            parentTips: [
              'Bermain peran sebagai pedagang dan pembeli menggunakan uang mainan atau uang asli nominal kecil.',
              'Biarkan anak membantu membayar belanjaan kecil di kasir toko swalayan terdekat.',
              'Ajarkan perbedaan gambar dan warna pecahan uang kertas rupiah.',
            ],
          ),
          RedleafItem(
            number: 12,
            title: 'Memahami Pecahan Sederhana',
            target: 'Target: Anak mampu memahami konsep pembagian objek utuh menjadi setengah atau seperempat bagian.',
            parentTips: [
              'Potong roti tawar atau pizza menjadi 2 atau 4 bagian sama besar untuk mengenalkan konsep visual setengah/seperempat.',
              'Gunakan kertas lipat berwarna untuk dilipat dan digunting menjadi pecahan sederhana.',
              'Bahas konsep berbagi makanan secara adil menggunakan istilah pecahan.',
            ],
          ),
          RedleafItem(
            number: 13,
            title: 'Memahami Penjumlahan dan Pengurangan Sederhana',
            target: 'Target: Anak mampu menjumlahkan dan mengurangkan angka di bawah 20 menggunakan bantuan benda konkret.',
            parentTips: [
              'Gunakan stik es krim atau sempoa warna-warni untuk melatih operasi hitung dasar.',
              'Buat soal cerita matematika yang berhubungan dengan mainan anak (',
              ').',
              'Latih kelancaran berhitung secara visual dan bertahap.',
            ],
          ),
          RedleafItem(
            number: 14,
            title: 'Membuat dan Melanjutkan Pola yang Lebih Rumit',
            target: 'Target: Anak mampu menyusun pola berulang yang kompleks (seperti pola 3 warna atau 3 bentuk geometri).',
            parentTips: [
              'Sediakan manik-manik beragam bentuk untuk dirangkai menjadi gelang berpola teratur.',
              'Bermain menyusun balok kayu membentuk pola berulang yang rumit bersama anak.',
              'Ajak anak menemukan pola bermotif berulang pada kain batik atau dekorasi rumah.',
            ],
          ),
          RedleafItem(
            number: 15,
            title: 'Mengidentifikasi dan Menggambar Bentuk 2D dan 3D Sederhana',
            target: 'Target: Anak mampu mengenali dan menggambar bentuk dua dimensi (persegi, segitiga) serta tiga dimensi (kubus, tabung, bola) sederhana.',
            parentTips: [
              'Ajak anak mencari benda di rumah yang berbentuk tabung (kaleng susu) atau kubus (kotak tisu).',
              'Bantu anak menjiplak permukaan benda 3D untuk melihat bentuk 2D pembentuknya.',
              'Contohkan cara menggambar kubus sederhana di kertas gambar.',
            ],
          ),
          RedleafItem(
            number: 16,
            title: 'Mengetahui Nama-nama Hari dalam Seminggu',
            target: 'Target: Anak mampu menyebutkan nama-nama hari secara urut dan tepat dari Senin hingga Minggu.',
            parentTips: [
              'Nyanyikan lagu nama-nama hari secara ceria bersama anak setiap pagi.',
              'Gunakan kalender dinding bergambar di kamarnya untuk menandai hari bersekolah dan hari libur.',
              'Tanyakan konsep hari esok, hari ini, dan kemarin kepada anak secara santai.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mencari Informasi Lebih Lanjut tentang Topik yang Diminati',
            target: 'Target: Anak berinisiatif mencari informasi (bertanya atau membaca buku) mengenai topik spesifik yang menarik perhatiannya.',
            parentTips: [
              'Temani anak meminjam buku bertema kegemarannya di perpustakaan atau toko buku.',
              'Ajak berdiskusi interaktif untuk memperdalam pengetahuannya mengenai topik yang ia sukai.',
              'Fasilitasi dengan tontonan dokumenter edukatif yang relevan secara terbatas.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mencari dan Menemukan Media Belajar Baru di Lingkungan Sekitar',
            target: 'Target: Anak aktif mencari bahan baru di sekelilingnya untuk dieksplorasi dan dipelajari fungsinya.',
            parentTips: [
              'Sediakan media belajar yang bervariasi (seperti cat air, tanah liat, atau daun kering) di rumah.',
              'Biarkan anak bebas bereksperimen menemukan cara bermain baru menggunakan media tersebut.',
              'Dampingi anak mengeksplorasi alam terbuka seperti mengoleksi jenis batu-batuan unik.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Mampu Belajar dalam Situasi Terstruktur maupun Tidak Terstruktur',
            target: 'Target: Anak mampu menyerap pembelajaran dengan baik saat mengikuti instruksi formal maupun saat bermain bebas.',
            parentTips: [
              'Latih anak mengikuti aturan tugas sekolah secara bertahap dan teratur.',
              'Bebaskan anak bereksplorasi membuat permainan buatannya sendiri di luar jam belajar terstruktur.',
              'Puji adaptasi anak di lingkungan baru yang memiliki aturan berbeda.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Memahami Hubungan Antara Perilaku dan Konsekuensi',
            target: 'Target: Anak menyadari bahwa setiap tindakan yang diambilnya memiliki dampak sebab-akibat yang harus dihadapi.',
            parentTips: [
              'Diskusikan dampak perbuatan sehari-hari secara logis (',
              ').',
              'Ajarkan tanggung jawab dengan membimbing anak merapikan tumpahan air yang dibuatnya secara tidak sengaja.',
              'Berikan konsekuensi logis yang mendidik alih-alih memberikan hukuman fisik.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '7_years',
    name: '7 Tahun',
    minAgeMonths: 84,
    maxAgeMonths: 96,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Mengendarai Sepeda dengan Sangat Lancar',
            target: 'Target: Anak mampu mengayuh, mengemudikan, dan mengerem sepeda roda dua dengan terampil dan percaya diri.',
            parentTips: [
              'Biarkan anak bersepeda secara mandiri di area aman seperti lapangan atau jalur sepeda khusus.',
              'Ajarkan cara berkendara yang aman termasuk mematuhi rambu atau pejalan kaki.',
              'Pakaikan pelindung kepala (helm) yang pas dan nyaman.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Terlibat dalam Olahraga, Tari, atau Permainan Aktif',
            target: 'Target: Anak aktif berpartisipasi dalam olahraga berkelompok, menari, atau permainan luar ruangan yang aktif.',
            parentTips: [
              'Dukung minat anak dengan mendaftarkannya ke klub olahraga (futsal, renang) atau kursus tari.',
              'Bermain lempar tangkap bola atau bulu tangkis bersama anak di akhir pekan.',
              'Jelaskan manfaat gaya hidup aktif bagi kesehatan tubuhnya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menaiki dan Menuruni Tangga dengan Lancar',
            target: 'Target: Anak mampu naik dan turun tangga dengan langkah kaki bergantian dan seimbang secara mandiri.',
            parentTips: [
              'Ingatkan anak agar tidak berlari terlalu kencang atau melompat-lompat saat berada di tangga.',
              'Pastikan area tangga rumah memiliki penerangan yang cukup dan pegangan tangga yang kokoh.',
              'Ajarkan untuk selalu waspada melihat pijakan kaki.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menulis dengan Lancar dan Rapi',
            target: 'Target: Anak mampu menulis kata dan kalimat panjang di atas kertas dengan kecepatan normal dan bentuk huruf yang rapi.',
            parentTips: [
              'Sediakan alat tulis dengan grip karet yang nyaman dipegang oleh anak.',
              'Ajak anak membuat kartu ucapan tulisan tangan untuk kerabat yang berulang tahun.',
              'Hindari memaksakan durasi menulis yang terlalu lama untuk mencegah otot tangan kelelahan.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menyukai Permainan Berkelompok yang Teratur',
            target: 'Target: Anak senang bergabung dalam aktivitas bermain kelompok yang terstruktur (seperti klub olahraga atau ekstrakurikuler).',
            parentTips: [
              'Daftarkan anak ke kegiatan ekstrakurikuler sekolah sesuai minatnya (seperti pramuka atau seni tari).',
              'Fasilitasi waktu bermain bersama kelompok sebaya secara berkala.',
              'Puji kemampuannya mengikuti instruksi pemimpin kelompok.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menikmati Waktu Bermain Sendiri',
            target: 'Target: Anak mampu asyik bermain sendiri (seperti membaca atau menggambar) sebagai bentuk waktu tenang.',
            parentTips: [
              'Sediakan ruang tenang dan material kreatif (buku gambar, lego, puzzle) di kamarnya.',
              'Hargai kebutuhannya saat ia sedang ingin menghabiskan waktu sendirian.',
              'Seimbangkan aktivitas mandiri dengan interaksi sosial bersama teman.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Belajar Menyelesaikan Perbedaan Pendapat dengan Teman',
            target: 'Target: Anak belajar mengelola perselisihan pendapat atau konflik kecil dengan teman sebaya secara wajar.',
            parentTips: [
              'Ajarkan anak mengekspresikan kekecewaannya dengan kata-kata sopan alih-alih berteriak.',
              'Bimbing anak mencari solusi kompromi bersama temannya saat berselisih.',
              'Tunjukkan cara meminta maaf dan memaafkan kesalahan teman.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Mampu Bekerja Sama dengan Teman Sebaya',
            target: 'Target: Anak mampu berkolaborasi, berbagi tugas, dan berkoordinasi dalam menyelesaikan kegiatan kelompok.',
            parentTips: [
              'Berikan tugas kolaboratif bersama saudara di rumah (seperti merapikan tanaman bersama).',
              'Latih anak mendengarkan ide temannya tanpa langsung menyela atau mendominasi.',
              'Puji kontribusi positif anak dalam kerja kelompoknya.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Bermain Sesuai Aturan yang Berlaku',
            target: 'Target: Anak memahami, menyetujui, dan menaati seluruh aturan dalam permainan secara konsisten dan sportif.',
            parentTips: [
              'Biasakan berdiskusi menegaskan aturan main sebelum permainan papan dimulai.',
              'Tanamkan sikap sportif dan jujur saat bermain bersama keluarga.',
              'Ajarkan bahwa kekalahan adalah bagian normal dan kesempatan belajar dalam setiap permainan.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menyukai Aktivitas Mendongeng atau Bercerita',
            target: 'Target: Anak senang mendengarkan dongeng dan mampu menceritakan kisah imajinatif dengan penuh ekspresi.',
            parentTips: [
              'Luangkan waktu secara teratur membacakan buku dongeng atau cerita rakyat kepada anak.',
              'Ajak anak bergantian melanjutkan paragraf cerita yang sedang dibaca bersama.',
              'Dukung ia mengekspresikan karakter cerita menggunakan intonasi suara berbeda.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menyukai Kegiatan Menulis Cerita',
            target: 'Target: Anak senang menulis cerita pendek atau jurnal pribadi menggunakan kosakata yang bervariasi.',
            parentTips: [
              'Sediakan buku harian khusus dengan motif menarik untuk memotivasinya menulis cerita.',
              'Berikan masukan positif terhadap alur cerita buatan anak tanpa terlalu fokus pada kesalahan tanda baca.',
              'Ajak anak memamerkan cerita buatannya kepada keluarga terdekat.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Belajar Mengeja Kata dengan Benar',
            target: 'Target: Anak mampu mengeja dan menuliskan kata-kata yang rumit secara tepat sesuai ejaan baku.',
            parentTips: [
              'Bermain tebak ejaan kata (spelling bee) sederhana dengan kosakata yang baru dipelajarinya.',
              'Gunakan kamus anak bergambar untuk memverifikasi ejaan kata yang membingungkan.',
              'Berikan apresiasi atas usahanya memperbaiki ejaan yang salah.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menggunakan Gaya Bicara yang Matang',
            target: 'Target: Anak mampu menyusun kalimat yang kompleks dan mengobrol dengan cara yang runtut mirip orang dewasa.',
            parentTips: [
              'Ajak anak mendiskusikan rencana akhir pekan keluarga secara setara.',
              'Dengarkan pendapat anak dengan serius tanpa meremehkan idenya.',
              'Gunakan perbendaharaan kata baru dalam percakapan sehari-hari untuk memperluas bahasanya.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Membaca dengan Pemahaman yang Baik',
            target: 'Target: Anak mampu membaca cerita pendek sendiri dan menjelaskan inti dari cerita yang dibacanya.',
            parentTips: [
              'Setelah anak membaca suatu cerita, tanyakan pendapatnya tentang isi cerita tersebut.',
              'Ajak anak mendiskusikan pesan moral atau pelajaran yang didapat dari buku.',
              'Bantu anak memahami arti kosakata baru yang ia temui saat membaca.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Membaca untuk Kesenangan',
            target: 'Target: Anak berinisiatif memilih dan membaca buku secara mandiri atas kemauan sendiri sebagai hiburan.',
            parentTips: [
              'Sediakan sudut baca yang nyaman di rumah lengkap dengan rak buku setinggi jangkauan anak.',
              'Biarkan anak memilih sendiri buku bacaan yang ia minati saat berkunjung ke toko buku.',
              'Jadwalkan momen membaca hening bersama seluruh anggota keluarga.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menceritakan Lelucon dan Teka-teki',
            target: 'Target: Anak memahami struktur humor sederhana serta senang melontarkan lelucon kepada orang lain.',
            parentTips: [
              'Tanggapi lelucon atau tebak-tebakan anak dengan tawa hangat dan antusias.',
              'Ajarkan teka-teki logika sederhana untuk merangsang kreativitas berpikir anak.',
              'Ajak anak bermain tebak-tebakan kata yang menghibur saat di perjalanan.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menunjukkan Ketertarikan pada Teknologi',
            target: 'Target: Anak tertarik mengeksplorasi gawai atau program edukatif komputer secara aman.',
            parentTips: [
              'Dampingi anak saat menggunakan komputer untuk mencoba aplikasi coding dasar ramah anak (seperti Scratch).',
              'Ajak anak mengeksplorasi situs web edukatif tentang sains atau matematika.',
              'Terapkan aturan waktu layar (screen time) yang seimbang dan konsisten.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menunjukkan Minat pada Peta dan Globe',
            target: 'Target: Anak tertarik mengamati peta daerah atau globe serta menanyakan letak geografis.',
            parentTips: [
              'Pajang peta dunia berwarna menarik di dinding kamar tidur anak.',
              'Gunakan globe untuk menjelaskan konsep perbedaan benua dan pulau-pulau besar.',
              'Ajak mencari lokasi negara yang sedang dibahas dalam berita atau buku cerita.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menunjukkan Minat pada Grafik Sederhana',
            target: 'Target: Anak tertarik membaca dan memahami informasi dalam bentuk diagram sederhana.',
            parentTips: [
              'Buat grafik visual sederhana mengenai cuaca harian (cerah, mendung, hujan) bersama anak.',
              'Gunakan susunan balok mainan untuk menggambarkan perbandingan jumlah barang.',
              'Latih membaca bagan tabel jadwal pelajaran sekolahnya.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mengetahui Nama-nama Bulan dalam Setahun',
            target: 'Target: Anak mampu menyebutkan nama-nama bulan dari Januari hingga Desember secara urut dan tepat.',
            parentTips: [
              'Latih anak melingkari tanggal ulang tahun anggota keluarga pada kalender dinding.',
              'Nyanyikan lagu edukatif nama-nama bulan bersama anak secara ceria.',
              'Ajarkan konsep pergantian bulan dan waktu liburan sekolah.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Menunjukkan Minat pada Peristiwa Terkini',
            target: 'Target: Anak tertarik mendengarkan atau menanyakan tentang berita positif yang sedang terjadi di sekitarnya.',
            parentTips: [
              'Diskusikan berita ramah anak (seperti misi luar angkasa atau perlindungan hewan langka).',
              'Tanyakan tanggapan anak mengenai kejadian positif yang ia dengar di sekolah.',
              'Gunakan koran anak atau majalah anak-anak sebagai bahan obrolan.',
            ],
          ),
          RedleafItem(
            number: 9,
            title: 'Menunjukkan Minat pada Sejarah dan Tokoh Terkenal',
            target: 'Target: Anak tertarik mendengarkan kisah sejarah, pahlawan, atau tokoh penemu terkenal.',
            parentTips: [
              'Bacakan buku biografi bergambar tentang tokoh penemu dunia yang menginspirasi.',
              'Ajak anak mengunjungi museum lokal terdekat untuk melihat benda-benda bersejarah.',
              'Ceritakan dongeng kepahlawanan dengan intonasi yang menggugah rasa penasaran.',
            ],
          ),
          RedleafItem(
            number: 10,
            title: 'Mengukur Dimensi Benda',
            target: 'Target: Anak mampu mengukur panjang, tinggi, atau berat benda menggunakan alat ukur standar.',
            parentTips: [
              'Ajak anak mengukur panjang meja makan atau lemari mainan menggunakan meteran gulung.',
              'Libatkan anak menimbang berat tepung atau gula saat membuat kue bersama di dapur.',
              'Latih membaca angka-angka skala pada penggaris miliknya.',
            ],
          ),
          RedleafItem(
            number: 11,
            title: 'Sadar dan Peduli Terhadap Waktu',
            target: 'Target: Anak mampu memperkirakan waktu yang dibutuhkan untuk menyelesaikan suatu tugas secara mandiri.',
            parentTips: [
              'Latih anak bersiap-siap mandiri sebelum berangkat sekolah agar tidak terlambat.',
              'Gunakan jam weker untuk membantu anak mengelola waktu mandi atau merapikan mainan.',
              'Bahas tentang konsep disiplin dan menghargai waktu orang lain.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Bermain dengan Detail dan Fokus',
            target: 'Target: Anak mampu terlibat dalam aktivitas bermain yang kompleks, mendetail, dan membutuhkan fokus perhatian yang lama.',
            parentTips: [
              'Dukung anak merancang proyek konstruktif seperti membangun maket kota dari kardus bekas.',
              'Biarkan anak menyelesaikan mainan rakitan lego kepingan kecil tanpa terburu-buru.',
              'Sediakan area bermain khusus agar proyek buatan anak tidak perlu dibongkar saat ia beristirahat.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Memilih, Merencanakan, Meneliti, dan Mengembangkan Ide',
            target: 'Target: Anak mampu menentukan proyek aktivitas, merancang langkah-langkahnya, dan mengumpulkan informasi secara kreatif.',
            parentTips: [
              'Tantang anak membuat prakarya eksperimen sains sederhana di rumah.',
              'Bimbing anak merencanakan tahapan pengerjaan proyeknya langkah demi langkah.',
              'Bantu anak mencari referensi buku atau video edukasi yang mendukung idenya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menggunakan Bahasa untuk Memperjelas Cara Berpikir dan Belajar',
            target: 'Target: Anak mampu menjelaskan konsep pemahaman baru yang ia pelajari secara verbal dengan terstruktur.',
            parentTips: [
              'Minta anak menceritakan pelajaran sekolah yang disukainya hari ini seolah ia menjadi gurunya.',
              'Ajak mendiskusikan kaitan materi belajar dengan kehidupan nyata.',
              'Berikan pertanyaan pemantik untuk memperdalam pemahaman konsep anak.',
            ],
          ),
        ],
      ),
    ],
  ),
  const RedleafAgeGroup(
    id: '8_years',
    name: '8 Tahun',
    minAgeMonths: 96,
    maxAgeMonths: 120,
    domains: [
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Koordinasi Tubuh yang Baik',
            target: 'Target: Anak mampu mengoordinasikan gerakan tangan, kaki, dan tubuh dengan sangat baik saat beraktivitas.',
            parentTips: [
              'Latih kelenturan dan koordinasi tubuh anak melalui senam lantai sederhana atau yoga anak.',
              'Bermain lempar tangkap bola dengan jarak yang bervariasi.',
              'Ajak anak bermain lompat tali bersama teman-temannya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Memiliki Rentang Perhatian yang Lebih Panjang',
            target: 'Target: Anak mampu fokus melakukan tugas terstruktur secara mandiri selama 30 menit atau lebih.',
            parentTips: [
              'Sediakan ruang belajar yang tenang bebas dari suara bising atau gawai.',
              'Dukung anak menyelesaikan bacaan buku cerita fiksi anak yang tebal.',
              'Berikan apresiasi atas ketekunan anak menyelesaikan pekerjaan sekolahnya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menunjukkan Koordinasi Mata dan Tangan yang Baik',
            target: 'Target: Anak terampil mengoordinasikan indra penglihatan dengan gerakan tangannya saat melakukan aktivitas presisi.',
            parentTips: [
              'Bermain menembak bola ke ring basket kecil di halaman rumah.',
              'Ajak anak melatih ketepatan lemparan dengan permainan dart magnet aman.',
              'Latih koordinasi lewat menggambar pola atau melukis detail kecil.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menyukai Aktivitas dengan Energi Tinggi',
            target: 'Target: Anak memiliki stamina yang baik untuk melakukan permainan luar ruangan yang aktif.',
            parentTips: [
              'Jadwalkan aktivitas berenang bersama keluarga di akhir pekan.',
              'Ajak anak bersepeda keliling kompleks perumahan secara aman.',
              'Biarkan anak bebas berlari dan bermain kejar-kejaran di taman kota.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Membangun dan Membongkar Benda',
            target: 'Target: Anak gemar merakit objek kompleks dan membongkarnya kembali untuk mempelajari mekanismenya.',
            parentTips: [
              'Sediakan mainan perakitan mekanik seperti lego teknik atau rakitan robot sederhana.',
              'Beri kesempatan anak membongkar barang elektronik rusak yang aman dengan pengawasan.',
              'Dukung eksperimen konstruktif anak membuat model bangunan unik.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          RedleafItem(
            number: 1,
            title: 'Lebih Menyukai Permainan Berkelompok daripada Bermain Sendiri',
            target: 'Target: Anak menunjukkan preferensi yang kuat untuk bermain dalam kelompok teman sebaya dibandingkan bermain sendirian.',
            parentTips: [
              'Fasilitasi pertemuan bermain (playdate) bersama teman-teman sekolah atau tetangga secara berkala.',
              'Dukung partisipasi anak dalam klub olahraga atau komunitas anak lainnya.',
              'Ajarkan pentingnya berkolaborasi dan berbagi peran dalam permainan kelompok.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Mulai Terpengaruh Tekanan Teman Sebaya',
            target: 'Target: Anak menunjukkan kecenderungan ingin meniru perilaku atau gaya temannya agar diterima dalam kelompok.',
            parentTips: [
              'Ajarkan anak untuk berani menolak ajakan teman jika hal tersebut merugikan atau tidak baik.',
              'Diskusikan pentingnya menjadi diri sendiri yang unik dan memiliki prinsip.',
              'Jalin komunikasi terbuka agar anak bebas bercerita tentang dinamika pertemanannya.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menerima Hasil Permainan dengan Sikap Dewasa',
            target: 'Target: Anak mampu menerima kekalahan atau kegagalan dalam tugas atau permainan tanpa menjadi sangat marah atau kecewa.',
            parentTips: [
              'Fokuskan pujian pada usaha keras anak alih-alih hasil akhir yang didapat.',
              'Contohkan reaksi sportif saat Anda sendiri mengalami kekalahan atau kegagalan kecil.',
              'Jelaskan bahwa kegagalan adalah kesempatan untuk belajar dan berkembang.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menunjukkan Kemandirian dan Berani Mencoba Hal Baru',
            target: 'Target: Anak aktif berinisiatif mengambil keputusan mandiri dan mencoba keterampilan baru secara percaya diri.',
            parentTips: [
              'Biarkan anak menata meja belajar atau kamarnya sendiri sesuai seleranya.',
              'Dukung ia mengeksplorasi minat baru seperti belajar memainkan alat musik atau seni rupa.',
              'Hargai pilihannya dan berikan bimbingan jika diperlukan.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Mengalami Rasa Cemas atau Takut yang Kompleks',
            target: 'Target: Anak mampu merasakan cemas (seperti takut gagal ujian atau cemas akan penolakan sosial).',
            parentTips: [
              'Dengarkan dengan penuh empati keluh kesah dan kekhawatiran anak tanpa langsung menghakiminya.',
              'Bantu anak memetakan langkah konkret untuk menghadapi situasi yang membuatnya cemas.',
              'Ajarkan teknik relaksasi sederhana seperti menarik napas dalam-dalam saat ia gugup.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Bermain Permainan Mandiri secara Seimbang',
            target: 'Target: Anak mampu asyik menikmati permainan logika atau teka-teki yang dimainkan secara mandiri.',
            parentTips: [
              'Sediakan buku teka-teki silang khusus anak atau tebak logika sebagai sarana bermain mandiri.',
              'Hargai waktu tenang anak saat ia asyik melakukan hobinya sendiri.',
              'Seimbangkan waktu bermain sendiri dengan interaksi sosial keluarga.',
            ],
          ),
          RedleafItem(
            number: 7,
            title: 'Mencari Kasih Sayang dan Perhatian dari Keluarga',
            target: 'Target: Anak membutuhkan penegasan kasih sayang, pelukan, dan penerimaan emosional dari orang tua.',
            parentTips: [
              'Luangkan waktu khusus untuk mengobrol berdua secara mendalam dengan anak sebelum tidur.',
              'Tunjukkan kasih sayang Anda melalui pelukan hangat, ciuman, dan kata-kata positif.',
              'Jadilah pendengar yang penuh perhatian saat anak ingin mencurahkan perasaannya.',
            ],
          ),
          RedleafItem(
            number: 8,
            title: 'Mencari Apresiasi dari Orang Dewasa',
            target: 'Target: Anak terdorong untuk berbuat baik demi mendapatkan persetujuan atau pujian dari orang tua atau guru.',
            parentTips: [
              'Berikan apresiasi spesifik ketika anak membantu tugas rumah tangga secara sukarela.',
              'Puji perilaku baiknya secara tulus untuk memperkuat motivasi internalnya.',
              'Hindari kritik tajam yang bisa meruntuhkan rasa percaya diri anak.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          RedleafItem(
            number: 1,
            title: 'Berkomunikasi Setara dengan Orang Dewasa',
            target: 'Target: Anak mampu mendiskusikan berbagai topik atau konsep kompleks dengan struktur kalimat yang matang saat bercakap-cakap dengan orang dewasa.',
            parentTips: [
              'Ajak anak mengobrol tentang isu sehari-hari yang ramah anak dan dengarkan opininya.',
              'Gunakan perbendaharaan kata yang bervariasi untuk memperluas pemahaman bahasanya.',
              'Berikan respon yang menghargai kecerdasan berpikir anak.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menyesuaikan Gaya Bahasa dengan Lawan Bicara',
            target: 'Target: Anak mampu mengubah pilihan kata dan nada bicaranya secara peka sesuai dengan siapa ia berbicara.',
            parentTips: [
              'Jelaskan pentingnya berbicara menggunakan kata-kata sopan saat berhadapan dengan orang yang lebih tua.',
              'Latih perbedaan intonasi suara saat berbicara santai dengan teman dan saat presentasi di kelas.',
              'Berikan contoh sikap santun dalam menyambut tamu di rumah.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menggunakan Bahasa Deskriptif yang Kaya',
            target: 'Target: Anak terampil menjelaskan suatu peristiwa, objek, atau perasaan menggunakan kata sifat yang mendetail.',
            parentTips: [
              'Minta anak menggambarkan suasana tempat wisata yang baru saja dikunjunginya secara rinci.',
              'Latih anak menggunakan analogi atau perumpamaan saat menceritakan perasaannya.',
              'Bacakan puisi anak-anak untuk memperkenalkan kata-kata indah bergaya deskriptif.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menyukai Humor dan Melontarkan Lelucon',
            target: 'Target: Anak menyukai humor, teka-teki kata, serta senang berbagi candaan jenaka dengan orang di sekitarnya.',
            parentTips: [
              'Sambut candaan anak dengan tawa hangat untuk memupuk rasa percaya diri sosialnya.',
              'Ajarkan batasan humor agar anak tidak membuat lelucon yang mengejek fisik atau perasaan orang lain.',
              'Bacakan buku kumpulan cerita jenaka anak-anak bersama.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menggunakan Bahasa untuk Mengekspresikan Emosi',
            target: 'Target: Anak mampu mengomunikasikan perasaan internalnya (seperti cemas atau kecewa) secara verbal daripada tindakan fisik.',
            parentTips: [
              'Dampingi anak menguraikan emosinya secara lisan saat ia sedang tertekan (',
              ').',
              'Puji kemampuannya mengendalikan amarah dan memilih berdiskusi secara tenang.',
              'Bantu anak menuliskan perasaannya dalam bentuk catatan harian jika ia kesulitan mengungkapkannya secara lisan.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Mengenal dan Menggunakan Bahasa Gaul secara Tepat',
            target: 'Target: Anak mulai mengenal kata gaul yang digunakan teman sebayanya dan memahami konteks penggunaannya.',
            parentTips: [
              'Diskusikan arti kata gaul baru yang didengar anak di sekolah secara terbuka.',
              'Ingatkan anak agar tidak menggunakan kata gaul tersebut dalam situasi formal seperti berbicara dengan guru.',
              'Pastikan kata gaul yang digunakan anak tetap bermakna positif dan tidak kasar.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          RedleafItem(
            number: 1,
            title: 'Terlibat dalam Proyek Pembelajaran',
            target: 'Target: Anak mampu merancang dan menyelesaikan proyek terencana (seperti membuat kliping atau herbarium) dalam beberapa hari.',
            parentTips: [
              'Bantu anak mengumpulkan bahan-bahan daur ulang untuk menunjang proyek belajarnya.',
              'Ajak anak membuat jadwal pengerjaan proyek agar selesai tepat waktu.',
              'Tunjukkan apresiasi yang tinggi atas hasil karya proyek yang diselesaikannya.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menggunakan dan Membaca Kalender',
            target: 'Target: Anak terampil membaca kalender, merencanakan jadwal kegiatan, dan menghitung selisih hari.',
            parentTips: [
              'Letakkan kalender meja khusus di meja belajar anak untuk melacak tugas sekolahnya.',
              'Ajak anak menghitung jumlah hari tersisa sebelum hari liburan keluarga dimulai.',
              'Latih ia mencatat agenda penting harian secara mandiri.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Melakukan Penelitian atau Pencarian Informasi Dasar',
            target: 'Target: Anak mampu mencari informasi mandiri dari buku referensi atau internet aman untuk menjawab pertanyaan sains atau sejarah.',
            parentTips: [
              'Ajarkan anak cara menggunakan indeks buku perpustakaan untuk mencari topik yang diinginkan.',
              'Bimbing anak menggunakan mesin pencari ramah anak di internet secara aman.',
              'Diskusikan informasi yang baru ditemukannya untuk melatih analisis kritis.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Menggunakan Penalaran Logis',
            target: 'Target: Anak mampu menganalisis masalah, menggunakan logika sebab-akibat, dan berargumentasi secara rasional.',
            parentTips: [
              'Ajak anak bermain catur atau permainan papan strategi lainnya.',
              'Diskusikan alasan di balik aturan-aturan di rumah atau sekolah secara logis.',
              'Dengarkan argumen anak and berikan umpan balik yang rasional.',
            ],
          ),
          RedleafItem(
            number: 5,
            title: 'Menunjukkan Minat pada Tempat dan Budaya Lain',
            target: 'Target: Anak tertarik mengetahui kehidupan negara lain, sejarah suku bangsa, pakaian adat, atau makanan khas daerah lain.',
            parentTips: [
              'Ajak anak mencicipi makanan khas daerah atau negara lain secara berkala.',
              'Bacakan buku kumpulan cerita rakyat nusantara dan dongeng dunia.',
              'Tonton film dokumenter budaya dunia yang ramah anak bersama-sama.',
            ],
          ),
          RedleafItem(
            number: 6,
            title: 'Menunjukkan Minat pada Perkembangan Teknologi',
            target: 'Target: Anak tertarik mengeksplorasi gawai, perangkat mekanik sederhana, atau cara kerja program komputer.',
            parentTips: [
              'Dampingi anak bereksperimen menggunakan mainan sirkuit listrik anak yang aman.',
              'Diskusikan dampak positif dan negatif penggunaan teknologi dalam kehidupan sehari-hari.',
              'Fasilitasi minat anak pada pembuatan animasi atau game sederhana lewat Scratch.',
            ],
          ),
        ],
      ),
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          RedleafItem(
            number: 1,
            title: 'Menunjukkan Rasa Ingin Tahu tentang Alam dan Budaya',
            target: 'Target: Anak aktif menunjukkan antusiasme untuk mengeksplorasi alam, masyarakat, adat istiadat, dan negara lain.',
            parentTips: [
              'Sambut setiap pertanyaan kritis anak tentang perbedaan sosial atau alam secara sabar.',
              'Sediakan buku cerita bertema geografi dunia atau ensiklopedia anak.',
              'Ajak anak mengunjungi pameran seni atau museum kebudayaan.',
            ],
          ),
          RedleafItem(
            number: 2,
            title: 'Menunjukkan Minat pada Seni, Kosakata, dan Tindakan Sosial',
            target: 'Target: Anak peka mengamati keindahan karya seni, mengeksplorasi makna kosakata baru, serta mengamati tindakan sosial.',
            parentTips: [
              'Sediakan media lukis dan krayon di rumah untuk menyalurkan bakat seninya.',
              'Diskusikan kosa kata indah atau majas sederhana yang ia temui saat membaca buku bersama.',
              'Bahas keteladanan positif dari tokoh kepahlawanan atau masyarakat.',
            ],
          ),
          RedleafItem(
            number: 3,
            title: 'Menunjukkan Ketekunan dengan Dorongan Minimal',
            target: 'Target: Anak gigih berusaha menyelesaikan tantangan atau tugas yang rumit secara mandiri tanpa perlu terus-menerus didorong.',
            parentTips: [
              'Puji kemandirian anak saat ia fokus menyelesaikan tugasnya sendiri.',
              'Biarkan anak mencoba memecahkan masalahnya terlebih dahulu sebelum Anda menawarkan bantuan.',
              'Berikan ruang yang tenang agar ia dapat berkonsentrasi tuntas.',
            ],
          ),
          RedleafItem(
            number: 4,
            title: 'Merefleksikan dan Mengevaluasi Pembelajaran Sendiri',
            target: 'Target: Anak mampu merenungkan apa yang telah dipelajari serta menilai hasil karyanya secara jujur.',
            parentTips: [
              'Ajak anak berdiskusi santai mengevaluasi hasil belajarnya (',
              ').',
              'Bimbing anak menyadari kekuatan dan kelemahannya tanpa membandingkannya dengan anak lain.',
              'Latih ia merencanakan langkah perbaikan untuk tugas berikutnya.',
            ],
          ),
        ],
      ),
    ],
  ),
];

/// Mendapatkan kelompok usia Redleaf yang sesuai dengan usia anak dalam bulan.
RedleafAgeGroup getRedleafAgeGroupForAge(int ageMonths) {
  for (final group in redleafAgeGroups) {
    if (ageMonths >= group.minAgeMonths && ageMonths < group.maxAgeMonths) {
      return group;
    }
  }
  if (ageMonths < redleafAgeGroups.first.minAgeMonths) {
    return redleafAgeGroups.first;
  }
  return redleafAgeGroups.last;
}

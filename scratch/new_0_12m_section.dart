/// Pembagian kelompok usia 0-12 bulan dalam satu group sesuai buku asli Chapter 4.
final List<RedleafAgeGroup> redleafAgeGroups = [
  const RedleafAgeGroup(
    id: '0_12m',
    name: 'Lahir - 12 Bulan',
    minAgeMonths: 0,
    maxAgeMonths: 12,
    domains: [
      // ═══════════════════════════════════════════════════════
      // DOMAIN 1: Fisik & Motorik (38 items)
      // ═══════════════════════════════════════════════════════
      RedleafDomain(
        id: 'fisik_motorik',
        name: 'Fisik & Motorik',
        items: [
          // ── Birth to Two Months (7 items) ──
          RedleafItem(
            number: 1,
            title: 'Exhibits a rooting reflex',
            target: 'Target: Anak mampu menunjukkan refleks rooting.',
            parentTips: ['Sentuhkan pipi bayi dengan lembut untuk memicu refleks rooting saat menyusui.', 'Jaga lingkungan yang tenang dan nyaman agar bayi tidak terlalu sering terkejut oleh suara keras.', 'Perhatikan refleks bayi secara rutin dan konsultasikan ke dokter jika refleks tidak muncul.'],
          ),
          RedleafItem(
            number: 2,
            title: 'Reacts to loud noises',
            target: 'Target: Anak mampu bereaksi terhadap suara keras.',
            parentTips: ['Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).', 'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.', 'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.'],
          ),
          RedleafItem(
            number: 3,
            title: 'Holds head up',
            target: 'Target: Anak mampu mengangkat dan menahan kepala.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 4,
            title: 'Makes quick and jerking arm movements',
            target: 'Target: Anak mampu membuat gerakan lengan cepat dan tersentak.',
            parentTips: ['Biarkan lengan dan tangan bayi bebas bergerak (tidak dibedong terlalu ketat) untuk melatih koordinasi.', 'Gantungkan mainan berwarna cerah yang aman di atas tempat tidur bayi agar ia tertarik meraih.', 'Pastikan tangan bayi selalu bersih karena ia sering memasukkan tangan ke mulut sebagai eksplorasi.'],
          ),
          RedleafItem(
            number: 5,
            title: 'Brings hands to face',
            target: 'Target: Anak mampu membawa tangan ke wajah.',
            parentTips: ['Biarkan lengan dan tangan bayi bebas bergerak (tidak dibedong terlalu ketat) untuk melatih koordinasi.', 'Gantungkan mainan berwarna cerah yang aman di atas tempat tidur bayi agar ia tertarik meraih.', 'Pastikan tangan bayi selalu bersih karena ia sering memasukkan tangan ke mulut sebagai eksplorasi.'],
          ),
          RedleafItem(
            number: 6,
            title: 'Moves head from side to side while on stomach',
            target: 'Target: Anak mampu menggerakkan kepala ke kanan-kiri saat tengkurap.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 7,
            title: 'Focuses on objects eight to twelve inches away',
            target: 'Target: Anak mampu fokus pada objek berjarak 20-30 cm.',
            parentTips: ['Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.', 'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.', 'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.'],
          ),
          // ── Two to Three Months (5 items) ──
          RedleafItem(
            number: 8,
            title: 'Turns head easily to both sides in supine (lying on back) position',
            target: 'Target: Anak mampu memutar kepala ke kedua sisi saat posisi terlentang.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 9,
            title: 'Lifts head off surface from prone (face down) position for one to two seconds',
            target: 'Target: Anak mampu mengangkat kepala dari posisi tengkurap selama 1-2 detik.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 10,
            title: 'Follows moving object with eyes',
            target: 'Target: Anak mampu mengikuti objek bergerak dengan mata.',
            parentTips: ['Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.', 'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.', 'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.'],
          ),
          RedleafItem(
            number: 11,
            title: 'Responds to loud sounds',
            target: 'Target: Anak mampu merespons suara keras.',
            parentTips: ['Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).', 'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.', 'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.'],
          ),
          RedleafItem(
            number: 12,
            title: 'Grasps and holds objects briefly',
            target: 'Target: Anak mampu menggenggam dan menahan objek sebentar.',
            parentTips: ['Berikan mainan yang aman untuk digenggam (kerincingan, mainan gigit, bola kecil empuk).', 'Letakkan benda di dekat tangan bayi untuk memicu respons menggenggam.', 'Latih kemampuan menggenggam bertahap dari benda besar ke benda kecil seiring pertumbuhannya.'],
          ),
          // ── Three to Four Months (7 items) ──
          RedleafItem(
            number: 13,
            title: 'Brings hands to midline while on back',
            target: 'Target: Anak mampu membawa tangan ke garis tengah tubuh saat terlentang.',
            parentTips: ['Biarkan lengan dan tangan bayi bebas bergerak (tidak dibedong terlalu ketat) untuk melatih koordinasi.', 'Gantungkan mainan berwarna cerah yang aman di atas tempat tidur bayi agar ia tertarik meraih.', 'Pastikan tangan bayi selalu bersih karena ia sering memasukkan tangan ke mulut sebagai eksplorasi.'],
          ),
          RedleafItem(
            number: 14,
            title: 'Rotates or turns head from side to side with no head bobbing',
            target: 'Target: Anak mampu memutar kepala ke kanan-kiri tanpa kepala terkulai.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 15,
            title: 'Holds head steady when carried or held',
            target: 'Target: Anak mampu menahan kepala tegak saat digendong atau dipegang.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 16,
            title: 'Plays with hands and may hold and observe a toy',
            target: 'Target: Anak mampu bermain dengan tangan dan memegang serta mengamati mainan.',
            parentTips: ['Berikan mainan yang aman untuk digenggam (kerincingan, mainan gigit, bola kecil empuk).', 'Letakkan benda di dekat tangan bayi untuk memicu respons menggenggam.', 'Latih kemampuan menggenggam bertahap dari benda besar ke benda kecil seiring pertumbuhannya.'],
          ),
          RedleafItem(
            number: 17,
            title: 'Reaches for objects',
            target: 'Target: Anak mampu meraih benda.',
            parentTips: ['Sediakan ruang bermain yang aman dan luas untuk anak melatih kemampuan fisik dan motoriknya.', 'Dampingi anak saat berlatih keterampilan baru dan berikan contoh gerakan yang benar.', 'Berikan pujian atas setiap kemajuan motorik anak dan jangan memaksakan jika belum siap.'],
          ),
          RedleafItem(
            number: 18,
            title: 'Pushes down on legs when feet are placed on a firm surface',
            target: 'Target: Anak mampu mendorong kaki ke bawah saat diletakkan di permukaan keras.',
            parentTips: ['Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.', 'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.', 'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.'],
          ),
          RedleafItem(
            number: 19,
            title: 'Exhibits the rooting reflex less often or not at all',
            target: 'Target: Anak menunjukkan refleks rooting lebih jarang atau tidak sama sekali.',
            parentTips: ['Sentuhkan pipi bayi dengan lembut untuk memicu refleks rooting saat menyusui.', 'Jaga lingkungan yang tenang dan nyaman agar bayi tidak terlalu sering terkejut oleh suara keras.', 'Perhatikan refleks bayi secara rutin dan konsultasikan ke dokter jika refleks tidak muncul.'],
          ),
          // ── Four to Six Months (8 items) ──
          RedleafItem(
            number: 20,
            title: 'Follows distant object with eyes',
            target: 'Target: Anak mampu mengikuti objek jauh dengan mata.',
            parentTips: ['Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.', 'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.', 'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.'],
          ),
          RedleafItem(
            number: 21,
            title: 'Lifts head while in supine (lying on back) position',
            target: 'Target: Anak mampu mengangkat kepala saat posisi terlentang.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 22,
            title: 'Holds chest up with weight on forearms',
            target: 'Target: Anak mampu menahan dada terangkat dengan bertumpu pada lengan bawah.',
            parentTips: ['Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.', 'Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.', 'Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal.'],
          ),
          RedleafItem(
            number: 23,
            title: 'Rolls from stomach to side',
            target: 'Target: Anak mampu berguling dari perut ke samping.',
            parentTips: ['Berikan waktu tengkurap yang cukup dan letakkan mainan di samping bayi untuk memotivasi berguling.', 'Bantu bayi berlatih berguling dengan lembut memegang pinggulnya dan membantu gerakan memutar.', 'Pastikan area bermain aman dan empuk (gunakan matras atau selimut tebal) saat bayi berlatih berguling.'],
          ),
          RedleafItem(
            number: 24,
            title: 'Rolls from stomach to back',
            target: 'Target: Anak mampu berguling dari perut ke punggung.',
            parentTips: ['Berikan waktu tengkurap yang cukup dan letakkan mainan di samping bayi untuk memotivasi berguling.', 'Bantu bayi berlatih berguling dengan lembut memegang pinggulnya dan membantu gerakan memutar.', 'Pastikan area bermain aman dan empuk (gunakan matras atau selimut tebal) saat bayi berlatih berguling.'],
          ),
          RedleafItem(
            number: 25,
            title: 'Rolls from back to stomach',
            target: 'Target: Anak mampu berguling dari punggung ke perut.',
            parentTips: ['Berikan waktu tengkurap yang cukup dan letakkan mainan di samping bayi untuk memotivasi berguling.', 'Bantu bayi berlatih berguling dengan lembut memegang pinggulnya dan membantu gerakan memutar.', 'Pastikan area bermain aman dan empuk (gunakan matras atau selimut tebal) saat bayi berlatih berguling.'],
          ),
          RedleafItem(
            number: 26,
            title: 'Stands with support',
            target: 'Target: Anak mampu berdiri dengan bantuan.',
            parentTips: ['Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.', 'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.', 'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.'],
          ),
          RedleafItem(
            number: 27,
            title: 'Brings feet to mouth easily while in supine (lying on back) position',
            target: 'Target: Anak mampu membawa kaki ke mulut saat posisi terlentang.',
            parentTips: ['Sediakan ruang bermain yang aman dan luas untuk anak melatih kemampuan fisik dan motoriknya.', 'Dampingi anak saat berlatih keterampilan baru dan berikan contoh gerakan yang benar.', 'Berikan pujian atas setiap kemajuan motorik anak dan jangan memaksakan jika belum siap.'],
          ),
          // ── Six to Nine Months (8 items) ──
          RedleafItem(
            number: 28,
            title: 'Transfers object from one hand to another',
            target: 'Target: Anak mampu memindahkan benda dari satu tangan ke tangan lain.',
            parentTips: ['Sediakan ruang bermain yang aman dan luas untuk anak melatih kemampuan fisik dan motoriknya.', 'Dampingi anak saat berlatih keterampilan baru dan berikan contoh gerakan yang benar.', 'Berikan pujian atas setiap kemajuan motorik anak dan jangan memaksakan jika belum siap.'],
          ),
          RedleafItem(
            number: 29,
            title: 'Uses toes and hands to propel forward or in a circle',
            target: 'Target: Anak mampu menggunakan jari kaki dan tangan untuk mendorong maju atau memutar.',
            parentTips: ['Letakkan mainan favorit di depan bayi (sedikit di luar jangkauan) untuk memotivasi gerakan merangkak.', 'Berikan permukaan yang aman untuk merangkak (matras, karpet, lantai yang bersih).', 'Ikut merangkak bersama bayi sebagai contoh dan ajak bermain mengejar untuk memotivasi gerak.'],
          ),
          RedleafItem(
            number: 30,
            title: 'Attempts to crawl (stomach and legs dragging)',
            target: 'Target: Anak mampu mencoba merangkak (perut dan kaki menyeret).',
            parentTips: ['Letakkan mainan favorit di depan bayi (sedikit di luar jangkauan) untuk memotivasi gerakan merangkak.', 'Berikan permukaan yang aman untuk merangkak (matras, karpet, lantai yang bersih).', 'Ikut merangkak bersama bayi sebagai contoh dan ajak bermain mengejar untuk memotivasi gerak.'],
          ),
          RedleafItem(
            number: 31,
            title: 'Crawls',
            target: 'Target: Anak mampu merangkak.',
            parentTips: ['Letakkan mainan favorit di depan bayi (sedikit di luar jangkauan) untuk memotivasi gerakan merangkak.', 'Berikan permukaan yang aman untuk merangkak (matras, karpet, lantai yang bersih).', 'Ikut merangkak bersama bayi sebagai contoh dan ajak bermain mengejar untuk memotivasi gerak.'],
          ),
          RedleafItem(
            number: 32,
            title: 'Gets to a sitting position',
            target: 'Target: Anak mampu mencapai posisi duduk.',
            parentTips: ['Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.', 'Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.', 'Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh.'],
          ),
          RedleafItem(
            number: 33,
            title: 'Grasps small items',
            target: 'Target: Anak mampu menggenggam benda-benda kecil.',
            parentTips: ['Berikan mainan yang aman untuk digenggam (kerincingan, mainan gigit, bola kecil empuk).', 'Letakkan benda di dekat tangan bayi untuk memicu respons menggenggam.', 'Latih kemampuan menggenggam bertahap dari benda besar ke benda kecil seiring pertumbuhannya.'],
          ),
          RedleafItem(
            number: 34,
            title: 'Sits without support',
            target: 'Target: Anak mampu duduk tanpa bantuan.',
            parentTips: ['Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.', 'Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.', 'Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh.'],
          ),
          RedleafItem(
            number: 35,
            title: 'Can be pulled to feet but can\'t support self',
            target: 'Target: Anak mampu ditarik berdiri tapi belum bisa menopang diri sendiri.',
            parentTips: ['Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.', 'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.', 'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.'],
          ),
          // ── Nine to Twelve Months (3 items) ──
          RedleafItem(
            number: 36,
            title: 'May stand momentarily without support',
            target: 'Target: Anak mampu berdiri sebentar tanpa bantuan.',
            parentTips: ['Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.', 'Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.', 'Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri.'],
          ),
          RedleafItem(
            number: 37,
            title: 'Walks with assistance',
            target: 'Target: Anak mampu berjalan dengan bantuan.',
            parentTips: ['Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.', 'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.', 'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.'],
          ),
          RedleafItem(
            number: 38,
            title: 'Walks alone',
            target: 'Target: Anak mampu berjalan sendiri.',
            parentTips: ['Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.', 'Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.', 'Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki.'],
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════
      // DOMAIN 2: Sosial & Emosional (22 items)
      // ═══════════════════════════════════════════════════════
      RedleafDomain(
        id: 'sosial_emosional',
        name: 'Sosial & Emosional',
        items: [
          // ── Birth to One Month (4 items) ──
          RedleafItem(
            number: 1,
            title: 'Makes demanding cries',
            target: 'Target: Anak mampu membuat tangisan yang menuntut.',
            parentTips: ['Respons tangisan bayi/anak dengan segera dan tenang untuk membangun rasa aman.', 'Kenali pola tangisan anak (lapar, mengantuk, tidak nyaman) dan tangani penyebabnya.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan kata-kata sebagai pengganti tangisan/marah.'],
          ),
          RedleafItem(
            number: 2,
            title: 'Shows sense of trust',
            target: 'Target: Anak mampu menunjukkan rasa percaya.',
            parentTips: ['Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.', 'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.'],
          ),
          RedleafItem(
            number: 3,
            title: 'Shows attachment (responds positively) to significant adults',
            target: 'Target: Anak mampu menunjukkan kelekatan (merespons positif) pada orang dewasa penting.',
            parentTips: ['Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.', 'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.'],
          ),
          RedleafItem(
            number: 4,
            title: 'Makes eye contact',
            target: 'Target: Anak mampu melakukan kontak mata.',
            parentTips: ['Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.', 'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.', 'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.'],
          ),
          // ── One to Three Months (5 items) ──
          RedleafItem(
            number: 5,
            title: 'Coos',
            target: 'Target: Anak mampu mengeluarkan suara kuu (cooing).',
            parentTips: ['Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.', 'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.', 'Ajak bayi \'bercakap-cakap\' dengan menirukan suaranya dan menambahkan kata-kata baru.'],
          ),
          RedleafItem(
            number: 6,
            title: 'Smiles at the sound of familiar voices',
            target: 'Target: Anak mampu tersenyum saat mendengar suara yang dikenal.',
            parentTips: ['Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.', 'Ajak bayi \'bercakap-cakap\' dengan suara lembut dan ekspresi wajah yang ramah.', 'Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional.'],
          ),
          RedleafItem(
            number: 7,
            title: 'Tracks moving persons or objects',
            target: 'Target: Anak mampu melacak orang atau benda yang bergerak.',
            parentTips: ['Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.', 'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.', 'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.'],
          ),
          RedleafItem(
            number: 8,
            title: 'Cries to demand attention',
            target: 'Target: Anak mampu menangis untuk menuntut perhatian.',
            parentTips: ['Respons tangisan bayi/anak dengan segera dan tenang untuk membangun rasa aman.', 'Kenali pola tangisan anak (lapar, mengantuk, tidak nyaman) dan tangani penyebabnya.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan kata-kata sebagai pengganti tangisan/marah.'],
          ),
          RedleafItem(
            number: 9,
            title: 'Smiles at strangers',
            target: 'Target: Anak mampu tersenyum pada orang asing.',
            parentTips: ['Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.', 'Ajak bayi \'bercakap-cakap\' dengan suara lembut dan ekspresi wajah yang ramah.', 'Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional.'],
          ),
          // ── Three to Six Months (5 items) ──
          RedleafItem(
            number: 10,
            title: 'Babbles and laughs to get adult attention',
            target: 'Target: Anak mampu berceloteh dan tertawa untuk menarik perhatian orang dewasa.',
            parentTips: ['Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.', 'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.', 'Ajak bayi \'bercakap-cakap\' dengan menirukan suaranya dan menambahkan kata-kata baru.'],
          ),
          RedleafItem(
            number: 11,
            title: 'Responds to smiles with smiling',
            target: 'Target: Anak mampu merespons senyuman dengan senyuman.',
            parentTips: ['Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.', 'Ajak bayi \'bercakap-cakap\' dengan suara lembut dan ekspresi wajah yang ramah.', 'Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional.'],
          ),
          RedleafItem(
            number: 12,
            title: 'Pays close attention to older children and their actions',
            target: 'Target: Anak mampu memperhatikan anak yang lebih besar dan tindakan mereka.',
            parentTips: ['Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.', 'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.'],
          ),
          RedleafItem(
            number: 13,
            title: 'Calms self',
            target: 'Target: Anak mampu menenangkan diri sendiri.',
            parentTips: ['Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.', 'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.'],
          ),
          RedleafItem(
            number: 14,
            title: 'Looks and listens for purpose',
            target: 'Target: Anak mampu melihat dan mendengarkan dengan tujuan.',
            parentTips: ['Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.', 'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.'],
          ),
          // ── Six to Nine Months (3 items) ──
          RedleafItem(
            number: 15,
            title: 'Distinguishes voices of important, familiar people',
            target: 'Target: Anak mampu membedakan suara orang-orang penting dan dikenal.',
            parentTips: ['Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.', 'Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari.'],
          ),
          RedleafItem(
            number: 16,
            title: 'Can distinguish voice tones and emotions',
            target: 'Target: Anak mampu membedakan nada suara dan emosi.',
            parentTips: ['Bantu anak menamai emosi yang dirasakan (senang, sedih, marah, takut, kecewa).', 'Dengarkan cerita dan keluh kesah anak tanpa langsung menghakimi atau menyalahkan.', 'Ajarkan teknik menenangkan diri (tarik napas dalam-dalam, hitung 1-10) saat emosi mulai meningkat.'],
          ),
          RedleafItem(
            number: 17,
            title: 'Plays games with adults and older children',
            target: 'Target: Anak mampu bermain permainan dengan orang dewasa dan anak yang lebih besar.',
            parentTips: ['Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.', 'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.', 'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.'],
          ),
          // ── Nine to Twelve Months (5 items) ──
          RedleafItem(
            number: 18,
            title: 'Begins to feel anxiety on separation from familiar adults (separation anxiety)',
            target: 'Target: Anak mulai merasa cemas saat berpisah dari orang dewasa yang dikenal (kecemasan perpisahan).',
            parentTips: ['Berikan pelukan dan kata-kata menenangkan saat anak merasa takut atau cemas.', 'Perkenalkan orang baru secara bertahap dengan kehadiran orang tua di samping anak.', 'Latih perpisahan singkat secara bertahap (misal: titip ke nenek 15 menit, lalu bertahap lebih lama).'],
          ),
          RedleafItem(
            number: 19,
            title: 'Begins to feel anxiety in the presence of strangers (stranger anxiety)',
            target: 'Target: Anak mulai merasa cemas di hadapan orang asing (kecemasan terhadap orang asing).',
            parentTips: ['Berikan pelukan dan kata-kata menenangkan saat anak merasa takut atau cemas.', 'Perkenalkan orang baru secara bertahap dengan kehadiran orang tua di samping anak.', 'Latih perpisahan singkat secara bertahap (misal: titip ke nenek 15 menit, lalu bertahap lebih lama).'],
          ),
          RedleafItem(
            number: 20,
            title: 'Plays with others',
            target: 'Target: Anak mampu bermain dengan orang lain.',
            parentTips: ['Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.', 'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.', 'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.'],
          ),
          RedleafItem(
            number: 21,
            title: 'Expresses emotions (happiness, sadness, anger, and surprise) through gestures, sounds, or facial expressions',
            target: 'Target: Anak mampu mengekspresikan emosi (senang, sedih, marah, terkejut) melalui gestur, suara, atau ekspresi wajah.',
            parentTips: ['Bantu anak menamai emosi yang dirasakan (senang, sedih, marah, takut, kecewa).', 'Dengarkan cerita dan keluh kesah anak tanpa langsung menghakimi atau menyalahkan.', 'Ajarkan teknik menenangkan diri (tarik napas dalam-dalam, hitung 1-10) saat emosi mulai meningkat.'],
          ),
          RedleafItem(
            number: 22,
            title: 'Explores environment',
            target: 'Target: Anak mampu mengeksplorasi lingkungan.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════
      // DOMAIN 3: Komunikasi & Bahasa (13 items)
      // ═══════════════════════════════════════════════════════
      RedleafDomain(
        id: 'komunikasi_bahasa',
        name: 'Komunikasi & Bahasa',
        items: [
          // ── One to Two Months (1 item) ──
          RedleafItem(
            number: 1,
            title: 'Coos in response to adults\' speech',
            target: 'Target: Anak mampu mengeluarkan suara kuu sebagai respons terhadap ucapan orang dewasa.',
            parentTips: ['Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.', 'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.', 'Ajak bayi \'bercakap-cakap\' dengan menirukan suaranya dan menambahkan kata-kata baru.'],
          ),
          // ── Two to Four Months (1 item) ──
          RedleafItem(
            number: 2,
            title: 'Makes squealing and gurgling sounds',
            target: 'Target: Anak mampu membuat suara melengking dan berkumur.',
            parentTips: ['Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).', 'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.', 'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.'],
          ),
          // ── Four to Six Months (2 items) ──
          RedleafItem(
            number: 3,
            title: 'Babbles consonant sounds such as "ba-ba-ba-ba-ba" and "da-da-da-da-da"',
            target: 'Target: Anak mampu mengoceh suara konsonan seperti "ba-ba-ba" dan "da-da-da".',
            parentTips: ['Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.', 'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.', 'Ajak bayi \'bercakap-cakap\' dengan menirukan suaranya dan menambahkan kata-kata baru.'],
          ),
          RedleafItem(
            number: 4,
            title: 'Laughs out loud',
            target: 'Target: Anak mampu tertawa keras.',
            parentTips: ['Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat yang jelas.', 'Bacakan buku cerita bergambar secara rutin dan ajak anak bercerita ulang.', 'Respons setiap upaya bicara anak dengan antusias untuk memotivasi perkembangan bahasanya.'],
          ),
          // ── Six to Nine Months (5 items) ──
          RedleafItem(
            number: 5,
            title: 'Babbles sounds, such as "goo" and "gaa"',
            target: 'Target: Anak mampu mengoceh suara seperti "goo" dan "gaa".',
            parentTips: ['Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.', 'Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.', 'Ajak bayi \'bercakap-cakap\' dengan menirukan suaranya dan menambahkan kata-kata baru.'],
          ),
          RedleafItem(
            number: 6,
            title: 'Experiments with vocalizations that include longer and more varied sounds',
            target: 'Target: Anak mampu bereksperimen dengan vokalisasi yang lebih panjang dan beragam.',
            parentTips: ['Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).', 'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.', 'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.'],
          ),
          RedleafItem(
            number: 7,
            title: 'Uses intonations in sounds',
            target: 'Target: Anak mampu menggunakan intonasi dalam suara.',
            parentTips: ['Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).', 'Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.', 'Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya.'],
          ),
          RedleafItem(
            number: 8,
            title: 'Responds to own name',
            target: 'Target: Anak mampu merespons saat namanya dipanggil.',
            parentTips: ['Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat yang jelas.', 'Bacakan buku cerita bergambar secara rutin dan ajak anak bercerita ulang.', 'Respons setiap upaya bicara anak dengan antusias untuk memotivasi perkembangan bahasanya.'],
          ),
          RedleafItem(
            number: 9,
            title: 'Develops receptive-language vocabulary',
            target: 'Target: Anak mampu mengembangkan kosakata bahasa reseptif.',
            parentTips: ['Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat yang jelas.', 'Bacakan buku cerita bergambar secara rutin dan ajak anak bercerita ulang.', 'Respons setiap upaya bicara anak dengan antusias untuk memotivasi perkembangan bahasanya.'],
          ),
          // ── Nine to Twelve Months (4 items) ──
          RedleafItem(
            number: 10,
            title: 'Says at least one word',
            target: 'Target: Anak mampu mengucapkan setidaknya satu kata.',
            parentTips: ['Sebutkan nama benda-benda di sekitar saat beraktivitas (\'Ini apel, apel warna merah\').', 'Respons upaya bicara anak dengan antusias dan ulangi kata yang benar tanpa menyalahkan.', 'Ajak bernyanyi lagu-lagu sederhana yang mengulang kata-kata untuk memperkaya kosakata.'],
          ),
          RedleafItem(
            number: 11,
            title: 'Gestures or points to communicate',
            target: 'Target: Anak mampu menggunakan gestur atau menunjuk untuk berkomunikasi.',
            parentTips: ['Ajarkan isyarat sederhana (melambaikan tangan, menggeleng, mengangguk) dalam konteks sehari-hari.', 'Respons saat anak menunjuk benda dengan menyebutkan nama benda tersebut.', 'Gunakan gerakan tangan dan ekspresi wajah saat berbicara untuk memperkuat pemahaman bahasa.'],
          ),
          RedleafItem(
            number: 12,
            title: 'Listens to songs, stories, or rhymes with interest',
            target: 'Target: Anak mampu mendengarkan lagu, cerita, atau sajak dengan penuh minat.',
            parentTips: ['Bacakan buku cerita bergambar menarik secara rutin setiap hari.', 'Ajak anak menceritakan kembali alur cerita yang didengarnya dengan bahasanya sendiri.', 'Nyanyikan lagu-lagu anak bersama dan ajak anak menghafal syair sederhana.'],
          ),
          RedleafItem(
            number: 13,
            title: 'Imitates sounds',
            target: 'Target: Anak mampu meniru suara.',
            parentTips: ['Tunjukkan perilaku positif yang ingin ditiru anak dalam kehidupan sehari-hari.', 'Ajak bermain peran (masak-masakan, dokter-dokteran) untuk mengembangkan kemampuan meniru.', 'Puji anak saat ia meniru perilaku baik seperti merapikan mainan atau membantu pekerjaan rumah.'],
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════
      // DOMAIN 4: Kognitif (16 items)
      // ═══════════════════════════════════════════════════════
      RedleafDomain(
        id: 'kognitif',
        name: 'Kognitif',
        items: [
          // ── Birth to Two Months (2 items) ──
          RedleafItem(
            number: 1,
            title: 'Shows understanding that crying brings comfort',
            target: 'Target: Anak mampu menunjukkan pemahaman bahwa menangis mendatangkan kenyamanan.',
            parentTips: ['Respons tangisan bayi/anak dengan segera dan tenang untuk membangun rasa aman.', 'Kenali pola tangisan anak (lapar, mengantuk, tidak nyaman) dan tangani penyebabnya.', 'Ajarkan anak mengenali dan mengekspresikan emosi dengan kata-kata sebagai pengganti tangisan/marah.'],
          ),
          RedleafItem(
            number: 2,
            title: 'Prefers black-and-white or high-contrast patterns',
            target: 'Target: Anak mampu menunjukkan preferensi terhadap pola hitam-putih atau kontras tinggi.',
            parentTips: ['Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.', 'Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.', 'Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata.'],
          ),
          // ── Two to Four Months (4 items) ──
          RedleafItem(
            number: 3,
            title: 'Explores the environment with senses',
            target: 'Target: Anak mampu mengeksplorasi lingkungan dengan indra.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          RedleafItem(
            number: 4,
            title: 'Discovers hands and feet are extensions of self',
            target: 'Target: Anak mampu menemukan bahwa tangan dan kaki adalah bagian dari diri sendiri.',
            parentTips: ['Ajak anak bermain permainan edukatif yang merangsang berpikir (puzzle, tebak-tebakan, hitung benda).', 'Libatkan anak dalam aktivitas sehari-hari yang mengembangkan kemampuan kognitif (memasak, berkebun).', 'Berikan pertanyaan terbuka yang merangsang anak berpikir dan mengeksplorasi jawaban sendiri.'],
          ),
          RedleafItem(
            number: 5,
            title: 'Responds to own reflection in mirror',
            target: 'Target: Anak mampu merespons pantulan dirinya di cermin.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          RedleafItem(
            number: 6,
            title: 'Anticipates events',
            target: 'Target: Anak mampu mengantisipasi kejadian.',
            parentTips: ['Gunakan rutinitas harian untuk mengenalkan konsep waktu (\'Setelah mandi, kita sarapan\').', 'Ceritakan urutan kegiatan menggunakan kata-kata waktu (pagi, siang, malam, kemarin, besok).', 'Libatkan anak mengatur jadwal sederhana hariannya dengan gambar-gambar aktivitas.'],
          ),
          // ── Four to Six Months (1 item) ──
          RedleafItem(
            number: 7,
            title: 'Shows interest in manipulating toys and objects',
            target: 'Target: Anak mampu menunjukkan minat dalam memanipulasi mainan dan benda.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          // ── Six to Nine Months (3 items) ──
          RedleafItem(
            number: 8,
            title: 'Investigates objects by banging, shaking, and throwing',
            target: 'Target: Anak mampu menyelidiki benda dengan memukul, mengguncang, dan melempar.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          RedleafItem(
            number: 9,
            title: 'Shows interest in objects with moving parts',
            target: 'Target: Anak mampu menunjukkan minat pada benda dengan bagian yang bergerak.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          RedleafItem(
            number: 10,
            title: 'Shows interest in playing games',
            target: 'Target: Anak mampu menunjukkan minat bermain permainan.',
            parentTips: ['Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.', 'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.', 'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.'],
          ),
          // ── Nine to Twelve Months (6 items) ──
          RedleafItem(
            number: 11,
            title: 'Responds to "no"',
            target: 'Target: Anak mampu merespons kata "tidak".',
            parentTips: ['Ajak anak bermain permainan edukatif yang merangsang berpikir (puzzle, tebak-tebakan, hitung benda).', 'Libatkan anak dalam aktivitas sehari-hari yang mengembangkan kemampuan kognitif (memasak, berkebun).', 'Berikan pertanyaan terbuka yang merangsang anak berpikir dan mengeksplorasi jawaban sendiri.'],
          ),
          RedleafItem(
            number: 12,
            title: 'Waves bye-bye',
            target: 'Target: Anak mampu melambaikan tangan da-da.',
            parentTips: ['Ajarkan isyarat sederhana (melambaikan tangan, menggeleng, mengangguk) dalam konteks sehari-hari.', 'Respons saat anak menunjuk benda dengan menyebutkan nama benda tersebut.', 'Gunakan gerakan tangan dan ekspresi wajah saat berbicara untuk memperkuat pemahaman bahasa.'],
          ),
          RedleafItem(
            number: 13,
            title: 'Shows understanding of object permanence (that is, knows objects exist when out of sight)',
            target: 'Target: Anak mampu menunjukkan pemahaman tentang ketetapan objek (tahu benda tetap ada meski tidak terlihat).',
            parentTips: ['Ajak anak bermain permainan edukatif yang merangsang berpikir (puzzle, tebak-tebakan, hitung benda).', 'Libatkan anak dalam aktivitas sehari-hari yang mengembangkan kemampuan kognitif (memasak, berkebun).', 'Berikan pertanyaan terbuka yang merangsang anak berpikir dan mengeksplorasi jawaban sendiri.'],
          ),
          RedleafItem(
            number: 14,
            title: 'Engages in more intentional play',
            target: 'Target: Anak mampu terlibat dalam permainan yang lebih terarah.',
            parentTips: ['Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.', 'Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.', 'Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama.'],
          ),
          RedleafItem(
            number: 15,
            title: 'Intentionally selects toys to play with',
            target: 'Target: Anak mampu secara sengaja memilih mainan untuk dimainkan.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          RedleafItem(
            number: 16,
            title: 'Shows understanding that objects have purpose',
            target: 'Target: Anak mampu menunjukkan pemahaman bahwa benda memiliki kegunaan.',
            parentTips: ['Ajak anak bermain permainan edukatif yang merangsang berpikir (puzzle, tebak-tebakan, hitung benda).', 'Libatkan anak dalam aktivitas sehari-hari yang mengembangkan kemampuan kognitif (memasak, berkebun).', 'Berikan pertanyaan terbuka yang merangsang anak berpikir dan mengeksplorasi jawaban sendiri.'],
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════
      // DOMAIN 5: Pendekatan Belajar (4 items)
      // ═══════════════════════════════════════════════════════
      RedleafDomain(
        id: 'pendekatan_belajar',
        name: 'Pendekatan Belajar',
        items: [
          // ── Birth to Six Months (1 item) ──
          RedleafItem(
            number: 1,
            title: 'Shows curiosity by exploring with senses',
            target: 'Target: Anak mampu menunjukkan rasa ingin tahu dengan mengeksplorasi melalui indra.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          // ── Six to Twelve Months (3 items) ──
          RedleafItem(
            number: 2,
            title: 'Shows persistence by repeating actions',
            target: 'Target: Anak mampu menunjukkan ketekunan dengan mengulangi tindakan.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan menyediakan beragam aktivitas eksplorasi yang aman.', 'Dampingi anak saat mencoba hal baru dan berikan dorongan untuk terus berusaha.', 'Ciptakan lingkungan belajar yang menyenangkan tanpa tekanan agar anak termotivasi belajar.'],
          ),
          RedleafItem(
            number: 3,
            title: 'Explores the environment actively, regardless of obstacles',
            target: 'Target: Anak mampu mengeksplorasi lingkungan secara aktif, terlepas dari hambatan.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).', 'Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.', 'Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya.'],
          ),
          RedleafItem(
            number: 4,
            title: 'Intentionally looks for and reaches for objects of interest',
            target: 'Target: Anak mampu secara sengaja mencari dan meraih benda yang menarik.',
            parentTips: ['Fasilitasi rasa ingin tahu anak dengan menyediakan beragam aktivitas eksplorasi yang aman.', 'Dampingi anak saat mencoba hal baru dan berikan dorongan untuk terus berusaha.', 'Ciptakan lingkungan belajar yang menyenangkan tanpa tekanan agar anak termotivasi belajar.'],
          ),
        ],
      ),
    ],
  ),

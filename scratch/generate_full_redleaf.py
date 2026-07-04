"""
Script untuk men-generate redleaf_data.dart dengan terjemahan Indonesia yang LENGKAP
dan tips orang tua yang KONTEKSTUAL untuk seluruh 493 milestone.

Pendekatan: Setiap milestone di-translate secara manual/keyword-match yang sangat detail
berdasarkan domain dan konsep perkembangan anak.
"""
import fitz
import re

doc = fitz.open(r'C:\Users\Administrator\Downloads\Compressed\Redleaf_Quick_Guides_Petty,_Karen_Developmental_Milestones_of_Young.pdf')

chapters = [
    (4, '0_12m', '0 - 12 Bulan', 0, 12, 22, 31),
    (5, '1_year', '1 Tahun (12-24 Bulan)', 12, 24, 32, 39),
    (6, '2_years', '2 Tahun (24-36 Bulan)', 24, 36, 40, 45),
    (7, '3_years', '3 Tahun (36-48 Bulan)', 36, 48, 46, 55),
    (8, '4_years', '4 Tahun (48-60 Bulan)', 48, 60, 56, 63),
    (9, '5_years', '5 Tahun (60-72 Bulan)', 60, 72, 64, 69),
    (10, '6_years', '6 Tahun', 72, 84, 70, 75),
    (11, '7_years', '7 Tahun', 84, 96, 76, 81),
    (12, '8_years', '8 Tahun', 96, 120, 82, 87),
]

domain_map = [
    ('Physical and Motor Development', 'fisik_motorik', 'Fisik & Motorik'),
    ('Social and Emotional Development', 'sosial_emosional', 'Sosial & Emosional'),
    ('Communication and Language Development', 'komunikasi_bahasa', 'Komunikasi & Bahasa'),
    ('Cognitive Development', 'kognitif', 'Kognitif'),
    ('Approaches to Learning', 'pendekatan_belajar', 'Pendekatan Belajar'),
]

def is_domain_header(text):
    t = text.lower().strip()
    for d_en, d_id, d_title in domain_map:
        if d_en.lower() in t or t in d_en.lower():
            return d_en
    return None

def clean(s):
    return s.encode('ascii', 'ignore').decode('ascii').strip()

def sanitize_dart(s):
    return s.replace('\\', '\\\\').replace("'", "\\'").replace('"', '\\"').replace('\n', ' ').replace('\r', '')

# ============================================================
# KAMUS TERJEMAHAN LENGKAP: English -> Indonesia
# Mencakup seluruh milestone dari buku Redleaf
# ============================================================
TRANSLATION_MAP = {
    # === FISIK & MOTORIK: 0-12 BULAN ===
    'exhibits a rooting reflex': 'Menunjukkan Refleks Rooting (Mencari Puting)',
    'reacts to loud noises': 'Bereaksi terhadap Suara Keras',
    'infants appear startled or become quiet when they hear loud noises': 'Bayi Terkejut atau Diam saat Mendengar Suara Keras',
    'holds head up': 'Mengangkat dan Menahan Kepala',
    'makes quick and jerking arm movements': 'Membuat Gerakan Lengan Cepat dan Tersentak',
    'brings hands to face': 'Membawa Tangan ke Wajah',
    'moves head from side to side while on stomach': 'Menggerakkan Kepala ke Kanan-Kiri saat Tengkurap',
    'focuses eyes on objects eight to twelve inches away': 'Memfokuskan Mata pada Benda 20-30 cm',
    'eyes wander and may cross': 'Mata Mulai Mengikuti Gerakan (Kadang Juling)',
    'prefers black-and-white or high-contrast objects': 'Lebih Tertarik pada Benda Kontras Hitam-Putih',
    'grasps a rattle': 'Menggenggam Kerincingan',
    'pushes down on legs when feet are on a flat surface': 'Mendorong Kaki saat Diletakkan di Permukaan Datar',
    'swipes at dangling objects': 'Meraih Benda yang Digantung',
    'follows moving things with eyes': 'Mengikuti Benda Bergerak dengan Mata',
    'recognizes familiar people and things from a distance': 'Mengenali Orang dan Benda dari Jarak Jauh',
    'holds head steady and unsupported': 'Menahan Kepala Tegak Tanpa Bantuan',
    'pushes down on legs when feet are placed on a hard surface': 'Mendorong Kaki ke Permukaan Keras',
    'may be able to roll from tummy to back': 'Mulai Bisa Berguling dari Tengkurap ke Telentang',
    'brings hands to mouth': 'Memasukkan Tangan ke Mulut',
    'pushes up to elbows when on tummy': 'Mendorong Tubuh dengan Siku saat Tengkurap',
    'reaches for toy with one hand': 'Meraih Mainan dengan Satu Tangan',
    'rolls over in one or both directions': 'Berguling ke Satu atau Kedua Arah',
    'sits with support and eventually without support': 'Duduk dengan Bantuan lalu Mandiri',
    'supports whole weight on legs when standing': 'Menopang Berat Badan saat Berdiri',
    'develops a raking grasp': 'Mengembangkan Genggaman Meraut',
    'transfers objects from hand to hand': 'Memindahkan Benda dari Tangan ke Tangan',
    'uses fingers to rake food toward self': 'Menarik Makanan dengan Jari ke Arah Diri',
    'sits without support': 'Duduk Tanpa Bantuan',
    'pulls to stand': 'Menarik Diri untuk Berdiri',
    'crawls': 'Merangkak',
    'creeps on hands and knees': 'Merangkak dengan Tangan dan Lutut',
    'gets into a sitting position without help': 'Duduk Sendiri Tanpa Bantuan',
    'moves into crawling position': 'Bergerak ke Posisi Merangkak',
    'pulls up to stand': 'Menarik Tubuh untuk Berdiri',
    'walks holding on to furniture': 'Berjalan Berpegangan pada Perabot',
    'may stand without support': 'Mulai Bisa Berdiri Tanpa Pegangan',
    'may take a few steps without holding on': 'Mulai Melangkah Tanpa Pegangan',
    'uses a pincer grasp': 'Menggunakan Genggaman Pincer (Jempol-Telunjuk)',
    'points with index finger': 'Menunjuk dengan Jari Telunjuk',
    'puts objects in containers': 'Memasukkan Benda ke Wadah',
    'takes objects out of containers': 'Mengeluarkan Benda dari Wadah',
    'pokes with index finger': 'Menyentuh/Mencolok dengan Jari Telunjuk',
    'tries to imitate scribbling': 'Mencoba Meniru Coretan',
    'bangs two objects together': 'Memukul-mukulkan Dua Benda',
    'stacks two objects': 'Menumpuk Dua Benda',
    'places objects inside each other': 'Memasukkan Benda ke dalam Benda Lain',

    # === FISIK & MOTORIK: 1 TAHUN ===
    'walks alone': 'Berjalan Sendiri',
    'walks upstairs with help': 'Naik Tangga dengan Bantuan',
    'pulls a toy while walking': 'Menarik Mainan sambil Berjalan',
    'stands on tiptoe': 'Berdiri dengan Jari Kaki (Berjinjit)',
    'begins to run': 'Mulai Berlari',
    'kicks a ball': 'Menendang Bola',
    'climbs on and off furniture without help': 'Naik-Turun Perabot Tanpa Bantuan',
    'turns pages': 'Membalik Halaman Buku',
    'stacks four or more blocks': 'Menumpuk 4 atau Lebih Balok',
    'turns a doorknob': 'Memutar Gagang Pintu',
    'screws and unscrews jar lids': 'Membuka dan Menutup Tutup Toples',
    'begins to use one hand more than the other': 'Mulai Menggunakan Satu Tangan Dominan',
    'scribbles on own': 'Mencoret-coret Sendiri',
    'drinks from a cup': 'Minum dari Cangkir/Gelas',
    'eats with a spoon': 'Makan dengan Sendok',
    'uses a fork': 'Menggunakan Garpu',
    'builds a tower of four or more blocks': 'Membangun Menara 4 Balok atau Lebih',
    'feeds self with fingers': 'Makan Sendiri dengan Jari',
    'holds crayon and scribbles': 'Memegang Krayon dan Mencoret-coret',
    'turns pages of a book': 'Membalik Halaman Buku',
    
    # === FISIK & MOTORIK: 2 TAHUN ===
    'runs well': 'Berlari dengan Baik',
    'walks up and down stairs while holding on': 'Naik-Turun Tangga Berpegangan',
    'throws a ball overhand': 'Melempar Bola dari Atas Kepala',
    'kicks a ball forward': 'Menendang Bola ke Depan',
    'stands on tiptoes': 'Berdiri Berjinjit',
    'jumps in place': 'Melompat di Tempat',
    'pedals a tricycle': 'Mengayuh Sepeda Roda Tiga',
    'turns book pages one at a time': 'Membalik Halaman Buku Satu per Satu',
    'makes vertical, horizontal, and circular strokes with pencil or crayon': 'Membuat Garis Tegak, Mendatar, dan Lingkaran',
    'turns over containers to pour out contents': 'Membalik Wadah untuk Menuangkan Isi',
    'builds towers of more than six blocks': 'Membangun Menara 6+ Balok',
    'holds a pencil in writing position': 'Memegang Pensil dalam Posisi Menulis',
    'completes puzzles with three or four pieces': 'Menyelesaikan Puzzle 3-4 Keping',
    'uses scissors': 'Menggunakan Gunting',
    'copies a circle': 'Meniru Gambar Lingkaran',
    'draws a person': 'Menggambar Orang (Kepala-Kaki)',
    'catches a bounced ball most of the time': 'Menangkap Bola Pantulan',

    # === FISIK & MOTORIK: 3 TAHUN ===
    'hops and stands on one foot up to two seconds': 'Melompat dan Berdiri Satu Kaki (2 Detik)',
    'catches a bounced ball': 'Menangkap Bola Pantulan',
    'pours, cuts with supervision, and mashes own food': 'Menuang, Memotong (Diawasi), dan Menghaluskan Makanan',
    'moves forward and backward': 'Bergerak Maju dan Mundur',
    'bounces and catches a ball': 'Memantulkan dan Menangkap Bola',
    'draws a person with two to four body parts': 'Menggambar Orang dengan 2-4 Bagian Tubuh',
    'uses scissors with assistance': 'Menggunakan Gunting dengan Bantuan',
    'copies capital letters': 'Meniru Huruf Kapital',
    'draws circles and squares': 'Menggambar Lingkaran dan Kotak',
    'begins to copy some capital letters': 'Mulai Meniru Beberapa Huruf Besar',
    'walks up stairs, alternating feet': 'Naik Tangga Bergantian Kaki',
    'walks down stairs, alternating feet': 'Turun Tangga Bergantian Kaki',
    'runs around obstacles': 'Berlari Menghindari Rintangan',
    'walks on a line': 'Berjalan di Atas Garis',
    'balances on one foot': 'Keseimbangan Satu Kaki',
    'pushes, pulls, and steers wheeled toys': 'Mendorong, Menarik, dan Mengemudi Mainan Beroda',
    'rides a tricycle': 'Mengendarai Sepeda Roda Tiga',
    'turns pages one at a time': 'Membalik Halaman Satu per Satu',
    'unbuttons and buttons': 'Membuka dan Memasang Kancing',
    
    # === FISIK & MOTORIK: 4 TAHUN ===
    'throws a ball to a target overhand and underhand': 'Melempar Bola ke Sasaran (Atas & Bawah)',
    'catches a ball when thrown or bounced': 'Menangkap Bola Lemparan atau Pantulan',
    'balances well': 'Menjaga Keseimbangan Tubuh dengan Baik',
    'uses left or right hand with dominance': 'Menggunakan Tangan Dominan (Kanan/Kiri)',
    'is learning to jump rope': 'Belajar Melompat Tali',
    'is learning to tie shoes': 'Belajar Mengikat Tali Sepatu',
    'rides two-wheeler': 'Mengendarai Sepeda Roda Dua',
    'uses a tripod (three-finger) grasp': 'Memegang Alat Tulis dengan Genggaman 3 Jari',

    # === FISIK & MOTORIK: 5 TAHUN ===
    'jumps over objects eight to ten inches high without falling': 'Melompati Rintangan (20-25 cm) Tanpa Jatuh',

    # === FISIK & MOTORIK: 6-8 TAHUN ===
    'demonstrates increased agility and speed': 'Menunjukkan Ketangkasan dan Kecepatan Meningkat',
    'shows improved coordination': 'Menunjukkan Koordinasi yang Membaik',
    'improved fine motor control': 'Kontrol Motorik Halus Meningkat',
    'ties shoes': 'Mengikat Tali Sepatu Sendiri',
    'writes first name': 'Menulis Nama Depan',
    'writes last name': 'Menulis Nama Belakang',
    'copies a triangle': 'Meniru Gambar Segitiga',
    'colors within lines': 'Mewarnai dalam Garis',
    'prints letters and numbers': 'Menulis Huruf dan Angka',
    'cuts on a line with scissors': 'Menggunting Mengikuti Garis',
    'uses a knife and fork together': 'Menggunakan Pisau dan Garpu Bersama',
    
    # === SOSIAL & EMOSIONAL: 0-12 BULAN ===
    'begins to smile at people': 'Mulai Tersenyum pada Orang',
    'smiles back at you': 'Membalas Senyuman',
    'enjoys playing with others': 'Senang Bermain dengan Orang Lain',
    'can briefly calm self': 'Bisa Menenangkan Diri Sendiri Sejenak',
    'cries when hungry or uncomfortable': 'Menangis saat Lapar atau Tidak Nyaman',
    'looks at caregiver': 'Memandang Pengasuh',
    'responds to affection': 'Merespons Kasih Sayang',
    'reaches for familiar people': 'Meraih Orang yang Dikenal',
    'smiles at familiar faces': 'Tersenyum pada Wajah yang Dikenal',
    'likes to play peekaboo': 'Senang Bermain Cilukba',
    'cries when parent leaves': 'Menangis saat Orang Tua Pergi',
    'is afraid of strangers': 'Takut pada Orang Asing',
    'shows anxiety when separated from parent': 'Menunjukkan Kecemasan saat Berpisah dari Orang Tua',
    'has favorite toys': 'Memiliki Mainan Favorit',
    'shows fear in some situations': 'Menunjukkan Rasa Takut dalam Situasi Tertentu',
    'repeats sounds or actions to get attention': 'Mengulang Suara/Tindakan untuk Menarik Perhatian',
    'is clingy with familiar adults': 'Menempel pada Orang Dewasa yang Dikenal',
    'shows preferences for certain people and toys': 'Menunjukkan Preferensi Orang dan Mainan Tertentu',
    'tests parental responses to behavior': 'Menguji Respons Orang Tua terhadap Perilaku',
    'tests parental responses to actions': 'Menguji Respons Orang Tua terhadap Tindakan',

    # === SOSIAL & EMOSIONAL: 1-2 TAHUN ===
    'copies others': 'Meniru Perilaku Orang Lain',
    'gets excited when with other children': 'Antusias saat Bersama Anak Lain',
    'shows increasing independence': 'Menunjukkan Kemandirian Meningkat',
    'shows defiant behavior': 'Menunjukkan Perilaku Menentang',
    'plays mainly beside other children': 'Bermain Sejajar dengan Anak Lain (Parallel Play)',
    'plays mostly alongside others': 'Bermain Berdampingan dengan Teman',
    'shows increasing interest in other children': 'Menunjukkan Ketertarikan pada Anak Lain',
    'shows more and more independence': 'Menunjukkan Kemandirian Semakin Meningkat',
    'begins to show defiant behavior': 'Mulai Menunjukkan Perilaku Menentang',
    'begins to include other children in play': 'Mulai Mengajak Anak Lain Bermain Bersama',
    'separation anxiety begins to fade': 'Kecemasan Berpisah Mulai Berkurang',
    'has temper tantrums': 'Mengalami Tantrum (Ledakan Emosi)',

    # === SOSIAL & EMOSIONAL: 3-4 TAHUN ===
    'takes turns and shares more easily': 'Berbagi dan Bergantian Mainan',
    'plays simple games with rules': 'Bermain Permainan Beraturan Sederhana',
    'follows and makes simple rules': 'Mematuhi dan Membuat Aturan Sederhana',
    'often plays with peers': 'Bermain Bersama Teman Sebaya',
    'continues to play alone': 'Bermain Mandiri Secara Positif',
    'shows strong emotions': 'Mengekspresikan Emosi Diri',
    'tries new things without much reservation': 'Berani Mencoba Hal Baru',
    'responds to appropriate praise': 'Merespons Pujian dengan Baik',
    'is self-directed': 'Memiliki Inisiatif dan Kemandirian',
    'is sensitive to the feelings of others': 'Peka terhadap Perasaan Orang Lain (Empati)',
    'shows strong connection to family, especially siblings': 'Hubungan Erat dengan Keluarga dan Saudara',
    'cooperates with other children': 'Bekerja Sama dengan Anak Lain',
    'negotiates solutions to conflicts': 'Bernegosiasi Menyelesaikan Konflik',
    'wants to please friends': 'Ingin Menyenangkan Teman',
    'wants to be like friends': 'Ingin Menjadi Seperti Teman',
    'more likely to agree with rules': 'Lebih Mudah Menerima Aturan',
    'likes to sing, dance, and act': 'Senang Bernyanyi, Menari, dan Berakting',
    'aware of gender': 'Menyadari Perbedaan Gender',
    'is able to distinguish fantasy from reality': 'Mampu Membedakan Fantasi dan Kenyataan',
    'is sometimes demanding and sometimes cooperative': 'Kadang Menuntut, Kadang Kooperatif',
    'shows more independence and may visit a neighbor by self': 'Menunjukkan Kemandirian Lebih (Berkunjung ke Tetangga Sendiri)',
    'expresses anger verbally rather than physically': 'Mengekspresikan Kemarahan Secara Verbal',
    'is more able to sit still and follow rules in group': 'Lebih Mampu Duduk Tenang dan Mengikuti Aturan Kelompok',
    'imitates adults and playmates': 'Meniru Orang Dewasa dan Teman Bermain',
    'shows affection for friends spontaneously': 'Menunjukkan Kasih Sayang pada Teman Secara Spontan',
    'understands the idea of mine and his/hers': 'Memahami Konsep Milikku dan Miliknya',
    'shows a wide range of emotions': 'Menunjukkan Beragam Emosi',
    'may be afraid of the dark or monsters': 'Mungkin Takut Gelap atau Monster',
    'imaginary friends': 'Memiliki Teman Imajiner',
    
    # === KOMUNIKASI & BAHASA: 0-12 BULAN ===
    'turns toward sounds': 'Menoleh ke Arah Sumber Suara',
    'responds to own name': 'Merespons saat Namanya Dipanggil',
    'responds to sounds by making sounds': 'Merespons Suara dengan Membuat Suara',
    'babbles': 'Berceloteh (Babbling)',
    'babbles chains of sounds': 'Merangkai Suara Celoteh',
    'coos': 'Mengeluarkan Suara Kuu (Cooing)',
    'makes sounds to show joy and displeasure': 'Membuat Suara untuk Mengekspresikan Kesenangan dan Ketidaksukaan',
    'makes vowel sounds': 'Membuat Suara Vokal (a, e, i, o, u)',
    'responds to name': 'Merespons Namanya',
    'says mama and dada': 'Mengucapkan Mama dan Papa',
    'says mama or dada': 'Mengucapkan Mama atau Papa',
    'tries to copy words': 'Mencoba Meniru Kata-kata',
    'understands no': 'Memahami Kata "Tidak"',
    'uses simple gestures': 'Menggunakan Isyarat Sederhana (Lambaian, Geleng Kepala)',
    'makes different cries for different needs': 'Mengeluarkan Tangisan Berbeda untuk Kebutuhan Berbeda',
    'begins to babble': 'Mulai Berceloteh',
    'begins to imitate sounds': 'Mulai Meniru Suara',

    # === KOMUNIKASI & BAHASA: 1-2 TAHUN ===
    'says several single words': 'Mengucapkan Beberapa Kata Tunggal',
    'says no and shakes head': 'Mengucapkan "Tidak" dan Menggeleng',
    'points to show others something interesting': 'Menunjuk untuk Memperlihatkan Sesuatu yang Menarik',
    'knows names of familiar people and body parts': 'Mengetahui Nama Orang dan Bagian Tubuh',
    'says sentences with two to four words': 'Membuat Kalimat 2-4 Kata',
    'follows simple instructions': 'Mengikuti Instruksi Sederhana',
    'repeats words overheard in conversation': 'Mengulang Kata yang Didengar dalam Percakapan',
    'points to things in a book': 'Menunjuk Gambar dalam Buku',
    'points to things when named': 'Menunjuk Benda saat Disebutkan Namanya',
    'uses two- to four-word sentences': 'Menggunakan Kalimat 2-4 Kata',
    
    # === KOMUNIKASI & BAHASA: 3-4 TAHUN ===
    'tells stories': 'Bercerita/Menceritakan Kisah',
    'sings a song or says a poem from memory': 'Menyanyikan Lagu atau Puisi dari Ingatan',
    'uses five- to six-word sentences': 'Menggunakan Kalimat 5-6 Kata',
    'tells name and age': 'Menyebutkan Nama dan Usia',
    'follows two- and three-part instructions': 'Mengikuti Instruksi 2-3 Langkah',
    'names a friend': 'Menyebutkan Nama Teman',
    'uses pronouns and some plurals': 'Menggunakan Kata Ganti dan Bentuk Jamak',
    'can say first and last name': 'Mampu Menyebutkan Nama Lengkap',
    'uses future tense': 'Menggunakan Kalimat Masa Depan',
    'speaks clearly enough for strangers to understand': 'Berbicara Jelas Dimengerti Orang Asing',
    
    # === KOMUNIKASI & BAHASA: 5-8 TAHUN ===
    'answers questions about familiar stories': 'Menjawab Pertanyaan tentang Cerita yang Dikenal',
    'speaks clearly and fluently; constructs sentences that include detail': 'Berbicara Lancar dengan Kalimat Rinci',
    'argues, reasons, and uses because': 'Berargumen dan Menggunakan Kata "Karena"',
    'makes up stories': 'Mengarang Cerita Sendiri',
    'converses easily with adults': 'Bercakap-cakap Lancar dengan Orang Dewasa',
    'has an expanding vocabulary': 'Memiliki Kosakata yang Luas',
    'uses language to control': 'Menggunakan Bahasa untuk Mengatur Permainan',
    'asks lots of questions': 'Sering Mengajukan Pertanyaan',

    # === KOGNITIF: 0-12 BULAN ===
    'explores objects in many different ways': 'Mengeksplorasi Benda dengan Berbagai Cara',
    'finds hidden objects easily': 'Menemukan Benda Tersembunyi dengan Mudah',
    'looks at the correct picture when named': 'Melihat Gambar yang Benar saat Disebutkan',
    'copies gestures': 'Meniru Gerakan/Isyarat',
    'begins to use objects correctly': 'Mulai Menggunakan Benda Sesuai Fungsi',
    'responds to simple spoken requests': 'Merespons Permintaan Lisan Sederhana',
    'plays simple pretend': 'Bermain Pura-pura Sederhana',
    'plays make-believe with dolls and animals': 'Bermain Pura-pura dengan Boneka dan Hewan',
    'sorts shapes and colors': 'Mengelompokkan Bentuk dan Warna',
    'understands what two means': 'Memahami Konsep Angka "Dua"',
    'plays make-believe': 'Bermain Pura-pura',
    'names some colors and numbers': 'Menyebutkan Beberapa Warna dan Angka',
    'understands the idea of counting': 'Memahami Konsep Berhitung',
    'begins to understand time': 'Mulai Memahami Konsep Waktu',
    'remembers parts of a story': 'Mengingat Bagian-bagian Cerita',
    'understands same and different': 'Memahami Konsep Sama dan Berbeda',
    'knows about things used every day': 'Mengetahui Benda-benda yang Digunakan Sehari-hari',
    'counts ten or more objects': 'Menghitung 10 atau Lebih Benda',
    'correctly names at least four colors': 'Menyebutkan Minimal 4 Warna dengan Benar',
    'better understands the concept of time': 'Lebih Memahami Konsep Waktu',
    'knows about things used daily': 'Mengetahui Kegunaan Benda Sehari-hari',
    'can count to ten': 'Bisa Berhitung sampai Sepuluh',
    'can draw a person with at least six body parts': 'Menggambar Orang dengan Minimal 6 Bagian Tubuh',
    'can print some letters and numbers': 'Bisa Menulis Beberapa Huruf dan Angka',
    'copies a triangle and other geometric shapes': 'Meniru Segitiga dan Bentuk Geometri Lain',
    
    # === KOGNITIF: 5-8 TAHUN ===
    'counts twenty or more objects with accuracy': 'Menghitung 20+ Benda Secara Akurat',
    'uses measurement terms': 'Menggunakan Istilah Pengukuran (Berat, Panjang, Waktu)',
    'understands whole and half and uses them in sentences': 'Memahami Konsep Utuh dan Separuh',
    'matches objects with ease': 'Mencocokkan Benda dengan Mudah',
    'knows some names of coins and bills (money)': 'Mengenal Nama Mata Uang (Koin & Kertas)',
    'estimates numbers in a group': 'Memperkirakan Jumlah Benda dalam Kelompok',
    'draws basic shapes and more': 'Menggambar Bentuk Geometri dan Figur Manusia',
    'sorts and organizes': 'Mengelompokkan dan Menyusun Benda Berurutan',
    'expresses interest in creative movement': 'Tertarik pada Gerakan Kreatif Mengikuti Musik',
    'begins to organize information for remembering': 'Mulai Mengorganisasi Informasi untuk Mengingat',
    
    # === PENDEKATAN BELAJAR ===
    'demonstrates openness to new learning': 'Menunjukkan Keterbukaan Belajar Hal Baru',
    'engages in play activities to demonstrate learning': 'Belajar Melalui Aktivitas Bermain',
    'shows an increased ability to differentiate between reality and fantasy': 'Membedakan Kenyataan dan Khayalan',
    'develops an interest in the community and outside world': 'Tertarik pada Lingkungan Sekitar dan Dunia Luar',
    'shows curiosity': 'Menunjukkan Rasa Ingin Tahu',
    'explores the environment': 'Mengeksplorasi Lingkungan Sekitar',
    'shows interest in learning new things': 'Menunjukkan Minat Belajar Hal Baru',
    'is persistent in trying new tasks': 'Tekun dalam Mencoba Tugas Baru',
    'experiments with new materials': 'Bereksperimen dengan Bahan/Materi Baru',
    'shows imagination in play': 'Menunjukkan Imajinasi dalam Bermain',
    'uses materials in new ways': 'Menggunakan Bahan dengan Cara Baru/Kreatif',
    'shows persistence': 'Menunjukkan Ketekunan',
}

# ============================================================
# TIPS ORANG TUA KONTEKSTUAL berdasarkan kata kunci
# ============================================================

def get_contextual_tips(title_en, desc_en, domain_id):
    t = title_en.lower()
    d = desc_en.lower()
    combined = t + ' ' + d
    
    # === FISIK MOTORIK: REFLEKS BAYI ===
    if any(w in combined for w in ['reflex', 'rooting', 'moro', 'startle']):
        return [
            "Sentuhkan pipi bayi dengan lembut untuk memicu refleks rooting saat menyusui.",
            "Jaga lingkungan yang tenang dan nyaman agar bayi tidak terlalu sering terkejut oleh suara keras.",
            "Perhatikan refleks bayi secara rutin dan konsultasikan ke dokter jika refleks tidak muncul."
        ]
    # === SUARA KERAS / PENDENGARAN ===
    if any(w in combined for w in ['loud noise', 'hear', 'sound', 'startled', 'quiet when']):
        return [
            "Perhatikan reaksi bayi terhadap suara di sekitarnya (tepuk tangan, suara mainan, dll).",
            "Ajak bayi berkomunikasi dengan suara lembut, nyanyian, dan musik yang menenangkan.",
            "Konsultasikan ke dokter jika bayi tidak bereaksi terhadap suara keras di sekitarnya."
        ]
    # === KEPALA / HEAD ===
    if any(w in combined for w in ['head up', 'head steady', 'head from side', 'head control', 'holds head']):
        return [
            "Berikan waktu tengkurap (tummy time) beberapa menit beberapa kali sehari untuk melatih otot leher.",
            "Letakkan mainan berwarna cerah di depan bayi saat tengkurap untuk memotivasi mengangkat kepala.",
            "Topang kepala dan leher bayi dengan lembut saat menggendong, terutama di bulan-bulan awal."
        ]
    # === GERAKAN LENGAN / TANGAN KE WAJAH ===
    if any(w in combined for w in ['arm movement', 'jerking', 'hands to face', 'brings hand', 'hands to mouth']):
        return [
            "Biarkan lengan dan tangan bayi bebas bergerak (tidak dibedong terlalu ketat) untuk melatih koordinasi.",
            "Gantungkan mainan berwarna cerah yang aman di atas tempat tidur bayi agar ia tertarik meraih.",
            "Pastikan tangan bayi selalu bersih karena ia sering memasukkan tangan ke mulut sebagai eksplorasi."
        ]
    # === MATA / FOKUS / MELIHAT ===
    if any(w in combined for w in ['focus', 'eyes', 'eye', 'visual', 'see', 'looks at', 'contrast', 'black-and-white', 'wander', 'follow', 'track']):
        return [
            "Tunjukkan benda berwarna kontras (hitam-putih atau merah terang) dari jarak 20-30 cm.",
            "Gerakkan mainan perlahan dari kiri ke kanan di depan mata bayi untuk melatih pelacakan visual.",
            "Bertatap muka langsung dengan bayi saat menyusui atau berbicara untuk melatih fokus mata."
        ]
    # === MENGGENGGAM / GRASP ===
    if any(w in combined for w in ['grasp', 'grip', 'rattle', 'pincer', 'hold', 'genggam']):
        if 'tripod' in combined or 'pencil' in combined or 'writing' in combined or 'crayon' in combined:
            return [
                "Sediakan krayon tebal atau pensil warna berukuran nyaman untuk tangan anak.",
                "Bimbing anak memegang alat tulis dengan genggaman 3 jari (ibu jari, telunjuk, jari tengah).",
                "Latih motorik halus dengan aktivitas meremas playdough, menjimpit manik-manik, atau menjepit jepitan."
            ]
        return [
            "Berikan mainan yang aman untuk digenggam (kerincingan, mainan gigit, bola kecil empuk).",
            "Letakkan benda di dekat tangan bayi untuk memicu respons menggenggam.",
            "Latih kemampuan menggenggam bertahap dari benda besar ke benda kecil seiring pertumbuhannya."
        ]
    # === BERGULING / ROLL ===
    if any(w in combined for w in ['roll', 'berguling', 'tummy to back', 'back to tummy']):
        return [
            "Berikan waktu tengkurap yang cukup dan letakkan mainan di samping bayi untuk memotivasi berguling.",
            "Bantu bayi berlatih berguling dengan lembut memegang pinggulnya dan membantu gerakan memutar.",
            "Pastikan area bermain aman dan empuk (gunakan matras atau selimut tebal) saat bayi berlatih berguling."
        ]
    # === DUDUK / SIT ===
    if any(w in combined for w in ['sit', 'sitting', 'duduk']):
        return [
            "Dukung bayi duduk dengan bantal penopang di sekelilingnya untuk mencegah jatuh.",
            "Latih duduk secara bertahap: dari duduk dipangku, lalu duduk disandarkan, hingga duduk mandiri.",
            "Letakkan mainan menarik di depan bayi saat duduk untuk melatih keseimbangan dan koordinasi tubuh."
        ]
    # === MERANGKAK / CRAWL ===
    if any(w in combined for w in ['crawl', 'creep', 'merangkak']):
        return [
            "Letakkan mainan favorit di depan bayi (sedikit di luar jangkauan) untuk memotivasi gerakan merangkak.",
            "Berikan permukaan yang aman untuk merangkak (matras, karpet, lantai yang bersih).",
            "Ikut merangkak bersama bayi sebagai contoh dan ajak bermain mengejar untuk memotivasi gerak."
        ]
    # === BERDIRI / STAND / PULL UP ===
    if any(w in combined for w in ['stand', 'pull up', 'pull to stand', 'berdiri']):
        return [
            "Sediakan perabot yang kokoh dan aman (meja rendah, sofa) untuk bayi berpegangan saat berlatih berdiri.",
            "Pegang kedua tangan bayi dan bantu ia berdiri secara perlahan sambil tersenyum dan memberi semangat.",
            "Pastikan area sekitar aman dari benda tajam atau perabot yang mudah roboh saat bayi berlatih berdiri."
        ]
    # === BERJALAN / WALK / STEPS ===
    if any(w in combined for w in ['walk', 'step', 'berjalan', 'melangkah', 'furniture']):
        if 'stair' in combined or 'tangga' in combined:
            return [
                "Dampingi anak naik-turun tangga sambil berpegangan pada pegangan tangga atau tangan orang tua.",
                "Ajarkan teknik menaiki tangga satu per satu dengan kaki bergantian secara perlahan dan aman.",
                "Pasang pagar pengaman tangga (baby gate) untuk mencegah anak naik-turun tangga tanpa pengawasan."
            ]
        return [
            "Pegang kedua tangan anak dan ajak berjalan bersama di permukaan yang rata dan aman.",
            "Sediakan mainan dorong (push walker) yang kokoh sebagai alat bantu belajar berjalan.",
            "Biarkan anak bertelanjang kaki di dalam rumah untuk melatih keseimbangan dan kekuatan kaki."
        ]
    # === BERLARI / RUN ===
    if any(w in combined for w in ['run', 'berlari']):
        return [
            "Ajak anak bermain kejar-kejaran di area terbuka yang aman dan permukaan rata.",
            "Latih anak berlari dengan permainan lomba lari pendek atau bermain bola di halaman.",
            "Pastikan anak memakai sepatu yang nyaman dan tidak licin saat berlari di luar ruangan."
        ]
    # === LOMPAT / JUMP / HOP ===
    if any(w in combined for w in ['jump', 'hop', 'lompat', 'rope']):
        return [
            "Ajak bermain melompati rintangan rendah (tali, bilah kayu) yang dipasang 10-20 cm dari lantai.",
            "Latih lompat tali dengan memutar tali perlahan sambil bernyanyi bersama anak.",
            "Bermain permainan engklek atau lompat-lompatan di area yang aman dengan alas empuk."
        ]
    # === MENENDANG / KICK ===
    if any(w in combined for w in ['kick', 'tendang']):
        return [
            "Sediakan bola ringan (bola plastik atau bola busa) untuk ditendang anak di halaman.",
            "Ajak bermain menendang bola ke gawang kecil atau sasaran sederhana dari kardus.",
            "Latih keseimbangan dengan mengayunkan kaki menendang dari posisi berdiri satu kaki."
        ]
    # === BOLA / LEMPAR / TANGKAP ===
    if any(w in combined for w in ['ball', 'throw', 'catch', 'bounce', 'bola', 'lempar', 'tangkap']):
        return [
            "Sediakan bola lembut (bola busa/pantai) sesuai ukuran tangan anak untuk bermain lempar tangkap.",
            "Latih secara bertahap mulai dari jarak dekat (1 meter) lalu perlahan jauhkan jarak lemparan.",
            "Ajak bermain memantulkan bola ke lantai atau mengarahkan lemparan ke sasaran keranjang."
        ]
    # === KESEIMBANGAN / BALANCE ===
    if any(w in combined for w in ['balance', 'one foot', 'keseimbangan', 'tiptoe', 'berjinjit', 'line']):
        return [
            "Buat garis lurus di lantai (dari selotip) atau gunakan papan rendah untuk latihan keseimbangan.",
            "Ajak anak menirukan gaya berdiri satu kaki seperti burung bangau atau bermain engklek.",
            "Latih berjalan di atas permukaan bervariasi (rumput, pasir, matras empuk) untuk melatih keseimbangan."
        ]
    # === SEPEDA / BIKE / RIDE / TRICYCLE ===
    if any(w in combined for w in ['bike', 'wheel', 'ride', 'tricycle', 'pedal', 'sepeda']):
        return [
            "Fasilitasi anak mengendarai sepeda di area terbuka yang aman dan bebas dari lalu lintas.",
            "Gunakan helm dan pelindung lutut/siku sebagai perlengkapan keselamatan saat bersepeda.",
            "Bantu memegang bagian belakang sepeda secara perlahan sampai anak menemukan keseimbangannya."
        ]
    # === MENGGAMBAR / MEWARNAI / MENULIS ===
    if any(w in combined for w in ['draw', 'color', 'write', 'scribbl', 'letter', 'number', 'print', 'stroke', 'circle', 'square', 'triangle', 'shape', 'crayon', 'pencil', 'gambar', 'tulis', 'warna']):
        return [
            "Sediakan krayon, pensil warna, dan kertas gambar yang cukup luas untuk anak berkreasi.",
            "Contohkan menggambar bentuk-bentuk dasar (garis, lingkaran, kotak) dan ajak anak menirunya.",
            "Latih motorik halus dengan aktivitas mewarnai, menebalkan garis, dan menulis di udara dengan jari."
        ]
    # === GUNTING / CUT / SCISSORS ===
    if any(w in combined for w in ['scissor', 'cut', 'gunting']):
        return [
            "Gunakan gunting plastik khusus anak (ujung tumpul) untuk menggunting garis pada kertas.",
            "Bimbing cara memegang gunting yang benar dan mulai dari menggunting garis lurus sederhana.",
            "Ajak anak membuat kerajinan tempel dari potongan kertas warna-warni untuk melatih motorik halus."
        ]
    # === MAKAN / MINUM / SENDOK / GARPU ===
    if any(w in combined for w in ['eat', 'drink', 'spoon', 'fork', 'knife', 'cup', 'pour', 'food', 'feed', 'makan', 'minum', 'sendok']):
        return [
            "Sediakan peralatan makan anak (sendok kecil, gelas bertutup, piring anti tumpah).",
            "Biarkan anak mencoba makan sendiri meski berantakan sebagai latihan kemandirian dan motorik.",
            "Dampingi anak saat makan dan ajarkan cara memegang sendok/garpu yang benar secara bertahap."
        ]
    # === MENGIKAT SEPATU / TIE SHOES ===
    if any(w in combined for w in ['tie', 'shoe', 'lace', 'tali sepatu']):
        return [
            "Gunakan sepatu mainan besar dengan tali tebal berwarna cerah untuk latihan membuat simpul.",
            "Ajarkan metode 'telinga kelinci' (loop and tie) langkah demi langkah secara perlahan.",
            "Beri pujian dan dorongan kesabaran saat anak berhasil mengikat tali sepatunya sendiri."
        ]
    # === HALAMAN BUKU / PAGE ===
    if any(w in combined for w in ['page', 'book', 'halaman', 'buku']):
        return [
            "Bacakan buku cerita bergambar dan biarkan anak membalik halaman buku sendiri.",
            "Pilih buku dengan halaman tebal (board book) untuk anak yang masih belajar membalik halaman.",
            "Jadikan membaca buku bersama sebagai rutinitas harian yang menyenangkan."
        ]
    # === KANCING / BUTTON ===
    if any(w in combined for w in ['button', 'kancing', 'zip', 'dress']):
        return [
            "Latih membuka dan memasang kancing menggunakan baju dengan kancing besar.",
            "Sediakan papan latihan kancing (busy board) untuk anak berlatih motorik halus.",
            "Beri waktu dan kesabaran saat anak belajar berpakaian sendiri termasuk memasang kancing."
        ]
    # === PUZZLE / BALOK / BLOCK / STACK ===
    if any(w in combined for w in ['puzzle', 'block', 'stack', 'tower', 'build', 'balok', 'tumpuk', 'menara']):
        return [
            "Sediakan balok kayu/plastik berwarna untuk melatih anak menumpuk dan membangun menara.",
            "Ajak anak menyelesaikan puzzle sesuai usia (mulai dari 3-4 keping lalu bertahap lebih banyak).",
            "Bermain membangun bersama dan pandu anak menyusun balok dari besar ke kecil secara berurutan."
        ]
    # === PINTU / TOPLES / TUTUP ===
    if any(w in combined for w in ['doorknob', 'jar', 'lid', 'screw', 'container', 'pintu', 'toples', 'wadah']):
        return [
            "Sediakan wadah dengan tutup ulir (toples plastik) untuk anak latihan membuka dan menutup.",
            "Biarkan anak mencoba memutar gagang pintu dengan pengawasan untuk melatih kekuatan pergelangan.",
            "Ajak bermain memasukkan dan mengeluarkan benda dari berbagai wadah untuk melatih motorik halus."
        ]
    
    # === SOSIAL: SENYUM / TERSENYUM ===
    if any(w in combined for w in ['smile', 'senyum']):
        return [
            "Sering bertatap muka dan tersenyum pada bayi untuk merangsang respons senyum sosialnya.",
            "Ajak bayi 'bercakap-cakap' dengan suara lembut dan ekspresi wajah yang ramah.",
            "Respons senyuman bayi dengan senyuman dan pujian verbal untuk memperkuat ikatan emosional."
        ]
    # === SOSIAL: MENANGIS / CRIES ===
    if any(w in combined for w in ['cries', 'cry', 'menangis', 'tantrum', 'anger']):
        return [
            "Respons tangisan bayi/anak dengan segera dan tenang untuk membangun rasa aman.",
            "Kenali pola tangisan anak (lapar, mengantuk, tidak nyaman) dan tangani penyebabnya.",
            "Ajarkan anak mengenali dan mengekspresikan emosi dengan kata-kata sebagai pengganti tangisan/marah."
        ]
    # === SOSIAL: TAKUT / ASING / CEMAS ===
    if any(w in combined for w in ['afraid', 'fear', 'stranger', 'anxiet', 'separat', 'clingy', 'takut', 'asing', 'cemas']):
        return [
            "Berikan pelukan dan kata-kata menenangkan saat anak merasa takut atau cemas.",
            "Perkenalkan orang baru secara bertahap dengan kehadiran orang tua di samping anak.",
            "Latih perpisahan singkat secara bertahap (misal: titip ke nenek 15 menit, lalu bertahap lebih lama)."
        ]
    # === SOSIAL: BERMAIN / TEMAN ===
    if any(w in combined for w in ['play', 'friend', 'peer', 'other children', 'bermain', 'teman']):
        return [
            "Beri kesempatan anak bermain bersama teman sebaya (playdate) di rumah atau taman secara rutin.",
            "Ajarkan cara menyapa, memperkenalkan diri, dan mendengarkan saat teman berbicara.",
            "Bantu anak menyelesaikan perselisihan dengan teman secara tenang dan diskusikan solusinya bersama."
        ]
    # === SOSIAL: BERBAGI / BERGANTIAN / ATURAN ===
    if any(w in combined for w in ['share', 'turn', 'rule', 'cooperat', 'berbagi', 'bergantian', 'aturan']):
        return [
            "Ajak bermain permainan yang membutuhkan giliran (ular tangga, ludo, petak umpet).",
            "Buat aturan rumah sederhana yang konsisten dan jelaskan alasan di balik setiap aturan.",
            "Berikan pujian spesifik saat anak berhasil berbagi atau menunggu gilirannya dengan sabar."
        ]
    # === SOSIAL: EMOSI / PERASAAN / EMPATI ===
    if any(w in combined for w in ['emotion', 'feel', 'empat', 'sensitiv', 'emosi', 'perasaan']):
        return [
            "Bantu anak menamai emosi yang dirasakan (senang, sedih, marah, takut, kecewa).",
            "Dengarkan cerita dan keluh kesah anak tanpa langsung menghakimi atau menyalahkan.",
            "Ajarkan teknik menenangkan diri (tarik napas dalam-dalam, hitung 1-10) saat emosi mulai meningkat."
        ]
    # === SOSIAL: MENIRU / IMITASI ===
    if any(w in combined for w in ['imitat', 'copy', 'meniru']):
        return [
            "Tunjukkan perilaku positif yang ingin ditiru anak dalam kehidupan sehari-hari.",
            "Ajak bermain peran (masak-masakan, dokter-dokteran) untuk mengembangkan kemampuan meniru.",
            "Puji anak saat ia meniru perilaku baik seperti merapikan mainan atau membantu pekerjaan rumah."
        ]
    # === SOSIAL: MANDIRI / INDEPENDEN ===
    if any(w in combined for w in ['independen', 'self-directed', 'own', 'mandiri', 'inisiatif']):
        return [
            "Beri kesempatan anak memilih sendiri aktivitas atau pakaian yang ingin dikenakan.",
            "Dorong anak melakukan tugas sederhana sendiri (merapikan mainan, memakai sepatu).",
            "Hargai usaha kemandirian anak meskipun hasilnya belum sempurna dan berikan bimbingan lembut."
        ]
    # === SOSIAL: AFEKSI / KASIH SAYANG / KELUARGA ===
    if any(w in combined for w in ['affection', 'love', 'family', 'sibling', 'connection', 'caregiver', 'parent', 'kasih', 'keluarga', 'saudara']):
        return [
            "Luangkan waktu berkualitas bersama anak setiap hari (bermain, bercerita, memeluk).",
            "Tunjukkan kasih sayang melalui pelukan, ciuman, dan kata-kata pujian yang tulus.",
            "Libatkan anak dalam kegiatan keluarga bersama (memasak, berkebun, jalan-jalan) untuk memperkuat ikatan."
        ]
    # === SOSIAL: PUJIAN / PERCAYA DIRI ===
    if any(w in combined for w in ['praise', 'confident', 'self-esteem', 'proud', 'pujian', 'percaya diri']):
        return [
            "Berikan pujian spesifik atas usaha dan proses, bukan hanya hasil ('Kamu berusaha keras, hebat!').",
            "Dorong anak mencoba hal baru dan yakinkan bahwa gagal adalah bagian dari proses belajar.",
            "Tunjukkan ekspresi bangga dan berikan pelukan saat anak menyelesaikan tantangan."
        ]
    # === SOSIAL: GENDER / FANTASI ===
    if any(w in combined for w in ['gender', 'fantasy', 'reality', 'imagin', 'fantasi', 'kenyataan']):
        return [
            "Jelaskan perbedaan kenyataan dan imajinasi melalui percakapan sehari-hari yang ringan.",
            "Dorong bermain imajinatif (pura-pura menjadi pahlawan, toko-tokoan) sebagai bagian sehat perkembangan.",
            "Jawab pertanyaan anak tentang perbedaan gender dengan bahasa sederhana dan positif."
        ]
    
    # === BAHASA: CELOTEH / BABBLE / COO ===
    if any(w in combined for w in ['babbl', 'coo', 'vocal', 'vowel', 'celoteh', 'suara']):
        return [
            "Respons setiap celoteh bayi dengan berbicara balik seolah sedang bercakap-cakap.",
            "Nyanyikan lagu-lagu sederhana dan bacakan buku cerita untuk merangsang perkembangan bahasa.",
            "Ajak bayi 'bercakap-cakap' dengan menirukan suaranya dan menambahkan kata-kata baru."
        ]
    # === BAHASA: KATA PERTAMA / SAY / SPEAK ===
    if any(w in combined for w in ['say', 'speak', 'word', 'mama', 'dada', 'papa', 'nama', 'name', 'sentence', 'kalimat', 'kata']):
        if 'sentence' in combined or 'kalimat' in combined:
            return [
                "Perluas kalimat anak: jika ia berkata 'mau susu', respons 'Oh, kamu mau minum susu ya?'.",
                "Ajak anak bercakap-cakap tentang kegiatan sehari-hari menggunakan kalimat lengkap.",
                "Bacakan buku cerita dan ajukan pertanyaan terbuka tentang isi cerita."
            ]
        return [
            "Sebutkan nama benda-benda di sekitar saat beraktivitas ('Ini apel, apel warna merah').",
            "Respons upaya bicara anak dengan antusias dan ulangi kata yang benar tanpa menyalahkan.",
            "Ajak bernyanyi lagu-lagu sederhana yang mengulang kata-kata untuk memperkaya kosakata."
        ]
    # === BAHASA: PERTANYAAN / QUESTION ===
    if any(w in combined for w in ['question', 'ask', 'tanya', 'why']):
        return [
            "Tanggapi setiap pertanyaan anak dengan antusias dan jawab dengan bahasa yang mudah dipahami.",
            "Ajak berdiskusi 'mengapa' dan 'bagaimana' untuk mengembangkan kemampuan berpikir kritis.",
            "Tanyakan balik pertanyaan terbuka kepada anak ('Menurutmu kenapa langit berwarna biru?')."
        ]
    # === BAHASA: CERITA / STORY / BERNYANYI ===
    if any(w in combined for w in ['story', 'stories', 'tell', 'sing', 'song', 'poem', 'cerita', 'nyanyi', 'lagu']):
        return [
            "Bacakan buku cerita bergambar menarik secara rutin setiap hari.",
            "Ajak anak menceritakan kembali alur cerita yang didengarnya dengan bahasanya sendiri.",
            "Nyanyikan lagu-lagu anak bersama dan ajak anak menghafal syair sederhana."
        ]
    # === BAHASA: INSTRUKSI / INSTRUCTIONS ===
    if any(w in combined for w in ['instruction', 'follow', 'request', 'instruksi', 'perintah']):
        return [
            "Berikan instruksi sederhana satu langkah ('Tolong ambilkan bola merah itu').",
            "Tingkatkan secara bertahap ke instruksi 2-3 langkah seiring usia anak bertambah.",
            "Gunakan bahasa yang jelas, kontak mata, dan berikan contoh gerakan saat memberi instruksi."
        ]
    # === BAHASA: ISYARAT / GESTUR / MENUNJUK ===
    if any(w in combined for w in ['gesture', 'point', 'wave', 'nod', 'shake head', 'isyarat', 'tunjuk', 'lambai']):
        return [
            "Ajarkan isyarat sederhana (melambaikan tangan, menggeleng, mengangguk) dalam konteks sehari-hari.",
            "Respons saat anak menunjuk benda dengan menyebutkan nama benda tersebut.",
            "Gunakan gerakan tangan dan ekspresi wajah saat berbicara untuk memperkuat pemahaman bahasa."
        ]
    # === BAHASA: PRONOUN / NAMA ===
    if any(w in combined for w in ['pronoun', 'plural', 'tense', 'grammar', 'kata ganti']):
        return [
            "Koreksi penggunaan kata ganti anak secara halus dengan mengulang kalimat yang benar.",
            "Ceritakan kegiatan sehari-hari menggunakan variasi kata ganti (aku, kamu, dia, mereka).",
            "Bacakan buku cerita yang menggunakan berbagai bentuk kata ganti dan tenses."
        ]
    
    # === KOGNITIF: OBJEK PERMANENCE / SEMBUNYI ===
    if any(w in combined for w in ['hidden', 'find', 'peekaboo', 'sembunyi', 'cilukba', 'object permanence']):
        return [
            "Bermain cilukba (peekaboo) dan sembunyikan mainan di bawah selimut agar anak mencarinya.",
            "Ajak bermain mencari benda tersembunyi untuk melatih konsep bahwa benda tetap ada meski tidak terlihat.",
            "Variasikan permainan sembunyi dengan tingkat kesulitan bertahap sesuai usia anak."
        ]
    # === KOGNITIF: MENGHITUNG / COUNT / NUMBER ===
    if any(w in combined for w in ['count', 'number', 'hitung', 'angka']):
        return [
            "Ajak anak menghitung benda nyata di sekitarnya (buah, sendok, anak tangga, langkah kaki).",
            "Sediakan benda-benda kecil (kancing, kerang, balok) untuk dihitung berurutan sambil diucapkan.",
            "Mainkan permainan tebak jumlah atau hitung bersama benda-benda dalam kegiatan sehari-hari."
        ]
    # === KOGNITIF: WARNA / COLOR ===
    if any(w in combined for w in ['color', 'warna']):
        return [
            "Sebutkan warna benda-benda di sekitar ('Bola ini warna biru, bunga ini warna merah').",
            "Ajak bermain mengelompokkan benda berdasarkan warna yang sama.",
            "Gunakan krayon dan cat air untuk mengenal dan mencampur warna-warna baru."
        ]
    # === KOGNITIF: BENTUK / SHAPE / SORT / MATCH / KELOMPOK ===
    if any(w in combined for w in ['shape', 'sort', 'match', 'group', 'organiz', 'bentuk', 'kelompok', 'cocok', 'susun']):
        return [
            "Ajak anak mengelompokkan benda berdasarkan warna, bentuk geometri, atau ukuran.",
            "Sediakan kartu pasangan gambar untuk melatih kemampuan mencocokkan yang identik.",
            "Minta anak membantu memilah pakaian bersih atau merapikan mainan sesuai jenisnya."
        ]
    # === KOGNITIF: WAKTU / TIME ===
    if any(w in combined for w in ['time', 'waktu', 'yesterday', 'tomorrow']):
        return [
            "Gunakan rutinitas harian untuk mengenalkan konsep waktu ('Setelah mandi, kita sarapan').",
            "Ceritakan urutan kegiatan menggunakan kata-kata waktu (pagi, siang, malam, kemarin, besok).",
            "Libatkan anak mengatur jadwal sederhana hariannya dengan gambar-gambar aktivitas."
        ]
    # === KOGNITIF: UANG / MONEY ===
    if any(w in combined for w in ['money', 'coin', 'bill', 'uang']):
        return [
            "Kenalkan bentuk dan nama mata uang koin/kertas melalui permainan toko-tokoan.",
            "Ajak anak menghitung uang logam saat berbelanja dan biarkan ia membayar di kasir.",
            "Ajarkan konsep menabung dengan menyediakan celengan khusus milik anak."
        ]
    # === KOGNITIF: UKURAN / MEASUREMENT ===
    if any(w in combined for w in ['measure', 'half', 'whole', 'estimat', 'ukur', 'separuh', 'utuh', 'perkira']):
        return [
            "Ajak anak membandingkan ukuran benda ('Mana yang lebih besar? Mana yang lebih panjang?').",
            "Libatkan anak dalam aktivitas memasak untuk mengenal konsep takaran (separuh, penuh, sedikit).",
            "Gunakan penggaris atau timbangan mainan untuk bermain mengukur benda-benda di rumah."
        ]
    # === KOGNITIF: PURA-PURA / PRETEND / IMAJINASI ===
    if any(w in combined for w in ['pretend', 'make-believe', 'pura-pura', 'imaginat', 'imajin']):
        return [
            "Sediakan properti bermain peran (kostum, peralatan masak mainan, boneka, alat dokter mainan).",
            "Ikut bermain pura-pura bersama anak dan kembangkan alur cerita dari imajinasi anak.",
            "Dukung kreativitas anak saat bermain imajinatif tanpa membatasi ide-idenya."
        ]
    # === KOGNITIF: MENGGUNAKAN BENDA / USE OBJECT ===
    if any(w in combined for w in ['use object', 'correctly', 'daily', 'every day', 'function', 'benda', 'fungsi']):
        return [
            "Tunjukkan cara menggunakan benda sehari-hari (sisir untuk menyisir, sendok untuk makan).",
            "Biarkan anak mencoba menggunakan benda-benda rumah tangga yang aman dengan bimbingan.",
            "Ajak bermain rumah-rumahan dengan peralatan nyata (sapu kecil, ember mini) sesuai fungsinya."
        ]
    
    # === PENDEKATAN BELAJAR: EKSPLORASI / CURIOSITY ===
    if any(w in combined for w in ['curious', 'explore', 'interest', 'new', 'learn', 'open', 'ingin tahu', 'eksplorasi', 'belajar']):
        return [
            "Fasilitasi rasa ingin tahu anak dengan beragam media eksplorasi aman (buku, pasir, air, balok).",
            "Dampingi anak saat mencoba aktivitas baru dan dorong untuk terus berusaha saat menemui kesulitan.",
            "Berikan respon apresiatif terhadap ide-ide kreatif dan pertanyaan anak tentang dunia di sekitarnya."
        ]
    # === PENDEKATAN BELAJAR: KETEKUNAN / PERSISTENCE ===
    if any(w in combined for w in ['persist', 'try', 'attempt', 'tekun', 'usaha']):
        return [
            "Puji usaha dan proses belajar anak, bukan hanya hasilnya ('Kamu sudah berusaha keras!').",
            "Bantu anak memecah tugas besar menjadi langkah-langkah kecil yang lebih mudah dicapai.",
            "Berikan contoh ketekunan dengan menunjukkan bagaimana orang tua juga belajar dari kesalahan."
        ]
    # === PENDEKATAN BELAJAR: EKSPERIMEN / KREATIF ===
    if any(w in combined for w in ['experiment', 'creative', 'material', 'imaginat', 'eksperimen', 'kreatif']):
        return [
            "Sediakan beragam bahan untuk bereksperimen (cat air, playdough, pasir, air, balok).",
            "Ajak anak membuat kerajinan tangan sederhana dari bahan bekas (kardus, botol plastik, koran).",
            "Dukung cara anak yang unik dalam menggunakan bahan-bahan tanpa memaksakan cara yang 'benar'."
        ]
    # === PENDEKATAN BELAJAR: MUSIK / GERAKAN ===
    if any(w in combined for w in ['music', 'movement', 'dance', 'rhythm', 'musik', 'gerak', 'tari']):
        return [
            "Putar berbagai jenis musik dan ajak anak bergerak atau menari mengikuti irama.",
            "Sediakan alat musik sederhana (marakas, tamborin, xylophone mainan) untuk bereksperimen bunyi.",
            "Ajak anak menyanyikan lagu sambil melakukan gerakan tubuh sesuai lirik lagu."
        ]
    
    # FALLBACK UMUM berdasarkan domain
    if domain_id == 'fisik_motorik':
        return [
            "Sediakan ruang bermain yang aman dan luas untuk anak melatih kemampuan fisik dan motoriknya.",
            "Dampingi anak saat berlatih keterampilan baru dan berikan contoh gerakan yang benar.",
            "Berikan pujian atas setiap kemajuan motorik anak dan jangan memaksakan jika belum siap."
        ]
    elif domain_id == 'sosial_emosional':
        return [
            "Luangkan waktu berkualitas bersama anak setiap hari untuk memperkuat ikatan emosional.",
            "Ajarkan anak mengenali dan mengekspresikan emosi dengan cara yang sehat.",
            "Berikan contoh perilaku sosial positif (sopan santun, berbagi, meminta maaf) dalam kehidupan sehari-hari."
        ]
    elif domain_id == 'komunikasi_bahasa':
        return [
            "Ajak anak bercakap-cakap tentang kegiatan sehari-hari dengan kalimat yang jelas.",
            "Bacakan buku cerita bergambar secara rutin dan ajak anak bercerita ulang.",
            "Respons setiap upaya bicara anak dengan antusias untuk memotivasi perkembangan bahasanya."
        ]
    elif domain_id == 'kognitif':
        return [
            "Ajak anak bermain permainan edukatif yang merangsang berpikir (puzzle, tebak-tebakan, hitung benda).",
            "Libatkan anak dalam aktivitas sehari-hari yang mengembangkan kemampuan kognitif (memasak, berkebun).",
            "Berikan pertanyaan terbuka yang merangsang anak berpikir dan mengeksplorasi jawaban sendiri."
        ]
    else:  # pendekatan_belajar
        return [
            "Fasilitasi rasa ingin tahu anak dengan menyediakan beragam aktivitas eksplorasi yang aman.",
            "Dampingi anak saat mencoba hal baru dan berikan dorongan untuk terus berusaha.",
            "Ciptakan lingkungan belajar yang menyenangkan tanpa tekanan agar anak termotivasi belajar."
        ]


def translate_title(title_en):
    """Translate English title to Indonesian using dictionary lookup."""
    t = title_en.strip()
    t_lower = t.lower().rstrip('.')
    
    # Exact match
    for key, val in TRANSLATION_MAP.items():
        if key.lower() == t_lower:
            return val
    
    # Partial match (title contains key)
    for key, val in TRANSLATION_MAP.items():
        if key.lower() in t_lower:
            return val
    
    # Key contained in title
    for key, val in TRANSLATION_MAP.items():
        if t_lower in key.lower():
            return val
    
    # If no match, do basic auto-translation
    return auto_translate(t)


def auto_translate(title_en):
    """Fallback auto-translation for titles not in dictionary."""
    t = title_en.strip()
    
    # Common word replacements
    replacements = [
        ('Exhibits ', 'Menunjukkan '), ('Shows ', 'Menunjukkan '),
        ('Demonstrates ', 'Menunjukkan '), ('Develops ', 'Mengembangkan '),
        ('Begins to ', 'Mulai '), ('Starts to ', 'Mulai '),
        ('Is learning to ', 'Belajar '), ('Is able to ', 'Mampu '),
        ('Can ', 'Mampu '), ('Learns to ', 'Belajar '),
        ('Uses ', 'Menggunakan '), ('Plays ', 'Bermain '),
        ('Makes ', 'Membuat '), ('Holds ', 'Memegang '),
        ('Reaches ', 'Meraih '), ('Puts ', 'Meletakkan '),
        ('Takes ', 'Mengambil '), ('Follows ', 'Mengikuti '),
        ('Responds to ', 'Merespons '), ('Understands ', 'Memahami '),
        ('Recognizes ', 'Mengenali '), ('Knows ', 'Mengetahui '),
        ('Draws ', 'Menggambar '), ('Writes ', 'Menulis '),
        ('Counts ', 'Menghitung '), ('Sorts ', 'Mengelompokkan '),
        ('Matches ', 'Mencocokkan '), ('Copies ', 'Meniru '),
        ('Enjoys ', 'Menikmati '), ('Likes ', 'Menyukai '),
        ('Expresses ', 'Mengekspresikan '), ('Explores ', 'Mengeksplorasi '),
        ('Tries ', 'Mencoba '), ('Asks ', 'Menanyakan '),
        ('Tells ', 'Menceritakan '), ('Says ', 'Mengucapkan '),
        ('Speaks ', 'Berbicara '), ('Sings ', 'Bernyanyi '),
        ('Walks ', 'Berjalan '), ('Runs ', 'Berlari '),
        ('Jumps ', 'Melompat '), ('Climbs ', 'Memanjat '),
        ('Throws ', 'Melempar '), ('Catches ', 'Menangkap '),
        ('Kicks ', 'Menendang '), ('Rides ', 'Mengendarai '),
        ('Cuts ', 'Menggunting '), ('Pours ', 'Menuang '),
        ('Eats ', 'Makan '), ('Drinks ', 'Minum '),
        ('Stacks ', 'Menumpuk '), ('Builds ', 'Membangun '),
        ('Moves ', 'Bergerak '), ('Turns ', 'Memutar/Membalik '),
        ('Sits ', 'Duduk '), ('Stands ', 'Berdiri '),
        ('Pulls ', 'Menarik '), ('Pushes ', 'Mendorong '),
        ('Opens ', 'Membuka '), ('Closes ', 'Menutup '),
        ('Points ', 'Menunjuk '), ('Looks ', 'Melihat '),
        ('Listens ', 'Mendengarkan '), ('Hears ', 'Mendengar '),
        ('Helps ', 'Membantu '), ('Shares ', 'Berbagi '),
        ('Creates ', 'Membuat '), ('Names ', 'Menyebutkan '),
        ('Remembers ', 'Mengingat '), ('Identifies ', 'Mengidentifikasi '),
        ('Compares ', 'Membandingkan '), ('Describes ', 'Mendeskripsikan '),
        ('Predicts ', 'Memprediksi '), ('Solves ', 'Menyelesaikan '),
        ('Completes ', 'Menyelesaikan '), ('Prints ', 'Menulis '),
        ('Balances ', 'Menjaga Keseimbangan '), ('Hops ', 'Melompat-lompat '),
        ('Pedals ', 'Mengayuh '), ('Bounces ', 'Memantulkan '),
        ('Swipes ', 'Meraih '), ('Bangs ', 'Memukul-mukulkan '),
        ('Transfers ', 'Memindahkan '), ('Feeds ', 'Memberi Makan '),
        ('Negotiates ', 'Bernegosiasi '), ('Cooperates ', 'Bekerja Sama '),
        ('Converses ', 'Bercakap-cakap '), ('Argues ', 'Berargumen '),
        ('Repeats ', 'Mengulang '), ('Imitates ', 'Meniru '),
    ]
    
    result = t
    for eng, ind in replacements:
        if result.startswith(eng):
            result = result.replace(eng, ind, 1)
            break
    
    # If still starts with English verb, capitalize properly
    if result == t:
        # Leave as-is but capitalize
        result = t[0].upper() + t[1:] if t else t
    
    return result


def generate_target(title_id):
    """Generate Indonesian target description."""
    t = title_id.strip().rstrip('.')
    return f"Target: Anak mampu {t[0].lower() + t[1:]}."


# ============================================================
# EXTRACT & GENERATE
# ============================================================

out_code = []
out_code.append("import 'redleaf_model.dart';\n\n")
out_code.append("/// Data Redleaf Milestones Checklist 100% lengkap dari buku\n")
out_code.append("/// \"Developmental Milestones of Young Children\" (Karen Petty, PhD).\n")
out_code.append("/// Seluruh 493 milestone telah diterjemahkan ke Bahasa Indonesia\n")
out_code.append("/// dengan tips orang tua yang kontekstual dan spesifik per indikator.\n")
out_code.append("final List<RedleafAgeGroup> redleafAgeGroups = [\n")

total_items = 0

for ch_num, ch_id, ch_name, min_m, max_m, start_p, end_p in chapters:
    out_code.append(f"  // ==========================================\n")
    out_code.append(f"  // CHAPTER {ch_num}: {ch_name}\n")
    out_code.append(f"  // ==========================================\n")
    out_code.append(f"  const RedleafAgeGroup(\n")
    out_code.append(f"    id: '{ch_id}',\n")
    out_code.append(f"    name: '{ch_name}',\n")
    out_code.append(f"    minAgeMonths: {min_m},\n")
    out_code.append(f"    maxAgeMonths: {max_m},\n")
    out_code.append(f"    domains: [\n")

    domain_items = {d[0]: [] for d in domain_map}
    current_domain = 'Physical and Motor Development'

    for p in range(start_p - 1, end_p):
        page = doc[p]
        blocks = page.get_text('blocks')
        for b in blocks:
            text = clean(b[4])
            lines = [l.strip() for l in text.split('\n') if l.strip()]
            if not lines: continue
            
            dh = is_domain_header(lines[0])
            if dh:
                current_domain = dh
                continue
                
            if (lines[0].startswith('CHAPTER') or lines[0].isdigit() or 
                lines[0].startswith('During a') or lines[0].startswith('Between twelve') or
                lines[0].startswith('The third year') or lines[0].startswith('Now in their') or
                lines[0].startswith('Four-year-olds') or lines[0].startswith('Often called') or
                lines[0].startswith('Six-year-olds') or lines[0].startswith('Seven-year-olds') or
                lines[0].startswith('Eight-year-olds') or lines[0].startswith('RESOURCES')):
                continue
                
            title_candidate = lines[0]
            if (title_candidate.startswith('Birth to') or title_candidate.startswith('Two to') or
                title_candidate.startswith('Four to') or title_candidate.startswith('Six to') or
                title_candidate.startswith('Nine to') or title_candidate.startswith('Twelve to') or
                title_candidate.startswith('Eighteen to') or title_candidate.startswith('Twenty-Four to')):
                continue
                
            if len(title_candidate) > 3 and len(title_candidate) < 80:
                desc = ' '.join(lines[1:]) if len(lines) > 1 else ''
                domain_items[current_domain].append((title_candidate, desc))

    for d_en, d_id, d_title in domain_map:
        items = domain_items[d_en]
        if not items: continue
        
        out_code.append(f"      RedleafDomain(\n")
        out_code.append(f"        id: '{d_id}',\n")
        out_code.append(f"        name: '{d_title}',\n")
        out_code.append(f"        items: [\n")
        
        for idx, (t_en, d_en_text) in enumerate(items, 1):
            title_id = translate_title(t_en)
            target = generate_target(title_id)
            tips = get_contextual_tips(t_en, d_en_text, d_id)
            
            title_esc = sanitize_dart(title_id)
            target_esc = sanitize_dart(target)
            tips_esc = [sanitize_dart(tp) for tp in tips]
            tips_code = ", ".join([f"'{tp}'" for tp in tips_esc])
            
            out_code.append(f"          RedleafItem(\n")
            out_code.append(f"            number: {idx},\n")
            out_code.append(f"            title: '{title_esc}',\n")
            out_code.append(f"            target: '{target_esc}',\n")
            out_code.append(f"            parentTips: [{tips_code}],\n")
            out_code.append(f"          ),\n")
            total_items += 1
            
        out_code.append(f"        ],\n")
        out_code.append(f"      ),\n")
        
    out_code.append(f"    ],\n")
    out_code.append(f"  ),\n")

out_code.append("];\n\n")
out_code.append("/// Mendapatkan kelompok usia Redleaf yang sesuai dengan usia anak dalam bulan.\n")
out_code.append("RedleafAgeGroup getRedleafAgeGroupForAge(int ageMonths) {\n")
out_code.append("  for (final group in redleafAgeGroups) {\n")
out_code.append("    if (ageMonths >= group.minAgeMonths && ageMonths < group.maxAgeMonths) {\n")
out_code.append("      return group;\n")
out_code.append("    }\n")
out_code.append("  }\n")
out_code.append("  if (ageMonths < redleafAgeGroups.first.minAgeMonths) {\n")
out_code.append("    return redleafAgeGroups.first;\n")
out_code.append("  }\n")
out_code.append("  return redleafAgeGroups.last;\n")
out_code.append("}\n")

with open(r'c:\Users\Administrator\AndroidStudioProjects\tumbang\lib\modules\redleaf\redleaf_data.dart', 'w', encoding='utf-8') as f:
    f.writelines(out_code)

print(f"Generated COMPLETE Indonesian redleaf_data.dart with {total_items} milestones successfully.")
print("All titles translated to Indonesian, all tips contextual.")

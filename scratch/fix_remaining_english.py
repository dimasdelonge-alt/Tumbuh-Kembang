"""
Post-processing: Fix all remaining English titles and targets in redleaf_data.dart
by applying comprehensive word-by-word translation.
"""
import re

# Comprehensive English-to-Indonesian word/phrase dictionary
WORD_MAP = [
    # Phrases first (longest match first)
    ('lying on back', 'telentang'),
    ('lying on stomach', 'tengkurap'),
    ('face down', 'wajah menghadap bawah'),
    ('on back', 'saat telentang'),
    ('on stomach', 'saat tengkurap'),
    ('on tummy', 'saat tengkurap'),
    ('tummy time', 'waktu tengkurap'),
    ('side to side', 'ke kiri dan kanan'),
    ('from one hand to another', 'dari satu tangan ke tangan lain'),
    ('one to two seconds', '1-2 detik'),
    ('two to four', '2-4'),
    ('three to four', '3-4'),
    ('four or more', '4 atau lebih'),
    ('six or more', '6 atau lebih'),
    ('eight to twelve inches', '20-30 cm'),
    ('eight to ten inches', '20-25 cm'),
    ('back and forth', 'bolak-balik'),
    ('at will', 'secara mandiri'),
    ('eye contact', 'kontak mata'),
    ('from a distance', 'dari jarak jauh'),
    ('from prone', 'dari posisi tengkurap'),
    ('from supine', 'dari posisi telentang'),
    ('at first', 'pada awalnya'),
    ('at this age', 'pada usia ini'),
    ('with support', 'dengan bantuan'),
    ('without support', 'tanpa bantuan'),
    ('without help', 'tanpa bantuan'),
    ('no head bobbing', 'tanpa kepala bergoyang'),
    ('firm surface', 'permukaan keras'),
    ('flat surface', 'permukaan datar'),
    ('hard surface', 'permukaan keras'),
    ('familiar faces', 'wajah yang dikenal'),
    ('familiar voices', 'suara yang dikenal'),
    ('familiar people', 'orang yang dikenal'),
    ('familiar objects', 'benda yang dikenal'),
    ('familiar adults', 'orang dewasa yang dikenal'),
    ('unfamiliar faces', 'wajah asing'),
    ('body parts', 'bagian tubuh'),
    ('high-contrast', 'kontras tinggi'),
    ('black-and-white', 'hitam-putih'),
    ('make-believe', 'pura-pura'),
    ('self-directed', 'mandiri dan berinisiatif'),
    ('index finger', 'jari telunjuk'),
    ('one hand', 'satu tangan'),
    ('both hands', 'kedua tangan'),
    ('each hand', 'masing-masing tangan'),
    ('both sides', 'kedua sisi'),
    ('both directions', 'kedua arah'),
    ('one foot', 'satu kaki'),
    ('both feet', 'kedua kaki'),
    ('two feet', 'dua kaki'),
    ('older children', 'anak yang lebih besar'),
    ('other children', 'anak lain'),
    ('their caregivers', 'pengasuhnya'),
    ('their caregiver', 'pengasuhnya'),
    ('the caregiver', 'pengasuh'),
    ('a caregiver', 'pengasuh'),
    ('caregivers', 'pengasuh'),
    ('caregiver', 'pengasuh'),
    ('new textures', 'tekstur baru'),
    ('new learning', 'pembelajaran baru'),
    ('new things', 'hal baru'),
    ('new tasks', 'tugas baru'),
    ('new materials', 'bahan/materi baru'),
    ('new situations', 'situasi baru'),
    ('rocking chair', 'kursi goyang'),
    ('head steady', 'kepala tegak'),
    ('head up', 'mengangkat kepala'),
    ('head off', 'mengangkat kepala dari'),
    ('off surface', 'dari permukaan'),
    ('chest up', 'dada terangkat'),
    ('weight on', 'berat pada'),
    ('to midline', 'ke garis tengah tubuh'),
    ('to mouth', 'ke mulut'),
    ('to face', 'ke wajah'),
]

# Single word translations
SINGLE_WORDS = {
    'exhibits': 'menunjukkan', 'shows': 'menunjukkan', 'demonstrates': 'menunjukkan',
    'develops': 'mengembangkan', 'begins': 'mulai', 'starts': 'mulai',
    'attempts': 'mencoba', 'tries': 'mencoba', 'learns': 'belajar',
    'uses': 'menggunakan', 'plays': 'bermain', 'makes': 'membuat',
    'holds': 'memegang', 'reaches': 'meraih', 'puts': 'meletakkan',
    'takes': 'mengambil', 'follows': 'mengikuti', 'responds': 'merespons',
    'understands': 'memahami', 'recognizes': 'mengenali', 'knows': 'mengetahui',
    'draws': 'menggambar', 'writes': 'menulis', 'counts': 'menghitung',
    'sorts': 'mengelompokkan', 'matches': 'mencocokkan', 'copies': 'meniru',
    'enjoys': 'menikmati', 'likes': 'menyukai', 'loves': 'menyukai',
    'expresses': 'mengekspresikan', 'explores': 'mengeksplorasi',
    'asks': 'menanyakan', 'tells': 'menceritakan', 'says': 'mengucapkan',
    'speaks': 'berbicara', 'sings': 'bernyanyi', 'walks': 'berjalan',
    'runs': 'berlari', 'jumps': 'melompat', 'climbs': 'memanjat',
    'throws': 'melempar', 'catches': 'menangkap', 'kicks': 'menendang',
    'rides': 'mengendarai', 'cuts': 'menggunting', 'pours': 'menuang',
    'eats': 'makan', 'drinks': 'minum', 'stacks': 'menumpuk',
    'builds': 'membangun', 'moves': 'bergerak', 'turns': 'memutar',
    'sits': 'duduk', 'stands': 'berdiri', 'pulls': 'menarik',
    'pushes': 'mendorong', 'opens': 'membuka', 'closes': 'menutup',
    'points': 'menunjuk', 'looks': 'melihat', 'listens': 'mendengarkan',
    'hears': 'mendengar', 'helps': 'membantu', 'shares': 'berbagi',
    'creates': 'membuat', 'names': 'menyebutkan', 'remembers': 'mengingat',
    'identifies': 'mengidentifikasi', 'compares': 'membandingkan',
    'predicts': 'memprediksi', 'solves': 'menyelesaikan',
    'completes': 'menyelesaikan', 'balances': 'menyeimbangkan',
    'hops': 'melompat-lompat', 'pedals': 'mengayuh',
    'bounces': 'memantulkan', 'swipes': 'meraih',
    'bangs': 'memukul-mukulkan', 'transfers': 'memindahkan',
    'feeds': 'memberi makan', 'negotiates': 'bernegosiasi',
    'cooperates': 'bekerja sama', 'converses': 'bercakap-cakap',
    'argues': 'berargumen', 'repeats': 'mengulang', 'imitates': 'meniru',
    'crawls': 'merangkak', 'creeps': 'merayap', 'grasps': 'menggenggam',
    'babbles': 'berceloteh', 'coos': 'mengeluarkan suara kuu',
    'cries': 'menangis', 'smiles': 'tersenyum', 'laughs': 'tertawa',
    'waves': 'melambaikan tangan', 'claps': 'bertepuk tangan',
    'lifts': 'mengangkat', 'lowers': 'menurunkan', 'rotates': 'memutar',
    'prefers': 'lebih menyukai', 'fears': 'takut terhadap',
    'avoids': 'menghindari', 'approaches': 'mendekati',
    'maintains': 'menjaga', 'improves': 'meningkatkan',
    'increases': 'meningkat', 'decreases': 'berkurang',
    'focuses': 'memfokuskan', 'tracks': 'melacak',
    'observes': 'mengamati', 'watches': 'mengamati',
    'grabs': 'meraih', 'squeezes': 'meremas',
    'drops': 'menjatuhkan', 'releases': 'melepaskan',
    'shakes': 'menggoyang', 'pats': 'menepuk',
    
    # Nouns
    'infant': 'bayi', 'infants': 'bayi', 'baby': 'bayi', 'babies': 'bayi',
    'child': 'anak', 'children': 'anak-anak', 'toddler': 'balita',
    'head': 'kepala', 'hand': 'tangan', 'hands': 'tangan',
    'arm': 'lengan', 'arms': 'lengan', 'leg': 'kaki', 'legs': 'kaki',
    'foot': 'kaki', 'feet': 'kaki', 'finger': 'jari', 'fingers': 'jari',
    'toe': 'jari kaki', 'toes': 'jari kaki',
    'eye': 'mata', 'eyes': 'mata', 'ear': 'telinga', 'ears': 'telinga',
    'mouth': 'mulut', 'face': 'wajah', 'body': 'tubuh',
    'chest': 'dada', 'stomach': 'perut', 'tummy': 'perut',
    'back': 'punggung', 'neck': 'leher', 'shoulder': 'bahu',
    'elbow': 'siku', 'elbows': 'siku', 'knee': 'lutut', 'knees': 'lutut',
    'wrist': 'pergelangan tangan', 'ankle': 'pergelangan kaki',
    'object': 'benda', 'objects': 'benda', 'toy': 'mainan', 'toys': 'mainan',
    'block': 'balok', 'blocks': 'balok', 'ball': 'bola',
    'rattle': 'kerincingan', 'bottle': 'botol', 'cup': 'cangkir',
    'spoon': 'sendok', 'fork': 'garpu', 'book': 'buku',
    'crayon': 'krayon', 'pencil': 'pensil', 'paper': 'kertas',
    'puzzle': 'puzzle', 'scissors': 'gunting',
    'door': 'pintu', 'doorknob': 'gagang pintu',
    'container': 'wadah', 'containers': 'wadah',
    'surface': 'permukaan', 'position': 'posisi',
    'noise': 'suara', 'noises': 'suara', 'sound': 'suara', 'sounds': 'suara',
    'voice': 'suara', 'voices': 'suara',
    'reflex': 'refleks', 'movement': 'gerakan', 'movements': 'gerakan',
    'action': 'tindakan', 'actions': 'tindakan',
    'circle': 'lingkaran', 'square': 'kotak', 'triangle': 'segitiga',
    'line': 'garis', 'shape': 'bentuk', 'shapes': 'bentuk',
    'color': 'warna', 'colors': 'warna', 'number': 'angka', 'numbers': 'angka',
    'letter': 'huruf', 'letters': 'huruf', 'word': 'kata', 'words': 'kata',
    'sentence': 'kalimat', 'sentences': 'kalimat',
    'story': 'cerita', 'stories': 'cerita', 'song': 'lagu', 'songs': 'lagu',
    'name': 'nama', 'age': 'usia', 'friend': 'teman', 'friends': 'teman',
    'family': 'keluarga', 'parent': 'orang tua', 'parents': 'orang tua',
    'sibling': 'saudara', 'siblings': 'saudara',
    'stranger': 'orang asing', 'strangers': 'orang asing',
    'emotion': 'emosi', 'emotions': 'emosi',
    'feeling': 'perasaan', 'feelings': 'perasaan',
    'rule': 'aturan', 'rules': 'aturan', 'game': 'permainan', 'games': 'permainan',
    'turn': 'giliran', 'turns': 'giliran',
    'environment': 'lingkungan', 'community': 'komunitas',
    'world': 'dunia', 'nature': 'alam',
    
    # Adjectives / adverbs
    'loud': 'keras', 'quiet': 'tenang', 'soft': 'lembut',
    'familiar': 'yang dikenal', 'unfamiliar': 'asing',
    'strong': 'kuat', 'weak': 'lemah',
    'big': 'besar', 'small': 'kecil', 'large': 'besar',
    'long': 'panjang', 'short': 'pendek',
    'fast': 'cepat', 'slow': 'lambat',
    'quick': 'cepat', 'jerking': 'tersentak',
    'prone': 'tengkurap', 'supine': 'telentang',
    'dangling': 'menggantung', 'hidden': 'tersembunyi',
    'simple': 'sederhana', 'complex': 'kompleks',
    'easily': 'dengan mudah', 'independently': 'secara mandiri',
    'momentarily': 'sejenak', 'briefly': 'sebentar',
    'gradually': 'secara bertahap', 'consistently': 'secara konsisten',
    'increasingly': 'semakin',
    'correctly': 'dengan benar', 'accurately': 'secara akurat',
    'unsupported': 'tanpa bantuan',
    'early': 'awal', 'often': 'sering', 'sometimes': 'kadang-kadang',
    'always': 'selalu', 'never': 'tidak pernah',
    
    # Prepositions / articles (to remove)
    'the': '', 'a': '', 'an': '',
}

def translate_sentence(text):
    """Translate an English sentence to Indonesian."""
    result = text
    
    # Apply phrase translations first
    for eng, ind in WORD_MAP:
        result = re.sub(re.escape(eng), ind, result, flags=re.IGNORECASE)
    
    # Clean up
    result = re.sub(r'\s+', ' ', result).strip()
    
    # Capitalize first letter
    if result:
        result = result[0].upper() + result[1:]
    
    # Remove trailing period if duplicated
    result = result.rstrip('.')
    
    return result

def fix_target(target_text):
    """Fix target text to be proper Indonesian."""
    # Extract the content after 'Target: Anak mampu '
    m = re.match(r"Target: Anak mampu (.+)\.", target_text)
    if m:
        content = m.group(1)
        # Check if content is English
        words = content.lower().split()
        english_words = {'a','the','to','in','on','of','and','with','for','is','are','has','or','by','an','at','from','that','this','it','its','when','while','up','down','out','into','over'}
        eng_count = sum(1 for w in words if w in english_words)
        if eng_count >= 2:
            translated = translate_sentence(content)
            translated = translated[0].lower() + translated[1:] if translated else content
            return f"Target: Anak mampu {translated}."
    return target_text


# Read current file
with open(r'c:\Users\Administrator\AndroidStudioProjects\tumbang\lib\modules\redleaf\redleaf_data.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix all title lines that are still in English
def fix_title(match):
    title = match.group(1)
    words = title.lower().split()
    english_words = {'a','the','to','in','on','of','and','with','for','is','are','has','or','by','an','at','from','that','this','it','its','when','while','up','down','out','into','over'}
    eng_count = sum(1 for w in words if w in english_words)
    if eng_count >= 2:
        translated = translate_sentence(title)
        return f"title: '{translated}'"
    return match.group(0)

def fix_target_line(match):
    target = match.group(1)
    words = target.lower().split()
    english_words = {'a','the','to','in','on','of','and','with','for','is','are','has','or','by','an','at','from','that','this','it','its','when','while','up','down','out','into','over'}
    eng_count = sum(1 for w in words if w in english_words)
    if eng_count >= 2:
        fixed = fix_target(target)
        return f"target: '{fixed}'"
    return match.group(0)

# Fix titles
content = re.sub(r"title: '([^']*)'", fix_title, content)
# Fix targets
content = re.sub(r"target: '([^']*)'", fix_target_line, content)

with open(r'c:\Users\Administrator\AndroidStudioProjects\tumbang\lib\modules\redleaf\redleaf_data.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Post-processing complete. Re-checking remaining English titles...")

# Re-check
lines = content.split('\n')
count = 0
for i, line in enumerate(lines):
    if "title: '" in line:
        m = re.search(r"title: '([^']*)'", line)
        if m:
            t = m.group(1)
            words = t.lower().split()
            english_words2 = {'a','the','to','in','on','of','and','with','for','is','are','has','or','by','an','at','from','that','this','it','its','when','while','up','down','out','into','over'}
            eng_cnt = sum(1 for w in words if w in english_words2)
            if eng_cnt >= 2:
                count += 1
                if count <= 10:
                    print(f"  L{i+1}: {t}")

print(f"Remaining English titles: {count}")

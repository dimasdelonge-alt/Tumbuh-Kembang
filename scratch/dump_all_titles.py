"""
COMPREHENSIVE MANUAL TRANSLATION: Extract all 512 milestone titles from PDF,
then write complete Indonesian translations for each one.
This script dumps all raw titles so we can create a full translation map.
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

all_items = []

for ch_num, ch_id, ch_name, min_m, max_m, start_p, end_p in chapters:
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
        for idx, (title, desc) in enumerate(items, 1):
            all_items.append((ch_id, d_id, idx, title, desc))

print(f"Total items extracted: {len(all_items)}")
print("\n=== ALL ITEMS ===")
for ch_id, d_id, idx, title, desc in all_items:
    # Print in format for building translation dict
    key = f"{ch_id}|{d_id}|{idx}"
    print(f"    '{key}': '{title}',")

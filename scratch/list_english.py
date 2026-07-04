"""
FINAL FIX: Read all remaining English titles, translate them manually
in a comprehensive sentence-level map, and rewrite the file.
"""
import re

with open(r'c:\Users\Administrator\AndroidStudioProjects\tumbang\lib\modules\redleaf\redleaf_data.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Extract ALL titles
titles = re.findall(r"title: '([^']*)'", content)
print(f"Total titles: {len(titles)}")

# Check which are still partly/fully English
english_words = {'a','the','to','in','on','of','and','with','for','is','are','has','or','by','an','at','from','that','this','it','its','when','while','up','down','out','into','over','not','no','can','may','will','their','they','them','all','do','does','did','was','were','been','being','have','had','having','but','if','so','as','than','more','most','each','other','without','between','through','during','before','after','about','above','below','under','only','also','then','first','last','next'}

for t in titles:
    words = t.lower().split()
    eng_cnt = sum(1 for w in words if w in english_words)
    if eng_cnt >= 1 and any(c.isascii() and c.isalpha() for c in t):
        # Check if it still has obvious English
        has_english_verb = any(w in t.lower().split() for w in ['is','are','has','can','may','will','do','does','was','were','their','they','them','this','that','the','with','from','for','and','when','while','at','by','or','into','over','after','before','about','above','between','through','during'])
        if has_english_verb:
            print(f"  NEEDS FIX: {t}")

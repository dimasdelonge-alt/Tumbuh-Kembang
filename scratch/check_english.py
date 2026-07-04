import re

with open(r'c:\Users\Administrator\AndroidStudioProjects\tumbang\lib\modules\redleaf\redleaf_data.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

english_words = {'a','the','to','in','on','of','and','with','for','is','are','has','or','by','an','at','from','that','this','it','its','when','while','up','down','out','into','over','than','more','most','not','no','can','may','will','does','do','was','were','been','being','have','had','having','each','other','without','between','through','during'}

count = 0
still_english = []
for i, line in enumerate(lines):
    if "title: '" in line:
        m = re.search(r"title: '([^']*)'", line)
        if m:
            content = m.group(1)
            words = content.lower().split()
            eng_count = sum(1 for w in words if w in english_words)
            if eng_count >= 2:
                count += 1
                still_english.append((i+1, content))

print(f"Total still-English titles: {count}")
for ln, t in still_english[:30]:
    print(f"  L{ln}: {t}")
if count > 30:
    print(f"  ... and {count - 30} more")

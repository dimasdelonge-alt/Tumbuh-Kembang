"""Add minMonth/maxMonth to all 93 items in the 0_12m age group based on sub-age comments."""

import re

file_path = r'c:\Users\Administrator\AndroidStudioProjects\tumbang\lib\modules\redleaf\redleaf_data.dart'

with open(file_path, 'r', encoding='utf-8-sig') as f:
    content = f.read()

# Map sub-age comments to (minMonth, maxMonth)
sub_age_map = {
    'Birth to Two Months': (0, 2),
    'Two to Three Months': (2, 3),
    'Three to Four Months': (3, 4),
    'Four to Six Months': (4, 6),
    'Six to Nine Months': (6, 9),
    'Nine to Twelve Months': (9, 12),
    'Birth to One Month': (0, 1),
    'One to Three Months': (1, 3),
    'Three to Six Months': (3, 6),
    'One to Two Months': (1, 2),
    'Two to Four Months': (2, 4),
    'Birth to Six Months': (0, 6),
    'Six to Twelve Months': (6, 12),
}

lines = content.split('\n')
new_lines = []
current_min = None
current_max = None
in_0_12m_group = False
items_modified = 0

for i, line in enumerate(lines):
    stripped = line.strip()
    
    # Detect when we enter the 0_12m age group
    if "id: '0_12m'" in stripped:
        in_0_12m_group = True
    
    # Detect when we leave the 0_12m age group (next age group starts)
    if in_0_12m_group and "id: '1_year'" in stripped:
        in_0_12m_group = False
    
    # Check for sub-age comment markers
    if in_0_12m_group and stripped.startswith('//'):
        for label, (min_m, max_m) in sub_age_map.items():
            if label in stripped:
                current_min = min_m
                current_max = max_m
                break
    
    # Add minMonth/maxMonth after parentTips line
    if in_0_12m_group and current_min is not None and 'parentTips:' in stripped:
        new_lines.append(line)
        # Find the indentation from the parentTips line
        indent = line[:len(line) - len(line.lstrip())]
        new_lines.append(f'{indent}minMonth: {current_min},')
        new_lines.append(f'{indent}maxMonth: {current_max},')
        items_modified += 1
    else:
        new_lines.append(line)

result = '\n'.join(new_lines)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(result)

print(f'Modified {items_modified} items with minMonth/maxMonth')

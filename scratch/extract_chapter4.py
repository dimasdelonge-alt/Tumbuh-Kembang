import fitz  # PyMuPDF

pdf_path = r"C:\Users\Administrator\Downloads\Compressed\Redleaf_Quick_Guides_Petty,_Karen_Developmental_Milestones_of_Young.pdf"

doc = fitz.open(pdf_path)

# Chapter 4 starts at PDF page 22 (0-indexed: 21), let's extract pages 21-31
with open(r"scratch\ch4_pages.txt", "w", encoding="utf-8") as f:
    f.write("CHAPTER 4: Birth through Twelve Months\n")
    f.write("=" * 80 + "\n")
    
    for page_num in range(21, 32):  # PDF pages 22-32
        if page_num < doc.page_count:
            page = doc[page_num]
            text = page.get_text()
            f.write(f"\n--- PDF PAGE {page_num + 1} ---\n")
            f.write(text)

doc.close()
print("Done!")

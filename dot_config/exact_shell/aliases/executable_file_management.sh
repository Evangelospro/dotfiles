# Compression
alias compress="ouch compress"
alias extract="unp"

# OCRMyPDF
alias ocrmypdf="ocrmypdf --invalidate-digital-signatures --deskew --clean --oversample 300 --tesseract-pagesegmode 6 --tesseract-oem 1"
alias pdfocr-dir="find . -name '*.pdf' | parallel --tag -j 2 ocrmypdf '{}' '{}'"
alias pdfrepair-dir='find . -type f -iname "*.pdf" -exec sh -c '\''for f; do echo "$f" && gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -sOutputFile="$f.tmp" "$f" && mv -f "$f.tmp" "$f"; done'\'' sh {} +'

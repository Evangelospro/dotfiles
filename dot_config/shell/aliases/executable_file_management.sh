# Compression
alias compress="ouch compress"
alias extract="ouch decompress"

# OCRMyPDF
alias ocrmypdf-dir="find . -name '*.pdf' | parallel --tag -j 2 ocrmypdf '{}' '{}'"
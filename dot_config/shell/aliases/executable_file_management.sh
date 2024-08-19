# Compression
alias compress="ouch compress"
alias extract="unp"

# OCRMyPDF
alias ocrmypdf='ocrmypdf --invalidate-digital-signatures'
alias ocrmypdf-dir="find . -name '*.pdf' | parallel --tag -j 2 ocrmypdf '{}' '{}'"

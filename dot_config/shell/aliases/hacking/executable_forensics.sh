alias strings-windows="/usr/bin/strings -el $@"
alias exrtact-base64="/usr/bin/rg -o '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$?' $@"
alias extract-urls="/usr/bin/rg -o 'https?://[^ ]+' $@"
alias extract-ips="/usr/bin/rg -o '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' $@"

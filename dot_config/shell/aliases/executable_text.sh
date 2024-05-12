# Text manipulation

alias lower='tr "[:upper:]" "[:lower:]"'
alias upper='tr "[:lower:]" "[:upper:]"'
alias capitalize='sed "s/\b\(.\)/\u\1/g"'
alias title='sed "s/\b\(.\)/\u\1/g"'

alias rot13='tr "A-Za-z" "N-ZA-Mn-za-m"'
alias rot47='tr "!-~" "P-~!-O"'

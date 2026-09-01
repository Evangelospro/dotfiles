# Fix sqlmap bad installation on Arch Linux
if [ -f /opt/sqlmap-bin/sqlmap.py ]; then
    alias sqlmap="/opt/sqlmap-bin/sqlmap.py"
elif [ -f /opt/sqlmap/sqlmap.py ]; then
    alias sqlmap="/opt/sqlmap/sqlmap.py"
fi
alias wpscan='wpscan -e ap,t,u --plugins-detection aggressive'
alias web-server='updog -p 8000'
alias ftp-server='sudo python -m pyftpdlib -p 21'

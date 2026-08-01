# Fix sqlmap bad installation on Arch Linux
if [ -f /opt/sqlmap-bin/sqlmap.py ]; then
    alias sqlmap="/opt/sqlmap-bin/sqlmap.py"
elif [ -f /opt/sqlmap/sqlmap.py ]; then
    alias sqlmap="/opt/sqlmap/sqlmap.py"
fi
alias sstimap="python3 $HACKING_TOOLS/Web/SSTImap/sstimap.py"
alias wpscan='wpscan -e ap,t,u --plugins-detection aggressive'
alias jwt-tool="python3 $HACKING_TOOLS/Web/jwt_tool/jwt_tool.py"
alias webserver='updog -p 8000'
alias ftpup='sudo python -m pyftpdlib -p 21'

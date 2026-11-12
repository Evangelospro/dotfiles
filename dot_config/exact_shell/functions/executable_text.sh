function urlencode() {
    /usr/bin/python3 -c "import sys; from pwn import *; context.log_level = 'error'; print(urlencode(sys.argv[1]));" "$1"
}

function urldecode() {
    /usr/bin/python3 -c "import sys; from pwn import *; context.log_level = 'error'; print(urldecode(sys.argv[1]));" "$1"
}

function xor() {
    /usr/bin/python3 -c "import sys; from pwn import *; context.log_level = 'error'; print(xor(sys.argv[1].encode(), sys.argv[2].encode()));" "$1" "$2"
}

function urlencode() {
    /usr/bin/python3 -c "from pwn import *; context.log_level = 'error'; print(urlencode('$1'));"
}

function urldecode() {
    /usr/bin/python3 -c "from pwn import *; context.log_level = 'error'; print(urldecode('$1'));"
}

function xor() {
    /usr/bin/python3 -c "from pwn import *; context.log_level = 'error'; print(xor(b'$1', b'$2'));"
}

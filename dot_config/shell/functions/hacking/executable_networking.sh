function scan() {
    rustscan --ulimit 5000 -b 3000 -a $1 -- -sC -sV
}

john-rock() {
    if [ $# -eq 0 ]; then
        echo "[i] Usage: $0 [options] hashfile"
    else
        seclists_dir=$(get-seclists-dir)
        john "${@}" --wordlist="$seclists_dir/Passwords/Leaked-Databases/rockyou.txt"
    fi
}

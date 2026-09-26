# Networking
alias ip='ip -color -brief'
alias ipa='ip -color -brief a'

# Transfers
alias rsync-fast='rsync -avAHx --progress --human-readable --info=progress2 -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x"'

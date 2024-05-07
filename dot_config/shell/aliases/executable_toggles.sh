# Disables / Enables
alias enable-ping='sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0'
alias disable-ping='sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1'
alias disable-ipv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1'
alias enable-ipv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0'
alias disable-aslr='sudo sysctl -w kernel.randomize_va_space=0'
alias enable-aslr='sudo sysctl -w kernel.randomize_va_space=2'

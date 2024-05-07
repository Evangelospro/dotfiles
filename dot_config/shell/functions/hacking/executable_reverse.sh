function angr() {
    docker run --rm -it -v "$(pwd)":/home/angr/work --privileged --cap-add=SYS_PTRACE angrpypy
}

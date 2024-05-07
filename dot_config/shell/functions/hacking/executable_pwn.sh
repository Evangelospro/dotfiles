function pwnenv() {
    if [ $(checkContainerRunning "pwnenv") ]; then
        echo "Container already running, attaching..."
        docker exec -it pwnenv zsh
    else
        echo "Starting container..."
        docker run --net=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --rm -it -v "$(pwd)":/root/data -h PWNENV --name pwnenv ghcr.io/evangelospro/pwnenv:latest
    fi
}

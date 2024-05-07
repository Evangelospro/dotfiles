function update-zsh() {
    # Update zsh plugins
    zinit update --parallel 40
    # Update zinit
    zinit self-update
}

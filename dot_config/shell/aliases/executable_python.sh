# python / pip / pipx
alias p='ipython' #'python3'
alias pip='noglob pip'
alias pipx='noglob pipx'
alias pipi='pip install'
alias pipir='pip install -r'
alias pipreq='pip freeze > requirements.txt'
alias pipua='pip list | cut -d " " -f1 | tail +3 | xargs pip install -U'



aliases_file = open('../aliases.zsh', 'r')

aliases_list = []

start = False

def recurse():
    if not start:
            start = True
            aliases_list.append(line.strip())
    elif start:
        sorted_alieses = sorted(aliases_list)
        for alias in sorted_alieses:
            print(alias)
        print()
        aliases_list = []
        aliases_list.append(line.strip())
        start = False
           
start = 
            
for line in aliases_file.readlines():
    if line.startswith('alias'):
        aliases_list.append(line[6:].strip())
    elif line.startswith('#'):
        recurse()
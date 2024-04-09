# Zwerd Web Enumeration Killer tool  
This is a zwerd tool that I created for my OSCP certification,
the idea is to have way to run web enumeration in one tool intead of using dirb or feroxbuster or dirbuster and other tools
Also that script create local files named of the search engine and used wordlist, so we can run unix command for grap the information from them easely

# How to run
/usr/local/sbin/zwek <engine> <url> <wordlist or directory> <options>

# Example:
zwek feroxbuster http://10.0.0.1:80/ /usr/share/dirb/wordlists/common.txt "-e -x php jsp html js"
or
zwek feroxbuster http://10.0.0.1:80/ dirb "-e -x php jsp html js"

# output file:
feroxbuser_10.0.0.1:80_common.txt
or
feroxbuster_10.0.0.1:80_small.txt
feroxbuster_10.0.0.1:80_euskera.txt
feroxbuster_10.0.0.1:80_catala.txt
....

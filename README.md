# bash-portstatus

Network connection, status, open ports in Linux. 

	- kernel routing table
	- kernel interface table
	- internet connections

### Check files permisions

bashportstatus.sh should be executable.
Go to bash-portstatus directory and check:

```sh
$ ls -l | cut -d' ' -f1,9
```

you should see:

```sh
$ total
-rwx------ bash-portstatus.sh
-rw-r--r-- config
-rw-r--r-- generator
```

### Configure script

Edit config file:

```sh
$ vim config
```

```sh
# If "yes" the script generates shell report
SHELL='yes'

# If "yes" the script generates index.html file
HTML='yes'

# HTML file path 
# you can set here your index.html destination
HTML_PATH='/home/www/localhost/'

# Refresh browser in seconds
# It works with HTML='yes' (option above)
RF=15

# System date and time
# %Y - year, %m - month, %d -day
# %H - hour, %M - minutes, %s - seconds
DT=`date "+%Y-%m-%d %H:%M:%S"`

# Show system information (man uname)
# -a, --all print all information, in the following order, except omit -p and -i if unknown:
# -s, --kernel-name print the kernel name
# -n, --nodename print the network node hostname
# -r, --kernel-release print the kernel release
# -v, --kernel-version print the kernel version
# -m, --machine print the machine hardware name
# -p, --processor print the processor type (non-portable)
# -i, --hardware-platform print the hardware platform (non-portable)
# -o, --operating-system print the operating system
S_UNAME_PARAM='-a'
```

### Run script

```sh
$ ./bash-portstatus.sh
```

### Todos

	- HTML menu
	- more funcionality

License
----

MIT



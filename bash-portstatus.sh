#!/bin/bash
#
# Function check
function check() {
	C_ARRAY=("$@")
	# Check all array elements 
	for i in "${C_ARRAY[@]}"
	do
		if [ ! -f "$i" ] 
		then
			# Isolate file name from path
			FILEN=`echo "$i" | awk -F'/' '{print $NF}'`
			
			echo -e "File $FILEN not found! \nScript has been stopped! Please check $FILEN file" 2>&1
			exit 
		fi
	done
}

# Check application dependencies
# If any does not exist, stop and inform  
[ ! -z `which netstat` ] && S_NETSTAT=`which netstat` || echo '"netstat" command not found! Please install it.'
[ ! -z `which awk` ] && S_AWK=`which awk` || echo '"awk" command not found! Please install it.'
[ ! -z `which grep` ] && S_GREP=`which grep` || echo '"grep" command not found! Please install it.'
[ ! -z `which sed` ] && S_SED=`which sed` || echo '"sed" command not found! Please install it.'
[ ! -z `which tee` ] && S_TEE=`which tee` || echo '"tee" command not found! Please install it.'
[ ! -z `which date` ] && S_DATE=`which date` || echo '"date" command not found! Please install it.'
[ ! -z `which uname` ] && S_UNAME=`which uname` || echo '"uname" command not found! Please install it.'
[ ! -z `which pwd` ] && S_PWD=`which pwd` || echo '"pwd" command not found! Please install it.'

# Application path
SCRIPT_PATH=`$S_PWD`

# Check if files exist
FILES=("$SCRIPT_PATH/config" "$SCRIPT_PATH/generator")
check "${FILES[@]}"

# Load config file
source $SCRIPT_PATH/config

# Check uname parameters in order to prepare table header
case "$S_UNAME_PARAM" in
'-s')
	TH_UNAME=('Kernel name')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-n')
	TH_UNAME=('Node name')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-r')
	TH_UNAME=('Kernel release')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-v')
	TH_UNAME=('Kernel version')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-m')
	TH_UNAME=('Machine')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-p')
	TH_UNAME=('Processor')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-i')
	TH_UNAME=('Hardware platform')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
'-o')
	TH_UNAME=('Operating system')
	TD_UNAME=`$S_UNAME $S_UNAME_PARAM`
	if [ "$HTML" = 'yes' ]
	then
		TH_UNAME_HTML="<th>$TH_UNAME</th>"
		TD_UNAME_HTML="<td>$TD_UNAME</td>"
	fi
	;;
*)
	TH_UNAME=('Kernel name' 'Node name' 'Kernel release' 'Kernel version' 'Machine' 'Processor' 'Hardware platform' 'Operating system')
	TD_UNAME[0]=`$S_UNAME -s`
	TD_UNAME[1]=`$S_UNAME -n`
	TD_UNAME[2]=`$S_UNAME -r`
	TD_UNAME[3]=`$S_UNAME -v`
	TD_UNAME[4]=`$S_UNAME -m`
	TD_UNAME[5]=`$S_UNAME -p`
	TD_UNAME[6]=`$S_UNAME -i`
	TD_UNAME[7]=`$S_UNAME -o`
	# Prepare HTML version
	if [ "$HTML" = 'yes' ]
	then
		# Declare arrays
		TH_UNAME_HTML=()
		TD_UNAME_HTML=()
		# TH table headers
		for i in "${TH_UNAME[@]}"
		do
			TH_UNAME_HTML+=("<th>$i</th>")
		done
		# Td table data
		for i in "${TD_UNAME[@]}"
		do
			TD_UNAME_HTML+="<td>$i</td>"
		done
	fi
  	;;
esac

# Route table using netstat
CAPTION_NETSTAT_K_HTML=`$S_NETSTAT -r | $S_AWK 'NR==1'`
TH_NETSTAT_K_HTML=`$S_NETSTAT -r | $S_AWK 'NR==2 {print \
						"<tr><th>"$1 \
						"</th><th>"$2 \
						"</th><th>"$3 \
						"</th><th>"$4 \
						"</th><th>"$5 \
						"</th><th>"$6 \
						"</th><th>"$7 \
						"</th><th>"$8"</th></tr>"}'`
TD_NETSTAT_K_HTML=`$S_NETSTAT -rn | $S_AWK 'NR>2 {print \
						"<tr><td>"$1 \
						"</td><td>"$2 \
						"</td><td>"$3 \
						"</td><td>"$4 \
						"</td><td>"$5 \
						"</td><td>"$6 \
						"</td><td>"$7 \
						"</td><td>"$8"</td></tr>"}'`
						

# Kernel interface table
CAPTION_NETSTAT_I_HTML=`$S_NETSTAT -i | $S_AWK 'NR==1'`
TH_NETSTAT_I_HTML=`$S_NETSTAT -i | $S_AWK 'NR==2 {print \
						"<tr><th>"$1 \
						"</th><th>"$2 \
						"</th><th>"$3 \
						"</th><th>"$4 \
						"</th><th>"$5 \
						"</th><th>"$6 \
						"</th><th>"$7 \
						"</th><th>"$8 \
						"</th><th>"$9 \
						"</th><th>"$10 \
						"</th><th>"$11 \
						"</th><th>"$12"</th></tr>"}'`
TD_NETSTAT_I_HTML=`$S_NETSTAT -i | $S_AWK 'NR>2 {print \
						"<tr><td>"$1 \
						"</td><td>"$2 \
						"</td><td>"$3 \
						"</td><td>"$4 \
						"</td><td>"$5 \
						"</td><td>"$6 \
						"</td><td>"$7 \
						"</td><td>"$8 \
						"</td><td>"$9 \
						"</td><td>"$10 \
						"</td><td>"$11 \
						"</td><td>"$12"</td></tr>"}'`

# Active internet connections using NETSTAT
CAPTION_NETSTAT_AIC_HTML=`$S_NETSTAT -ltn | $S_AWK 'NR==1'`
TH_NETSTAT_AIC_HTML=`$S_NETSTAT -ltun | $S_AWK 'NR==2 {print \
						"<tr><th>"$1 \
						"</th><th>"$4 $5 \
						"</th><th>"$3 \
						"</th><th>"$4 $5 \
						"</th><th>"$6 $7 \
						"</th><th>"$8"</th></tr>"}'`
TD_NETSTAT_AIC_HTML=`$S_NETSTAT -ltun | $S_AWK 'NR>2 {print \
						"<tr><td>"$1 \
						"</td><td>"$2 \
						"</td><td>"$3 \
						"</td><td>"$4 \
						"</td><td>"$5 \
						"</td><td>"$6"</td></tr>"}'`

# Load generator file
source $SCRIPT_PATH/generator

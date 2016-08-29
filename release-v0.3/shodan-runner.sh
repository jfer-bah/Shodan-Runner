clear
echo '███████╗██╗  ██╗ ██████╗ ██████╗  █████╗ ███╗   ██╗██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗ '
echo '██╔════╝██║  ██║██╔═══██╗██╔══██╗██╔══██╗████╗  ██║██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗'
echo '███████╗███████║██║   ██║██║  ██║███████║██╔██╗ ██║██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝'
echo '╚════██║██╔══██║██║   ██║██║  ██║██╔══██║██║╚██╗██║██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗'
echo '███████║██║  ██║╚██████╔╝██████╔╝██║  ██║██║ ╚████║██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║'
echo '╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝'

#set outputfile = $1
#set country = $2
#set vendors = $3

echo 'ver 0.3 / Last update Aug 22, 2016 / created by jfer @ Booz Allen Hamilton'
echo 'https://github.com/booz-allen-hamilton/Shodan-Runner'
# changes 
# v0.3 --documented uses, added input checking, first public release
# v0.2 --removed parse feature question after download is completed 
# v0.1 --initial proof of concept

# Check if shodan is installed, if not, install shodan python, ask user for api key, initialize shodan cli with api key #

check_shodan() {
hash shodan 2>/dev/null || { echo >&2 "shodan cli for python not found, installing and exiting, re-run script after succesful install" ; sudo easy_install shodan; exit; } 
}

check_api_key() {
shodan info 2>/dev/null || { echo >&2 "no api key,get your api key for shodan and insert here"; read f; shodan init $f; }
}

# wanted to use openssl s_client -connect shodan.io:443 -quiet, but doing the ssl checks slow down the tool, you pick...

check_network_comms(){
wget --tries=2 --timeout=8 -q --spider https://shodan.io --no-check-certificate
if [[ $? -ne 0 ]] 
then
	echo "Cannot reach shodan, either your network connection is down or shodan.io cannot be reached at the moment"
	exit
fi
}

# once shodan is installed and api key is set, it should show how many credits you have remaining on this api key

# simple function to ensure 3 parameters are passed

check_inputs() {
if [ $# -ne 3 ]
then
	echo "Wrong number of parameters used, script takes 3 arguments"
	exit	
fi
}

# Set newline and outfile/inputfile in order to parse content correctly.

newline='
'

OIFS=$IFS
IFS=$newline
print_usage() {
echo ''
echo ''

echo 'This script is a simple nested bash loop that uses an already activates shodan cli with api key in order to expedite queries for collection'
 
echo 'usage: shodan-runner [desired output filename] [filename 1] [filename 2]'
echo ''
echo 'Script takes 3 inputs. Order, name or content of text files does not affect script'
echo ''
echo 'example: ./shodan-runner shodan-collection countries.txt vendors.txt'
echo ''
echo 'No safety checks here for bad syntax or bad search filters, pay attention or lose search queries tokens :-)'
echo ''
}

# Nested bash loop that loops two times and attempts shodan download $filename $country $vendors

check_network_comms
check_shodan
check_api_key
print_usage
check_inputs $1 $2 $3
for c in $(cat $2)
do
	IFS=$OIFS
	for v in $(cat $3)
	do
		shodan download $(echo $1.$c.$v | tr -d '"' | tr -d "[:space:]" | sed 's/\:/_/g') $c $v --limit 10000
	done
done

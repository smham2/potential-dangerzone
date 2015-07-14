#!/bin/bash
#
# DNS Lookup
# Stanley Hammond - 2013-2014
#
# This is a basic script that will return the active IP address or Hostname of 
# computers on a given network.  This will only search a /24 network (254 hosts)
# I was looking for a script that returned the live hosts on a private network. 
#
# This script is provided AS-IS.  I am not responsible for any damage this script my
# cause to your system.  Use it at your own risk.
#

function help {
	echo ""
	echo "Host Network Lookup"
	echo "Usage: $0 Network (Where network is the first 3 octets)"
	echo "Example: $0 192.168.1"
	echo ""
}

if ! [ $# -eq 1 ]
	then
	help
	exit 0
fi

for i in {1..254}
do
	ip=$1.$i
	result=`ping -c 1 -q -n $ip | grep "packet" | awk '{ print $6 }'`
	if [ "$result" == "0%" ]
	then
		hostname=`host $ip | grep -v "not found" | awk '{ print $5 }'`
		if [ "$hostname" != "" ] 
		then
			echo $ip,${hostname%?}
		else
			echo $ip
		fi
	fi
done

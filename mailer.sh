#!/bin/bash
#
# Mailer
# Stanley Hammond - 2011-2012
#
# This script will email users on a Linux system, if the account exist.
# This is a good script if you want to inform Linux users of changes to the system, although
# regular email or a telephone call would probably be more pratical.
# This script was a homework assignment for a shell scripting course I took.
# You will need to change the email body to match the message that you want to send.
#
# This script is provided AS-IS.  I am not responsible for any damage this script my
# cause to your system.  Use it at your own risk.
#


# Mailer function (actual message that is send to users
mailer ()
{

BODY="
Hello $REALNAME
Change this part to match the intended message you want to send. The current time and date is `date`. Have a nice day.
Signed: $SIGNATURE
"
echo "$BODY" | mail -s "Hello $REALNAME" $USERNAME

}

# Usage function (help)
usage ()
{

echo "
mailer username(s)...
" >&2
exit 1

}

if [ $# -eq 0 ]
	then
	usage
fi

for I in $* 
do

USERNAME=`grep $I /etc/passwd | cut -d':' -f1`
if [ "$I" == "$USERNAME" -a $I != ${USER} ]
then

SHORT=`echo $I | cut -c 1-8`
SIGNATURE=`grep ${USER} /etc/passwd | cut -d':' -f1`

if MATCH=`who | grep "^$SHORT" `
	then
	REALNAME=`grep $SHORT /etc/passwd | cut -d':' -f7`
	mailer
	else
	echo "User $I not logged in"
fi

elif [ ! "$USERNAME" ]
	then
	echo "User $I is not a valid account on this system"
fi

done

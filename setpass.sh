#!/bin/bash
#
# Set Password (for Apache)
# Stanley Hammond - 2015
#
# This script will create a random password using Python and set that password to a specific user
# storing the information in a htpasswd file.  Use this script if you are setting up a password
# protected site, but want random 10 character passwords for each user.
#
# This script is provided AS-IS.  I am not responsible for any damage this script my
# cause to your system.  Use it at your own risk.
#

function help {
        echo ""
        echo "Set Password (for Apache Web Servers)"
        echo "Usage: $0 user_name"
        echo "Example: $0 john_doe (Generates a 10 character password for john_doe)"
        echo ""
}

function random_passwd {
python - <<END
import string
import random
def id_generator(size=10, chars=string.ascii_letters + '!@$' + string.digits):
  return ''.join(random.SystemRandom().choice(chars) for _ in range(size))
print "%s" % id_generator()
END
}

if ! [ $# -eq 1 ]
        then
        help
        exit 0
fi

temppass=$(random_passwd)

htpasswd -b -c /etc/apache2/.htpasswd $1 $temppass

echo "$1 = $temppass"

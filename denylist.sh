#!/bin/bash

# parallel download and cleaning
read -r -d '' URLS <<'EOF'
https://adaway.org/hosts.txt
https://urlhaus.abuse.ch/downloads/hostfile/
https://mirror1.malwaredomains.com/files/justdomains
https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt
https://codeberg.org/spootle/blocklist/raw/branch/master/blocklist.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://phishing.army/download/phishing_army_blocklist_extended.txt
https://pgl.yoyo.org/adservers/serverlist.php\?hostformat=hosts\&showintro=0\&mimetype=plaintext
EOF
echo "$URLS" |  xargs -n 1 -P 4 wget -qO - \
 | sed '/^s*$/d;/^\s*\#/d;/"/d;s/$\s//;s///;s/[[:blank:]]*$//;s/\(\.*\)\(#.*\)/\1/;s/\.$//' \
 | awk '{print $NF}' | tr '[:upper:]' '[:lower:]' | sort | uniq \
 | awk '{print "local-zone: \""$1"\" always_nxdomain"}' > /tmp/denylist.conf

# remove domain from denylist
sed -i '/algolia.com/d' /tmp/denylist.conf
sleep 1
sudo mv -v /etc/unbound/denylist.conf ~/denylist.conf.old
sudo mv -v /tmp/denylist.conf /etc/unbound/denylist.conf
sync
sleep 1
sudo systemctl stop unbound
sleep 1
sudo systemctl start unbound

#!/bin/bash

alertSMS="1234567890@txt.att.net" #update with your number or email, semi-colon seperated
date=`date +%d%m%y`
alertText="failedSites${date}.txt"
sitesToCheck=(http://www.SITE1.com/ 
http://site.two.com/ 
http://www.SITE3.com/ ) 

if [ -f $alertText ]; then
  #already alerted
  exit 0
fi

for site in ${sitesToCheck[@]}; do
  status=`curl -silent $site -I | awk '/HTTP/ {print $2}'`

  if [ $status != "200" ]; then
    echo "$site has failed with a $status error code.">>$alertText
  fi
done

if [ -f $alertText ]; then
  mailx -s "sites are down alert" -F $alertSMS<$alertText
fi

exit 0

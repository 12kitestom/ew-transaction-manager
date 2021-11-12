#!/bin/sh
echo "let apiUrlBase = '$API_URL';" > /usr/share/nginx/html/tmp.txt
cat /usr/share/nginx/html/tmp.txt /usr/share/nginx/html/scriptfragment.html > /usr/share/nginx/html/scriptfragment2.html
rm /usr/share/nginx/html/scriptfragment.html
mv /usr/share/nginx/html/scriptfragment2.html /usr/share/nginx/html/scriptfragment.html
rm /usr/share/nginx/html/tmp.txt


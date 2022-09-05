#!/bin/sh
echo "let apiUrlBase = '$API_URL';" > /usr/share/nginx/html/tmp.txt
cat /usr/share/nginx/html/tmp.txt /usr/share/nginx/html/prescript.html > /usr/share/nginx/html/prescript2.html
rm /usr/share/nginx/html/prescript.html
mv /usr/share/nginx/html/prescript2.html /usr/share/nginx/html/prescript.html
rm /usr/share/nginx/html/tmp.txt


#! /bin/sh

echo "Content-type: text/html"
echo ""

echo "<h1>Databases</h1>\n"

cd /database
for f in duc_*.db; do
    echo "<a href=select.cgi?db=$f>$f</a><br>\n"
done

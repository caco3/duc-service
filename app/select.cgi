#! /bin/sh

echo "Content-type: text/html"
echo ""

QUERY=`echo "$REQUEST_URI" | sed "s/\/select.cgi?db=//"`
# echo "QUERY: '$QUERY'"

# For simplicity, we expect we are a single user system
# We then simply copy the selected database to the default one
rm -f /database/duc.db
cp "/database/$QUERY" "/database/duc.db"

echo "<meta http-equiv=refresh content=\"0; url=duc.cgi?cmd=index&path=/scan\">"

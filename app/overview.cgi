#! /bin/sh

echo "Content-type: text/html"
echo ""

cd /database
echo "<ul>"
for f in `ls -c1 duc_*.db | sort`; do
    n=`echo $f | sed "s/duc_//"`
    n=`echo $n | sed "s/.db//"`
#     n=`echo $n | sed "s/-/:/"`
    n=`echo $n | sed "s/_/ /"`
    echo "<li><a href=javascript:void(0) onclick=selected(\"$f\")>$n</a></li><br>\n"
done
echo "</ul>"

#!/bin/sh

#  parser.sh
#  
#
#  Created by Sven Jansen on 14.11.12.
#

SOURCE=$1
DESTINATIONFILE=$2
SPLIT_SOURCE=$3

split -p "<<UNIT_TEST_MARKER_START>>" $SOURCE $SPLIT_SOURCE
SPLIT_SOURCE=$SPLIT_SOURCE"ab"

LINENUMBERSERROR=$(grep "error" $SPLIT_SOURCE | awk -F, 'END{print NR}')
LINENUMBERSPASSED=$(grep "passed" $SPLIT_SOURCE | awk -F, 'END{print NR}')
TESTSUM=`expr $LINENUMBERSERROR + $LINENUMBERSPASSED`

echo "<html><style type=\"text/css\"><!-- body, table { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px } --> </style><body>" > $DESTINATIONFILE
echo "<h1>Test Results: $LINENUMBERSPASSED / $TESTSUM  tests passed</h1>" >> $DESTINATIONFILE
if [ $LINENUMBERSERROR == 0 ] ; then
    echo "<b>All Unit Tests passed. See the results below...</b><br><br><br>" >> $DESTINATIONFILE
else 
    echo "<table cellpadding=10 cellspacing=0>" >> $DESTINATIONFILE
    echo "<tr><th>Implementation File</th><th>Line Number</th><th>Result</th><th>Message</th></tr>" >> $DESTINATIONFILE
    for ((i=1; i<=$LINENUMBERSERROR; i++ )) ;
    do
    if [ $(( $i % 2 )) -ne 0 ] ; then
        TR="<tr bgcolor=#EEEEFF>"
    else
        TR="<tr>"
    fi
    echo "$TR<td>" >> $DESTINATIONFILE
    echo $(grep "error" $SPLIT_SOURCE | awk NR==$i | grep -o '[^\/]*:[0-9]*:' | grep -o '^[0-9A-Za-z]*.[A-Za-z]') >> $DESTINATIONFILE
    echo "</td><td>" >> $DESTINATIONFILE
    echo $(grep "error" $SPLIT_SOURCE | awk NR==$i | grep -o '[^\/]*:[0-9]*:' | grep -o ':[0-9]*:' | grep -o '[^:][0-9]*') >> $DESTINATIONFILE
    echo "</td><td>" >> $DESTINATIONFILE
    echo "<font color=\"red\">Error</font></td>" >> $DESTINATIONFILE
    echo "</td><td><i>" >> $DESTINATIONFILE
    echo $(grep "error" $SPLIT_SOURCE | awk NR==$i | grep -o '] : .*' | cut -c 5-) >> $DESTINATIONFILE

    echo "</i></td></tr>" >> $DESTINATIONFILE
    done

    echo "</table><br><br><br><br>" >> $DESTINATIONFILE
fi

echo "<table cellpadding=10 cellspacing=0>" >> $DESTINATIONFILE
echo "<tr><th>Test Class</th><th>Test Method</th><th>Execution Time</th><th>Result</th></tr>" >> $DESTINATIONFILE
for ((i=1; i<=$LINENUMBERSPASSED; i++ )) ;
do
if [ $(( $i % 2 )) -ne 0 ] ; then
TR="<tr bgcolor=#EEEEFF>"
else
TR="<tr>"
fi
echo "$TR<td>" >> $DESTINATIONFILE
echo $(grep "passed" $SPLIT_SOURCE | awk NR==$i | awk -F "[" '{print $2}' | awk -F " " '{print $1}') >> $DESTINATIONFILE
echo "</td><td>" >> $DESTINATIONFILE
echo $(grep "passed" $SPLIT_SOURCE | awk NR==$i | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' | awk -F " " '{print $2}' | awk -F "]" '{print $1}') >> $DESTINATIONFILE
echo "</td><td>" >> $DESTINATIONFILE
echo $(grep "passed" $SPLIT_SOURCE | awk NR==$i | awk -F "(" '{print $2}' | awk -F ")" '{print $1}') >> $DESTINATIONFILE
echo "</td><td>" >> $DESTINATIONFILE
echo "<font color=\"green\">Passed</font></td>" >> $DESTINATIONFILE

echo "</td></tr>" >> $DESTINATIONFILE
done
echo "</table><br><br><br><br>" >> $DESTINATIONFILE

echo "</body></html>" >> $DESTINATIONFILE
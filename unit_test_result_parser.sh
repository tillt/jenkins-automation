#!/bin/sh

#  parser.sh
#  
#
#  Created by Sven Jansen on 14.11.12.
#
SOURCE=$1
DESTINATIONFILE=$2
SPLIT_SOURCE=$3

# split our input file (burger) into 3 pieces - the uppen bun, the beef and the lower bun
split -p "<<UNIT_TEST_MARKER>>" $SOURCE $SPLIT_SOURCE
SPLIT_SOURCE=$SPLIT_SOURCE"ab"

# get number of lines for different test states
LINENUMBERSERROR=$(grep "error" $SPLIT_SOURCE | awk -F, 'END{print NR}')
LINENUMBERSPASSED=$(grep "passed" $SPLIT_SOURCE | awk -F, 'END{print NR}')
TESTSUM=`expr $LINENUMBERSERROR + $LINENUMBERSPASSED`

# create a HTML body with some CSS styles
echo "<html><style type=\"text/css\"><!-- body, table { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px } --> </style><body>" > $DESTINATIONFILE
# headline with amount of passed tests
echo "<h1>Test Results: $LINENUMBERSPASSED / $TESTSUM  tests passed</h1>" >> $DESTINATIONFILE
# if all tests passed display just a nice message
if [ $LINENUMBERSERROR == 0 ] ; then
    echo "<b>Congratulations! All Unit Tests passed...</b><br><br><br>" >> $DESTINATIONFILE
# if some tests failed display them on top
else 
    echo "<table cellpadding=10 cellspacing=0>" >> $DESTINATIONFILE
    echo "<tr><th>Implementation File</th><th>Line Number</th><th>Result</th><th>Message</th></tr>" >> $DESTINATIONFILE
    # create a table row for every failed test  
    for ((i=1; i<=$LINENUMBERSERROR; i++ )) ;
    do
    # alternate the background-color of table row
    if [ $(( $i % 2 )) -ne 0 ] ; then
        TR="<tr bgcolor=#EEEEFF>"
    else
        TR="<tr>"
    fi
    echo "$TR<td>" >> $DESTINATIONFILE
    # get the implementation file where the error occured
    echo $(grep "error" $SPLIT_SOURCE | awk NR==$i | grep -o '[^\/]*:[0-9]*:' | grep -o '^[0-9A-Za-z]*.[A-Za-z]') >> $DESTINATIONFILE
    echo "</td><td>" >> $DESTINATIONFILE
    # get the line number in which the error occured
    echo $(grep "error" $SPLIT_SOURCE | awk NR==$i | grep -o '[^\/]*:[0-9]*:' | grep -o ':[0-9]*:' | grep -o '[^:][0-9]*') >> $DESTINATIONFILE
    echo "</td><td>" >> $DESTINATIONFILE
    # just indicate that this test failed
    echo "<font color=\"red\">Error</font></td>" >> $DESTINATIONFILE
    echo "</td><td><i>" >> $DESTINATIONFILE
    # get the result message from OCUnit
    echo $(grep "error" $SPLIT_SOURCE | awk NR==$i | grep -o '] : .*' | cut -c 5-) >> $DESTINATIONFILE

    echo "</i></td></tr>" >> $DESTINATIONFILE
    done

    echo "</table><br><br><br><br>" >> $DESTINATIONFILE
fi

# create a second table with all passed tests
echo "<table cellpadding=10 cellspacing=0>" >> $DESTINATIONFILE
echo "<tr><th>Test Class</th><th>Test Method</th><th>Execution Time</th><th>Result</th></tr>" >> $DESTINATIONFILE
# create a table row for every passed test
for ((i=1; i<=$LINENUMBERSPASSED; i++ )) ;
do
# alternate the background-color of table row
if [ $(( $i % 2 )) -ne 0 ] ; then
TR="<tr bgcolor=#EEEEFF>"
else
TR="<tr>"
fi
echo "$TR<td>" >> $DESTINATIONFILE
# get the test class
echo $(grep "passed" $SPLIT_SOURCE | awk NR==$i | awk -F "-" '{print $2}' | awk -F " " '{print $1}' | grep -o [^\[]*$) >> $DESTINATIONFILE
echo "</td><td>" >> $DESTINATIONFILE
# get the name of test method
echo $(grep "passed" $SPLIT_SOURCE | awk NR==$i | awk -F "-" '{print $2}' | awk -F " " '{print $2}' | awk -F "]" '{print $1}') >> $DESTINATIONFILE
echo "</td><td>" >> $DESTINATIONFILE
# get the execution time of this test
echo $(grep "passed" $SPLIT_SOURCE | awk NR==$i | awk -F "(" '{print $2}' | awk -F ")" '{print $1}') >> $DESTINATIONFILE
echo "</td><td>" >> $DESTINATIONFILE
# just indicate that this test passed
echo "<font color=\"green\">Passed</font></td>" >> $DESTINATIONFILE

echo "</td></tr>" >> $DESTINATIONFILE
done
echo "</table><br><br><br><br>" >> $DESTINATIONFILE

echo "</body></html>" >> $DESTINATIONFILE
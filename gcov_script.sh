#!/bin/sh

#  gcov_script.sh
#  
#
#  Created by Sven Jansen on 12.10.12.
#

#!/bin/sh

# constants
MAILTO="sjansen@cellular.de"
SUBJECT="UnitTest"
MINEXPECTEDCOVERAGE="75.0" # amount of minimal expected code coverage in %

# search for all files in directory ending with *.gnco
for srcfile in *.gcno
do
    # create gcov output for sourcefile and write stdout and stderr to nowhere
    gcov -c -a $srcfile > /dev/null 2> /dev/null
done
# path to logfile
LOGFILE=~/UnitTestScripts/codeCoverage.log
# run perl-script to sum up code coverage and save it as a logfile
if [ $(perl -CS ~/UnitTestScripts/check-coverage.pl *.gcov > $LOGFILE) ] ; then
    exit 0
#echo "check"
# if code coverage is less than 100% print out all untested lines of code
else
    grep -E -A0 -B0 '#####' *.gcov >> $LOGFILE
    # get total amount of code coverage
    CODECOVERAGE=$(grep 'TOTAL' $LOGFILE | grep -o '[0-9.]\+%' | grep -o '[0-9.]\+')
    # send some nice congratulation mail, if expected code coverage is reached
    if [ $(echo "$CODECOVERAGE > $MINEXPECTEDCOVERAGE" | bc) -ne 0 ] ; then
        EMAILMESSAGE="emailmessageUnitTest.txt"
        echo "Unit Logic Test SUCCEDED"> $EMAILMESSAGE
        echo "Congratulations! You reached $CODECOVERAGE% of CodeCoverage!" >>$EMAILMESSAGE
        #mail -s $SUBJECT $MAILTO < $EMAILMESSAGE
    # or send logfile with untested lines of code
    else
        mail -s $SUBJECT $MAILTO < $LOGFILE
    fi
#exit 1
fi

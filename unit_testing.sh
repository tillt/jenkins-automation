#!/bin/sh
SIMULATORSDK=$1
UNITTESTS=$2

# Path to code coverage files
COVERAGEDIR=$(xcodebuild -scheme UnitTest -sdk $SIMULATORSDK -configuration UnitTest TEST_AFTER_BUILD=YES ONLY_ACTIVE_ARCH=NO -showBuildSettings | grep CONFIGURATION_TEMP_DIR -m1 | grep -o '/.\+$')
echo "COVERAGE_DIR"
echo $COVERAGEDIR
# kill Simulator
sh ~/UnitTestScripts/kill_simulator.sh
# run unit tests
# OCUnit2JUnit Results
xcodebuild -scheme UnitTest -sdk $SIMULATORSDK -configuration UnitTest TEST_AFTER_BUILD=YES ONLY_ACTIVE_ARCH=NO clean build 2>&1 | /Library/Ruby/Gems/1.8/gems/ocunit2junit-1.2/bin/ocunit2junit
# custom HTML Results
xcodebuild -scheme UnitTest -sdk $SIMULATORSDK -configuration UnitTest TEST_AFTER_BUILD=YES ONLY_ACTIVE_ARCH=NO clean build >$WORKSPACE/TestResults/UnitTesting.log
# run test parser to render some beautiful HTML output
sh ~/UnitTestScripts/unit_test_result_parser.sh $WORKSPACE/TestResults/UnitTesting.log $WORKSPACE/TestResults/UnitTesting.html $WORKSPACE/TestResults/IntermediateLog.log
# go to coverage directory
COVERAGEDIR=$COVERAGEDIR/$UNITTESTS.build/Objects-normal/i386/
cd $COVERAGEDIR
# run gcov_script to generate coverage results
#sh ~/UnitTestScripts/gcov_script.sh
for srcfile in *.gcno
do
# create gcov output for sourcefile and write stdout and stderr to nowhere
gcov -c -a $srcfile > /dev/null 2> /dev/null
done

ruby ~/UnitTestScripts/gcovr . --object-directory $COVERAGEDIR --exclude '.*Test.*' --exclude '.*ExternalFrameworks.*' --xml > $WORKSPACE/coverage/coverage.xml
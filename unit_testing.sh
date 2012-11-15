#!/bin/sh
SIMULATORSDK=$1
UNITTESTS=$2

# Path to code coverage files
COVERAGEDIR=$(xcodebuild -scheme UnitTest -sdk $SIMULATORSDK -configuration Coverage TEST_AFTER_BUILD=YES ONLY_ACTIVE_ARCH=NO -showBuildSettings | grep CONFIGURATION_TEMP_DIR -m1 | grep -o '/.\+$')
# kill Simulator
sh ~/UnitTestScripts/kill_simulator.sh
# run unit tests
xcodebuild -scheme UnitTest -sdk $SIMULATORSDK -configuration UnitTest TEST_AFTER_BUILD=YES ONLY_ACTIVE_ARCH=NO clean build >$WORKSPACE/TestResults/UnitTesting.log
# run test parser to render some beautiful HTML output
sh ~/UnitTestScripts/unit_test_result_parser.sh $WORKSPACE/TestResults/UnitTesting.log $WORKSPACE/TestResults/UnitTesting.html $WORKSPACE/TestResults/IntermediateLog.log
# go to coverage directory
COVERAGEDIR=$COVERAGEDIR/$UNITTESTS.build/Objects-normal/i386/
cd $COVERAGEDIR
# run gcov_script to generate coverage results
sh ~/UnitTestScripts/gcov_script.sh

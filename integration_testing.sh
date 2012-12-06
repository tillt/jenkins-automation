#!/bin/sh
SIMULATORSDK=$1
APPNAME=$2
UIAUTOMATIONPREFIX=$3
UIAUTOMATIONTESTPATH=$4
IS_UNIVERSAL=$5

TESTRESULTSPATH=$UIAUTOMATIONPREFIX/TestResults 

# boolean value for testResults
TESTSUCCESSFUL=false

# save the date/time at first to be able to compare with the build-time later
NOW=$(date +%d.%m.%y/%T)
# create a nice title including the BuildNumber and the Date (stored in first line of this script)
SUBJECT="Build: "$BUILD_NUMBER
SUBJECT=$SUBJECT" - Date:"
SUBJECT=$SUBJECT$NOW

echo "IS_UNIVERSAL:"
echo $IS_UNIVERSAL

RESULT_IPAD=0
RESULT_IPHONE=0

# run Instruments from command line combined with the *.app file and the JavaScript test script. Results for every run in Instruments are stored in $WORKSPACE/TestResults.
# stdout is passed to an log-File just for this command
if [ ${IS_UNIVERSAL} -ne 1 ] ; then
echo "run iPhone/iPad-only UITest"
    # build the project especially with Debug-scheme on iOS Simulator to make this build runnable with instruments (make sure architecture i386 is enabled in debug scheme)
    xcodebuild -arch i386 -configuration Debug -sdk $SIMULATORSDK clean build

xcrun instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $WORKSPACE/build/Debug-iphonesimulator/$APPNAME.app -e UIASCRIPT $UIAUTOMATIONTESTPATH.js -e UIARESULTSPATH $WORKSPACE/TestResults 1>IntegrationTest.log
else
echo "run iPhone UI Test"
    # build the iPhone app
    xcodebuild -arch i386 -configuration Debug -sdk $SIMULATORSDK TARGETED_DEVICE_FAMILY=1 clean build

    # run iPhone UI Test
    xcrun instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $WORKSPACE/build/Debug-iphonesimulator/$APPNAME.app -e UIASCRIPT ${UIAUTOMATIONTESTPATH}_iphone.js -e UIARESULTSPATH $WORKSPACE/TestResults 1>IntegrationTest_iPhone.log


    # if some tests of UIAutomation fail a Message containing the word "Fail" will be presented in the log-file
    # search for "Fail:" and count the number of occurrences
    RESULT_IPHONE=$(grep "Fail:" -F IntegrationTest_iPhone.log | wc -l)

    # locating the active run (latest run)
    ACTIVE_RUN=$(ls -1t ${WORKSPACE}/TestResults|grep "Run" -m1)

    # transform the resulting PLIST into some nice HTML
    xsltproc --stringparam Title "${SUBJECT}" --stringparam ScreenshotPathPrefix "${ACTIVE_RUN}/" --stringparam SmileyPathPrefix "/userContent/TestResults/images/" --output "${WORKSPACE}/TestResults/IntegrationTesting_iPhone.html" ~/UnitTestScripts/integration_test_result_transform.xsl "${WORKSPACE}/TestResults/${ACTIVE_RUN}/Automation Results.plist"


    echo "run iPad UI Test"
    # build the iPad app
    xcodebuild -arch i386 -configuration Debug -sdk $SIMULATORSDK TARGETED_DEVICE_FAMILY=2 clean build

    # run iPad UI Test
    xcrun instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $WORKSPACE/build/Debug-iphonesimulator/$APPNAME.app -e UIASCRIPT ${UIAUTOMATIONTESTPATH}_ipad.js -e UIARESULTSPATH $WORKSPACE/TestResults 1>IntegrationTest.log

fi

# remove all *.trace files because in most cases they are broken and we don't need them (-> garbage), because we have all necessary information in the log-file
rm -r $WORKSPACE/*.trace

# if some tests of UIAutomation fail a Message containing the word "Fail" will be presented in the log-file
# search for "Fail:" and count the number of occurrences
RESULT_IPAD=$(grep "Fail:" -F IntegrationTest.log | wc -l)

# locating the active run (latest run)
ACTIVE_RUN=$(ls -1t ${WORKSPACE}/TestResults|grep "Run" -m1)

# transform the resulting PLIST into some nice HTML
xsltproc --stringparam Title "${SUBJECT}" --stringparam ScreenshotPathPrefix "${ACTIVE_RUN}/" --stringparam SmileyPathPrefix "/userContent/TestResults/images/" --output "${WORKSPACE}/TestResults/IntegrationTesting.html" ~/UnitTestScripts/integration_test_result_transform.xsl "${WORKSPACE}/TestResults/${ACTIVE_RUN}/Automation Results.plist"

echo "iPadResult:"
echo $RESULT_IPAD
echo "iPhoneResult"
echo $RESULT_IPHONE

if [ $RESULT_IPAD -ne 0 ] || [ $RESULT_IPHONE -ne 0 ]
then
echo "some UI tests failed!"
# exit this script with 1 to tell Jenkins that this build didn't complete successfully
exit 1
fi

exit 0

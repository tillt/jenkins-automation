# CONSTANTS (PLEASE ADJUST FOR THIS JOB)
# project name prefix without *.xcodeproj
PROJECT_PREFIX="LobotomatRulez"
# the app's name (compare with product name in Xcode!) without *.app
APPNAME="${PROJECT_PREFIX}_iPad"
# path to *.plist file of this App
PLISTPATH="$WORKSPACE/$APPNAME-Info.plist"
# path to the Xcode project file
XCODEPROJECTPATH="$WORKSPACE/$APPNAME.xcodeproj"
# name of the InHouse scheme
INHOUSE_SCHEME="ReleaseInHouse"
# name of the AdHoc scheme
ADHOC_SCHEME="ReleaseAdHoc"
# name of IPA InHouse file (it's your choice)
INHOUSE_IPA_NAME="${PROJECT_PREFIX}_InHouse"
# name of IPA AdHoc file (it's your choice)
ADHOC_IPA_NAME="${PROJECT_PREFIX}_AdHoc"

## unit test specifics
UNITTESTNAME="${APPNAME}_Tests"

## integration test specifics
# subfolder within project that contains the integration tests
UIAUTOMATIONPREFIX="${WORKSPACE}/${APPNAME}_Tests/${PROJECT_PREFIX}_Integration_Tests"
# path to UIAutomation root test script (JavaScript-File)
UIAUTOMATIONTESTPATH="${UIAUTOMATIONPREFIX}/integration_tests.js"

## simulator test specifics
# simulator sdk version for integration tests
SIMULATORSDK="iphonesimulator6.0"

# get the date of the last successful build by the date the changelog-file of the build was created
# this is important to get all git commits since this date to write releaseNotes
LASTSUCCESSFUL="$(date -j -f "%s" "$(stat -f %m $WORKSPACE/../lastSuccessful/changelog.xml)")"

# if the user enabled unit testing (checkbox in Jenkins), run the tests before building the App
if [ $Unit_Logic_Test == true ]; then
  RESULT=$(/bin/sh ~/UnitTestScripts/unit_testing.sh $SIMULATORSDK $UNITTESTNAME)
  if [ $RESULT -ne 0 ]; then
    echo "**** unit testing FAILED ****"
    exit 1
  fi
  echo "==== unit testing succeeded ===="
fi

# if the user enabled UIAutomation testing (checkbox in Jenkins), run the tests before building the App
if [ $UIAutomation_Test == true ]; then
  RESULT=$(/bin/sh ~/UnitTestScripts/integration_testing.sh $SIMULATORSDK $APPNAME $UIAUTOMATIONPREFIX $UIAUTOMATIONTESTPATH)
  if [ $RESULT -ne 0 ]; then
    echo "**** integration testing FAILED ****"
    exit 1
  fi
  echo "==== integration testing succeeded ===="

  # get the bundleIdentifier from *.plist
  BUNDLEIDENTIFIER=$(awk -F"[<>]" '/CFBundleIdentifier/ {getline; print $3; exit}' $PLISTPATH)
  # WRITING RELEASE NOTES
  # get just the subjects of git commits since the lastSuccessful build-date (created in first line of this script)
  # remove duplicated entries
  # for every line in stdout append a "- " before subject and a "<br />" html tag after this line.
  # write the whole stdout with all commits into a html-file to provide releaseNotes in HockeyKit
  git log --no-merges --pretty="%s" --since="$LASTSUCCESSFUL" | uniq | while read line; do echo "- ""$line""<br />"; done > /Applications/XAMPP/xamppfiles/htdocs/hockey/$BUNDLEIDENTIFIER/releaseNotes.html
fi

# clear all artefacts from former builds
/usr/bin/python ~/Documents/Jenkins/clear_artefacts.py

# update the version number within the PLIST 
/usr/bin/python /Users/atkins/Documents/Jenkins/UpdatePlistVersion.py $PLISTPATH
# build of the in-house-version
/usr/bin/xcodebuild -scheme $INHOUSE_SCHEME -project $XCODEPROJECTPATH
# render an IPA from that App
/usr/bin/python ~/Documents/Jenkins/create_ipa_to_dist.py $WORKSPACE/build/$INHOUSE_SCHEME-iphoneos/$APPNAME.app $PLISTPATH $INHOUSE_IPA_NAME
# render a Hokey version from that App
/usr/bin/python ~/Documents/Jenkins/prepare_for_ota_dist.py $PLISTPATH

# build the ad-hoc-version
/usr/bin/xcodebuild -scheme $ADHOC_SCHEME -project $XCODEPROJECTPATH
# render an IPA from that App
/usr/bin/python ~/Documents/Jenkins/create_ipa_to_dist.py $WORKSPACE/build/$ADHOC_SCHEME-iphoneos/$APPNAME.app $PLISTPATH $ADHOC_IPA_NAME

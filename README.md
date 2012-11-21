# jenkins-automation
===
###Jenkins Testing Integration

jenkins-automation is a toolbox for automated test coverage of iOS apps using the continuous integration server [Jenkins](http://jenkins-ci.org). 

#####Coverage

- Logic Testing via SenTestingKit (OCUnit)
- Application Testing via SenTestingKit (OCUnit)
- Integration (User Interface) Testing via UIAutomation

## Prerequisites

- [Jenkins](http://jenkins-ci.org)
- [Xcode 4.x](https://developer.apple.com/xcode/)
- [ios-sim](https://github.com/phonegap/ios-sim) 
- [OCUnit2JUnit](https://github.com/ciryon/OCUnit2JUnit)




## How To Get Started
 
First of all install the prerequisites listed above!

===
#####Jenkins Build Script

######build.sh

Automatically calls unit_testing.sh and integration_testing.sh
You may modify some constants in this script:

* PROJECT_PREFIX
* APPNAME
* PLISTPATH
* XCODEPROJECTPATH
* INHOUSE_SCHEME
* ADHOC_SCHEME
* INHOUSE_IPA_NAME
* ADHOC_IPA_NAME
* UNITTESTNAME
* UIAUTOMATIONPREFIX
* UIAUTOMATIONTESTPATH
* SIMULATORSDK

===
#####Unit Testing Execution Script

######unit_testing.sh

Parameter:

* SDK name
* unit test target name

Example:

```
/bin/sh unit_testing.sh iphonesimulator MyAppTests
```
HTML result example: 

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/Screenshots/unitTest_Screenshot.png)

Note: Jenkins is already pre-configured to support test results. But this support only covers JUnit test results (xml). After installing OCUnit2JUnit the build script will automatically convert OCUnit test results to JUnit test results and Jenkins will support some really nice charts! 

===
#####Integration Testing Execution Script

######integration_testing.sh

Parameter:
 
* SDK name
* app name
* UIAutomation prefix
* UIAutomation test path

Example:

```
/bin/sh integration_testing.sh iphonesimulator MyApp foo bar
```
===
#####Integration Testing Transformer Stylesheet

######integration_test_result_transform.xsl


Parameter:

* Title
* ScreenshotPathPrefix
* SmileyPathPrefix

Example:

```
xsltproc --stringparam Title "FooBar" --stringparam ScreenshotPathPrefix "test/" --stringparam SmileyPathPrefix "foo/" -output out.html transform.xsl Automation\ Results.plist
```

===

## Requirements (Xcode)

To be able to use all these scripts, you have to make some modifications in your Xcode project to support testing with OCUnit.

##### Build Configurations

At first duplicate the Debug Build Configuration and call it "UnitTest".

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/Screenshots/Xcode_BuildConfiguration.png)

It's important to enable i386 as valid architecture for these new Build Settings.

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/Screenshots/Valid_Archs.png)

Search for "Test After Build" and set the value to "YES".

Last but not least set "Generate Test Coverage Files" and "Instrument Program Flow" to "YES".

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/Screenshots/OtherBuildSettings.png)


##### Schemes

You have to create a scheme called "UnitTest". This could be a duplicate of the Debug-Scheme.

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/Screenshots/Xcode_Schemes.png)

Make sure to have enabled the test bundle to run in "Build" category (list on the left) and use your Build Configuration "UnitTest" in "Test" category.

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/Screenshots/Xcode_UnitTest.png)


##### Targets (Only important to enable Application Tests)

NOTE: if you just like to run Logic Tests, you can skip reading this chapter.

###### Modify Xcode

Disclaimer: changig your Xcode configuration file may prevent you using Xcode! Be careful while make the following changes!

Open this file in some text editor with root previleges:
_/Developer/Platforms/iPhoneSimulator.platform/Developer/Tools/RunPlatformUnitTests_

Go to line 95 and search for:

```
Warning ${LINENO} "Skipping tests; the iPhoneSimulator platform does not currently support application-hosted tests (TEST_HOST set)."
```
Put some "#" in front of these lines to disable execution. Now you don't get a warning if you try to run Application Tests from command line.


###### Build Phases (Run Script)

Click on your project file in Xcode and choose the Application Test Target in list to edit the Build Phases.

Expand "Run Script" and put in the following code snipplet (*unit_testing_build_phase.sh*):

```
echo "<<UNIT_TEST_MARKER>>"
test_bundle_path="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.$WRAPPER_EXTENSION"
environment_args="--setenv DYLD_INSERT_LIBRARIES=/../../Library/PrivateFrameworks/IDEBundleInjection.framework/IDEBundleInjection --setenv XCInjectBundle=$test_bundle_path --setenv XCInjectBundleInto=$TEST_HOST"
ios-sim launch $(dirname $TEST_HOST) $environment_args --args -SenTest All $test_bundle_path
echo "Finished running tests with ios-sim"
echo "<<UNIT_TEST_MARKER>>"
```
This allows you to run Application Test with xcodebuild.

===

## Contact


### Creators

[Sven Jansen](http://github.com/macsven)  
[Till Toenshoff](http://github.com/lobotomat)  

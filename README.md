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




## How To Get Started 
to be filled with content

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

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/unitTest_Screenshot.png)

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

###### Build Configurations

At first duplicate the Debug Build Configuration and call it "UnitTest".

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/unitTest_Screenshot.png)

It's important to enable i386 as valid architecture for this new Build Settings.

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/unitTest_Screenshot.png)

Search for "Test After Build" and set the value to "YES".

Last but not least set "Generate Test Coverage Files" and "Instrument Program Flow" to "YES".

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/unitTest_Screenshot.png)


###### Schemes
You have to create a scheme called "UnitTest". This could be a duplicate of the Debug-Scheme.

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/unitTest_Screenshot.png)

Make sure to have enabled the test bundle to run in "Build" category (list on the left) and use your Build Configuration "UniTest" for "Test" category.

![ScreenShot](https://raw.github.com/lobotomat/jenkins-automation/master/unitTest_Screenshot.png)

===

## Contact


### Creators

[Sven Jansen](http://github.com/macsven)  
[Till Toenshoff](http://github.com/lobotomat)  

# jenkins-automation
===
###Jenkins Testing Integration

jenkins-automation is a toolbox for automated test coverage of iOS apps using the continuous integration server [Jenkins](http://jenkins-ci.org). 

#####Coverage

- Logic Testing via SenTestingKit
- Application Testing via SenTestingKit
- Integration Testing via UIAutomation

## Prerequisites

- [Jenkins](http://jenkins-ci.org)
- [Xcode 4.x](https://developer.apple.com/xcode/)
- [ios-sim](https://github.com/phonegap/ios-sim) 




## How To Get Started 
to be filled with content

===
#####Jenkins Build Script

######build.sh

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

## Contact


### Creators

[Sven Jansen](http://github.com/macsven)  
[Till Toenshoff](http://github.com/lobotomat)  

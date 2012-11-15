jenkins-automation
==================

Jenkins UIAutomation Integration


Build Script

Parameter:

* SimlatorSDK
* AppName
* UIAutomationPrefix
* UIAutomationTestPath


Transformer XSLT

Parameter:
Title
ScreenshotPathPrefix
SmileyPathPrefix

Example - running the transformation:
```
xsltproc --stringparam Title "FooBar" --stringparam ScreenshotPathPrefix "test/" --stringparam SmileyPathPrefix "foo/" -output out.html transform.xsl Automation\ Results.plist
```


jenkins-automation
==================

Jenkins UIAutomation Integration

Transformer XSLT

Parameter:
ScreenshotPathPrefix
SmileyPathPrefix

Example - running the transformation:
```
xsltproc --stringparam ScreenshotPathPrefix "test/" --stringparam SmileyPathPrefix "foo/" -output out.html transform.xsl Automation\ Results.plist
```
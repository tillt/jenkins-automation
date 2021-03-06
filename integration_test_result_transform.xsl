<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>UIAutomation Test Result Report</title>
				<link rel="stylesheet" type="text/css" href="/static/f15a856f/css/style.css" />
				<style TYPE="text/css">
					<xsl:text disable-output-escaping="yes"><![CDATA[<!-- tr:nth-child(even) { background-color: #EEEEFF; } -->]]></xsl:text>
				</style>
			</head>
			<body>
				<h1>UIAutomation Test Result Report: <xsl:copy-of select="$Title"/></h1>
				<table border="0" style="width:100%">
					<tr>
					<th>Timestamp</th>
					<th>Sequence</th>
					<th><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
					<th>Result</th>
					<th>Message</th>
					<th>Screenshot</th>
					</tr>
					<xsl:for-each select="plist/dict/array/dict">
						<xsl:variable name="Type"><xsl:value-of select="./integer[preceding-sibling::key='Type'][1]"/></xsl:variable>
						<xsl:variable name="LogType"><xsl:value-of select="./string[preceding-sibling::key='LogType'][1]"/></xsl:variable>
						<xsl:variable name="Message"><xsl:value-of select="./string[preceding-sibling::key='Message'][1]"/></xsl:variable>
						<xsl:variable name="Screenshot"><xsl:value-of select="./string[preceding-sibling::key='Screenshot'][1]"/></xsl:variable>
						<xsl:if test="$Type = '4' or $Type = '7'">
							<xsl:if test="($LogType = 'Pass') or (($LogType = 'Error' or $LogType = 'Fail') and $Type = '7')">
                                <tr>
									<td>
										<xsl:value-of select="translate(translate(date, 'T',' '), 'Z','')"/>
									</td>
									<td>
										<xsl:value-of select="position()"/>
									</td>
									<td>
										<xsl:text disable-output-escaping="yes"><![CDATA[<img src="]]></xsl:text><xsl:copy-of select="$SmileyPathPrefix"/><xsl:copy-of select="$LogType"/><xsl:text disable-output-escaping="yes"><![CDATA[.png" width="20px"/>]]></xsl:text>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="$LogType = 'Pass'">
												<span style="color:green"><xsl:copy-of select="$LogType"/></span>
											</xsl:when>
											<xsl:when test="$LogType = 'Error' or $LogType = 'Fail'">
												<span style="color:red"><xsl:copy-of select="$LogType"/></span>
											</xsl:when>
										</xsl:choose>
									</td>
									<td>
										<xsl:copy-of select="$Message"/>
									</td>
									<td>
										<xsl:if test="$Screenshot != ''">
											<xsl:element name="a">
											<xsl:attribute name="href">
											<xsl:copy-of select="$ScreenshotPathPrefix"/><xsl:copy-of select="$Message"/><xsl:text disable-output-escaping="yes"><![CDATA[.png]]></xsl:text>
											</xsl:attribute>
											<xsl:text disable-output-escaping="yes"><![CDATA[<img src="]]></xsl:text><xsl:copy-of select="$ScreenshotPathPrefix"/><xsl:copy-of select="$Message"/><xsl:text disable-output-escaping="yes"><![CDATA[.png" width="80px"/>]]></xsl:text>
											</xsl:element>
										</xsl:if>
									</td>
	                          	</tr>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
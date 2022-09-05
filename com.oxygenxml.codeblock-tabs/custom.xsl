<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs oxy"
  version="2.0" xmlns:oxy="http://www.oxygenxml.com/oxy">
  <xsl:include href="tabbed-codeblock.xsl"/>
  <xsl:include href="tabbed-steps.xsl"/>
  
  <!-- Compute unique ID -->
  <xsl:function name="oxy:computeUniqueID">
    <xsl:param name="context" as="node()"/>
    <xsl:choose>
      <xsl:when test="$context/../@id">
        <xsl:value-of select="$context/../@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($context)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
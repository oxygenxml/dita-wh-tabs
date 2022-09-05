<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs oxy"
    version="2.0"
    xmlns:oxy="http://www.oxygenxml.com/oxy">
  
    <xsl:param name="tabs.for.steps"/>
    
  <!-- Show steps in separate tabs -->
  <xsl:template match="steps[$tabs.for.steps='true']">
    <!-- Create the navigation tabs -->
    <ul class="nav nav-tabs" role="tablist">
      <xsl:attribute name="id" select="@id"/>
      <!-- For all consecutive code blocks -->
      <xsl:for-each select="step">
        <xsl:call-template name="createStepNavItem">
          <xsl:with-param name="position" select="position()"/>
          <xsl:with-param name="context" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </ul>
    <!-- The tab content -->
    <div class="tab-content">
      <!-- For all consecutive steps -->
      <xsl:for-each select="step">
        <div role="tabpanel">
          <xsl:call-template name="createTabpanelStepAttrs">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="context" select="."/>
          </xsl:call-template>
          <xsl:variable name="content">
            <xsl:apply-templates select="."/>
          </xsl:variable>
          <div>
            <xsl:copy-of select="$content/*/@*"/>
            <xsl:copy-of select="$content/*/node()"/>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  
    <!-- Create the tabbed pane attributes -->
   <xsl:template name="createTabpanelStepAttrs">
        <xsl:param name="position"/>
        <xsl:param name="context"/>
        <xsl:variable name="uniqueID" select="oxy:computeUniqueID(.)"/>
        <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="$position = 1">
                    <xsl:value-of select="'tab-pane fade show active'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'tab-pane fade'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="id" select="concat($uniqueID, '-', position(), '-step')"/>
        <xsl:attribute name="aria-labelledby" select="concat($uniqueID, '-', position(), '-tab')"/>
    </xsl:template>
    
  <!-- Create navigation item -->
  <xsl:template name="createStepNavItem">
    <xsl:param name="context"/>
    <xsl:param name="position"/>
    <xsl:variable name="uniqueID" select="oxy:computeUniqueID(.)"/>
    <li class="nav-item">
      <!-- active if first -->
      <a class="nav-link" data-toggle="tab" role="tab" aria-selected="true">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$position = 1">
              <xsl:value-of select="'nav-link active'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'nav-link'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="id" select="concat($uniqueID, '-', $position, '-tab')"/>
        <xsl:attribute name="aria-controls" select="concat($uniqueID, '-', $position, '-step')"/>
        <xsl:attribute name="href" select="concat('#', $uniqueID, '-', $position, '-step')"/>
        <xsl:value-of select="concat('Step ', $position)"/>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>
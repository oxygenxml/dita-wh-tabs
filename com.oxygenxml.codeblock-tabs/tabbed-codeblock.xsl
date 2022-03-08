<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:oxy="http://www.oxygenxml.com/oxy">
    
    <xsl:variable name="language-names">
        <entry key="bourne">Bash</entry>
        <entry key="xml">XML</entry>
        <entry key="java">Java</entry>
        <entry key="css">CSS</entry>
        <entry key="javascript">JavaScript</entry>
        <entry key="json">JSON</entry>
        <entry key="sql">SQL</entry>
        <entry key="c">C</entry>
        <entry key="cpp">C++</entry>
        <entry key="csharp">C#</entry>
        <entry key="ini">Ini</entry>
        <entry key="python">Python</entry>
        <entry key="ruby">Ruby</entry>
        <entry key="perl">Perl</entry>
        <entry key="php">Php</entry>
        <entry key="lua">Lua</entry>
        <entry key="go">Go</entry>
    </xsl:variable>
    
    <!-- Code blocks added to a figure -->
    <xsl:template match="fig[@outputclass='tabbed-codeblock']">
        <!-- The tabs list -->
        <ul class="nav nav-tabs" role="tablist">
            <xsl:attribute name="id" select="@id"/>
            <xsl:for-each select="./codeblock">
                <xsl:call-template name="createNavItem">
                    <xsl:with-param name="position" select="position()"/>
                    <xsl:with-param name="context" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </ul>
        <!-- The content for each tab -->
        <div class="tab-content">
            <xsl:for-each select="codeblock">
                <xsl:variable name="language" select="oxy:computeLanguage(.)"/>
                <div role="tabpanel">
                    <xsl:call-template name="createTabpanelAttrs">
                        <xsl:with-param name="language" select="$language"/>
                        <xsl:with-param name="position" select="position()"/>
                        <xsl:with-param name="context" select="."/>
                    </xsl:call-template>
                    <xsl:apply-templates select="."/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!-- Match the first code block which is followed by other consecutive code blocks containing an output class -->
    <xsl:template match="codeblock[@outputclass][(following-sibling::*)[1][local-name()='codeblock'][@outputclass]][not(preceding-sibling::*[local-name()='codeblock'][@outputclass])][not(parent::fig[@outputclass='tabbed-codeblock'])]">
        <xsl:variable name="curentContent">
            <xsl:next-match/>
        </xsl:variable>
        <!-- Create the navigation tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <xsl:attribute name="id" select="@id"/>
            <!-- For all consecutive code blocks -->
            <xsl:for-each select=".|following-sibling::*[@outputclass][(preceding-sibling::*)[last()][local-name()='codeblock'][@outputclass]]">
                <xsl:call-template name="createNavItem">
                    <xsl:with-param name="position" select="position()"/>
                    <xsl:with-param name="context" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </ul>
        <!-- The tab content -->
        <div class="tab-content">
            <!-- For all consecutive code blocks -->
            <xsl:for-each select=".|following-sibling::*[@outputclass][(preceding-sibling::*)[last()][local-name()='codeblock'][@outputclass]]">
                <xsl:variable name="language" select="oxy:computeLanguage(.)"/>
                <div role="tabpanel">
                    <xsl:call-template name="createTabpanelAttrs">
                        <xsl:with-param name="language" select="$language"/>
                        <xsl:with-param name="position" select="position()"/>
                        <xsl:with-param name="context" select="."/>
                    </xsl:call-template>
                    <xsl:choose>
                        <xsl:when test="position() = 1">
                            <xsl:copy-of select="$curentContent"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="ignore" select="false()"/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!-- Match codeblocks immediately following another. -->
    <xsl:template match="codeblock[@outputclass][(preceding-sibling::*)[last()][local-name()='codeblock'][@outputclass]][not(parent::fig[@outputclass='tabbed-codeblock'])]">
        <!-- Ignore processing for codeblocks which are consecutive to the first one -->
        <xsl:param name="ignore" select="true()"/>
        <xsl:if test="not($ignore)">
            <xsl:next-match/>
        </xsl:if>
    </xsl:template>
    
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
    <!-- Create the tabbed pane attributes -->
    <xsl:template name="createTabpanelAttrs">
        <xsl:param name="language"/>
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
        <xsl:attribute name="id" select="concat($uniqueID, '-', $language, '-code')"/>
        <xsl:attribute name="aria-labelledby" select="concat($uniqueID, '-', $language, '-tab')"/>
    </xsl:template>
    
    <!-- Create navigation item -->
    <xsl:template name="createNavItem">
        <xsl:param name="context"/>
        <xsl:param name="position"/>
        <xsl:variable name="uniqueID" select="oxy:computeUniqueID(.)"/>
        <li class="nav-item">
            <!-- active if first -->
            <xsl:variable name="language" select="oxy:computeLanguage($context)"/>
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
                <xsl:attribute name="id" select="concat($uniqueID, '-', $language, '-tab')"/>
                <xsl:attribute name="aria-controls" select="concat($uniqueID, '-', $language, '-code')"/>
                <xsl:attribute name="href" select="concat('#', $uniqueID, '-', $language, '-code')"/>
                <xsl:value-of select="$language-names/entry[@key = $language]"/>
            </a>
        </li>
    </xsl:template>
    
    <!-- Compute language -->
    <xsl:function name="oxy:computeLanguage">
        <xsl:param name="context" as="node()"/>
        <xsl:choose>
            <xsl:when test="starts-with($context/@outputclass, 'language-')">
                <xsl:value-of select="substring-after($context/@outputclass, 'language-')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$context/@outputclass"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
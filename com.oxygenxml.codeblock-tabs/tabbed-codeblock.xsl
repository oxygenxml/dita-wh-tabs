<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
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
    
    <xsl:template match="fig[@outputclass='tabbed-codeblock']">
        <ul class="nav nav-tabs" role="tablist">
            <xsl:attribute name="id" select="@id"/>
            <xsl:for-each select="./codeblock">
                <li class="nav-item">
                    <!-- active if first -->
                    <xsl:variable name="language" select="substring-after(@outputclass, 'language-')"/>
                    <a class="nav-link" data-toggle="tab" role="tab" aria-selected="true">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="position()=1">
                                    <xsl:value-of select="'nav-link active'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'nav-link'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="id" select="concat(../@id, '-', $language, '-tab')"/>
                        <xsl:attribute name="aria-controls" select="concat(../@id, '-', $language, '-code')"/> 
                        <xsl:attribute name="href" select="concat('#', ../@id, '-', $language, '-code')"/>
                        <xsl:value-of select="$language-names/entry[@key=$language]"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul>
        <div class="tab-content">
            <xsl:for-each select="./codeblock">
                <xsl:variable name="language" select="substring-after(@outputclass, 'language-')"/>
                <div role="tabpanel">
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="position()=1">
                                <xsl:value-of select="'tab-pane fade show active'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'tab-pane fade'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="id" select="concat(../@id, '-', $language, '-code')"/>
                    <xsl:attribute name="aria-labelledby" select="concat(../@id, '-', $language, '-tab')"/> 
                    <xsl:apply-templates select="."/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>
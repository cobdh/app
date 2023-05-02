<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:utils="https://data.cobdh.org/utils"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    >
    <!-- Structure of monograph section.  -->
    <xsl:template match="tei:monogr">
        <h4>
            <xsl:if test="count(tei:editor) &gt; 0">
                <xsl:text>Published in: </xsl:text>
            </xsl:if>
            <i>
                <xsl:apply-templates select=".//tei:title"/>
            </i>
        </h4>
        <ul class="list-none">
            <xsl:for-each select=".//tei:author">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select=".//tei:editor">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </ul>
        <xsl:apply-templates select="tei:imprint"/>
    </xsl:template>
    <xsl:template match="tei:analytic">
        <h4>Article</h4>
        <ul class="list-none">
            <li>
                Title: <xsl:apply-templates select=".//tei:title"/>
            </li>
            <xsl:for-each select=".//tei:author">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <li>
                URI:
                <xsl:call-template name="resource_link">
                    <xsl:with-param name="resource" select="../@xml:id"/>
                </xsl:call-template>
            </li>
            <xsl:call-template name="external_links"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:imprint">
        <ul class="list-none">
            <xsl:if test=".//tei:date">
                <li>Date of Publication: <xsl:value-of select="//tei:date"/></li>
            </xsl:if>
            <xsl:if test=".//tei:volume">
                <li>Volume: <xsl:value-of select="//tei:volume"/></li>
            </xsl:if>
            <xsl:if test=".//tei:biblScope[@unit='volume']">
                <li>Volume: <xsl:value-of select=".//tei:biblScope[@unit='volume']"/></li>
            </xsl:if>
            <xsl:if test=".//tei:extent">
                <li>Pages: <xsl:value-of select="//tei:extent"/></li>
            </xsl:if>
            <xsl:if test=".//tei:biblScope[@unit='page']">
                <li>Pages: <xsl:value-of select=".//tei:biblScope[@unit='page']"/></li>
            </xsl:if>
            <xsl:if test=".//tei:publisher">
                <li>Publisher: <xsl:value-of select="//tei:publisher"/>(<xsl:value-of select="//tei:pubPlace"/>)</li>
            </xsl:if>
            <xsl:if test=".//tei:edition">
                <li>Edition: <xsl:value-of select="//tei:edition"/></li>
            </xsl:if>
            <!--Workaround to display Series information outside of tei:imprint-->
            <xsl:if test="./../..//tei:series/tei:title">
                <li>Series: <xsl:value-of select="./../..//tei:series/tei:title"/></li>
            </xsl:if>
        </ul>
    </xsl:template>
    <xsl:template match="tei:title">
        <xsl:value-of select="utils:improve(.)"/>
    </xsl:template>
</xsl:stylesheet>

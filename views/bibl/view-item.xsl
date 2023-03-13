<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://data.cobdh.org/bibl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <xsl:import href="../core/href.xsl"/>
    <!-- End of Import -->
    <xsl:template match="tei:biblStruct">
        <div class="container">
            <xsl:call-template name="header"/>
            <h3>Preferred Citation</h3>
            <xsl:call-template name="citation"/>
            <h3>Full Citation Information</h3>
            <xsl:call-template name="article"/>
            <xsl:call-template name="publication"/>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:biblFull">
        <div class="container">
            <xsl:call-template name="header"/>
            <h3>Preferred Citation</h3>
            <xsl:call-template name="citation"/>
            <h3>Full Citation Information</h3>
            <xsl:call-template name="article"/>
            <xsl:call-template name="publication"/>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
    <!--Render header-->
    <xsl:template name="header">
        <xsl:call-template name="print_formats"/>
        <h2><xsl:value-of select="//tei:title"/></h2>
        <small>
            <xsl:call-template name="resource_link"/>
        </small>
    </xsl:template>
    <!--Render citation-->
    <xsl:template name="citation">
        <p>
            Paul Peeters, "Le martyrologe de Rabban Ṣalība." Analecta
            <br/>
            Bollandiana, vol. 27 (1908): 129-200.
            <xsl:call-template name="copy" >
                <xsl:with-param name="text">cite</xsl:with-param>
            </xsl:call-template>
        </p>
    </xsl:template>
    <!--Render article-->
    <xsl:template name="article">
        <h4>Article</h4>
        <ul class="list-none">
            <li>
                Title: <xsl:value-of select="//tei:title"/>
            </li>
            <xsl:for-each select="//tei:author">
                <li>Author: <xsl:value-of select="."/></li>
            </xsl:for-each>
            <li>
                URI: <xsl:call-template name="resource_link"/>
            </li>
            <xsl:call-template name="external_links"/>
        </ul>
    </xsl:template>
    <!--Render publication-->
    <xsl:template name="publication">
        <h4>Publication</h4>
        <ul class="list-none">
            <xsl:if test="//tei:title">
                <li>Title: <xsl:value-of select="//tei:title"/></li>
            </xsl:if>
            <xsl:if test="//tei:date">
                <li>Date of Publication: <xsl:value-of select="//tei:date"/></li>
            </xsl:if>
            <xsl:if test="//tei:volume">
                <li>Volume: <xsl:value-of select="//tei:volume"/></li>
            </xsl:if>
            <xsl:if test="//tei:extent">
                <li>Pages: <xsl:value-of select="//tei:extent"/></li>
            </xsl:if>
            <xsl:if test="//tei:publisher">
                <li>Publisher: <xsl:value-of select="//tei:publisher"/>(<xsl:value-of select="//tei:pubPlace"/>)</li>
            </xsl:if>
            <xsl:if test="//tei:edition">
                <li>Edition: <xsl:value-of select="//tei:edition"/></li>
            </xsl:if>
        </ul>
    </xsl:template>
</xsl:stylesheet>

<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://data.cobdh.org/bibl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
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
        <h2><xsl:value-of select="//tei:title"/></h2>
        <xsl:call-template name="resource_link"/>
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
            <li>
                Zotero: http://zotero.org/groups/392292/items/R9EAZRI3
            </li>
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
    <!--Render credit information-->
    <xsl:template name="credit">
        <h3>About this Online Entry</h3>
        <h4>Additional Credit</h4>
        <div data-template="bibl:editors-request"/>
        <ul class="list-none">
            <xsl:for-each select="//tei:editor">
                <li>
                    <xsl:choose>
                        <xsl:when test="@role = 'creator'">
                            XML coded by <xsl:call-template name="editor_link"/>
                        </xsl:when>
                        <xsl:otherwise>
                            >Data entry by Robert Phenix
                        </xsl:otherwise>
                    </xsl:choose>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <!--Render licence-->
    <xsl:template name="licence">
        <h3>Licence</h3>
        <p>
            <xsl:choose>
                <xsl:when test="//tei:licence">
                    <xsl:value-of select="//tei:licence"/>
                </xsl:when>
                <xsl:otherwise>
                    The Creative Commons Attribution 3.0 Unported (CC BY
                    3.0) Licence applies to this document.
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    <!--Render resource resource_link-->
    <xsl:template name="resource_link">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <!-- TODO: REPLACE WITH app:abspath -->
                <xsl:sequence select="concat('/exist/apps/cobdh-data/', 'bibl/', @xml:id)"/>
            </xsl:attribute>
            https://cobdh.org/bibl/<xsl:value-of select=".//@xml:id"/>
        </xsl:element>
        <xsl:call-template name="copy"/>
        <br/>
    </xsl:template>
    <!--Render resource copy-->
    <xsl:template name="copy">
        <xsl:param name="text">copy</xsl:param>
        <button
            type="button"
            class="btn btn-sm btn-default copy-sm clipboard"
            title="Copies URI to clipboard"
            >
            <xsl:value-of select="$text"/>
        </button>
    </xsl:template>
    <!--Render editor-->
    <xsl:template name="editor_link">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <!-- TODO: REPLACE WITH app:abspath -->
                <xsl:sequence select="concat('/exist/apps/cobdh-data/', 'editors/', @xml:id)"/>
            </xsl:attribute>
            <xsl:value-of select=".//@xml:id"/>
        </xsl:element>
        <xsl:call-template name="copy"/>
        <br/>
    </xsl:template>
</xsl:stylesheet>

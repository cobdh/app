<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:utils="https://data.cobdh.org/utils"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!--Render citation-->
    <xsl:template name="citation">
        <p>
            <xsl:apply-templates select="." mode="citation"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="copy" >
                <xsl:with-param name="text">cite</xsl:with-param>
            </xsl:call-template>
        </p>
    </xsl:template>
    <!-- journalArticle -->
    <xsl:template match="tei:biblStruct[@type='journalArticle']" mode="citation">
        <xsl:call-template name="authors_plain"/>
        <xsl:text>, </xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:apply-templates select="utils:single(.//tei:analytic/tei:title)"/>
        <xsl:text>," </xsl:text>
        <i>
            <xsl:apply-templates select="utils:single(.//tei:monogr/tei:title)"/>
        </i>
        <xsl:text>, </xsl:text>
        <xsl:text>vol. </xsl:text>
        <xsl:value-of select=".//tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/>
        <xsl:text> </xsl:text>
        <xsl:text>(</xsl:text>
        <xsl:value-of select=".//tei:monogr/tei:imprint/tei:date"/>
        <xsl:text>)</xsl:text>
        <xsl:text>, </xsl:text>
        <xsl:value-of select=".//tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
    <!-- book and tei:biblStruct-fallback-->
    <xsl:template match="tei:biblStruct[@type='book'] | tei:biblStruct" mode="citation">
        <xsl:call-template name="authors_plain"/>
        <xsl:text>, </xsl:text>
        <!--title-->
        <i>
            <xsl:apply-templates select="utils:single(.//tei:title)"/>
        </i>
        <xsl:text> </xsl:text>
        <!--(Yale University Press, 1990).-->
        <xsl:text>(</xsl:text>
        <xsl:value-of select="utils:single(//tei:pubPlace)"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="utils:single(//tei:publisher)"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:date"/>
        <xsl:text>)</xsl:text>
        <xsl:text>.</xsl:text>
    </xsl:template>
    <!-- booksSection -->
    <xsl:template match="tei:biblStruct[@type='bookSection']" mode="citation">
        <xsl:call-template name="authors_plain"/>
        <xsl:text>, "</xsl:text>
        <!--title-->
        <xsl:apply-templates select="utils:single(.//tei:analytic/tei:title)"/>
        <xsl:text>," </xsl:text>
        <xsl:text>in </xsl:text>
        <i>
            <xsl:apply-templates select="utils:single(.//tei:monogr/tei:title)"/>
        </i>
        <xsl:text>, edited by </xsl:text>
        <xsl:call-template name="editors_plain"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select=".//tei:monogr/tei:imprint" mode="plain"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
    <!-- biblFull -->
    <xsl:template match="tei:biblFull" mode="citation">
        <xsl:call-template name="authors_plain"/>
        <xsl:text>, </xsl:text>
        <!--title-->
        <i>
            <xsl:apply-templates select="utils:single(.//tei:title)"/>
        </i>
        <!--(Yale University Press, 1990).-->
        <xsl:text> (</xsl:text>
        <xsl:value-of select=".//tei:publicationStmt/tei:publisher"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select=".//tei:publicationStmt/tei:date"/>
        <xsl:text>).</xsl:text>
    </xsl:template>
    <xsl:template name="authors_plain">
        <!--Blain Virginia, Clements Patricia and Meister Eder,-->
        <xsl:choose>
            <xsl:when test="count(.//tei:author) &gt; 1">
                <xsl:for-each select=".//tei:author">
                    <xsl:apply-templates select="." mode="plain"/>
                    <xsl:if test="position() eq last()-2">, </xsl:if>
                    <xsl:if test="position() eq last()-1"> and </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=".//tei:author" mode="plain_single"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="editors_plain">
        <!--Blain Virginia, Clements Patricia and Meister Eder,-->
        <xsl:choose>
            <xsl:when test="count(.//tei:editor) &gt; 1">
                <xsl:for-each select=".//tei:editor">
                    <xsl:apply-templates select="." mode="plain"/>
                    <xsl:if test="position() eq last()-2">, </xsl:if>
                    <xsl:if test="position() eq last()-1"> and </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=".//tei:editor" mode="plain"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:imprint" mode="plain">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="//tei:pubPlace"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="//tei:publisher"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="//tei:date"/>
        <xsl:text>), </xsl:text>
        <xsl:value-of select=".//tei:biblScope[@unit='page']"/>
    </xsl:template>
</xsl:stylesheet>

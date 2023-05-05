<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://cobdh.org/bibl"
    xmlns:utils="https://cobdh.org/utils"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <xsl:import href="../core/citation.xsl"/>
    <xsl:import href="../core/href.xsl"/>
    <xsl:import href="../core/mono.xsl"/>
    <xsl:import href="../core/persons.xsl"/>
    <xsl:import href="../core/utils.xsl"/>
    <!-- End of Import -->
    <xsl:template match="tei:biblStruct">
        <div class="col-md-8 col-lg-8">
            <xsl:call-template name="header"/>
            <h3>Preferred Citation</h3>
            <xsl:call-template name="citation"/>
            <h3>Full Citation Information</h3>
            <xsl:apply-templates select="tei:analytic"/>
            <xsl:apply-templates select="tei:monogr"/>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:biblFull">
        <div class="col-md-8 col-lg-8">
            <xsl:call-template name="header"/>
            <h3>Preferred Citation</h3>
            <xsl:call-template name="citation"/>
            <h3>Full Citation Information</h3>
            <xsl:apply-templates select="tei:analytic"/>
            <xsl:apply-templates select="tei:monogr"/>
            <xsl:call-template name="biblfull_no_analytic_monogr"/>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
    <!--Render header-->
    <xsl:template name="header">
        <xsl:call-template name="print_formats"/>
        <h2>
            <!-- TODO: IMPROVE -->
            <!--Do not render monogr title-->
            <xsl:apply-templates select="utils:single(descendant::tei:title)"/>
        </h2>
        <small>
            <xsl:call-template name="resource_link"/>
        </small>
    </xsl:template>
    <xsl:template name="biblfull_no_analytic_monogr">
        <xsl:if test="empty(.//tei:analytic) and empty(.//tei:monogr)">
            <!--TODO: UNITE WITH MONO -->
            <ul class="list-none">
                <li>
                    Title: <xsl:apply-templates select=".//tei:title"/>
                </li>
                <xsl:for-each select=".//tei:author">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
                <xsl:for-each select=".//tei:editor">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </ul>
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
                    <li>Publisher: <xsl:value-of select="//tei:publisher"/> (<xsl:value-of select="//tei:pubPlace"/>)</li>
                </xsl:if>
                <xsl:if test=".//tei:edition">
                    <li>Edition: <xsl:value-of select="//tei:edition"/></li>
                </xsl:if>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

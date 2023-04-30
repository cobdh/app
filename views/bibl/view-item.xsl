<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://data.cobdh.org/bibl"
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
            <xsl:value-of select="descendant::tei:title[1]"/>
        </h2>
        <small>
            <xsl:call-template name="resource_link"/>
        </small>
    </xsl:template>
</xsl:stylesheet>

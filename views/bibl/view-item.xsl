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
    <xsl:import href="../core/mono.xsl"/>
    <xsl:import href="../core/persons.xsl"/>
    <!-- End of Import -->
    <xsl:template match="tei:biblStruct">
        <div class="container">
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
        <div class="container">
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
            <xsl:value-of select=".//tei:title[not(ancestor::tei:monogr)]"/>
        </h2>
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
</xsl:stylesheet>

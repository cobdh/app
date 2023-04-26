<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
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

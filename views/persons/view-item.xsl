<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://data.cobdh.org/bibl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <!-- End of Import -->
    <xsl:template match="tei:person">
        <div class="container">
            <h3>Biography</h3>
            <xsl:call-template name="person_names">
                <xsl:with-param name="newline" select='1'/>
                <xsl:with-param name="name" select='1'/>
            </xsl:call-template>
            <h3>Full Citation Information</h3>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
</xsl:stylesheet>

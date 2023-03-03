<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <xsl:template match="tei:person">
        <h2><xsl:value-of select="//tei:person"/></h2>
        <hr/>
    </xsl:template>
</xsl:stylesheet>

<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    >
    <xsl:template name="external_links">
        <xsl:if test="//tei:biblStruct/@corresp">
            <li>
                Zotero: <xsl:value-of select="//tei:biblStruct/@corresp"/>
            </li>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

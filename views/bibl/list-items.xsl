<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <xsl:template match="/">
        <ul>
            <xsl:for-each select="//tei:biblFull">
                <li>
                    <!-- Example: cobdh.org/bibl/1-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            bibl/<xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                        <xsl:value-of select=".//tei:title"/>
                        ;
                        <xsl:value-of select=".//tei:date"/>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>

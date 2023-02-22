<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="1.0"
    >
    <xsl:template match="/">
        <h1>Editors</h1>
        <ul>
            <xsl:for-each select="//person">
                <li>
                    <!-- Example: cobdh.org/editor/schewe_helmut_konrad-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            editor/<xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>

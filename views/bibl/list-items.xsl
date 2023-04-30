<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:app="https://data.cobdh.org/app"
    xmlns:core="https://data.cobdh.org/core"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!--Import general methods-->
    <xsl:import href="../core/core.xsl"/>
    <!--TODO: THERE MUST BE A BETTER WAY TO AVOID THIS GLOBAL PARAMETER-->
    <xsl:param name="headline" select="''"/>
    <xsl:template match="/">
        <!--Pass headline to draw optional headline  -->
        <xsl:if test="$headline and //(tei:biblFull|tei:biblStruct)">
            <h3><xsl:value-of select="$headline"/></h3>
        </xsl:if>
        <ul>
            <xsl:for-each select="//(tei:biblFull|tei:biblStruct)">
                <li>
                    <!-- Example: cobdh.org/bibl/1-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:sequence select="core:hyper('bibl', @xml:id)"/>
                        </xsl:attribute>
                        <xsl:value-of select=".//tei:date"/>
                        <xsl:text>: </xsl:text>
                        <xsl:apply-templates select="descendant::tei:title[1]"/>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>

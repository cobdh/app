<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:app="https://cobdh.org/app"
    xmlns:core="https://cobdh.org/core"
    xmlns:utils="https://cobdh.org/utils"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!--Import general methods-->
    <xsl:import href="../core/core.xsl"/>
    <xsl:import href="../core/utils.xsl"/>
    <!--TODO: THERE MUST BE A BETTER WAY TO AVOID THIS GLOBAL PARAMETER-->
    <xsl:param name="headline" select="''"/>
    <xsl:param name="style" select="''"/>
    <xsl:template match="tei:listBibl">
        <!--Pass headline to draw optional headline  -->
        <xsl:if test="$headline and //(tei:biblFull|tei:biblStruct)">
            <h3><xsl:value-of select="$headline"/></h3>
        </xsl:if>
        <ul class="list-none mt-2">
            <xsl:for-each select="//(tei:biblFull|tei:biblStruct)">
                <li style="margin-bottom:5px">
                    <!-- Example: cobdh.org/bibl/1-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:sequence select="core:hyper('bibl', @xml:id)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$style eq ''">
                                <!--Default style: Use year and title-->
                                <xsl:value-of select=".//tei:date"/>
                                <xsl:text>: </xsl:text>
                                <xsl:apply-templates select="utils:single(descendant::tei:title)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--Use citation style-->
                                <xsl:apply-templates select="." mode="citation"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>

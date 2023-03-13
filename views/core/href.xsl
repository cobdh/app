<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    >
    <xsl:template name="external_links">
        <xsl:if test="//tei:biblStruct/@corresp">
            <li>
                Zotero:
                <xsl:text> </xsl:text>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:sequence select="//tei:biblStruct/@corresp"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">blank</xsl:attribute>
                    <xsl:value-of select="//tei:biblStruct/@corresp"/>
                </xsl:element>
            </li>
        </xsl:if>
    </xsl:template>
    <!--Render resource resource_link-->
    <xsl:template name="resource_link">
        <xsl:param name="collection">bibl</xsl:param>
        <xsl:param name="resource" select="@xml:id"/>
        <xsl:element name="a">
            <xsl:attribute name="href">
                <!-- TODO: REPLACE WITH app:abspath -->
                <xsl:sequence select="concat('/exist/apps/cobdh-data/', $collection, '/', $resource)"/>
            </xsl:attribute>
            https://cobdh.org/bibl/<xsl:value-of select="$resource"/>
        </xsl:element>
        <!-- <xsl:call-template name="copy"/> -->
        <br/>
    </xsl:template>
</xsl:stylesheet>

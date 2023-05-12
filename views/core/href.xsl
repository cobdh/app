<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:core="https://cobdh.org/core"
    version="1.0"
    >
    <!--Render resource resource_link-->
    <xsl:template name="resource_link">
        <xsl:param name="collection">bibl</xsl:param>
        <xsl:param name="resource" select="@xml:id"/>
        <xsl:param name="text">https://cobdh.org/<xsl:value-of select="$collection"/>/<xsl:value-of select="$resource"/></xsl:param>
        <!-- Hide href if no xml:id/address is given -->
        <xsl:element name="{if (empty($resource)) then 'span' else 'a'}">
            <xsl:attribute name="href">
                <xsl:sequence select="core:hyper($collection, $resource)"/>
            </xsl:attribute>
            <xsl:value-of select="$text"/>
        </xsl:element>
        <!-- <xsl:call-template name="copy"/> -->
        <br/>
    </xsl:template>
</xsl:stylesheet>

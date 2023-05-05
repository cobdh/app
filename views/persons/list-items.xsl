<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:app="https://cobdh.org/app"
    xmlns:core="https://cobdh.org/core"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <xsl:import href="../core/href.xsl"/>
    <xsl:import href="../core/persons.xsl"/>
    <xsl:import href="../core/utils.xsl"/>
    <!--Render list of persons -->
    <xsl:template match="/">
        <ul>
            <xsl:for-each select="//(tei:person)">
                <xsl:call-template name="person_href"/>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="person_href">
        <li>
            <!-- Example: cobdh.org/persons/Ovid121-->
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <!-- TODO: REPLACE WITH app:abspath -->
                    <xsl:sequence select="core:hyper('persons', @xml:id)"/>
                </xsl:attribute>
                <xsl:call-template name="person_names"/>
                <xsl:if test="./role">
                    <xsl:text> </xsl:text>
                    <small>(<xsl:sequence select="./role/text()"/>)</small>
                </xsl:if>
            </xsl:element>
        </li>
    </xsl:template>
</xsl:stylesheet>

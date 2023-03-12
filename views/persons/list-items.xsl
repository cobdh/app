<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:app="https://data.cobdh.org/templates"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <xsl:import href="../core/persons.xsl"/>
    <!--Render list of persons -->
    <xsl:template match="/">
        <ul>
            <xsl:for-each select="//(tei:person)">
                <li>
                    <!-- Example: cobdh.org/persons/Ovid121-->
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <!-- TODO: REPLACE WITH app:abspath -->
                            <xsl:sequence select="concat('/exist/apps/cobdh-data/', 'persons/', @xml:id)"/>
                        </xsl:attribute>
                        <xsl:call-template name="person_names"/>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>

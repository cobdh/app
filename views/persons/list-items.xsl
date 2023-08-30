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
    <!--Parameter-->
    <xsl:param name="headline" select="''"/>
    <xsl:param name="mode" select="''"/>
    <!--Render list of persons -->
    <xsl:template match="tei:listPerson">
        <xsl:if test="$mode eq ''">
            <xsl:if test="$headline and //(tei:person)">
                <h3>
                    <xsl:value-of select="$headline"/>
                </h3>
            </xsl:if>
            <ul class="list-none">
                <xsl:for-each select="//(tei:person)">
                    <xsl:call-template name="person_href"/>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="$mode eq 'plain'">
            <!--Render citations in textmode to export them to a txt file for users.-->
            <xsl:call-template name="copy" >
                <xsl:with-param name="text">Export</xsl:with-param>
                <xsl:with-param name="value">
                    <xsl:for-each select="//(tei:person)">
                        <xsl:call-template name="person_names"/>
                        <xsl:text>NEWLINE</xsl:text>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
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

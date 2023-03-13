<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://data.cobdh.org/bibl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <xsl:import href="../core/href.xsl"/>
    <xsl:import href="../core/mono.xsl"/>
    <xsl:import href="../core/persons.xsl"/>
    <!-- End of Import -->
    <xsl:template match="tei:person">
        <div class="container">
            <xsl:call-template name="print_formats"/>
            <small>
                <xsl:call-template name="resource_link">
                    <xsl:with-param name="collection">persons</xsl:with-param>
                </xsl:call-template>
            </small>
            <h3>Biography</h3>
            <h4>Names</h4>
            <ul class="list-none">
                <xsl:call-template name="person_names">
                    <xsl:with-param name="list" select='1'/>
                </xsl:call-template>
            </ul>
            <xsl:call-template name="details"/>
            <h3>Full Citation Information</h3>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
    <xsl:template name="details">
        <xsl:if test="tei:state | tei:birth | tei:death | tei:floruit | tei:sex | tei:langKnowledge">
            <h4>Details</h4>
            <ul class="list-none">
                <xsl:apply-templates select="tei:state | tei:birth | tei:death | tei:floruit | tei:sex | tei:langKnowledge"/>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

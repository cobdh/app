<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://data.cobdh.org/bibl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!-- Import general methods -->
    <xsl:import href="../core/core.xsl"/>
    <!-- End of Import -->
    <xsl:template match="tei:person">
        <div class="container">
            <xsl:call-template name="print_formats"/>
            <h3>Biography</h3>
            <h4>Names</h4>
            <ul class="list-none">
                <xsl:call-template name="person_names">
                    <xsl:with-param name="list" select='1'/>
                </xsl:call-template>
            </ul>
            <h4>Details</h4>
            <ul class="list-none">
                <xsl:apply-templates select="tei:sex | tei:death | tei:birth | tei:floruit"/>
            </ul>
            <h3>Full Citation Information</h3>
            <xsl:call-template name="credit"/>
            <xsl:call-template name="licence"/>
        </div>
    </xsl:template>
    <!--Display personal details of the person-->
    <xsl:template match="tei:state | tei:birth | tei:death | tei:floruit | tei:sex | tei:langKnowledge">
        <li>
            <xsl:choose>
                <xsl:when test="self::tei:birth">Birth:</xsl:when>
                <xsl:when test="self::tei:death">Death:</xsl:when>
                <xsl:when test="self::tei:floruit">Floruitei:</xsl:when>
                <xsl:when test="self::tei:sex">Sex:</xsl:when>
                <xsl:when test="self::tei:langKnowledge">Language Knowledge:</xsl:when>
                <xsl:when test="@role">
                    <xsl:value-of select="concat(upper-case(substring(@role,1,1)),substring(@role,2))"/>:
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(upper-case(substring(@type,1,1)),substring(@type,2))"/>:
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="count(tei:date) &gt; 1">
                    <xsl:for-each select="tei:date">
                        <xsl:apply-templates/>
                        <!-- <xsl:sequence select="local:add-footnotes(@source,.)"/> -->
                        <xsl:if test="position() != last()"> or </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="plain"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- <xsl:sequence select="local:add-footnotes(@source,.)"/> -->
        </li>
    </xsl:template>
</xsl:stylesheet>

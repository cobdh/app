<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    >
    <!--Render persName-->
    <xsl:template name="person_names">
        <xsl:param name="list">0</xsl:param>
        <xsl:for-each select="tei:persName">
            <xsl:choose>
                <xsl:when test="$list=1">
                    <li>
                        <xsl:apply-templates/>
                    </li>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:persName">
        <xsl:for-each select="//tei:surname">
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:if test="//tei:forename">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:for-each select="//tei:forename">
            <xsl:value-of select="."/>
        </xsl:for-each>
        <!--Simple Name-->
        <xsl:if test="not(tei:surname) and not(tei:forename)">
            <xsl:value-of select="."/>
        </xsl:if>
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
    <xsl:template match="tei:author">
        <!-- TODO: UNITE LATER -->
        <li>
            Author:
            <xsl:text> </xsl:text>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <!-- TODO: REPLACE WITH app:abspath -->
                    <xsl:sequence select="concat('/exist/apps/cobdh-data/', 'persons/', @xml:id)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </li>
    </xsl:template>
    <xsl:template match="tei:editor[not(ancestor::tei:teiHeader)]">
        <!--Do not display editor from header with this template-->
        <li>
            Editor:
            <xsl:text> </xsl:text>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <!-- TODO: REPLACE WITH app:abspath -->
                    <xsl:sequence select="concat('/exist/apps/cobdh-data/', 'persons/', @xml:id)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </li>
    </xsl:template>
</xsl:stylesheet>
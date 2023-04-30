<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:utils="https://data.cobdh.org/utils"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    >
    <xsl:function name="utils:strip">
        <xsl:param name="text"/>
        <xsl:value-of select="normalize-space(string-join($text))"/>
    </xsl:function>
    <xsl:function name="utils:improve">
        <!--Improve text space failures for example:
             * Solomon : Introduction => Solomon: Introduction
        -->
        <xsl:param name="text"/>
        <xsl:value-of select="replace(utils:strip($text), ' : ', ': ')"/>
    </xsl:function>
</xsl:stylesheet>

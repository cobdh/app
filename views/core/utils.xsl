<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:utils="https://cobdh.org/utils"
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
    <xsl:function name="utils:single">
        <!--Prefer latin characters -->
        <!--TODO:WHILE IMPROVING MULTIPLE LANG APROACH, PREFER SELECTED LANG -->
        <xsl:param name="nodes"/>
        <xsl:variable name="selected">
            <xsl:value-of select="if (empty($nodes[@xml:lang eq 'en'][1])) then
                    $nodes[1] else
                    $nodes[@xml:lang eq 'en'][1]
                            "/>
        </xsl:variable>
        <xsl:value-of select="utils:improve($selected)"/>
    </xsl:function>
</xsl:stylesheet>

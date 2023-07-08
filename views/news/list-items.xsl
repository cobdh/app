<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!--Import general methods-->
    <xsl:import href="../core/core.xsl"/>
    <xsl:template match="/">
        <div class="row row-cols-1 g-4">
            <xsl:for-each select=".//tei:floatingText">
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="card-title"><xsl:value-of select=".//tei:h1"/></h3>
                            <p>
                                <xsl:value-of select="./../..//tei:date"/>
                                <xsl:text> by </xsl:text>
                                <xsl:for-each select="./../..//tei:editor">
                                    <xsl:call-template name="editor_link"/>
                                </xsl:for-each>
                            </p>
                            <xsl:for-each select=".//tei:p">
                                <p class="card-text">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>

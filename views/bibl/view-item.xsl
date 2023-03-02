<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <xsl:template match="tei:biblFull">
        <h2><xsl:value-of select="//tei:title"/></h2>
        <hr/>
        <div class="container">
            <ul>
                <li>
                    <button type="button"
                            class="btn btn-sm btn-default copy-sm clipboard"
                            data-toggle="tooltip"
                            title="Copies URI to clipboard"
                        >
                        <span class="glyphicon glyphicon-copy" aria-hidden="true"/>
                    </button>
                </li>
                <li>
                    <button type="button"
                            class="btn btn-sm btn-default copy-sm clipboard"
                            data-toggle="tooltip"
                            title="Copies citation to clipboard"
                        >
                        <span class="glyphicon glyphicon-copy" aria-hidden="true"/>
                    </button>
                </li>
            </ul>
        </div>
    </xsl:template>
</xsl:stylesheet>

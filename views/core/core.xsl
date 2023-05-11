<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://cobdh.org/bibl"
    xmlns:core="https://cobdh.org/core"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!--Render credit information-->
    <xsl:template name="credit">
        <h3>About this Online Entry</h3>
        <h4>Additional Credit</h4>
        <div data-template="bibl:editors-request"/>
        <ul class="list-none">
            <xsl:for-each select="//tei:titleStmt/tei:editor">
                <li>
                    <xsl:choose>
                        <xsl:when test="@role = 'creator'">
                            XML coded by <xsl:call-template name="editor_link"/>
                        </xsl:when>
                        <xsl:when test="@role = 'general'">
                            Data entered by <xsl:call-template name="editor_link"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <!--Render licence-->
    <xsl:template name="licence">
        <h4>Licence</h4>
        <p>
            <xsl:choose>
                <xsl:when test="//tei:licence">
                    <xsl:value-of select="//tei:licence"/>
                </xsl:when>
                <xsl:otherwise>
                    The Creative Commons Attribution 3.0 Unported (CC BY
                    3.0) Licence applies to this document.
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    <!--Render resource copy-->
    <xsl:template name="copy">
        <xsl:param name="text">copy</xsl:param>
        <button
            type="button"
            class="btn btn-default btn-xs"
            title="Copies to clipboard"
            data-clipboard-action="copy"
            data-clipboard-text="{normalize-space($text)}"
            >
            <xsl:value-of select="$text"/>
        </button>
    </xsl:template>
    <!--Render editor-->
    <xsl:template name="editor_link">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:sequence select="core:hyper('editors', @xml:id)"/>
            </xsl:attribute>
            <xsl:value-of select="core:id_to_name(.//@xml:id)"/>
        </xsl:element>
        <!-- <xsl:call-template name="copy"/> -->
        <br/>
    </xsl:template>
    <!--Render formats-->
    <xsl:template name="print_formats">
        <xsl:param name="resource"></xsl:param>
        <div class="container other_formats">
            <xsl:element name="a">
                <xsl:attribute name="class">btn btn-default btn-xs</xsl:attribute>
                <xsl:attribute name="data-original-title">Click to send this page to the printer.</xsl:attribute>
                <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                <xsl:attribute name="id">teiBtn</xsl:attribute>
                <xsl:attribute name="type">button</xsl:attribute>
                <xsl:attribute name="href">javascript:window.print();</xsl:attribute>
                <span
                    aria-hidden="true"
                    class="glyphicon glyphicon-print"
                    />
            </xsl:element>
            <xsl:element name="a">
                <xsl:attribute name="class">btn btn-default btn-xs</xsl:attribute>
                <xsl:attribute name="data-original-title">Click to view the TEI XML data for this record.</xsl:attribute>
                <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                <xsl:attribute name="id">teiBtn</xsl:attribute>
                <xsl:attribute name="type">button</xsl:attribute>
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>?format=tei</xsl:text>
                </xsl:attribute>
                <span
                    aria-hidden="true"
                    class="glyphicon glyphicon-download-alt"
                    >
                    TEI/XML
                </span>
            </xsl:element>
        </div>
    </xsl:template>
    <!--Create absolute hyperlink to automate collection and item-->
    <xsl:function name="core:hyper">
        <xsl:param name="collection"/>
        <xsl:param name="item"/>
        <xsl:value-of select="concat('/exist/apps/cobdh/', $collection, '/', $item)"/>
    </xsl:function>
    <!--Userid to name-->
    <xsl:function name="core:id_to_name">
        <xsl:param name="xmlid"/>
        <xsl:value-of select="replace($xmlid, '_', ' ')"/>
    </xsl:function>
</xsl:stylesheet>

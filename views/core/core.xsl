<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bibl="https://cobdh.org/bibl"
    xmlns:core="https://cobdh.org/core"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0"
    >
    <!--Render credit information-->
    <xsl:param name="web-root"/>
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
            <xsl:call-template name="external_links"/>
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
                    The Creative Commons Attribution 4.0 (CC BY 4.0)
                    Licence applies to this document.
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    <!--Render resource copy-->
    <xsl:template name="copy">
        <xsl:param name="text">copy</xsl:param>
        <xsl:param name="value"></xsl:param>
        <button
            type="button"
            class="btn btn-secondary btn-sm copy-sm clipboard"
            title="Copies to clipboard"
            data-clipboard-action="copy"
            data-clipboard-text="{core:no_html($value)}"
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
                <xsl:attribute name="class">btn btn-secondary btn-sm</xsl:attribute>
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
                <xsl:attribute name="class">btn btn-secondary btn-sm</xsl:attribute>
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
        <xsl:value-of select="concat($web-root, '/', $collection, '/', $item)"/>
    </xsl:function>
    <!--Userid to name-->
    <xsl:function name="core:id_to_name">
        <xsl:param name="xmlid"/>
        <xsl:value-of select="core:titleCase(replace($xmlid, '_', ' '))"/>
    </xsl:function>
    <!--Remove html styling elements out of text-->
    <xsl:function name="core:no_html">
        <xsl:param name="text"/>
        <xsl:value-of select="replace($text, '&lt;/?(ibu)&gt;', '')"/>
    </xsl:function>
    <xsl:template name="external_links">
        <xsl:if test="//tei:biblStruct/@corresp">
            <li>
                Based on
                <xsl:text> </xsl:text>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:sequence select="//tei:biblStruct/@corresp"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">blank</xsl:attribute>
                    <xsl:value-of select="//tei:biblStruct/@corresp"/>
                </xsl:element>
            </li>
        </xsl:if>
    </xsl:template>
    <!--Convert to title case, make every first word character upper case.-->
    <xsl:function name="core:titleCase">
        <xsl:param name="text" />
        <xsl:for-each select="tokenize($text,' ')">
            <xsl:value-of select="upper-case(substring(.,1,1))" />
            <xsl:value-of select="lower-case(substring(.,2))" />
            <xsl:if test="position() ne last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>

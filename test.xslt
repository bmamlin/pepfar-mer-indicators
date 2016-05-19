<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:character-map name="cmap">
        <xsl:output-character character="&#xE801;" string="&lt;"/>
        <xsl:output-character character="&#xE802;" string="&gt;"/>
    </xsl:character-map>
    <xsl:output encoding="UTF-8" indent="yes" method="xhtml" use-character-maps="cmap"/>
    
    <xsl:template match="/terminology">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.3/jquery.min.js"></script>
                <style type="text/css">
                    body { font-family: arial }
                    .concept {
                        border:thin solid grey;
                        margin: 5pt;
                        padding: 5pt;
                    }
                    .concept-name {
                        font-weight: bold;
                        font-size: 150%;
                    }
                    .concept-id {
                        font-style: italic;
                        color: #B0B0B0;
                    }
                    .concept-code {
                        font-style: italic;
                        color: #B0B0B0;
                    }
                    .status {
                        float: right;
                        padding: 2pt;
                        font-weight: bold;
                        border-radius: 4pt;
                    }
                    .status-active {
                        color: white;
                        background-color: #A0D0A0;
                    }
                </style>
            </head>
            <body>
                <h1><xsl:value-of select="namespace/name"/></h1>
                <h2>Code</h2>
                <p><xsl:value-of select="namespace/code"/></p>
                <h2>ID</h2>
                <p><xsl:value-of select="namespace/id"/></p>
                <h2>Version</h2>
                <p><xsl:value-of select="namespace/version"/></p>
                <h2>Authority</h2>
                <p><xsl:value-of select="namespace/authority"/></p>
                <h2>Properties</h2>
                <ul>
                    <xsl:apply-templates select="proptype" />
                </ul>
                <div class="search">
                    <input id="search" type="search" placeholder="Filter by concept name" />
                </div>
                <xsl:apply-templates select="concept" />
                <div style="display:block;width:100%;height:1000px;"></div>
                <script>
                    $(document).ready(function() {
                        $.expr[':'].icontains = $.expr.createPseudo(function(text) {
                            return function(e) {
                            return $(e).text().toUpperCase().indexOf(text.toUpperCase()) &#xE802;= 0;
                            };
                        });
                        
                        $('.association').click(function() {
                            var name = $(this).text();
                            alert('I\'d take you to "'+name.replace(/\s+/g, ' ').trim()
                                +'" page now if I could.');
                        });
                        
                        $('#search').on('input', function() {
                            var search = $(this).val();
                            if (!search || search.length &#xE801; 1) {
                                $('.concept').show();
                                return;
                            }
                            $('.concept:has(&#xE802; .concept-name:icontains('+search+'))').each(function() {
                                $(this).show();
                            });
                            $('.concept:has(&#xE802; .concept-name:not(:icontains('+search+')))').each(function() {
                                $(this).hide();
                            });
                        }).focus();
                    });
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="proptype">
        <li><xsl:value-of select="name"/> (<xsl:value-of select="id"/>)</li>
    </xsl:template>
    
    <xsl:template match="concept">
        <div class="concept">
            <xsl:element name="div">
                <xsl:attribute name="class">
                    <xsl:text>status</xsl:text>
                    <xsl:value-of select="concat(' status-',lower-case(status))"/>
                </xsl:attribute>
                <xsl:value-of select="status"/>
            </xsl:element>
            <div class="concept-name"><xsl:value-of select="name"/></div>
            <div class="concept-code">code: <xsl:value-of select="code"/></div>
            <div class="concept-id">id: <xsl:value-of select="id"/></div>
            <xsl:if test="exists(association)">
                <h4>Associations</h4>
                <ul>
                    <xsl:apply-templates select="association" />
                </ul>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="association">
        <li><a href="#" class="association"><xsl:value-of select="to_name"/></a></li>
    </xsl:template>

</xsl:stylesheet>

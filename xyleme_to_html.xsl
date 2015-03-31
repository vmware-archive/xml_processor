<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xy="http://xyleme.com/xylink">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="/IA">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <xsl:apply-templates select="/IA/CoverPage/Title"/>
        <link href="http://docs.pivotal.io/stylesheets/master.css" rel="stylesheet" type="text/css" media="screen,print"/>
        <link href="../../xyleme.css" rel="stylesheet" type="text/css" media="screen, print"/>
      </head>

      <a id="top"></a>
      <h2 class="small-title thin">
        <xsl:value-of select="/IA/CoverPage/SubTitle/text()"/>
      </h2>
      <div class="lessons">
        <xsl:apply-templates select="/IA/Lessons"/>
      </div>

      <div class="container">
        <div class="footnotes">
          <h2 class="horton-blue border-bottom">Footnotes</h2>
          <ol>
            <xsl:for-each select="//Footnote">
              <xsl:element name="li">
                <xsl:attribute name="id">footnote-<xsl:number level="any" count="Footnote" format="1"/></xsl:attribute>
                <xsl:apply-templates/>
              </xsl:element>
            </xsl:for-each>
          </ol>
        </div>
      </div>

      <div class="container">
        <footer>
          <h3 class="horton-blue border-bottom">About Hortonworks Data Platform</h3>
          <xsl:apply-templates select="/IA/CoverPage/Notice"/>
          <div class="copyright">
            <xsl:apply-templates select="/IA/Credits"/>
          </div>
        </footer>
      </div>
    </html>
  </xsl:template>

  <!-- Universal Matchers -->

  <xsl:template match="//Icon">
    <div class="icon">
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:value-of select="@uri"/>
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="@thumbWidth"/>
        </xsl:attribute>
      </xsl:element>
    </div>
  </xsl:template>

  <xsl:template match="//RichText">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//Emph">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="//Italic">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="//Code">
    <pre><code><xsl:apply-templates/></code></pre>
  </xsl:template>

  <xsl:template match="//InLineCode">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="//InLineTypeThis">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="//InLineApplicationPrompt">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="//InLineMenuSelection">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="//Footnote">
    <xsl:element name="a">
      <xsl:attribute name="href">#footnote-<xsl:number level="any" count="Footnote" format="1"/></xsl:attribute>
      <xsl:attribute name="class">footnote-anchor</xsl:attribute>
      <xsl:number level="any" count="Footnote" format="[1]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//Href">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="@UrlTarget"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//Xref">
    <xsl:element name="a">
      <xsl:attribute name="href">#ref-<xsl:value-of select="@InsideTargetRef"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//FilterMetadata">
  </xsl:template>


  <xsl:template match="//Tabs">
    <div class="tabs">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="//Tab">
    <div class="tab"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="//Tab/Label">
    <p class="bold"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//Tab/Content">
    <div class="tab-content"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="//InLineMenuSelection">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="//List">
    <xsl:variable name="list_marker" select="@ListMarker"/>
    <xsl:choose>
      <xsl:when test="$list_marker = 'Numeric'">
        <ul class="number-list"><xsl:apply-templates/></ul>
      </xsl:when>
      <xsl:otherwise>
        <ul class="bullet-list"><xsl:apply-templates/></ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//List//Item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="//List//Item/ItemPara">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//List//Item//SubList">
    <xsl:element name="ul">
      <xsl:attribute name="class"><xsl:value-of select="@ListMarker"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>


  <!-- Composite Matchers -->


  <xsl:template match="//Table">
    <div class="xyleme-table">
      <table border="1">
        <xsl:apply-templates select="/TblTitle"/>
        <xsl:apply-templates select="/TblGroup"/>
        <xsl:apply-templates/>
      </table>
    </div>
  </xsl:template>


  <!-- Specific Matchers -->


  <xsl:template match="//Table/TblTitle">
    <p class="italic bold"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//Table/TblGroup/TblBody">
    <tbody><xsl:apply-templates/></tbody>
  </xsl:template>

  <xsl:template match="//Table/TblGroup/TblHeader">
    <thead><xsl:apply-templates/></thead>
  </xsl:template>

  <xsl:template match="//Table//TableRow">
    <tr><xsl:apply-templates/></tr>
  </xsl:template>

  <xsl:template match="//Table//TblHeader/TableRow/Cell">
    <xsl:variable name="rowspan" select="@rowspan"/>
    <xsl:element name="th">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="$rowspan">
        </xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//Table/TblGroup[TblHeader[string-length() = 0]]/TblBody//TableRow[position() = 1]/Cell">
    <xsl:variable name="rowspan" select="@rowspan"/>

    <xsl:element name="th">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="$rowspan">
        </xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//Table/TblGroup[TblHeader[string-length() = 0]]/TblBody//TableRow[position() != 1]/Cell">
    <xsl:variable name="rowspan" select="@rowspan"/>

    <xsl:element name="td">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="$rowspan">
        </xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//Table/TblGroup[TblHeader[string-length() != 0]]/TblBody//TableRow/Cell">
    <xsl:variable name="rowspan" select="@rowspan"/>
    <xsl:element name="td">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="$rowspan">
        </xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="/IA/CoverPage/Title">
      <title><xsl:apply-templates/></title>
  </xsl:template>


  <xsl:template match="/IA/Credits">
      <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="/IA/Credits/CopyrightBlock">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/IA/Credits/CopyrightDate">
      <span><xsl:text>&#169; </xsl:text><xsl:value-of select="text()"/></span>
  </xsl:template>


  <xsl:template match="/IA/Lessons/Lesson/Title">
    <xsl:element name="h2">
      <xsl:attribute name="class">horton-green bold</xsl:attribute>
      <xsl:attribute name="id">ref-<xsl:value-of select="../@xy:guid"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/Title">
    <xsl:element name="h3">
      <xsl:attribute name="class">horton-blue bold</xsl:attribute>
      <xsl:attribute name="id">ref-<xsl:value-of select="../@xy:guid"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic//Topic/Title">
    <xsl:element name="h4">
      <xsl:attribute name="class">bold</xsl:attribute>
      <xsl:attribute name="id">ref-<xsl:value-of select="../@xy:guid"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//CustomNote">
      <aside class="custom-note"><xsl:apply-templates/></aside>
  </xsl:template>

  <xsl:template match="//CustomNote//SimpleBlock">
    <div class="simple-block"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="//TitledBlock/Title">
    <span class="title"><strong><xsl:apply-templates/></strong></span>
  </xsl:template>

  <xsl:template match="//Figure">
    <div class="figure">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="//Figure/MediaObject">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="//Figure/MediaObject/Title">
    <p class="italic">Figure - <xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//Caption">
    <p class="italic"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//Underline">
    <p class="underline"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="//Figure/MediaObject/Renditions/Web">
    <xsl:element name="img">
      <xsl:attribute name="src"><xsl:value-of select="@uri"/></xsl:attribute>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>


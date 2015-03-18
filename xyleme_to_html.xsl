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
        <link href="http://docs.pivotal.io/stylesheets/master.css" rel="stylesheet" type="text/css" media="screen,print" />
        <link href="http://docs.pivotal.io/stylesheets/print.css" rel="stylesheet" type="text/css" media="print" />
      </head>
      <body>
        <div class="viewport">
          <div class="wrap">
            <div class="container">
              <header>
              </header>
              <main class="content content-layout" id="js-content" role="main">
                <a id="top"></a>
                <h1 class="title-container">
                  <xsl:value-of select="/IA/CoverPage/Title/text()"/>
                </h1>
                <h2 class="title-details">
                  <xsl:value-of select="/IA/CoverPage/SubTitle/text()"/>
                </h2>
                <div class="lessons">
                  <xsl:apply-templates select="/IA/Lessons"/>
                </div>
              </main>
            </div>
            
            <div class="container">
              <footer>
                <xsl:apply-templates select="/IA/CoverPage/Notice"/>
                <div class="copyright">
                  <xsl:apply-templates select="/IA/Credits"/>
                </div>
              </footer>
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/IA/CoverPage/Title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>

  <xsl:template match="/IA/CoverPage/Notice//ParaBlock/RichText">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="/IA/CoverPage/Notice//ParaBlock//Href">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="@UrlTarget"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Credits">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="/IA/Credits/CopyrightBlock">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/IA/Credits/CopyrightBlock//RichText">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/IA/Credits/CopyrightBlock/RichText//Href">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="@UrlTarget"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Credits/CopyrightDate">
    <span><xsl:text>&#169;</xsl:text><xsl:value-of select="text()"/></span>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock//Href">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="@UrlTarget"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Title">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/Title">
    <xsl:element name="h3">
      <xsl:attribute name="id">ref-<xsl:value-of select="../@xy:guid"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock/RichText">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic//List">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic//List//Item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic//List//Item/ItemPara">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock//Href">
    <xsl:element name="a">
      <xsl:attribute name="href"><xsl:value-of select="@UrlTarget"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/IA/Lessons/Lesson/Topic/ParaBlock//Xref">
    <xsl:element name="a">
      <xsl:attribute name="href">#ref-<xsl:value-of select="@InsideTargetRef"/></xsl:attribute>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//Emph">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="//Icon">
    <xsl:element name="img">
      <xsl:attribute name="src"><xsl:value-of select="@UrlTarget"/><xsl:value-of select="text()"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

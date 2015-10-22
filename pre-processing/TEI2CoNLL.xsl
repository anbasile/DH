<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*"/>
  <xsl:output method="text" encoding="UTF-8"/>

  
  <xsl:template match="text()[normalize-space()]" name="processtail">
    <xsl:variable name="textnode" select="current()" />
    <xsl:variable name="canto" select="count(./../../preceding-sibling::div1) + 1" />
    <xsl:variable name="verso" select="count(./../preceding-sibling::l) + 1" />
    <xsl:variable name="versePosition" select="string-join((string($canto),string($verso)),'.')" />
    <xsl:variable name="punteggiatura" select="normalize-space(.)" />
    <xsl:call-template name="parseString">
      <xsl:with-param name="text" select = "$punteggiatura" />
      <xsl:with-param name="versePosition" select = "$versePosition" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="parseString">
    <xsl:param name="text"/>
    <xsl:param name="versePosition"/>
    <xsl:analyze-string select="$text" regex=".">
      <xsl:matching-substring>
        <xsl:value-of select="normalize-space(.)" />
	<xsl:text>&#9;</xsl:text>
	<xsl:text>&#9;</xsl:text>
	<xsl:text>&#9;</xsl:text>
	<xsl:value-of select="$versePosition"/><xsl:text>&#10;</xsl:text>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="LM">
    <xsl:variable name="canto" select="count(./../../preceding-sibling::div1) + 1" />
    <xsl:variable name="verso" select="count(./../preceding-sibling::l) + 1" />
    <xsl:variable name="versePosition" select="string-join((string($canto),string($verso)),'.')" />
    <xsl:choose>
      <xsl:when test="contains(normalize-space(./text()),' ')">
	<xsl:variable name="thisnode" select="current()" />
	<xsl:for-each select="tokenize(normalize-space(./text()), ' ')">
	  <xsl:choose>
	    <xsl:when test="matches(normalize-space(.),'\w+(\.|;|:|,|!|\?)')">
	      <xsl:value-of select="substring(normalize-space(.),1,string-length(normalize-space(.))-1)"/>
	      <xsl:call-template name="ids">
		<xsl:with-param name="text" select = "$thisnode" />
	      </xsl:call-template>
	      <xsl:value-of select="substring(normalize-space(.),string-length(normalize-space(.)))"/>
	      <xsl:text>&#9;</xsl:text>
	      <xsl:text>&#9;</xsl:text>
	      <xsl:text>&#9;</xsl:text>
	      <xsl:value-of select="$versePosition"/><xsl:text>&#10;</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="normalize-space(.)"/>
	      <xsl:call-template name="ids">
		<xsl:with-param name="text" select = "$thisnode" />
	      </xsl:call-template>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="matches(normalize-space(.),'\w+(\.|,|;|:|!)$')">
	    <xsl:value-of select="substring(normalize-space(.),1,string-length(normalize-space(.))-1)"/>
	    <xsl:call-template name="ids">
	      <xsl:with-param name="text" select = "current()" />
	    </xsl:call-template>
	    <xsl:value-of select="substring(normalize-space(.),string-length(normalize-space(.)))"/>
	    <xsl:text>&#9;</xsl:text>
	    <xsl:text>&#9;</xsl:text>
	    <xsl:text>&#9;</xsl:text>
	    <xsl:value-of select="$versePosition"/><xsl:text>&#10;</xsl:text>
	    <!-- <xsl:value-of select="count(../preceding-sibling::l) + 1"/><xsl:text>&#10;</xsl:text> -->
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="normalize-space(.)"/>
	    <xsl:call-template name="ids">
	      <xsl:with-param name="text" select = "current()" />
	    </xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="LM1" name="LM1">
    <xsl:choose>
      <xsl:when test="contains(normalize-space(./LM[1]/text()),' ')">
  	<xsl:variable name="thisnode" select="current()" />
  	<xsl:for-each select="tokenize(normalize-space(./LM[1]/text()), ' ')">
          <xsl:value-of select="normalize-space(.)"/>
  	  <xsl:call-template name="ids">
  	    <xsl:with-param name="text" select = "$thisnode" />
  	  </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
  	<xsl:value-of select="normalize-space(./LM[1])"/>
  	<xsl:call-template name="ids">
  	  <xsl:with-param name="text" select = "current()" />
  	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="./text()">
      <xsl:variable name="canto" select="count(./../../preceding-sibling::div1) + 1" />
      <xsl:variable name="verso" select="count(./../preceding-sibling::l) + 1" />
      <xsl:variable name="versePosition" select="string-join((string($canto),string($verso)),'.')" />
      <xsl:variable name="punteggiatura" select="normalize-space(./text()[last()])" />
      <xsl:call-template name="parseString">
	<xsl:with-param name="text" select ="$punteggiatura" />
	<xsl:with-param name="versePosition" select = "$versePosition" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ids">
    <xsl:param name="text"/>
    <xsl:variable name="canto" select="count($text/../../preceding-sibling::div1) + 1" />
    <xsl:variable name="verso" select="count($text/../preceding-sibling::l) + 1" />
    <xsl:variable name="versePosition" select="string-join((string($canto),string($verso)),'.')" />
    <xsl:text>&#9;</xsl:text>
    <xsl:choose>
      <xsl:when test="$text/name()='LM1'">
	<xsl:value-of select="string-join(.//@lemma,'/')" /><xsl:text>&#9;</xsl:text>
	<xsl:value-of select="string-join(.//@catg,'/')" /><xsl:text>&#9;</xsl:text>
	<xsl:value-of select="$versePosition"/><xsl:text>&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$text/@lemma"/><xsl:text>&#9;</xsl:text>
	<xsl:value-of select="$text/@catg"/><xsl:text>&#9;</xsl:text>
	<xsl:value-of select="$versePosition"/><xsl:text>&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>     
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:for-each select="//l">
      <xsl:apply-templates/>
    </xsl:for-each>

    <!-- <xsl:apply-templates/> -->
  </xsl:template>
  
</xsl:stylesheet>

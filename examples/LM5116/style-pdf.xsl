<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="https://datasheet.org/schema/v1"
    exclude-result-prefixes="d">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

<xsl:template match="/d:Datasheet">
<html>
<head>
<meta charset="UTF-8"/>
<title><xsl:value-of select="d:Metadata/d:PartNumber"/> - <xsl:value-of select="d:Metadata/d:Product"/></title>
<style>
  @page { size: Letter; margin: 20mm 16mm; }
  body { font-family: "Helvetica Neue", Arial, sans-serif; color: #1a1a1a; font-size: 9.5pt; line-height: 1.4; }
  h1 { font-size: 18pt; margin: 0 0 4pt 0; color: #b02021; }
  h2 { font-size: 13pt; margin: 18pt 0 6pt 0; padding-bottom: 3pt; border-bottom: 1.5pt solid #b02021; color: #111; }
  h3 { font-size: 10.5pt; margin: 10pt 0 4pt 0; color: #333; }
  .doc-header { display: flex; justify-content: space-between; align-items: baseline; border-bottom: 2pt solid #b02021; padding-bottom: 6pt; margin-bottom: 10pt; }
  .doc-number { font-size: 8pt; color: #555; text-align: right; }
  .manufacturer { font-size: 9pt; color: #555; letter-spacing: 0.5pt; text-transform: uppercase; }
  table { border-collapse: collapse; width: 100%; margin: 6pt 0 12pt 0; font-size: 8.5pt; }
  th, td { border: 0.5pt solid #999; padding: 3pt 5pt; text-align: left; vertical-align: top; }
  th { background: #eeeeee; font-weight: 600; }
  td.num, th.num { text-align: right; font-variant-numeric: tabular-nums; }
  ul.features { column-count: 2; -webkit-column-count: 2; margin: 4pt 0; padding-left: 16pt; }
  ul.features li { break-inside: avoid; margin-bottom: 2pt; }
  .group-title { font-weight: bold; background: #f5f5f5; }
  .pagebreak { page-break-before: always; }
  .note { font-size: 8pt; color: #555; font-style: italic; margin: 4pt 0; }
  .footer-note { font-size: 7.5pt; color: #777; margin-top: 4pt; }
  p { margin: 4pt 0; }
</style>
</head>
<body>

  <div class="doc-header">
    <div>
      <div class="manufacturer"><xsl:value-of select="d:Metadata/d:Manufacturer"/></div>
      <h1><xsl:value-of select="d:Metadata/d:PartNumber"/></h1>
      <div><xsl:value-of select="d:Metadata/d:Product"/></div>
    </div>
    <div class="doc-number">
      <div><xsl:value-of select="d:Metadata/d:DocumentNumber"/></div>
      <div>Rev. <xsl:value-of select="d:Metadata/d:Revision"/> &#8212; <xsl:value-of select="d:Metadata/d:PublicationDate"/></div>
      <div><xsl:value-of select="d:Metadata/d:Status"/></div>
    </div>
  </div>

  <!-- Features -->
  <xsl:if test="d:Features">
    <h2>Features</h2>
    <ul class="features">
      <xsl:for-each select="d:Features/d:Feature">
        <li><xsl:value-of select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:if>

  <!-- Applications -->
  <xsl:if test="d:Applications">
    <h2>Applications</h2>
    <ul>
      <xsl:for-each select="d:Applications/d:Application">
        <li><xsl:value-of select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:if>

  <!-- Description -->
  <xsl:if test="d:Description">
    <h2>Description</h2>
    <xsl:for-each select="d:Description/d:Paragraph">
      <p><xsl:value-of select="normalize-space(.)"/></p>
    </xsl:for-each>
  </xsl:if>

  <!-- Package -->
  <xsl:if test="d:Package">
    <h2>Package Information</h2>
    <table>
      <tr><th>Part Number</th><th>Package</th><th>Pins</th><th>Package Size</th></tr>
      <tr>
        <td><xsl:value-of select="/d:Datasheet/d:Metadata/d:PartNumber"/></td>
        <td><xsl:value-of select="d:Package/d:Name"/></td>
        <td class="num"><xsl:value-of select="d:Package/d:Pins"/></td>
        <td>
          <xsl:value-of select="d:Package/d:Dimensions/d:Length"/> &#215;
          <xsl:value-of select="d:Package/d:Dimensions/d:Width"/>
          <xsl:text> </xsl:text><xsl:value-of select="d:Package/d:Dimensions/@unit"/>
        </td>
      </tr>
    </table>
    <xsl:if test="d:Package/d:ThermalResistance">
      <h3>Thermal Information</h3>
      <table>
        <tr><th>Parameter</th><th class="num">Value</th><th>Unit</th></tr>
        <xsl:for-each select="d:Package/d:ThermalResistance/*">
          <tr>
            <td><xsl:value-of select="@symbol"/></td>
            <td class="num"><xsl:value-of select="."/></td>
            <td><xsl:value-of select="@unit"/></td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:if>

  <!-- Pin Description -->
  <xsl:if test="d:PinDescription">
    <h2>Pin Configuration and Functions</h2>
    <table>
      <tr><th>Pin No.</th><th>Name</th><th>Direction</th><th>Type</th><th>Description</th></tr>
      <xsl:for-each select="d:PinDescription/d:Pin">
        <xsl:sort select="@number" data-type="text"/>
        <tr>
          <td class="num"><xsl:value-of select="@number"/></td>
          <td><b><xsl:value-of select="d:Name"/></b></td>
          <td><xsl:value-of select="d:Direction"/></td>
          <td><xsl:value-of select="d:Type"/></td>
          <td><xsl:value-of select="d:Description"/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:if>

  <div class="pagebreak"/>

  <!-- Absolute Maximum Ratings -->
  <xsl:if test="d:AbsoluteMaximumRatings">
    <h2>Absolute Maximum Ratings</h2>
    <xsl:if test="d:AbsoluteMaximumRatings/@note">
      <p class="note"><xsl:value-of select="d:AbsoluteMaximumRatings/@note"/></p>
    </xsl:if>
    <table>
      <tr><th>Parameter</th><th class="num">Min</th><th class="num">Max</th><th>Unit</th></tr>
      <xsl:for-each select="d:AbsoluteMaximumRatings/d:Rating">
        <tr>
          <td><xsl:value-of select="d:Name"/></td>
          <td class="num"><xsl:value-of select="d:Minimum"/><xsl:value-of select="d:Minimum/@expression"/></td>
          <td class="num"><xsl:value-of select="d:Maximum"/><xsl:value-of select="d:Maximum/@expression"/></td>
          <td><xsl:value-of select="d:Minimum/@unit"/><xsl:if test="not(d:Minimum/@unit)"><xsl:value-of select="d:Maximum/@unit"/></xsl:if></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:if>

  <!-- ESD Ratings -->
  <xsl:if test="d:ESDRatings">
    <h2>ESD Ratings</h2>
    <table>
      <tr><th>Model</th><th>Standard</th><th class="num">Value</th><th>Unit</th><th>Note</th></tr>
      <xsl:for-each select="d:ESDRatings/d:Rating">
        <tr>
          <td><xsl:value-of select="@method"/></td>
          <td><xsl:value-of select="@standard"/></td>
          <td class="num">&#177;<xsl:value-of select="d:Value"/></td>
          <td><xsl:value-of select="d:Value/@unit"/></td>
          <td><xsl:value-of select="d:Note"/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:if>

  <!-- Recommended Operating Conditions -->
  <xsl:if test="d:RecommendedOperatingConditions">
    <h2>Recommended Operating Conditions</h2>
    <table>
      <tr><th>Parameter</th><th class="num">Min</th><th class="num">Max</th><th>Unit</th></tr>
      <xsl:for-each select="d:RecommendedOperatingConditions/d:Parameter">
        <tr>
          <td><xsl:value-of select="d:Name"/></td>
          <td class="num"><xsl:value-of select="d:Minimum"/></td>
          <td class="num"><xsl:value-of select="d:Maximum"/></td>
          <td><xsl:value-of select="d:Minimum/@unit"/><xsl:if test="not(d:Minimum/@unit)"><xsl:value-of select="d:Maximum/@unit"/></xsl:if></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:if>

  <div class="pagebreak"/>

  <!-- Electrical Characteristics -->
  <xsl:if test="d:ElectricalCharacteristics">
    <h2>Electrical Characteristics</h2>
    <p class="note">TJ = -40&#176;C to 125&#176;C unless otherwise noted. VIN = 48 V, VCC = 7.4 V, VCCX = 0 V, EN = 5 V, RT = 16 k&#937;, no load on LO and HO.</p>
    <table>
      <tr><th>Parameter</th><th>Condition</th><th class="num">Min</th><th class="num">Typ</th><th class="num">Max</th><th>Unit</th></tr>
      <xsl:for-each select="d:ElectricalCharacteristics/d:Group">
        <tr class="group-title"><td colspan="6"><xsl:value-of select="@name"/></td></tr>
        <xsl:for-each select="d:Parameter">
          <tr>
            <td><xsl:value-of select="d:Name"/><xsl:if test="@symbol"> (<xsl:value-of select="@symbol"/>)</xsl:if></td>
            <td><xsl:value-of select="d:Condition"/></td>
            <td class="num"><xsl:value-of select="d:Minimum"/></td>
            <td class="num"><xsl:value-of select="d:Typical"/></td>
            <td class="num"><xsl:value-of select="d:Maximum"/></td>
            <td><xsl:choose>
              <xsl:when test="d:Minimum/@unit"><xsl:value-of select="d:Minimum/@unit"/></xsl:when>
              <xsl:when test="d:Typical/@unit"><xsl:value-of select="d:Typical/@unit"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="d:Maximum/@unit"/></xsl:otherwise>
            </xsl:choose></td>
          </tr>
        </xsl:for-each>
      </xsl:for-each>
    </table>
  </xsl:if>

  <!-- Timing / Switching Characteristics -->
  <xsl:if test="d:Timing">
    <h2>Switching Characteristics</h2>
    <table>
      <tr><th>Parameter</th><th>Condition</th><th class="num">Min</th><th class="num">Typ</th><th class="num">Max</th><th>Unit</th></tr>
      <xsl:for-each select="d:Timing/d:Group">
        <tr class="group-title"><td colspan="6"><xsl:value-of select="@name"/></td></tr>
        <xsl:for-each select="d:Parameter">
          <tr>
            <td><xsl:value-of select="d:Name"/><xsl:if test="@symbol"> (<xsl:value-of select="@symbol"/>)</xsl:if></td>
            <td><xsl:value-of select="d:Condition"/></td>
            <td class="num"><xsl:value-of select="d:Minimum"/></td>
            <td class="num"><xsl:value-of select="d:Typical"/></td>
            <td class="num"><xsl:value-of select="d:Maximum"/></td>
            <td><xsl:choose>
              <xsl:when test="d:Minimum/@unit"><xsl:value-of select="d:Minimum/@unit"/></xsl:when>
              <xsl:when test="d:Typical/@unit"><xsl:value-of select="d:Typical/@unit"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="d:Maximum/@unit"/></xsl:otherwise>
            </xsl:choose></td>
          </tr>
        </xsl:for-each>
      </xsl:for-each>
    </table>
  </xsl:if>

  <div class="pagebreak"/>

  <!-- Application Notes -->
  <xsl:if test="d:ApplicationNotes">
    <h2>Application and Implementation</h2>
    <xsl:for-each select="d:ApplicationNotes/d:Section">
      <h3><xsl:value-of select="@title"/></h3>
      <xsl:for-each select="d:Paragraph">
        <p><xsl:value-of select="normalize-space(.)"/></p>
      </xsl:for-each>
      <xsl:if test="d:Parameter">
        <table>
          <tr><th>Parameter</th><th class="num">Min</th><th class="num">Typ</th><th class="num">Max</th><th>Unit</th></tr>
          <xsl:for-each select="d:Parameter">
            <tr>
              <td><xsl:value-of select="d:Name"/></td>
              <td class="num"><xsl:value-of select="d:Minimum"/></td>
              <td class="num"><xsl:value-of select="d:Typical"/></td>
              <td class="num"><xsl:value-of select="d:Maximum"/></td>
              <td><xsl:choose>
                <xsl:when test="d:Minimum/@unit"><xsl:value-of select="d:Minimum/@unit"/></xsl:when>
                <xsl:when test="d:Typical/@unit"><xsl:value-of select="d:Typical/@unit"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="d:Maximum/@unit"/></xsl:otherwise>
              </xsl:choose></td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>

  <!-- Cross References -->
  <xsl:if test="d:CrossReferences">
    <h2>Related Documentation and Devices</h2>
    <ul>
      <xsl:for-each select="d:CrossReferences/d:Reference">
        <li><xsl:value-of select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:if>

  <!-- Revision History -->
  <xsl:if test="d:RevisionHistory">
    <h2>Revision History</h2>
    <table>
      <tr><th>Rev</th><th>Date</th><th>Description</th></tr>
      <xsl:for-each select="d:RevisionHistory/d:Revision">
        <tr>
          <td><xsl:value-of select="d:Number"/></td>
          <td><xsl:value-of select="d:Date"/></td>
          <td><xsl:value-of select="d:Description"/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:if>

  <p class="footer-note">
    <xsl:value-of select="d:Metadata/d:Copyright"/> &#8212;
    Generated automatically from <xsl:value-of select="d:Metadata/d:PartNumber"/>'s DatasheetXML
    source via style-pdf.xsl. Not a substitute for the manufacturer's original PDF for
    contractual or safety-critical use.
  </p>

</body>
</html>
</xsl:template>
</xsl:stylesheet>

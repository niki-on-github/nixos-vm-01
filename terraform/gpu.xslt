<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="node()|@*">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
  </xsl:template>

  <xsl:template match="/domain/devices">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x0e' slot='0x00' function='0x0'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x01' function='0x0'/>
    </hostdev>

    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x0e' slot='0x00' function='0x1'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x01' function='0x1'/>
    </hostdev>
        
   <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x0e' slot='0x00' function='0x2'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x01' function='0x2'/>
    </hostdev>

   <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x0e' slot='0x00' function='0x3'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x01' function='0x3'/>
    </hostdev>

    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

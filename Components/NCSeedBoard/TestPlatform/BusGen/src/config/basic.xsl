<?xml version='1.0' encoding="ksc5601"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/TR/WD-xsl"
	xmlns="http://www.w3.org/TR/REC-html40"
        result-ns="">

<xsl:template match="/">                    <!-- root rule -->
    <HTML>
      <HEAD>
        <TITLE>AXI bus configuration</TITLE>
      </HEAD>
      <BODY>
	<P>■ Bus configuration file for the s-axi bus</P>
        <xsl:apply-templates/> 
      </BODY>
    </HTML>
</xsl:template>

<xsl:template match="BUS">
	<xsl:apply-templates select="Main"/>
</xsl:template>

<xsl:template match="Main">
    <FONT SIZE="3" >
        Main congirutation_________________________________________
        <BR/>
    </FONT>

	<FONT SIZE="2"><BR/>
        Bus Name : <xsl:value-of select="name"/>
	</FONT><BR/>

	<FONT SIZE="2" color="gray">
        Total Master : <xsl:value-of select="name/@masternum"/>
        <BR/>
        Total Slave  : <xsl:value-of select="name/@slavenum"/>
	</FONT><BR/>

    <FONT SIZE="2">
        Bus width     : <xsl:value-of select="width/buswidth"/>
        <BR/>
        address width : <xsl:value-of select="width/addresswidth"/>
	</FONT><BR/>

	<FONT SIZE="3" color="gray">
	Connect configuration <BR/>
	<TABLE BORDER="2">
		<TR>
            <TD WIDTH="150">Write address </TD> 
            <TD><xsl:value-of select="channel_connection/write_addr"/></TD>
		</TR>
		<TR>
            <TD WIDTH="150">Write data </TD> 
            <TD><xsl:value-of select="channel_connection/write_data"/></TD>
        </TR>
		<TR>
            <TD WIDTH="150">Write resp </TD> 
            <TD><xsl:value-of select="channel_connection/write_resp"/></TD>
        </TR>
	</TABLE>
	</FONT><BR/>

	<FONT SIZE="2">
    Memory Map :: default <BR/>
	<TABLE BORDER="1">
        <xsl:for-each select="memory_map/map0/slave">
		<TR>
            <TD>name :: <xsl:value-of/></TD>
		</TR>
	</xsl:for-each>
	</TABLE>
	</FONT>


    <FONT SIZE="3" >
        ___________________________________________________________
        <BR/>
	</FONT>
</xsl:template>

</xsl:stylesheet>

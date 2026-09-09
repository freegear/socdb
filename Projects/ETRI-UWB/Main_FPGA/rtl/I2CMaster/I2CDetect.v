// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2CDetect.v
// File Revision       : 1.1
// Reveision 		   :
//  -----------------------------------------------------------------------------
//  Purpose            : I2C  Bus Dectect 
//  =============================================================================

module I2CDetect
(
	PCLK,
	PRESETn,

	ArbitCheck,
	SCL_i,
	SDA_i,	

	SCL_o,
	SDA_o,

	DSCL,
	DDSCL,

	DSCL_o,

	ReadData,

	ClkEn,
	BusyDet,
	StartDet,
	StopDet,
	ArbitLostDet

);

input 	PCLK;
input	PRESETn;

input	ArbitCheck;
input	SCL_i;
input	SDA_i;

input	SCL_o;
input	SDA_o;

output	DSCL;
output	DDSCL;
output	DSCL_o;


input	[7:0]ReadData;
input	ClkEn; // Clock Transition Signal

output	BusyDet;
output	StartDet;
output	StopDet;
output	ArbitLostDet;

reg	SCL_iSync;
reg	SDA_iSync;
reg	IntSCL	;
reg	IntSDA	;
reg	DIntSCL	;
reg	DIntSDA	;

// Input Synchronization
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	SCL_iSync 	<= 1'b1;
	SDA_iSync 	<= 1'b1;
	IntSCL 		<= 1'b1; 
	IntSDA 		<= 1'b1;
	DIntSCL 	<= 1'b1;
	DIntSDA		<= 1'b1;
	end
	else
	begin
	SCL_iSync 	<= SCL_i;
	SDA_iSync	<= SDA_i;	
	IntSCL 		<= SCL_iSync;
	IntSDA 		<= SDA_iSync;
	DIntSCL 	<= IntSCL;
	DIntSDA 	<= IntSDA;
	end
end


reg	SCL_oSync;
reg	SDA_oSync;
reg	DSCL_o;
reg	DSDA_o;
// Input and  output Synchronization for input comparation
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	SCL_oSync 	<= 1'b1;
	SDA_oSync	<= 1'b1;
	DSCL_o		<= 1'b1;
	DSDA_o		<= 1'b1;
	end
	else
	begin
	SCL_oSync	<= SCL_o;
	SDA_oSync 	<= SDA_o;
	DSCL_o		<= SCL_oSync;
	DSDA_o		<= SDA_oSync;
	
	end
end

// I2C Start Detect
// I2C Stop Detect
// I2C Arbitration Lost Detect

assign DSCL = IntSCL;
assign DDSCL = DIntSCL;


reg	StartDet;
reg	StopDet;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	StartDet <= 0;
	StopDet	<= 0;
	end
	else //if (ClkEn) 
	begin
	StartDet <= IntSCL & DIntSCL & ~IntSDA & DIntSDA;
	StopDet	 <= IntSCL & DIntSCL & IntSDA & ~DIntSDA;
	end
end

reg	BusyDet;

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	BusyDet <=0;
	else 
		begin
		if (~IntSCL|~IntSDA)
		BusyDet <= 1;
		else if (StopDet)
		BusyDet <= 0;
		end
end 

// olny  Master Tx mode Valid value

reg	ArbitLostDet;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	ArbitLostDet <=0;
	else //if ()
		if (StopDet|StartDet|~ArbitCheck)
		ArbitLostDet <= 0;
		else if (~IntSDA && DSDA_o && IntSCL&ArbitCheck)
		ArbitLostDet <= 1;
end

endmodule

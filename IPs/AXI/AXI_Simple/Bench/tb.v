/*****************************************************************
		         TestMaster Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset
always #CLK_HALFPERIOD	ACLK = ~ACLK;
initial ACLK 		= 0;     // clock
initial
begin
	ARESETn 	= 0;     // reset
	repeat(10) @(posedge ACLK);
	ARESETn	= 1;
end

parameter BUS_WID =    32;
parameter ADDR_WID=    32;
parameter ID_WID  =    4;
parameter AWLEN_WID=   4;
parameter AWSIZE_WID=  3;
parameter AWBURST_WID= 2;
parameter AWLOCK_WID=  2;
parameter AWCACHE_WID= 4;
parameter AWPROT_WID=  3;

parameter WSTRB_WID=   4;
parameter BRESP_WID=   2;
parameter RRESP_WID=   2;
parameter ARLEN_WID=   4;
parameter ARSIZE_WID=  3;
parameter ARBURST_WID= 2;
parameter ARLOCK_WID=  2;
parameter ARCACHE_WID= 4;
parameter ARPROT_WID=  3;

parameter MASTERWID = 4;
parameter SLAVEWID  = 3;


//For Master 0
//Write address channel
wire  [ID_WID-1:0]       AWIDm02si0;    
wire  [ADDR_WID-1:0]     AWADDRm02si0;
wire  [AWLEN_WID-1:0]    AWLENm02si0;
wire  [AWSIZE_WID-1:0]   AWSIZEm02si0;  
wire  [AWBURST_WID-1:0]  AWBURSTm02si0; 
wire  [AWLOCK_WID-1:0]   AWLOCKm02si0;  
wire  [AWCACHE_WID-1:0]  AWCACHEm02si0; 
wire  [AWPROT_WID-1:0]   AWPROTm02si0;  

wire  AWVALIDm02si0; 
wire  AWREADYsi02m0; 

//Write data channel
wire  [ID_WID-1:0]       WIDm02si0;     
wire  [BUS_WID-1:0]      WDATAm02si0;   
wire  [WSTRB_WID-1:0]    WSTRBm02si0;   
wire  WLASTm02si0;   
wire  WVALIDm02si0;  
wire  WREADYsi02m0;  

//Write response channel
wire   [ID_WID-1:0]      BIDsi02m0;     
wire   [BRESP_WID-1:0]   BRESPsi02m0;   
wire   BVALIDsi02m0;  
wire   BREADYm02si0;  

//For Master 1
//Write address channel
wire  [ID_WID-1:0]       AWIDm12si1;    
wire  [ADDR_WID-1:0]     AWADDRm12si1;
wire  [AWLEN_WID-1:0]    AWLENm12si1;
wire  [AWSIZE_WID-1:0]   AWSIZEm12si1;  
wire  [AWBURST_WID-1:0]  AWBURSTm12si1; 
wire  [AWLOCK_WID-1:0]   AWLOCKm12si1;  
wire  [AWCACHE_WID-1:0]  AWCACHEm12si1; 
wire  [AWPROT_WID-1:0]   AWPROTm12si1;  

wire  AWVALIDm12si1; 
wire  AWREADYsi12m1; 

//Write data channel
wire  [ID_WID-1:0]       WIDm12si1;     
wire  [BUS_WID-1:0]      WDATAm12si1;   
wire  [WSTRB_WID-1:0]    WSTRBm12si1;   
wire  WLASTm12si1;   
wire  WVALIDm12si1;  
wire  WREADYsi12m1;  

//Write response channel
wire   [ID_WID-1:0]      BIDsi12m1;     
wire   [BRESP_WID-1:0]   BRESPsi12m1;   
wire   BVALIDsi12m1;  
wire   BREADYm12si1;  

//For Master 2
//Write address channel
wire  [ID_WID-1:0]       AWIDm22si2;    
wire  [ADDR_WID-1:0]     AWADDRm22si2;
wire  [AWLEN_WID-1:0]    AWLENm22si2;
wire  [AWSIZE_WID-1:0]   AWSIZEm22si2;  
wire  [AWBURST_WID-1:0]  AWBURSTm22si2; 
wire  [AWLOCK_WID-1:0]   AWLOCKm22si2;  
wire  [AWCACHE_WID-1:0]  AWCACHEm22si2; 
wire  [AWPROT_WID-1:0]   AWPROTm22si2;  

wire  AWVALIDm22si2; 
wire  AWREADYsi22m2; 

//Write data channel
wire  [ID_WID-1:0]       WIDm22si2;     
wire  [BUS_WID-1:0]      WDATAm22si2;   
wire  [WSTRB_WID-1:0]    WSTRBm22si2;   
wire  WLASTm22si2;   
wire  WVALIDm22si2;  
wire  WREADYsi22m2;  

//Write response channel
wire   [ID_WID-1:0]      BIDsi22m2;     
wire   [BRESP_WID-1:0]   BRESPsi22m2;   
wire   BVALIDsi22m2;  
wire   BREADYm22si2;  

//For Master 3
//Write address channel
wire  [ID_WID-1:0]       AWIDm32si3;    
wire  [ADDR_WID-1:0]     AWADDRm32si3;
wire  [AWLEN_WID-1:0]    AWLENm32si3;
wire  [AWSIZE_WID-1:0]   AWSIZEm32si3;  
wire  [AWBURST_WID-1:0]  AWBURSTm32si3; 
wire  [AWLOCK_WID-1:0]   AWLOCKm32si3;  
wire  [AWCACHE_WID-1:0]  AWCACHEm32si3; 
wire  [AWPROT_WID-1:0]   AWPROTm32si3;  

wire  AWVALIDm32si3; 
wire  AWREADYsi32m3; 

//Write data channel
wire  [ID_WID-1:0]       WIDm32si3;     
wire  [BUS_WID-1:0]      WDATAm32si3;   
wire  [WSTRB_WID-1:0]    WSTRBm32si3;   
wire  WLASTm32si3;   
wire  WVALIDm32si3;  
wire  WREADYsi32m3;  

//Write response channel
wire   [ID_WID-1:0]      BIDsi32m3;     
wire   [BRESP_WID-1:0]   BRESPsi32m3;   
wire   BVALIDsi32m3;  
wire   BREADYm32si3;  

// For slave 0
wire   [(ID_WID+MASTERWID-1):0]       AWIDmi02s0;    
wire   [ADDR_WID-1:0]     AWADDRmi02s0;
wire   [AWLEN_WID-1:0]    AWLENmi02s0;
wire   [AWSIZE_WID-1:0]   AWSIZEmi02s0;  
wire   [AWBURST_WID-1:0]  AWBURSTmi02s0; 
wire   [AWLOCK_WID-1:0]   AWLOCKmi02s0;  
wire   [AWCACHE_WID-1:0]  AWCACHEmi02s0; 
wire   [AWPROT_WID-1:0]   AWPROTmi02s0;  

wire   AWVALIDmi02s0; 
wire   AWREADYs02mi0; 


//Write data channel
wire   [(ID_WID+MASTERWID-1):0]       WIDmi02s0;     
wire   [BUS_WID-1:0]      WDATAmi02s0;   
wire   [WSTRB_WID-1:0]    WSTRBmi02s0;   
wire   WLASTmi02s0;   
wire   WVALIDmi02s0;  
wire   WREADYs02mi0; 

//Write response channel
wire  [(ID_WID+MASTERWID-1):0]      BIDs02mi0;     
wire  [BRESP_WID-1:0]   BRESPs02mi0;   
wire  BVALIDs02mi0;  
wire  BREADYmi02s0;  


// For slave 1
// Write address channel
wire   [(ID_WID+MASTERWID-1):0]       AWIDmi12s1;    
wire   [ADDR_WID-1:0]     AWADDRmi12s1;
wire   [AWLEN_WID-1:0]    AWLENmi12s1;
wire   [AWSIZE_WID-1:0]   AWSIZEmi12s1;  
wire   [AWBURST_WID-1:0]  AWBURSTmi12s1; 
wire   [AWLOCK_WID-1:0]   AWLOCKmi12s1;  
wire   [AWCACHE_WID-1:0]  AWCACHEmi12s1; 
wire   [AWPROT_WID-1:0]   AWPROTmi12s1;  

wire   AWVALIDmi12s1; 
wire   AWREADYs12mi1; 


//Write data channel
wire   [(ID_WID+MASTERWID-1):0]       WIDmi12s1;     
wire   [BUS_WID-1:0]      WDATAmi12s1;   
wire   [WSTRB_WID-1:0]    WSTRBmi12s1;   
wire   WLASTmi12s1;   
wire   WVALIDmi12s1;  
wire   WREADYs12mi1; 

//Write response channel
wire  [(ID_WID+MASTERWID-1):0]      BIDs12mi1;     
wire  [BRESP_WID-1:0]   BRESPs12mi1;   
wire  BVALIDs12mi1;  
wire  BREADYmi12s1;  



// For Slave 2
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       AWIDmi22s2;    
wire   [ADDR_WID-1:0]     AWADDRmi22s2;
wire   [AWLEN_WID-1:0]    AWLENmi22s2;
wire   [AWSIZE_WID-1:0]   AWSIZEmi22s2;  
wire   [AWBURST_WID-1:0]  AWBURSTmi22s2; 
wire   [AWLOCK_WID-1:0]   AWLOCKmi22s2;  
wire   [AWCACHE_WID-1:0]  AWCACHEmi22s2; 
wire   [AWPROT_WID-1:0]   AWPROTmi22s2;  

wire   AWVALIDmi22s2; 
wire   AWREADYs22mi2; 


//Write data channel
wire   [(ID_WID+MASTERWID-1):0]       WIDmi22s2;     
wire   [BUS_WID-1:0]      WDATAmi22s2;   
wire   [WSTRB_WID-1:0]    WSTRBmi22s2;   
wire   WLASTmi22s2;   
wire   WVALIDmi22s2;  
wire   WREADYs22mi2; 

//Write response channel
wire  [(ID_WID+MASTERWID-1):0]      BIDs22mi2;     
wire  [BRESP_WID-1:0]   BRESPs22mi2;   
wire  BVALIDs22mi2;  
wire  BREADYmi22s2;  


// For slave 3
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       AWIDmi32s3;    
wire   [ADDR_WID-1:0]     AWADDRmi32s3;
wire   [AWLEN_WID-1:0]    AWLENmi32s3;
wire   [AWSIZE_WID-1:0]   AWSIZEmi32s3;  
wire   [AWBURST_WID-1:0]  AWBURSTmi32s3; 
wire   [AWLOCK_WID-1:0]   AWLOCKmi32s3;  
wire   [AWCACHE_WID-1:0]  AWCACHEmi32s3; 
wire   [AWPROT_WID-1:0]   AWPROTmi32s3;  

wire   AWVALIDmi32s3; 
wire   AWREADYs32mi3; 


//Write data channel
wire   [(ID_WID+MASTERWID-1):0]       WIDmi32s3;     
wire   [BUS_WID-1:0]      WDATAmi32s3;   
wire   [WSTRB_WID-1:0]    WSTRBmi32s3;   
wire   WLASTmi32s3;   
wire   WVALIDmi32s3;  
wire   WREADYs32mi3; 

//Write response channel
wire  [(ID_WID+MASTERWID-1):0]      BIDs32mi3;     
wire  [BRESP_WID-1:0]   BRESPs32mi3;   
wire  BVALIDs32mi3;  
wire  BREADYmi32s3;  


// For slave 4
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       AWIDmi42s4;    
wire   [ADDR_WID-1:0]     AWADDRmi42s4;
wire   [AWLEN_WID-1:0]    AWLENmi42s4;
wire   [AWSIZE_WID-1:0]   AWSIZEmi42s4;  
wire   [AWBURST_WID-1:0]  AWBURSTmi42s4; 
wire   [AWLOCK_WID-1:0]   AWLOCKmi42s4;  
wire   [AWCACHE_WID-1:0]  AWCACHEmi42s4; 
wire   [AWPROT_WID-1:0]   AWPROTmi42s4;  

wire   AWVALIDmi42s4; 
wire   AWREADYs42mi4; 


//Write data channel
wire   [(ID_WID+MASTERWID-1):0]       WIDmi42s4;     
wire   [BUS_WID-1:0]      WDATAmi42s4;   
wire   [WSTRB_WID-1:0]    WSTRBmi42s4;   
wire   WLASTmi42s4;   
wire   WVALIDmi42s4;  
wire   WREADYs42mi4; 

//Write response channel
wire  [(ID_WID+MASTERWID-1):0]      BIDs42mi4;     
wire  [BRESP_WID-1:0]   BRESPs42mi4;   
wire  BVALIDs42mi4;  
wire  BREADYmi42s4;  



// For slave 5
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       AWIDmi52s5;    
wire   [ADDR_WID-1:0]     AWADDRmi52s5;
wire   [AWLEN_WID-1:0]    AWLENmi52s5;
wire   [AWSIZE_WID-1:0]   AWSIZEmi52s5;  
wire   [AWBURST_WID-1:0]  AWBURSTmi52s5; 
wire   [AWLOCK_WID-1:0]   AWLOCKmi52s5;  
wire   [AWCACHE_WID-1:0]  AWCACHEmi52s5; 
wire   [AWPROT_WID-1:0]   AWPROTmi52s5;  

wire   AWVALIDmi52s5; 
wire   AWREADYs52mi5; 

//Write data channel
wire   [(ID_WID+MASTERWID-1):0]       WIDmi52s5;     
wire   [BUS_WID-1:0]      WDATAmi52s5;   
wire   [WSTRB_WID-1:0]    WSTRBmi52s5;   
wire   WLASTmi52s5;   
wire   WVALIDmi52s5;  
wire   WREADYs52mi5; 

//Write response channel
wire  [(ID_WID+MASTERWID-1):0]      BIDs52mi5;     
wire  [BRESP_WID-1:0]   BRESPs52mi5;   
wire  BVALIDs52mi5;  
wire  BREADYmi52s5;  

//_______________________________________________________________
//For Master 0
//Read address channel
wire  [ID_WID-1:0]       ARIDm02si0;    
wire  [ADDR_WID-1:0]     ARADDRm02si0;
wire  [ARLEN_WID-1:0]    ARLENm02si0;
wire  [ARSIZE_WID-1:0]   ARSIZEm02si0;  
wire  [ARBURST_WID-1:0]  ARBURSTm02si0; 
wire  [ARLOCK_WID-1:0]   ARLOCKm02si0;  
wire  [ARCACHE_WID-1:0]  ARCACHEm02si0; 
wire  [ARPROT_WID-1:0]   ARPROTm02si0;  

wire  ARVALIDm02si0; 
wire  ARREADYsi02m0; 

//Read data channel
wire   [ID_WID-1:0]      RIDsi02m0;     
wire   [BRESP_WID-1:0]   RRESPsi02m0;   
wire   [BUS_WID-1:0]     RDATAsi02m0;
wire   RLASTsi02m0;
wire   RVALIDsi02m0;  
wire   RREADYm02si0;  


//_______________________________________________________________
//For Master 1
//Read address channel
wire  [ID_WID-1:0]       ARIDm12si1;    
wire  [ADDR_WID-1:0]     ARADDRm12si1;
wire  [ARLEN_WID-1:0]    ARLENm12si1;
wire  [ARSIZE_WID-1:0]   ARSIZEm12si1;  
wire  [ARBURST_WID-1:0]  ARBURSTm12si1; 
wire  [ARLOCK_WID-1:0]   ARLOCKm12si1;  
wire  [ARCACHE_WID-1:0]  ARCACHEm12si1; 
wire  [ARPROT_WID-1:0]   ARPROTm12si1;  

wire  ARVALIDm12si1; 
wire  ARREADYsi12m1; 

//Read data channel
wire   [ID_WID-1:0]      RIDsi12m1;     
wire   [BRESP_WID-1:0]   RRESPsi12m1;   
wire   [BUS_WID-1:0]     RDATAsi12m1;
wire   RLASTsi12m1;
wire   RVALIDsi12m1;  
wire   RREADYm12si1;  


//_______________________________________________________________
//For Master 2
//Read address channel
wire  [ID_WID-1:0]       ARIDm22si2;    
wire  [ADDR_WID-1:0]     ARADDRm22si2;
wire  [ARLEN_WID-1:0]    ARLENm22si2;
wire  [ARSIZE_WID-1:0]   ARSIZEm22si2;  
wire  [ARBURST_WID-1:0]  ARBURSTm22si2; 
wire  [ARLOCK_WID-1:0]   ARLOCKm22si2;  
wire  [ARCACHE_WID-1:0]  ARCACHEm22si2; 
wire  [ARPROT_WID-1:0]   ARPROTm22si2;  

wire  ARVALIDm22si2; 
wire  ARREADYsi22m2; 

//Read data channel
wire   [ID_WID-1:0]      RIDsi22m2;     
wire   [BRESP_WID-1:0]   RRESPsi22m2;   
wire   [BUS_WID-1:0]     RDATAsi22m2;
wire   RLASTsi22m2;
wire   RVALIDsi22m2;  
wire   RREADYm22si2;  


//_______________________________________________________________
//For Master 3
//Read address channel
wire  [ID_WID-1:0]       ARIDm32si3;    
wire  [ADDR_WID-1:0]     ARADDRm32si3;
wire  [ARLEN_WID-1:0]    ARLENm32si3;
wire  [ARSIZE_WID-1:0]   ARSIZEm32si3;  
wire  [ARBURST_WID-1:0]  ARBURSTm32si3; 
wire  [ARLOCK_WID-1:0]   ARLOCKm32si3;  
wire  [ARCACHE_WID-1:0]  ARCACHEm32si3; 
wire  [ARPROT_WID-1:0]   ARPROTm32si3;  

wire  ARVALIDm32si3; 
wire  ARREADYsi32m3; 

//Read data channel
wire   [ID_WID-1:0]      RIDsi32m3;     
wire   [BRESP_WID-1:0]   RRESPsi32m3;   
wire   [BUS_WID-1:0]     RDATAsi32m3;
wire   RLASTsi32m3;
wire   RVALIDsi32m3;  
wire   RREADYm32si3;  



//_______________________________________________________________
// For slave 0
// Read address channel
wire   [(ID_WID+MASTERWID-1):0]       ARIDmi02s0;    
wire   [ADDR_WID-1:0]     ARADDRmi02s0;
wire   [ARLEN_WID-1:0]    ARLENmi02s0;
wire   [ARSIZE_WID-1:0]   ARSIZEmi02s0;  
wire   [ARBURST_WID-1:0]  ARBURSTmi02s0; 
wire   [ARLOCK_WID-1:0]   ARLOCKmi02s0;  
wire   [ARCACHE_WID-1:0]  ARCACHEmi02s0; 
wire   [ARPROT_WID-1:0]   ARPROTmi02s0;  

wire   ARVALIDmi02s0; 
wire   ARREADYs02mi0; 


//Read data channel
wire  [(ID_WID+MASTERWID-1):0]      RIDs02mi0;     
wire  [RRESP_WID-1:0]   RRESPs02mi0;   
wire  [BUS_WID-1:0]RDATAs02mi0;  
wire  RLASTs02mi0;  
wire  RVALIDs02mi0;  
wire  RREADYmi02s0;  


// For slave 1
// Read address channel
wire   [(ID_WID+MASTERWID-1):0]       ARIDmi12s1;    
wire   [ADDR_WID-1:0]     ARADDRmi12s1;
wire   [ARLEN_WID-1:0]    ARLENmi12s1;
wire   [ARSIZE_WID-1:0]   ARSIZEmi12s1;  
wire   [ARBURST_WID-1:0]  ARBURSTmi12s1; 
wire   [ARLOCK_WID-1:0]   ARLOCKmi12s1;  
wire   [ARCACHE_WID-1:0]  ARCACHEmi12s1; 
wire   [ARPROT_WID-1:0]   ARPROTmi12s1;  

wire   ARVALIDmi12s1; 
wire   ARREADYs12mi1; 

//Read data channel
wire  [(ID_WID+MASTERWID-1):0]      RIDs12mi1;     
wire  [RRESP_WID-1:0]   RRESPs12mi1;   
wire  [BUS_WID-1:0]RDATAs12mi1;  
wire  RLASTs12mi1;  
wire  RVALIDs12mi1;  
wire  RREADYmi12s1;  



// For Slave 2
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       ARIDmi22s2;    
wire   [ADDR_WID-1:0]     ARADDRmi22s2;
wire   [ARLEN_WID-1:0]    ARLENmi22s2;
wire   [ARSIZE_WID-1:0]   ARSIZEmi22s2;  
wire   [ARBURST_WID-1:0]  ARBURSTmi22s2; 
wire   [ARLOCK_WID-1:0]   ARLOCKmi22s2;  
wire   [ARCACHE_WID-1:0]  ARCACHEmi22s2; 
wire   [ARPROT_WID-1:0]   ARPROTmi22s2;  

wire   ARVALIDmi22s2; 
wire   ARREADYs22mi2; 

//Read data channel
wire  [(ID_WID+MASTERWID-1):0]      RIDs22mi2;     
wire  [RRESP_WID-1:0]   RRESPs22mi2;   
wire  [BUS_WID-1:0]RDATAs22mi2;  
wire  RLASTs22mi2;  
wire  RVALIDs22mi2;  
wire  RREADYmi22s2;  


// For slave 3
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       ARIDmi32s3;    
wire   [ADDR_WID-1:0]     ARADDRmi32s3;
wire   [ARLEN_WID-1:0]    ARLENmi32s3;
wire   [ARSIZE_WID-1:0]   ARSIZEmi32s3;  
wire   [ARBURST_WID-1:0]  ARBURSTmi32s3; 
wire   [ARLOCK_WID-1:0]   ARLOCKmi32s3;  
wire   [ARCACHE_WID-1:0]  ARCACHEmi32s3; 
wire   [ARPROT_WID-1:0]   ARPROTmi32s3;  

wire   ARVALIDmi32s3; 
wire   ARREADYs32mi3; 

//Read data channel
wire  [(ID_WID+MASTERWID-1):0]      RIDs32mi3;     
wire  [RRESP_WID-1:0]   RRESPs32mi3;   
wire  [BUS_WID-1:0]RDATAs32mi3;  
wire  RLASTs32mi3;  
wire  RVALIDs32mi3;  
wire  RREADYmi32s3;  


// For slave 4
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       ARIDmi42s4;    
wire   [ADDR_WID-1:0]     ARADDRmi42s4;
wire   [ARLEN_WID-1:0]    ARLENmi42s4;
wire   [ARSIZE_WID-1:0]   ARSIZEmi42s4;  
wire   [ARBURST_WID-1:0]  ARBURSTmi42s4; 
wire   [ARLOCK_WID-1:0]   ARLOCKmi42s4;  
wire   [ARCACHE_WID-1:0]  ARCACHEmi42s4; 
wire   [ARPROT_WID-1:0]   ARPROTmi42s4;  

wire   ARVALIDmi42s4; 
wire   ARREADYs42mi4; 

//Read data channel
wire  [(ID_WID+MASTERWID-1):0]      RIDs42mi4;     
wire  [RRESP_WID-1:0]   RRESPs42mi4;   
wire  [BUS_WID-1:0]RDATAs42mi4;  
wire  RLASTs42mi4;  
wire  RVALIDs42mi4;  
wire  RREADYmi42s4;  

// For slave 5
// Wriet address channel
wire   [(ID_WID+MASTERWID-1):0]       ARIDmi52s5;    
wire   [ADDR_WID-1:0]     ARADDRmi52s5;
wire   [ARLEN_WID-1:0]    ARLENmi52s5;
wire   [ARSIZE_WID-1:0]   ARSIZEmi52s5;  
wire   [ARBURST_WID-1:0]  ARBURSTmi52s5; 
wire   [ARLOCK_WID-1:0]   ARLOCKmi52s5;  
wire   [ARCACHE_WID-1:0]  ARCACHEmi52s5; 
wire   [ARPROT_WID-1:0]   ARPROTmi52s5;  

wire   ARVALIDmi52s5; 
wire   ARREADYs52mi5; 

//Read data channel
wire  [(ID_WID+MASTERWID-1):0]      RIDs52mi5;     
wire  [RRESP_WID-1:0]   RRESPs52mi5;   
wire  [BUS_WID-1:0]RDATAs52mi5;  
wire  RLASTs52mi5;  
wire  RVALIDs52mi5;  
wire  RREADYmi52s5;  

SBUS SBUS(

    .ACLK          (ACLK),
    .ARESETn       (ARESETn),

    //_______________________________________________________________
    //For Master 0
    //Write address channel
    .AWIDm02si0    (AWIDm02si0),
    .AWADDRm02si0  (AWADDRm02si0),
    .AWLENm02si0   (AWLENm02si0),
    .AWSIZEm02si0  (AWSIZEm02si0),
    .AWBURSTm02si0 (AWBURSTm02si0), 
    .AWLOCKm02si0  (AWLOCKm02si0),
    .AWCACHEm02si0 (AWCACHEm02si0),
    .AWPROTm02si0  (AWPROTm02si0),

    .AWVALIDm02si0 (AWVALIDm02si0),
    .AWREADYsi02m0 (AWREADYsi02m0),

    //Write data channel
    .WIDm02si0     (WIDm02si0),
    .WDATAm02si0   (WDATAm02si0),
    .WSTRBm02si0   (WSTRBm02si0),
    .WLASTm02si0   (WLASTm02si0),
    .WVALIDm02si0  (WVALIDm02si0),
    .WREADYsi02m0  (WREADYsi02m0),

    //Write response channel
    .BIDsi02m0     (BIDsi02m0),
    .BRESPsi02m0   (BRESPsi02m0),
    .BVALIDsi02m0  (BVALIDsi02m0),
    .BREADYm02si0  (BREADYm02si0),


    //_______________________________________________________________
    //For Master 1
    //Write address channel
    .AWIDm12si1    (AWIDm12si1),
    .AWADDRm12si1  (AWADDRm12si1),
    .AWLENm12si1   (AWLENm12si1),
    .AWSIZEm12si1  (AWSIZEm12si1),
    .AWBURSTm12si1 (AWBURSTm12si1), 
    .AWLOCKm12si1  (AWLOCKm12si1),
    .AWCACHEm12si1 (AWCACHEm12si1),
    .AWPROTm12si1  (AWPROTm12si1),

    .AWVALIDm12si1 (AWVALIDm12si1),
    .AWREADYsi12m1 (AWREADYsi12m1),

    //Write data channel
    .WIDm12si1     (WIDm12si1),
    .WDATAm12si1   (WDATAm12si1),
    .WSTRBm12si1   (WSTRBm12si1),
    .WLASTm12si1   (WLASTm12si1),
    .WVALIDm12si1  (WVALIDm12si1),
    .WREADYsi12m1  (WREADYsi12m1),

    //Write response channel
    .BIDsi12m1     (BIDsi12m1),
    .BRESPsi12m1   (BRESPsi12m1),
    .BVALIDsi12m1  (BVALIDsi12m1),
    .BREADYm12si1  (BREADYm12si1),


    //_______________________________________________________________
    //For Master 2
    //Write address channel
    .AWIDm22si2    (AWIDm22si2),
    .AWADDRm22si2  (AWADDRm22si2),
    .AWLENm22si2   (AWLENm22si2),
    .AWSIZEm22si2  (AWSIZEm22si2),
    .AWBURSTm22si2 (AWBURSTm22si2), 
    .AWLOCKm22si2  (AWLOCKm22si2),
    .AWCACHEm22si2 (AWCACHEm22si2),
    .AWPROTm22si2  (AWPROTm22si2),

    .AWVALIDm22si2 (AWVALIDm22si2),
    .AWREADYsi22m2 (AWREADYsi22m2),

    //Write data channel
    .WIDm22si2     (WIDm22si2),
    .WDATAm22si2   (WDATAm22si2),
    .WSTRBm22si2   (WSTRBm22si2),
    .WLASTm22si2   (WLASTm22si2),
    .WVALIDm22si2  (WVALIDm22si2),
    .WREADYsi22m2  (WREADYsi22m2),

    //Write response channel
    .BIDsi22m2     (BIDsi22m2),
    .BRESPsi22m2   (BRESPsi22m2),
    .BVALIDsi22m2  (BVALIDsi22m2),
    .BREADYm22si2  (BREADYm22si2),

    //_______________________________________________________________
    //For Master 3
    //Write address channel
    .AWIDm32si3    (AWIDm32si3),
    .AWADDRm32si3  (AWADDRm32si3),
    .AWLENm32si3   (AWLENm32si3),
    .AWSIZEm32si3  (AWSIZEm32si3),
    .AWBURSTm32si3 (AWBURSTm32si3), 
    .AWLOCKm32si3  (AWLOCKm32si3),
    .AWCACHEm32si3 (AWCACHEm32si3),
    .AWPROTm32si3  (AWPROTm32si3),

    .AWVALIDm32si3 (AWVALIDm32si3),
    .AWREADYsi32m3 (AWREADYsi32m3),

    //Write data channel
    .WIDm32si3     (WIDm32si3),
    .WDATAm32si3   (WDATAm32si3),
    .WSTRBm32si3   (WSTRBm32si3),
    .WLASTm32si3   (WLASTm32si3),
    .WVALIDm32si3  (WVALIDm32si3),
    .WREADYsi32m3  (WREADYsi32m3),

    //Write response channel
    .BIDsi32m3     (BIDsi32m3),
    .BRESPsi32m3   (BRESPsi32m3),
    .BVALIDsi32m3  (BVALIDsi32m3),
    .BREADYm32si3  (BREADYm32si3),
    
    //_______________________________________________________________
    
    //For Slave 0
    //Write address channel
    .AWIDmi02s0    (AWIDmi02s0),
    .AWADDRmi02s0  (AWADDRmi02s0),
    .AWLENmi02s0   (AWLENmi02s0),
    .AWSIZEmi02s0  (AWSIZEmi02s0),
    .AWBURSTmi02s0 (AWBURSTmi02s0),
    .AWLOCKmi02s0  (AWLOCKmi02s0),
    .AWCACHEmi02s0 (AWCACHEmi02s0),
    .AWPROTmi02s0  (AWPROTmi02s0),

    .AWVALIDmi02s0 (AWVALIDmi02s0),
    .AWREADYs02mi0 (AWREADYs02mi0),

    //Write data channel
    .WIDmi02s0     (WIDmi02s0),
    .WDATAmi02s0   (WDATAmi02s0),
    .WSTRBmi02s0   (WSTRBmi02s0),
    .WLASTmi02s0   (WLASTmi02s0),
    .WVALIDmi02s0  (WVALIDmi02s0),
    .WREADYs02mi0  (WREADYs02mi0),

    //Write response channel
    .BIDs02mi0     (BIDs02mi0),
    .BRESPs02mi0   (BRESPs02mi0),
    .BVALIDs02mi0  (BVALIDs02mi0),
    .BREADYmi02s0  (BREADYmi02s0),


    //_______________________________________________________________

    //For Slave 1
    //Write address channel
    .AWIDmi12s1    (AWIDmi12s1),
    .AWADDRmi12s1  (AWADDRmi12s1),
    .AWLENmi12s1   (AWLENmi12s1),
    .AWSIZEmi12s1  (AWSIZEmi12s1),
    .AWBURSTmi12s1 (AWBURSTmi12s1),
    .AWLOCKmi12s1  (AWLOCKmi12s1),
    .AWCACHEmi12s1 (AWCACHEmi12s1),
    .AWPROTmi12s1  (AWPROTmi12s1),

    .AWVALIDmi12s1 (AWVALIDmi12s1),
    .AWREADYs12mi1 (AWREADYs12mi1),

    //Write data channel
    .WIDmi12s1     (WIDmi12s1),
    .WDATAmi12s1   (WDATAmi12s1),
    .WSTRBmi12s1   (WSTRBmi12s1),
    .WLASTmi12s1   (WLASTmi12s1),
    .WVALIDmi12s1  (WVALIDmi12s1),
    .WREADYs12mi1  (WREADYs12mi1),

    //Write response channel
    .BIDs12mi1     (BIDs12mi1),
    .BRESPs12mi1   (BRESPs12mi1),
    .BVALIDs12mi1  (BVALIDs12mi1),
    .BREADYmi12s1  (BREADYmi12s1),
    
    //_______________________________________________________________


    //For Slave 2
    //Write address channel
    .AWIDmi22s2    (AWIDmi22s2),
    .AWADDRmi22s2  (AWADDRmi22s2),
    .AWLENmi22s2   (AWLENmi22s2),
    .AWSIZEmi22s2  (AWSIZEmi22s2),
    .AWBURSTmi22s2 (AWBURSTmi22s2),
    .AWLOCKmi22s2  (AWLOCKmi22s2),
    .AWCACHEmi22s2 (AWCACHEmi22s2),
    .AWPROTmi22s2  (AWPROTmi22s2),

    .AWVALIDmi22s2 (AWVALIDmi22s2),
    .AWREADYs22mi2 (AWREADYs22mi2),

    //Write data channel
    .WIDmi22s2     (WIDmi22s2),
    .WDATAmi22s2   (WDATAmi22s2),
    .WSTRBmi22s2   (WSTRBmi22s2),
    .WLASTmi22s2   (WLASTmi22s2),
    .WVALIDmi22s2  (WVALIDmi22s2),
    .WREADYs22mi2  (WREADYs22mi2),

    //Write response channel
    .BIDs22mi2     (BIDs22mi2),
    .BRESPs22mi2   (BRESPs22mi2),
    .BVALIDs22mi2  (BVALIDs22mi2),
    .BREADYmi22s2  (BREADYmi22s2),

    
    //_______________________________________________________________
    
    
    //For Slave 3
    //Write address channel
    .AWIDmi32s3    (AWIDmi32s3),
    .AWADDRmi32s3  (AWADDRmi32s3),
    .AWLENmi32s3   (AWLENmi32s3),
    .AWSIZEmi32s3  (AWSIZEmi32s3),
    .AWBURSTmi32s3 (AWBURSTmi32s3),
    .AWLOCKmi32s3  (AWLOCKmi32s3),
    .AWCACHEmi32s3 (AWCACHEmi32s3),
    .AWPROTmi32s3  (AWPROTmi32s3),

    .AWVALIDmi32s3 (AWVALIDmi32s3),
    .AWREADYs32mi3 (AWREADYs32mi3),

    //Write data channel
    .WIDmi32s3     (WIDmi32s3),
    .WDATAmi32s3   (WDATAmi32s3),
    .WSTRBmi32s3   (WSTRBmi32s3),
    .WLASTmi32s3   (WLASTmi32s3),
    .WVALIDmi32s3  (WVALIDmi32s3),
    .WREADYs32mi3  (WREADYs32mi3),

    //Write response channel
    .BIDs32mi3     (BIDs32mi3),
    .BRESPs32mi3   (BRESPs32mi3),
    .BVALIDs32mi3  (BVALIDs32mi3),
    .BREADYmi32s3  (BREADYmi32s3),
    
    
    //_______________________________________________________________
    
    //For Slave 4
    //Write address channel
    .AWIDmi42s4    (AWIDmi42s4),
    .AWADDRmi42s4  (AWADDRmi42s4),
    .AWLENmi42s4   (AWLENmi42s4),
    .AWSIZEmi42s4  (AWSIZEmi42s4),
    .AWBURSTmi42s4 (AWBURSTmi42s4),
    .AWLOCKmi42s4  (AWLOCKmi42s4),
    .AWCACHEmi42s4 (AWCACHEmi42s4),
    .AWPROTmi42s4  (AWPROTmi42s4),

    .AWVALIDmi42s4 (AWVALIDmi42s4),
    .AWREADYs42mi4 (AWREADYs42mi4),

    //Write data channel
    .WIDmi42s4     (WIDmi42s4),
    .WDATAmi42s4   (WDATAmi42s4),
    .WSTRBmi42s4   (WSTRBmi42s4),
    .WLASTmi42s4   (WLASTmi42s4),
    .WVALIDmi42s4  (WVALIDmi42s4),
    .WREADYs42mi4  (WREADYs42mi4),

    //Write response channel
    .BIDs42mi4     (BIDs42mi4),
    .BRESPs42mi4   (BRESPs42mi4),
    .BVALIDs42mi4  (BVALIDs42mi4),
    .BREADYmi42s4  (BREADYmi42s4),
    
    //_______________________________________________________________
    
    
    //For Slave 5
    //Write address channel
    .AWIDmi52s5    (AWIDmi52s5),
    .AWADDRmi52s5  (AWADDRmi52s5),
    .AWLENmi52s5   (AWLENmi52s5),
    .AWSIZEmi52s5  (AWSIZEmi52s5),
    .AWBURSTmi52s5 (AWBURSTmi52s5),
    .AWLOCKmi52s5  (AWLOCKmi52s5),
    .AWCACHEmi52s5 (AWCACHEmi52s5),
    .AWPROTmi52s5  (AWPROTmi52s5),

    .AWVALIDmi52s5 (AWVALIDmi52s5),
    .AWREADYs52mi5 (AWREADYs52mi5),

    //Write data channel
    .WIDmi52s5     (WIDmi52s5),
    .WDATAmi52s5   (WDATAmi52s5),
    .WSTRBmi52s5   (WSTRBmi52s5),
    .WLASTmi52s5   (WLASTmi52s5),
    .WVALIDmi52s5  (WVALIDmi52s5),
    .WREADYs52mi5  (WREADYs52mi5),

    //Write response channel
    .BIDs52mi5     (BIDs52mi5),
    .BRESPs52mi5   (BRESPs52mi5),
    .BVALIDs52mi5  (BVALIDs52mi5),
    .BREADYmi52s5  (BREADYmi52s5),

    //_______________________________________________________________

    //_______________________________________________________________
    //For Master 0
    //Read address channel
    .ARIDm02si0    (ARIDm02si0),
    .ARADDRm02si0  (ARADDRm02si0),
    .ARLENm02si0   (ARLENm02si0),
    .ARSIZEm02si0  (ARSIZEm02si0),
    .ARBURSTm02si0 (ARBURSTm02si0),
    .ARLOCKm02si0  (ARLOCKm02si0),
    .ARCACHEm02si0 (ARCACHEm02si0),
    .ARPROTm02si0  (ARPROTm02si0),

    .ARVALIDm02si0 (ARVALIDm02si0),
    .ARREADYsi02m0 (ARREADYsi02m0),

    //Read data channel
    .RIDsi02m0     (RIDsi02m0),
    .RRESPsi02m0   (RRESPsi02m0),
    .RDATAsi02m0   (RDATAsi02m0),
    .RLASTsi02m0   (RLASTsi02m0),
    .RVALIDsi02m0  (RVALIDsi02m0),
    .RREADYm02si0  (RREADYm02si0),


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    .ARIDm12si1    (ARIDm12si1),
    .ARADDRm12si1  (ARADDRm12si1),
    .ARLENm12si1   (ARLENm12si1),
    .ARSIZEm12si1  (ARSIZEm12si1),
    .ARBURSTm12si1 (ARBURSTm12si1),
    .ARLOCKm12si1  (ARLOCKm12si1),
    .ARCACHEm12si1 (ARCACHEm12si1),
    .ARPROTm12si1  (ARPROTm12si1),

    .ARVALIDm12si1 (ARVALIDm12si1),
    .ARREADYsi12m1 (ARREADYsi12m1),

    //Read data channel
    .RIDsi12m1     (RIDsi12m1),
    .RRESPsi12m1   (RRESPsi12m1),
    .RDATAsi12m1   (RDATAsi12m1),
    .RLASTsi12m1   (RLASTsi12m1),
    .RVALIDsi12m1  (RVALIDsi12m1),
    .RREADYm12si1  (RREADYm12si1),

    //_______________________________________________________________
    //For Master 2
    //Read address channel
    .ARIDm22si2    (ARIDm22si2),
    .ARADDRm22si2  (ARADDRm22si2),
    .ARLENm22si2   (ARLENm22si2),
    .ARSIZEm22si2  (ARSIZEm22si2),
    .ARBURSTm22si2 (ARBURSTm22si2),
    .ARLOCKm22si2  (ARLOCKm22si2),
    .ARCACHEm22si2 (ARCACHEm22si2),
    .ARPROTm22si2  (ARPROTm22si2),

    .ARVALIDm22si2 (ARVALIDm22si2),
    .ARREADYsi22m2 (ARREADYsi22m2),

    //Read data channel
    .RIDsi22m2     (RIDsi22m2),
    .RRESPsi22m2   (RRESPsi22m2),
    .RDATAsi22m2   (RDATAsi22m2),
    .RLASTsi22m2   (RLASTsi22m2),
    .RVALIDsi22m2  (RVALIDsi22m2),
    .RREADYm22si2  (RREADYm22si2),


    //_______________________________________________________________
    //For Master 3
    //Read address channel
    .ARIDm32si3    (ARIDm32si3),
    .ARADDRm32si3  (ARADDRm32si3),
    .ARLENm32si3   (ARLENm32si3),
    .ARSIZEm32si3  (ARSIZEm32si3),
    .ARBURSTm32si3 (ARBURSTm32si3),
    .ARLOCKm32si3  (ARLOCKm32si3),
    .ARCACHEm32si3 (ARCACHEm32si3),
    .ARPROTm32si3  (ARPROTm32si3),

    .ARVALIDm32si3 (ARVALIDm32si3),
    .ARREADYsi32m3 (ARREADYsi32m3),

    //Read data channel
    .RIDsi32m3     (RIDsi32m3),
    .RRESPsi32m3   (RRESPsi32m3),
    .RDATAsi32m3   (RDATAsi32m3),
    .RLASTsi32m3   (RLASTsi32m3),
    .RVALIDsi32m3  (RVALIDsi32m3),
    .RREADYm32si3  (RREADYm32si3),
    

 
    //_______________________________________________________________
    //For Slave 0
    //Read address channel
    .ARIDmi02s0    (ARIDmi02s0),
    .ARADDRmi02s0  (ARADDRmi02s0),
    .ARLENmi02s0   (ARLENmi02s0),
    .ARSIZEmi02s0  (ARSIZEmi02s0),
    .ARBURSTmi02s0 (ARBURSTmi02s0),
    .ARLOCKmi02s0  (ARLOCKmi02s0),
    .ARCACHEmi02s0 (ARCACHEmi02s0),
    .ARPROTmi02s0  (ARPROTmi02s0),

    .ARVALIDmi02s0 (ARVALIDmi02s0),
    .ARREADYs02mi0 (ARREADYs02mi0),

    //Read data channel
    .RIDs02mi0     (RIDs02mi0),
    .RRESPs02mi0   (RRESPs02mi0),
    .RDATAs02mi0   (RDATAs02mi0),
    .RLASTs02mi0   (RLASTs02mi0),
    .RVALIDs02mi0  (RVALIDs02mi0),
    .RREADYmi02s0  (RREADYmi02s0),


    //_______________________________________________________________
    //For Slave 1
    //Read address channel
    .ARIDmi12s1    (ARIDmi12s1),
    .ARADDRmi12s1  (ARADDRmi12s1),
    .ARLENmi12s1   (ARLENmi12s1),
    .ARSIZEmi12s1  (ARSIZEmi12s1),
    .ARBURSTmi12s1 (ARBURSTmi12s1),
    .ARLOCKmi12s1  (ARLOCKmi12s1),
    .ARCACHEmi12s1 (ARCACHEmi12s1),
    .ARPROTmi12s1  (ARPROTmi12s1),

    .ARVALIDmi12s1 (ARVALIDmi12s1),
    .ARREADYs12mi1 (ARREADYs12mi1),

    //Read data channel
    .RIDs12mi1     (RIDs12mi1),
    .RRESPs12mi1   (RRESPs12mi1),
    .RDATAs12mi1   (RDATAs12mi1),
    .RLASTs12mi1   (RLASTs12mi1),
    .RVALIDs12mi1  (RVALIDs12mi1),
    .RREADYmi12s1  (RREADYmi12s1),
    
    //_______________________________________________________________
    //For Slave 2
    //Read address channel
    .ARIDmi22s2    (ARIDmi22s2),
    .ARADDRmi22s2  (ARADDRmi22s2),
    .ARLENmi22s2   (ARLENmi22s2),
    .ARSIZEmi22s2  (ARSIZEmi22s2),
    .ARBURSTmi22s2 (ARBURSTmi22s2),
    .ARLOCKmi22s2  (ARLOCKmi22s2),
    .ARCACHEmi22s2 (ARCACHEmi22s2),
    .ARPROTmi22s2  (ARPROTmi22s2),

    .ARVALIDmi22s2 (ARVALIDmi22s2),
    .ARREADYs22mi2 (ARREADYs22mi2),

    //Read data channel
    .RIDs22mi2     (RIDs22mi2),
    .RRESPs22mi2   (RRESPs22mi2),
    .RDATAs22mi2   (RDATAs22mi2),
    .RLASTs22mi2   (RLASTs22mi2),
    .RVALIDs22mi2  (RVALIDs22mi2),
    .RREADYmi22s2  (RREADYmi22s2),

    
    //_______________________________________________________________
    //For Slave 3
    //Read address channel
    .ARIDmi32s3    (ARIDmi32s3),
    .ARADDRmi32s3  (ARADDRmi32s3),
    .ARLENmi32s3   (ARLENmi32s3),
    .ARSIZEmi32s3  (ARSIZEmi32s3),
    .ARBURSTmi32s3 (ARBURSTmi32s3),
    .ARLOCKmi32s3  (ARLOCKmi32s3),
    .ARCACHEmi32s3 (ARCACHEmi32s3),
    .ARPROTmi32s3  (ARPROTmi32s3),

    .ARVALIDmi32s3 (ARVALIDmi32s3),
    .ARREADYs32mi3 (ARREADYs32mi3),

    //Read data channel
    .RIDs32mi3     (RIDs32mi3),
    .RRESPs32mi3   (RRESPs32mi3),
    .RDATAs32mi3   (RDATAs32mi3),
    .RLASTs32mi3   (RLASTs32mi3),
    .RVALIDs32mi3  (RVALIDs32mi3),
    .RREADYmi32s3  (RREADYmi32s3),
    
    
    //_______________________________________________________________
    //For Slave 4
    //Read address channel
    .ARIDmi42s4    (ARIDmi42s4),
    .ARADDRmi42s4  (ARADDRmi42s4),
    .ARLENmi42s4   (ARLENmi42s4),
    .ARSIZEmi42s4  (ARSIZEmi42s4),
    .ARBURSTmi42s4 (ARBURSTmi42s4),
    .ARLOCKmi42s4  (ARLOCKmi42s4),
    .ARCACHEmi42s4 (ARCACHEmi42s4),
    .ARPROTmi42s4  (ARPROTmi42s4),

    .ARVALIDmi42s4 (ARVALIDmi42s4),
    .ARREADYs42mi4 (ARREADYs42mi4),

    //Read data channel
    .RIDs42mi4     (RIDs42mi4),
    .RRESPs42mi4   (RRESPs42mi4),
    .RDATAs42mi4   (RDATAs42mi4),
    .RLASTs42mi4   (RLASTs42mi4),
    .RVALIDs42mi4  (RVALIDs42mi4),
    .RREADYmi42s4  (RREADYmi42s4),
    
    
    //_______________________________________________________________
    //For Slave 5
    //Read address channel
    .ARIDmi52s5    (ARIDmi52s5),
    .ARADDRmi52s5  (ARADDRmi52s5),
    .ARLENmi52s5   (ARLENmi52s5),
    .ARSIZEmi52s5  (ARSIZEmi52s5),
    .ARBURSTmi52s5 (ARBURSTmi52s5),
    .ARLOCKmi52s5  (ARLOCKmi52s5),
    .ARCACHEmi52s5 (ARCACHEmi52s5),
    .ARPROTmi52s5  (ARPROTmi52s5),

    .ARVALIDmi52s5 (ARVALIDmi52s5),
    .ARREADYs52mi5 (ARREADYs52mi5),

    //Read data channel
    .RIDs52mi5     (RIDs52mi5),
    .RRESPs52mi5   (RRESPs52mi5),
    .RDATAs52mi5   (RDATAs52mi5),
    .RLASTs52mi5   (RLASTs52mi5),
    .RVALIDs52mi5  (RVALIDs52mi5),
    .RREADYmi52s5  (RREADYmi52s5)
    //_______________________________________________________________
);

// Master 0
TestMaster TestMaster0
(
		.MASTER_ID(2'b00),

		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDm02si0),
		.AWADDR(AWADDRm02si0),
		.AWLEN(AWLENm02si0),
		.AWSIZE(AWSIZEm02si0),
		.AWBURST(AWBURSTm02si0),
		.AWLOCK(AWLOCKm02si0),
		.AWCACHE(AWCACHEm02si0),
		.AWPROT(AWPROTm02si0),
		.AWVALID(AWVALIDm02si0),
		.AWREADY(AWREADYsi02m0),

		.WID(WIDm02si0),
		.WDATA(WDATAm02si0),
		.WSTRB(WSTRBm02si0),
		.WLAST(WLASTm02si0),
		.WVALID(WVALIDm02si0),
		.WREADY(WREADYsi02m0),

		.BID(BIDsi02m0),
		.BRESP(BRESPsi02m0),
		.BVALID(BVALIDsi02m0),
		.BREADY(BREADYm02si0),

		.ARID(ARIDm02si0),
		.ARADDR(ARADDRm02si0),
		.ARLEN(ARLENm02si0),
		.ARSIZE(ARSIZEm02si0),
		.ARBURST(ARBURSTm02si0),
		.ARLOCK(ARLOCKm02si0),
		.ARCACHE(ARCACHEm02si0),
		.ARPROT(ARPROTm02si0),
		.ARVALID(ARVALIDm02si0),
		.ARREADY(ARREADYsi02m0),

		// Read Data Channel
		.RID(RIDsi02m0),
		.RDATA(RDATAsi02m0),
		.RRESP(RRESPsi02m0),
		.RLAST(RLASTsi02m0),
		.RVALID(RVALIDsi02m0),
		.RREADY(RREADYm02si0)
);

// Master 1
TestMaster TestMaster1
(
		.MASTER_ID(2'b01),

		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDm12si1),
		.AWADDR(AWADDRm12si1),
		.AWLEN(AWLENm12si1),
		.AWSIZE(AWSIZEm12si1),
		.AWBURST(AWBURSTm12si1),
		.AWLOCK(AWLOCKm12si1),
		.AWCACHE(AWCACHEm12si1),
		.AWPROT(AWPROTm12si1),
		.AWVALID(AWVALIDm12si1),
		.AWREADY(AWREADYsi12m1),

		.WID(WIDm12si1),
		.WDATA(WDATAm12si1),
		.WSTRB(WSTRBm12si1),
		.WLAST(WLASTm12si1),
		.WVALID(WVALIDm12si1),
		.WREADY(WREADYsi12m1),

		.BID(BIDsi12m1),
		.BRESP(BRESPsi12m1),
		.BVALID(BVALIDsi12m1),
		.BREADY(BREADYm12si1),

		.ARID(ARIDm12si1),
		.ARADDR(ARADDRm12si1),
		.ARLEN(ARLENm12si1),
		.ARSIZE(ARSIZEm12si1),
		.ARBURST(ARBURSTm12si1),
		.ARLOCK(ARLOCKm12si1),
		.ARCACHE(ARCACHEm12si1),
		.ARPROT(ARPROTm12si1),
		.ARVALID(ARVALIDm12si1),
		.ARREADY(ARREADYsi12m1),

		// Read Data Channel
		.RID(RIDsi12m1),
		.RDATA(RDATAsi12m1),
		.RRESP(RRESPsi12m1),
		.RLAST(RLASTsi12m1),
		.RVALID(RVALIDsi12m1),
		.RREADY(RREADYm12si1)
);

// Master 2
TestMaster TestMaster2
(
		.MASTER_ID(2'b10),

		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDm22si2),
		.AWADDR(AWADDRm22si2),
		.AWLEN(AWLENm22si2),
		.AWSIZE(AWSIZEm22si2),
		.AWBURST(AWBURSTm22si2),
		.AWLOCK(AWLOCKm22si2),
		.AWCACHE(AWCACHEm22si2),
		.AWPROT(AWPROTm22si2),
		.AWVALID(AWVALIDm22si2),
		.AWREADY(AWREADYsi22m2),

		.WID(WIDm22si2),
		.WDATA(WDATAm22si2),
		.WSTRB(WSTRBm22si2),
		.WLAST(WLASTm22si2),
		.WVALID(WVALIDm22si2),
		.WREADY(WREADYsi22m2),

		.BID(BIDsi22m2),
		.BRESP(BRESPsi22m2),
		.BVALID(BVALIDsi22m2),
		.BREADY(BREADYm22si2),

		.ARID(ARIDm22si2),
		.ARADDR(ARADDRm22si2),
		.ARLEN(ARLENm22si2),
		.ARSIZE(ARSIZEm22si2),
		.ARBURST(ARBURSTm22si2),
		.ARLOCK(ARLOCKm22si2),
		.ARCACHE(ARCACHEm22si2),
		.ARPROT(ARPROTm22si2),
		.ARVALID(ARVALIDm22si2),
		.ARREADY(ARREADYsi22m2),

		// Read Data Channel
		.RID(RIDsi22m2),
		.RDATA(RDATAsi22m2),
		.RRESP(RRESPsi22m2),
		.RLAST(RLASTsi22m2),
		.RVALID(RVALIDsi22m2),
		.RREADY(RREADYm22si2)
);

// Master 3
TestMaster TestMaster3
(
		.MASTER_ID(2'b11),

		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDm32si3),
		.AWADDR(AWADDRm32si3),
		.AWLEN(AWLENm32si3),
		.AWSIZE(AWSIZEm32si3),
		.AWBURST(AWBURSTm32si3),
		.AWLOCK(AWLOCKm32si3),
		.AWCACHE(AWCACHEm32si3),
		.AWPROT(AWPROTm32si3),
		.AWVALID(AWVALIDm32si3),
		.AWREADY(AWREADYsi32m3),

		.WID(WIDm32si3),
		.WDATA(WDATAm32si3),
		.WSTRB(WSTRBm32si3),
		.WLAST(WLASTm32si3),
		.WVALID(WVALIDm32si3),
		.WREADY(WREADYsi32m3),

		.BID(BIDsi32m3),
		.BRESP(BRESPsi32m3),
		.BVALID(BVALIDsi32m3),
		.BREADY(BREADYm32si3),

		.ARID(ARIDm32si3),
		.ARADDR(ARADDRm32si3),
		.ARLEN(ARLENm32si3),
		.ARSIZE(ARSIZEm32si3),
		.ARBURST(ARBURSTm32si3),
		.ARLOCK(ARLOCKm32si3),
		.ARCACHE(ARCACHEm32si3),
		.ARPROT(ARPROTm32si3),
		.ARVALID(ARVALIDm32si3),
		.ARREADY(ARREADYsi32m3),

		// Read Data Channel
		.RID(RIDsi32m3),
		.RDATA(RDATAsi32m3),
		.RRESP(RRESPsi32m3),
		.RLAST(RLASTsi32m3),
		.RVALID(RVALIDsi32m3),
		.RREADY(RREADYm32si3)
);

// Slave 0
wire [31:0] MEMADDR0;
wire [31:0] MEMRDATA0;
wire [31:0] MEMWDATA0;
wire        MEMCEn0;
wire [3:0]  MEMWEn0;
IntSRAMController #(
	.WID_WIDTH(ID_WID+MASTERWID),
	.RID_WIDTH(ID_WID+MASTERWID)
)
IntSRAMController0
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDmi02s0),
		.AWADDR(AWADDRmi02s0),
		.AWLEN(AWLENmi02s0),
		.AWSIZE(AWSIZEmi02s0),
		.AWBURST(AWBURSTmi02s0),
		.AWVALID(AWVALIDmi02s0),
		.AWREADY(AWREADYs02mi0),

		.WID(WIDmi02s0),
		.WDATA(WDATAmi02s0),
		.WSTRB(WSTRBmi02s0),
		.WLAST(WLASTmi02s0),
		.WVALID(WVALIDmi02s0),
		.WREADY(WREADYs02mi0),

		.BID(BIDs02mi0),
		.BRESP(BRESPs02mi0),
		.BVALID(BVALIDs02mi0),
		.BREADY(BREADYmi02s0),

		.ARID(ARIDmi02s0),
		.ARADDR(ARADDRmi02s0),
		.ARLEN(ARLENmi02s0),
		.ARSIZE(ARSIZEmi02s0),
		.ARBURST(ARBURSTmi02s0),
		.ARVALID(ARVALIDmi02s0),
		.ARREADY(ARREADYs02mi0),

		// Read Data Channel
		.RID(RIDs02mi0),
		.RDATA(RDATAs02mi0),
		.RRESP(RRESPs02mi0),
		.RLAST(RLASTs02mi0),
		.RVALID(RVALIDs02mi0),
		.RREADY(RREADYmi02s0),

		.MEMADDR(MEMADDR0[29:0]),
		.MEMCEn(MEMCEn0),
		.MEMWEn(MEMWEn0),
		.MEMRDATA(MEMRDATA0),
		.MEMWDATA(MEMWDATA0)
);

SSRAM32bit #(14) SRAM0
(
		.CLK(ACLK),
		.ADDR(MEMADDR0[13:0]),
		.CEn(MEMCEn0),
		.WEn(MEMWEn0),
		.RDATA(MEMRDATA0),
		.WDATA(MEMWDATA0)
);

// Slave 1
wire [31:0] MEMADDR1;
wire [31:0] MEMRDATA1;
wire [31:0] MEMWDATA1;
wire        MEMCEn1;
wire [3:0]  MEMWEn1;
IntSRAMController #(
	.WID_WIDTH(ID_WID+MASTERWID),
	.RID_WIDTH(ID_WID+MASTERWID)
)
IntSRAMController1
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDmi12s1),
		.AWADDR(AWADDRmi12s1),
		.AWLEN(AWLENmi12s1),
		.AWSIZE(AWSIZEmi12s1),
		.AWBURST(AWBURSTmi12s1),
		.AWVALID(AWVALIDmi12s1),
		.AWREADY(AWREADYs12mi1),

		.WID(WIDmi12s1),
		.WDATA(WDATAmi12s1),
		.WSTRB(WSTRBmi12s1),
		.WLAST(WLASTmi12s1),
		.WVALID(WVALIDmi12s1),
		.WREADY(WREADYs12mi1),

		.BID(BIDs12mi1),
		.BRESP(BRESPs12mi1),
		.BVALID(BVALIDs12mi1),
		.BREADY(BREADYmi12s1),

		.ARID(ARIDmi12s1),
		.ARADDR(ARADDRmi12s1),
		.ARLEN(ARLENmi12s1),
		.ARSIZE(ARSIZEmi12s1),
		.ARBURST(ARBURSTmi12s1),
		.ARVALID(ARVALIDmi12s1),
		.ARREADY(ARREADYs12mi1),

		// Read Data Channel
		.RID(RIDs12mi1),
		.RDATA(RDATAs12mi1),
		.RRESP(RRESPs12mi1),
		.RLAST(RLASTs12mi1),
		.RVALID(RVALIDs12mi1),
		.RREADY(RREADYmi12s1),

		.MEMADDR(MEMADDR1[29:0]),
		.MEMCEn(MEMCEn1),
		.MEMWEn(MEMWEn1),
		.MEMRDATA(MEMRDATA1),
		.MEMWDATA(MEMWDATA1)
);

SSRAM32bit #(14) SRAM1
(
		.CLK(ACLK),
		.ADDR(MEMADDR1[13:0]),
		.CEn(MEMCEn1),
		.WEn(MEMWEn1),
		.RDATA(MEMRDATA1),
		.WDATA(MEMWDATA1)
);

// Slave 2
wire [31:0] MEMADDR2;
wire [31:0] MEMRDATA2;
wire [31:0] MEMWDATA2;
wire        MEMCEn2;
wire [3:0]  MEMWEn2;
IntSRAMController #(
	.WID_WIDTH(ID_WID+MASTERWID),
	.RID_WIDTH(ID_WID+MASTERWID)
)
IntSRAMController2
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDmi22s2),
		.AWADDR(AWADDRmi22s2),
		.AWLEN(AWLENmi22s2),
		.AWSIZE(AWSIZEmi22s2),
		.AWBURST(AWBURSTmi22s2),
		.AWVALID(AWVALIDmi22s2),
		.AWREADY(AWREADYs22mi2),

		.WID(WIDmi22s2),
		.WDATA(WDATAmi22s2),
		.WSTRB(WSTRBmi22s2),
		.WLAST(WLASTmi22s2),
		.WVALID(WVALIDmi22s2),
		.WREADY(WREADYs22mi2),

		.BID(BIDs22mi2),
		.BRESP(BRESPs22mi2),
		.BVALID(BVALIDs22mi2),
		.BREADY(BREADYmi22s2),

		.ARID(ARIDmi22s2),
		.ARADDR(ARADDRmi22s2),
		.ARLEN(ARLENmi22s2),
		.ARSIZE(ARSIZEmi22s2),
		.ARBURST(ARBURSTmi22s2),
		.ARVALID(ARVALIDmi22s2),
		.ARREADY(ARREADYs22mi2),

		// Read Data Channel
		.RID(RIDs22mi2),
		.RDATA(RDATAs22mi2),
		.RRESP(RRESPs22mi2),
		.RLAST(RLASTs22mi2),
		.RVALID(RVALIDs22mi2),
		.RREADY(RREADYmi22s2),

		.MEMADDR(MEMADDR2[29:0]),
		.MEMCEn(MEMCEn2),
		.MEMWEn(MEMWEn2),
		.MEMRDATA(MEMRDATA2),
		.MEMWDATA(MEMWDATA2)
);

SSRAM32bit #(14) SRAM2
(
		.CLK(ACLK),
		.ADDR(MEMADDR2[13:0]),
		.CEn(MEMCEn2),
		.WEn(MEMWEn2),
		.RDATA(MEMRDATA2),
		.WDATA(MEMWDATA2)
);

// Slave 3
wire [31:0] MEMADDR3;
wire [31:0] MEMRDATA3;
wire [31:0] MEMWDATA3;
wire        MEMCEn3;
wire [3:0]  MEMWEn3;
IntSRAMController #(
	.WID_WIDTH(ID_WID+MASTERWID),
	.RID_WIDTH(ID_WID+MASTERWID)
)
IntSRAMController3
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDmi32s3),
		.AWADDR(AWADDRmi32s3),
		.AWLEN(AWLENmi32s3),
		.AWSIZE(AWSIZEmi32s3),
		.AWBURST(AWBURSTmi32s3),
		.AWVALID(AWVALIDmi32s3),
		.AWREADY(AWREADYs32mi3),

		.WID(WIDmi32s3),
		.WDATA(WDATAmi32s3),
		.WSTRB(WSTRBmi32s3),
		.WLAST(WLASTmi32s3),
		.WVALID(WVALIDmi32s3),
		.WREADY(WREADYs32mi3),

		.BID(BIDs32mi3),
		.BRESP(BRESPs32mi3),
		.BVALID(BVALIDs32mi3),
		.BREADY(BREADYmi32s3),

		.ARID(ARIDmi32s3),
		.ARADDR(ARADDRmi32s3),
		.ARLEN(ARLENmi32s3),
		.ARSIZE(ARSIZEmi32s3),
		.ARBURST(ARBURSTmi32s3),
		.ARVALID(ARVALIDmi32s3),
		.ARREADY(ARREADYs32mi3),

		// Read Data Channel
		.RID(RIDs32mi3),
		.RDATA(RDATAs32mi3),
		.RRESP(RRESPs32mi3),
		.RLAST(RLASTs32mi3),
		.RVALID(RVALIDs32mi3),
		.RREADY(RREADYmi32s3),

		.MEMADDR(MEMADDR3[29:0]),
		.MEMCEn(MEMCEn3),
		.MEMWEn(MEMWEn3),
		.MEMRDATA(MEMRDATA3),
		.MEMWDATA(MEMWDATA3)
);

SSRAM32bit #(14) SRAM3
(
		.CLK(ACLK),
		.ADDR(MEMADDR3[13:0]),
		.CEn(MEMCEn3),
		.WEn(MEMWEn3),
		.RDATA(MEMRDATA3),
		.WDATA(MEMWDATA3)
);

// Slave 4
wire [31:0] MEMADDR4;
wire [31:0] MEMRDATA4;
wire [31:0] MEMWDATA4;
wire        MEMCEn4;
wire [3:0]  MEMWEn4;
IntSRAMController #(
	.WID_WIDTH(ID_WID+MASTERWID),
	.RID_WIDTH(ID_WID+MASTERWID)
)
IntSRAMController4
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDmi42s4),
		.AWADDR(AWADDRmi42s4),
		.AWLEN(AWLENmi42s4),
		.AWSIZE(AWSIZEmi42s4),
		.AWBURST(AWBURSTmi42s4),
		.AWVALID(AWVALIDmi42s4),
		.AWREADY(AWREADYs42mi4),

		.WID(WIDmi42s4),
		.WDATA(WDATAmi42s4),
		.WSTRB(WSTRBmi42s4),
		.WLAST(WLASTmi42s4),
		.WVALID(WVALIDmi42s4),
		.WREADY(WREADYs42mi4),

		.BID(BIDs42mi4),
		.BRESP(BRESPs42mi4),
		.BVALID(BVALIDs42mi4),
		.BREADY(BREADYmi42s4),

		.ARID(ARIDmi42s4),
		.ARADDR(ARADDRmi42s4),
		.ARLEN(ARLENmi42s4),
		.ARSIZE(ARSIZEmi42s4),
		.ARBURST(ARBURSTmi42s4),
		.ARVALID(ARVALIDmi42s4),
		.ARREADY(ARREADYs42mi4),

		// Read Data Channel
		.RID(RIDs42mi4),
		.RDATA(RDATAs42mi4),
		.RRESP(RRESPs42mi4),
		.RLAST(RLASTs42mi4),
		.RVALID(RVALIDs42mi4),
		.RREADY(RREADYmi42s4),

		.MEMADDR(MEMADDR4[29:0]),
		.MEMCEn(MEMCEn4),
		.MEMWEn(MEMWEn4),
		.MEMRDATA(MEMRDATA4),
		.MEMWDATA(MEMWDATA4)
);

SSRAM32bit #(14) SRAM4
(
		.CLK(ACLK),
		.ADDR(MEMADDR4[13:0]),
		.CEn(MEMCEn4),
		.WEn(MEMWEn4),
		.RDATA(MEMRDATA4),
		.WDATA(MEMWDATA4)
);

// Slave 5 : Default Slave
DefaultSlave #(
	.WID_WIDTH(ID_WID+MASTERWID),
	.RID_WIDTH(ID_WID+MASTERWID)
)
DefaultSlave
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDmi52s5),
		.AWADDR(AWADDRmi52s5),
		.AWLEN(AWLENmi52s5),
		.AWSIZE(AWSIZEmi52s5),
		.AWBURST(AWBURSTmi52s5),
		.AWVALID(AWVALIDmi52s5),
		.AWREADY(AWREADYs52mi5),

		.WID(WIDmi52s5),
	//	.WDATA(WDATAmi52s5),
	//	.WSTRB(WSTRBmi52s5),
		.WLAST(WLASTmi52s5),
		.WVALID(WVALIDmi52s5),
		.WREADY(WREADYs52mi5),

		.BID(BIDs52mi5),
		.BRESP(BRESPs52mi5),
		.BVALID(BVALIDs52mi5),
		.BREADY(BREADYmi52s5),

		.ARID(ARIDmi52s5),
		.ARADDR(ARADDRmi52s5),
		.ARLEN(ARLENmi52s5),
		.ARSIZE(ARSIZEmi52s5),
		.ARBURST(ARBURSTmi52s5),
		.ARVALID(ARVALIDmi52s5),
		.ARREADY(ARREADYs52mi5),

		// Read Data Channel
		.RID(RIDs52mi5),
		.RDATA(RDATAs52mi5),
		.RRESP(RRESPs52mi5),
		.RLAST(RLASTs52mi5),
		.RVALID(RVALIDs52mi5),
		.RREADY(RREADYmi52s5)
);

endmodule


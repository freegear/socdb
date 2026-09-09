
module  WriteChannel(

    ACLK    ,
    ARESETn ,

    //_______________________________________________________________
    //For Master 0
    //Write address channel
    AWIDm02si0    ,
    AWADDRm02si0  ,
    AWLENm02si0   ,
    AWSIZEm02si0  ,
    AWBURSTm02si0 ,
    AWLOCKm02si0  ,
    AWCACHEm02si0 ,
    AWPROTm02si0  ,

    AWVALIDm02si0 ,
    AWREADYsi02m0 ,

    //Write data channel
    WIDm02si0     ,
    WDATAm02si0   ,
    WSTRBm02si0   ,
    WLASTm02si0   ,
    WVALIDm02si0  ,
    WREADYsi02m0  ,

    //Write response channel
    BIDsi02m0     ,
    BRESPsi02m0   ,
    BVALIDsi02m0  ,
    BREADYm02si0  ,


    //_______________________________________________________________
    //For Master 1
    //Write address channel
    AWIDm12si1    ,
    AWADDRm12si1  ,
    AWLENm12si1   ,
    AWSIZEm12si1  ,
    AWBURSTm12si1 ,
    AWLOCKm12si1  ,
    AWCACHEm12si1 ,
    AWPROTm12si1  ,

    AWVALIDm12si1 ,
    AWREADYsi12m1 ,

    //Write data channel
    WIDm12si1     ,
    WDATAm12si1   ,
    WSTRBm12si1   ,
    WLASTm12si1   ,
    WVALIDm12si1  ,
    WREADYsi12m1  ,

    //Write response channel
    BIDsi12m1     ,
    BRESPsi12m1   ,
    BVALIDsi12m1  ,
    BREADYm12si1  ,


    //_______________________________________________________________
    //For Master 2
    //Write address channel
    AWIDm22si2    ,
    AWADDRm22si2  ,
    AWLENm22si2   ,
    AWSIZEm22si2  ,
    AWBURSTm22si2 ,
    AWLOCKm22si2  ,
    AWCACHEm22si2 ,
    AWPROTm22si2  ,

    AWVALIDm22si2 ,
    AWREADYsi22m2 ,

    //Write data channel
    WIDm22si2     ,
    WDATAm22si2   ,
    WSTRBm22si2   ,
    WLASTm22si2   ,
    WVALIDm22si2  ,
    WREADYsi22m2  ,

    //Write response channel
    BIDsi22m2     ,
    BRESPsi22m2   ,
    BVALIDsi22m2  ,
    BREADYm22si2  ,

    //_______________________________________________________________
    //For Master 3
    //Write address channel
    AWIDm32si3    ,
    AWADDRm32si3  ,
    AWLENm32si3   ,
    AWSIZEm32si3  ,
    AWBURSTm32si3 ,
    AWLOCKm32si3  ,
    AWCACHEm32si3 ,
    AWPROTm32si3  ,

    AWVALIDm32si3 ,
    AWREADYsi32m3 ,

    //Write data channel
    WIDm32si3     ,
    WDATAm32si3   ,
    WSTRBm32si3   ,
    WLASTm32si3   ,
    WVALIDm32si3  ,
    WREADYsi32m3  ,

    //Write response channel
    BIDsi32m3     ,
    BRESPsi32m3   ,
    BVALIDsi32m3  ,
    BREADYm32si3  ,
    
    //_______________________________________________________________
    
    //For Slave 0
    //Write address channel
    AWIDmi02s0    ,
    AWADDRmi02s0  ,
    AWLENmi02s0   ,
    AWSIZEmi02s0  ,
    AWBURSTmi02s0 ,
    AWLOCKmi02s0  ,
    AWCACHEmi02s0 ,
    AWPROTmi02s0  ,

    AWVALIDmi02s0 ,
    AWREADYs02mi0 ,

    //Write data channel
    WIDmi02s0     ,
    WDATAmi02s0   ,
    WSTRBmi02s0   ,
    WLASTmi02s0   ,
    WVALIDmi02s0  ,
    WREADYs02mi0  ,

    //Write response channel
    BIDs02mi0     ,
    BRESPs02mi0   ,
    BVALIDs02mi0  ,
    BREADYmi02s0  ,


    //_______________________________________________________________

    //For Slave 1
    //Write address channel
    AWIDmi12s1    ,
    AWADDRmi12s1  ,
    AWLENmi12s1   ,
    AWSIZEmi12s1  ,
    AWBURSTmi12s1 ,
    AWLOCKmi12s1  ,
    AWCACHEmi12s1 ,
    AWPROTmi12s1  ,

    AWVALIDmi12s1 ,
    AWREADYs12mi1 ,

    //Write data channel
    WIDmi12s1     ,
    WDATAmi12s1   ,
    WSTRBmi12s1   ,
    WLASTmi12s1   ,
    WVALIDmi12s1  ,
    WREADYs12mi1  ,

    //Write response channel
    BIDs12mi1     ,
    BRESPs12mi1   ,
    BVALIDs12mi1  ,
    BREADYmi12s1  ,
    
    //_______________________________________________________________


    //For Slave 2
    //Write address channel
    AWIDmi22s2    ,
    AWADDRmi22s2  ,
    AWLENmi22s2   ,
    AWSIZEmi22s2  ,
    AWBURSTmi22s2 ,
    AWLOCKmi22s2  ,
    AWCACHEmi22s2 ,
    AWPROTmi22s2  ,

    AWVALIDmi22s2 ,
    AWREADYs22mi2 ,

    //Write data channel
    WIDmi22s2     ,
    WDATAmi22s2   ,
    WSTRBmi22s2   ,
    WLASTmi22s2   ,
    WVALIDmi22s2  ,
    WREADYs22mi2  ,

    //Write response channel
    BIDs22mi2     ,
    BRESPs22mi2   ,
    BVALIDs22mi2  ,
    BREADYmi22s2  ,

    
    //_______________________________________________________________
    
    
    //For Slave 3
    //Write address channel
    AWIDmi32s3    ,
    AWADDRmi32s3  ,
    AWLENmi32s3   ,
    AWSIZEmi32s3  ,
    AWBURSTmi32s3 ,
    AWLOCKmi32s3  ,
    AWCACHEmi32s3 ,
    AWPROTmi32s3  ,

    AWVALIDmi32s3 ,
    AWREADYs32mi3 ,

    //Write data channel
    WIDmi32s3     ,
    WDATAmi32s3   ,
    WSTRBmi32s3   ,
    WLASTmi32s3   ,
    WVALIDmi32s3  ,
    WREADYs32mi3  ,

    //Write response channel
    BIDs32mi3     ,
    BRESPs32mi3   ,
    BVALIDs32mi3  ,
    BREADYmi32s3  ,
    
    
    //_______________________________________________________________
    
    //For Slave 4
    //Write address channel
    AWIDmi42s4    ,
    AWADDRmi42s4  ,
    AWLENmi42s4   ,
    AWSIZEmi42s4  ,
    AWBURSTmi42s4 ,
    AWLOCKmi42s4  ,
    AWCACHEmi42s4 ,
    AWPROTmi42s4  ,

    AWVALIDmi42s4 ,
    AWREADYs42mi4 ,

    //Write data channel
    WIDmi42s4     ,
    WDATAmi42s4   ,
    WSTRBmi42s4   ,
    WLASTmi42s4   ,
    WVALIDmi42s4  ,
    WREADYs42mi4  ,

    //Write response channel
    BIDs42mi4     ,
    BRESPs42mi4   ,
    BVALIDs42mi4  ,
    BREADYmi42s4  ,
    
    //_______________________________________________________________
    
    
    //For Slave 5
    //Write address channel
    AWIDmi52s5    ,
    AWADDRmi52s5  ,
    AWLENmi52s5   ,
    AWSIZEmi52s5  ,
    AWBURSTmi52s5 ,
    AWLOCKmi52s5  ,
    AWCACHEmi52s5 ,
    AWPROTmi52s5  ,

    AWVALIDmi52s5 ,
    AWREADYs52mi5 ,

    //Write data channel
    WIDmi52s5     ,
    WDATAmi52s5   ,
    WSTRBmi52s5   ,
    WLASTmi52s5   ,
    WVALIDmi52s5  ,
    WREADYs52mi5  ,

    //Write response channel
    BIDs52mi5     ,
    BRESPs52mi5   ,
    BVALIDs52mi5  ,
    BREADYmi52s5  

    //_______________________________________________________________

);
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    //For Master 0
    //Write address channel
    input   [ID_WID-1:0]       AWIDm02si0;    
    input   [ADDR_WID-1:0]     AWADDRm02si0;
    input   [AWLEN_WID-1:0]    AWLENm02si0;
    input   [AWSIZE_WID-1:0]   AWSIZEm02si0;  
    input   [AWBURST_WID-1:0]  AWBURSTm02si0; 
    input   [AWLOCK_WID-1:0]   AWLOCKm02si0;  
    input   [AWCACHE_WID-1:0]      AWCACHEm02si0; 
    input   [AWPROT_WID-1:0]       AWPROTm02si0;  

    input   AWVALIDm02si0; 
    output  AWREADYsi02m0; 

    //Write data channel
    input   [ID_WID-1:0]       WIDm02si0;     
    input   [BUS_WID-1:0]      WDATAm02si0;   
    input   [WSTRB_WID-1:0]    WSTRBm02si0;   
    input   WLASTm02si0;   
    input   WVALIDm02si0;  
    output  WREADYsi02m0;  

    //Write response channel
    output   [ID_WID-1:0]      BIDsi02m0;     
    output   [BRESP_WID-1:0]   BRESPsi02m0;   
    output   BVALIDsi02m0;  
    input    BREADYm02si0;  

    //For Master 1
    //Write address channel
    input   [ID_WID-1:0]       AWIDm12si1;    
    input   [ADDR_WID-1:0]     AWADDRm12si1;
    input   [AWLEN_WID-1:0]    AWLENm12si1;
    input   [AWSIZE_WID-1:0]   AWSIZEm12si1;  
    input   [AWBURST_WID-1:0]  AWBURSTm12si1; 
    input   [AWLOCK_WID-1:0]   AWLOCKm12si1;  
    input   [AWCACHE_WID-1:0]      AWCACHEm12si1; 
    input   [AWPROT_WID-1:0]       AWPROTm12si1;  

    input   AWVALIDm12si1; 
    output  AWREADYsi12m1; 

    //Write data channel
    input   [ID_WID-1:0]       WIDm12si1;     
    input   [BUS_WID-1:0]      WDATAm12si1;   
    input   [WSTRB_WID-1:0]    WSTRBm12si1;   
    input   WLASTm12si1;   
    input   WVALIDm12si1;  
    output  WREADYsi12m1;  

    //Write response channel
    output   [ID_WID-1:0]      BIDsi12m1;     
    output   [BRESP_WID-1:0]   BRESPsi12m1;   
    output   BVALIDsi12m1;  
    input    BREADYm12si1;  

    //For Master 2
    //Write address channel
    input   [ID_WID-1:0]       AWIDm22si2;    
    input   [ADDR_WID-1:0]     AWADDRm22si2;
    input   [AWLEN_WID-1:0]    AWLENm22si2;
    input   [AWSIZE_WID-1:0]   AWSIZEm22si2;  
    input   [AWBURST_WID-1:0]  AWBURSTm22si2; 
    input   [AWLOCK_WID-1:0]   AWLOCKm22si2;  
    input   [AWCACHE_WID-1:0]      AWCACHEm22si2; 
    input   [AWPROT_WID-1:0]       AWPROTm22si2;  

    input   AWVALIDm22si2; 
    output  AWREADYsi22m2; 

    //Write data channel
    input   [ID_WID-1:0]       WIDm22si2;     
    input   [BUS_WID-1:0]      WDATAm22si2;   
    input   [WSTRB_WID-1:0]    WSTRBm22si2;   
    input   WLASTm22si2;   
    input   WVALIDm22si2;  
    output  WREADYsi22m2;  

    //Write response channel
    output   [ID_WID-1:0]      BIDsi22m2;     
    output   [BRESP_WID-1:0]   BRESPsi22m2;   
    output   BVALIDsi22m2;  
    input    BREADYm22si2;  
    
    //For Master 3
    //Write address channel
    input   [ID_WID-1:0]       AWIDm32si3;    
    input   [ADDR_WID-1:0]     AWADDRm32si3;
    input   [AWLEN_WID-1:0]    AWLENm32si3;
    input   [AWSIZE_WID-1:0]   AWSIZEm32si3;  
    input   [AWBURST_WID-1:0]  AWBURSTm32si3; 
    input   [AWLOCK_WID-1:0]   AWLOCKm32si3;  
    input   [AWCACHE_WID-1:0]      AWCACHEm32si3; 
    input   [AWPROT_WID-1:0]       AWPROTm32si3;  

    input   AWVALIDm32si3; 
    output  AWREADYsi32m3; 

    //Write data channel
    input   [ID_WID-1:0]       WIDm32si3;     
    input   [BUS_WID-1:0]      WDATAm32si3;   
    input   [WSTRB_WID-1:0]    WSTRBm32si3;   
    input   WLASTm32si3;   
    input   WVALIDm32si3;  
    output  WREADYsi32m3;  

    //Write response channel
    output   [ID_WID-1:0]      BIDsi32m3;     
    output   [BRESP_WID-1:0]   BRESPsi32m3;   
    output   BVALIDsi32m3;  
    input    BREADYm32si3;  

    // For slave 0
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi02s0;    
    output   [ADDR_WID-1:0]     AWADDRmi02s0;
    output   [AWLEN_WID-1:0]    AWLENmi02s0;
    output   [AWSIZE_WID-1:0]   AWSIZEmi02s0;  
    output   [AWBURST_WID-1:0]  AWBURSTmi02s0; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi02s0;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi02s0; 
    output   [AWPROT_WID-1:0]   AWPROTmi02s0;  

    output   AWVALIDmi02s0; 
    input    AWREADYs02mi0; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi02s0;     
    output   [BUS_WID-1:0]      WDATAmi02s0;   
    output   [WSTRB_WID-1:0]    WSTRBmi02s0;   
    output   WLASTmi02s0;   
    output   WVALIDmi02s0;  
    input    WREADYs02mi0; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs02mi0;     
    input   [BRESP_WID-1:0]   BRESPs02mi0;   
    input   BVALIDs02mi0;  
    output  BREADYmi02s0;  

    
    // For slave 1
    // Write address channel
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi12s1;    
    output   [ADDR_WID-1:0]     AWADDRmi12s1;
    output   [AWLEN_WID-1:0]    AWLENmi12s1;
    output   [AWSIZE_WID-1:0]   AWSIZEmi12s1;  
    output   [AWBURST_WID-1:0]  AWBURSTmi12s1; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi12s1;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi12s1; 
    output   [AWPROT_WID-1:0]   AWPROTmi12s1;  

    output   AWVALIDmi12s1; 
    input    AWREADYs12mi1; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi12s1;     
    output   [BUS_WID-1:0]      WDATAmi12s1;   
    output   [WSTRB_WID-1:0]    WSTRBmi12s1;   
    output   WLASTmi12s1;   
    output   WVALIDmi12s1;  
    input    WREADYs12mi1; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs12mi1;     
    input   [BRESP_WID-1:0]   BRESPs12mi1;   
    input   BVALIDs12mi1;  
    output  BREADYmi12s1;  



    // For Slave 2
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi22s2;    
    output   [ADDR_WID-1:0]     AWADDRmi22s2;
    output   [AWLEN_WID-1:0]    AWLENmi22s2;
    output   [AWSIZE_WID-1:0]   AWSIZEmi22s2;  
    output   [AWBURST_WID-1:0]  AWBURSTmi22s2; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi22s2;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi22s2; 
    output   [AWPROT_WID-1:0]   AWPROTmi22s2;  

    output   AWVALIDmi22s2; 
    input    AWREADYs22mi2; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi22s2;     
    output   [BUS_WID-1:0]      WDATAmi22s2;   
    output   [WSTRB_WID-1:0]    WSTRBmi22s2;   
    output   WLASTmi22s2;   
    output   WVALIDmi22s2;  
    input    WREADYs22mi2; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs22mi2;     
    input   [BRESP_WID-1:0]   BRESPs22mi2;   
    input   BVALIDs22mi2;  
    output  BREADYmi22s2;  


    // For slave 3
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi32s3;    
    output   [ADDR_WID-1:0]     AWADDRmi32s3;
    output   [AWLEN_WID-1:0]    AWLENmi32s3;
    output   [AWSIZE_WID-1:0]   AWSIZEmi32s3;  
    output   [AWBURST_WID-1:0]  AWBURSTmi32s3; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi32s3;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi32s3; 
    output   [AWPROT_WID-1:0]   AWPROTmi32s3;  

    output   AWVALIDmi32s3; 
    input    AWREADYs32mi3; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi32s3;     
    output   [BUS_WID-1:0]      WDATAmi32s3;   
    output   [WSTRB_WID-1:0]    WSTRBmi32s3;   
    output   WLASTmi32s3;   
    output   WVALIDmi32s3;  
    input    WREADYs32mi3; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs32mi3;     
    input   [BRESP_WID-1:0]   BRESPs32mi3;   
    input   BVALIDs32mi3;  
    output  BREADYmi32s3;  


    // For slave 4
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi42s4;    
    output   [ADDR_WID-1:0]     AWADDRmi42s4;
    output   [AWLEN_WID-1:0]    AWLENmi42s4;
    output   [AWSIZE_WID-1:0]   AWSIZEmi42s4;  
    output   [AWBURST_WID-1:0]  AWBURSTmi42s4; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi42s4;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi42s4; 
    output   [AWPROT_WID-1:0]   AWPROTmi42s4;  

    output   AWVALIDmi42s4; 
    input    AWREADYs42mi4; 
    

    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi42s4;     
    output   [BUS_WID-1:0]      WDATAmi42s4;   
    output   [WSTRB_WID-1:0]    WSTRBmi42s4;   
    output   WLASTmi42s4;   
    output   WVALIDmi42s4;  
    input    WREADYs42mi4; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs42mi4;     
    input   [BRESP_WID-1:0]   BRESPs42mi4;   
    input   BVALIDs42mi4;  
    output  BREADYmi42s4;  



    // For slave 5
    // Wriet address channel
    output   [(ID_WID+MASTER_WID-1):0]       AWIDmi52s5;    
    output   [ADDR_WID-1:0]     AWADDRmi52s5;
    output   [AWLEN_WID-1:0]    AWLENmi52s5;
    output   [AWSIZE_WID-1:0]   AWSIZEmi52s5;  
    output   [AWBURST_WID-1:0]  AWBURSTmi52s5; 
    output   [AWLOCK_WID-1:0]   AWLOCKmi52s5;  
    output   [AWCACHE_WID-1:0]  AWCACHEmi52s5; 
    output   [AWPROT_WID-1:0]   AWPROTmi52s5;  

    output   AWVALIDmi52s5; 
    input    AWREADYs52mi5; 
    
    //Write data channel
    output   [(ID_WID+MASTER_WID-1):0]       WIDmi52s5;     
    output   [BUS_WID-1:0]      WDATAmi52s5;   
    output   [WSTRB_WID-1:0]    WSTRBmi52s5;   
    output   WLASTmi52s5;   
    output   WVALIDmi52s5;  
    input    WREADYs52mi5; 

    //Write response channel
    input   [(ID_WID+MASTER_WID-1):0]      BIDs52mi5;     
    input   [BRESP_WID-1:0]   BRESPs52mi5;   
    input   BVALIDs52mi5;  
    output  BREADYmi52s5;  



//Master module 0    
//___________________________________________________________________________

    wire  [ID_WID-1:0] AWIDsi02mi;    
    wire  [ADDR_WID-1:0] AWADDRsi02mi;  
    wire  [AWLEN_WID-1:0] AWLENsi02mi;   
    wire  [AWSIZE_WID-1:0] AWSIZEsi02mi;  
    wire  [AWBURST_WID-1:0] AWBURSTsi02mi; 
    wire  [AWLOCK_WID-1:0] AWLOCKsi02mi;  
    wire  [AWCACHE_WID-1:0] AWCACHEsi02mi; 
    wire  [AWPROT_WID-1:0] AWPROTsi02mi;
    
    wire  [ID_WID-1:0] WIDsi02mi;     
    wire  [BUS_WID-1:0] WDATAsi02mi;   
    wire  [WSTRB_WID-1:0]WSTRBsi02mi;  

    wire   [ID_WID-1:0] BIDmi02si;     
    wire   [BRESP_WID-1:0] BRESPmi02si;   

    wire   [ID_WID-1:0] BIDmi12si;     
    wire   [BRESP_WID-1:0] BRESPmi12si;   

    wire   [ID_WID-1:0] BIDmi22si;     
    wire   [BRESP_WID-1:0] BRESPmi22si;   

    wire   [ID_WID-1:0] BIDmi32si;     
    wire   [BRESP_WID-1:0] BRESPmi32si;   

    wire   [ID_WID-1:0] BIDmi42si;     
    wire   [BRESP_WID-1:0] BRESPmi42si;   

    wire   [ID_WID-1:0] BIDmi52si;     
    wire   [BRESP_WID-1:0] BRESPmi52si;   

    wire    [SLAVE_NUM-1:0]  AWVALIDsi02mi;
    wire    [SLAVE_NUM-1:0] AWREADYmi2si0;
    wire    [SLAVE_NUM-1:0]  WLASTsi02mi;
    wire    [SLAVE_NUM-1:0]  WVALIDsi02mi;
    wire    [SLAVE_NUM-1:0]  WREADYmi2si0;
    wire    [SLAVE_NUM-1:0] BVALIDmi2si0;
    wire    [SLAVE_NUM-1:0]  BREADYsi02mi;	

//Master module 1    
//___________________________________________________________________________

    wire  [ID_WID-1:0] AWIDsi12mi;    
    wire  [ADDR_WID-1:0] AWADDRsi12mi;  
    wire  [AWLEN_WID-1:0] AWLENsi12mi;   
    wire  [AWSIZE_WID-1:0] AWSIZEsi12mi;  
    wire  [AWBURST_WID-1:0] AWBURSTsi12mi; 
    wire  [AWLOCK_WID-1:0] AWLOCKsi12mi;  
    wire  [AWCACHE_WID-1:0] AWCACHEsi12mi; 
    wire  [AWPROT_WID-1:0] AWPROTsi12mi;
    
    wire  [ID_WID-1:0] WIDsi12mi;     
    wire  [BUS_WID-1:0] WDATAsi12mi;   
    wire  [WSTRB_WID-1:0]WSTRBsi12mi;  

    wire    [SLAVE_NUM-1:0]  AWVALIDsi12mi;
    wire    [SLAVE_NUM-1:0]  AWREADYmi2si1;
    wire    [SLAVE_NUM-1:0]  WLASTsi12mi;
    wire    [SLAVE_NUM-1:0]  WVALIDsi12mi;
    wire    [SLAVE_NUM-1:0] WREADYmi2si1;

    wire    [SLAVE_NUM-1:0] BVALIDmi2si1;
    wire    [SLAVE_NUM-1:0]  BREADYsi12mi;


//Master module 2    
//___________________________________________________________________________

    wire  [ID_WID-1:0] AWIDsi22mi;    
    wire  [ADDR_WID-1:0] AWADDRsi22mi;  
    wire  [AWLEN_WID-1:0] AWLENsi22mi;   
    wire  [AWSIZE_WID-1:0] AWSIZEsi22mi;  
    wire  [AWBURST_WID-1:0] AWBURSTsi22mi; 
    wire  [AWLOCK_WID-1:0] AWLOCKsi22mi;  
    wire  [AWCACHE_WID-1:0] AWCACHEsi22mi; 
    wire  [AWPROT_WID-1:0] AWPROTsi22mi;
    
    wire  [ID_WID-1:0] WIDsi22mi;     
    wire  [BUS_WID-1:0] WDATAsi22mi;   
    wire  [WSTRB_WID-1:0]WSTRBsi22mi;  

    wire    [SLAVE_NUM-1:0]  AWVALIDsi22mi;
    wire    [SLAVE_NUM-1:0]  AWREADYmi2si2;
    wire    [SLAVE_NUM-1:0]  WLASTsi22mi;
    wire    [SLAVE_NUM-1:0]  WVALIDsi22mi;
    wire    [SLAVE_NUM-1:0] WREADYmi2si2;
    wire    [SLAVE_NUM-1:0] BVALIDmi2si2;
    wire    [SLAVE_NUM-1:0]  BREADYsi22mi;



//Master module 3    
//___________________________________________________________________________

    wire  [ID_WID-1:0] AWIDsi32mi;    
    wire  [ADDR_WID-1:0] AWADDRsi32mi;  
    wire  [AWLEN_WID-1:0] AWLENsi32mi;   
    wire  [AWSIZE_WID-1:0] AWSIZEsi32mi;  
    wire  [AWBURST_WID-1:0] AWBURSTsi32mi; 
    wire  [AWLOCK_WID-1:0] AWLOCKsi32mi;  
    wire  [AWCACHE_WID-1:0] AWCACHEsi32mi; 
    wire  [AWPROT_WID-1:0] AWPROTsi32mi;
    
    wire  [ID_WID-1:0] WIDsi32mi;     
    wire  [BUS_WID-1:0] WDATAsi32mi;   
    wire  [WSTRB_WID-1:0]WSTRBsi32mi;  

    wire    [SLAVE_NUM-1:0]  AWVALIDsi32mi;
    wire    [SLAVE_NUM-1:0]  AWREADYmi2si3;
    wire    [SLAVE_NUM-1:0]  WLASTsi32mi;
    wire    [SLAVE_NUM-1:0]  WVALIDsi32mi;
    wire    [SLAVE_NUM-1:0] WREADYmi2si3;
    wire    [SLAVE_NUM-1:0] BVALIDmi2si3;
    wire    [SLAVE_NUM-1:0]  BREADYsi32mi;




//Slave module 0    
//___________________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi02si;
    wire  [MASTER_NUM-1:0]    WREADYmi02si;  



//Slave module 1    
//___________________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi12si;
    wire  [MASTER_NUM-1:0]    WREADYmi12si;  
    

//Slave module 2    
//___________________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi22si;
    wire  [MASTER_NUM-1:0]    WREADYmi22si;  
    

//Slave module 3    
//___________________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi32si;
    wire  [MASTER_NUM-1:0]    WREADYmi32si;  

//Slave module 4    
//___________________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi42si;
    wire  [MASTER_NUM-1:0]    WREADYmi42si;  

//Slave module 5    
//___________________________________________________________________________

    wire  [MASTER_NUM-1:0]    AWREADYmi52si;
    wire  [MASTER_NUM-1:0]    WREADYmi52si;  

    wire  [MASTER_NUM-1:0]    BVALIDmi02si;
    wire  [MASTER_NUM-1:0]    BVALIDmi12si;
    wire  [MASTER_NUM-1:0]    BVALIDmi22si;
    wire  [MASTER_NUM-1:0]    BVALIDmi32si;
    wire  [MASTER_NUM-1:0]    BVALIDmi42si;
    wire  [MASTER_NUM-1:0]    BVALIDmi52si;

    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi0;
    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi1;
    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi2;
    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi3;
    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi4;
    wire  [MASTER_NUM-1:0]    AWVALIDsi2mi5;


assign  BVALIDmi2si0 = {BVALIDmi52si[0], BVALIDmi42si[0], BVALIDmi32si[0], BVALIDmi22si[0], BVALIDmi12si[0], BVALIDmi02si[0]};
assign  BVALIDmi2si1 = {BVALIDmi52si[1], BVALIDmi42si[1], BVALIDmi32si[1], BVALIDmi22si[1], BVALIDmi12si[1], BVALIDmi02si[1]};
assign  BVALIDmi2si2 = {BVALIDmi52si[2], BVALIDmi42si[2], BVALIDmi32si[2], BVALIDmi22si[2], BVALIDmi12si[2], BVALIDmi02si[2]};
assign  BVALIDmi2si3 = {BVALIDmi52si[3], BVALIDmi42si[3], BVALIDmi32si[3], BVALIDmi22si[3], BVALIDmi12si[3], BVALIDmi02si[3]};
    
assign  AWREADYmi2si0 = {AWREADYmi52si[0], AWREADYmi42si[0], AWREADYmi32si[0], AWREADYmi22si[0], AWREADYmi12si[0], AWREADYmi02si[0] };
assign  AWREADYmi2si1 = {AWREADYmi52si[1], AWREADYmi42si[1], AWREADYmi32si[1], AWREADYmi22si[1], AWREADYmi12si[1], AWREADYmi02si[1] };
assign  AWREADYmi2si2 = {AWREADYmi52si[2], AWREADYmi42si[2], AWREADYmi32si[2], AWREADYmi22si[2], AWREADYmi12si[2], AWREADYmi02si[2] };
assign  AWREADYmi2si3 = {AWREADYmi52si[3], AWREADYmi42si[3], AWREADYmi32si[3], AWREADYmi22si[3], AWREADYmi12si[3], AWREADYmi02si[3] };

assign  WREADYmi2si0 = {WREADYmi52si[0], WREADYmi42si[0], WREADYmi32si[0], WREADYmi22si[0], WREADYmi12si[0], WREADYmi02si[0] };
assign  WREADYmi2si1 = {WREADYmi52si[1], WREADYmi42si[1], WREADYmi32si[1], WREADYmi22si[1], WREADYmi12si[1], WREADYmi02si[1] };
assign  WREADYmi2si2 = {WREADYmi52si[2], WREADYmi42si[2], WREADYmi32si[2], WREADYmi22si[2], WREADYmi12si[2], WREADYmi02si[2] };
assign  WREADYmi2si3 = {WREADYmi52si[3], WREADYmi42si[3], WREADYmi32si[3], WREADYmi22si[3], WREADYmi12si[3], WREADYmi02si[3] };

assign  AWVALIDsi2mi0 = { AWVALIDsi32mi[0], AWVALIDsi22mi[0], AWVALIDsi12mi[0], AWVALIDsi02mi[0] };
assign  AWVALIDsi2mi1 = { AWVALIDsi32mi[1], AWVALIDsi22mi[1], AWVALIDsi12mi[1], AWVALIDsi02mi[1] };
assign  AWVALIDsi2mi2 = { AWVALIDsi32mi[2], AWVALIDsi22mi[2], AWVALIDsi12mi[2], AWVALIDsi02mi[2] };
assign  AWVALIDsi2mi3 = { AWVALIDsi32mi[3], AWVALIDsi22mi[3], AWVALIDsi12mi[3], AWVALIDsi02mi[3] };
assign  AWVALIDsi2mi4 = { AWVALIDsi32mi[4], AWVALIDsi22mi[4], AWVALIDsi12mi[4], AWVALIDsi02mi[4] };
assign  AWVALIDsi2mi5 = { AWVALIDsi32mi[5], AWVALIDsi22mi[5], AWVALIDsi12mi[5], AWVALIDsi02mi[5] };



//Master module 0    
//___________________________________________________________________________

WriteChannelsi 
U0WriteChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For Master
    //Write address channel
    // xxx2si (slave interface)
    // 2m (Master)
    .AWIDm2si    (AWIDm02si0),
    .AWADDRm2si  (AWADDRm02si0),
    .AWLENm2si   (AWLENm02si0),
    .AWSIZEm2si  (AWSIZEm02si0),
    .AWBURSTm2si (AWBURSTm02si0),
    .AWLOCKm2si  (AWLOCKm02si0),
    .AWCACHEm2si (AWCACHEm02si0),
    .AWPROTm2si  (AWPROTm02si0),

    .AWVALIDm2si (AWVALIDm02si0),
    .AWREADYsi2m (AWREADYsi02m0),

    //Write data channel
    .WIDm2si     (WIDm02si0),
    .WDATAm2si   (WDATAm02si0),
    .WSTRBm2si   (WSTRBm02si0),
    .WLASTm2si   (WLASTm02si0),
    .WVALIDm2si  (WVALIDm02si0),
    .WREADYsi2m  (WREADYsi02m0),

    //Write response channel
    .BIDsi2m     (BIDsi02m0),
    .BRESPsi2m   (BRESPsi02m0),
    .BVALIDsi2m  (BVALIDsi02m0),
    .BREADYm2si  (BREADYm02si0),

    //For Master interface
    //Write address channel
    .AWIDsi2mi    (AWIDsi02mi),
    .AWADDRsi2mi  (AWADDRsi02mi),
    .AWLENsi2mi   (AWLENsi02mi),
    .AWSIZEsi2mi  (AWSIZEsi02mi),
    .AWBURSTsi2mi (AWBURSTsi02mi),
    .AWLOCKsi2mi  (AWLOCKsi02mi),
    .AWCACHEsi2mi (AWCACHEsi02mi),
    .AWPROTsi2mi  (AWPROTsi02mi),
    .AWVALIDsi2mi (AWVALIDsi02mi),
    .AWREADYmi2si (AWREADYmi2si0),

    //Write data channel
    .WIDsi2mi     (WIDsi02mi),
    .WDATAsi2mi   (WDATAsi02mi),
    .WSTRBsi2mi   (WSTRBsi02mi),
    .WLASTsi2mi   (WLASTsi02mi),
    .WVALIDsi2mi  (WVALIDsi02mi),
    .WREADYmi2si  (WREADYmi2si0),

    //Write response channel
    .BIDmi02si     (BIDmi02si),
    .BRESPmi02si   (BRESPmi02si),


    .BIDmi12si     (BIDmi12si),
    .BRESPmi12si   (BRESPmi12si),


    .BIDmi22si     (BIDmi22si),
    .BRESPmi22si   (BRESPmi22si),

    
    .BIDmi32si     (BIDmi32si),
    .BRESPmi32si   (BRESPmi32si),


    .BIDmi42si     (BIDmi42si),
    .BRESPmi42si   (BRESPmi42si),


    .BIDmi52si     (BIDmi52si),
    .BRESPmi52si   (BRESPmi52si),

    .BVALIDmi2si  (BVALIDmi2si0),
    .BREADYsi2mi  (BREADYsi02mi)	
);


//Master module 1    
//___________________________________________________________________________

WriteChannelsi 
U1WriteChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For Master
    //Write address channel
    // xxx2si (slave interface)
    // 2m (Master)
    .AWIDm2si    (AWIDm12si1),
    .AWADDRm2si  (AWADDRm12si1),
    .AWLENm2si   (AWLENm12si1),
    .AWSIZEm2si  (AWSIZEm12si1),
    .AWBURSTm2si (AWBURSTm12si1),
    .AWLOCKm2si  (AWLOCKm12si1),
    .AWCACHEm2si (AWCACHEm12si1),
    .AWPROTm2si  (AWPROTm12si1),

    .AWVALIDm2si (AWVALIDm12si1),
    .AWREADYsi2m (AWREADYsi12m1),

    //Write data channel
    .WIDm2si     (WIDm12si1),
    .WDATAm2si   (WDATAm12si1),
    .WSTRBm2si   (WSTRBm12si1),
    .WLASTm2si   (WLASTm12si1),
    .WVALIDm2si  (WVALIDm12si1),
    .WREADYsi2m  (WREADYsi12m1),

    //Write response channel
    .BIDsi2m     (BIDsi12m1),
    .BRESPsi2m   (BRESPsi12m1),
    .BVALIDsi2m  (BVALIDsi12m1),
    .BREADYm2si  (BREADYm12si1),

    //For Master interface
    //Write address channel
    .AWIDsi2mi    (AWIDsi12mi),
    .AWADDRsi2mi  (AWADDRsi12mi),
    .AWLENsi2mi   (AWLENsi12mi),
    .AWSIZEsi2mi  (AWSIZEsi12mi),
    .AWBURSTsi2mi (AWBURSTsi12mi),
    .AWLOCKsi2mi  (AWLOCKsi12mi),
    .AWCACHEsi2mi (AWCACHEsi12mi),
    .AWPROTsi2mi  (AWPROTsi12mi),
    .AWVALIDsi2mi (AWVALIDsi12mi),
    .AWREADYmi2si (AWREADYmi2si1),

    //Write data channel
    .WIDsi2mi     (WIDsi12mi),
    .WDATAsi2mi   (WDATAsi12mi),
    .WSTRBsi2mi   (WSTRBsi12mi),
    .WLASTsi2mi   (WLASTsi12mi),
    .WVALIDsi2mi  (WVALIDsi12mi),
    .WREADYmi2si  (WREADYmi2si1),

    //Write response channel
    .BIDmi02si     (BIDmi02si),
    .BRESPmi02si   (BRESPmi02si),


    .BIDmi12si     (BIDmi12si),
    .BRESPmi12si   (BRESPmi12si),


    .BIDmi22si     (BIDmi22si),
    .BRESPmi22si   (BRESPmi22si),

    
    .BIDmi32si     (BIDmi32si),
    .BRESPmi32si   (BRESPmi32si),


    .BIDmi42si     (BIDmi42si),
    .BRESPmi42si   (BRESPmi42si),


    .BIDmi52si     (BIDmi52si),
    .BRESPmi52si   (BRESPmi52si),

    .BVALIDmi2si  (BVALIDmi2si1),
    .BREADYsi2mi  (BREADYsi12mi)	
);


//Master module 2    
//___________________________________________________________________________

WriteChannelsi 
U2WriteChannelsi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For Master
    //Write address channel
    // xxx2si (slave interface)
    // 2m (Master)
    .AWIDm2si    (AWIDm22si2),
    .AWADDRm2si  (AWADDRm22si2),
    .AWLENm2si   (AWLENm22si2),
    .AWSIZEm2si  (AWSIZEm22si2),
    .AWBURSTm2si (AWBURSTm22si2),
    .AWLOCKm2si  (AWLOCKm22si2),
    .AWCACHEm2si (AWCACHEm22si2),
    .AWPROTm2si  (AWPROTm22si2),

    .AWVALIDm2si (AWVALIDm22si2),
    .AWREADYsi2m (AWREADYsi22m2),

    //Write data channel
    .WIDm2si     (WIDm22si2),
    .WDATAm2si   (WDATAm22si2),
    .WSTRBm2si   (WSTRBm22si2),
    .WLASTm2si   (WLASTm22si2),
    .WVALIDm2si  (WVALIDm22si2),
    .WREADYsi2m  (WREADYsi22m2),

    //Write response channel
    .BIDsi2m     (BIDsi22m2),
    .BRESPsi2m   (BRESPsi22m2),
    .BVALIDsi2m  (BVALIDsi22m2),
    .BREADYm2si  (BREADYm22si2),

    //For Master interface
    //Write address channel
    .AWIDsi2mi    (AWIDsi22mi),
    .AWADDRsi2mi  (AWADDRsi22mi),
    .AWLENsi2mi   (AWLENsi22mi),
    .AWSIZEsi2mi  (AWSIZEsi22mi),
    .AWBURSTsi2mi (AWBURSTsi22mi),
    .AWLOCKsi2mi  (AWLOCKsi22mi),
    .AWCACHEsi2mi (AWCACHEsi22mi),
    .AWPROTsi2mi  (AWPROTsi22mi),
    .AWVALIDsi2mi (AWVALIDsi22mi),
    .AWREADYmi2si (AWREADYmi2si2),

    //Write data channel
    .WIDsi2mi     (WIDsi22mi),
    .WDATAsi2mi   (WDATAsi22mi),
    .WSTRBsi2mi   (WSTRBsi22mi),
    .WLASTsi2mi   (WLASTsi22mi),
    .WVALIDsi2mi  (WVALIDsi22mi),
    .WREADYmi2si  (WREADYmi2si2),

    //Write response channel
    .BIDmi02si     (BIDmi02si),
    .BRESPmi02si   (BRESPmi02si),


    .BIDmi12si     (BIDmi12si),
    .BRESPmi12si   (BRESPmi12si),


    .BIDmi22si     (BIDmi22si),
    .BRESPmi22si   (BRESPmi22si),

    
    .BIDmi32si     (BIDmi32si),
    .BRESPmi32si   (BRESPmi32si),


    .BIDmi42si     (BIDmi42si),
    .BRESPmi42si   (BRESPmi42si),


    .BIDmi52si     (BIDmi52si),
    .BRESPmi52si   (BRESPmi52si),

    .BVALIDmi2si  (BVALIDmi2si2),
    .BREADYsi2mi  (BREADYsi22mi)	
);

//Master module 3    
//___________________________________________________________________________

WriteChannelsi
U3WriteChannelsi(
    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For Master
    //Write address channel
    // xxx2si (slave interface)
    // 2m (Master)
    .AWIDm2si    (AWIDm32si3),
    .AWADDRm2si  (AWADDRm32si3),
    .AWLENm2si   (AWLENm32si3),
    .AWSIZEm2si  (AWSIZEm32si3),
    .AWBURSTm2si (AWBURSTm32si3),
    .AWLOCKm2si  (AWLOCKm32si3),
    .AWCACHEm2si (AWCACHEm32si3),
    .AWPROTm2si  (AWPROTm32si3),

    .AWVALIDm2si (AWVALIDm32si3),
    .AWREADYsi2m (AWREADYsi32m3),

    //Write data channel
    .WIDm2si     (WIDm32si3),
    .WDATAm2si   (WDATAm32si3),
    .WSTRBm2si   (WSTRBm32si3),
    .WLASTm2si   (WLASTm32si3),
    .WVALIDm2si  (WVALIDm32si3),
    .WREADYsi2m  (WREADYsi32m3),

    //Write response channel
    .BIDsi2m     (BIDsi32m3),
    .BRESPsi2m   (BRESPsi32m3),
    .BVALIDsi2m  (BVALIDsi32m3),
    .BREADYm2si  (BREADYm32si3),

    //For Master interface
    //Write address channel
    .AWIDsi2mi    (AWIDsi32mi),
    .AWADDRsi2mi  (AWADDRsi32mi),
    .AWLENsi2mi   (AWLENsi32mi),
    .AWSIZEsi2mi  (AWSIZEsi32mi),
    .AWBURSTsi2mi (AWBURSTsi32mi),
    .AWLOCKsi2mi  (AWLOCKsi32mi),
    .AWCACHEsi2mi (AWCACHEsi32mi),
    .AWPROTsi2mi  (AWPROTsi32mi),
    .AWVALIDsi2mi (AWVALIDsi32mi),
    .AWREADYmi2si (AWREADYmi2si3),

    //Write data channel
    .WIDsi2mi     (WIDsi32mi),
    .WDATAsi2mi   (WDATAsi32mi),
    .WSTRBsi2mi   (WSTRBsi32mi),
    .WLASTsi2mi   (WLASTsi32mi),
    .WVALIDsi2mi  (WVALIDsi32mi),
    .WREADYmi2si  (WREADYmi2si3),

    //Write response channel
    .BIDmi02si     (BIDmi02si),
    .BRESPmi02si   (BRESPmi02si),


    .BIDmi12si     (BIDmi12si),
    .BRESPmi12si   (BRESPmi12si),


    .BIDmi22si     (BIDmi22si),
    .BRESPmi22si   (BRESPmi22si),

    
    .BIDmi32si     (BIDmi32si),
    .BRESPmi32si   (BRESPmi32si),


    .BIDmi42si     (BIDmi42si),
    .BRESPmi42si   (BRESPmi42si),


    .BIDmi52si     (BIDmi52si),
    .BRESPmi52si   (BRESPmi52si),

    .BVALIDmi2si  (BVALIDmi2si3),
    .BREADYsi2mi  (BREADYsi32mi)	
);





//Slave module 0    
//___________________________________________________________________________

WriteChannelmi 
U0WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Write address channel
    .AWIDmi2s    (AWIDmi02s0),
    .AWADDRmi2s  (AWADDRmi02s0),
    .AWLENmi2s   (AWLENmi02s0),
    .AWSIZEmi2s  (AWSIZEmi02s0),
    .AWBURSTmi2s (AWBURSTmi02s0),
    .AWLOCKmi2s  (AWLOCKmi02s0),
    .AWCACHEmi2s (AWCACHEmi02s0),
    .AWPROTmi2s  (AWPROTmi02s0),

    .AWVALIDmi2s (AWVALIDmi02s0),
    .AWREADYs2mi (AWREADYs02mi0),

    //Write data channel
    .WIDmi2s     (WIDmi02s0),
    .WDATAmi2s   (WDATAmi02s0),
    .WSTRBmi2s   (WSTRBmi02s0),
    .WLASTmi2s   (WLASTmi02s0),
    .WVALIDmi2s  (WVALIDmi02s0),
    .WREADYs2mi  (WREADYs02mi0),

    //Write response channel
    .BIDs2mi     (BIDs02mi0),
    .BRESPs2mi   (BRESPs02mi0),
    .BVALIDs2mi  (BVALIDs02mi0),
    .BREADYmi2s  (BREADYmi02s0),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi),
    .AWADDRsi02mi  (AWADDRsi02mi),
    .AWLENsi02mi   (AWLENsi02mi),
    .AWSIZEsi02mi  (AWSIZEsi02mi),
    .AWBURSTsi02mi (AWBURSTsi02mi),
    .AWLOCKsi02mi  (AWLOCKsi02mi),
    .AWCACHEsi02mi (AWCACHEsi02mi),
    .AWPROTsi02mi  (AWPROTsi02mi),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi),
    .AWADDRsi12mi  (AWADDRsi12mi),
    .AWLENsi12mi   (AWLENsi12mi),
    .AWSIZEsi12mi  (AWSIZEsi12mi),
    .AWBURSTsi12mi (AWBURSTsi12mi),
    .AWLOCKsi12mi  (AWLOCKsi12mi),
    .AWCACHEsi12mi (AWCACHEsi12mi),
    .AWPROTsi12mi  (AWPROTsi12mi),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi),
    .AWADDRsi22mi  (AWADDRsi22mi),
    .AWLENsi22mi   (AWLENsi22mi),
    .AWSIZEsi22mi  (AWSIZEsi22mi),
    .AWBURSTsi22mi (AWBURSTsi22mi),
    .AWLOCKsi22mi  (AWLOCKsi22mi),
    .AWCACHEsi22mi (AWCACHEsi22mi),
    .AWPROTsi22mi  (AWPROTsi22mi),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi),
    .AWADDRsi32mi  (AWADDRsi32mi),
    .AWLENsi32mi   (AWLENsi32mi),
    .AWSIZEsi32mi  (AWSIZEsi32mi),
    .AWBURSTsi32mi (AWBURSTsi32mi),
    .AWLOCKsi32mi  (AWLOCKsi32mi),
    .AWCACHEsi32mi (AWCACHEsi32mi),
    .AWPROTsi32mi  (AWPROTsi32mi),

    //Master 0/1/2/3
    //.AWVALIDsi2mi  ({AWVALIDsi32mi[0], AWVALIDsi22mi[0], AWVALIDsi12mi[0], AWVALIDsi02mi[0]}),
    .AWVALIDsi2mi  (AWVALIDsi2mi0),

    .AWREADYmi2si  (AWREADYmi02si),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi),     
    .WDATAsi02mi (WDATAsi02mi),   
    .WSTRBsi02mi (WSTRBsi02mi),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi),     
    .WDATAsi12mi (WDATAsi12mi),   
    .WSTRBsi12mi (WSTRBsi12mi),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi),     
    .WDATAsi22mi (WDATAsi22mi),   
    .WSTRBsi22mi (WSTRBsi22mi),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi),     
    .WDATAsi32mi (WDATAsi32mi),   
    .WSTRBsi32mi (WSTRBsi32mi),   

    //Master 0/1/2/3
    .WLASTsi2mi   ({WLASTsi32mi[0], WLASTsi22mi[0], WLASTsi12mi[0], WLASTsi02mi[0]}),
    .WVALIDsi2mi  ({WVALIDsi32mi[0], WVALIDsi22mi[0], WVALIDsi12mi[0], WVALIDsi02mi[0]}),

    //output 1port
    .WREADYmi2si  (WREADYmi02si),

    //Write response channel
    .BIDmi2si     (BIDmi02si),
    .BRESPmi2si   (BRESPmi02si),
    .BVALIDmi2si  (BVALIDmi02si),

    .BREADYsi2mi  ({BREADYsi32mi[0],BREADYsi22mi[0],BREADYsi12mi[0],BREADYsi02mi[0]})

    );
    




//Slave module 1    
//___________________________________________________________________________

WriteChannelmi 
U1WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Write address channel
    .AWIDmi2s    (AWIDmi12s1),
    .AWADDRmi2s  (AWADDRmi12s1),
    .AWLENmi2s   (AWLENmi12s1),
    .AWSIZEmi2s  (AWSIZEmi12s1),
    .AWBURSTmi2s (AWBURSTmi12s1),
    .AWLOCKmi2s  (AWLOCKmi12s1),
    .AWCACHEmi2s (AWCACHEmi12s1),
    .AWPROTmi2s  (AWPROTmi12s1),

    .AWVALIDmi2s (AWVALIDmi12s1),
    .AWREADYs2mi (AWREADYs12mi1),

    //Write data channel
    .WIDmi2s     (WIDmi12s1),
    .WDATAmi2s   (WDATAmi12s1),
    .WSTRBmi2s   (WSTRBmi12s1),
    .WLASTmi2s   (WLASTmi12s1),
    .WVALIDmi2s  (WVALIDmi12s1),
    .WREADYs2mi  (WREADYs12mi1),

    //Write response channel
    .BIDs2mi     (BIDs12mi1),
    .BRESPs2mi   (BRESPs12mi1),
    .BVALIDs2mi  (BVALIDs12mi1),
    .BREADYmi2s  (BREADYmi12s1),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi),
    .AWADDRsi02mi  (AWADDRsi02mi),
    .AWLENsi02mi   (AWLENsi02mi),
    .AWSIZEsi02mi  (AWSIZEsi02mi),
    .AWBURSTsi02mi (AWBURSTsi02mi),
    .AWLOCKsi02mi  (AWLOCKsi02mi),
    .AWCACHEsi02mi (AWCACHEsi02mi),
    .AWPROTsi02mi  (AWPROTsi02mi),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi),
    .AWADDRsi12mi  (AWADDRsi12mi),
    .AWLENsi12mi   (AWLENsi12mi),
    .AWSIZEsi12mi  (AWSIZEsi12mi),
    .AWBURSTsi12mi (AWBURSTsi12mi),
    .AWLOCKsi12mi  (AWLOCKsi12mi),
    .AWCACHEsi12mi (AWCACHEsi12mi),
    .AWPROTsi12mi  (AWPROTsi12mi),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi),
    .AWADDRsi22mi  (AWADDRsi22mi),
    .AWLENsi22mi   (AWLENsi22mi),
    .AWSIZEsi22mi  (AWSIZEsi22mi),
    .AWBURSTsi22mi (AWBURSTsi22mi),
    .AWLOCKsi22mi  (AWLOCKsi22mi),
    .AWCACHEsi22mi (AWCACHEsi22mi),
    .AWPROTsi22mi  (AWPROTsi22mi),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi),
    .AWADDRsi32mi  (AWADDRsi32mi),
    .AWLENsi32mi   (AWLENsi32mi),
    .AWSIZEsi32mi  (AWSIZEsi32mi),
    .AWBURSTsi32mi (AWBURSTsi32mi),
    .AWLOCKsi32mi  (AWLOCKsi32mi),
    .AWCACHEsi32mi (AWCACHEsi32mi),
    .AWPROTsi32mi  (AWPROTsi32mi),

    //Master 0/1/2/3
    //.AWVALIDsi2mi  ({AWVALIDsi32mi[1], AWVALIDsi22mi[1], AWVALIDsi12mi[1], AWVALIDsi02mi[1]}),
    .AWVALIDsi2mi  (AWVALIDsi2mi1),

    .AWREADYmi2si  (AWREADYmi12si),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi),     
    .WDATAsi02mi (WDATAsi02mi),   
    .WSTRBsi02mi (WSTRBsi02mi),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi),     
    .WDATAsi12mi (WDATAsi12mi),   
    .WSTRBsi12mi (WSTRBsi12mi),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi),     
    .WDATAsi22mi (WDATAsi22mi),   
    .WSTRBsi22mi (WSTRBsi22mi),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi),     
    .WDATAsi32mi (WDATAsi32mi),   
    .WSTRBsi32mi (WSTRBsi32mi),   

    //Master 0/1/2/3
    .WLASTsi2mi   ({WLASTsi32mi[1], WLASTsi22mi[1], WLASTsi12mi[1], WLASTsi02mi[1]}),
    .WVALIDsi2mi  ({WVALIDsi32mi[1], WVALIDsi22mi[1], WVALIDsi12mi[1], WVALIDsi02mi[1]}),

    //output 1port
    .WREADYmi2si  (WREADYmi12si),

    //Write response channel
    .BIDmi2si     (BIDmi12si),
    .BRESPmi2si   (BRESPmi12si),
    .BVALIDmi2si  (BVALIDmi12si),

    .BREADYsi2mi  ({BREADYsi32mi[1],BREADYsi22mi[1],BREADYsi12mi[1],BREADYsi02mi[1]})

    );
    




//Slave module 2    
//___________________________________________________________________________

WriteChannelmi 
U2WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Write address channel
    .AWIDmi2s    (AWIDmi22s2),
    .AWADDRmi2s  (AWADDRmi22s2),
    .AWLENmi2s   (AWLENmi22s2),
    .AWSIZEmi2s  (AWSIZEmi22s2),
    .AWBURSTmi2s (AWBURSTmi22s2),
    .AWLOCKmi2s  (AWLOCKmi22s2),
    .AWCACHEmi2s (AWCACHEmi22s2),
    .AWPROTmi2s  (AWPROTmi22s2),

    .AWVALIDmi2s (AWVALIDmi22s2),
    .AWREADYs2mi (AWREADYs22mi2),

    //Write data channel
    .WIDmi2s     (WIDmi22s2),
    .WDATAmi2s   (WDATAmi22s2),
    .WSTRBmi2s   (WSTRBmi22s2),
    .WLASTmi2s   (WLASTmi22s2),
    .WVALIDmi2s  (WVALIDmi22s2),
    .WREADYs2mi  (WREADYs22mi2),

    //Write response channel
    .BIDs2mi     (BIDs22mi2),
    .BRESPs2mi   (BRESPs22mi2),
    .BVALIDs2mi  (BVALIDs22mi2),
    .BREADYmi2s  (BREADYmi22s2),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi),
    .AWADDRsi02mi  (AWADDRsi02mi),
    .AWLENsi02mi   (AWLENsi02mi),
    .AWSIZEsi02mi  (AWSIZEsi02mi),
    .AWBURSTsi02mi (AWBURSTsi02mi),
    .AWLOCKsi02mi  (AWLOCKsi02mi),
    .AWCACHEsi02mi (AWCACHEsi02mi),
    .AWPROTsi02mi  (AWPROTsi02mi),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi),
    .AWADDRsi12mi  (AWADDRsi12mi),
    .AWLENsi12mi   (AWLENsi12mi),
    .AWSIZEsi12mi  (AWSIZEsi12mi),
    .AWBURSTsi12mi (AWBURSTsi12mi),
    .AWLOCKsi12mi  (AWLOCKsi12mi),
    .AWCACHEsi12mi (AWCACHEsi12mi),
    .AWPROTsi12mi  (AWPROTsi12mi),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi),
    .AWADDRsi22mi  (AWADDRsi22mi),
    .AWLENsi22mi   (AWLENsi22mi),
    .AWSIZEsi22mi  (AWSIZEsi22mi),
    .AWBURSTsi22mi (AWBURSTsi22mi),
    .AWLOCKsi22mi  (AWLOCKsi22mi),
    .AWCACHEsi22mi (AWCACHEsi22mi),
    .AWPROTsi22mi  (AWPROTsi22mi),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi),
    .AWADDRsi32mi  (AWADDRsi32mi),
    .AWLENsi32mi   (AWLENsi32mi),
    .AWSIZEsi32mi  (AWSIZEsi32mi),
    .AWBURSTsi32mi (AWBURSTsi32mi),
    .AWLOCKsi32mi  (AWLOCKsi32mi),
    .AWCACHEsi32mi (AWCACHEsi32mi),
    .AWPROTsi32mi  (AWPROTsi32mi),

    //Master 0/1/2/3
    //.AWVALIDsi2mi  ({AWVALIDsi32mi[1], AWVALIDsi22mi[1], AWVALIDsi12mi[1], AWVALIDsi02mi[1]}),
    .AWVALIDsi2mi  (AWVALIDsi2mi2),

    .AWREADYmi2si  (AWREADYmi22si),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi),     
    .WDATAsi02mi (WDATAsi02mi),   
    .WSTRBsi02mi (WSTRBsi02mi),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi),     
    .WDATAsi12mi (WDATAsi12mi),   
    .WSTRBsi12mi (WSTRBsi12mi),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi),     
    .WDATAsi22mi (WDATAsi22mi),   
    .WSTRBsi22mi (WSTRBsi22mi),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi),     
    .WDATAsi32mi (WDATAsi32mi),   
    .WSTRBsi32mi (WSTRBsi32mi),   

    //Master 0/1/2/3
    .WLASTsi2mi   ({WLASTsi32mi[2], WLASTsi22mi[2], WLASTsi12mi[2], WLASTsi02mi[2]}),
    .WVALIDsi2mi  ({WVALIDsi32mi[2], WVALIDsi22mi[2], WVALIDsi12mi[2], WVALIDsi02mi[2]}),

    //output 1port
    .WREADYmi2si  (WREADYmi22si),

    //Write response channel
    .BIDmi2si     (BIDmi22si),
    .BRESPmi2si   (BRESPmi22si),
    .BVALIDmi2si  (BVALIDmi22si),

    .BREADYsi2mi  ({BREADYsi32mi[2],BREADYsi22mi[2],BREADYsi12mi[2],BREADYsi02mi[2]})

    );
    
    



//Slave module 3    
//___________________________________________________________________________

WriteChannelmi 
U3WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Write address channel
    .AWIDmi2s    (AWIDmi32s3),
    .AWADDRmi2s  (AWADDRmi32s3),
    .AWLENmi2s   (AWLENmi32s3),
    .AWSIZEmi2s  (AWSIZEmi32s3),
    .AWBURSTmi2s (AWBURSTmi32s3),
    .AWLOCKmi2s  (AWLOCKmi32s3),
    .AWCACHEmi2s (AWCACHEmi32s3),
    .AWPROTmi2s  (AWPROTmi32s3),

    .AWVALIDmi2s (AWVALIDmi32s3),
    .AWREADYs2mi (AWREADYs32mi3),

    //Write data channel
    .WIDmi2s     (WIDmi32s3),
    .WDATAmi2s   (WDATAmi32s3),
    .WSTRBmi2s   (WSTRBmi32s3),
    .WLASTmi2s   (WLASTmi32s3),
    .WVALIDmi2s  (WVALIDmi32s3),
    .WREADYs2mi  (WREADYs32mi3),

    //Write response channel
    .BIDs2mi     (BIDs32mi3),
    .BRESPs2mi   (BRESPs32mi3),
    .BVALIDs2mi  (BVALIDs32mi3),
    .BREADYmi2s  (BREADYmi32s3),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi),
    .AWADDRsi02mi  (AWADDRsi02mi),
    .AWLENsi02mi   (AWLENsi02mi),
    .AWSIZEsi02mi  (AWSIZEsi02mi),
    .AWBURSTsi02mi (AWBURSTsi02mi),
    .AWLOCKsi02mi  (AWLOCKsi02mi),
    .AWCACHEsi02mi (AWCACHEsi02mi),
    .AWPROTsi02mi  (AWPROTsi02mi),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi),
    .AWADDRsi12mi  (AWADDRsi12mi),
    .AWLENsi12mi   (AWLENsi12mi),
    .AWSIZEsi12mi  (AWSIZEsi12mi),
    .AWBURSTsi12mi (AWBURSTsi12mi),
    .AWLOCKsi12mi  (AWLOCKsi12mi),
    .AWCACHEsi12mi (AWCACHEsi12mi),
    .AWPROTsi12mi  (AWPROTsi12mi),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi),
    .AWADDRsi22mi  (AWADDRsi22mi),
    .AWLENsi22mi   (AWLENsi22mi),
    .AWSIZEsi22mi  (AWSIZEsi22mi),
    .AWBURSTsi22mi (AWBURSTsi22mi),
    .AWLOCKsi22mi  (AWLOCKsi22mi),
    .AWCACHEsi22mi (AWCACHEsi22mi),
    .AWPROTsi22mi  (AWPROTsi22mi),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi),
    .AWADDRsi32mi  (AWADDRsi32mi),
    .AWLENsi32mi   (AWLENsi32mi),
    .AWSIZEsi32mi  (AWSIZEsi32mi),
    .AWBURSTsi32mi (AWBURSTsi32mi),
    .AWLOCKsi32mi  (AWLOCKsi32mi),
    .AWCACHEsi32mi (AWCACHEsi32mi),
    .AWPROTsi32mi  (AWPROTsi32mi),

    //Master 0/1/2/3
    //.AWVALIDsi2mi  ({AWVALIDsi32mi[1], AWVALIDsi22mi[1], AWVALIDsi12mi[1], AWVALIDsi02mi[1]}),
    .AWVALIDsi2mi  (AWVALIDsi2mi3),

    .AWREADYmi2si  (AWREADYmi32si),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi),     
    .WDATAsi02mi (WDATAsi02mi),   
    .WSTRBsi02mi (WSTRBsi02mi),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi),     
    .WDATAsi12mi (WDATAsi12mi),   
    .WSTRBsi12mi (WSTRBsi12mi),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi),     
    .WDATAsi22mi (WDATAsi22mi),   
    .WSTRBsi22mi (WSTRBsi22mi),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi),     
    .WDATAsi32mi (WDATAsi32mi),   
    .WSTRBsi32mi (WSTRBsi32mi),   

    //Master 0/1/2/3
    .WLASTsi2mi   ({WLASTsi32mi[3], WLASTsi22mi[3], WLASTsi12mi[3], WLASTsi02mi[3]}),
    .WVALIDsi2mi  ({WVALIDsi32mi[3], WVALIDsi22mi[3], WVALIDsi12mi[3], WVALIDsi02mi[3]}),

    //output 1port
    .WREADYmi2si  (WREADYmi32si),

    //Write response channel
    .BIDmi2si     (BIDmi32si),
    .BRESPmi2si   (BRESPmi32si),
    .BVALIDmi2si  (BVALIDmi32si),

    .BREADYsi2mi  ({BREADYsi32mi[3],BREADYsi22mi[3],BREADYsi12mi[3],BREADYsi02mi[3]})

    );
    




//Slave module 4    
//___________________________________________________________________________

WriteChannelmi 
U4WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Write address channel
    .AWIDmi2s    (AWIDmi42s4),
    .AWADDRmi2s  (AWADDRmi42s4),
    .AWLENmi2s   (AWLENmi42s4),
    .AWSIZEmi2s  (AWSIZEmi42s4),
    .AWBURSTmi2s (AWBURSTmi42s4),
    .AWLOCKmi2s  (AWLOCKmi42s4),
    .AWCACHEmi2s (AWCACHEmi42s4),
    .AWPROTmi2s  (AWPROTmi42s4),

    .AWVALIDmi2s (AWVALIDmi42s4),
    .AWREADYs2mi (AWREADYs42mi4),

    //Write data channel
    .WIDmi2s     (WIDmi42s4),
    .WDATAmi2s   (WDATAmi42s4),
    .WSTRBmi2s   (WSTRBmi42s4),
    .WLASTmi2s   (WLASTmi42s4),
    .WVALIDmi2s  (WVALIDmi42s4),
    .WREADYs2mi  (WREADYs42mi4),

    //Write response channel
    .BIDs2mi     (BIDs42mi4),
    .BRESPs2mi   (BRESPs42mi4),
    .BVALIDs2mi  (BVALIDs42mi4),
    .BREADYmi2s  (BREADYmi42s4),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi),
    .AWADDRsi02mi  (AWADDRsi02mi),
    .AWLENsi02mi   (AWLENsi02mi),
    .AWSIZEsi02mi  (AWSIZEsi02mi),
    .AWBURSTsi02mi (AWBURSTsi02mi),
    .AWLOCKsi02mi  (AWLOCKsi02mi),
    .AWCACHEsi02mi (AWCACHEsi02mi),
    .AWPROTsi02mi  (AWPROTsi02mi),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi),
    .AWADDRsi12mi  (AWADDRsi12mi),
    .AWLENsi12mi   (AWLENsi12mi),
    .AWSIZEsi12mi  (AWSIZEsi12mi),
    .AWBURSTsi12mi (AWBURSTsi12mi),
    .AWLOCKsi12mi  (AWLOCKsi12mi),
    .AWCACHEsi12mi (AWCACHEsi12mi),
    .AWPROTsi12mi  (AWPROTsi12mi),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi),
    .AWADDRsi22mi  (AWADDRsi22mi),
    .AWLENsi22mi   (AWLENsi22mi),
    .AWSIZEsi22mi  (AWSIZEsi22mi),
    .AWBURSTsi22mi (AWBURSTsi22mi),
    .AWLOCKsi22mi  (AWLOCKsi22mi),
    .AWCACHEsi22mi (AWCACHEsi22mi),
    .AWPROTsi22mi  (AWPROTsi22mi),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi),
    .AWADDRsi32mi  (AWADDRsi32mi),
    .AWLENsi32mi   (AWLENsi32mi),
    .AWSIZEsi32mi  (AWSIZEsi32mi),
    .AWBURSTsi32mi (AWBURSTsi32mi),
    .AWLOCKsi32mi  (AWLOCKsi32mi),
    .AWCACHEsi32mi (AWCACHEsi32mi),
    .AWPROTsi32mi  (AWPROTsi32mi),

    //Master 0/1/2/3
    //.AWVALIDsi2mi  ({AWVALIDsi32mi[1], AWVALIDsi22mi[1], AWVALIDsi12mi[1], AWVALIDsi02mi[1]}),
    .AWVALIDsi2mi  (AWVALIDsi2mi4),

    .AWREADYmi2si  (AWREADYmi42si),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi),     
    .WDATAsi02mi (WDATAsi02mi),   
    .WSTRBsi02mi (WSTRBsi02mi),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi),     
    .WDATAsi12mi (WDATAsi12mi),   
    .WSTRBsi12mi (WSTRBsi12mi),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi),     
    .WDATAsi22mi (WDATAsi22mi),   
    .WSTRBsi22mi (WSTRBsi22mi),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi),     
    .WDATAsi32mi (WDATAsi32mi),   
    .WSTRBsi32mi (WSTRBsi32mi),   

    //Master 0/1/2/3
    .WLASTsi2mi   ({WLASTsi32mi[4], WLASTsi22mi[4], WLASTsi12mi[4], WLASTsi02mi[4]}),
    .WVALIDsi2mi  ({WVALIDsi32mi[4], WVALIDsi22mi[4], WVALIDsi12mi[4], WVALIDsi02mi[4]}),

    //output 1port
    .WREADYmi2si  (WREADYmi42si),

    //Write response channel
    .BIDmi2si     (BIDmi42si),
    .BRESPmi2si   (BRESPmi42si),
    .BVALIDmi2si  (BVALIDmi42si),

    .BREADYsi2mi  ({BREADYsi32mi[4],BREADYsi22mi[4],BREADYsi12mi[4],BREADYsi02mi[4]})

    );
    




//Slave module 5    
//___________________________________________________________________________

WriteChannelmi 
U5WriteChannelmi(

    //Global signal
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    //For slave 
    //Write address channel
    .AWIDmi2s    (AWIDmi52s5),
    .AWADDRmi2s  (AWADDRmi52s5),
    .AWLENmi2s   (AWLENmi52s5),
    .AWSIZEmi2s  (AWSIZEmi52s5),
    .AWBURSTmi2s (AWBURSTmi52s5),
    .AWLOCKmi2s  (AWLOCKmi52s5),
    .AWCACHEmi2s (AWCACHEmi52s5),
    .AWPROTmi2s  (AWPROTmi52s5),

    .AWVALIDmi2s (AWVALIDmi52s5),
    .AWREADYs2mi (AWREADYs52mi5),

    //Write data channel
    .WIDmi2s     (WIDmi52s5),
    .WDATAmi2s   (WDATAmi52s5),
    .WSTRBmi2s   (WSTRBmi52s5),
    .WLASTmi2s   (WLASTmi52s5),
    .WVALIDmi2s  (WVALIDmi52s5),
    .WREADYs2mi  (WREADYs52mi5),

    //Write response channel
    .BIDs2mi     (BIDs52mi5),
    .BRESPs2mi   (BRESPs52mi5),
    .BVALIDs2mi  (BVALIDs52mi5),
    .BREADYmi2s  (BREADYmi52s5),

    //Slave interface signal

    //Write address channel
    //Master0
    .AWIDsi02mi    (AWIDsi02mi),
    .AWADDRsi02mi  (AWADDRsi02mi),
    .AWLENsi02mi   (AWLENsi02mi),
    .AWSIZEsi02mi  (AWSIZEsi02mi),
    .AWBURSTsi02mi (AWBURSTsi02mi),
    .AWLOCKsi02mi  (AWLOCKsi02mi),
    .AWCACHEsi02mi (AWCACHEsi02mi),
    .AWPROTsi02mi  (AWPROTsi02mi),

    //Master1
    .AWIDsi12mi    (AWIDsi12mi),
    .AWADDRsi12mi  (AWADDRsi12mi),
    .AWLENsi12mi   (AWLENsi12mi),
    .AWSIZEsi12mi  (AWSIZEsi12mi),
    .AWBURSTsi12mi (AWBURSTsi12mi),
    .AWLOCKsi12mi  (AWLOCKsi12mi),
    .AWCACHEsi12mi (AWCACHEsi12mi),
    .AWPROTsi12mi  (AWPROTsi12mi),

    //Master2
    .AWIDsi22mi    (AWIDsi22mi),
    .AWADDRsi22mi  (AWADDRsi22mi),
    .AWLENsi22mi   (AWLENsi22mi),
    .AWSIZEsi22mi  (AWSIZEsi22mi),
    .AWBURSTsi22mi (AWBURSTsi22mi),
    .AWLOCKsi22mi  (AWLOCKsi22mi),
    .AWCACHEsi22mi (AWCACHEsi22mi),
    .AWPROTsi22mi  (AWPROTsi22mi),

    //Master3
    .AWIDsi32mi    (AWIDsi32mi),
    .AWADDRsi32mi  (AWADDRsi32mi),
    .AWLENsi32mi   (AWLENsi32mi),
    .AWSIZEsi32mi  (AWSIZEsi32mi),
    .AWBURSTsi32mi (AWBURSTsi32mi),
    .AWLOCKsi32mi  (AWLOCKsi32mi),
    .AWCACHEsi32mi (AWCACHEsi32mi),
    .AWPROTsi32mi  (AWPROTsi32mi),

    //Master 0/1/2/3
    //.AWVALIDsi2mi  ({AWVALIDsi32mi[1], AWVALIDsi22mi[1], AWVALIDsi12mi[1], AWVALIDsi02mi[1]}),
    .AWVALIDsi2mi  (AWVALIDsi2mi5),

    .AWREADYmi2si  (AWREADYmi52si),

    //Write data channel
    //Master 0
    .WIDsi02mi   (WIDsi02mi),     
    .WDATAsi02mi (WDATAsi02mi),   
    .WSTRBsi02mi (WSTRBsi02mi),   

    //Master 1
    .WIDsi12mi   (WIDsi12mi),     
    .WDATAsi12mi (WDATAsi12mi),   
    .WSTRBsi12mi (WSTRBsi12mi),   

    //Master 2
    .WIDsi22mi   (WIDsi22mi),     
    .WDATAsi22mi (WDATAsi22mi),   
    .WSTRBsi22mi (WSTRBsi22mi),   

    //Master 3
    .WIDsi32mi   (WIDsi32mi),     
    .WDATAsi32mi (WDATAsi32mi),   
    .WSTRBsi32mi (WSTRBsi32mi),   

    //Master 0/1/2/3
    .WLASTsi2mi   ({WLASTsi32mi[5], WLASTsi22mi[5], WLASTsi12mi[5], WLASTsi02mi[5]}),
    .WVALIDsi2mi  ({WVALIDsi32mi[5], WVALIDsi22mi[5], WVALIDsi12mi[5], WVALIDsi02mi[5]}),

    //output 1port
    .WREADYmi2si  (WREADYmi52si),

    //Write response channel
    .BIDmi2si     (BIDmi52si),
    .BRESPmi2si   (BRESPmi52si),
    .BVALIDmi2si  (BVALIDmi52si),

    .BREADYsi2mi  ({BREADYsi32mi[5],BREADYsi22mi[5],BREADYsi12mi[5],BREADYsi02mi[5]})

    );
    
endmodule

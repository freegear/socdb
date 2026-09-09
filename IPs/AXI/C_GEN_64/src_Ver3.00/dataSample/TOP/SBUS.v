
module SBUS(

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
    BREADYmi52s5  ,

    //_______________________________________________________________

    //_______________________________________________________________
    //For Master 0
    //Read address channel
    ARIDm02si0    ,
    ARADDRm02si0  ,
    ARLENm02si0   ,
    ARSIZEm02si0  ,
    ARBURSTm02si0 ,
    ARLOCKm02si0  ,
    ARCACHEm02si0 ,
    ARPROTm02si0  ,

    ARVALIDm02si0 ,
    ARREADYsi02m0 ,

    //Read data channel
    RIDsi02m0     ,
    RRESPsi02m0   ,
    RDATAsi02m0   ,
    RLASTsi02m0   ,
    RVALIDsi02m0  ,
    RREADYm02si0  ,


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    ARIDm12si1    ,
    ARADDRm12si1  ,
    ARLENm12si1   ,
    ARSIZEm12si1  ,
    ARBURSTm12si1 ,
    ARLOCKm12si1  ,
    ARCACHEm12si1 ,
    ARPROTm12si1  ,

    ARVALIDm12si1 ,
    ARREADYsi12m1 ,

    //Read data channel
    RIDsi12m1     ,
    RRESPsi12m1   ,
    RDATAsi12m1   ,
    RLASTsi12m1   ,
    RVALIDsi12m1  ,
    RREADYm12si1  ,

    //_______________________________________________________________
    //For Master 2
    //Read address channel
    ARIDm22si2    ,
    ARADDRm22si2  ,
    ARLENm22si2   ,
    ARSIZEm22si2  ,
    ARBURSTm22si2 ,
    ARLOCKm22si2  ,
    ARCACHEm22si2 ,
    ARPROTm22si2  ,

    ARVALIDm22si2 ,
    ARREADYsi22m2 ,

    //Read data channel
    RIDsi22m2     ,
    RRESPsi22m2   ,
    RDATAsi22m2   ,
    RLASTsi22m2   ,
    RVALIDsi22m2  ,
    RREADYm22si2  ,


    //_______________________________________________________________
    //For Master 3
    //Read address channel
    ARIDm32si3    ,
    ARADDRm32si3  ,
    ARLENm32si3   ,
    ARSIZEm32si3  ,
    ARBURSTm32si3 ,
    ARLOCKm32si3  ,
    ARCACHEm32si3 ,
    ARPROTm32si3  ,

    ARVALIDm32si3 ,
    ARREADYsi32m3 ,

    //Read data channel
    RIDsi32m3     ,
    RRESPsi32m3   ,
    RDATAsi32m3   ,
    RLASTsi32m3   ,
    RVALIDsi32m3  ,
    RREADYm32si3  ,
    

 
    //_______________________________________________________________
    //For Slave 0
    //Read address channel
    ARIDmi02s0    ,
    ARADDRmi02s0  ,
    ARLENmi02s0   ,
    ARSIZEmi02s0  ,
    ARBURSTmi02s0 ,
    ARLOCKmi02s0  ,
    ARCACHEmi02s0 ,
    ARPROTmi02s0  ,

    ARVALIDmi02s0 ,
    ARREADYs02mi0 ,

    //Read data channel
    RIDs02mi0     ,
    RRESPs02mi0   ,
    RDATAs02mi0  ,
    RLASTs02mi0  ,
    RVALIDs02mi0  ,
    RREADYmi02s0  ,


    //_______________________________________________________________

    //For Slave 1
    //Read address channel
    ARIDmi12s1    ,
    ARADDRmi12s1  ,
    ARLENmi12s1   ,
    ARSIZEmi12s1  ,
    ARBURSTmi12s1 ,
    ARLOCKmi12s1  ,
    ARCACHEmi12s1 ,
    ARPROTmi12s1  ,

    ARVALIDmi12s1 ,
    ARREADYs12mi1 ,

    //Read data channel
    RIDs12mi1     ,
    RRESPs12mi1   ,
    RDATAs12mi1  ,
    RLASTs12mi1  ,
    RVALIDs12mi1  ,
    RREADYmi12s1  ,
    
    //_______________________________________________________________


    //For Slave 2
    //Read address channel
    ARIDmi22s2    ,
    ARADDRmi22s2  ,
    ARLENmi22s2   ,
    ARSIZEmi22s2  ,
    ARBURSTmi22s2 ,
    ARLOCKmi22s2  ,
    ARCACHEmi22s2 ,
    ARPROTmi22s2  ,

    ARVALIDmi22s2 ,
    ARREADYs22mi2 ,

    //Read data channel
    RIDs22mi2     ,
    RRESPs22mi2   ,
    RDATAs22mi2  ,
    RLASTs22mi2  ,
    RVALIDs22mi2  ,
    RREADYmi22s2  ,

    
    //_______________________________________________________________
    
    
    //For Slave 3
    //Read address channel
    ARIDmi32s3    ,
    ARADDRmi32s3  ,
    ARLENmi32s3   ,
    ARSIZEmi32s3  ,
    ARBURSTmi32s3 ,
    ARLOCKmi32s3  ,
    ARCACHEmi32s3 ,
    ARPROTmi32s3  ,

    ARVALIDmi32s3 ,
    ARREADYs32mi3 ,

    //Read data channel
    RIDs32mi3     ,
    RRESPs32mi3   ,
    RDATAs32mi3  ,
    RLASTs32mi3  ,
    RVALIDs32mi3  ,
    RREADYmi32s3  ,
    
    
    //_______________________________________________________________
    
    //For Slave 4
    //Read address channel
    ARIDmi42s4    ,
    ARADDRmi42s4  ,
    ARLENmi42s4   ,
    ARSIZEmi42s4  ,
    ARBURSTmi42s4 ,
    ARLOCKmi42s4  ,
    ARCACHEmi42s4 ,
    ARPROTmi42s4  ,

    ARVALIDmi42s4 ,
    ARREADYs42mi4 ,

    //Read data channel
    RIDs42mi4     ,
    RRESPs42mi4   ,
    RDATAs42mi4   ,    
    RLASTs42mi4   ,
    RVALIDs42mi4  ,
    RREADYmi42s4  ,
    
    //_______________________________________________________________
    
    
    //For Slave 5
    //Read address channel
    ARIDmi52s5    ,
    ARADDRmi52s5  ,
    ARLENmi52s5   ,
    ARSIZEmi52s5  ,
    ARBURSTmi52s5 ,
    ARLOCKmi52s5  ,
    ARCACHEmi52s5 ,
    ARPROTmi52s5  ,

    ARVALIDmi52s5 ,
    ARREADYs52mi5 ,

    //Read data channel
    RIDs52mi5     ,
    RRESPs52mi5   ,
    RDATAs52mi5   ,    
    RLASTs52mi5   ,
    RVALIDs52mi5  ,
    RREADYmi52s5  

    //_______________________________________________________________
);
`include "Def.v"
parameter SELMASTER_WID= 3;

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
    output   [(ID_WID+SELMASTER_WID-1):0]       AWIDmi02s0;    
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
    output   [(ID_WID+SELMASTER_WID-1):0]       WIDmi02s0;     
    output   [BUS_WID-1:0]      WDATAmi02s0;   
    output   [WSTRB_WID-1:0]    WSTRBmi02s0;   
    output   WLASTmi02s0;   
    output   WVALIDmi02s0;  
    input    WREADYs02mi0; 

    //Write response channel
    input   [(ID_WID+SELMASTER_WID-1):0]      BIDs02mi0;     
    input   [BRESP_WID-1:0]   BRESPs02mi0;   
    input   BVALIDs02mi0;  
    output  BREADYmi02s0;  

    
    // For slave 1
    // Write address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       AWIDmi12s1;    
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
    output   [(ID_WID+SELMASTER_WID-1):0]       WIDmi12s1;     
    output   [BUS_WID-1:0]      WDATAmi12s1;   
    output   [WSTRB_WID-1:0]    WSTRBmi12s1;   
    output   WLASTmi12s1;   
    output   WVALIDmi12s1;  
    input    WREADYs12mi1; 

    //Write response channel
    input   [(ID_WID+SELMASTER_WID-1):0]      BIDs12mi1;     
    input   [BRESP_WID-1:0]   BRESPs12mi1;   
    input   BVALIDs12mi1;  
    output  BREADYmi12s1;  



    // For Slave 2
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       AWIDmi22s2;    
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
    output   [(ID_WID+SELMASTER_WID-1):0]       WIDmi22s2;     
    output   [BUS_WID-1:0]      WDATAmi22s2;   
    output   [WSTRB_WID-1:0]    WSTRBmi22s2;   
    output   WLASTmi22s2;   
    output   WVALIDmi22s2;  
    input    WREADYs22mi2; 

    //Write response channel
    input   [(ID_WID+SELMASTER_WID-1):0]      BIDs22mi2;     
    input   [BRESP_WID-1:0]   BRESPs22mi2;   
    input   BVALIDs22mi2;  
    output  BREADYmi22s2;  


    // For slave 3
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       AWIDmi32s3;    
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
    output   [(ID_WID+SELMASTER_WID-1):0]       WIDmi32s3;     
    output   [BUS_WID-1:0]      WDATAmi32s3;   
    output   [WSTRB_WID-1:0]    WSTRBmi32s3;   
    output   WLASTmi32s3;   
    output   WVALIDmi32s3;  
    input    WREADYs32mi3; 

    //Write response channel
    input   [(ID_WID+SELMASTER_WID-1):0]      BIDs32mi3;     
    input   [BRESP_WID-1:0]   BRESPs32mi3;   
    input   BVALIDs32mi3;  
    output  BREADYmi32s3;  


    // For slave 4
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       AWIDmi42s4;    
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
    output   [(ID_WID+SELMASTER_WID-1):0]       WIDmi42s4;     
    output   [BUS_WID-1:0]      WDATAmi42s4;   
    output   [WSTRB_WID-1:0]    WSTRBmi42s4;   
    output   WLASTmi42s4;   
    output   WVALIDmi42s4;  
    input    WREADYs42mi4; 

    //Write response channel
    input   [(ID_WID+SELMASTER_WID-1):0]      BIDs42mi4;     
    input   [BRESP_WID-1:0]   BRESPs42mi4;   
    input   BVALIDs42mi4;  
    output  BREADYmi42s4;  



    // For slave 5
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       AWIDmi52s5;    
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
    output   [(ID_WID+SELMASTER_WID-1):0]       WIDmi52s5;     
    output   [BUS_WID-1:0]      WDATAmi52s5;   
    output   [WSTRB_WID-1:0]    WSTRBmi52s5;   
    output   WLASTmi52s5;   
    output   WVALIDmi52s5;  
    input    WREADYs52mi5; 

    //Write response channel
    input   [(ID_WID+SELMASTER_WID-1):0]      BIDs52mi5;     
    input   [BRESP_WID-1:0]   BRESPs52mi5;   
    input   BVALIDs52mi5;  
    output  BREADYmi52s5;  

    //_______________________________________________________________
    //For Master 0
    //Read address channel
    input   [ID_WID-1:0]       ARIDm02si0;    
    input   [ADDR_WID-1:0]     ARADDRm02si0;
    input   [ARLEN_WID-1:0]    ARLENm02si0;
    input   [ARSIZE_WID-1:0]   ARSIZEm02si0;  
    input   [ARBURST_WID-1:0]  ARBURSTm02si0; 
    input   [ARLOCK_WID-1:0]   ARLOCKm02si0;  
    input   [ARCACHE_WID-1:0]  ARCACHEm02si0; 
    input   [ARPROT_WID-1:0]   ARPROTm02si0;  

    input   ARVALIDm02si0; 
    output  ARREADYsi02m0; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi02m0;     
    output   [BRESP_WID-1:0]   RRESPsi02m0;   
    output   [BUS_WID-1:0]     RDATAsi02m0;
    output   RLASTsi02m0;
    output   RVALIDsi02m0;  
    input    RREADYm02si0;  


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    input   [ID_WID-1:0]       ARIDm12si1;    
    input   [ADDR_WID-1:0]     ARADDRm12si1;
    input   [ARLEN_WID-1:0]    ARLENm12si1;
    input   [ARSIZE_WID-1:0]   ARSIZEm12si1;  
    input   [ARBURST_WID-1:0]  ARBURSTm12si1; 
    input   [ARLOCK_WID-1:0]   ARLOCKm12si1;  
    input   [ARCACHE_WID-1:0]  ARCACHEm12si1; 
    input   [ARPROT_WID-1:0]   ARPROTm12si1;  

    input   ARVALIDm12si1; 
    output  ARREADYsi12m1; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi12m1;     
    output   [BRESP_WID-1:0]   RRESPsi12m1;   
    output   [BUS_WID-1:0]     RDATAsi12m1;
    output   RLASTsi12m1;
    output   RVALIDsi12m1;  
    input    RREADYm12si1;  


    //_______________________________________________________________
    //For Master 2
    //Read address channel
    input   [ID_WID-1:0]       ARIDm22si2;    
    input   [ADDR_WID-1:0]     ARADDRm22si2;
    input   [ARLEN_WID-1:0]    ARLENm22si2;
    input   [ARSIZE_WID-1:0]   ARSIZEm22si2;  
    input   [ARBURST_WID-1:0]  ARBURSTm22si2; 
    input   [ARLOCK_WID-1:0]   ARLOCKm22si2;  
    input   [ARCACHE_WID-1:0]  ARCACHEm22si2; 
    input   [ARPROT_WID-1:0]   ARPROTm22si2;  

    input   ARVALIDm22si2; 
    output  ARREADYsi22m2; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi22m2;     
    output   [BRESP_WID-1:0]   RRESPsi22m2;   
    output   [BUS_WID-1:0]     RDATAsi22m2;
    output   RLASTsi22m2;
    output   RVALIDsi22m2;  
    input    RREADYm22si2;  


    //_______________________________________________________________
    //For Master 3
    //Read address channel
    input   [ID_WID-1:0]       ARIDm32si3;    
    input   [ADDR_WID-1:0]     ARADDRm32si3;
    input   [ARLEN_WID-1:0]    ARLENm32si3;
    input   [ARSIZE_WID-1:0]   ARSIZEm32si3;  
    input   [ARBURST_WID-1:0]  ARBURSTm32si3; 
    input   [ARLOCK_WID-1:0]   ARLOCKm32si3;  
    input   [ARCACHE_WID-1:0]  ARCACHEm32si3; 
    input   [ARPROT_WID-1:0]   ARPROTm32si3;  

    input   ARVALIDm32si3; 
    output  ARREADYsi32m3; 

    //Read data channel
    output   [ID_WID-1:0]      RIDsi32m3;     
    output   [BRESP_WID-1:0]   RRESPsi32m3;   
    output   [BUS_WID-1:0]     RDATAsi32m3;
    output   RLASTsi32m3;
    output   RVALIDsi32m3;  
    input    RREADYm32si3;  



    //_______________________________________________________________
    // For slave 0
    // Read address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi02s0;    
    output   [ADDR_WID-1:0]     ARADDRmi02s0;
    output   [ARLEN_WID-1:0]    ARLENmi02s0;
    output   [ARSIZE_WID-1:0]   ARSIZEmi02s0;  
    output   [ARBURST_WID-1:0]  ARBURSTmi02s0; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi02s0;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi02s0; 
    output   [ARPROT_WID-1:0]   ARPROTmi02s0;  

    output   ARVALIDmi02s0; 
    input    ARREADYs02mi0; 
    

    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs02mi0;     
    input   [RRESP_WID-1:0]   RRESPs02mi0;   
    input   [BUS_WID-1:0]RDATAs02mi0;  
    input   RLASTs02mi0;  
    input   RVALIDs02mi0;  
    output  RREADYmi02s0;  

    
    // For slave 1
    // Read address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi12s1;    
    output   [ADDR_WID-1:0]     ARADDRmi12s1;
    output   [ARLEN_WID-1:0]    ARLENmi12s1;
    output   [ARSIZE_WID-1:0]   ARSIZEmi12s1;  
    output   [ARBURST_WID-1:0]  ARBURSTmi12s1; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi12s1;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi12s1; 
    output   [ARPROT_WID-1:0]   ARPROTmi12s1;  

    output   ARVALIDmi12s1; 
    input    ARREADYs12mi1; 
    
    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs12mi1;     
    input   [RRESP_WID-1:0]   RRESPs12mi1;   
    input   [BUS_WID-1:0]RDATAs12mi1;  
    input   RLASTs12mi1;  
    input   RVALIDs12mi1;  
    output  RREADYmi12s1;  



    // For Slave 2
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi22s2;    
    output   [ADDR_WID-1:0]     ARADDRmi22s2;
    output   [ARLEN_WID-1:0]    ARLENmi22s2;
    output   [ARSIZE_WID-1:0]   ARSIZEmi22s2;  
    output   [ARBURST_WID-1:0]  ARBURSTmi22s2; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi22s2;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi22s2; 
    output   [ARPROT_WID-1:0]   ARPROTmi22s2;  

    output   ARVALIDmi22s2; 
    input    ARREADYs22mi2; 
    
    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs22mi2;     
    input   [RRESP_WID-1:0]   RRESPs22mi2;   
    input   [BUS_WID-1:0]RDATAs22mi2;  
    input   RLASTs22mi2;  
    input   RVALIDs22mi2;  
    output  RREADYmi22s2;  


    // For slave 3
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi32s3;    
    output   [ADDR_WID-1:0]     ARADDRmi32s3;
    output   [ARLEN_WID-1:0]    ARLENmi32s3;
    output   [ARSIZE_WID-1:0]   ARSIZEmi32s3;  
    output   [ARBURST_WID-1:0]  ARBURSTmi32s3; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi32s3;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi32s3; 
    output   [ARPROT_WID-1:0]   ARPROTmi32s3;  

    output   ARVALIDmi32s3; 
    input    ARREADYs32mi3; 
    
    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs32mi3;     
    input   [RRESP_WID-1:0]   RRESPs32mi3;   
    input   [BUS_WID-1:0]RDATAs32mi3;  
    input   RLASTs32mi3;  
    input   RVALIDs32mi3;  
    output  RREADYmi32s3;  


    // For slave 4
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi42s4;    
    output   [ADDR_WID-1:0]     ARADDRmi42s4;
    output   [ARLEN_WID-1:0]    ARLENmi42s4;
    output   [ARSIZE_WID-1:0]   ARSIZEmi42s4;  
    output   [ARBURST_WID-1:0]  ARBURSTmi42s4; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi42s4;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi42s4; 
    output   [ARPROT_WID-1:0]   ARPROTmi42s4;  

    output   ARVALIDmi42s4; 
    input    ARREADYs42mi4; 
    
    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs42mi4;     
    input   [RRESP_WID-1:0]   RRESPs42mi4;   
    input   [BUS_WID-1:0]RDATAs42mi4;  
    input   RLASTs42mi4;  
    input   RVALIDs42mi4;  
    output  RREADYmi42s4;  

    // For slave 5
    // Wriet address channel
    output   [(ID_WID+SELMASTER_WID-1):0]       ARIDmi52s5;    
    output   [ADDR_WID-1:0]     ARADDRmi52s5;
    output   [ARLEN_WID-1:0]    ARLENmi52s5;
    output   [ARSIZE_WID-1:0]   ARSIZEmi52s5;  
    output   [ARBURST_WID-1:0]  ARBURSTmi52s5; 
    output   [ARLOCK_WID-1:0]   ARLOCKmi52s5;  
    output   [ARCACHE_WID-1:0]  ARCACHEmi52s5; 
    output   [ARPROT_WID-1:0]   ARPROTmi52s5;  

    output   ARVALIDmi52s5; 
    input    ARREADYs52mi5; 
    
    //Read data channel
    input   [(ID_WID+SELMASTER_WID-1):0]      RIDs52mi5;     
    input   [RRESP_WID-1:0]   RRESPs52mi5;   
    input   [BUS_WID-1:0]RDATAs52mi5;  
    input   RLASTs52mi5;  
    input   RVALIDs52mi5;  
    output  RREADYmi52s5;  

    wire    ReadIntEmptyWrmi02Rdmi0;
    wire    ReadIntEmptyWrmi12Rdmi1;
    wire    ReadIntEmptyWrmi22Rdmi2;
    wire    ReadIntEmptyWrmi32Rdmi3;
    wire    ReadIntEmptyWrmi42Rdmi4;
    wire    ReadIntEmptyWrmi52Rdmi5;

    wire    DataCntEmptyRdmi02Wrmi0;
    wire    DataCntEmptyRdmi12Wrmi1;
    wire    DataCntEmptyRdmi22Wrmi2;
    wire    DataCntEmptyRdmi32Wrmi3;
    wire    DataCntEmptyRdmi42Wrmi4;
    wire    DataCntEmptyRdmi52Wrmi5;

    wire   [SELMASTER_WID-1:0]CtlDataWrite2Lock0;
    wire   [SELMASTER_WID-1:0]CtlDataWrite2Lock1;
    wire   [SELMASTER_WID-1:0]CtlDataWrite2Lock2;
    wire   [SELMASTER_WID-1:0]CtlDataWrite2Lock3;
    wire   [SELMASTER_WID-1:0]CtlDataWrite2Lock4;
    wire   [SELMASTER_WID-1:0]CtlDataWrite2Lock5;

    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock0;     
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock1;     
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock2;     
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock3;     
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock4;     
    wire   [SELMASTER_WID-1:0]CtlDataRead2Lock5;     
    
    wire   Lock2wrmi0;
    wire   Lock2wrmi1;
    wire   Lock2wrmi2;
    wire   Lock2wrmi3;
    wire   Lock2wrmi4;
    wire   Lock2wrmi5;

    wire   UnLock2wrmi0;
    wire   UnLock2wrmi1;
    wire   UnLock2wrmi2;
    wire   UnLock2wrmi3;
    wire   UnLock2wrmi4;
    wire   UnLock2wrmi5;

    wire   UnLock2rdmi0;
    wire   UnLock2rdmi1;
    wire   UnLock2rdmi2;
    wire   UnLock2rdmi3;
    wire   UnLock2rdmi4;
    wire   UnLock2rdmi5;

    wire    Lock2rdmi0 ;
    wire    Lock2rdmi1 ;
    wire    Lock2rdmi2 ;
    wire    Lock2rdmi3 ;
    wire    Lock2rdmi4 ;
    wire    Lock2rdmi5 ;

    wire    [SELMASTER_WID-1:0]LockPort2wrmi0;
    wire    [SELMASTER_WID-1:0]LockPort2wrmi1;
    wire    [SELMASTER_WID-1:0]LockPort2wrmi2;
    wire    [SELMASTER_WID-1:0]LockPort2wrmi3;
    wire    [SELMASTER_WID-1:0]LockPort2wrmi4;
    wire    [SELMASTER_WID-1:0]LockPort2wrmi5;

    wire    [SELMASTER_WID-1:0]LockPort2rdmi0;
    wire    [SELMASTER_WID-1:0]LockPort2rdmi1;
    wire    [SELMASTER_WID-1:0]LockPort2rdmi2;
    wire    [SELMASTER_WID-1:0]LockPort2rdmi3;
    wire    [SELMASTER_WID-1:0]LockPort2rdmi4;
    wire    [SELMASTER_WID-1:0]LockPort2rdmi5;

ReadChannel 
U0ReadChannel (


    //_______________________________________________________________
    //For Master 0
    //Read address channel
    ARIDm02si0    ,
    ARADDRm02si0  ,
    ARLENm02si0   ,
    ARSIZEm02si0  ,
    ARBURSTm02si0 ,
    ARLOCKm02si0  ,
    ARCACHEm02si0 ,
    ARPROTm02si0  ,

    ARVALIDm02si0 ,
    ARREADYsi02m0 ,

    //Read data channel
    RIDsi02m0     ,
    RRESPsi02m0   ,
    RDATAsi02m0   ,
    RLASTsi02m0   ,
    RVALIDsi02m0  ,
    RREADYm02si0  ,


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    ARIDm12si1    ,
    ARADDRm12si1  ,
    ARLENm12si1   ,
    ARSIZEm12si1  ,
    ARBURSTm12si1 ,
    ARLOCKm12si1  ,
    ARCACHEm12si1 ,
    ARPROTm12si1  ,

    ARVALIDm12si1 ,
    ARREADYsi12m1 ,

    //Read data channel
    RIDsi12m1     ,
    RRESPsi12m1   ,
    RDATAsi12m1   ,
    RLASTsi12m1   ,
    RVALIDsi12m1  ,
    RREADYm12si1  ,

    //_______________________________________________________________
    //For Master 2
    //Read address channel
    ARIDm22si2    ,
    ARADDRm22si2  ,
    ARLENm22si2   ,
    ARSIZEm22si2  ,
    ARBURSTm22si2 ,
    ARLOCKm22si2  ,
    ARCACHEm22si2 ,
    ARPROTm22si2  ,

    ARVALIDm22si2 ,
    ARREADYsi22m2 ,

    //Read data channel
    RIDsi22m2     ,
    RRESPsi22m2   ,
    RDATAsi22m2   ,
    RLASTsi22m2   ,
    RVALIDsi22m2  ,
    RREADYm22si2  ,


    //_______________________________________________________________
    //For Master 3
    //Read address channel
    ARIDm32si3    ,
    ARADDRm32si3  ,
    ARLENm32si3   ,
    ARSIZEm32si3  ,
    ARBURSTm32si3 ,
    ARLOCKm32si3  ,
    ARCACHEm32si3 ,
    ARPROTm32si3  ,

    ARVALIDm32si3 ,
    ARREADYsi32m3 ,

    //Read data channel
    RIDsi32m3     ,
    RRESPsi32m3   ,
    RDATAsi32m3   ,
    RLASTsi32m3   ,
    RVALIDsi32m3  ,
    RREADYm32si3  ,
    

 
    //_______________________________________________________________
    //For Slave 0
    //Read address channel
    ARIDmi02s0    ,
    ARADDRmi02s0  ,
    ARLENmi02s0   ,
    ARSIZEmi02s0  ,
    ARBURSTmi02s0 ,
    ARLOCKmi02s0  ,
    ARCACHEmi02s0 ,
    ARPROTmi02s0  ,

    ARVALIDmi02s0 ,
    ARREADYs02mi0 ,

    //Read data channel
    RIDs02mi0     ,
    RRESPs02mi0   ,
    RDATAs02mi0  ,
    RLASTs02mi0  ,
    RVALIDs02mi0  ,
    RREADYmi02s0  ,


    //_______________________________________________________________

    //For Slave 1
    //Read address channel
    ARIDmi12s1    ,
    ARADDRmi12s1  ,
    ARLENmi12s1   ,
    ARSIZEmi12s1  ,
    ARBURSTmi12s1 ,
    ARLOCKmi12s1  ,
    ARCACHEmi12s1 ,
    ARPROTmi12s1  ,

    ARVALIDmi12s1 ,
    ARREADYs12mi1 ,

    //Read data channel
    RIDs12mi1     ,
    RRESPs12mi1   ,
    RDATAs12mi1  ,
    RLASTs12mi1  ,
    RVALIDs12mi1  ,
    RREADYmi12s1  ,
    
    //_______________________________________________________________


    //For Slave 2
    //Read address channel
    ARIDmi22s2    ,
    ARADDRmi22s2  ,
    ARLENmi22s2   ,
    ARSIZEmi22s2  ,
    ARBURSTmi22s2 ,
    ARLOCKmi22s2  ,
    ARCACHEmi22s2 ,
    ARPROTmi22s2  ,

    ARVALIDmi22s2 ,
    ARREADYs22mi2 ,

    //Read data channel
    RIDs22mi2     ,
    RRESPs22mi2   ,
    RDATAs22mi2  ,
    RLASTs22mi2  ,
    RVALIDs22mi2  ,
    RREADYmi22s2  ,

    
    //_______________________________________________________________
    
    
    //For Slave 3
    //Read address channel
    ARIDmi32s3    ,
    ARADDRmi32s3  ,
    ARLENmi32s3   ,
    ARSIZEmi32s3  ,
    ARBURSTmi32s3 ,
    ARLOCKmi32s3  ,
    ARCACHEmi32s3 ,
    ARPROTmi32s3  ,

    ARVALIDmi32s3 ,
    ARREADYs32mi3 ,

    //Read data channel
    RIDs32mi3     ,
    RRESPs32mi3   ,
    RDATAs32mi3  ,
    RLASTs32mi3  ,
    RVALIDs32mi3  ,
    RREADYmi32s3  ,
    
    
    //_______________________________________________________________
    
    //For Slave 4
    //Read address channel
    ARIDmi42s4    ,
    ARADDRmi42s4  ,
    ARLENmi42s4   ,
    ARSIZEmi42s4  ,
    ARBURSTmi42s4 ,
    ARLOCKmi42s4  ,
    ARCACHEmi42s4 ,
    ARPROTmi42s4  ,

    ARVALIDmi42s4 ,
    ARREADYs42mi4 ,

    //Read data channel
    RIDs42mi4     ,
    RRESPs42mi4   ,
    RDATAs42mi4   ,    
    RLASTs42mi4   ,
    RVALIDs42mi4  ,
    RREADYmi42s4  ,
    
    //_______________________________________________________________
    
    
    //For Slave 5
    //Read address channel
    ARIDmi52s5    ,
    ARADDRmi52s5  ,
    ARLENmi52s5   ,
    ARSIZEmi52s5  ,
    ARBURSTmi52s5 ,
    ARLOCKmi52s5  ,
    ARCACHEmi52s5 ,
    ARPROTmi52s5  ,

    ARVALIDmi52s5 ,
    ARREADYs52mi5 ,

    //Read data channel
    RIDs52mi5     ,
    RRESPs52mi5   ,
    RDATAs52mi5   ,    
    RLASTs52mi5   ,
    RVALIDs52mi5  ,
    RREADYmi52s5  , 

    //Lock signal
    Lock2rdmi0  ,
    Lock2rdmi1  ,
    Lock2rdmi2  ,
    Lock2rdmi3  ,
    Lock2rdmi4  ,
    Lock2rdmi5  ,

    Lock2wrmi0  ,
    Lock2wrmi1  ,
    Lock2wrmi2  ,
    Lock2wrmi3  ,
    Lock2wrmi4  ,
    Lock2wrmi5  ,

    UnLock2rdmi0 ,
    UnLock2rdmi1 ,
    UnLock2rdmi2 ,
    UnLock2rdmi3 ,
    UnLock2rdmi4 ,
    UnLock2rdmi5 ,

    UnLock2wrmi0 ,
    UnLock2wrmi1 ,
    UnLock2wrmi2 ,
    UnLock2wrmi3 ,
    UnLock2wrmi4 ,
    UnLock2wrmi5 ,

    AWVALIDmi02s0,
    AWVALIDmi12s1,
    AWVALIDmi22s2,
    AWVALIDmi32s3,
    AWVALIDmi42s4,
    AWVALIDmi52s5,

    LockPort2rdmi0,
    LockPort2rdmi1,
    LockPort2rdmi2,
    LockPort2rdmi3,
    LockPort2rdmi4,
    LockPort2rdmi5,

    ReadIntEmptyWrmi02Rdmi0,
    ReadIntEmptyWrmi12Rdmi1,
    ReadIntEmptyWrmi22Rdmi2,
    ReadIntEmptyWrmi32Rdmi3,
    ReadIntEmptyWrmi42Rdmi4,
    ReadIntEmptyWrmi52Rdmi5,

    DataCntEmptyRdmi02Wrmi0,
    DataCntEmptyRdmi12Wrmi1,
    DataCntEmptyRdmi22Wrmi2,
    DataCntEmptyRdmi32Wrmi3,
    DataCntEmptyRdmi42Wrmi4,
    DataCntEmptyRdmi52Wrmi5,

    CtlDataRead2Lock0      ,
    CtlDataRead2Lock1      ,
    CtlDataRead2Lock2      ,
    CtlDataRead2Lock3      ,
    CtlDataRead2Lock4      ,
    CtlDataRead2Lock5      ,

    ACLK    ,
    ARESETn 

    //_______________________________________________________________
);



WriteChannel 
U0WriteChannel(


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
    BREADYmi52s5  ,
    
    //Lock Access
    Lock2wrmi0,
    Lock2wrmi1,
    Lock2wrmi2,
    Lock2wrmi3,
    Lock2wrmi4,
    Lock2wrmi5,

    Lock2rdmi0,
    Lock2rdmi1,
    Lock2rdmi2,
    Lock2rdmi3,
    Lock2rdmi4,
    Lock2rdmi5,
    
    UnLock2wrmi0,
    UnLock2wrmi1,
    UnLock2wrmi2,
    UnLock2wrmi3,
    UnLock2wrmi4,
    UnLock2wrmi5,

    UnLock2rdmi0,
    UnLock2rdmi1,
    UnLock2rdmi2,
    UnLock2rdmi3,
    UnLock2rdmi4,
    UnLock2rdmi5,

    ARVALIDmi02s0,
    ARVALIDmi12s1,
    ARVALIDmi22s2,
    ARVALIDmi32s3,
    ARVALIDmi42s4,
    ARVALIDmi52s5,
    
    LockPort2wrmi0,
    LockPort2wrmi1,
    LockPort2wrmi2,
    LockPort2wrmi3,
    LockPort2wrmi4,
    LockPort2wrmi5,

    ReadIntEmptyWrmi02Rdmi0,
    ReadIntEmptyWrmi12Rdmi1,
    ReadIntEmptyWrmi22Rdmi2,
    ReadIntEmptyWrmi32Rdmi3,
    ReadIntEmptyWrmi42Rdmi4,
    ReadIntEmptyWrmi52Rdmi5,

    DataCntEmptyRdmi02Wrmi0,
    DataCntEmptyRdmi12Wrmi1,
    DataCntEmptyRdmi22Wrmi2,
    DataCntEmptyRdmi32Wrmi3,
    DataCntEmptyRdmi42Wrmi4,
    DataCntEmptyRdmi52Wrmi5,

    CtlDataWrite2Lock0,
    CtlDataWrite2Lock1,
    CtlDataWrite2Lock2,
    CtlDataWrite2Lock3,
    CtlDataWrite2Lock4,
    CtlDataWrite2Lock5,


    //_______________________________________________________________

    ACLK    ,
    ARESETn 
);

//For Lock control 
//_______________________________________________________________

assign  LockPort2wrmi0 = CtlDataRead2Lock0; 
assign  LockPort2rdmi0 = CtlDataWrite2Lock0;

assign  LockPort2wrmi1 = CtlDataRead2Lock1; 
assign  LockPort2rdmi1 = CtlDataWrite2Lock1;

assign  LockPort2wrmi2 = CtlDataRead2Lock2; 
assign  LockPort2rdmi2 = CtlDataWrite2Lock2;

assign  LockPort2wrmi3 = CtlDataRead2Lock3; 
assign  LockPort2rdmi3 = CtlDataWrite2Lock3;

assign  LockPort2wrmi4 = CtlDataRead2Lock4; 
assign  LockPort2rdmi4 = CtlDataWrite2Lock4;

assign  LockPort2wrmi5 = CtlDataRead2Lock5; 
assign  LockPort2rdmi5 = CtlDataWrite2Lock5;


endmodule

    
    wire [MASTERID_WID-1:0] WIDsi2mi;     
    wire [BUS_WID-1:0] WDATAsi2mi;   
    wire [WSTRB_WID-1:0]WSTRBsi2mi;   
    wire [SLAVE_WID  :0] CtlData2writech; 

//STATE00_START
    //SLAVE ??
    assign  AWIDsi2mi?? = AWIDm2si;    
    assign  AWADDRsi2mi?? = AWADDRm2si;  
    assign  AWLENsi2mi?? = AWLENm2si;   
    assign  AWSIZEsi2mi?? = AWSIZEm2si;  
    assign  AWBURSTsi2mi?? = AWBURSTm2si; 
    assign  AWLOCKsi2mi?? = AWLOCKm2si;  
    assign  AWCACHEsi2mi?? = AWCACHEm2si; 
    assign  AWPROTsi2mi?? = AWPROTm2si;  

    assign  WIDsi2mi?? = WIDm2si;
    assign  WDATAsi2mi?? = WDATAm2si;   
    assign  WSTRBsi2mi?? = WSTRBm2si;

//STATE_END

//Write address channel
//____________________________________________________________________


//AWVALID MUX 
reg [SLAVE_NUM-1:0]AWVALIDsi2mi; 


//MUX_GEN_START

//Define_START
00
CtlData2writech 
AWVALIDm2si 
SLAVE_WID
AWVALIDsi2mi
//END

//MUX_END

reg AWREADYsi2m;

//AWREADY Demux
always @(CtlData2writech or AWREADYmi2si)
begin

    if(CtlData2writech[SLAVE_WID]) //Mux enable bit
    begin
        case(CtlData2writech[SLAVE_WID-1:0])
            //synopsys parallel_case full_case
//STATE00_START
            SLAVE_WID'd??: AWREADYsi2m <= AWREADYmi2si[??];
//STATE00_END
            default:
                AWREADYsi2m <= 1'b0;
        endcase
    end
    else
        AWREADYsi2m <= 1'b0;
end

reg [SLAVE_WID-1:0] SlaveNum;

//ADDRESS Decoder
//____________________________________________________________________

//ADDRDECODER_GEN_START
AWADDRm2si
//STATE_END

//____________________________________________________________________

// Write data channel ////////////////////////////////////////////////
//____________________________________________________________________

//WVALID MUX 
wire  [SLAVE_WID  :0] CtlData2datach;
reg   [SLAVE_NUM-1:0] WVALIDsi2mi;  
reg   [SLAVE_NUM-1:0] WLASTsi2mi;   

//MUX_GEN_START

//Define_START
00
CtlData2datach
WVALIDm2si 
SLAVE_WID
WVALIDsi2mi
//END
//MUX_END

//MUX_GEN_START
//Define_START
00
CtlData2datach
WLASTm2si 
SLAVE_WID
WLASTsi2mi
//END
//MUX_END

//____________________________________________________________________
reg WREADYsi2m;

//WREADY Demux
always @(CtlData2datach or WREADYmi2si)
begin
    if(CtlData2datach[SLAVE_WID]) //MUX enalbe bit
    begin
        case(CtlData2datach[SLAVE_WID-1:0])
            //synopsys parallel_case full_case
//STATE01_START
            SLAVE_WID'd??: WREADYsi2m <= WREADYmi2si[??];
//STATE01_END
            default:
                WREADYsi2m <= 1'b0;
        endcase
    end
    else
        WREADYsi2m <= 1'b0;
end
//____________________________________________________________________



//Write response channel
//____________________________________________________________________

reg   [MASTERID_WID-1:0]      BIDsi2m;     
reg   [BRESP_WID-1:0]   BRESPsi2m;   
reg   BVALIDsi2m;  
reg   [SLAVE_NUM-1:0]   BREADYsi2mi;    


//Arbiter
//_______________________________________________________________
reg   [SLAVE_WID-1:0] CtlData2resch;
//ARBITER_GEN_START
//Define_START
00
ACLK
ARESETn
CtlData2resch
BVALIDmi2si
//END
//ARBITER_GEN_END

//Demux reaponse channel
//MUX_GEN_START

//Define_START
01
CtlData2resch 
BREADYm2si 
SLAVE_WID
BREADYsi2mi
//END
//MUX_END

//Demux reaponse channel

always @(
//STATE02_START
         BIDmi??2si or
//STATE02_END
        CtlData2resch 
        )
begin
    case(CtlData2resch)
//STATE03_START
        SLAVE_WID'd??: BIDsi2m      <= BIDmi??2si;     
//STATE03_END
//Syn Warning
        default:       BIDsi2m      <= 0;
    endcase
end

always @(
//STATE04_START
         BRESPmi??2si   or
//STATE04_END
         CtlData2resch 
        )
begin
    case(CtlData2resch)
//STATE05_START
        SLAVE_WID'd??: BRESPsi2m   <= BRESPmi??2si;     
//STATE05_END
//Syn Warning
        default:       BRESPsi2m   <= 0;
    endcase
end


always @(CtlData2resch or
         BVALIDmi2si    
        )
begin
    case(CtlData2resch)
//STATE06_START
        SLAVE_WID'd??: BVALIDsi2m   <= BVALIDmi2si[??];     
//STATE06_END
//Syn Warning
        default:       BVALIDsi2m   <= 0;
    endcase
end

WRCH_?NAME?_PermitCtl
    U0PermitCtl(

    .ACLK       (ACLK)      ,
    .ARESETn    (ARESETn)   ,
    .SlaveNum   (SlaveNum)  ,

    .SID       (AWIDm2si),
    .AREADY    (AWREADYsi2m),
    .AVALID    (AWVALIDm2si),    

    .WID       (WIDm2si),
    .WREADY    (WREADYsi2m),
    .WVALID    (WVALIDm2si),
    .WLAST     (WLASTm2si),
    /*
    .WREADY     (1'b0),
    .WVALID     (1'b0),
    .WLAST      (1'b0),
    */

    .LID       (BIDsi2m),
    .LAST      (BVALIDsi2m),
    .READY     (BREADYm2si),
    .RVALID    (1'b1),

    .CtlData2datach  (CtlData2datach),
    .CtlData2writech (CtlData2writech) 

    );
endmodule
//Code_END

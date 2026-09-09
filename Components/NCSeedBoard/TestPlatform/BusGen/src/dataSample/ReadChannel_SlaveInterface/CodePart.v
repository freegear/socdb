
    wire [SLAVE_WID :0] CtlData2writech;

//STATE00_START
    //SLAVE ??
    assign  ARIDsi2mi?? = ARIDm2si;    
    assign  ARADDRsi2mi?? = ARADDRm2si;  
    assign  ARLENsi2mi?? = ARLENm2si;   
    assign  ARSIZEsi2mi?? = ARSIZEm2si;  
    assign  ARBURSTsi2mi?? = ARBURSTm2si; 
    assign  ARLOCKsi2mi?? = ARLOCKm2si;  
    assign  ARCACHEsi2mi?? = ARCACHEm2si; 
    assign  ARPROTsi2mi?? = ARPROTm2si;  

//STATE_END


//Read address channel
//____________________________________________________________________

//ARVALID MUX 
reg [SLAVE_NUM-1:0]ARVALIDsi2mi; 

//MUX_GEN_START
//Define_START
00
CtlData2writech 
ARVALIDm2si 
SLAVE_WID
ARVALIDsi2mi
//END
//MUX_END


reg ARREADYsi2m;

//ARREADY Demux
always @(CtlData2writech or ARREADYmi2si)
begin
    if(CtlData2writech[SLAVE_WID])
    begin
        case(CtlData2writech[SLAVE_WID-1:0])
        // synopsys parallel_case full_case
//STATE00_START
            ?WID?'d??:   ARREADYsi2m <= ARREADYmi2si[??]; 
//STATE_END
            default:
                ARREADYsi2m <= 1'b0;
        endcase
    end
    else
        ARREADYsi2m <= 1'b0;
end

reg [SLAVE_WID-1:0] SlaveNum;

//ADDRESS Decoder
//____________________________________________________________________

//ADDRDECODER_GEN_START
ARADDRm2si
//STATE_END

//____________________________________________________________________

//Read data channel
//____________________________________________________________________

reg   [MASTERID_WID-1:0]RIDsi2m;     
reg   [RRESP_WID-1:0]   RRESPsi2m;   
reg   RVALIDsi2m;  
reg   RLASTsi2m;
reg   [SLAVE_NUM-1:0]   RREADYsi2mi;    
reg   [BUS_WID-1:0]     RDATAsi2m;

//Data Arbiter
reg   [SLAVE_WID-1:0] CtlData2readch; 

//ARBITER_GEN_START
//Define_START
00
ACLK
ARESETn
CtlData2readch
RVALIDmi2si
//END
//ARBITER_GEN_END


//MUX_GEN_START
//Define_START
01
CtlData2readch[SLAVE_WID-1:0] 
RREADYm2si 
SLAVE_WID
RREADYsi2mi
//END
//MUX_END


    always @(//1
//STATE01_START
             RRESPmi??2si or    
//STATE_END
             CtlData2readch
            )
    begin
        case(CtlData2readch[SLAVE_WID-1:0])
            // synopsys parallel_case full_case
//STATE02_START
            ?WID?'d??:   RRESPsi2m  <= RRESPmi??2si;
//STATE_END
            default:     RRESPsi2m  <= 0;
        endcase
    end


    always @(//2
//STATE03_START
             RIDmi??2si or    
//STATE_END
             CtlData2readch
            )
    begin
        case(CtlData2readch[SLAVE_WID-1:0])
            // synopsys parallel_case full_case
//STATE04_START
            ?WID?'d??:   RIDsi2m  <= RIDmi??2si;
//STATE_END
            default:     RIDsi2m  <= 0;
        endcase
    end


    always @(//3
//STATE05_START
             RDATAmi??2si or    
//STATE_END
             CtlData2readch
            )
    begin
        case(CtlData2readch[SLAVE_WID-1:0])
            // synopsys parallel_case full_case
//STATE06_START
            ?WID?'d??:   RDATAsi2m  <= RDATAmi??2si;
//STATE_END
            default:     RDATAsi2m  <= 0;
        endcase
    end


    always @(//4
             RVALIDmi2si or    
             CtlData2readch
            )
    begin
        case(CtlData2readch[SLAVE_WID-1:0])
            // synopsys parallel_case full_case
//STATE07_START
            ?WID?'d??:   RVALIDsi2m  <= RVALIDmi2si[??];
//STATE_END
            default:     RVALIDsi2m  <= 0;
        endcase
    end


    always @(//5
             RLASTmi2si or    
             CtlData2readch
            )
    begin
        case(CtlData2readch[SLAVE_WID-1:0])
            // synopsys parallel_case full_case
//STATE08_START
            ?WID?'d??:   RLASTsi2m  <= RLASTmi2si[??];
//STATE_END
            default:     RLASTsi2m  <= 0;
        endcase
    end

RDCH_?NAME?_PermitCtl 
    U1PermitCtl(

    .ACLK       (ACLK)      ,
    .ARESETn    (ARESETn)   ,
    .SlaveNum   (SlaveNum)  ,

    .SID        (ARIDm2si),
    .AREADY     (ARREADYsi2m),
    .AVALID     (ARVALIDm2si),    

    .WID        ({MASTERID_WID{1'b0}}),
    .WREADY     (1'b0),
    .WVALID     (1'b0),
    .WLAST      (1'b0),

    .LID        (RIDsi2m),
    .LAST       (RLASTsi2m),
    .READY      (RREADYm2si),
    .RVALID     (RVALIDsi2m),

    .CtlData2datach  (),
    .CtlData2writech (CtlData2writech)

    );
   
endmodule
//Code_END

//`define SYN_AC  


module  ReadChannelsi(

    //Global signal
    ACLK    ,
    ARESETn ,

    //Read address channel
    ARIDm2si    ,
    ARADDRm2si  ,
    ARLENm2si   ,
    ARSIZEm2si  ,
    ARBURSTm2si ,
    ARLOCKm2si  ,
    ARCACHEm2si ,
    ARPROTm2si  ,

    ARVALIDm2si ,
    ARREADYsi2m ,

    //Read data channel
    RIDsi2m     ,
    RRESPsi2m   ,
    RVALIDsi2m  ,
    RDATAsi2m   ,
    RREADYm2si  ,
    RLASTsi2m   ,


    //For Master interface
    //Read address channel
    ARIDsi2mi    ,
    ARADDRsi2mi  ,
    ARLENsi2mi   ,
    ARSIZEsi2mi  ,
    ARBURSTsi2mi ,
    ARLOCKsi2mi  ,
    ARCACHEsi2mi ,
    ARPROTsi2mi  ,
    ARVALIDsi2mi ,
    ARREADYmi2si ,


    //Read data channel
    RIDmi02si     ,
    RRESPmi02si   ,
    RDATAmi02si   ,

    RIDmi12si     ,
    RRESPmi12si   ,
    RDATAmi12si   ,

    RIDmi22si     ,
    RRESPmi22si   ,
    RDATAmi22si   ,
    
    RIDmi32si     ,
    RRESPmi32si   ,
    RDATAmi32si   ,

    RIDmi42si     ,
    RRESPmi42si   ,
    RDATAmi42si   ,

    RIDmi52si     ,
    RRESPmi52si   ,
    RDATAmi52si   ,

    RVALIDmi2si  ,
    RREADYsi2mi  ,
    RLASTmi2si
);
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    //Read Address channel
    input   [ID_WID-1:0]       ARIDm2si;    
    input   [ADDR_WID-1:0]     ARADDRm2si;
    input   [ARLEN_WID-1:0]    ARLENm2si;
    input   [ARSIZE_WID-1:0]   ARSIZEm2si;  
    input   [ARBURST_WID-1:0]  ARBURSTm2si; 
    input   [ARLOCK_WID-1:0]   ARLOCKm2si;  
    input   [ARCACHE_WID-1:0]  ARCACHEm2si; 
    input   [ARPROT_WID-1:0]   ARPROTm2si;  

    input   ARVALIDm2si; 
    output  ARREADYsi2m; 


    //Read data channel
    output   [ID_WID-1:0]      RIDsi2m;     
    output   [RRESP_WID-1:0]   RRESPsi2m;   
    output   [BUS_WID-1:0]     RDATAsi2m;
    output   RVALIDsi2m;  
    input    RREADYm2si;  
    output   RLASTsi2m;   

    //For Master interface
    //Write address channel
    output  [ID_WID-1:0] ARIDsi2mi;    
    output  [ADDR_WID-1:0] ARADDRsi2mi;  
    output  [ARLEN_WID-1:0] ARLENsi2mi;   
    output  [ARSIZE_WID-1:0] ARSIZEsi2mi;  
    output  [ARBURST_WID-1:0] ARBURSTsi2mi; 
    output  [ARLOCK_WID-1:0] ARLOCKsi2mi;  
    output  [ARCACHE_WID-1:0] ARCACHEsi2mi; 
    output  [ARPROT_WID-1:0] ARPROTsi2mi;  
    output  [SLAVE_NUM-1:0]ARVALIDsi2mi; 
    input   [SLAVE_NUM-1:0]ARREADYmi2si; 


    //Read data channel
    input   [ID_WID-1:0]    RIDmi02si;     
    input   [RRESP_WID-1:0] RRESPmi02si;   
    input   [BUS_WID-1:0]   RDATAmi02si;

    input   [ID_WID-1:0]    RIDmi12si;     
    input   [RRESP_WID-1:0] RRESPmi12si;   
    input   [BUS_WID-1:0]   RDATAmi12si;

    input   [ID_WID-1:0]    RIDmi22si;     
    input   [RRESP_WID-1:0] RRESPmi22si;   
    input   [BUS_WID-1:0]   RDATAmi22si;

    input   [ID_WID-1:0]    RIDmi32si;     
    input   [RRESP_WID-1:0] RRESPmi32si;   
    input   [BUS_WID-1:0]   RDATAmi32si;

    input   [ID_WID-1:0]    RIDmi42si;     
    input   [RRESP_WID-1:0] RRESPmi42si;   
    input   [BUS_WID-1:0]   RDATAmi42si;

    input   [ID_WID-1:0]    RIDmi52si;     
    input   [RRESP_WID-1:0] RRESPmi52si;   
    input   [BUS_WID-1:0]   RDATAmi52si;

    input   [SLAVE_NUM-1:0] RVALIDmi2si;  
    input   [SLAVE_NUM-1:0] RLASTmi2si;  

    output  [SLAVE_NUM-1:0] RREADYsi2mi;    

    wire [SLAVE_WID :0] CtlData2writech;

    //CtlData2readch[SLAVE_WID] <= enable bit
    wire [SLAVE_WID  :0] CtlData2readch; 

    assign  ARIDsi2mi = ARIDm2si;    
    assign  ARADDRsi2mi = ARADDRm2si;  
    assign  ARLENsi2mi = ARLENm2si;   
    assign  ARSIZEsi2mi = ARSIZEm2si;  
    assign  ARBURSTsi2mi = ARBURSTm2si; 
    assign  ARLOCKsi2mi = ARLOCKm2si;  
    assign  ARCACHEsi2mi = ARCACHEm2si; 
    assign  ARPROTsi2mi = ARPROTm2si;  


//Read address channel
//____________________________________________________________________


//ARVALID MUX 
reg [SLAVE_NUM-1:0]ARVALIDsi2mi; 

always @(CtlData2writech or 
         ARVALIDm2si )
begin

    if(CtlData2writech[SLAVE_WID])
    begin
        case(CtlData2writech[SLAVE_WID-1:0])
        //synopsys full_case
        3'd0:   
        begin
            ARVALIDsi2mi[0] <= ARVALIDm2si;
            ARVALIDsi2mi[1] <= 1'b0;
            ARVALIDsi2mi[2] <= 1'b0;
            ARVALIDsi2mi[3] <= 1'b0;
            ARVALIDsi2mi[4] <= 1'b0;
            ARVALIDsi2mi[5] <= 1'b0;
        end
        3'd1:   
        begin
            ARVALIDsi2mi[0] <= 1'b0;
            ARVALIDsi2mi[1] <= ARVALIDm2si;
            ARVALIDsi2mi[2] <= 1'b0;
            ARVALIDsi2mi[3] <= 1'b0;
            ARVALIDsi2mi[4] <= 1'b0;
            ARVALIDsi2mi[5] <= 1'b0;
        end
        3'd2:   
        begin
            ARVALIDsi2mi[0] <= 1'b0;
            ARVALIDsi2mi[1] <= 1'b0;
            ARVALIDsi2mi[2] <= ARVALIDm2si;
            ARVALIDsi2mi[3] <= 1'b0;
            ARVALIDsi2mi[4] <= 1'b0;
            ARVALIDsi2mi[5] <= 1'b0;
        end
        3'd3:   
        begin
            ARVALIDsi2mi[0] <= 1'b0;
            ARVALIDsi2mi[1] <= 1'b0;
            ARVALIDsi2mi[2] <= 1'b0;
            ARVALIDsi2mi[3] <= ARVALIDm2si;
            ARVALIDsi2mi[4] <= 1'b0;
            ARVALIDsi2mi[5] <= 1'b0;
        end
        3'd4:   
        begin
            ARVALIDsi2mi[0] <= 1'b0;
            ARVALIDsi2mi[1] <= 1'b0;
            ARVALIDsi2mi[2] <= 1'b0;
            ARVALIDsi2mi[3] <= 1'b0;
            ARVALIDsi2mi[4] <= ARVALIDm2si;
            ARVALIDsi2mi[5] <= 1'b0;
        end

        default:
        begin
            ARVALIDsi2mi[0] <= 1'b0;
            ARVALIDsi2mi[1] <= 1'b0;
            ARVALIDsi2mi[2] <= 1'b0;
            ARVALIDsi2mi[3] <= 1'b0;
            ARVALIDsi2mi[4] <= 1'b0;
            ARVALIDsi2mi[5] <= ARVALIDm2si;
        end
        endcase
    end
    else
    begin
        ARVALIDsi2mi[0] <= 1'b0;
        ARVALIDsi2mi[1] <= 1'b0;
        ARVALIDsi2mi[2] <= 1'b0;
        ARVALIDsi2mi[3] <= 1'b0;
        ARVALIDsi2mi[4] <= 1'b0;
        ARVALIDsi2mi[5] <= 1'b0;
    end

end

reg ARREADYsi2m;

//ARREADY Demux
always @(CtlData2writech or ARREADYmi2si)
begin
    if(CtlData2writech[SLAVE_WID])
    begin
        case(CtlData2writech[SLAVE_WID-1:0])
        //synopsys full_case
            3'd0: ARREADYsi2m <= ARREADYmi2si[0];
            3'd1: ARREADYsi2m <= ARREADYmi2si[1];
            3'd2: ARREADYsi2m <= ARREADYmi2si[2];
            3'd3: ARREADYsi2m <= ARREADYmi2si[3];
            3'd4: ARREADYsi2m <= ARREADYmi2si[4];
            3'd5: ARREADYsi2m <= ARREADYmi2si[5];
            default:
                ARREADYsi2m <= 1'b0;
        endcase
    end
    else
        ARREADYsi2m <= 1'b0;
end

reg [SLAVE_WID-1:0] SlaveNum;

//ADDRESS Decoder
always @(ARADDRm2si)
begin
    case(ARADDRm2si[ADDR_WID-1:ADDR_WID-3])
        //synopsys full_case
        3'd0: SlaveNum <= 3'd0;
        3'd1: SlaveNum <= 3'd1;
        3'd2: SlaveNum <= 3'd2;
        3'd3: SlaveNum <= 3'd3;
        3'd4: SlaveNum <= 3'd4;
        default:
              SlaveNum <= 3'd5;
    endcase
end

//____________________________________________________________________

    


//Read data channel
//____________________________________________________________________

reg   [ID_WID-1:0]      RIDsi2m;     
reg   [RRESP_WID-1:0]   RRESPsi2m;   
reg   RVALIDsi2m;  
reg   RLASTsi2m;
reg   [SLAVE_NUM-1:0]    RREADYsi2mi;    
reg   [BUS_WID-1:0]     RDATAsi2m;


//Demux data channel
always @(RREADYm2si    or
         CtlData2readch
     )
begin
    if(CtlData2readch[SLAVE_WID]) //Mux enable bit
    begin

        case(CtlData2readch[SLAVE_WID-1:0])
        //synopsys full_case
            3'd0:
            begin
                RREADYsi2mi[0] <= RREADYm2si;
                RREADYsi2mi[1] <= 1'b0;
                RREADYsi2mi[2] <= 1'b0;
                RREADYsi2mi[3] <= 1'b0;
                RREADYsi2mi[4] <= 1'b0;
                RREADYsi2mi[5] <= 1'b0;
            end
            3'd1:
            begin
                RREADYsi2mi[0] <= 1'b0;
                RREADYsi2mi[1] <= RREADYm2si;
                RREADYsi2mi[2] <= 1'b0;
                RREADYsi2mi[3] <= 1'b0;
                RREADYsi2mi[4] <= 1'b0;
                RREADYsi2mi[5] <= 1'b0;
            end
            3'd2:
            begin
                RREADYsi2mi[0] <= 1'b0;
                RREADYsi2mi[1] <= 1'b0;
                RREADYsi2mi[2] <= RREADYm2si;
                RREADYsi2mi[3] <= 1'b0;
                RREADYsi2mi[4] <= 1'b0;
                RREADYsi2mi[5] <= 1'b0;
            end
            3'd3:
            begin
                RREADYsi2mi[0] <= 1'b0;
                RREADYsi2mi[1] <= 1'b0;
                RREADYsi2mi[2] <= 1'b0;
                RREADYsi2mi[3] <= RREADYm2si;
                RREADYsi2mi[4] <= 1'b0;
                RREADYsi2mi[5] <= 1'b0;
            end
            3'd4:
            begin
                RREADYsi2mi[0] <= 1'b0;
                RREADYsi2mi[1] <= 1'b0;
                RREADYsi2mi[2] <= 1'b0;
                RREADYsi2mi[3] <= 1'b0;
                RREADYsi2mi[4] <= RREADYm2si;
                RREADYsi2mi[5] <= 1'b0;
            end
            default:
            begin
                RREADYsi2mi[0] <= 1'b0;
                RREADYsi2mi[1] <= 1'b0;
                RREADYsi2mi[2] <= 1'b0;
                RREADYsi2mi[3] <= 1'b0;
                RREADYsi2mi[4] <= 1'b0;
                RREADYsi2mi[5] <= RREADYm2si;
            end

        endcase
        /*
        for(i = 0; i <= SLAVE_NUM-1; i=i+1)
        begin
            if(CtlData2readch == i)
                RREADYsi2mi[i] <= RREADYm2si;
            else 
                RREADYsi2mi[i] <= 1'b0;
        end
        */
    end
    else
    begin
            RREADYsi2mi[0] <= 1'b0;
            RREADYsi2mi[1] <= 1'b0;
            RREADYsi2mi[2] <= 1'b0;
            RREADYsi2mi[3] <= 1'b0;
            RREADYsi2mi[4] <= 1'b0;
            RREADYsi2mi[5] <= 1'b0;
    end
end

//Demux reaponse channel
always @(CtlData2readch  or

         RRESPmi02si    or
         RIDmi02si      or

         RRESPmi12si    or
         RIDmi12si      or

         RRESPmi22si    or
         RIDmi22si      or

         RRESPmi32si    or
         RIDmi32si      or

         RRESPmi42si    or
         RIDmi42si      or

         RRESPmi52si    or
         RIDmi52si      or

         RDATAmi02si or
         RDATAmi12si or
         RDATAmi22si or
         RDATAmi32si or
         RDATAmi42si or
         RDATAmi52si or

         RRESPmi52si    or
         RVALIDmi2si   or
         RIDmi52si     or
         RLASTmi2si

        )
begin

    if(CtlData2readch[SLAVE_WID]) // Mux enable bit
    begin
        case(CtlData2readch[SLAVE_WID-1:0]) 
        //synopsys full_case

        3'd0:
            begin
                RIDsi2m      <= RIDmi02si;     
                RRESPsi2m    <= RRESPmi02si;   
                RVALIDsi2m   <= RVALIDmi2si[0];  
                RDATAsi2m    <= RDATAmi02si;
                RLASTsi2m    <= RLASTmi2si[0];  
            end
        3'd1:
            begin
                RIDsi2m      <= RIDmi12si;     
                RRESPsi2m    <= RRESPmi12si;   
                RVALIDsi2m   <= RVALIDmi2si[1];  
                RDATAsi2m    <= RDATAmi12si;
                RLASTsi2m    <= RLASTmi2si[1];  
            end
        3'd2:
            begin
                RIDsi2m      <= RIDmi22si;     
                RRESPsi2m    <= RRESPmi22si;   
                RVALIDsi2m   <= RVALIDmi2si[2];  
                RDATAsi2m    <= RDATAmi22si;
                RLASTsi2m    <= RLASTmi2si[2];  
            end
        3'd3:
            begin
                RIDsi2m      <= RIDmi32si;     
                RRESPsi2m    <= RRESPmi32si;   
                RVALIDsi2m   <= RVALIDmi2si[3];  
                RDATAsi2m    <= RDATAmi32si;
                RLASTsi2m    <= RLASTmi2si[3];  
            end

       3'd4:
            begin
                RIDsi2m      <= RIDmi42si;     
                RRESPsi2m    <= RRESPmi42si;   
                RVALIDsi2m   <= RVALIDmi2si[4];  
                RDATAsi2m    <= RDATAmi42si;
                RLASTsi2m    <= RLASTmi2si[4];  
            end

       3'd5:
            begin
                RIDsi2m      <= RIDmi52si;     
                RRESPsi2m    <= RRESPmi52si;   
                RVALIDsi2m   <= RVALIDmi2si[5];  
                RDATAsi2m    <= RDATAmi52si;
                RLASTsi2m    <= RLASTmi2si[5];  
            end

        default:
            begin
                RIDsi2m      <= {ID_WID{1'b0}};     
                RRESPsi2m    <= {RRESP_WID{1'b0}};   
                RVALIDsi2m   <= 1'b0;  
                RDATAsi2m    <= {BUS_WID{1'b0}};
                RLASTsi2m    <= 1'b0;  
            end
        endcase
    end
    else
    begin
        RIDsi2m      <= {ID_WID{1'b0}};     
        RRESPsi2m    <= {RRESP_WID{1'b0}};   
        RVALIDsi2m   <= 1'b0;  
        RDATAsi2m    <= {BUS_WID{1'b0}};
        RLASTsi2m    <= 1'b0;  
    end
end


//____________________________________________________________________


PermitCtl 
    U1PermitCtl(

    .ACLK       (ACLK)      ,
    .ARESETn    (ARESETn)   ,
    //.ADDR       (ARADDRm2si),
    .SlaveNum   (SlaveNum)  ,

    .AREADY     (ARREADYsi2m),
    .AVALID     (ARVALIDm2si),    

    .LAST       (RLASTsi2m),
    .READY      (RREADYm2si),
    .RVALID     (RVALIDsi2m),

    .CtlData2datach  (),
    .CtlData2resch   (),
    .CtlData2writech (CtlData2writech),
    .CtlData2rddatach(CtlData2readch)
    

    );

endmodule

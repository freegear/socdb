
`define SLAVECNTWID 5   

module  WriteChannelsi(

    //Global signal
    ACLK    ,
    ARESETn ,

    //For Master
    //Write address channel
    AWIDm2si    ,
    AWADDRm2si  ,
    AWLENm2si   ,
    AWSIZEm2si  ,
    AWBURSTm2si ,
    AWLOCKm2si  ,
    AWCACHEm2si ,
    AWPROTm2si  ,

    AWVALIDm2si ,
    AWREADYsi2m ,

    //Write data channel
    WIDm2si     ,
    WDATAm2si   ,
    WSTRBm2si   ,
    WLASTm2si   ,
    WVALIDm2si  ,
    WREADYsi2m  ,

    //Write response channel
    BIDsi2m     ,
    BRESPsi2m   ,
    BVALIDsi2m  ,
    BREADYm2si  ,



    //For Master interface
    //Write address channel
    AWIDsi2mi    ,
    AWADDRsi2mi  ,
    AWLENsi2mi   ,
    AWSIZEsi2mi  ,
    AWBURSTsi2mi ,
    AWLOCKsi2mi  ,
    AWCACHEsi2mi ,
    AWPROTsi2mi  ,
    AWVALIDsi2mi ,
    AWREADYmi2si ,

    //Write data channel
    WIDsi2mi     ,
    WDATAsi2mi   ,
    WSTRBsi2mi   ,
    WLASTsi2mi   ,
    WVALIDsi2mi  ,
    WREADYmi2si  ,

    //Write response channel
    BIDmi02si     ,
    BRESPmi02si   ,

    BIDmi12si     ,
    BRESPmi12si   ,

    BIDmi22si     ,
    BRESPmi22si   ,
    
    BIDmi32si     ,
    BRESPmi32si   ,

    BIDmi42si     ,
    BRESPmi42si   ,

    BIDmi52si     ,
    BRESPmi52si   ,

    BVALIDmi2si  ,
    BREADYsi2mi
);
`include "Def.v"

    input   ACLK;
    input   ARESETn;

    //For Master
    //Write address channel
    input   [ID_WID-1:0]       AWIDm2si;    
    input   [ADDR_WID-1:0]     AWADDRm2si;
    input   [AWLEN_WID-1:0]    AWLENm2si;
    input   [AWSIZE_WID-1:0]   AWSIZEm2si;  
    input   [AWBURST_WID-1:0]  AWBURSTm2si; 
    input   [AWLOCK_WID-1:0]   AWLOCKm2si;  
    input   [AWCACHE_WID-1:0]  AWCACHEm2si; 
    input   [AWPROT_WID-1:0]   AWPROTm2si;  

    input   AWVALIDm2si; 
    output  AWREADYsi2m; 

    //Write data channel
    input   [ID_WID-1:0]       WIDm2si;     
    input   [BUS_WID-1:0]      WDATAm2si;   
    input   [WSTRB_WID-1:0]    WSTRBm2si;   
    input   WLASTm2si;   
    input   WVALIDm2si;  
    output  WREADYsi2m;  

    //Write response channel
    output   [ID_WID-1:0]      BIDsi2m;     
    output   [BRESP_WID-1:0]   BRESPsi2m;   
    output   BVALIDsi2m;  
    input    BREADYm2si;  

    //For Master interface
    //Write address channel
    output  [ID_WID-1:0] AWIDsi2mi;    
    output  [ADDR_WID-1:0] AWADDRsi2mi;  
    output  [AWLEN_WID-1:0] AWLENsi2mi;   
    output  [AWSIZE_WID-1:0] AWSIZEsi2mi;  
    output  [AWBURST_WID-1:0] AWBURSTsi2mi; 
    output  [AWLOCK_WID-1:0] AWLOCKsi2mi;  
    output  [AWCACHE_WID-1:0] AWCACHEsi2mi; 
    output  [AWPROT_WID-1:0] AWPROTsi2mi;  
    output  [SLAVE_NUM-1:0]AWVALIDsi2mi; 
    input   [SLAVE_NUM-1:0]AWREADYmi2si; 

    //Write data channel
    output  [ID_WID-1:0] WIDsi2mi;     
    output  [BUS_WID-1:0] WDATAsi2mi;   
    output  [WSTRB_WID-1:0]WSTRBsi2mi;   
    output  [SLAVE_NUM-1:0]WLASTsi2mi;   
    output  [SLAVE_NUM-1:0]WVALIDsi2mi;  
    input   [SLAVE_NUM-1:0]WREADYmi2si;  

    //Write response channel
    input   [ID_WID-1:0] BIDmi02si;     
    input   [BRESP_WID-1:0] BRESPmi02si;   

    input   [ID_WID-1:0] BIDmi12si;     
    input   [BRESP_WID-1:0] BRESPmi12si;   

    input   [ID_WID-1:0] BIDmi22si;     
    input   [BRESP_WID-1:0] BRESPmi22si;   

    input   [ID_WID-1:0] BIDmi32si;     
    input   [BRESP_WID-1:0] BRESPmi32si;   

    input   [ID_WID-1:0] BIDmi42si;     
    input   [BRESP_WID-1:0] BRESPmi42si;   

    input   [ID_WID-1:0] BIDmi52si;     
    input   [BRESP_WID-1:0] BRESPmi52si;   

    input   [SLAVE_NUM-1:0]BVALIDmi2si;  
    output  [SLAVE_NUM-1:0]BREADYsi2mi;    

    wire [ID_WID-1:0] WIDsi2mi;     
    wire [BUS_WID-1:0] WDATAsi2mi;   
    wire [WSTRB_WID-1:0]WSTRBsi2mi;   

    wire [SLAVE_WID  :0] CtlData2writech; //CtlData2writech[SLAVE_WID]<= enable bit
    wire [SLAVE_WID-1:0] CtlData2readch;
    wire [SLAVE_WID-1:0] CtlData2resch;

    assign  AWIDsi2mi = AWIDm2si;    
    assign  AWADDRsi2mi = AWADDRm2si;  
    assign  AWLENsi2mi = AWLENm2si;   
    assign  AWSIZEsi2mi = AWSIZEm2si;  
    assign  AWBURSTsi2mi = AWBURSTm2si; 
    assign  AWLOCKsi2mi = AWLOCKm2si;  
    assign  AWCACHEsi2mi = AWCACHEm2si; 
    assign  AWPROTsi2mi = AWPROTm2si;  

    assign  WIDsi2mi = WIDm2si;
    assign  WDATAsi2mi = WDATAm2si;   
    assign  WSTRBsi2mi = WSTRBm2si;

//Write address channel
//____________________________________________________________________


//AWVALID MUX 
reg [SLAVE_NUM-1:0]AWVALIDsi2mi; 

always @(CtlData2writech or 
         AWVALIDm2si )
begin

    if(CtlData2writech[SLAVE_WID]) //MUX enalbe bit
    begin
        case(CtlData2writech[SLAVE_WID-1:0])
            //synopsys full_case
            3'd0:   
            begin
                AWVALIDsi2mi[0] <= AWVALIDm2si;
                AWVALIDsi2mi[1] <= 1'b0;
                AWVALIDsi2mi[2] <= 1'b0;
                AWVALIDsi2mi[3] <= 1'b0;
                AWVALIDsi2mi[4] <= 1'b0;
                AWVALIDsi2mi[5] <= 1'b0;
            end
            3'd1:   
            begin
                AWVALIDsi2mi[0] <= 1'b0;
                AWVALIDsi2mi[1] <= AWVALIDm2si;
                AWVALIDsi2mi[2] <= 1'b0;
                AWVALIDsi2mi[3] <= 1'b0;
                AWVALIDsi2mi[4] <= 1'b0;
                AWVALIDsi2mi[5] <= 1'b0;
            end
            3'd2:   
            begin
                AWVALIDsi2mi[0] <= 1'b0;
                AWVALIDsi2mi[1] <= 1'b0;
                AWVALIDsi2mi[2] <= AWVALIDm2si;
                AWVALIDsi2mi[3] <= 1'b0;
                AWVALIDsi2mi[4] <= 1'b0;
                AWVALIDsi2mi[5] <= 1'b0;
            end
            3'd3:   
            begin
                AWVALIDsi2mi[0] <= 1'b0;
                AWVALIDsi2mi[1] <= 1'b0;
                AWVALIDsi2mi[2] <= 1'b0;
                AWVALIDsi2mi[3] <= AWVALIDm2si;
                AWVALIDsi2mi[4] <= 1'b0;
                AWVALIDsi2mi[5] <= 1'b0;
            end
            3'd4:   
            begin
                AWVALIDsi2mi[0] <= 1'b0;
                AWVALIDsi2mi[1] <= 1'b0;
                AWVALIDsi2mi[2] <= 1'b0;
                AWVALIDsi2mi[3] <= 1'b0;
                AWVALIDsi2mi[4] <= AWVALIDm2si;
                AWVALIDsi2mi[5] <= 1'b0;
            end

            default:
            begin
                AWVALIDsi2mi[0] <= 1'b0;
                AWVALIDsi2mi[1] <= 1'b0;
                AWVALIDsi2mi[2] <= 1'b0;
                AWVALIDsi2mi[3] <= 1'b0;
                AWVALIDsi2mi[4] <= 1'b0;
                AWVALIDsi2mi[5] <= AWVALIDm2si;
            end
        endcase

    end
    else
    begin
        AWVALIDsi2mi[0] <= 1'b0;
        AWVALIDsi2mi[1] <= 1'b0;
        AWVALIDsi2mi[2] <= 1'b0;
        AWVALIDsi2mi[3] <= 1'b0;
        AWVALIDsi2mi[4] <= 1'b0;
        AWVALIDsi2mi[5] <= 1'b0;
    end
end

reg AWREADYsi2m;

//AWREADY Demux
always @(CtlData2writech or AWREADYmi2si)
begin

    if(CtlData2writech[SLAVE_WID]) //Mux enable bit
    begin
        case(CtlData2writech[SLAVE_WID-1:0])
            //synopsys full_case
            3'd0: AWREADYsi2m <= AWREADYmi2si[0];
            3'd1: AWREADYsi2m <= AWREADYmi2si[1];
            3'd2: AWREADYsi2m <= AWREADYmi2si[2];
            3'd3: AWREADYsi2m <= AWREADYmi2si[3];
            3'd4: AWREADYsi2m <= AWREADYmi2si[4];
            3'd5: AWREADYsi2m <= AWREADYmi2si[5];
            default:
                AWREADYsi2m <= 1'b0;
        endcase
    end
    else
        AWREADYsi2m <= 1'b0;

end

reg [SLAVE_WID-1:0] SlaveNum;

//ADDRESS Decoder
always @(AWADDRm2si)
begin
    case(AWADDRm2si[ADDR_WID-1:ADDR_WID-3])
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


//Write data channel
//____________________________________________________________________

//WVALID MUX 
//
wire  [SLAVE_WID-1:0] CtlData2datach;
reg   [SLAVE_NUM-1:0] WVALIDsi2mi;  
reg   [SLAVE_NUM-1:0] WLASTsi2mi;   

always @(CtlData2datach or 
         WVALIDm2si or
         WLASTm2si
        )
begin
    case(CtlData2datach)
            //synopsys full_case
        3'd0:   
        begin
            WVALIDsi2mi[0] <= WVALIDm2si;
            WVALIDsi2mi[1] <= 1'b0;
            WVALIDsi2mi[2] <= 1'b0;
            WVALIDsi2mi[3] <= 1'b0;
            WVALIDsi2mi[4] <= 1'b0;
            WVALIDsi2mi[5] <= 1'b0;

            WLASTsi2mi[0]  <= WLASTm2si;
            WLASTsi2mi[1]  <= 1'b0;
            WLASTsi2mi[2]  <= 1'b0;
            WLASTsi2mi[3]  <= 1'b0;
            WLASTsi2mi[4]  <= 1'b0;
            WLASTsi2mi[5]  <= 1'b0;
        end
        3'd1:   
        begin
            WVALIDsi2mi[0] <= 1'b0;
            WVALIDsi2mi[1] <= WVALIDm2si;
            WVALIDsi2mi[2] <= 1'b0;
            WVALIDsi2mi[3] <= 1'b0;
            WVALIDsi2mi[4] <= 1'b0;
            WVALIDsi2mi[5] <= 1'b0;

            WLASTsi2mi[0]  <= 1'b0;
            WLASTsi2mi[1]  <= WLASTm2si;
            WLASTsi2mi[2]  <= 1'b0;
            WLASTsi2mi[3]  <= 1'b0;
            WLASTsi2mi[4]  <= 1'b0;
            WLASTsi2mi[5]  <= 1'b0;
        end
        3'd2:   
        begin
            WVALIDsi2mi[0] <= 1'b0;
            WVALIDsi2mi[1] <= 1'b0;
            WVALIDsi2mi[2] <= WVALIDm2si;
            WVALIDsi2mi[3] <= 1'b0;
            WVALIDsi2mi[4] <= 1'b0;
            WVALIDsi2mi[5] <= 1'b0;

            WLASTsi2mi[0]  <= 1'b0;
            WLASTsi2mi[1]  <= 1'b0;
            WLASTsi2mi[2]  <= WLASTm2si;
            WLASTsi2mi[3]  <= 1'b0;
            WLASTsi2mi[4]  <= 1'b0;
            WLASTsi2mi[5]  <= 1'b0;
        end
        3'd3:   
        begin
            WVALIDsi2mi[0] <= 1'b0;
            WVALIDsi2mi[1] <= 1'b0;
            WVALIDsi2mi[2] <= 1'b0;
            WVALIDsi2mi[3] <= WVALIDm2si;
            WVALIDsi2mi[4] <= 1'b0;
            WVALIDsi2mi[5] <= 1'b0;

            WLASTsi2mi[0]  <= 1'b0;
            WLASTsi2mi[1]  <= 1'b0;
            WLASTsi2mi[2]  <= 1'b0;
            WLASTsi2mi[3]  <= WLASTm2si;
            WLASTsi2mi[4]  <= 1'b0;
            WLASTsi2mi[5]  <= 1'b0;
        end
        3'd4:   
        begin
            WVALIDsi2mi[0] <= 1'b0;
            WVALIDsi2mi[1] <= 1'b0;
            WVALIDsi2mi[2] <= 1'b0;
            WVALIDsi2mi[3] <= 1'b0;
            WVALIDsi2mi[4] <= WVALIDm2si;
            WVALIDsi2mi[5] <= 1'b0;

            WLASTsi2mi[0]  <= 1'b0;
            WLASTsi2mi[1]  <= 1'b0;
            WLASTsi2mi[2]  <= 1'b0;
            WLASTsi2mi[3]  <= 1'b0;
            WLASTsi2mi[4]  <= WLASTm2si;
            WLASTsi2mi[5]  <= 1'b0;
        end
        3'd7:   
        begin
            WVALIDsi2mi[0] <= 1'b0;
            WVALIDsi2mi[1] <= 1'b0;
            WVALIDsi2mi[2] <= 1'b0;
            WVALIDsi2mi[3] <= 1'b0;
            WVALIDsi2mi[4] <= 1'b0;
            WVALIDsi2mi[5] <= 1'b0;

            WLASTsi2mi[0]  <= 1'b0;
            WLASTsi2mi[1]  <= 1'b0;
            WLASTsi2mi[2]  <= 1'b0;
            WLASTsi2mi[3]  <= 1'b0;
            WLASTsi2mi[4]  <= 1'b0;
            WLASTsi2mi[5]  <= 1'b0;
        end

        default:
        begin
            WVALIDsi2mi[0] <= 1'b0;
            WVALIDsi2mi[1] <= 1'b0;
            WVALIDsi2mi[2] <= 1'b0;
            WVALIDsi2mi[3] <= 1'b0;
            WVALIDsi2mi[4] <= 1'b0;
            WVALIDsi2mi[5] <= WVALIDm2si;

            WLASTsi2mi[0]  <= 1'b0;
            WLASTsi2mi[1]  <= 1'b0;
            WLASTsi2mi[2]  <= 1'b0;
            WLASTsi2mi[3]  <= 1'b0;
            WLASTsi2mi[4]  <= 1'b0;
            WLASTsi2mi[5]  <= WLASTm2si;
        end
    endcase
end

reg WREADYsi2m;

//WREADY Demux
always @(CtlData2datach or WREADYmi2si)
begin
    case(CtlData2datach)
            //synopsys full_case
        3'd0: WREADYsi2m <= WREADYmi2si[0];
        3'd1: WREADYsi2m <= WREADYmi2si[1];
        3'd2: WREADYsi2m <= WREADYmi2si[2];
        3'd3: WREADYsi2m <= WREADYmi2si[3];
        3'd4: WREADYsi2m <= WREADYmi2si[4];
        3'd5: WREADYsi2m <= WREADYmi2si[5];
        3'd7: WREADYsi2m <= 1'b0;
        default:
            WREADYsi2m <= 1'b0;
    endcase
end


//____________________________________________________________________





//Write response channel
//____________________________________________________________________

reg   [ID_WID-1:0]      BIDsi2m;     
reg   [BRESP_WID-1:0]   BRESPsi2m;   
reg   BVALIDsi2m;  
reg   [SLAVE_NUM-1:0]   BREADYsi2mi;    


//Demux reaponse channel
always @(BREADYm2si    or
         CtlData2resch
     )
begin

    case(CtlData2resch)
        //synopsys full_case
        3'd0:
        begin
            BREADYsi2mi[0] <= BREADYm2si;
            BREADYsi2mi[1] <= 1'b0;
            BREADYsi2mi[2] <= 1'b0;
            BREADYsi2mi[3] <= 1'b0;
            BREADYsi2mi[4] <= 1'b0;
            BREADYsi2mi[5] <= 1'b0;
        end
        3'd1:
        begin
            BREADYsi2mi[0] <= 1'b0;
            BREADYsi2mi[1] <= BREADYm2si;
            BREADYsi2mi[2] <= 1'b0;
            BREADYsi2mi[3] <= 1'b0;
            BREADYsi2mi[4] <= 1'b0;
            BREADYsi2mi[5] <= 1'b0;
        end
        3'd2:
        begin
            BREADYsi2mi[0] <= 1'b0;
            BREADYsi2mi[1] <= 1'b0;
            BREADYsi2mi[2] <= BREADYm2si;
            BREADYsi2mi[3] <= 1'b0;
            BREADYsi2mi[4] <= 1'b0;
            BREADYsi2mi[5] <= 1'b0;
        end
        3'd3:
        begin
            BREADYsi2mi[0] <= 1'b0;
            BREADYsi2mi[1] <= 1'b0;
            BREADYsi2mi[2] <= 1'b0;
            BREADYsi2mi[3] <= BREADYm2si;
            BREADYsi2mi[4] <= 1'b0;
            BREADYsi2mi[5] <= 1'b0;
        end
        3'd4:
        begin
            BREADYsi2mi[0] <= 1'b0;
            BREADYsi2mi[1] <= 1'b0;
            BREADYsi2mi[2] <= 1'b0;
            BREADYsi2mi[3] <= 1'b0;
            BREADYsi2mi[4] <= BREADYm2si;
            BREADYsi2mi[5] <= 1'b0;
        end
        3'd5:
        begin
            BREADYsi2mi[0] <= 1'b0;
            BREADYsi2mi[1] <= 1'b0;
            BREADYsi2mi[2] <= 1'b0;
            BREADYsi2mi[3] <= 1'b0;
            BREADYsi2mi[4] <= 1'b0;
            BREADYsi2mi[5] <= BREADYm2si;
        end
        default:
        begin
            BREADYsi2mi[0] <= 1'b0;
            BREADYsi2mi[1] <= 1'b0;
            BREADYsi2mi[2] <= 1'b0;
            BREADYsi2mi[3] <= 1'b0;
            BREADYsi2mi[4] <= 1'b0;
            BREADYsi2mi[5] <= 1'b0;
        end

    endcase

    /*
    for(i = 0; i <= SLAVE_NUM-1; i=i+1)
    begin
        if(CtlData2resch == 7)
            BREADYsi2mi[i] <= 1'b0;
        else if(CtlData2resch == i)
            BREADYsi2mi[i] <= BREADYm2si;
        else 
            BREADYsi2mi[i] <= 1'b0;
    end
    */
end

//Demux reaponse channel
always @(CtlData2resch  or

         BRESPmi02si    or
         BIDmi02si      or

         BRESPmi12si    or
         BIDmi12si      or

         BRESPmi22si    or
         BIDmi22si      or

         BRESPmi32si    or
         BIDmi32si      or

         BRESPmi42si    or
         BIDmi42si      or

         BRESPmi52si    or
         BVALIDmi2si    or
         BIDmi52si      

        )
begin

    case(CtlData2resch)
            //synopsys full_case
        4'd0:
            begin
                BIDsi2m      <= BIDmi02si;     
                BRESPsi2m    <= BRESPmi02si;   
                BVALIDsi2m   <= BVALIDmi2si[0];  
            end
        4'd1:
            begin
                BIDsi2m      <= BIDmi12si;     
                BRESPsi2m    <= BRESPmi12si;   
                BVALIDsi2m   <= BVALIDmi2si[1];  
            end
        4'd2:
            begin
                BIDsi2m      <= BIDmi22si;     
                BRESPsi2m    <= BRESPmi22si;   
                BVALIDsi2m   <= BVALIDmi2si[2];  
            end
        4'd3:
            begin
                BIDsi2m      <= BIDmi32si;     
                BRESPsi2m    <= BRESPmi32si;   
                BVALIDsi2m   <= BVALIDmi2si[3];  
            end
        4'd4:
            begin
                BIDsi2m      <= BIDmi42si;     
                BRESPsi2m    <= BRESPmi42si;   
                BVALIDsi2m   <= BVALIDmi2si[4];  
            end
        default:
            begin
                BIDsi2m      <= BIDmi52si;     
                BRESPsi2m    <= BRESPmi52si;   
                BVALIDsi2m   <= BVALIDmi2si[5];  
            end
    endcase
end


//____________________________________________________________________


PermitCtl
    U0PermitCtl(

    .ACLK       (ACLK)      ,
    .ARESETn    (ARESETn)   ,
    .SlaveNum   (SlaveNum)  ,


    .AREADY    (AWREADYsi2m),
    .AVALID    (AWVALIDm2si),    

    .LAST      (BVALIDsi2m),
    .READY     (BREADYm2si),
    .RVALID    (1'b1),

    .CtlData2datach  (CtlData2datach),
    .CtlData2resch   (CtlData2resch),
    .CtlData2writech (CtlData2writech) ,
    .CtlData2rddatach()


    );

endmodule

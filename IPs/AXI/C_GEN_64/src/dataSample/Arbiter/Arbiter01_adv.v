//Response Arbiter
//Arbiter was Generated 
//LockAccess support Aribiter TYPE01
reg   EnArbiter;
reg   rEnArbiter;
reg   [SELMASTER_WID-1:0] rCtlData; 

always @(
         rCtlData or
         ?IN? or
         ?SEL?
        )
begin
    case(rCtlData)
        //synopsys parallel_case full_case
//CASE_START
        ?WID?'d??:    EnArbiter <= ?IN?[??];
//END
        default: EnArbiter <= 1'b0;
    endcase
end

always  @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        rEnArbiter <= 0;
    end
    else
    begin
        case(rCtlData) //Ver2.2 Arbiter bug fix
            //synopsys parallel_case full_case
//CASE_START
            ?WID?'d??:    rEnArbiter <= EnArbiter & !?IN1?[??];
//END
            default: rEnArbiter <= 1'b0;
        endcase
    end
end



always  @(posedge ?CLK? or negedge ?REST?)
begin
    if(!?REST?)
    begin
        rCtlData <= 0;
    end
    else if((LockArbiter[1] | LockArbiter[5]) & !LockPort[SELMASTER_WID]) // STATE --> FUll_MASK
    begin                                    // STATE --> VMASK
        rCtlData <= LockPort[SELMASTER_WID-1:0];
    end
    else if(!rEnArbiter && !ReqFull && LockArbiter[0])
    begin
        rCtlData <= ?SEL?;
    end
end


always @(rEnArbiter or rCtlData or ReqFull or LockArbiter or ?IN?) begin

    if(!rEnArbiter && !ReqFull && LockArbiter[0])
    begin
//IF_START
        ?else? if(?IN?[??]) ?SEL? <= ?WID?'d??;
//END
        else                     ?SEL? <= rCtlData ;
    end
    else                         ?SEL? <= rCtlData ;

end

//Code_End

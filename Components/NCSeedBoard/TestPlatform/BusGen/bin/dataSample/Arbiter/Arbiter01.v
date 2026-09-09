//Response Arbiter
//Arbiter was Generated 
//LockAccess support Aribiter TYPE01
reg   EnArbiter;

always @(
         ?IN? or
         ?SEL?
        )
begin
    case(?SEL?)
        //synopsys parallel_case full_case
//CASE_START
        ?WID?'d??:    EnArbiter <= ?IN?[??];
//END
        default: EnArbiter <= 1'b0;
    endcase
end

always  @(posedge ?CLK? or negedge ?REST?)
begin
    if(!?REST?)
    begin
        ?SEL? <= 0;
    end
    else if((LockArbiter[1] | LockArbiter[5]) & !LockPort[SELMASTER_WID]) // STATE --> FUll_MASK
    begin                                    // STATE --> VMASK
        ?SEL? <= LockPort[SELMASTER_WID-1:0];
    end
    else if(!EnArbiter && !ReqFull && LockArbiter[0])
    begin
//IF_START
        ?else? if(?IN?[??]) ?SEL? <= ?WID?'d??;
//END
    end
end

//Code_End

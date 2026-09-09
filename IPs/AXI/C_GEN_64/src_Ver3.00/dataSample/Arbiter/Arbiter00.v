//Response Arbiter
//Arbiter was Generated TYPE00
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
    else if(!EnArbiter)
    begin
//IF_START
        ?else? if(?IN?[??]) ?SEL? <= ?WID?'d??;
//END
    end
end

//Code_End

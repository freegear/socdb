//MUX TYPE 00 was Generated 
always @(?SEL? or 
         ?IN? )
begin

    if(?SEL?[?WID?]) //MUX enalbe bit
    begin
        case(?SEL?[?WID?-1:0])
        //synopsys parallel_case full_case
//CASE_START
            ?WID?'d??:   
            begin
               ?repeat? ?OUT?[??] <= ?IN?;
            end
//END
            default:
            begin
//DEFAULT_START
                ?OUT?[??] <= ?IN?;
//END
            end
        endcase
    end
    else
    begin
//ELSE_START
        ?OUT?[??] <= 1'b0;
//END
    end
end
//Code_End

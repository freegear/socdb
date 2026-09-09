//MUX TYPE 01 was Generated 
always @(?SEL? or 
         ?IN? )
begin

   case(?SEL?)
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
//Code_End

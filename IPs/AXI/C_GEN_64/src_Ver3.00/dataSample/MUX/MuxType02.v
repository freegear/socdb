//MUX TYPE 02 was Generated 
always @(?SEL? or 
         ?IN?  or
         ?SEL2?
        )
begin

   case({?SEL2?, ?SEL?})
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

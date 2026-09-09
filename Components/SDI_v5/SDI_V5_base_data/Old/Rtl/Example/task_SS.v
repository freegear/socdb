task Diff_LOC ;
begin
PRESETn           = 1'b0         ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;
#(`PERIOD/2 )                    ;
PRESETn           = 1'b1         ;
#(`PERIOD*5)                     ;

//Pulse Gen
Flag_Neg_Det_1d   = 1'b1         ;
STC_Pulse         = 1'b0         ;
#(`PERIOD)                       ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;

//Wait State
#(`PERIOD*20)                    ;

Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b1         ;
#(`PERIOD)                       ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;
end 
 endtask

task Same_Loc ;
begin

PRESETn           = 1'b0         ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;
#(`PERIOD/2 )                    ;
PRESETn           = 1'b1         ;
#(`PERIOD*5)                     ;

//Same Loc Gen
Flag_Neg_Det_1d   = 1'b1         ;
STC_Pulse         = 1'b1         ;
#(`PERIOD)                       ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;
//Wait State
#(`PERIOD*20)                    ;

//STC_Pulse 
Flag_Neg_Det_1d   = 1'b1         ;
STC_Pulse         = 1'b0         ;
#(`PERIOD)                       ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;
//Wait State
#(`PERIOD*20)                    ;

//STC_Pulse 
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b1         ;
#(`PERIOD)                       ;
Flag_Neg_Det_1d   = 1'b0         ;
STC_Pulse         = 1'b0         ;
end 
 endtask
 


//STATE_MAXMIN_EN
//Slave Number ??
wire Slave??MAXEn = (?ADDR? >= ?MAXVAL?) ? 1'b1:1'b0;
wire Slave??MINEn = (?MINVAL? >  ?ADDR?)  ? 1'b1:1'b0;
wire Slave??En = Slave??MAXEn & Slave??MINEn;

//END

//STATE_DEFAULT
wire Slave??En = 
//END
//STATE_EN00
                !Slave??En ?&?
//END

always @(
//STATE_EN01
         Slave??En ?or?
//STATE_END
        )
begin
    case(1'b1)
//STATE_EN02
        Slave??En:   SlaveNum <= ?WID?'d??;
//STATE_END
        default:   SlaveNum <= {?WID?{1'd0}};
    endcase
end

//Code_End


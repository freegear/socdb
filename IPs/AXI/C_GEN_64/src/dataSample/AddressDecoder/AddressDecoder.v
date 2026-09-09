

//STATE_MAXMIN_EN
//Slave Number ??
wire Slave??MAX0En = (?ADDR? >= ?MAXVAL?) ? 1'b1:1'b0;
wire Slave??MIN0En = (?MINVAL? >  ?ADDR?)  ? 1'b1:1'b0;
wire Slave??_0En = Slave??MAX0En & Slave??MIN0En;

//END

//STATE_MAXMIN_EN
//Slave Number ??
wire Slave??MAX1En = (?ADDR? >= ?MAXVAL?) ? 1'b1:1'b0;
wire Slave??MIN1En = (?MINVAL? >  ?ADDR?)  ? 1'b1:1'b0;
wire Slave??_1En = Slave??MAX1En & Slave??MIN1En;

//Selection mux
wire Slave??En = (SelMAP1) ? Slave??_1En : Slave??_0En;

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
    SlaveNum = 0;
    case(1'b1) 
//STATE_EN02
        Slave??En:   SlaveNum = ?WID?'d??;
//STATE_END
        default:   SlaveNum = {?WID?{1'd0}};
    endcase
end

//Code_End


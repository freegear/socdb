module sel_arth(iop2, icin, sel, oop2, ocin);

input[7:0]	iop2;
input 		icin;
input[2:0] 	sel;

output[7:0]	oop2;
output		ocin;	

reg[7:0]	oop2;
reg		ocin;	

always @(iop2 or icin or sel)
begin
	if (sel == 3'b000) begin // add
		ocin <=  0;
		oop2 <=  iop2;
	    end
	else if (sel == 3'b001) begin // addc
		ocin <=  icin;
		oop2 <=  iop2;
	    end
	else if (sel == 3'b010) begin // sub
		ocin <=  ~icin;
		oop2 <=  ~iop2 ;
		//oop2 <=  ~iop2 + 1; XXX
	    end
	else if (sel == 3'b011) begin  //increase
		ocin <=  0;
		oop2 <=  8'b00000001;
	    end
	else if (sel == 3'b100) begin //decrease
		ocin <=  0;
		oop2 <=  8'b11111111;
        end	
    else begin
	    ocin <=  0;
		oop2 <=  8'b00000000;
        end		
end
endmodule
		

module sel_al(isel, osel);

input[4:0]	isel;

output[3:0]	osel;
reg[3:0]	osel;

always @(isel)
begin
	if     ((isel >= 5'd0) && (isel <= 5'd4))  osel <= 4'd0;
	else if (isel == 5'd5)  osel <= 4'd1;
	else if (isel == 5'd6)  osel <= 4'd2;
	else if (isel == 5'd7)  osel <= 4'd3;
	else if (isel == 5'd8)  osel <= 4'd4;
	else if (isel == 5'd9)  osel <= 4'd5;
	else if (isel == 5'd10) osel <= 4'd6;
	else if (isel == 5'd11) osel <= 4'd7;
	else if (isel == 5'd12) osel <= 4'd8;
	else if (isel == 5'd13) osel <= 4'd9;
	else if (isel == 5'd14) osel <= 4'd10;
	else if (isel == 5'd15) osel <= 4'd11;
	else if (isel == 5'd16) osel <= 4'd12;
	else if (isel == 5'd17) osel <= 4'd13;
	else if (isel == 5'd18) osel <= 4'd14;
	else osel <= 4'd15;
end
endmodule

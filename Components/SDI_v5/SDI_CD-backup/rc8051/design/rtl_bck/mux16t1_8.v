module mux16t1_8( a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, 
	b0, b1, b2, b3, b4, b5, sel, qq);

input [7:0]   a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, 
	      b0, b1, b2, b3, b4, b5;
input [3:0]   sel;   
 
output[7:0]   qq;   
reg[7:0]      qq;   

always @( a0 or a1 or a2 or a3 or a4 or a5 or a6 or a7 or a8 or a9 or b0 or b1 or b2 or b3 or b4 or b5 or sel) begin
             if (sel == 4'b0000)//0     
                qq <=  a0; 
        else if (sel == 4'b0001)//1
                qq <=  a1;
        else if (sel == 4'b0010)//2
                qq <=  a2;
        else if (sel == 4'b0011)//3
                qq <=  a3; 
        else if (sel == 4'b0100)//4
                qq <=  a4; 
        else if (sel == 4'b0101)//5
                qq <=  a5;
        else if (sel == 4'b0110)//6
                qq <=  a6;
        else if (sel == 4'b0111)//7
                qq <=  a7;
        else if (sel == 4'b1000)//8
                qq <=  a8;
        else if (sel == 4'b1001)//9
                qq <=  a9;
        else if (sel == 4'b1010)//10
                qq <=  b0;
        else if (sel == 4'b1011)//11
                qq <=  b1;
        else if (sel == 4'b1100)//12
                qq <=  b2;
        else if (sel == 4'b1101)//13
                qq <=  b3;
        else if (sel == 4'b1110)//14
                qq <=  b4;
        else if (sel == 4'b1111)//15
                qq <=  b5;
end
endmodule
          

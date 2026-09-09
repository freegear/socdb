module mux2t1_1(a, b, sel, c);

input		a,b;
input		sel;
output		c;
reg c;
always @(a or b or sel)
if (!sel) c <= a;
else c <= b;
endmodule 

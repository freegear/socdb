 module adc(dataa, datab, cin, ac, cout, overflow, result);
 input[7:0] 	dataa, datab;
 input 		  cin;

 output  	cout, overflow, ac;
 output[7:0] 	result; 

 reg   		cout, overflow, ac, nega, negb ;
 reg[7:0] 	result; 
 reg[7:0]	a, b;
 reg[9:0]       c;

	always @(dataa or datab or a or b or c or cin or nega or negb or result) begin
          	a <= dataa[7:0];
		b <= datab[7:0];

                c[4:0] <= a[3:0] + b[3:0] + cin;     
 	        c[9:5] <= a[7:4] + b[7:4] + c[4];
		  
		result <= {c[8:5],c[3:0]};	
		
		if((8'b10000000<=a) && (a<=8'b11111111)) nega <= 1;
		else nega <= 0;

		if((8'b10000000<=b) && (b<=8'b11111111)) negb <= 1;
	        else negb <= 0;	
 
		if(!nega && !negb) begin 
			if((8'b10000000<=result) && (result<=8'b11111111)) overflow <= 1;	
			else overflow <= 0;
			end
	        else if(nega && negb) begin 
			if((8'b01111111>=result) && (result>=0)) overflow <= 1;
			else overflow <= 0;
	        end 
		else overflow <= 0;
		ac <= c[4];
		cout <= c[9];
	        end
    
 endmodule 
	 

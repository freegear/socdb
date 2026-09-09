module YUV422TO444 (
START,
TD_D,
CLOCK,
Y,
Cb,
Cr,
Ypix_clock,
COUNTER,
fi
);
input START;
input [7:0]TD_D;
input CLOCK;
output [7:0]Y;
output [7:0]Cb;
output [7:0]Cr;
output Ypix_clock;
output [1:0]COUNTER;
input  fi;

reg[7:0]  Cbb,Crr;
reg[7:0]  YY,CCr,CCb; 
reg[7:0]  Cbb2,Crr2;
reg[7:0]  YY2,CCr2,CCb2; 
reg [2:0] COUNTER;	
reg Ypix_clock;
	
wire  [7:0]Y= YY ;
wire  [7:0]Cb=CCb;
wire  [7:0]Cr=CCr;



	always @(posedge CLOCK) begin
		if (START) 
		   COUNTER=0;
			else COUNTER=COUNTER+1;
    end			

	always @(posedge CLOCK) begin
		case (COUNTER)
			0:begin Cbb =TD_D;                  Ypix_clock =0;end
			1:begin YY  =TD_D;CCr=Crr;CCb=Cbb; Ypix_clock =1;end
			2:begin Crr=TD_D;                  Ypix_clock =0;end
			3:begin YY  =TD_D;CCr=Crr;CCb=Cbb; Ypix_clock =1;end			
			4:begin Cbb=TD_D;                  Ypix_clock =0;end
			5:begin YY  =TD_D;CCr=Crr;CCb=Cbb; Ypix_clock =1;end
			6:begin Crr =TD_D;                  Ypix_clock =0;end
			7:begin YY  =TD_D;CCr=Crr;CCb=Cbb; Ypix_clock =1;end			
			
        endcase 			
    end	
endmodule 		

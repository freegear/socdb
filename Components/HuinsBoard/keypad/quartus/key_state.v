/****************************************************
 *	MODULE:		Key_state		    *
 *	AUTHOR:		JYS			    *						*
 *	CODE TYPE:	Behavioral		    *					*
 *	DESCRIPTION: State machine for Key-State    *
 ****************************************************/
 
`include "ahb_slave_include.v"

module key_state(	
                 reset       ,
                 clock       ,
                 DATA_AVAIL  ,     
                 DATA_A      ,     
                 DATA_B      ,     
                 DATA_C      ,     
                 DATA_D      ,
                 address     ,
                 write       ,
		         read_data   ,
                 Int_reg     ,
                 Hready_i
                 

				);

input reset                            ;  //Active low reset
input clock                            ;  //System Clock 

input DATA_AVAIL          ;
input DATA_A              ;
input DATA_B              ;
input DATA_C              ;
input DATA_D              ;
input [31:0] address      ;
input write               ;

output [31:0]  read_data  ; 
output         Int_reg    ;
output         Hready_i   ;

parameter Hig   = 1'b1 ;
parameter Low   = 1'b0 ;

parameter	        IDLE			= 3'b000,
			DATA_PHASE              = 3'b001,
			WAIT_STATE              = 3'b010,
			READ_STATE              = 3'b011,
			WAIT_STATE2             = 3'b100 ;

reg [2:0] PLD_STATE;
reg DATA_AVAIL_1d         ;
reg DATA_AVAIL_2d         ;
reg [31:0] DATA_1d         ;
reg [31:0] DATA_2d        ;


reg [7:0] DATA_REG        ; 
reg       Int_reg         ;
reg       Latch_en        ;
reg  [31:0] read_data     ;
reg wait_sig              ;

reg Hready_i              ;

//latch code
always @(negedge reset or posedge clock )
  begin
     if (!reset ) begin
      
      DATA_AVAIL_1d  <= 1'b0         ;
      DATA_AVAIL_2d  <= 1'b0         ;
      DATA_REG       <= 8'h00        ;
      Latch_en       <= 1'b0         ;
      end
      else
         begin
        
        
        DATA_AVAIL_1d <=   DATA_AVAIL                        ;              
        DATA_AVAIL_2d <=   DATA_AVAIL_1d                     ;
        //Latch_en      <=   1'b0                              ;
        
       if ( DATA_AVAIL_1d == 1'b1 )
           begin
                 if (DATA_1d == 4'b0000)
                 DATA_REG <=  8'h31 ;     
            else if (DATA_1d == 4'b0010)   
                 DATA_REG <=  8'h32 ;
            else if (DATA_1d == 4'b0001)
                 DATA_REG <=  8'h33 ;
            else if (DATA_1d == 4'b1000)
                 DATA_REG <=  8'h34 ;
            else if (DATA_1d == 4'b1010)
                 DATA_REG <=  8'h35 ;
            else if (DATA_1d == 4'b1001)
                 DATA_REG <=  8'h36 ;
            else if (DATA_1d == 4'b0100)
                 DATA_REG <=  8'h37 ;
            else if (DATA_1d == 4'b0110)
                 DATA_REG <=  8'h38 ;
            else if (DATA_1d == 4'b1001)
                 DATA_REG <=  8'h39 ;
            else if (DATA_1d == 4'b1110)
                 DATA_REG <=  8'h30 ;
            else if (DATA_1d == 4'b1100)
                 DATA_REG <=  8'h2A ;
            else if (DATA_1d == 4'b1101)
                 DATA_REG <=  8'h23 ;
            else DATA_REG <=  8'h00 ;
           end  
           
           if (DATA_AVAIL_1d == 1'b0 && DATA_AVAIL_2d == 1'b1 )
                 Latch_en <= 1'b1 ;
            else Latch_en <= 1'b0 ;   
              
         end 
          end 


always @(posedge clock or negedge reset)
  begin

	if (reset == 1'b0)	// check if PLD_RESETn is active
	  begin
		
		PLD_STATE  <= IDLE         ;
		DATA_1d    <= 32'h00000000 ;
		DATA_2d    <= 32'h00000000 ;
		Int_reg    <= Low          ;
		read_data  <= 32'hFFFFFFFF ;
		wait_sig   <= 1'b1         ;
		Hready_i   <= 1'b1        ;
  
	  end

	else
		
	  begin	
		      
		      //if (  Latch_en == 1'b1 )
		      //   DATA_1d  <= { 28'h0000000 , DATA_A,DATA_B, DATA_C, DATA_D } ;
			 
		      
		      case(PLD_STATE)
		           
		           IDLE : 	
		             begin
				Int_reg   <= Low    ;
				if (  Latch_en == 1'b1 )
				  //if (  Latch_en == 1'b1 )			      
				      PLD_STATE <= DATA_PHASE ;
			         else PLD_STATE <= IDLE       ;
			       wait_sig      <= 1'b1          ; 
			       Hready_i <= 1'b1 ;
	  		  end
	                   
	                   
  			DATA_PHASE :	// Store
		  	  begin
		  	
			DATA_1d  <= { 28'h0000000 , DATA_A,DATA_B, DATA_C, DATA_D } ;
			Int_reg       <= Hig                                 ;
			PLD_STATE     <= WAIT_STATE                           ; 	
			wait_sig      <= 1'b0                                ;
			Hready_i      <= 1'b1 ;  	  
			   
		  	  end 

		  	WAIT_STATE:
			  begin
			  
			     wait_sig <= 1'b0 ;
			   if ( address[2:0] == 3'b100 && write == 1'b0 )
			           begin
			           PLD_STATE <= READ_STATE ;
			           Hready_i <= 1'b0 ;
			           end 
			        else
			           begin
			           PLD_STATE <= WAIT_STATE ;
			           Hready_i <= 1'b1 ;
			           end 
			  end 
			READ_STATE :
			  begin
				
				read_data <= DATA_1d        ;
				Int_reg   <= Hig            ;
				PLD_STATE <= WAIT_STATE2          ;
				Hready_i  <= 1'b1 ;
				wait_sig <= 1'b1 ;
			  end
		        WAIT_STATE2 : begin
		                Int_reg   <= Low            ;
		                PLD_STATE <= IDLE           ;
		                Hready_i  <= 1'b1           ;     
		                      end
		           
	  		endcase
	  end 
	
end // always


endmodule

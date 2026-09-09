module LCD_TOP( clk, 
                reset,
                address,
                data_in,
                write,
                enable,                
                data_out,
                mode,
                init_done,  
                rd_address,
                read_reg, 
                phase,
                lcd_en);

//INPUTS
 input          clk;
 input          reset;
 input  [7:0]   address;
 input  [31:0]  data_in;
 input          write;
 input          enable;

// OUTPUTS
 output [7:0]   data_out;
 output [1:0]   mode;
 output         lcd_en;
 output         init_done;
 output [31:0]  read_reg;
 output         phase;   
 output [5:0]   rd_address;         

// REGISTER
 reg    [31:0]  read_reg;
 reg    [23:0]  counter;  
 reg            read;
 reg    [5:0]   rd_address; 
 reg    [7:0]   data_out;
 reg    [1:0]   mode;
 reg            lcd_en; 
 reg            state;
 reg            init_done;
 reg            clk_dpram;
// Wire

 wire           wr_en       = (write && enable && address[6])? 1'b1 : 1'b0;
 wire   [5:0]   data_cnt    = counter[20:15]; 
 wire   [7:0]   rd_data; 
 wire   [7:2]   wr_address  = (wr_en) ? address[5:0] : 6'd63; 
 wire   [31:0]  read_data   = {24'b0,data_out};
 assign         phase = state; 
 wire    [7:0]  wr_data = data_in[7:0];

dp_ram dpram1( .clk(clk), 
               .write(wr_en),
               .wr_address(wr_address),
               .wr_data(wr_data),
               .read(read),
               .rd_address(rd_address),
               .rd_data(rd_data));

parameter INIT_PHASE = 1'b0,
          DATA_PHASE = 1'b1; 

always @(posedge clk)
begin
   if (read==1)
      read_reg <= read_data;
   if (wr_en==1)
      clk_dpram <= clk;

   else
      clk_dpram <= 1'b0;

end
   
//DPRAM READ, MODE SET
always @(posedge clk or negedge reset)
begin
   if (~reset)
     begin
       mode       <= 2'b0;
       init_done  <= 1'b0;
       state      <= INIT_PHASE; 
       read       <= 1'b0;
       rd_address <= 6'b0;
    end
   else
    begin
       if (enable==1'b1)
       begin
           case(state)
                INIT_PHASE:
                begin
                   if (counter == 24'h8FFFFF)
                    begin
                       mode      <= 2'b00;
                       state     <= DATA_PHASE;      
                       init_done <= 1'b0;
                    end             
                   else if (counter == 24'h00000)
                    begin
                       state     <= INIT_PHASE;
                       mode      <= 2'b00;
                       init_done <= 1'b0;
                       data_out  <= 8'h3c;           // function set 0x3c
                    end
                   else if (counter == 24'h4FFFFF)
                    begin
                       state     <= INIT_PHASE;
                        mode     <= 2'b00;
                       init_done <= 1'b0;
                       data_out  <= 8'h0c;           // display ON, cursor ON 0x0c
                    end
                   else if (counter == 24'h5FFFFF)
                    begin
                       state     <= INIT_PHASE;
                       mode      <= 2'b00;
                       init_done <= 1'b0;
                       data_out  <= 8'h06;           //  cursor home 0x06 
                    end
                   else if (counter == 24'h6FFFFF)
                    begin
                       state     <= INIT_PHASE;
                       mode      <= 2'b00;
                       init_done <= 1'b0;
                       data_out  <= 8'h01;           // display clear 0x01
                    end
                 end          
              DATA_PHASE:
               begin 
                  if (data_cnt == 0)
                   begin
                      state      <= DATA_PHASE;
                      mode      <= 2'b00;
                      init_done  <= 1'b1;
                      read       <= 1'b0;
                      data_out   <= 8'h80;           // line 1 address
                   end
                  else if (data_cnt < 21)
                   begin

                         state      <= DATA_PHASE;
                         read       <= 1'b1;
                         mode      <= 2'b10;
                         rd_address <= data_cnt;
                        data_out   <= rd_data;         // line 1 data
                   end
                  else if (data_cnt == 21)
                   begin
                         state      <= DATA_PHASE;
                         mode       <= 2'b00;
                         read       <= 1'b0; 
                         data_out   <= 8'hC0;           // line 2 address
                   end
                  else if (data_cnt < 42 && data_cnt>21)
                   begin
                         state      <= DATA_PHASE;
                         read       <= 1'b1;
                         mode      <= 2'b10;
                         rd_address <= data_cnt;
                         data_out   <= rd_data;         // line 2 data
                   end
                  else if (data_cnt < 64 && data_cnt>41)
                   begin
                         state      <= DATA_PHASE;
                         read       <= 1'b0;
                         mode       <= 2'b00;
                         data_out   <= 8'd2;         // delay  
                   end                      
                   else if (data_cnt>63)
                    begin
                       state     <= DATA_PHASE;
                       mode      <= 2'b0;
                       init_done <= 1'b0;
                       read      <= 1'b0; 
                       data_out  <= 8'h01;           // display clear 0x01
                    end
               end
           endcase
      end
   end
end

// counter
always @(posedge clk or negedge reset)
begin
   if (~reset)
   begin
       counter <= 22'h0;
        lcd_en  <= 1'b1;
   end
   else
   begin
       counter <= counter + 1;
       lcd_en  <= ~ counter[14];
   end
end
   
          
endmodule                 

  


module en_8051 (
rst            ,
SEL_8051_ST_EN ,
SCAN_TEST_MODE ,
clk            ,
p0_in          ,
p1_in          ,
p2_in          ,
p3_in          ,
p0_out         ,
p1_out         ,
p2_out         ,
p3_out         ,
p0_con         ,
p1_con         ,
p2_con         ,
p3_con         ,

rxdi           ,
int_0          ,
int_1          ,
txdo           ,

rom_data_i     ,
rom_addr_o     ,

ram_data_i      ,
ram_data_o      ,
ram_addr_o      ,
ram_wr_o        ,

ext_data_i      ,
ext_data_o      ,
ext_data_addr   ,
ext_data_rd     , 
ext_data_wr      );

input            clk, rst, int_0, int_1;
input            rxdi;
input            SCAN_TEST_MODE, SEL_8051_ST_EN;
input   [7:0]    p0_in;
input   [7:0]    p1_in;
input   [7:0]    p2_in;
input   [7:0]    p3_in;
input   [7:0]    rom_data_i, ram_data_i, ext_data_i;

output  [7:0]    p0_out, p1_out, p2_out, p3_out;
output  [7:0]    p0_con, p1_con, p2_con, p3_con;
output  [15:0]   rom_addr_o, ext_data_addr;
output  [7:0]    ram_addr_o, ram_data_o, ext_data_o;
output           txdo, ram_wr_o, ext_data_wr, ext_data_rd;

// Register define
reg      [15:0]  ext_data_addr;
reg      [7:0]   xaddr_low;
reg              ale_d1;
reg              ram_data_cs, wr_xdat_d1;

// Wire & assignment define
wire     [15:0]  rom_addr_o;
wire     [7:0]   rom_data_i;
wire     [7:0]   ram_addr_o, ram_data_o, ram_data_i;
wire     [7:0]   xaddr_high, ext_data_o, ext_data_i;
wire     [7:0]   p0_en, p1_en, p2_en, p3_en;
wire     [7:0]   p0_i, p1_i, p2_i, p3_i;
wire     [7:0]   p0_o, p1_o, p2_o, p3_o;
wire             rd_idat, ram_wr_o;
wire             ext_data_rd, ext_data_wr;
wire             ale, xdat_en, psen;
wire             rxdo, txdo, sel_code_xdat;
wire             rst_8051;


// Ale delay
always @(posedge clk or negedge rst) begin
   if(rst == 1'b0) begin
      ale_d1 <= 1'b0;
   end
   else begin
      ale_d1 <= ale;
   end
end

// External sram low address
always @(posedge clk or negedge rst) begin
   if(rst == 1'b0) begin
      xaddr_low <= 8'd0;
   end
   else if(ale_d1 == 1'b1) begin
      xaddr_low <= ext_data_o;
   end
   else begin
      xaddr_low <=  xaddr_low;
   end
end

// External sram address
always @(posedge clk or negedge rst) begin
   if(rst == 1'b0) begin
      ext_data_addr <= 16'd0;
   end
   else begin
      ext_data_addr <= {xaddr_high, xaddr_low};
   end
end

// External data , en signal
always @(posedge clk or negedge rst) begin
   if(rst == 1'b0) begin
      ram_data_cs <= 1'b1;
      wr_xdat_d1  <= 1'b1;
   end
   else begin
      ram_data_cs <= ext_data_wr & ext_data_rd;
      wr_xdat_d1  <= ext_data_wr;
   end
end

assign rst_8051 = (SCAN_TEST_MODE) ? rst : ~{SEL_8051_ST_EN|rst} ;

u_cpu u_cpu(
.clk                ( clk                      ),
.rst_p              ( rst_8051                 ),
.in_xrom_a          ( rom_data_i               ),
.in_idat_a          ( ram_data_i               ),
.in_xdat_a          ( ext_data_i               ),
.p0_in              ( p0_in                    ),
.p1_in              ( p1_in                    ),
.p2_in              ( p2_in                    ),
.p3_in              ( p3_in                    ),
.rxdi               ( rxdi                     ),
.t0_pin             ( 1'b1                     ),
.t1_pin             ( 1'b1                     ),
.int0_pin           ( int_0                    ),
.int1_pin           ( int_1                    ),
.addr_xrom_a        ( rom_addr_o               ),
.addr_a             ( ram_addr_o               ),
.out_idat           ( ram_data_o               ),
.wr_idat            ( ram_wr_o                 ),
.rd_idat            ( rd_idat                  ),
.xaddr_high         ( xaddr_high               ),
.out_xdat           ( ext_data_o               ),
.ale                ( ale                      ),
.p0_out             ( p0_out                   ),
.p1_out             ( p1_out                   ),
.p2_out             ( p2_out                   ),
.p3_out             ( p3_out                   ),
.p0_en              ( p0_con                   ),
.p1_en              ( p1_con                   ),
.p2_en              ( p2_con                   ),
.p3_en              ( p3_con                   ),
.psen               ( psen                     ),
.xdat_en            ( xdat_en                  ),
.wr_xdat            ( ext_data_wr              ),
.rd_xdat            ( ext_data_rd              ),
.rxdo               ( rxdo                     ),
.txdo               ( txdo                     ),
.sel_code_xdat      ( sel_code_xdat            ));


endmodule


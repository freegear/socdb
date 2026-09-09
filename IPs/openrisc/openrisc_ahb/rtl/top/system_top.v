// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : system_top.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose             : openrisc ahb platform system top module
//  --========================================================================--

`timescale 1ns/1ps

module system_top (
		RESETn   ,
		CLK
);

input         RESETn;
input         CLK;

wire [31:0] HRDATA_M;
wire        HREADY_M;
wire [1:0]  HRESP_M;

wire        HBUSREQ_M0;
wire        HGRANT_M0;
wire        HLOCK_M0;
wire        HSPLIT_M0;
wire [31:0] HADDR_M0;
wire [1:0]  HTRANS_M0;
wire        HWRITE_M0;
wire [2:0]  HSIZE_M0;
wire [2:0]  HBURST_M0;
wire [3:0]  HPROT_M0;
wire [31:0] HWDATA_M0;

wire        HBUSREQ_M1;
wire        HGRANT_M1;
wire        HLOCK_M1;
wire        HSPLIT_M1;
wire [31:0] HADDR_M1;
wire [1:0]  HTRANS_M1;
wire        HWRITE_M1;
wire [2:0]  HSIZE_M1;
wire [2:0]  HBURST_M1;
wire [3:0]  HPROT_M1;
wire [31:0] HWDATA_M1;

wire        HBUSREQ_M2;
wire        HGRANT_M2;
wire        HLOCK_M2;
wire        HSPLIT_M2;
wire [31:0] HADDR_M2;
wire [1:0]  HTRANS_M2;
wire        HWRITE_M2;
wire [2:0]  HSIZE_M2;
wire [2:0]  HBURST_M2;
wire [3:0]  HPROT_M2;
wire [31:0] HWDATA_M2;

wire        HBUSREQ_M3;
wire        HGRANT_M3;
wire        HLOCK_M3;
wire        HSPLIT_M3;
wire [31:0] HADDR_M3;
wire [1:0]  HTRANS_M3;
wire        HWRITE_M3;
wire [2:0]  HSIZE_M3;
wire [2:0]  HBURST_M3;
wire [3:0]  HPROT_M3;
wire [31:0] HWDATA_M3;

wire [31:0] HADDR_S;
wire [1:0]  HTRANS_S;
wire        HWRITE_S;
wire [2:0]  HSIZE_S;
wire [2:0]  HBURST_S;
wire [3:0]  HPROT_S;
wire [31:0] HWDATA_S;
wire        HMASTLOCK_S;
wire        HMASTER_S;
wire        HREADY_S;

wire        HSEL_S0;
wire [31:0] HRDATA_S0;
wire        HREADY_S0;
wire [1:0]  HRESP_S0;
wire [3:0]  HSPLIT_S0;

wire        HSEL_S1;
wire [31:0] HRDATA_S1;
wire        HREADY_S1;
wire [1:0]  HRESP_S1;
wire [3:0]  HSPLIT_S1;

wire        HSEL_S2;
wire [31:0] HRDATA_S2;
wire        HREADY_S2;
wire [1:0]  HRESP_S2;
wire [3:0]  HSPLIT_S2;

wire        HSEL_S3;
wire [31:0] HRDATA_S3;
wire        HREADY_S3;
wire [1:0]  HRESP_S3;
wire [3:0]  HSPLIT_S3;

wire RESET = ~RESETn;	// active high reset for or1200

AHB bus (
		.HCLK(CLK),
		.HRESETn(RESETn),

		// Master Common
		.HRDATA_M(HRDATA_M),
		.HREADY_M(HREADY_M),
		.HRESP_M(HRESP_M),

		// Master 0 : default Master
		.HBUSREQ_M0(HBUSREQ_M0),
		.HGRANT_M0(HGRANT_M0),
		.HLOCK_M0(HLOCK_M0),
		.HSPLIT_M0(HSPLIT_M0),
		.HADDR_M0(HADDR_M0),
		.HTRANS_M0(HTRANS_M0),
		.HWRITE_M0(HWRITE_M0),
		.HSIZE_M0(HSIZE_M0),
		.HBURST_M0(HBURST_M0),
		.HPROT_M0(HPROT_M0),
		.HWDATA_M0(HWDATA_M0),

		// Master 1
		.HBUSREQ_M1(HBUSREQ_M1),
		.HGRANT_M1(HGRANT_M1),
		.HLOCK_M1(HLOCK_M1),
		.HSPLIT_M1(HSPLIT_M1),
		.HADDR_M1(HADDR_M1),
		.HTRANS_M1(HTRANS_M1),
		.HWRITE_M1(HWRITE_M1),
		.HSIZE_M1(HSIZE_M1),
		.HBURST_M1(HBURST_M1),
		.HPROT_M1(HPROT_M1),
		.HWDATA_M1(HWDATA_M1),

		// Master 2
		.HBUSREQ_M2(HBUSREQ_M2),
		.HGRANT_M2(HGRANT_M2),
		.HLOCK_M2(HLOCK_M2),
		.HSPLIT_M2(HSPLIT_M2),
		.HADDR_M2(HADDR_M2),
		.HTRANS_M2(HTRANS_M2),
		.HWRITE_M2(HWRITE_M2),
		.HSIZE_M2(HSIZE_M2),
		.HBURST_M2(HBURST_M2),
		.HPROT_M2(HPROT_M2),
		.HWDATA_M2(HWDATA_M2),

		// Master 3
		.HBUSREQ_M3(HBUSREQ_M3),
		.HGRANT_M3(HGRANT_M3),
		.HLOCK_M3(HLOCK_M3),
		.HSPLIT_M3(HSPLIT_M3),
		.HADDR_M3(HADDR_M3),
		.HTRANS_M3(HTRANS_M3),
		.HWRITE_M3(HWRITE_M3),
		.HSIZE_M3(HSIZE_M3),
		.HBURST_M3(HBURST_M3),
		.HPROT_M3(HPROT_M3),
		.HWDATA_M3(HWDATA_M3),

		// Slave Common
		.HADDR_S(HADDR_S),
		.HTRANS_S(HTRANS_S),
		.HWRITE_S(HWRITE_S),
		.HSIZE_S(HSIZE_S),
		.HBURST_S(HBURST_S),
		.HPROT_S(HPROT_S),
		.HWDATA_S(HWDATA_S),
		.HMASTLOCK_S(HMASTLOCK_S),
		.HMASTER_S(HMASTER_S),
		.HREADY_S(HREADY_S),

		// Slave 0
		.HSEL_S0(HSEL_S0),
		.HRDATA_S0(HRDATA_S0),
		.HREADY_S0(HREADY_S0),
		.HRESP_S0(HRESP_S0),
		.HSPLIT_S0(HSPLIT_S0),

		// Slave 1
		.HSEL_S1(HSEL_S1),
		.HRDATA_S1(HRDATA_S1),
		.HREADY_S1(HREADY_S1),
		.HRESP_S1(HRESP_S1),
		.HSPLIT_S1(HSPLIT_S1),

		// Slave 2
		.HSEL_S2(HSEL_S2),
		.HRDATA_S2(HRDATA_S2),
		.HREADY_S2(HREADY_S2),
		.HRESP_S2(HRESP_S2),
		.HSPLIT_S2(HSPLIT_S2),

		// Slave 3
		.HSEL_S3(HSEL_S3),
		.HRDATA_S3(HRDATA_S3),
		.HREADY_S3(HREADY_S3),
		.HRESP_S3(HRESP_S3),
		.HSPLIT_S3(HSPLIT_S3)
);

// AHB Master 1/Master 2 : or1200
wire [19:0] Interrupts = 0;

assign HLOCK_M1 = 0;
assign HLOCK_M2 = 0;

or1200_top openrisc(
		// System
		.clk_i(CLK),
		.rst_i(RESET),
		.pic_ints_i(Interrupts),

		// Instruction AHB INTERFACE
		.ihbusreq_o(HBUSREQ_M1),
		.ihgrant_i(HGRANT_M1),
		.ihaddr_o(HADDR_M1),
		.ihtrans_o(HTRANS_M1),
		.ihwrite_o(HWRITE_M1),
		.ihsize_o(HSIZE_M1),
		.ihburst_o(HBURST_M1),
		.ihprot_o(HPROT_M1),
		.ihwdata_o(HWDATA_M1),
		.ihrdata_i(HRDATA_M),
		.ihready_i(HREADY_M),
		.ihresp_i(HRESP_M),

		// Data AHB INTERFACE
		.dhbusreq_o(HBUSREQ_M2),
		.dhgrant_i(HGRANT_M2),
		.dhaddr_o(HADDR_M2),
		.dhtrans_o(HTRANS_M2),
		.dhwrite_o(HWRITE_M2),
		.dhsize_o(HSIZE_M2),
		.dhburst_o(HBURST_M2),
		.dhprot_o(HPROT_M2),
		.dhwdata_o(HWDATA_M2),
		.dhrdata_i(HRDATA_M),
		.dhready_i(HREADY_M),
		.dhresp_i(HRESP_M),

		// External Debug Interface
		.dbg_stall_i(1'b0),
		.dbg_ewt_i(1'b0),
		.dbg_lss_o(),
		.dbg_is_o(),
		.dbg_wp_o(),
		.dbg_bp_o(),
		.dbg_stb_i(1'b0),
		.dbg_we_i(1'b0),
		.dbg_adr_i(32'd0),
		.dbg_dat_i(32'd0),
		.dbg_dat_o(),
		.dbg_ack_o(),
	
		// Power Management
		.pm_cpustall_i(1'b0),
		.pm_clksd_o(),
		.pm_dc_gate_o(),
		.pm_ic_gate_o(),
		.pm_dmmu_gate_o(), 
		.pm_immu_gate_o(),
		.pm_tt_gate_o(),
		.pm_cpu_gate_o(),
		.pm_wakeup_o(),
		.pm_lvolt_o()
);

// AHB Master 0/Master 3 : not connected
`define IDLE 2'b00

assign HBUSREQ_M0 = 0;
assign HLOCK_M0 = 0;
assign HADDR_M0 = 0;
assign HTRANS_M0 = `IDLE;
assign HWRITE_M0 = 0;
assign HSIZE_M0 = 0;
assign HBURST_M0 = 0;
assign HPROT_M0 = 0;
assign HWDATA_M0 = 0;

assign HBUSREQ_M3 = 0;
assign HLOCK_M3 = 0;
assign HADDR_M3 = 0;
assign HTRANS_M3 = `IDLE;
assign HWRITE_M3 = 0;
assign HSIZE_M3 = 0;
assign HBURST_M3 = 0;
assign HPROT_M3 = 0;
assign HWDATA_M3 = 0;

// AHB Slave 0 : Synchronous SRAM Controller
wire        ram_csb;
wire [18:0] ram_addr;
wire [3:0]  ram_wrb;
wire        ram_oeb;
wire [31:0] ram_q;
wire [31:0] ram_d;

ismc_ahb #(.ADDR_WIDTH(21)) ram_ctrl(	// 2MB RAM @ 0x00000000
	.clk(CLK),
	.rstb(RESETn),

	.ahb_sel(HSEL_S0),
	.ahb_readyin(HREADY_S),
	.ahb_htrans(HTRANS_S),
	.ahb_addr(HADDR_S[20:0]),
	.ahb_write(HWRITE_S),
	.ahb_size(HSIZE_S),
	.ahb_wdata(HWDATA_S),
	.ahb_rdata(HRDATA_S0),
	.ahb_ready(HREADY_S0),
	.ahb_resp(HRESP_S0),
	
	.sram_csb(ram_csb),
	.sram_addr(ram_addr),
	.sram_wrb(ram_wrb),
	.sram_oeb(ram_oeb),
	.sram_dout(ram_q),
	.sram_din(ram_d)
);
assign HSPLIT_S0 = 0;

ram512Kx32 #(.ADDR_WIDTH(19), .Load(1)) ram(
	.clk(CLK),
	.rstb(RESETn),

	.csb(ram_csb),
	.addr(ram_addr),
	.wrb(ram_wrb),
	.oeb(ram_oeb),
	.dout(ram_q),
	.din(ram_d)
);


wire        rom_csb;
wire [18:0] rom_addr;
wire [3:0]  rom_wrb;
wire        rom_oeb;
wire [31:0] rom_q;
wire [31:0] rom_d;

// AHB Slave 1 : Synchronous SRAM Controller
ismc_ahb #(.ADDR_WIDTH(21)) rom_ctrl(	// 2MB RAM @ 0x00000000
	.clk(CLK),
	.rstb(RESETn),

	.ahb_sel(HSEL_S1),
	.ahb_readyin(HREADY_S),
	.ahb_htrans(HTRANS_S),
	.ahb_addr(HADDR_S[20:0]),
	.ahb_write(HWRITE_S),
	.ahb_size(HSIZE_S),
	.ahb_wdata(HWDATA_S),
	.ahb_rdata(HRDATA_S1),
	.ahb_ready(HREADY_S1),
	.ahb_resp(HRESP_S1),
	
	.sram_csb(rom_csb),
	.sram_addr(rom_addr),
	.sram_wrb(rom_wrb),
	.sram_oeb(rom_oeb),
	.sram_dout(rom_q),
	.sram_din(rom_d)
);
assign HSPLIT_S1 = 0;

ram512Kx32 #(.ADDR_WIDTH(19), .Load(0)) rom(
	.clk(CLK),
	.rstb(RESETn),

	.csb(rom_csb),
	.addr(rom_addr),
	.wrb(rom_wrb),
	.oeb(rom_oeb),
	.dout(rom_q),
	.din(rom_d)
);

// AHB Slave 2 : default AHB slave
DefaultSlave default_slave0(
	.HCLK(CLK),
	.HRESETn(RESETn),

	.HTRANS(HTRANS_S),
	.HSEL(HSEL_S2),
	.HREADY(HREADY_S),
	.HREADYOUT(HREADY_S2),
	.HRESP(HRESP_S2)
);
assign HRDATA_S2 = 0;
assign HSPLIT_S2 = 0;

// AHB Slave 3 : default AHB slave
DefaultSlave default_slave1(
	.HCLK(CLK),
	.HRESETn(RESETn),

	.HTRANS(HTRANS_S),
	.HSEL(HSEL_S3),
	.HREADY(HREADY_S),
	.HREADYOUT(HREADY_S3),
	.HRESP(HRESP_S3)
);
assign HRDATA_S3 = 0;
assign HSPLIT_S3 = 0;

endmodule

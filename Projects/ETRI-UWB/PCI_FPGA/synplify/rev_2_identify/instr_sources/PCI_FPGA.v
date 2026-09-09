
// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : ETRI_UWBFPGA.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : ETRI UWB Top module for FPGA implementaion
// --========================================================================--

`timescale 1ns/1ps
module PCI_FPGA
  (
        Clk,
        nRst,
        led,
        sw,
        SevenSegCtrl,
        SevenSegComm,
        
   // System Reset & CLK
        CLK33M,
        nRESET,

        adin,
        adout,
        arb_gnt_b,
        arb_req_b,
        cbein_b,
        cbeout_b,
        devselin_b,
        devselout_b,
        framein_b,
        frameout_b,
//        gnt_b,
        idsel,
        intaout_b,
        irdyin_b,
        irdyout_b,
        parin,
        parout,
        perrin_b,
        perrout_b,
//        reqout_b,
        serrout_b,
        stopin_b,
        stopout_b,
        trdyin_b,
        trdyout_b,
        oe_ad,
        oe_cbe,
        oe_devsel,
        oe_frame,
        oe_irdy,
        oe_par,
        oe_perr,
        oe_req,
        oe_stop,
        oe_trdy,

        PCI_INTAb,
        PCI_INTBb,
        PCI_INTCb,
        PCI_INTDb,

        // PCI
        PCI_CLK,
        PCI_RESET,
        PCI_AD,
        PCI_GNT,
        PCI_REQ,
        PCI_CBE,
        PCI_DEVSEL,
        PCI_FRAME,
        PCI_IDSEL,
        PCI_IRDY,
        PCI_PAR,
        PCI_PERR,
        PCI_SERR,
        PCI_STOP,
        PCI_TRDY,
        PCI_INTA,
        PCI_INTB,
        PCI_INTC,
        PCI_INTD,
        PCI_M66EN
        

); wire [0:157] uplink_3_a; wire [0:9] comm2iice_link_iice_0_a_0; wire [0:0] iice2comm_link_iice_0_a_0;
input         Clk;
input         nRst;
output [3:0]  led;
input  [3:0]  sw;

output [7:0]  SevenSegCtrl;
output [3:0]  SevenSegComm;

output        CLK33M;
input         nRESET;

// PCI 
output[31:0]  adin;
input [31:0]  adout;
input [4:1]   arb_gnt_b;
output[4:1]   arb_req_b;
output[3:0]   cbein_b;
input [3:0]   cbeout_b;
output        devselin_b;
input         devselout_b;
output        framein_b;
input         frameout_b;
//output        gnt_b;
output        idsel;
input         intaout_b;
output        irdyin_b;
input         irdyout_b;
output        parin;
input         parout;
output        perrin_b;
input         perrout_b;
//input         reqout_b;
input         serrout_b;
output        stopin_b;
input         stopout_b;
output        trdyin_b;
input         trdyout_b;
input         oe_ad;
input         oe_cbe;
input         oe_devsel;
input         oe_frame;
input         oe_irdy;
input         oe_par;
input         oe_perr;
input         oe_req;
input         oe_stop;
input         oe_trdy;

output        PCI_INTAb;
output        PCI_INTBb;
output        PCI_INTCb;
output        PCI_INTDb;

// PCI 
output[3:0]   PCI_CLK;
output        PCI_RESET;
inout [31:0]  PCI_AD;
output[ 4:1]  PCI_GNT;
input [ 4:1]  PCI_REQ;
inout [ 3:0]  PCI_CBE;
inout         PCI_DEVSEL;
inout         PCI_FRAME;
output[ 3:0]  PCI_IDSEL;
inout         PCI_IRDY;
inout         PCI_PAR;
inout         PCI_PERR;
output        PCI_SERR;
inout         PCI_STOP;
inout         PCI_TRDY;

input         PCI_INTA;
input         PCI_INTB;
input         PCI_INTC;
input         PCI_INTD;
output        PCI_M66EN;

assign PCI_M66EN = 1'b0;

assign idsel = adout[11];

assign        PCI_GNT = arb_gnt_b[4:1];
assign        arb_req_b = PCI_REQ;

reg pci_clk;
reg[3:0] div_cnt;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) div_cnt <=0;
    else begin
        div_cnt <= div_cnt + 1'b1;
    end
end
always @(sw or div_cnt or Clk) 
begin
    case(sw)
        4'b0001 : pci_clk = div_cnt[0]; // 1/2
        4'b0010 : pci_clk = div_cnt[1]; // 1/4
        4'b0100 : pci_clk = div_cnt[2]; // 1/8
        4'b1000 : pci_clk = div_cnt[3]; // 1/16
        default : pci_clk = Clk;
    endcase
end

wire pci_clkdly; // synthesis syn_keep=1
wire pci_clkdly0; // synthesis syn_keep=1
wire pci_clkdly1; // synthesis syn_keep=1
wire pci_clkdly2; // synthesis syn_keep=1
wire pci_clkdly3; // synthesis syn_keep=1
wire pci_clkdly4; // synthesis syn_keep=1
wire pci_clkdly5; // synthesis syn_keep=1
wire pci_clkdly6; // synthesis syn_keep=1
wire pci_clkdly7; // synthesis syn_keep=1
wire pci_clkdly8; // synthesis syn_keep=1
wire pci_clkdly9; // synthesis syn_keep=1

assign  CLK33M = pci_clk;
assign  PCI_CLK[0] = pci_clk;
assign  PCI_CLK[1] = pci_clk;
assign  PCI_CLK[2] = pci_clk;
assign  PCI_CLK[3] = pci_clk;

/*
BUFG bufio1 (
        .O(pci_clkdly1),
        .I(pci_clkdly0)
    );
BUFG bufio2 (
        .O(pci_clkdly2),
        .I(~pci_clkdly1)
    );
BUFG bufio3 (
        .O(pci_clkdly3),
        .I(~pci_clkdly2)
    );
BUFG bufio4 (
        .O(pci_clkdly4),
        .I(~pci_clkdly3)
    );
*/

assign  PCI_RESET = nRESET;
assign  PCI_SERR = serrout_b;

assign  PCI_IDSEL[0] = (adout[12]==1'b1) ? 1'b1 : 1'b0;
assign  PCI_IDSEL[1] = (adout[13]==1'b1) ? 1'b1 : 1'b0;
assign  PCI_IDSEL[2] = (adout[14]==1'b1) ? 1'b1 : 1'b0;
assign  PCI_IDSEL[3] = (adout[15]==1'b1) ? 1'b1 : 1'b0;

// PCI
tri [31:0]  PCI_AD;
tri [ 3:0]  PCI_CBE;
tri         PCI_DEVSEL;
tri         PCI_FRAME;
tri         PCI_IRDY;
tri         PCI_PAR;
tri         PCI_PERR;
tri         PCI_STOP;
tri         PCI_TRDY;

assign PCI_AD = (oe_ad) ? adout : {32{1'bz}};
assign adin = PCI_AD;

assign PCI_CBE = (oe_cbe) ? cbeout_b : 4'hz;
assign cbein_b = PCI_CBE;

assign PCI_DEVSEL = (oe_devsel) ? devselout_b : 1'bz;
assign devselin_b = PCI_DEVSEL;

assign PCI_FRAME = (oe_frame) ? frameout_b : 1'bz;
assign framein_b = PCI_FRAME;

assign PCI_IRDY = (oe_irdy) ? irdyout_b : 1'bz;
assign irdyin_b = PCI_IRDY;

assign PCI_PAR = (oe_par) ? parout : 1'bz;
assign parin = PCI_PAR;

assign PCI_PERR = (oe_perr) ? perrout_b : 1'bz;
assign perrin_b = PCI_PERR;

assign PCI_STOP = (oe_stop) ? stopout_b : 1'bz;
assign stopin_b = PCI_STOP;

assign PCI_TRDY = (oe_trdy) ? trdyout_b : 1'bz;
assign trdyin_b = PCI_TRDY;

assign PCI_INTAb = PCI_INTA;
assign PCI_INTBb = PCI_INTB;
assign PCI_INTCb = PCI_INTC;
assign PCI_INTDb = PCI_INTD;

reg[25:0]   cnt;
assign led = cnt[25:22];
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        cnt<={30{1'b0}};
    end
    else begin
        cnt<=cnt+1;
    end
end

SevenSegment SevenSegment (
	.Clock     (Clk         ),
	.nReset    (nRst        ),

	.DataIn    (16'h1231    ),
	.DotIn     (4'h0        ),
	.ControlOut(SevenSegCtrl),
	.CommonOut (SevenSegComm));
comm_block comm_block_inst( .comm2iice_link_iice_0(comm2iice_link_iice_0_a_0), .iice2comm_link_iice_0(iice2comm_link_iice_0_a_0)) /* synthesis syn_noprune=1 */; ldic1_0 ldic1_inst_0( .PCI_AD(PCI_AD), .PCI_CBE(PCI_CBE), .PCI_CLK(PCI_CLK), .PCI_DEVSEL(PCI_DEVSEL), .PCI_FRAME(PCI_FRAME), .PCI_GNT(PCI_GNT), .PCI_IDSEL(PCI_IDSEL), .PCI_INTAb(PCI_INTAb), .PCI_INTBb(PCI_INTBb), .PCI_INTCb(PCI_INTCb), .PCI_INTDb(PCI_INTDb), .PCI_IRDY(PCI_IRDY), .PCI_PAR(PCI_PAR), .PCI_PERR(PCI_PERR), .PCI_REQ(PCI_REQ), .PCI_SERR(PCI_SERR), .PCI_STOP(PCI_STOP), .PCI_TRDY(PCI_TRDY), .adin(adin), .adout(adout), .cbein_b(cbein_b), .cbeout_b(cbeout_b), .devselin_b(devselin_b), .devselout_b(devselout_b), .framein_b(framein_b), .frameout_b(frameout_b), .idsel(idsel), .irdyin_b(irdyin_b), .irdyout_b(irdyout_b), .oe_ad(oe_ad), .oe_cbe(oe_cbe), .oe_devsel(oe_devsel), .oe_frame(oe_frame), .oe_irdy(oe_irdy), .oe_par(oe_par), .oe_perr(oe_perr), .oe_req(oe_req), .oe_stop(oe_stop), .oe_trdy(oe_trdy), .stopin_b(stopin_b), .stopout_b(stopout_b), .trdyin_b(trdyin_b), .trdyout_b(trdyout_b), .Clk(Clk), .uplink_3(uplink_3_a)) /* synthesis syn_noprune=1 */; iice_0 iice_inst_0( .comm2iice_link_iice_0(comm2iice_link_iice_0_a_0), .iice2comm_link_iice_0(iice2comm_link_iice_0_a_0), .mdic_link(uplink_3_a)) /* synthesis syn_noprune=1 */; endmodule



//----------------------------------------------------------------------
//
// Copyright (c) 2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCIM64-AHB
//
//  File          : pcim64ahbw.v
//
//  Dependencies  : 
//
//  Model Type:   : Synthesizable core
//
//  Description   : PCIM64-AHB Interface - Top Level design entity wrapper
//
//  Designer      : AS
//
//  QA Engineer   :  NS 
//
//  Creation Date : 17-September-2003
//
//  Last Update   : 20-November-2003
//
//  Version       : 1.0.2V
//----------------------------------------------------------------------
`timescale 1 ns / 1 ps

module pcim64ahbw (clk_p, rstn_p, idsel_p, gntn_p, reqn_p, intan_p, serrn_p, par_p, par64_p, framen_p, req64n_p, irdyn_p,
                   trdyn_p, devseln_p, ack64n_p, stopn_p, perrn_p, ad_p, cbe_p,
                   hclk,hresetn,mhaddr,mhbusreq,mhlock,mhgrant,mhwrite,mhtrans,mhsize,mhprot,mhburst,mhready,mhresp,mhrdata,mhwdata,
                   shsel,shwrite,shtrans,shsize,shburst,shaddr,shready,shresp,shrdata,shwdata,hint
                 );

   input clk_p; 
   input rstn_p; 
   input idsel_p; 
   input gntn_p; 
   output reqn_p; 
   wire reqn_p;
   output intan_p; 
   wire intan_p;
   output serrn_p; 
   wire serrn_p;
   inout par_p; 
   wire par_p;
   inout par64_p; 
   wire par64_p;
   inout framen_p; 
   wire framen_p;
   inout req64n_p; 
   wire req64n_p;
   inout irdyn_p; 
   wire irdyn_p;
   inout trdyn_p; 
   wire trdyn_p;
   inout devseln_p; 
   wire devseln_p;
   inout ack64n_p; 
   wire ack64n_p;
   inout stopn_p; 
   wire stopn_p;
   inout perrn_p; 
   wire perrn_p;
   inout[63:0] ad_p; 
   wire[63:0] ad_p;
   inout[7:0] cbe_p; 
   wire[7:0] cbe_p;
   //
   input hclk;                      
   input hresetn;                   
   input mhgrant;                   
   input mhready;                   
   input[1:0] mhresp;               
   input[31:0] mhrdata;
   input shsel;
   input shwrite;                   // AHB operation is write
   input[1:0] shtrans;              // AHB transfer type
   input[2:0] shsize;               // AHB transfer size
   input[2:0] shburst;              // AHB  burst type
   input[31:0] shaddr;              // AHB address
   input[31:0] shwdata;
   output mhbusreq;             
   wire mhbusreq; 
   output mhlock;               
   wire mhlock;
   output mhwrite;              
   wire mhwrite;
   output[1:0] mhtrans;         
   wire[1:0] mhtrans;
   output[2:0] mhsize;         
   wire[2:0] mhsize;
   output[3:0] mhprot;         
   wire[3:0] mhprot;
   output[2:0] mhburst;        
   wire[2:0] mhburst;
   output[31:0] mhaddr; 
   wire[31:0] mhaddr;  
   output[31:0] mhwdata;
   wire[31:0] mhwdata;
   output shready;                   // AHB slave ready 
   wire shready;
   output[1:0] shresp;               // AHB slave response (00 = OKAY, 01 = ERROR, 10 = RETRY, 11 = SPLIT)
   wire [1:0] shresp;
   output[31:0] shrdata;
   wire[31:0] shrdata;
   output hint;
   wire hint;
   //
   wire clkpci; 
   wire rstpcin; 
   wire[63:0] adi; 
   wire[7:0] cbei; 
   wire pari; 
   wire par64i; 
   wire idseli; 
   wire gntni; 
   wire frameni; 
   wire req64ni; 
   wire irdyni; 
   wire devselni; 
   wire ack64ni; 
   wire trdyni; 
   wire stopni; 
   wire perrni; 
   wire reqno; 
   wire frameno; 
   wire req64no; 
   wire irdyno; 
   wire devselno; 
   wire ack64no; 
   wire trdyno; 
   wire stopno; 
   wire ot_frame; 
   wire ot_req64; 
   wire ot_irdy; 
   wire ot_devsel; 
   wire ot_ack64; 
   wire ot_trdy; 
   wire ot_stop; 
   wire intano; 
   wire paro; 
   wire par64o; 
   wire perrno; 
   wire serrno; 
   wire ot_perr; 
   wire ot_par; 
   wire ot_par64; 
   wire[63:0] ado; 
   wire[63:0] ot_ad; 
   wire[7:0] cbeo; 
   wire[7:0] ot_cbe; 

   pci_gclkbuf uclkbuf (.i(clk_p), .o(clkpci)); 

   pci_ibuf urst (.i(rstn_p), .o(rstpcin)); 

   pci_ibuf uidsel (.i(idsel_p), .o(idseli)); 

   pci_iobuf uframe (.i(frameno), .t(ot_frame), .o(frameni), .iopci(framen_p)); 

   pci_iobuf ureq64 (.i(req64no), .t(ot_req64), .o(req64ni), .iopci(req64n_p)); 

   pci_iobuf uirdy (.i(irdyno), .t(ot_irdy), .o(irdyni), .iopci(irdyn_p)); 

   pci_iobuf udevsel (.i(devselno), .t(ot_devsel), .o(devselni), .iopci(devseln_p)); 

   pci_iobuf uack64 (.i(ack64no), .t(ot_ack64), .o(ack64ni), .iopci(ack64n_p)); 

   pci_iobuf utrdy (.i(trdyno), .t(ot_trdy), .o(trdyni), .iopci(trdyn_p)); 

   pci_iobuf ustop (.i(stopno), .t(ot_stop), .o(stopni), .iopci(stopn_p)); 

   pci_iobuf uparb (.i(paro), .t(ot_par), .o(pari), .iopci(par_p)); 

   pci_iobuf upar64b (.i(par64o), .t(ot_par64), .o(par64i), .iopci(par64_p)); 

   pci_iobuf uperrb (.i(perrno), .t(ot_perr), .o(perrni), .iopci(perrn_p)); 

   pci_obufoc userrb (.i(serrno), .o(serrn_p)); 

   pci_obuf ureqb (.i(reqno), .o(reqn_p)); 

   pci_ibuf ugntb (.i(gntn_p), .o(gntni)); 

   pci_obufoc uintab (.i(intano), .o(intan_p)); 

   pci_iobuf uadb0 (.i(ado[0]), .t(ot_ad[0]), .o(adi[0]), .iopci(ad_p[0])); 

   pci_iobuf uadb1 (.i(ado[1]), .t(ot_ad[1]), .o(adi[1]), .iopci(ad_p[1])); 

   pci_iobuf uadb2 (.i(ado[2]), .t(ot_ad[2]), .o(adi[2]), .iopci(ad_p[2])); 

   pci_iobuf uadb3 (.i(ado[3]), .t(ot_ad[3]), .o(adi[3]), .iopci(ad_p[3])); 

   pci_iobuf uadb4 (.i(ado[4]), .t(ot_ad[4]), .o(adi[4]), .iopci(ad_p[4])); 

   pci_iobuf uadb5 (.i(ado[5]), .t(ot_ad[5]), .o(adi[5]), .iopci(ad_p[5])); 

   pci_iobuf uadb6 (.i(ado[6]), .t(ot_ad[6]), .o(adi[6]), .iopci(ad_p[6])); 

   pci_iobuf uadb7 (.i(ado[7]), .t(ot_ad[7]), .o(adi[7]), .iopci(ad_p[7])); 

   pci_iobuf uadb8 (.i(ado[8]), .t(ot_ad[8]), .o(adi[8]), .iopci(ad_p[8])); 

   pci_iobuf uadb9 (.i(ado[9]), .t(ot_ad[9]), .o(adi[9]), .iopci(ad_p[9])); 

   pci_iobuf uadb10 (.i(ado[10]), .t(ot_ad[10]), .o(adi[10]), .iopci(ad_p[10])); 

   pci_iobuf uadb11 (.i(ado[11]), .t(ot_ad[11]), .o(adi[11]), .iopci(ad_p[11])); 

   pci_iobuf uadb12 (.i(ado[12]), .t(ot_ad[12]), .o(adi[12]), .iopci(ad_p[12])); 

   pci_iobuf uadb13 (.i(ado[13]), .t(ot_ad[13]), .o(adi[13]), .iopci(ad_p[13])); 

   pci_iobuf uadb14 (.i(ado[14]), .t(ot_ad[14]), .o(adi[14]), .iopci(ad_p[14])); 

   pci_iobuf uadb15 (.i(ado[15]), .t(ot_ad[15]), .o(adi[15]), .iopci(ad_p[15])); 

   pci_iobuf uadb16 (.i(ado[16]), .t(ot_ad[16]), .o(adi[16]), .iopci(ad_p[16])); 

   pci_iobuf uadb17 (.i(ado[17]), .t(ot_ad[17]), .o(adi[17]), .iopci(ad_p[17])); 

   pci_iobuf uadb18 (.i(ado[18]), .t(ot_ad[18]), .o(adi[18]), .iopci(ad_p[18])); 

   pci_iobuf uadb19 (.i(ado[19]), .t(ot_ad[19]), .o(adi[19]), .iopci(ad_p[19])); 

   pci_iobuf uadb20 (.i(ado[20]), .t(ot_ad[20]), .o(adi[20]), .iopci(ad_p[20])); 

   pci_iobuf uadb21 (.i(ado[21]), .t(ot_ad[21]), .o(adi[21]), .iopci(ad_p[21])); 

   pci_iobuf uadb22 (.i(ado[22]), .t(ot_ad[22]), .o(adi[22]), .iopci(ad_p[22])); 

   pci_iobuf uadb23 (.i(ado[23]), .t(ot_ad[23]), .o(adi[23]), .iopci(ad_p[23])); 

   pci_iobuf uadb24 (.i(ado[24]), .t(ot_ad[24]), .o(adi[24]), .iopci(ad_p[24])); 

   pci_iobuf uadb25 (.i(ado[25]), .t(ot_ad[25]), .o(adi[25]), .iopci(ad_p[25])); 

   pci_iobuf uadb26 (.i(ado[26]), .t(ot_ad[26]), .o(adi[26]), .iopci(ad_p[26])); 

   pci_iobuf uadb27 (.i(ado[27]), .t(ot_ad[27]), .o(adi[27]), .iopci(ad_p[27])); 

   pci_iobuf uadb28 (.i(ado[28]), .t(ot_ad[28]), .o(adi[28]), .iopci(ad_p[28])); 

   pci_iobuf uadb29 (.i(ado[29]), .t(ot_ad[29]), .o(adi[29]), .iopci(ad_p[29])); 

   pci_iobuf uadb30 (.i(ado[30]), .t(ot_ad[30]), .o(adi[30]), .iopci(ad_p[30])); 

   pci_iobuf uadb31 (.i(ado[31]), .t(ot_ad[31]), .o(adi[31]), .iopci(ad_p[31])); 

   pci_iobuf uadb32 (.i(ado[32]), .t(ot_ad[32]), .o(adi[32]), .iopci(ad_p[32])); 

   pci_iobuf uadb33 (.i(ado[33]), .t(ot_ad[33]), .o(adi[33]), .iopci(ad_p[33])); 

   pci_iobuf uadb34 (.i(ado[34]), .t(ot_ad[34]), .o(adi[34]), .iopci(ad_p[34])); 

   pci_iobuf uadb35 (.i(ado[35]), .t(ot_ad[35]), .o(adi[35]), .iopci(ad_p[35])); 

   pci_iobuf uadb36 (.i(ado[36]), .t(ot_ad[36]), .o(adi[36]), .iopci(ad_p[36])); 

   pci_iobuf uadb37 (.i(ado[37]), .t(ot_ad[37]), .o(adi[37]), .iopci(ad_p[37])); 

   pci_iobuf uadb38 (.i(ado[38]), .t(ot_ad[38]), .o(adi[38]), .iopci(ad_p[38])); 

   pci_iobuf uadb39 (.i(ado[39]), .t(ot_ad[39]), .o(adi[39]), .iopci(ad_p[39])); 

   pci_iobuf uadb40 (.i(ado[40]), .t(ot_ad[40]), .o(adi[40]), .iopci(ad_p[40])); 

   pci_iobuf uadb41 (.i(ado[41]), .t(ot_ad[41]), .o(adi[41]), .iopci(ad_p[41])); 

   pci_iobuf uadb42 (.i(ado[42]), .t(ot_ad[42]), .o(adi[42]), .iopci(ad_p[42])); 

   pci_iobuf uadb43 (.i(ado[43]), .t(ot_ad[43]), .o(adi[43]), .iopci(ad_p[43])); 

   pci_iobuf uadb44 (.i(ado[44]), .t(ot_ad[44]), .o(adi[44]), .iopci(ad_p[44])); 

   pci_iobuf uadb45 (.i(ado[45]), .t(ot_ad[45]), .o(adi[45]), .iopci(ad_p[45])); 

   pci_iobuf uadb46 (.i(ado[46]), .t(ot_ad[46]), .o(adi[46]), .iopci(ad_p[46])); 

   pci_iobuf uadb47 (.i(ado[47]), .t(ot_ad[47]), .o(adi[47]), .iopci(ad_p[47])); 

   pci_iobuf uadb48 (.i(ado[48]), .t(ot_ad[48]), .o(adi[48]), .iopci(ad_p[48])); 

   pci_iobuf uadb49 (.i(ado[49]), .t(ot_ad[49]), .o(adi[49]), .iopci(ad_p[49])); 

   pci_iobuf uadb50 (.i(ado[50]), .t(ot_ad[50]), .o(adi[50]), .iopci(ad_p[50])); 

   pci_iobuf uadb51 (.i(ado[51]), .t(ot_ad[51]), .o(adi[51]), .iopci(ad_p[51])); 

   pci_iobuf uadb52 (.i(ado[52]), .t(ot_ad[52]), .o(adi[52]), .iopci(ad_p[52])); 

   pci_iobuf uadb53 (.i(ado[53]), .t(ot_ad[53]), .o(adi[53]), .iopci(ad_p[53])); 

   pci_iobuf uadb54 (.i(ado[54]), .t(ot_ad[54]), .o(adi[54]), .iopci(ad_p[54])); 

   pci_iobuf uadb55 (.i(ado[55]), .t(ot_ad[55]), .o(adi[55]), .iopci(ad_p[55])); 

   pci_iobuf uadb56 (.i(ado[56]), .t(ot_ad[56]), .o(adi[56]), .iopci(ad_p[56])); 

   pci_iobuf uadb57 (.i(ado[57]), .t(ot_ad[57]), .o(adi[57]), .iopci(ad_p[57])); 

   pci_iobuf uadb58 (.i(ado[58]), .t(ot_ad[58]), .o(adi[58]), .iopci(ad_p[58])); 

   pci_iobuf uadb59 (.i(ado[59]), .t(ot_ad[59]), .o(adi[59]), .iopci(ad_p[59])); 

   pci_iobuf uadb60 (.i(ado[60]), .t(ot_ad[60]), .o(adi[60]), .iopci(ad_p[60])); 

   pci_iobuf uadb61 (.i(ado[61]), .t(ot_ad[61]), .o(adi[61]), .iopci(ad_p[61])); 

   pci_iobuf uadb62 (.i(ado[62]), .t(ot_ad[62]), .o(adi[62]), .iopci(ad_p[62])); 

   pci_iobuf uadb63 (.i(ado[63]), .t(ot_ad[63]), .o(adi[63]), .iopci(ad_p[63])); 

   pci_iobuf ucbeb0 (.i(cbeo[0]), .t(ot_cbe[0]), .o(cbei[0]), .iopci(cbe_p[0])); 

   pci_iobuf ucbeb1 (.i(cbeo[1]), .t(ot_cbe[1]), .o(cbei[1]), .iopci(cbe_p[1])); 

   pci_iobuf ucbeb2 (.i(cbeo[2]), .t(ot_cbe[2]), .o(cbei[2]), .iopci(cbe_p[2])); 

   pci_iobuf ucbeb3 (.i(cbeo[3]), .t(ot_cbe[3]), .o(cbei[3]), .iopci(cbe_p[3])); 

   pci_iobuf ucbeb4 (.i(cbeo[4]), .t(ot_cbe[4]), .o(cbei[4]), .iopci(cbe_p[4])); 

   pci_iobuf ucbeb5 (.i(cbeo[5]), .t(ot_cbe[5]), .o(cbei[5]), .iopci(cbe_p[5])); 

   pci_iobuf ucbeb6 (.i(cbeo[6]), .t(ot_cbe[6]), .o(cbei[6]), .iopci(cbe_p[6])); 

   pci_iobuf ucbeb7 (.i(cbeo[7]), .t(ot_cbe[7]), .o(cbei[7]), .iopci(cbe_p[7])); 
   //
   pcim64ahb u0 (
      .clkpci(clkpci), 
      .rstpcin(rstpcin), 
      .adi(adi), 
      .cbei(cbei), 
      .pari(pari), 
      .par64i(par64i), 
      .idseli(idseli), 
      .gntni(gntni), 
      .frameni(frameni), 
      .req64ni(req64ni), 
      .irdyni(irdyni), 
      .devselni(devselni), 
      .ack64ni(ack64ni), 
      .trdyni(trdyni), 
      .stopni(stopni), 
      .perrni(perrni), 
      .reqno(reqno), 
      .frameno(frameno), 
      .req64no(req64no), 
      .irdyno(irdyno), 
      .devselno(devselno), 
      .ack64no(ack64no), 
      .trdyno(trdyno), 
      .stopno(stopno), 
      .ot_frame(ot_frame), 
      .ot_req64(ot_req64), 
      .ot_irdy(ot_irdy), 
      .ot_devsel(ot_devsel), 
      .ot_ack64(ot_ack64), 
      .ot_trdy(ot_trdy), 
      .ot_stop(ot_stop), 
      .intano(intano), 
      .paro(paro), 
      .par64o(par64o), 
      .perrno(perrno), 
      .serrno(serrno), 
      .ot_perr(ot_perr), 
      .ot_par(ot_par), 
      .ot_par64(ot_par64), 
      .ado(ado), 
      .ot_ad(ot_ad), 
      .cbeo(cbeo), 
      .ot_cbe(ot_cbe),
      .hclk(hclk),
      .hresetn(hresetn),
      .mhaddr(mhaddr),
      .mhbusreq(mhbusreq),
      .mhlock(mhlock),
      .mhgrant(mhgrant),
      .mhwrite(mhwrite),
      .mhtrans(mhtrans),
      .mhsize(mhsize),
      .mhprot(mhprot),
      .mhburst(mhburst),
      .mhready(mhready),
      .mhresp(mhresp),
      .mhrdata(mhrdata),
      .mhwdata(mhwdata),
      .shsel(shsel),
      .shwrite(shwrite),
      .shtrans(shtrans),
      .shsize(shsize),
      .shburst(shburst),
      .shaddr(shaddr),
      .shready(shready),
      .shresp(shresp),
      .shrdata(shrdata),
      .shwdata(shwdata),
      .hint(hint)
   ); 
endmodule

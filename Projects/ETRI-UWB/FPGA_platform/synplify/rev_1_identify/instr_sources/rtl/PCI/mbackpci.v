// ##########################################################################
//
// Copyright (C) 2002 Eureka Technology Inc.
//
// Confidential & Proprietary Information
//
// All Rights Reserved
//
// The use, modification, or duplication of this product is protected
// according to FAR 12.212 and by Eureka's licensing agreement.
// This design contains confidential and proprietary information which
// are the properties of Eureka Technology Inc.
// Unauthorized use, disclosure, duplication, or reproduction are prohibited.
//
// ##########################################################################
//
`timescale 1ns / 100ps

module mbackpci(
db23_wea_word,
h_adsh_b,
h_ain,
h_bein_b,
h_boff_b,
h_cacheline,
h_cmd,
h_done_b,
h_dout,
h_mio,
h_rdym_b,
h_size,
h_wrin,
mack_b,
mrdreq_b,
mrd_abort,
mrd_addra,
mrd_dina,
mwrreq_b,
mwr_addrb,
mwr_beoutb,
pci_adr,
pci_be_b,
pci_cacheline,
pci_cmd,
pci_mio,
pci_size,
pciclk,
reset_b
);
output db23_wea_word;
output h_adsh_b;
output[31:0] h_ain;
output[3:0] h_bein_b;
input h_boff_b;
output h_cacheline;
output[1:0] h_cmd;
input h_done_b;
input[31:0] h_dout;
output h_mio;
input h_rdym_b;
output[15:0] h_size;
output h_wrin;
output mack_b;
input mrdreq_b;
output mrd_abort;
output[3:0] mrd_addra;
output[31:0] mrd_dina;
input mwrreq_b;
output[5:0] mwr_addrb;
input[3:0] mwr_beoutb;
input[31:0] pci_adr;
input[3:0] pci_be_b;
input pci_cacheline;
input[1:0] pci_cmd;
input pci_mio;
input[6:0] pci_size;
input pciclk;
input reset_b;
wire IO0lIIlO01OOl1I;wire OlI01IO01lOOIl1;wire[5:0] l0IO1I01lOOlI1O;wire IlI0OIIO0lIOIl0;wire lO10IIO0lIIlI0O;wire[6:0] I01lOO1lIOOI01l;
wire OlI01OIl01lO10I;wire l0IO1O01IllIO10;wire[6:0] IlO01OlI01l0IO1;wire OIl01I01lOIO01l;wire I1lO0I1lO0IlO01;wire OOIl1I1lO0OOl1I;
wire l0IO1IO0lIIO0lI;wire IlO01O1lIOIIO0l;wire IO0lIOlI1OIOIl0;wire I1lO0O01IlO01Il;wire OOIl1OlI01OIl01;wire IOIl0OI01llO10I;wire IO01lI1lO0I1lO0;
wire O1lIOl10IOI01lO;wire OI01ll0IO1IO01l;wire lIO10lIO10IlO01;wire IOIl0OlI1OO1lIO;wire OIl01OOIl1IO0lI;wire[5:0] I1lO0OOl1IIIO0l;
wire OI01lOI01lOlI01;wire lIO10IlI0OO01Il;wire IO01lIOIl0OIl01;wire O01Ill0IO1l10IO;wire l10IOlIO10I1lO0;wire OOl1IlO10II01lO;wire[31:0] lIO10OOIl1OOIl1;
wire IO01lOOl1IOlI1O;wire OlI1OIlO01O1lIO;wire l10IOIlI0OIlI0O;wire OOl1IIOIl0OI01l;wire IIO0lIIO0lOlI01;wire I01lOlIO10lIO10;wire OlI1OlO10Il0IO1;
wire IlI0OOIl01l10IO;wire IlO01IlO01IlO01;
dff6 IOlI1OOlI1OOlI01(I1lO0OOl1IIIO0l[5:0],l0IO1I01lOOlI1O[5:0],pciclk,reset_b,1'b1);assign h_ain[1:0]
=(~l10IOIlI0OIlI0O&~IOIl0OlI1OO1lIO&~IO01lI1lO0I1lO0)?2'b00:pci_adr[1:0];assign IlI0OOIl01l10IO
=(IO01lOOl1IOlI1O&~IlI0OIIO0lIOIl0&~I01lOlIO10lIO10)|(OI01ll0IO1IO01l&~I01lOlIO10lIO10);assign IlI0OIIO0lIOIl0=IlO01O1lIOIIO0l;assign lIO10lIO10IlO01
=lIO10IlI0OO01Il&OOIl1I1lO0OOl1I;dff IOlI01OOIl1IlI0O(OIl01OOIl1IO0lI,OlI01IO01lOOIl1,pciclk,reset_b,1'b1);assign IO0lIIlO01OOl1I
=((IO01lIOIl0OIl01&~OIl01I01lOIO01l)|
(~h_done_b&h_boff_b)|OOl1IlO10II01lO)?1'b1:1'b0;assign h_cacheline=pci_cacheline;dff IIO0lIOI01ll10IO
(mack_b,O1lIOl10IOI01lO,pciclk,1'b1,reset_b);assign lIO10OOIl1OOIl1=h_dout;assign mrd_abort=O01Ill0IO1l10IO;dff IIIO0lOIl01IO01l
(IO0lIOlI1OIOIl0,OlI1OIlO01O1lIO,pciclk,reset_b,1'b1);assign I1lO0O01IlO01Il=l0IO1IO0lIIO0lI&(~h_done_b|I01lOlIO10lIO10);assign l10IOIlI0OIlI0O
=(pci_size[6:0]==7'b0000001)?1'b1:1'b0;assign IOIl0OlI1OO1lIO
=(IO01lOOl1IOlI1O&~IlI0OIIO0lIOIl0&I01lOlIO10lIO10)|(OI01ll0IO1IO01l&I01lOlIO10lIO10)|IOIl0OI01llO10I;assign h_cmd[1:0]
=pci_cmd[1:0];assign mrd_dina[31:0]=lIO10OOIl1OOIl1;assign lO10IIO0lIIlI0O
=(IO01lOOl1IOlI1O&~OI01lOI01lOlI01&I01lOlIO10lIO10)|(l10IOlIO10I1lO0&I01lOlIO10lIO10)|
(lIO10IlI0OO01Il&~IO0lIIlO01OOl1I);dff II01lOOlI01I01lO
(OlI1OlO10Il0IO1,mrdreq_b,pciclk,1'b1,reset_b);dff Il0IO1OOl1IOI01l(OOl1IlO10II01lO,OOIl1I1lO0OOl1I,pciclk,reset_b,1'b1);dff IOIl01IlI0OlIO10
(l10IOlIO10I1lO0,l0IO1O01IllIO10,pciclk,reset_b,1'b1);assign I01lOO1lIOOI01l[6:0]
=
(IO01lOOl1IOlI1O&~(IlI0OIIO0lIOIl0&OI01lOI01lOlI01))?pci_size[6:0]:
((lIO10IlI0OO01Il|IOIl0OI01llO10I)&~OIl01I01lOIO01l)?IlO01OlI01l0IO1[6:0]-7'b0000001:
IlO01OlI01l0IO1[6:0];assign h_mio
=pci_mio;assign IIO0lIIO0lOlI01
=(IO01lOOl1IOlI1O&~IlI0OIIO0lIOIl0&I01lOlIO10lIO10)|(OI01ll0IO1IO01l&I01lOlIO10lIO10)|
(IOIl0OI01llO10I&~IO0lIIlO01OOl1I);assign OI01lOI01lOlI01
=OOIl1OlI01OIl01;assign IlO01IlO01IlO01=IO01lOOl1IOlI1O&~OI01lOI01lOlI01;dff IIlI0OIO01lIO0lI
(OI01ll0IO1IO01l,IlI0OOIl01l10IO,pciclk,reset_b,1'b1);assign l0IO1I01lOOlI1O[5:0]
=
(IO01lOOl1IOlI1O&~(IlI0OIIO0lIOIl0&OI01lOI01lOlI01))?6'b000000:
((lIO10IlI0OO01Il|IOIl0OI01llO10I)&~OIl01I01lOIO01l)?I1lO0OOl1IIIO0l[5:0]+6'b000001:
I1lO0OOl1IIIO0l[5:0];assign h_size[15:7]
=9'b000000000;assign O1lIOl10IOI01lO
=~((IO01lOOl1IOlI1O&~IlI0OIIO0lIOIl0&I01lOlIO10lIO10)|
(lIO10IlI0OO01Il&IO0lIIlO01OOl1I)|(OIl01OOIl1IO0lI&~OI01lOI01lOlI01)|
(OI01ll0IO1IO01l&I01lOlIO10lIO10)|(IOIl0OI01llO10I&~IO0lIIlO01OOl1I)|
(IOIl0OI01llO10I&IO0lIIlO01OOl1I&~IlI0OIIO0lIOIl0)|
(IO0lIOlI1OIOIl0&~IlI0OIIO0lIOIl0));assign h_adsh_b
=l0IO1IO0lIIO0lI;assign db23_wea_word=lIO10IlI0OO01Il&~OIl01I01lOIO01l;assign I1lO0I1lO0IlO01
=(IO01lOOl1IOlI1O&IlI0OIIO0lIOIl0&OI01lOI01lOlI01)|(OIl01OOIl1IO0lI&OI01lOI01lOlI01)|
(IOIl0OI01llO10I&IO0lIIlO01OOl1I&IlI0OIIO0lIOIl0)|(IO0lIOlI1OIOIl0&IlI0OIIO0lIOIl0);dff IIlO01I1lO0O1lIO
(OOl1IIOIl0OI01l,mwrreq_b,pciclk,1'b1,reset_b);assign h_bein_b[3:0]=IOIl0OlI1OO1lIO?mwr_beoutb[3:0]:pci_be_b[3:0];dff7 IO1lIOIIO0llO10I
(IlO01OlI01l0IO1[6:0],I01lOO1lIOOI01l[6:0],pciclk,reset_b,1'b1);assign h_ain[31:2]=pci_adr[31:2];assign mwr_addrb[5:0]
=l0IO1I01lOOlI1O[5:0];assign OlI01IO01lOOIl1=(lIO10IlI0OO01Il&IO0lIIlO01OOl1I)|(OIl01OOIl1IO0lI&~OI01lOI01lOlI01);dff II1lO0IOIl0l0IO1
(OOIl1OlI01OIl01,OlI1OlO10Il0IO1,pciclk,1'b1,reset_b);assign OOIl1I1lO0OOl1I=~(h_boff_b|h_done_b);dff IO01IlIO0lIO01Il
(lIO10IlI0OO01Il,lO10IIO0lIIlI0O,pciclk,reset_b,1'b1);assign IO01lIOIl0OIl01=(IlO01OlI01l0IO1[6:0]==7'b0000001)?1'b1:1'b0;assign IO01lI1lO0I1lO0
=pci_cmd[1]&~pci_cmd[0]&~pci_mio;assign OlI1OIlO01O1lIO
=(IOIl0OI01llO10I&IO0lIIlO01OOl1I&~IlI0OIIO0lIOIl0)|(IO0lIOlI1OIOIl0&~IlI0OIIO0lIOIl0);assign OIl01I01lOIO01l=h_rdym_b;assign OlI01OIl01lO10I
=~IlO01IlO01IlO01&(lIO10lIO10IlO01|O01Ill0IO1l10IO);dff IIOIl0l10IOOOIl1(IOIl0OI01llO10I,IIO0lIIO0lOlI01,pciclk,reset_b,1'b1);dff IOOl1IIlO01IOIl0
(I01lOlIO10lIO10,I1lO0O01IlO01Il,pciclk,1'b1,reset_b);assign h_size[6:0]=pci_size[6:0];assign l0IO1IO0lIIO0lI
=~((IO01lOOl1IOlI1O&~IlI0OIIO0lIOIl0&I01lOlIO10lIO10)|
(IO01lOOl1IOlI1O&~OI01lOI01lOlI01&I01lOlIO10lIO10)|
(l10IOlIO10I1lO0&I01lOlIO10lIO10)|(OI01ll0IO1IO01l&I01lOlIO10lIO10));assign h_wrin
=IOIl0OlI1OO1lIO;assign mrd_addra[3:0]=I1lO0OOl1IIIO0l[3:0];assign l0IO1O01IllIO10
=(IO01lOOl1IOlI1O&~OI01lOI01lOlI01&~I01lOlIO10lIO10)|(l10IOlIO10I1lO0&~I01lOlIO10lIO10);dff IIO01llIO10OOl1I
(IlO01O1lIOIIO0l,OOl1IIOIl0OI01l,pciclk,1'b1,reset_b);dff Il10IOO1lIOOIl01
(O01Ill0IO1l10IO,OlI01OIl01lO10I,pciclk,reset_b,1'b1);dff IlO10IO01IlI1lO0
(IO01lOOl1IOlI1O,I1lO0I1lO0IlO01,pciclk,1'b1,reset_b);
endmodule 

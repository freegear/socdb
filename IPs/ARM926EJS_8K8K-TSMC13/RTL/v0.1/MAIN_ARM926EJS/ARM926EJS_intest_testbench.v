// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : ARM926EJS_intest_testbench.v,v
// File Revision       : 1.1
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------


`timescale 100 ns / 1 ns

module ARM926EJS_intest_testbench();

   reg               CLK;
   reg               nFIQ;
   reg               nIRQ;
   reg               VINITHI;
   reg               BIGENDINIT;
   reg  [31:0]       TAPID;
   reg               HRESETn;
   reg               DHCLKEN;
   reg               DHGRANT;
   reg               DHREADY;
   reg  [1:0]        DHRESP;
   reg  [31:0]       DHRDATA;
   reg               IHCLKEN;
   reg               IHGRANT;
   reg               IHREADY;
   reg  [1:0]        IHRESP;
   reg  [31:0]       IHRDATA;
   reg  [31:0]       CPDIN;
   reg  [1:0]        CHSDE;
   reg  [1:0]        CHSEX;
   reg  [3:0]        CPBURST;
   reg               CPEN;
   reg               DBGEN;
   reg               EDBGRQ;
   reg  [1:0]        DBGEXT;
   reg               DBGIEBKPT;
   reg               DBGDEWPT;
   wire              DBGnTRST;
   reg               DBGTCKEN;
   reg               DBGTDI;
   reg               DBGTMS;
   reg               DBGSDOUT;
   reg               ETMEN;
   reg               FIFOFULL;
   reg  [31:0]       DRRD;
   reg               DRWAIT;
   reg  [3:0]        DRSIZE;
   reg  [31:0]       IRRD;
   reg               IRWAIT;
   reg  [3:0]        IRSIZE;
   reg               INITRAM;
   reg               DRDMAEN;
   reg               DRDMACS;
   reg  [17:0]       DRDMAADDR;
   reg               IRDMAEN;
   reg               IRDMACS;
   reg  [17:0]       IRDMAADDR;
   reg               SCANENABLE;
   wire              INTEST;
   wire              EXTEST;
   wire              TESTMODE;
   reg               INTESTSCANIN;

   wire              STANDBYWFI;
   wire              CFGBIGEND;
   wire [31:0]       DHADDR;
   wire [1:0]        DHTRANS;
   wire [2:0]        DHBURST;
   wire              DHWRITE;
   wire [2:0]        DHSIZE;
   wire [3:0]        DHBL;
   wire [3:0]        DHPROT;
   wire [31:0]       DHWDATA;
   wire              DHBUSREQ;
   wire              DHLOCK;
   wire [31:0]       IHADDR;
   wire [1:0]        IHTRANS;
   wire [2:0]        IHBURST;
   wire              IHWRITE;
   wire [2:0]        IHSIZE;
   wire [3:0]        IHPROT;
   wire              IHBUSREQ;
   wire              IHLOCK;
   wire              CPCLKEN;
   wire [31:0]       CPINSTR;
   wire [31:0]       CPDOUT;
   wire              CPPASS;
   wire              CPLATECANCEL;
   wire              nCPINSTRVALID;
   wire              nCPMREQ;
   wire              nCPTRANS;
   wire              CPABORT;
   wire              COMMRX;
   wire              COMMTX;
   wire              DBGACK;
   wire              DBGRQI;
   wire              DBGINSTREXEC;
   wire [1:0]        DBGRNG;
   wire              DBGTDO;
   wire [3:0]        DBGIR;
   wire [4:0]        DBGSCREG;
   wire [3:0]        DBGTAPSM;
   wire              DBGnTDOEN;
   wire              DBGSDIN;
   wire              ETMBIGEND;
   wire              ETMHIVECS;
   wire [31:0]       ETMIA;
   wire              ETMInMREQ;
   wire              ETMISEQ;
   wire              ETMITBIT;
   wire              ETMIJBIT;
   wire              ETMZIFIRST;
   wire              ETMZILAST;
   wire              ETMIABORT;
   wire [31:0]       ETMDA;
   wire [1:0]        ETMDMAS;
   wire              ETMDMORE;
   wire              ETMDnMREQ;
   wire              ETMDnRW;
   wire              ETMDSEQ;
   wire [31:0]       ETMRDATA;
   wire              ETMDABORT;
   wire [31:0]       ETMWDATA;
   wire              ETMnWAIT;
   wire              ETMDBGACK;
   wire              ETMINSTREXEC;
   wire [1:0]        ETMRNGOUT;
   wire [31:25]      ETMID31To25;
   wire [15:11]      ETMID15To11;
   wire [1:0]        ETMCHSD;
   wire [1:0]        ETMCHSE;
   wire              ETMPASS;
   wire              ETMLATECANCEL;
   wire [31:0]       ETMPROCID;
   wire              ETMPROCIDWR;
   wire              ETMINSTRVALID;
   wire              DRnRW;
   wire [17:0]       DRADDR;
   wire [31:0]       DRWD;
   wire              DRIDLE;
   wire              DRCS;
   wire [3:0]        DRWBL;
   wire              DRSEQ;
   wire              IRnRW;
   wire [17:0]       IRADDR;
   wire [31:0]       IRWD;
   wire              IRIDLE;
   wire              IRCS;
   wire [3:0]        IRWBL;
   wire              IRSEQ;
   wire              INTESTSCANOUT;

   wire [3:0]        CPBURST_uut;
   wire [31:0]       DRRD_uut;
   wire [3:0]        DRSIZE_uut;
   wire [1:0]        CHSDE_uut;
   wire [31:0]       IHRDATA_uut;
   wire [1:0]        DBGEXT_uut;
   wire [17:0]       DRDMAADDR_uut;
   wire [1:0]        CHSEX_uut;
   wire [31:0]       TAPID_uut;
   wire [1:0]        DHRESP_uut;
   wire [17:0]       IRDMAADDR_uut;
   wire [2:0]        SCANIN_uut;
   wire [3:0]        IRSIZE_uut;
   wire [31:0]       IRRD_uut;
   wire [1:0]        IHRESP_uut;
   wire [31:0]       DHRDATA_uut;
   wire [31:0]       CPDIN_uut;
   wire              CLK_uut;
   wire              nFIQ_uut;
   wire              nIRQ_uut;
   wire              VINITHI_uut;
   wire              BIGENDINIT_uut;
   wire              HRESETn_uut;
   wire              DHCLKEN_uut;
   wire              DHGRANT_uut;
   wire              DHREADY_uut;
   wire              IHCLKEN_uut;
   wire              IHGRANT_uut;
   wire              IHREADY_uut;
   wire              CPEN_uut;
   wire              DBGEN_uut;
   wire              EDBGRQ_uut;
   wire              DBGIEBKPT_uut;
   wire              DBGDEWPT_uut;
   wire              DBGnTRST_uut;
   wire              DBGTCKEN_uut;
   wire              DBGTDI_uut;
   wire              DBGTMS_uut;
   wire              DBGSDOUT_uut;
   wire              ETMEN_uut;
   wire              FIFOFULL_uut;
   wire              DRWAIT_uut;
   wire              IRWAIT_uut;
   wire              INITRAM_uut;
   wire              DRDMAEN_uut;
   wire              DRDMACS_uut;
   wire              IRDMAEN_uut;
   wire              IRDMACS_uut;
   wire              SCANENABLE_uut;
   wire              INTEST_uut;
   wire              EXTEST_uut;
   wire              TESTMODE_uut;
   wire              INTESTSCANIN_uut;

   wire [31:0]       DHADDR_uut;
   wire [3:0]        DHBL_uut;
   wire [31:0]       ETMWDATA_uut;
   wire [31:0]       DHWDATA_uut;
   wire [2:0]        IHBURST_uut;
   wire [2:0]        IHSIZE_uut;
   wire [3:0]        DBGIR_uut;
   wire [1:0]        ETMCHSD_uut;
   wire [31:0]       ETMPROCID_uut;
   wire [31:0]       IRWD_uut;
   wire [31:25]      ETMID31To25_uut;
   wire [1:0]        DHTRANS_uut;
   wire [2:0]        DHBURST_uut;
   wire [1:0]        IHTRANS_uut;
   wire [3:0]        IHPROT_uut;
   wire [3:0]        DRWBL_uut;
   wire [1:0]        ETMRNGOUT_uut;
   wire [1:0]        ETMCHSE_uut;
   wire [17:0]       IRADDR_uut;
   wire [2:0]        DHSIZE_uut;
   wire [4:0]        DBGSCREG_uut;
   wire [3:0]        DBGTAPSM_uut;
   wire [15:11]      ETMID15To11_uut;
   wire [31:0]       CPINSTR_uut;
   wire [1:0]        DBGRNG_uut;
   wire [31:0]       ETMDA_uut;
   wire [17:0]       DRADDR_uut;
   wire [3:0]        IRWBL_uut;
   wire [31:0]       ETMIA_uut;
   wire [31:0]       DRWD_uut;
   wire [3:0]        DHPROT_uut;
   wire [31:0]       IHADDR_uut;
   wire [31:0]       CPDOUT_uut;
   wire [31:0]       ETMRDATA_uut;
   wire [1:0]        ETMDMAS_uut;
   wire              STANDBYWFI_uut;
   wire              CFGBIGEND_uut;
   wire              DHWRITE_uut;
   wire              DHBUSREQ_uut;
   wire              DHLOCK_uut;
   wire              IHWRITE_uut;
   wire              IHBUSREQ_uut;
   wire              IHLOCK_uut;
   wire              CPCLKEN_uut;
   wire              CPPASS_uut;
   wire              CPLATECANCEL_uut;
   wire              nCPINSTRVALID_uut;
   wire              nCPMREQ_uut;
   wire              nCPTRANS_uut;
   wire              CPABORT_uut;
   wire              COMMRX_uut;
   wire              COMMTX_uut;
   wire              DBGACK_uut;
   wire              DBGRQI_uut;
   wire              DBGINSTREXEC_uut;
   wire              DBGTDO_uut;
   wire              DBGnTDOEN_uut;
   wire              DBGSDIN_uut;
   wire              ETMBIGEND_uut;
   wire              ETMHIVECS_uut;
   wire              ETMInMREQ_uut;
   wire              ETMISEQ_uut;
   wire              ETMITBIT_uut;
   wire              ETMIJBIT_uut;
   wire              ETMZIFIRST_uut;
   wire              ETMZILAST_uut;
   wire              ETMIABORT_uut;
   wire              ETMDMORE_uut;
   wire              ETMDnMREQ_uut;
   wire              ETMDnRW_uut;
   wire              ETMDSEQ_uut;
   wire              ETMDABORT_uut;
   wire              ETMnWAIT_uut;
   wire              ETMDBGACK_uut;
   wire              ETMINSTREXEC_uut;
   wire              ETMPASS_uut;
   wire              ETMLATECANCEL_uut;
   wire              ETMPROCIDWR_uut;
   wire              ETMINSTRVALID_uut;
   wire              DRnRW_uut;
   wire              DRIDLE_uut;
   wire              DRCS_uut;
   wire              DRSEQ_uut;
   wire              IRnRW_uut;
   wire              IRIDLE_uut;
   wire              IRCS_uut;
   wire              IRSEQ_uut;
   wire              INTESTSCANOUT_uut;

   reg               Check;

   // Define MASK:
`include "mask.vh"
   reg [820:0]       MaskShift;
   wire              MaskNow;

   reg [277:0]       ipvector;
   integer           loop;
   
   assign CLK_uut                        = CLK;
   assign nFIQ_uut                       = nFIQ;
   assign nIRQ_uut                       = nIRQ;
   assign VINITHI_uut                    = VINITHI;
   assign BIGENDINIT_uut                 = BIGENDINIT;
   assign TAPID_uut                      = TAPID;
   assign HRESETn_uut                    = HRESETn;
   assign DHCLKEN_uut                    = DHCLKEN;
   assign DHGRANT_uut                    = DHGRANT;
   assign DHREADY_uut                    = DHREADY;
   assign DHRESP_uut                     = DHRESP;
   assign DHRDATA_uut                    = DHRDATA;
   assign IHCLKEN_uut                    = IHCLKEN;
   assign IHGRANT_uut                    = IHGRANT;
   assign IHREADY_uut                    = IHREADY;
   assign IHRESP_uut                     = IHRESP;
   assign IHRDATA_uut                    = IHRDATA;
   assign CPDIN_uut                      = CPDIN;
   assign CHSDE_uut                      = CHSDE;
   assign CHSEX_uut                      = CHSEX;
   assign CPBURST_uut                    = CPBURST;
   assign CPEN_uut                       = CPEN;
   assign DBGEN_uut                      = DBGEN;
   assign EDBGRQ_uut                     = EDBGRQ;
   assign DBGEXT_uut                     = DBGEXT;
   assign DBGIEBKPT_uut                  = DBGIEBKPT;
   assign DBGDEWPT_uut                   = DBGDEWPT;
   assign DBGnTRST_uut                   = DBGnTRST;
   assign DBGTCKEN_uut                   = DBGTCKEN;
   assign DBGTDI_uut                     = DBGTDI;
   assign DBGTMS_uut                     = DBGTMS;
   assign DBGSDOUT_uut                   = DBGSDOUT;
   assign ETMEN_uut                      = ETMEN;
   assign FIFOFULL_uut                   = FIFOFULL;
   assign DRRD_uut                       = DRRD;
   assign DRWAIT_uut                     = DRWAIT;
   assign DRSIZE_uut                     = DRSIZE;
   assign IRRD_uut                       = IRRD;
   assign IRWAIT_uut                     = IRWAIT;
   assign IRSIZE_uut                     = IRSIZE;
   assign INITRAM_uut                    = INITRAM;
   assign DRDMAEN_uut                    = DRDMAEN;
   assign DRDMACS_uut                    = DRDMACS;
   assign DRDMAADDR_uut                  = DRDMAADDR;
   assign IRDMAEN_uut                    = IRDMAEN;
   assign IRDMACS_uut                    = IRDMACS;
   assign IRDMAADDR_uut                  = IRDMAADDR;
   assign SCANENABLE_uut                 = SCANENABLE;
   assign INTEST_uut                     = INTEST;
   assign EXTEST_uut                     = EXTEST;
   assign TESTMODE_uut                   = TESTMODE;
   assign INTESTSCANIN_uut               = INTESTSCANIN;

ARM926EJS        U_ref      (
                                .CLK(CLK),
                                .nFIQ(nFIQ),
                                .nIRQ(nIRQ),
                                .VINITHI(VINITHI),
                                .BIGENDINIT(BIGENDINIT),
                                .TAPID(TAPID),
                                .HRESETn(HRESETn),
                                .DHCLKEN(DHCLKEN),
                                .DHGRANT(DHGRANT),
                                .DHREADY(DHREADY),
                                .DHRESP(DHRESP),
                                .DHRDATA(DHRDATA),
                                .IHCLKEN(IHCLKEN),
                                .IHGRANT(IHGRANT),
                                .IHREADY(IHREADY),
                                .IHRESP(IHRESP),
                                .IHRDATA(IHRDATA),
                                .CPDIN(CPDIN),
                                .CHSDE(CHSDE),
                                .CHSEX(CHSEX),
                                .CPBURST(CPBURST),
                                .CPEN(CPEN),
                                .DBGEN(DBGEN),
                                .EDBGRQ(EDBGRQ),
                                .DBGEXT(DBGEXT),
                                .DBGIEBKPT(DBGIEBKPT),
                                .DBGDEWPT(DBGDEWPT),
                                .DBGnTRST(DBGnTRST),
                                .DBGTCKEN(DBGTCKEN),
                                .DBGTDI(DBGTDI),
                                .DBGTMS(DBGTMS),
                                .DBGSDOUT(DBGSDOUT),
                                .ETMEN(ETMEN),
                                .FIFOFULL(FIFOFULL),
                                .DRRD(DRRD),
                                .DRWAIT(DRWAIT),
                                .DRSIZE(DRSIZE),
                                .IRRD(IRRD),
                                .IRWAIT(IRWAIT),
                                .IRSIZE(IRSIZE),
                                .INITRAM(INITRAM),
                                .DRDMAEN(DRDMAEN),
                                .DRDMACS(DRDMACS),
                                .DRDMAADDR(DRDMAADDR),
                                .IRDMAEN(IRDMAEN),
                                .IRDMACS(IRDMACS),
                                .IRDMAADDR(IRDMAADDR),
                                .SCANENABLE(SCANENABLE),
                                .INTEST(INTEST),
                                .EXTEST(EXTEST),
                                .TESTMODE(TESTMODE),
                                .STANDBYWFI(STANDBYWFI),
                                .CFGBIGEND(CFGBIGEND),
                                .DHADDR(DHADDR),
                                .DHTRANS(DHTRANS),
                                .DHBURST(DHBURST),
                                .DHWRITE(DHWRITE),
                                .DHSIZE(DHSIZE),
                                .DHBL(DHBL),
                                .DHPROT(DHPROT),
                                .DHWDATA(DHWDATA),
                                .DHBUSREQ(DHBUSREQ),
                                .DHLOCK(DHLOCK),
                                .IHADDR(IHADDR),
                                .IHTRANS(IHTRANS),
                                .IHBURST(IHBURST),
                                .IHWRITE(IHWRITE),
                                .IHSIZE(IHSIZE),
                                .IHPROT(IHPROT),
                                .IHBUSREQ(IHBUSREQ),
                                .IHLOCK(IHLOCK),
                                .CPCLKEN(CPCLKEN),
                                .CPINSTR(CPINSTR),
                                .CPDOUT(CPDOUT),
                                .CPPASS(CPPASS),
                                .CPLATECANCEL(CPLATECANCEL),
                                .nCPINSTRVALID(nCPINSTRVALID),
                                .nCPMREQ(nCPMREQ),
                                .nCPTRANS(nCPTRANS),
                                .CPABORT(CPABORT),
                                .COMMRX(COMMRX),
                                .COMMTX(COMMTX),
                                .DBGACK(DBGACK),
                                .DBGRQI(DBGRQI),
                                .DBGINSTREXEC(DBGINSTREXEC),
                                .DBGRNG(DBGRNG),
                                .DBGTDO(DBGTDO),
                                .DBGIR(DBGIR),
                                .DBGSCREG(DBGSCREG),
                                .DBGTAPSM(DBGTAPSM),
                                .DBGnTDOEN(DBGnTDOEN),
                                .DBGSDIN(DBGSDIN),
                                .ETMBIGEND(ETMBIGEND),
                                .ETMHIVECS(ETMHIVECS),
                                .ETMIA(ETMIA),
                                .ETMInMREQ(ETMInMREQ),
                                .ETMISEQ(ETMISEQ),
                                .ETMITBIT(ETMITBIT),
                                .ETMIJBIT(ETMIJBIT),
                                .ETMZIFIRST(ETMZIFIRST),
                                .ETMZILAST(ETMZILAST),
                                .ETMIABORT(ETMIABORT),
                                .ETMDA(ETMDA),
                                .ETMDMAS(ETMDMAS),
                                .ETMDMORE(ETMDMORE),
                                .ETMDnMREQ(ETMDnMREQ),
                                .ETMDnRW(ETMDnRW),
                                .ETMDSEQ(ETMDSEQ),
                                .ETMRDATA(ETMRDATA),
                                .ETMDABORT(ETMDABORT),
                                .ETMWDATA(ETMWDATA),
                                .ETMnWAIT(ETMnWAIT),
                                .ETMDBGACK(ETMDBGACK),
                                .ETMINSTREXEC(ETMINSTREXEC),
                                .ETMRNGOUT(ETMRNGOUT),
                                .ETMID31To25(ETMID31To25),
                                .ETMID15To11(ETMID15To11),
                                .ETMCHSD(ETMCHSD),
                                .ETMCHSE(ETMCHSE),
                                .ETMPASS(ETMPASS),
                                .ETMLATECANCEL(ETMLATECANCEL),
                                .ETMPROCID(ETMPROCID),
                                .ETMPROCIDWR(ETMPROCIDWR),
                                .ETMINSTRVALID(ETMINSTRVALID),
                                .DRnRW(DRnRW),
                                .DRADDR(DRADDR),
                                .DRWD(DRWD),
                                .DRIDLE(DRIDLE),
                                .DRCS(DRCS),
                                .DRWBL(DRWBL),
                                .DRSEQ(DRSEQ),
                                .IRnRW(IRnRW),
                                .IRADDR(IRADDR),
                                .IRWD(IRWD),
                                .IRIDLE(IRIDLE),
                                .IRCS(IRCS),
                                .IRWBL(IRWBL),
                                .IRSEQ(IRSEQ),
                                .INTESTSCANIN(INTESTSCANIN),
                                .INTESTSCANOUT(INTESTSCANOUT),
                                .SCANIN(3'b000));

ARM926EJS_intest        U_uut      (
                                .CPBURST(CPBURST_uut),
                                .DRRD(DRRD_uut),
                                .DRSIZE(DRSIZE_uut),
                                .CHSDE(CHSDE_uut),
                                .IHRDATA(IHRDATA_uut),
                                .DBGEXT(DBGEXT_uut),
                                .DRDMAADDR(DRDMAADDR_uut),
                                .CHSEX(CHSEX_uut),
                                .TAPID(TAPID_uut),
                                .DHRESP(DHRESP_uut),
                                .IRDMAADDR(IRDMAADDR_uut),
                                .IRSIZE(IRSIZE_uut),
                                .IRRD(IRRD_uut),
                                .IHRESP(IHRESP_uut),
                                .DHRDATA(DHRDATA_uut),
                                .CPDIN(CPDIN_uut),
                                .CLK(CLK_uut),
                                .nFIQ(nFIQ_uut),
                                .nIRQ(nIRQ_uut),
                                .VINITHI(VINITHI_uut),
                                .BIGENDINIT(BIGENDINIT_uut),
                                .HRESETn(HRESETn_uut),
                                .DHCLKEN(DHCLKEN_uut),
                                .DHGRANT(DHGRANT_uut),
                                .DHREADY(DHREADY_uut),
                                .IHCLKEN(IHCLKEN_uut),
                                .IHGRANT(IHGRANT_uut),
                                .IHREADY(IHREADY_uut),
                                .CPEN(CPEN_uut),
                                .DBGEN(DBGEN_uut),
                                .EDBGRQ(EDBGRQ_uut),
                                .DBGIEBKPT(DBGIEBKPT_uut),
                                .DBGDEWPT(DBGDEWPT_uut),
                                .DBGnTRST(DBGnTRST_uut),
                                .DBGTCKEN(DBGTCKEN_uut),
                                .DBGTDI(DBGTDI_uut),
                                .DBGTMS(DBGTMS_uut),
                                .DBGSDOUT(DBGSDOUT_uut),
                                .ETMEN(ETMEN_uut),
                                .FIFOFULL(FIFOFULL_uut),
                                .DRWAIT(DRWAIT_uut),
                                .IRWAIT(IRWAIT_uut),
                                .INITRAM(INITRAM_uut),
                                .DRDMAEN(DRDMAEN_uut),
                                .DRDMACS(DRDMACS_uut),
                                .IRDMAEN(IRDMAEN_uut),
                                .IRDMACS(IRDMACS_uut),
                                .SCANENABLE(SCANENABLE_uut),
                                .INTEST(INTEST_uut),
                                .EXTEST(EXTEST_uut),
                                .TESTMODE(TESTMODE_uut),
                                .INTESTSCANIN(INTESTSCANIN_uut),
                                .DHADDR(DHADDR_uut),
                                .DHBL(DHBL_uut),
                                .ETMWDATA(ETMWDATA_uut),
                                .DHWDATA(DHWDATA_uut),
                                .IHBURST(IHBURST_uut),
                                .IHSIZE(IHSIZE_uut),
                                .DBGIR(DBGIR_uut),
                                .ETMCHSD(ETMCHSD_uut),
                                .ETMPROCID(ETMPROCID_uut),
                                .IRWD(IRWD_uut),
                                .ETMID31To25(ETMID31To25_uut),
                                .DHTRANS(DHTRANS_uut),
                                .DHBURST(DHBURST_uut),
                                .IHTRANS(IHTRANS_uut),
                                .IHPROT(IHPROT_uut),
                                .DRWBL(DRWBL_uut),
                                .ETMRNGOUT(ETMRNGOUT_uut),
                                .ETMCHSE(ETMCHSE_uut),
                                .IRADDR(IRADDR_uut),
                                .DHSIZE(DHSIZE_uut),
                                .DBGSCREG(DBGSCREG_uut),
                                .DBGTAPSM(DBGTAPSM_uut),
                                .ETMID15To11(ETMID15To11_uut),
                                .CPINSTR(CPINSTR_uut),
                                .DBGRNG(DBGRNG_uut),
                                .ETMDA(ETMDA_uut),
                                .DRADDR(DRADDR_uut),
                                .IRWBL(IRWBL_uut),
                                .ETMIA(ETMIA_uut),
                                .DRWD(DRWD_uut),
                                .DHPROT(DHPROT_uut),
                                .IHADDR(IHADDR_uut),
                                .CPDOUT(CPDOUT_uut),
                                .ETMRDATA(ETMRDATA_uut),
                                .ETMDMAS(ETMDMAS_uut),
                                .STANDBYWFI(STANDBYWFI_uut),
                                .CFGBIGEND(CFGBIGEND_uut),
                                .DHWRITE(DHWRITE_uut),
                                .DHBUSREQ(DHBUSREQ_uut),
                                .DHLOCK(DHLOCK_uut),
                                .IHWRITE(IHWRITE_uut),
                                .IHBUSREQ(IHBUSREQ_uut),
                                .IHLOCK(IHLOCK_uut),
                                .CPCLKEN(CPCLKEN_uut),
                                .CPPASS(CPPASS_uut),
                                .CPLATECANCEL(CPLATECANCEL_uut),
                                .nCPINSTRVALID(nCPINSTRVALID_uut),
                                .nCPMREQ(nCPMREQ_uut),
                                .nCPTRANS(nCPTRANS_uut),
                                .CPABORT(CPABORT_uut),
                                .COMMRX(COMMRX_uut),
                                .COMMTX(COMMTX_uut),
                                .DBGACK(DBGACK_uut),
                                .DBGRQI(DBGRQI_uut),
                                .DBGINSTREXEC(DBGINSTREXEC_uut),
                                .DBGTDO(DBGTDO_uut),
                                .DBGnTDOEN(DBGnTDOEN_uut),
                                .DBGSDIN(DBGSDIN_uut),
                                .ETMBIGEND(ETMBIGEND_uut),
                                .ETMHIVECS(ETMHIVECS_uut),
                                .ETMInMREQ(ETMInMREQ_uut),
                                .ETMISEQ(ETMISEQ_uut),
                                .ETMITBIT(ETMITBIT_uut),
                                .ETMIJBIT(ETMIJBIT_uut),
                                .ETMZIFIRST(ETMZIFIRST_uut),
                                .ETMZILAST(ETMZILAST_uut),
                                .ETMIABORT(ETMIABORT_uut),
                                .ETMDMORE(ETMDMORE_uut),
                                .ETMDnMREQ(ETMDnMREQ_uut),
                                .ETMDnRW(ETMDnRW_uut),
                                .ETMDSEQ(ETMDSEQ_uut),
                                .ETMDABORT(ETMDABORT_uut),
                                .ETMnWAIT(ETMnWAIT_uut),
                                .ETMDBGACK(ETMDBGACK_uut),
                                .ETMINSTREXEC(ETMINSTREXEC_uut),
                                .ETMPASS(ETMPASS_uut),
                                .ETMLATECANCEL(ETMLATECANCEL_uut),
                                .ETMPROCIDWR(ETMPROCIDWR_uut),
                                .ETMINSTRVALID(ETMINSTRVALID_uut),
                                .DRnRW(DRnRW_uut),
                                .DRIDLE(DRIDLE_uut),
                                .DRCS(DRCS_uut),
                                .DRSEQ(DRSEQ_uut),
                                .IRnRW(IRnRW_uut),
                                .IRIDLE(IRIDLE_uut),
                                .IRCS(IRCS_uut),
                                .IRSEQ(IRSEQ_uut),
                                .INTESTSCANOUT(INTESTSCANOUT_uut));


reg    __CheckerStopOnFailure;
integer __CheckerCycleCount;
integer __CheckerErrorCount;
initial
  begin
    $display ("ARM926EJS intest testbench started");
    __CheckerStopOnFailure <= 1'b1;
    __CheckerCycleCount    <= 0;
    __CheckerErrorCount    <= 0;
  end

always @(posedge CLK)
  begin
    __CheckerCycleCount <= __CheckerCycleCount + 1;

    if(^INTESTSCANOUT !== 1'bx && MaskNow != 1'b0)
      begin
        if (INTESTSCANOUT !== INTESTSCANOUT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT INTESTSCANOUT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, INTESTSCANOUT, INTESTSCANOUT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^STANDBYWFI !== 1'bx && Check != 1'b0)
      begin
        if (STANDBYWFI !== STANDBYWFI_uut)
          begin
             $display ("COMPARISON FAILURE : PORT STANDBYWFI : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, STANDBYWFI, STANDBYWFI_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CFGBIGEND !== 1'bx && Check != 1'b0)
      begin
        if (CFGBIGEND !== CFGBIGEND_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CFGBIGEND : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CFGBIGEND, CFGBIGEND_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHADDR !== 1'bx && Check != 1'b0)
      begin
        if (DHADDR !== DHADDR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHADDR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHADDR, DHADDR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHTRANS !== 1'bx && Check != 1'b0)
      begin
        if (DHTRANS !== DHTRANS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHTRANS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHTRANS, DHTRANS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHBURST !== 1'bx && Check != 1'b0)
      begin
        if (DHBURST !== DHBURST_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHBURST : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHBURST, DHBURST_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHWRITE !== 1'bx && Check != 1'b0)
      begin
        if (DHWRITE !== DHWRITE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHWRITE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHWRITE, DHWRITE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHSIZE !== 1'bx && Check != 1'b0)
      begin
        if (DHSIZE !== DHSIZE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHSIZE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHSIZE, DHSIZE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHBL !== 1'bx && Check != 1'b0)
      begin
        if (DHBL !== DHBL_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHBL : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHBL, DHBL_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHPROT !== 1'bx && Check != 1'b0)
      begin
        if (DHPROT !== DHPROT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHPROT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHPROT, DHPROT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHWDATA !== 1'bx && Check != 1'b0)
      begin
        if (DHWDATA !== DHWDATA_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHWDATA : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHWDATA, DHWDATA_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHBUSREQ !== 1'bx && Check != 1'b0)
      begin
        if (DHBUSREQ !== DHBUSREQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHBUSREQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHBUSREQ, DHBUSREQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DHLOCK !== 1'bx && Check != 1'b0)
      begin
        if (DHLOCK !== DHLOCK_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DHLOCK : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DHLOCK, DHLOCK_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHADDR !== 1'bx && Check != 1'b0)
      begin
        if (IHADDR !== IHADDR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHADDR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHADDR, IHADDR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHTRANS !== 1'bx && Check != 1'b0)
      begin
        if (IHTRANS !== IHTRANS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHTRANS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHTRANS, IHTRANS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHBURST !== 1'bx && Check != 1'b0)
      begin
        if (IHBURST !== IHBURST_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHBURST : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHBURST, IHBURST_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHWRITE !== 1'bx && Check != 1'b0)
      begin
        if (IHWRITE !== IHWRITE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHWRITE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHWRITE, IHWRITE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHSIZE !== 1'bx && Check != 1'b0)
      begin
        if (IHSIZE !== IHSIZE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHSIZE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHSIZE, IHSIZE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHPROT !== 1'bx && Check != 1'b0)
      begin
        if (IHPROT !== IHPROT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHPROT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHPROT, IHPROT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHBUSREQ !== 1'bx && Check != 1'b0)
      begin
        if (IHBUSREQ !== IHBUSREQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHBUSREQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHBUSREQ, IHBUSREQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IHLOCK !== 1'bx && Check != 1'b0)
      begin
        if (IHLOCK !== IHLOCK_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IHLOCK : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IHLOCK, IHLOCK_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CPCLKEN !== 1'bx && Check != 1'b0)
      begin
        if (CPCLKEN !== CPCLKEN_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CPCLKEN : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CPCLKEN, CPCLKEN_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CPINSTR !== 1'bx && Check != 1'b0)
      begin
        if (CPINSTR !== CPINSTR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CPINSTR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CPINSTR, CPINSTR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CPDOUT !== 1'bx && Check != 1'b0)
      begin
        if (CPDOUT !== CPDOUT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CPDOUT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CPDOUT, CPDOUT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CPPASS !== 1'bx && Check != 1'b0)
      begin
        if (CPPASS !== CPPASS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CPPASS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CPPASS, CPPASS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CPLATECANCEL !== 1'bx && Check != 1'b0)
      begin
        if (CPLATECANCEL !== CPLATECANCEL_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CPLATECANCEL : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CPLATECANCEL, CPLATECANCEL_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^nCPINSTRVALID !== 1'bx && Check != 1'b0)
      begin
        if (nCPINSTRVALID !== nCPINSTRVALID_uut)
          begin
             $display ("COMPARISON FAILURE : PORT nCPINSTRVALID : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, nCPINSTRVALID, nCPINSTRVALID_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^nCPMREQ !== 1'bx && Check != 1'b0)
      begin
        if (nCPMREQ !== nCPMREQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT nCPMREQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, nCPMREQ, nCPMREQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^nCPTRANS !== 1'bx && Check != 1'b0)
      begin
        if (nCPTRANS !== nCPTRANS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT nCPTRANS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, nCPTRANS, nCPTRANS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^CPABORT !== 1'bx && Check != 1'b0)
      begin
        if (CPABORT !== CPABORT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT CPABORT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, CPABORT, CPABORT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^COMMRX !== 1'bx && Check != 1'b0)
      begin
        if (COMMRX !== COMMRX_uut)
          begin
             $display ("COMPARISON FAILURE : PORT COMMRX : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, COMMRX, COMMRX_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^COMMTX !== 1'bx && Check != 1'b0)
      begin
        if (COMMTX !== COMMTX_uut)
          begin
             $display ("COMPARISON FAILURE : PORT COMMTX : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, COMMTX, COMMTX_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGACK !== 1'bx && Check != 1'b0)
      begin
        if (DBGACK !== DBGACK_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGACK : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGACK, DBGACK_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGRQI !== 1'bx && Check != 1'b0)
      begin
        if (DBGRQI !== DBGRQI_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGRQI : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGRQI, DBGRQI_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGINSTREXEC !== 1'bx && Check != 1'b0)
      begin
        if (DBGINSTREXEC !== DBGINSTREXEC_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGINSTREXEC : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGINSTREXEC, DBGINSTREXEC_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGRNG !== 1'bx && Check != 1'b0)
      begin
        if (DBGRNG !== DBGRNG_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGRNG : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGRNG, DBGRNG_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGTDO !== 1'bx && Check != 1'b0)
      begin
        if (DBGTDO !== DBGTDO_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGTDO : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGTDO, DBGTDO_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGIR !== 1'bx && Check != 1'b0)
      begin
        if (DBGIR !== DBGIR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGIR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGIR, DBGIR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGSCREG !== 1'bx && Check != 1'b0)
      begin
        if (DBGSCREG !== DBGSCREG_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGSCREG : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGSCREG, DBGSCREG_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGTAPSM !== 1'bx && Check != 1'b0)
      begin
        if (DBGTAPSM !== DBGTAPSM_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGTAPSM : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGTAPSM, DBGTAPSM_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGnTDOEN !== 1'bx && Check != 1'b0)
      begin
        if (DBGnTDOEN !== DBGnTDOEN_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGnTDOEN : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGnTDOEN, DBGnTDOEN_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DBGSDIN !== 1'bx && Check != 1'b0)
      begin
        if (DBGSDIN !== DBGSDIN_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DBGSDIN : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DBGSDIN, DBGSDIN_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMBIGEND !== 1'bx && Check != 1'b0)
      begin
        if (ETMBIGEND !== ETMBIGEND_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMBIGEND : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMBIGEND, ETMBIGEND_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMHIVECS !== 1'bx && Check != 1'b0)
      begin
        if (ETMHIVECS !== ETMHIVECS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMHIVECS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMHIVECS, ETMHIVECS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMIA !== 1'bx && Check != 1'b0)
      begin
        if (ETMIA !== ETMIA_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMIA : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMIA, ETMIA_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMInMREQ !== 1'bx && Check != 1'b0)
      begin
        if (ETMInMREQ !== ETMInMREQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMInMREQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMInMREQ, ETMInMREQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMISEQ !== 1'bx && Check != 1'b0)
      begin
        if (ETMISEQ !== ETMISEQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMISEQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMISEQ, ETMISEQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMITBIT !== 1'bx && Check != 1'b0)
      begin
        if (ETMITBIT !== ETMITBIT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMITBIT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMITBIT, ETMITBIT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMIJBIT !== 1'bx && Check != 1'b0)
      begin
        if (ETMIJBIT !== ETMIJBIT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMIJBIT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMIJBIT, ETMIJBIT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMZIFIRST !== 1'bx && Check != 1'b0)
      begin
        if (ETMZIFIRST !== ETMZIFIRST_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMZIFIRST : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMZIFIRST, ETMZIFIRST_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMZILAST !== 1'bx && Check != 1'b0)
      begin
        if (ETMZILAST !== ETMZILAST_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMZILAST : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMZILAST, ETMZILAST_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMIABORT !== 1'bx && Check != 1'b0)
      begin
        if (ETMIABORT !== ETMIABORT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMIABORT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMIABORT, ETMIABORT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDA !== 1'bx && Check != 1'b0)
      begin
        if (ETMDA !== ETMDA_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDA : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDA, ETMDA_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDMAS !== 1'bx && Check != 1'b0)
      begin
        if (ETMDMAS !== ETMDMAS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDMAS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDMAS, ETMDMAS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDMORE !== 1'bx && Check != 1'b0)
      begin
        if (ETMDMORE !== ETMDMORE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDMORE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDMORE, ETMDMORE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDnMREQ !== 1'bx && Check != 1'b0)
      begin
        if (ETMDnMREQ !== ETMDnMREQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDnMREQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDnMREQ, ETMDnMREQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDnRW !== 1'bx && Check != 1'b0)
      begin
        if (ETMDnRW !== ETMDnRW_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDnRW : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDnRW, ETMDnRW_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDSEQ !== 1'bx && Check != 1'b0)
      begin
        if (ETMDSEQ !== ETMDSEQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDSEQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDSEQ, ETMDSEQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMRDATA !== 1'bx && Check != 1'b0)
      begin
        if (ETMRDATA !== ETMRDATA_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMRDATA : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMRDATA, ETMRDATA_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDABORT !== 1'bx && Check != 1'b0)
      begin
        if (ETMDABORT !== ETMDABORT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDABORT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDABORT, ETMDABORT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMWDATA !== 1'bx && Check != 1'b0)
      begin
        if (ETMWDATA !== ETMWDATA_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMWDATA : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMWDATA, ETMWDATA_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMnWAIT !== 1'bx && Check != 1'b0)
      begin
        if (ETMnWAIT !== ETMnWAIT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMnWAIT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMnWAIT, ETMnWAIT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMDBGACK !== 1'bx && Check != 1'b0)
      begin
        if (ETMDBGACK !== ETMDBGACK_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMDBGACK : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMDBGACK, ETMDBGACK_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMINSTREXEC !== 1'bx && Check != 1'b0)
      begin
        if (ETMINSTREXEC !== ETMINSTREXEC_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMINSTREXEC : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMINSTREXEC, ETMINSTREXEC_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMRNGOUT !== 1'bx && Check != 1'b0)
      begin
        if (ETMRNGOUT !== ETMRNGOUT_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMRNGOUT : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMRNGOUT, ETMRNGOUT_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMID31To25 !== 1'bx && Check != 1'b0)
      begin
        if (ETMID31To25 !== ETMID31To25_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMID31To25 : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMID31To25, ETMID31To25_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMID15To11 !== 1'bx && Check != 1'b0)
      begin
        if (ETMID15To11 !== ETMID15To11_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMID15To11 : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMID15To11, ETMID15To11_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMCHSD !== 1'bx && Check != 1'b0)
      begin
        if (ETMCHSD !== ETMCHSD_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMCHSD : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMCHSD, ETMCHSD_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMCHSE !== 1'bx && Check != 1'b0)
      begin
        if (ETMCHSE !== ETMCHSE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMCHSE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMCHSE, ETMCHSE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMPASS !== 1'bx && Check != 1'b0)
      begin
        if (ETMPASS !== ETMPASS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMPASS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMPASS, ETMPASS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMLATECANCEL !== 1'bx && Check != 1'b0)
      begin
        if (ETMLATECANCEL !== ETMLATECANCEL_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMLATECANCEL : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMLATECANCEL, ETMLATECANCEL_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMPROCID !== 1'bx && Check != 1'b0)
      begin
        if (ETMPROCID !== ETMPROCID_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMPROCID : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMPROCID, ETMPROCID_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMPROCIDWR !== 1'bx && Check != 1'b0)
      begin
        if (ETMPROCIDWR !== ETMPROCIDWR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMPROCIDWR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMPROCIDWR, ETMPROCIDWR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^ETMINSTRVALID !== 1'bx && Check != 1'b0)
      begin
        if (ETMINSTRVALID !== ETMINSTRVALID_uut)
          begin
             $display ("COMPARISON FAILURE : PORT ETMINSTRVALID : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, ETMINSTRVALID, ETMINSTRVALID_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRnRW !== 1'bx && Check != 1'b0)
      begin
        if (DRnRW !== DRnRW_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRnRW : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRnRW, DRnRW_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRADDR !== 1'bx && Check != 1'b0)
      begin
        if (DRADDR !== DRADDR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRADDR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRADDR, DRADDR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRWD !== 1'bx && Check != 1'b0)
      begin
        if (DRWD !== DRWD_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRWD : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRWD, DRWD_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRIDLE !== 1'bx && Check != 1'b0)
      begin
        if (DRIDLE !== DRIDLE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRIDLE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRIDLE, DRIDLE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRCS !== 1'bx && Check != 1'b0)
      begin
        if (DRCS !== DRCS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRCS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRCS, DRCS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRWBL !== 1'bx && Check != 1'b0)
      begin
        if (DRWBL !== DRWBL_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRWBL : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRWBL, DRWBL_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^DRSEQ !== 1'bx && Check != 1'b0)
      begin
        if (DRSEQ !== DRSEQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT DRSEQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, DRSEQ, DRSEQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRnRW !== 1'bx && Check != 1'b0)
      begin
        if (IRnRW !== IRnRW_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRnRW : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRnRW, IRnRW_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRADDR !== 1'bx && Check != 1'b0)
      begin
        if (IRADDR !== IRADDR_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRADDR : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRADDR, IRADDR_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRWD !== 1'bx && Check != 1'b0)
      begin
        if (IRWD !== IRWD_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRWD : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRWD, IRWD_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRIDLE !== 1'bx && Check != 1'b0)
      begin
        if (IRIDLE !== IRIDLE_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRIDLE : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRIDLE, IRIDLE_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRCS !== 1'bx && Check != 1'b0)
      begin
        if (IRCS !== IRCS_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRCS : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRCS, IRCS_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRWBL !== 1'bx && Check != 1'b0)
      begin
        if (IRWBL !== IRWBL_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRWBL : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRWBL, IRWBL_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end

    if(^IRSEQ !== 1'bx && Check != 1'b0)
      begin
        if (IRSEQ !== IRSEQ_uut)
          begin
             $display ("COMPARISON FAILURE : PORT IRSEQ : CYCLE %d : TIME %t\nref = %h\nuut = %h", __CheckerCycleCount, $time, IRSEQ, IRSEQ_uut);
             if (__CheckerStopOnFailure == 1'b1)
               begin
                 $display ("\n** TEST FAILED **\n");
                 $stop;
               end
             __CheckerErrorCount = __CheckerCycleCount + 1;
          end
      end
  end

   assign TESTMODE = 1'b1;
   assign EXTEST = 1'b1;
   assign INTEST = 1'b0;

   always
     begin
        # 5 CLK = ~CLK;
     end

   assign DBGnTRST = HRESETn;
   initial
     begin
        CLK = 1'b0;
        HRESETn = 1'b0;
        Check = 1'b0;
        SCANENABLE = 1'b0;
        INTESTSCANIN = 1'b0;
        ipvector = 0;
        # 41
        HRESETn = 1'b1;
        # 20
        SCANENABLE = 1'b1;
        $display($time, " Clocking zeros into the scan chain");
        # 8300 // Clock all zeros through the scan chain.
        Check = 1'b1;
        # 10
        INTESTSCANIN = 1'b1;
        $display($time, " Applying single bit to INTESTSCANIN");
        # 10
        INTESTSCANIN = 1'b0;
        # 8300 // Clock a single bit through the scan chain.
        SCANENABLE = 1'b0;
        $display($time, " Sampling the random data on inputs");
        ipvector = {$random,$random,$random,$random,$random,$random,$random,
                    $random,$random};
        Check = 1'b0;
        # 10
        SCANENABLE = 1'b1;
        # 8300 // Clock the random input data out through INTESTSCANOUT.
        SCANENABLE = 1'b0;
        $display($time, " Sampling inverse of the random data on inputs");
        ipvector = ~ipvector;
        # 10
        SCANENABLE = 1'b1;
        # 8300 // Clock the inverse of the previous random data out
              // through INTESTSCANOUT.
        SCANENABLE = 1'b0;
        ipvector = 1;
        $display($time, " Testing input %d of 278", 1);
        # 10
        SCANENABLE = 1'b1;
        for (loop = 2 ; loop <= 278; loop = loop + 1)
          begin
             # 8300 // Test sampling a single set bit applied to the inputs.
                   // Repeat for all 278 inputs.
             $display($time, " Testing input %d of 278", loop);
             SCANENABLE = 1'b0;
             ipvector = ipvector << 1;
             # 10
             SCANENABLE = 1'b1;
          end
        # 8300
        $display($time, " TEST PASSED");
        $stop;
     end

always @(ipvector)
    begin
       nFIQ = ipvector[0];
       nIRQ = ipvector[1];
       VINITHI = ipvector[2];
       BIGENDINIT = ipvector[3];
       TAPID[31:0] = ipvector[35:4];
       DHCLKEN = ipvector[36];
       DHGRANT = ipvector[37];
       DHREADY = ipvector[38];
       DHRESP[1:0] = ipvector[40:39];
       DHRDATA[31:0] = ipvector[72:41];
       IHCLKEN = ipvector[73];
       IHGRANT = ipvector[74];
       IHREADY = ipvector[75];
       IHRESP[1:0] = ipvector[77:76];
       IHRDATA[31:0] = ipvector[109:78];
       CPDIN[31:0] = ipvector[141:110];
       CHSDE[1:0] = ipvector[143:142];
       CHSEX[1:0] = ipvector[145:144];
       CPBURST[3:0] = ipvector[149:146];
       CPEN = ipvector[150];
       DBGEN = ipvector[151];
       EDBGRQ = ipvector[152];
       DBGEXT[1:0] = ipvector[154:153];
       DBGIEBKPT = ipvector[155];
       DBGDEWPT = ipvector[156];
       DBGTCKEN = ipvector[157];
       DBGTDI = ipvector[158];
       DBGTMS = ipvector[159];
       DBGSDOUT = ipvector[160];
       ETMEN = ipvector[161];
       FIFOFULL = ipvector[162];
       DRRD[31:0] = ipvector[194:163];
       DRWAIT = ipvector[195];
       DRSIZE[3:0] = ipvector[199:196];
       IRRD[31:0] = ipvector[231:200];
       IRWAIT = ipvector[232];
       IRSIZE[3:0] = ipvector[236:233];
       INITRAM = ipvector[237];
       DRDMAEN = ipvector[238];
       DRDMACS = ipvector[239];
       DRDMAADDR[17:0] = ipvector[257:240];
       IRDMAEN = ipvector[258];
       IRDMACS = ipvector[259];
       IRDMAADDR[17:0] = ipvector[277:260];
    end

   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          MaskShift <= 821'd0;
        else if (SCANENABLE === 1'b0)
          MaskShift <= MASK;
        else
          MaskShift <= {MaskShift[819:0], 1'b1};
     end
   assign MaskNow = MaskShift[820];
   
endmodule

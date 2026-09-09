//----------------------------------------------------------------------
//
// Copyright (c) 2001-2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI-M64
//
//  File          : pci_m64core.v
//
//  Dependencies  : 
//
//  Model Type:   : Synthesizable core
//
//  Description   : PCI Master/Target Core
//
//  Designer      : AS
//
//  QA Engineer   :  NS 
//
//  Creation Date : 1-March-2001
//
//  Last Update   : 25-August-2003
//
//  Version       : 2.0
//----------------------------------------------------------------------
`timescale 1 ns / 1 ps

module pci_m64core (clkpci, rstpcin, adi, cbei, pari, par64i, idseli, gntni, frameni, req64ni, irdyni, devselni, ack64ni, trdyni, stopni, perrni, reqno, frameno, req64no, irdyno, devselno, ack64no, trdyno, stopno, ot_frame, ot_req64, ot_irdy, ot_devsel, ot_ack64, ot_trdy, ot_stop, intano, paro, par64o, perrno, serrno, ot_perr, ot_par, ot_par64, ado, ot_ad, cbeo, ot_cbe, app_ado, app_intn, t_drdy, t_abort, t_term, m_cbe, m_areq, m_areq64, m_crw, m_drdy, m_lastd, app_rst, app_adr, app_adi, t_barhit, t_ebarhit, t_ben, t_cmd, t_rd, t_wr, t_we, t_nextd, t_adr_valid, t_width64, m_aack, m_aack64, m_otcmd, m_otdata, m_nextd, m_wrejd, m_mabort, m_tabort, m_tretry, m_tdisc, pcr_cmd, pcr_stat, pcr_cachesize, pci_framenid, pci_req64nid, pci_irdynid, pci_devselnid, pci_ack64nid, pci_trdynid, pci_stopnid);

   `include "pci_m64_params.v"

   input clkpci; 
   input rstpcin; 
   input[63:0] adi; 
   input[7:0] cbei; 
   input pari; 
   input par64i; 
   input idseli; 
   input gntni; 
   input frameni; 
   input req64ni; 
   input irdyni; 
   input devselni; 
   input ack64ni; 
   input trdyni; 
   input stopni; 
   input perrni; 
   output reqno; 
   reg reqno;
   output frameno; 
   reg frameno;
   output req64no; 
   reg req64no;
   output irdyno; 
   reg irdyno;
   output devselno; 
   reg devselno;
   output ack64no; 
   reg ack64no;
   output trdyno; 
   reg trdyno;
   output stopno; 
   reg stopno;
   output ot_frame; 
   reg ot_frame;
   output ot_req64; 
   reg ot_req64;
   output ot_irdy; 
   reg ot_irdy;
   output ot_devsel; 
   reg ot_devsel;
   output ot_ack64; 
   reg ot_ack64;
   output ot_trdy; 
   reg ot_trdy;
   output ot_stop; 
   reg ot_stop;
   output intano; 
   wire intano;
   output paro; 
   reg paro;
   output par64o; 
   reg par64o;
   output perrno; 
   reg perrno;
   output serrno; 
   reg serrno;
   output ot_perr; 
   reg ot_perr;
   output ot_par; 
   reg ot_par;
   output ot_par64; 
   reg ot_par64;
   output[63:0] ado; 
   wire[63:0] ado;
   output[63:0] ot_ad; 
   wire[63:0] ot_ad;
   output[7:0] cbeo; 
   wire[7:0] cbeo;
   output[7:0] ot_cbe; 
   wire[7:0] ot_cbe;
   input[63:0] app_ado; 
   input app_intn; 
   input[6:0] t_drdy; 
   input t_abort; 
   input t_term; 
   input[7:0] m_cbe; 
   input m_areq; 
   input m_areq64; 
   input m_crw; 
   input m_drdy; 
   input m_lastd; 
   output app_rst; 
   wire app_rst;
   output[31:0] app_adr; 
   wire[31:0] app_adr;
   output[63:0] app_adi; 
   wire[63:0] app_adi;
   output[5:0] t_barhit; 
   wire[5:0] t_barhit;
   output t_ebarhit; 
   wire t_ebarhit;
   output[7:0] t_ben; 
   wire[7:0] t_ben;
   output[3:0] t_cmd; 
   wire[3:0] t_cmd;
   output t_rd; 
   wire t_rd;
   output t_wr; 
   wire t_wr;
   output t_we; 
   wire t_we;
   output t_nextd; 
   wire t_nextd;
   output t_adr_valid; 
   wire t_adr_valid;
   output t_width64; 
   wire t_width64;
   output m_aack; 
   wire m_aack;
   output m_aack64; 
   wire m_aack64;
   output m_otcmd; 
   wire m_otcmd;
   output m_otdata; 
   wire m_otdata;
   output m_nextd; 
   wire m_nextd;
   output m_wrejd; 
   wire m_wrejd;
   output m_mabort; 
   wire m_mabort;
   output m_tabort; 
   wire m_tabort;
   output m_tretry; 
   wire m_tretry;
   output m_tdisc; 
   wire m_tdisc;
   output[15:0] pcr_cmd; 
   wire[15:0] pcr_cmd;
   output[15:0] pcr_stat; 
   wire[15:0] pcr_stat;
   output[7:0] pcr_cachesize; 
   wire[7:0] pcr_cachesize;
   output pci_framenid; 
   wire pci_framenid;
   output pci_req64nid; 
   wire pci_req64nid;
   output pci_irdynid; 
   wire pci_irdynid;
   output pci_devselnid; 
   wire pci_devselnid;
   output pci_ack64nid; 
   wire pci_ack64nid;
   output pci_trdynid; 
   wire pci_trdynid;
   output pci_stopnid; 
   wire pci_stopnid;

   wire rstpci; 
   reg[63:0] ado_r; 
   wire[63:0] ado_nxt; 
   reg[63:0] adi_r; 
   reg[63:0] ot_ad_r; 
   reg[7:0] cbeo_r; 
   reg[7:0] cbei_r; 
   reg[7:0] ot_cbe_r; 
   wire ot_par_nxt; 
   wire paro_nxt; 
   wire ot_par64_nxt; 
   wire par64o_nxt; 
   wire perrno_nxt; 
   wire serrno_nxt; 
   wire ot_perr_nxt; 
   reg idseli_r; 
   reg frameni_r; 
   reg irdyni_r; 
   reg devselni_r; 
   reg trdyni_r; 
   reg stopni_r; 
   reg gntni_r; 
   reg req64ni_r; 
   reg ack64ni_r; 
   wire ce_adol; 
   wire ce_adoh; 
   wire ce_adop; 
   wire reqno_nxt; 
   wire frameno_nxt; 
   wire ce_frame; 
   wire req64no_nxt; 
   wire ce_req64; 
   wire irdyno_nxt; 
   wire devselno_nxt; 
   wire ack64no_nxt; 
   wire trdyno_nxt; 
   wire stopno_nxt; 
   wire ot_frame_nxt; 
   wire ot_req64_nxt; 
   wire ot_irdy_nxt; 
   wire ot_devsel_nxt; 
   wire ot_ack64_nxt; 
   wire ot_trdy_nxt; 
   wire ot_stop_nxt; 
   wire[31:0] cfg_ado; 
   wire[4:0] ot_ad_nxt; 
   wire[3:0] ot_ad64_nxt; 
   wire clr_adtff; 
   wire ot_cbe_nxt; 
   wire first_cyc; 
   wire[31:0] adr; 
   wire[31:0] busadr; 
   wire[3:0] command; 
   wire cmd_cfgrd; 
   wire cmd_cfgwr; 
   wire acc_cfg; 
   wire acc_io; 
   wire acc_mem; 
   wire acc_wr; 
   wire acc_rd; 
   wire set_mdperr; 
   wire sig_serr; 
   wire det_perr; 
   wire cfg_drdy; 
   wire card_hit; 
   wire io_en; 
   wire mem_en; 
   wire master_en; 
   wire spec_cyc; 
   wire mwi_en; 
   wire perr_en; 
   wire stepping_en; 
   wire serr_en; 
   wire[7:0] lat_timer; 
   wire[7:0] cache_size; 
   wire target_act; 
   wire acc_end; 
   wire ce_adodir; 
   wire t_ce_adordyn; 
   wire m_ce_adordyn; 
   wire mabort_sig; 
   wire tabort_det; 
   wire tretry_det; 
   wire tdisc_det; 
   wire master_act; 
   wire lt_we; 
   wire ladr_valid; 
   wire cfg_hit; 
   wire b_limit; 

   assign rstpci = ~(rstpcin) ;
   assign app_rst = rstpci ;
   assign app_adr = adr ;
   assign app_adi = adi_r ;
   assign ado_nxt[63:32] = app_ado[63:32] ;
   assign ado_nxt[31:0] = (cfg_hit == 1'b0) ? app_ado[31:0] : cfg_ado ;
   assign t_ben = cbei_r ;
   assign t_cmd = command ;
   assign t_we = lt_we ;
   assign t_adr_valid = ladr_valid ;
   assign m_mabort = mabort_sig ;
   assign m_tabort = tabort_det ;
   assign m_tretry = tretry_det ;
   assign m_tdisc = tdisc_det ;
   assign pcr_cachesize = cache_size ;
   assign pci_framenid = frameni_r ;
   assign pci_irdynid = irdyni_r ;
   assign pci_devselnid = devselni_r ;
   assign pci_trdynid = trdyni_r ;
   assign pci_stopnid = stopni_r ;
   assign pci_ack64nid = ack64ni_r ;
   assign pci_req64nid = req64ni_r ;
   assign ado = ado_r ;
   assign ot_ad = ot_ad_r ;
   assign cbeo = cbeo_r ;
   assign ot_cbe = ot_cbe_r ;
   assign intano = app_intn ;

   always @(posedge clkpci or posedge rstpci)
   begin : gnt_iff
      if (rstpci == 1'b1)
      begin
         gntni_r <= 1'b1 ; 
      end
      else
      begin
         gntni_r <= gntni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : idsel_iff
      if (rstpci == 1'b1)
      begin
         idseli_r <= 1'b0 ; 
      end
      else
      begin
         idseli_r <= idseli ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : frame_iff
      if (rstpci == 1'b1)
      begin
         frameni_r <= 1'b1 ; 
      end
      else
      begin
         frameni_r <= frameni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : req64_iff
      if (rstpci == 1'b1)
      begin
         req64ni_r <= 1'b1 ; 
      end
      else
      begin
         req64ni_r <= req64ni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : irdy_iff
      if (rstpci == 1'b1)
      begin
         irdyni_r <= 1'b1 ; 
      end
      else
      begin
         irdyni_r <= irdyni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : devsel_iff
      if (rstpci == 1'b1)
      begin
         devselni_r <= 1'b0 ; 
      end
      else
      begin
         devselni_r <= devselni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : ack64_iff
      if (rstpci == 1'b1)
      begin
         ack64ni_r <= 1'b1 ; 
      end
      else
      begin
         ack64ni_r <= ack64ni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : trdy_iff
      if (rstpci == 1'b1)
      begin
         trdyni_r <= 1'b0 ; 
      end
      else
      begin
         trdyni_r <= trdyni ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : stop_iff
      if (rstpci == 1'b1)
      begin
         stopni_r <= 1'b0 ; 
      end
      else
      begin
         stopni_r <= stopni ; 
      end 
   end 

   always @(posedge clkpci)
   begin : padi_reg
      adi_r <= adi ;  
   end 

   always @(posedge clkpci)
   begin : pcbei_reg
      cbei_r <= cbei ;  
   end 

   always @(posedge clkpci or posedge clr_adtff)
   begin : pado_reg
      if (clr_adtff == 1'b1)
      begin
         ado_r <= {64{1'b0}} ; 
      end
      else
      begin
         if (ce_adol == 1'b1)
         begin
            ado_r[31:0] <= ado_nxt[31:0] ; 
         end 
         if (ce_adoh == 1'b1)
         begin
            ado_r[63:32] <= ado_nxt[63:32] ; 
         end 
      end 
   end 

   always @(posedge clkpci or posedge clr_adtff)
   begin : pad_tff
      if (clr_adtff == 1'b1)
      begin
         ot_ad_r <= {64{1'b1}} ; 
      end
      else
      begin
         begin : xhdl_53
            integer i;
            for(i = 0; i <= 31; i = i + 1)
            begin : adl
               ot_ad_r[i] <= ot_ad_nxt[i / 16] ; 
            end
         end 
         begin : xhdl_54
            integer i;
            for(i = 32; i <= 63; i = i + 1)
            begin : adh
               ot_ad_r[i] <= ot_ad64_nxt[(i - 32) / 16] ; 
            end
         end 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : pcbeo_reg
      if (rstpci == 1'b1)
      begin
         cbeo_r <= {8{1'b0}} ; 
      end
      else
      begin
         if (ce_adol == 1'b1)
         begin
            cbeo_r[3:0] <= m_cbe[3:0] ; 
         end 
         if (ce_adoh == 1'b1)
         begin
            cbeo_r[7:4] <= m_cbe[7:4] ; 
         end 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : pcbe_tff
      if (rstpci == 1'b1)
      begin
         ot_cbe_r <= ~(oe_active) ; 
      end
      else
      begin
         begin : xhdl_59
            integer i;
            for(i = 0; i <= 7; i = i + 1)
            begin
               ot_cbe_r[i] <= ot_cbe_nxt ; 
            end
         end 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : offpar
      if (rstpci == 1'b1)
      begin
         paro <= 1'b0 ; 
      end
      else
      begin
         paro <= paro_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : tffpar
      if (rstpci == 1'b1)
      begin
         ot_par <= ~(oe_active) ; 
      end
      else
      begin
         ot_par <= ot_par_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : offpar64
      if (rstpci == 1'b1)
      begin
         par64o <= 1'b0 ; 
      end
      else
      begin
         par64o <= par64o_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : tffpar64
      if (rstpci == 1'b1)
      begin
         ot_par64 <= ~oe_active ; 
      end
      else
      begin
         ot_par64 <= ot_par64_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : perroff
      if (rstpci == 1'b1)
      begin
         perrno <= 1'b1 ; 
      end
      else
      begin
         perrno <= perrno_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : perrtff
      if (rstpci == 1'b1)
      begin
         ot_perr <= ~oe_active ; 
      end
      else
      begin
         ot_perr <= ot_perr_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : serroff
      if (rstpci == 1'b1)
      begin
         serrno <= 1'b1 ; 
      end
      else
      begin
         serrno <= serrno_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : reqoff
      if (rstpci == 1'b1)
      begin
         reqno <= 1'b1 ; 
      end
      else
      begin
         reqno <= reqno_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : frameoff
      if (rstpci == 1'b1)
      begin
         frameno <= 1'b1 ; 
      end
      else
      begin
         if (ce_frame == 1'b1)
         begin
            frameno <= frameno_nxt ; 
         end 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : frametff
      if (rstpci == 1'b1)
      begin
         ot_frame <= ~oe_active ; 
      end
      else
      begin
         ot_frame <= ot_frame_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : req64off
      if (rstpci == 1'b1)
      begin
         req64no <= 1'b1 ; 
      end
      else
      begin
         if (ce_req64 == 1'b1)
         begin
            req64no <= req64no_nxt ; 
         end 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : req64tff
      if (rstpci == 1'b1)
      begin
         ot_req64 <= ~oe_active ; 
      end
      else
      begin
         ot_req64 <= ot_req64_nxt ; 
      end 
   end 

   always @(posedge clkpci or posedge rstpci)
   begin : irdyoff
      if (rstpci == 1'b1)
      begin
         irdyno <= 1'b1 ; 
      end
      else
      begin
         irdyno <= irdyno_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : irdytff
      if (rstpci == 1'b1)
      begin
         ot_irdy <= ~oe_active ; 
      end
      else
      begin
         ot_irdy <= ot_irdy_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : devseloff
      if (rstpci == 1'b1)
      begin
         devselno <= 1'b1 ; 
      end
      else
      begin
         devselno <= devselno_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : devseltff
      if (rstpci == 1'b1)
      begin
         ot_devsel <= ~oe_active ; 
      end
      else
      begin
         ot_devsel <= ot_devsel_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : ack64off
      if (rstpci == 1'b1)
      begin
         ack64no <= 1'b1 ; 
      end
      else
      begin
         ack64no <= ack64no_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : ack64tff
      if (rstpci == 1'b1)
      begin
         ot_ack64 <= ~oe_active ; 
      end
      else
      begin
         ot_ack64 <= ot_ack64_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : trdyoff
      if (rstpci == 1'b1)
      begin
         trdyno <= 1'b1 ; 
      end
      else
      begin
         trdyno <= trdyno_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : trdytff
      if (rstpci == 1'b1)
      begin
         ot_trdy <= ~oe_active ; 
      end
      else
      begin
         ot_trdy <= ot_trdy_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : stopoff
      if (rstpci == 1'b1)
      begin
         stopno <= 1'b1 ; 
      end
      else
      begin
         stopno <= stopno_nxt ; 
      end 
   end 

   always @(posedge rstpci or posedge clkpci)
   begin : stoptff
      if (rstpci == 1'b1)
      begin
         ot_stop <= ~oe_active ; 
      end
      else
      begin
         ot_stop <= ot_stop_nxt ; 
      end 
   end 
   pci_cead u0pcicel (.pci_ce(ce_adol), .irdy(irdyni), .trdy(trdyni), .t_ce_rdyn(t_ce_adordyn), .dir_ceo(ce_adodir), .m_ce_rdyn(m_ce_adordyn)); 
   pci_cead u0pciceh (.pci_ce(ce_adoh), .irdy(irdyni), .trdy(trdyni), .t_ce_rdyn(t_ce_adordyn), .dir_ceo(ce_adodir), .m_ce_rdyn(m_ce_adordyn)); 
   pci_cead u0pcicep (.pci_ce(ce_adop), .irdy(irdyni), .trdy(trdyni), .t_ce_rdyn(t_ce_adordyn), .dir_ceo(ce_adodir), .m_ce_rdyn(m_ce_adordyn)); 
   pci_genpar64 u0 (.rstpci(rstpci), .clkpci(clkpci), .clr_adtff(clr_adtff), .ce_ado(ce_adop), .ot_ado_nxt(ot_ad_nxt[4]), .ado(ado_nxt), .cbei(cbei), .ot_par_nxt(ot_par_nxt), .paro_nxt(paro_nxt), .ot_par64_nxt(ot_par64_nxt), .par64o_nxt(par64o_nxt)); 
   pci_chkpar64 u1 (.reset(rstpci), .clk(clkpci), .ad(adi_r), .ben(cbei_r), .first_cyc(first_cyc), .irdynid(irdyni_r), .trdynid(trdyni_r), .pari(pari), .par64i(par64i), .perrni(perrni), .ack64nid(ack64ni_r), .acc_wr(acc_wr), .perr_en(perr_en), .serr_en(serr_en), .target_act(target_act), .master_act(master_act), .master_read(m_crw), .perrno_nxt(perrno_nxt), .serrno_nxt(serrno_nxt), .ot_perr_nxt(ot_perr_nxt), .set_mdperr(set_mdperr), .det_perr(det_perr), .sig_serr(sig_serr)); 
   pci_cfgspace u2 (.reset(rstpci), .clk(clkpci), .din(adi_r[31:0]), .dout(cfg_ado), .adr(adr[7:2]), .busadr(busadr), .ben(cbei_r[3:0]), .cmd_cfgrd(cmd_cfgrd), .cmd_cfgwr(cmd_cfgwr), .acc_end(acc_end), .first_cyc(first_cyc), .acc_cfg(acc_cfg), .acc_io(acc_io), .acc_mem(acc_mem), .adr_valid(ladr_valid), .we(lt_we), .set_mdperr(set_mdperr), .sig_tabort(t_abort), .rcv_tabort(tabort_det), .rcv_mabort(mabort_sig), .sig_serr(sig_serr), .det_perr(det_perr), .drdy(cfg_drdy), .b_limit(b_limit), .pcr_cmd(pcr_cmd), .pcr_stat(pcr_stat), .card_hit(card_hit), .target_act(target_act), .bar_hit(t_barhit), .rom_hit(t_ebarhit), .cfg_hit(cfg_hit), .io_en(io_en), .mem_en(mem_en), .master_en(master_en), .spec_cyc(spec_cyc), .mwi_en(mwi_en), .perr_en(perr_en), .stepping_en(stepping_en), .serr_en(serr_en), .lat_timer(lat_timer), .cache_size(cache_size)); 
   pci_mtfsm64 u3 (.clk(clkpci), .reset(rstpci), .idselid(idseli_r), .frameni(frameni), .framenid(frameni_r), .irdyni(irdyni), .irdynid(irdyni_r), .devselni(devselni), .devselnid(devselni_r), .trdyni(trdyni), .trdynid(trdyni_r), .stopni(stopni), .stopnid(stopni_r), .gntni(gntni), .gntnid(gntni_r), .req64nid(req64ni_r), .ack64ni(ack64ni), .target_act(target_act), .adi(adi_r), .cbenid(cbei_r), .lat_timer(lat_timer), .cfg_ioen(io_en), .cfg_memen(mem_en), .master_en(master_en), .hit(card_hit), .cfg_drdy(cfg_drdy), .b_limit(b_limit), .t_drdy(t_drdy), .t_term(t_term), .t_abort(t_abort), .m_areq(m_areq), .m_areq64(m_areq64), .m_crw(m_crw), .m_drdy(m_drdy), .m_lastd(m_lastd), .reqno_nxt(reqno_nxt), .frameno_nxt(frameno_nxt), .ce_frame(ce_frame), .req64no_nxt(req64no_nxt), .ce_req64(ce_req64), .irdyno_nxt(irdyno_nxt), .devselno_nxt(devselno_nxt), .ack64no_nxt(ack64no_nxt), .trdyno_nxt(trdyno_nxt), .stopno_nxt(stopno_nxt), .ot_frame_nxt(ot_frame_nxt), .ot_req64_nxt(ot_req64_nxt), .ot_irdy_nxt(ot_irdy_nxt), .ot_devsel_nxt(ot_devsel_nxt), .ot_ack64_nxt(ot_ack64_nxt), .ot_trdy_nxt(ot_trdy_nxt), .ot_stop_nxt(ot_stop_nxt), .acc_end(acc_end), .ot_cbe_nxt(ot_cbe_nxt), .new_ot_ad(ot_ad_nxt), .new_ot_ad64(ot_ad64_nxt), .clr_adtff(clr_adtff), .t_ce_adordyn(t_ce_adordyn), .m_ce_adordyn(m_ce_adordyn), .ce_adodir(ce_adodir), .first_cyc(first_cyc), .acc_cfg(acc_cfg), .acc_io(acc_io), .acc_mem(acc_mem), .acc_wr(acc_wr), .acc_rd(acc_rd), .adr(adr), .badr(busadr), .command(command), .cmd_cfgrd(cmd_cfgrd), .cmd_cfgwr(cmd_cfgwr), .adr_valid(ladr_valid), .width64(t_width64), .t_nextd(t_nextd), .t_we(lt_we), .t_wr(t_wr), .t_rd(t_rd), .m_otcmd(m_otcmd), .m_otdata(m_otdata), .m_wrejd(m_wrejd), .m_nextd(m_nextd), .m_aack(m_aack), .m_aack64(m_aack64), .mabort_sig(mabort_sig), .tabort_det(tabort_det), .tretry_det(tretry_det), .tdisc_det(tdisc_det), .master_act(master_act)); 
endmodule

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
//  Project       : PCI-M64AHB
//
//  File          : dma64ahb.v
//
//  Dependencies  : dma64_regs.v; dma64_fiforam.v; dma64_fifo.v
//                  dma64_wfifo.v; dma64_arbit.v
//
//  Model Type:   : Synthesizable core
//
//  Description   : DMA Controller for Master PCI transactions with independent 
//                  read and write units with FIFO data buffers. 
//                  Arbiter optimized for dataflow  Read -> Process -> Write
//
//  Designer      : AS
//
//  QA Engineer   :  NS 
//
//  Creation Date : 17-September-2003
//
//  Last Update   : 20-November-2003
//
//  Version       : 1.0.1V
//----------------------------------------------------------------------
module dma64ahb (rstpci, clkpci, t_width64, t_hit, t_we, irdynid, trdynid, m_nextd, m_rejd, m_aack, m_aack64, 
        m_tretry, m_tabort, m_abort, m_otcmd, m_otdata, adi,t_addr, t_ben,ahbaddr,dout_ahb,din_dmaregs,dout_dmaregs,t_drdy, m_lastd, 
        m_drdy, m_areq, m_areq64, m_crw, ado, m_cbe, 
        hclk,hresetn,iaddr,iben,itxinit,iwr,iburst,iprefetch,idrdy,itxerr,itxidle,wbae,wbte,wbrd,rbaf,rbtf,rbwr,rbdin,wbdout,
        dma_txdone, dma_pcierr, dma_ahberr 
        );
   //--------------------------------------------
   // input ports
   //--------------------------------------------
   input rstpci; 
   input clkpci; 
   input t_width64;  
   input t_hit;     
   input t_we;      
   input irdynid;    
   input trdynid;   
   input m_nextd;    
   input m_rejd;     
   input m_aack;     
   input m_aack64;    
   input m_tretry;    
   input m_tabort;    
   input m_abort;     
   input m_otcmd;     
   input m_otdata; 
   input[63:0] din_dmaregs;
   input[63:0] adi; 
   input[15:0] t_addr; 
   input[7:0] t_ben; 
   input[5:0] ahbaddr; 
   //
   input hclk;                      // AHB clock
   input hresetn;                   // AHB reset - active low
   input idrdy;
   input itxerr;
   input itxidle;
   input rbwr;
   input wbrd;
   input[31:0] rbdin;
   //--------------------------------------------
   // output ports
   //--------------------------------------------
   output t_drdy; 
   wire t_drdy;
   output m_lastd; 
   wire m_lastd;
   output m_drdy; 
   wire m_drdy;
   output m_areq; 
   wire m_areq;
   output m_areq64; 
   wire m_areq64;
   output m_crw; 
   wire m_crw;
   output[63:0] dout_dmaregs; 
   wire[63:0] dout_dmaregs;
   output[31:0] dout_ahb;
   wire[31:0] dout_ahb;
   output[63:0] ado; 
   wire[63:0] ado;
   output[7:0] m_cbe; 
   wire[7:0] m_cbe;
   // AHB ports
   output[31:0] iaddr;
   wire[31:0] iaddr;
   output[3:0] iben;
   wire[3:0] iben;
   output itxinit;
   wire itxinit;
   output iwr;
   wire iwr;
   output iburst;
   wire iburst;
   output[3:0] iprefetch;
   wire[3:0] iprefetch;
   output wbae;
   wire wbae;
   output wbte;
   wire wbte;
   output rbaf;
   wire rbaf;
   output rbtf;
   wire rbtf;
   output[31:0] wbdout;
   wire[31:0] wbdout; 
   output dma_txdone; 
   wire dma_txdone; 
   output dma_pcierr; 
   wire dma_pcierr; 
   output dma_ahberr; 
   wire dma_ahberr; 
   //
   //---------------------------------------------------------------------------
   //   internal wires and regs
   //---------------------------------------------------------------------------
   //
   wire[63:0] tf_dout; 
   reg[31:0] dout32_hi; 
   wire[63:0] rf_datain; 
   wire wf_dwordsel; 
   wire rf_dwordsel; 
   wire rd_baf; 
   wire rd_bae; 
   wire rd_btf; 
   wire rd_bte; 
   wire rd_bmid; 
   wire wr_baf; 
   wire wr_bae; 
   wire wr_btf; 
   wire wr_bte; 
   wire wr_bmid; 
   wire wf_read; 
   wire wf_undo; 
   wire rf_wrl; 
   wire rf_wrh; 
   wire[63:0] fi_din;
   wire fi_rd; 
   wire fo_wr; 
   wire wbmid;
   wire[1:0] wfmiddle;  
   wire rbmid;
   wire[1:0] rfmiddle;  
   wire txsucc32;                  //
   wire txsucc64;
   wire inc_ahbaddr;  
   wire tx_pcierrset;
   wire tx_ahberrset; 
   wire tx_doneset;
   wire tx_64fset;
   wire txcnt_0; 
   wire dma_txena;
   wire dma_flsh; 
   wire dma_tx64; 
   wire dma_tx64fail; 
   wire dma_cmderror; 
   wire[23:0] dma_txcnt; 
   wire[3:0] dma_pcicmd; 
   wire[31:0] dma_ahbaddr;      
   wire[31:0] dma_pciaddr;
   reg fifowordsel_r;
   reg[31:0] wbdout_r;
   wire[63:0] wfdo;
   wire[63:0] rfdo;
   wire[1:0] wfwr;                       // Write FIFOs write
   reg[1:0] wfrd;                       // Write FIFOs read
   wire[1:0] wfte;                      // Write FIFOs true empty
   wire[1:0] wftf;                      // Write FIFOs true full
   wire[1:0] rfte;                      // Read FIFOs true empty
   wire[1:0] rftf;                      // Read FIFOs true full
   wire[1:0] rfwr;                      // Read FIFOs write
   wire[1:0] rfrd;                      // Read FIFOs read
   wire log0;                      // logic zero
   //
   //
   //---------------------------------------------------------------------------
   //    main code
   //---------------------------------------------------------------------------
   //
   assign log0 = 1'b0 ;
   assign ado[63:32] = (m_otdata == 1'b0) ? tf_dout[63:32] : {32{1'b0}} ;
   assign ado[31:0]  = (m_otcmd == 1'b0) ? dma_pciaddr :(wf_dwordsel == 1'b0) ? tf_dout[31:0] : dout32_hi ;
   assign rf_datain[63:32] = (rf_dwordsel == 1'b1) ? adi[31:0] : adi[63:32] ;
   assign rf_datain[31:0] = adi[31:0] ;
   //
   assign iaddr = dma_ahbaddr;   
   assign iben  = 4'b000;
   //
   always @(posedge clkpci or posedge rstpci)
   begin : pdatareg
      if (rstpci == 1'b1)
      begin
         dout32_hi <= {32{1'b0}} ; 
      end
      else
      begin
         dout32_hi <= tf_dout[63:32] ; 
      end 
   end 

   //
   //
   dma64regs u1(
      .hclk(hclk),
      .hresetn(hresetn),
      .rstpci(rstpci), 
      .clkpci(clkpci), 
      .t_addr(t_addr), 
      .t_ben(t_ben), 
      .t_width64(t_width64), 
      .t_hit(t_hit), 
      .t_we(t_we), 
      .din(din_dmaregs), 
      .dout(dout_dmaregs),
      .ahbaddr(ahbaddr),
      .dout_ahb(dout_ahb), 
      .txsucc32(txsucc32), 
      .txsucc64(txsucc64), 
      .inc_ahbaddr(inc_ahbaddr),  
      .tx_pcierrset(tx_pcierrset), 
      .tx_ahberrset(tx_ahberrset), 
      .tx_doneset(tx_doneset),
      .tx_64fset(tx_64fset), 
      .m_otcmd(m_otcmd), 
      .t_drdy(t_drdy), 
      .txcnt_0(txcnt_0), 
      .dma_txena(dma_txena), 
      .dma_flsh(dma_flsh), 
      .dma_tx64(dma_tx64), 
      .dma_txdone(dma_txdone), 
      .dma_pcierr(dma_pcierr), 
      .dma_ahberr(dma_ahberr), 
      .dma_tx64fail(dma_tx64fail),
      .dma_cmderror(dma_cmderror), 
      .dma_cbe(m_cbe), 
      .dma_txcnt(dma_txcnt), 
      .dma_pcicmd(dma_pcicmd),
      .dma_pciaddr(dma_pciaddr),
      .dma_ahbaddr(dma_ahbaddr) 
      );
   // 
   //
   dma64txctrl u2 (
      .rstpci(rstpci),
      .clkpci(clkpci),
      .irdynid(irdynid), 
      .trdynid(trdynid), 
      .m_nextd(m_nextd),
      .m_rejd(m_rejd),
      .m_aack(m_aack),
      .m_aack64(m_aack64),
      .m_tretry(m_tretry),
      .m_tabort(m_tabort), 
      .m_abort(m_abort),
      .m_otcmd(m_otcmd),
      .m_drdy(m_drdy),
      .m_areq(m_areq),
      .m_areq64(m_areq64),
      .m_otdata(m_otdata),
      .m_crw(m_crw),
      .m_lastd(m_lastd),
      .wf_read(wf_read), 
      .wf_undo(wf_undo), 
      .wf_dwordsel(wf_dwordsel), 
      .rf_wrl(rf_wrl), 
      .rf_wrh(rf_wrh), 
      .rf_dwordsel(rf_dwordsel), 
      .rf_tf(rd_btf), 
      .rf_af(rd_baf), 
      .rf_te(rd_bte), 
      .rf_mid(rd_bmid),
      .wf_mid(wr_bmid),
      .wf_tf(wr_btf), 
      .wf_te(wr_bte), 
      .wf_ae(wr_bae), 
      .txsucc32(txsucc32), 
      .txsucc64(txsucc64), 
      .inc_ahbaddr(inc_ahbaddr), 
      .tx_pcierrset(tx_pcierrset), 
      .tx_ahberrset(tx_ahberrset), 
      .tx_doneset(tx_doneset), 
      .tx_64fset(tx_64fset),
      .txcnt_0(txcnt_0), 
      .hclk(hclk),
      .hresetn(hresetn),
      .itxinit(itxinit),
      .iwr(iwr),
      .iburst(iburst),
      .iprefetch(iprefetch),
      .idrdy(idrdy),
      .itxerr(itxerr),
      .itxidle(itxidle),
      .wbae(wbae),
      .wbte(wbte),
      .wbrd(wbrd),
      .rbaf(rbaf),
      .rbtf(rbtf),
      .rbwr(rbwr),
      .rbmid(rbmid),
      .wbmid(wbmid),
      
      .dma_txena(dma_txena), 
      .dma_tx64(dma_tx64), 
      .dma_txdone(dma_txdone), 
      .dma_pcierr(dma_pcierr), 
      .dma_ahberr(dma_ahberr), 
      .dma_tx64fail(dma_tx64fail),
      .dma_cmderror(dma_cmderror), 
      .dma_txcnt(dma_txcnt), 
      .dma_pcicmd(dma_pcicmd), 
      .dma_ahbaddr(dma_ahbaddr)
      );
   //
   // PCI Read FIFO
   //
   dma64rdfifo u3 (
      .reset(rstpci), 
      .clk(clkpci), 
      .din(rf_datain), 
      .dout(fi_din), 
      .rd(fi_rd), 
      .wrl(rf_wrl), 
      .wrh(rf_wrh), 
      .flush(dma_flsh), 
      .undo(log0), 
      .ae(rd_bae), 
      .te(rd_bte), 
      .af(rd_baf), 
      .tf(rd_btf), 
      .mid(rd_bmid)
   ); 
   //
   // PCI Write FIFO
   //
   dma64wrfifo u4 (
      .reset(rstpci), 
      .clk(clkpci), 
      .din(rfdo), 
      .dout(tf_dout), 
      .rd(wf_read), 
      .wr(fo_wr), 
      .flush(dma_flsh), 
      .undo(wf_undo), 
      .ae(wr_bae), 
      .te(wr_bte), 
      .af(wr_baf), 
      .tf(wr_btf), 
      .mid(wr_bmid)
   );
   // -----------------------------------------------   
   // AHB FIFOs control
   // -----------------------------------------------   
   always @(posedge hclk or negedge hresetn)
   begin
      if (~hresetn) 
         fifowordsel_r <= 1'b0;
      else
         if (itxinit)
            fifowordsel_r <= iaddr[2];
         else 
            if (wbrd | rbwr)
               fifowordsel_r <= ~fifowordsel_r;
   end 

   //
   //data output register
   always @(posedge hclk or negedge hresetn)
   begin
      if (~hresetn) 
         wbdout_r <= {32{1'b0}};
      else
         if (wbrd)
            if (fifowordsel_r)
               wbdout_r <= wfdo[63:32];
            else
               wbdout_r <= wfdo[31:0];
   end 
   //
   assign wbdout = wbdout_r; 
  //
  // Write FIFO Read 
  //
   always@(wbrd or fifowordsel_r)
   begin
      if (wbrd)
      begin
         if (fifowordsel_r)
            wfrd = 2'b10;
         else  
            wfrd = 2'b01;
      end
      else
      begin
         wfrd = 2'b00;
      end
   end 
   //
   assign wfwr[0] = ~(rd_bte | wftf[0] | wftf[1]); 
   assign wfwr[1] = ~(rd_bte | wftf[0] | wftf[1]);
   assign fi_rd   = ~(rd_bte | wftf[0] | wftf[1]);
   //
   // AHB Write FIFO lower DWORD
   fifo_async WRF0(
     .rst(rstpci), 
     .clkrd(hclk), 
     .clkwr(clkpci), 
     .rd(wfrd[0]), 
     .we(wfwr[0]), 
     .flush(dma_flsh), 
     .din(fi_din[31:0]), 
     .full(wftf[0]), 
     .empty(wfte[0]),
     .middle(wfmiddle[0]), 
     .dout(wfdo[31:0])
     );
  //
  // AHB Write FIFO upper DWORD
  fifo_async WRF1(
     .rst(rstpci), 
     .clkrd(hclk), 
     .clkwr(clkpci), 
     .rd(wfrd[1]), 
     .we(wfwr[1]), 
     .flush(dma_flsh), 
     .din(fi_din[63:32]), 
     .full(wftf[1]), 
     .empty(wfte[1]),
     .middle(wfmiddle[1]), 
     .dout(wfdo[63:32])
     );
   //  
   // write buffer flags
   assign wbae = (wfte[0] ^ wfte[1])|(wfte[0] & wfte[1]);
   assign wbte = wfte[0] & wfte[1];
   assign wbmid = wfmiddle[0] & wfmiddle[1];
   //   
   assign rfwr[0] = (rbwr & ~fifowordsel_r);
   assign rfwr[1] = (rbwr & fifowordsel_r);
   //
   assign rfrd[0] = ~(wr_btf | rfte[0]|rfte[1]);
   assign rfrd[1] = ~(wr_btf | rfte[0]|rfte[1]);
   assign fo_wr   = ~(wr_btf | rfte[0]|rfte[1]);
   //
   // AHB Read FIFO lower DWORD
   fifo_async RDF0(
     .rst(rstpci), 
     .clkrd(clkpci), 
     .clkwr(hclk), 
     .rd(rfrd[0]), 
     .we(rfwr[0]), 
     .flush(dma_flsh), 
     .din(rbdin), 
     .full(rftf[0]), 
     .empty(rfte[0]), 
     .middle(rfmiddle[0]), 
     .dout(rfdo[31:0])
     );
   //
   // AHB Read FIFO upper DWORD
   fifo_async RDF1(
     .rst(rstpci), 
     .clkrd(clkpci), 
     .clkwr(hclk), 
     .rd(rfrd[1]), 
     .we(rfwr[1]), 
     .flush(dma_flsh), 
     .din(rbdin), 
     .full(rftf[1]), 
     .empty(rfte[1]), 
     .middle(rfmiddle[1]), 
     .dout(rfdo[63:32])
     );
   // read buffer flags
   assign rbaf = (rftf[0] ^ rftf[1])|(rftf[0] & rftf[1]);
   assign rbtf = rftf[0] & rftf[1];
   assign rbmid = rfmiddle[0] & rfmiddle[1];
endmodule
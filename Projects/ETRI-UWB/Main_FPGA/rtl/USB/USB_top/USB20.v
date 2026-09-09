/*
     USB rapper
 
     Project : CT-500
 
     contain : axi2ahb rapper, USB_DEVICE, Buffer memory
 
     Created by gtlee
 
     date : 2007.2.21
 
     note :
 
     history :
 
 */




module   USB20
  (
   CLK                               ,
   RESETn                            ,
   
   AWADDR                            ,
   AWLEN                             ,
   AWSIZE                            ,
   AWBURST                           ,
   AWLOCK                            ,
   AWCACHE                           ,
   AWPROT                            ,
   AWVALID                           ,
   AWREADY                           ,
   
   WDATA                             ,
   WSTRB                             ,
   WLAST                             ,
   WVALID                            ,
   WREADY                            ,
   
   BRESP                             ,
   BVALID                            ,
   BREADY                            ,
   
   ARADDR                            ,
   ARLEN                             ,
   ARSIZE                            ,
   ARBURST                           ,
   ARLOCK                            ,
   ARCACHE                           ,
   ARPROT                            ,
   ARVALID                           ,
   ARREADY                           ,
   
   RDATA                             ,
   RRESP                             ,
   RLAST                             ,
   RVALID                            ,
   RREADY                            ,
   
   scanmode                          ,
   
   s_penable                         ,
   s_psel                            ,
   s_paddr                           ,
   s_pwrite                          ,
   s_pwdata                          ,
   s_prdata                          ,
   s_pready                          ,
    
   interrupt                         ,
   
   pwrctl_utmi_xcvr_clk              ,
   ctrl_utmi_datain_l                , 
   ctrl_utmi_dataoe                  ,
   ctrl_utmi_opmode                  , 
   ctrl_utmi_txvalid                 , 
   ctrl_utmi_reset                   , 
   ctrl_utmi_termselect              , 
   ctrl_utmi_xcvrsel                 ,
   
   pwrctl_linestate                  , 
   phy_utmi_dataout_l                , 
   phy_utmi_txready                  , 
   phy_utmi_rxvalid                  , 
   phy_utmi_rxactive                 , 
   phy_utmi_rxerror                  , 
   
   ctrl_utmi_chrgvbus                ,
   ctrl_utmi_dischrgvbus             ,
   pwrctl_suspendn                   ,
   id_dig                            ,
   idpullup                          ,
   
   phy_utmi_hostdisconnect           ,
   ctrl_utmi_dmpulldown              ,
   ctrl_utmi_dppulldown              ,
   sessend                           ,
   sessvld                           ,
   vbusvld          
   );
   

   // Clocks and Resets
   input                  CLK;
   input                  RESETn;

   // axi write channel
   output [31:0] 		  AWADDR;
   output [3:0] 		  AWLEN;
   output [2:0] 		  AWSIZE;
   output [1:0] 		  AWBURST;
   output [1:0] 		  AWLOCK;
   output [3:0] 		  AWCACHE;
   output [2:0] 		  AWPROT;
   output                 AWVALID;
   input                  AWREADY;
   
   output [31:0] 		  WDATA;
   output [3:0] 		  WSTRB;
   output                 WLAST;
   output                 WVALID;
   input                  WREADY;
   
   
   input [1:0] 			  BRESP;
   input 				  BVALID;
   output                 BREADY;
   
   // axi read channel
   output [31:0] 		  ARADDR;
   output [3:0] 		  ARLEN;
   output [2:0] 		  ARSIZE;
   output [1:0] 		  ARBURST;
   output [1:0] 		  ARLOCK;
   output [3:0] 		  ARCACHE;
   output [2:0] 		  ARPROT;
   output                 ARVALID;
   input                  ARREADY;
   
   input [31:0] 		  RDATA;
   input [1:0] 			  RRESP;
   input                  RLAST;
   input                  RVALID;
   output                 RREADY;
   
   // Scan test enable for controller and PHY
   input 				  scanmode; //  (0) normal mode ; (1) scan test
   input 				  s_penable ;
   input 				  s_psel    ;
   input [8:0] 			  s_paddr   ;
   input 				  s_pwrite  ;
   input [31:0] 		  s_pwdata  ;
   output [31:0] 		  s_prdata  ;
   output 				  s_pready  ;

   // System processor interrupt request
   output 				  interrupt; //  Interrupt to the processor
   
   // USB3500 PHY interface
   input 				  pwrctl_utmi_xcvr_clk    ;
   output [7:0] 		  ctrl_utmi_datain_l      ; //1
   output 				  ctrl_utmi_dataoe        ;
   output [1:0] 		  ctrl_utmi_opmode        ; //1
   output 				  ctrl_utmi_txvalid       ; //1
   output 				  ctrl_utmi_reset         ; //1
   output 				  ctrl_utmi_termselect    ; //1
   output [1:0] 		  ctrl_utmi_xcvrsel       ; //2
   
   input [1:0] 			  pwrctl_linestate            ; //1
   input [7:0] 			  phy_utmi_dataout_l          ; //1
   input 				  phy_utmi_txready            ; //1
   input 				  phy_utmi_rxvalid            ; //1
   input 				  phy_utmi_rxactive           ; //1
   input 				  phy_utmi_rxerror            ; //1
   
   output 				  ctrl_utmi_chrgvbus      ;
   output 				  ctrl_utmi_dischrgvbus   ;
   output 				  pwrctl_suspendn         ;
   input 				  id_dig                  ; // USB type A or B
   output 				  idpullup                ;
   
   input 				  phy_utmi_hostdisconnect ; // no used
   output 				  ctrl_utmi_dmpulldown    ;
   output 				  ctrl_utmi_dppulldown    ;
   input 				  sessend; // no used
   input 				  sessvld;
   input 				  vbusvld; // no used
   
   //--------------------------------------------------------------------
   wire [31:0] 			  AWADDR;
   wire [3:0] 			  AWLEN;
   wire [2:0] 			  AWSIZE;
   wire [1:0] 			  AWBURST;
   wire [1:0] 			  AWLOCK;
   wire [3:0] 			  AWCACHE;
   wire [2:0] 			  AWPROT;
   wire 				  AWVALID;
   
   wire [31:0] 			  WDATA;
   wire [3:0] 			  WSTRB;
   wire 				  WLAST;
   wire 				  WVALID;
   
   wire 				  BREADY;
   
   wire [31:0] 			  ARADDR;
   wire [3:0] 			  ARLEN;
   wire [2:0] 			  ARSIZE;
   wire [1:0] 			  ARBURST;
   wire [1:0] 			  ARLOCK;
   wire [3:0] 			  ARCACHE;
   wire [2:0] 			  ARPROT;
   wire 				  ARVALID;
   
   wire 				  RREADY;

   
   // USB PHY interface. part num:USB3500
   wire [7:0] 				ctrl_utmi_datain_l      ; //1
   wire 					ctrl_utmi_dataoe        ;
   wire [1:0] 				ctrl_utmi_opmode        ; //1
   wire 					ctrl_utmi_txvalid       ; //1
   //wire  [VUSB_HS_NUM_PORT-1:0]  ctrl_utmi_txvalidh      ;
   wire 					ctrl_utmi_reset         ; //1
   wire 					ctrl_utmi_termselect    ; //1
   wire [1:0] 				ctrl_utmi_xcvrsel       ; //2
   
   wire 					ctrl_utmi_chrgvbus      ;
   wire 					ctrl_utmi_dischrgvbus   ;
   wire 					pwrctl_suspendn         ;
   wire 					idpullup                ;
   wire 					ctrl_utmi_dmpulldown    ;
   wire 					ctrl_utmi_dppulldown    ;

   // AHB 
   wire [31:0] 				m_haddr   ;
   wire [1:0] 				m_htrans  ;
   wire 					m_hwrite  ;
   wire [2:0] 				m_hsize   ;
   wire [2:0] 				m_hburst  ;
   wire [3:0] 				m_hprot   ;
   wire [3:0] 				m_htypeinfo;
   wire [31:0] 				m_hwdata  ;
   wire [31:0] 				m_hrdata  ;
   wire 					m_hready  ;
   wire [1:0] 				m_hresp   ;
   wire 					m_hbusreq ;
   wire 					m_hgrant  ;
   wire 					m_hlock   ;

   
   // USB buffer memory interface
   //       Rx RAM Signals
   wire [6:0] 				rx_buf_addr_a    ; //  Address bus A
   wire [35:0] 				rx_buf_data_wr_a ; //  Data write bus A - bits [35:32] used as a tag
   wire 					rx_buf_wr_en_a   ; //  Data write enable A
   wire 					rx_buf_clk_a     ; //  Clock A - connect to pe_clk (see pe_clk notes)
   wire [6:0] 				rx_buf_addr_b    ; //  Address bus B
   wire 					rx_buf_rd_en_b   ; //  Data read enable B
   wire [35:0] 				rx_buf_data_rd_b ; //  Data read bus B - bits [35:32] used as a tag
   wire 					rx_buf_clk_b     ; //  Clock B - Connect to system clock
   
   //        Tx RAM Signals
   wire [6:0] 				tx_buf_addr_a    ; //  Address bus A
   wire [35:0] 				tx_buf_data_wr_a ; //  Data write bus A - bits [35:32] used as a tag
   wire 					tx_buf_wr_en_a   ; //  Data write enable A
   wire 					tx_buf_clk_a     ; //  Clock A - Connect to system clock
   wire [6:0] 				tx_buf_addr_b    ; //  Address bus B
   wire [35:0] 				tx_buf_data_rd_b ; //  Data read bus B - bits [35:32] used as a tag
   wire 					tx_buf_rd_en_b   ; //  Data read enable B
   wire 					tx_buf_clk_b     ;

   assign 					m_hgrant = m_hbusreq ;
   
   
   // generate BL
   reg [3:0] 				m_bl;

   always@(m_hsize or m_haddr) begin
	  if(m_hsize[2:1] == 2'b00) begin
		 if(m_hsize[0] == 1'b0) begin  // if 8bit
			case(m_haddr[1:0])
			  2'h1 : m_bl <= 4'b0010;
			  2'h2 : m_bl <= 4'b0100;
			  2'h3 : m_bl <= 4'b1000;
			  default : m_bl <= 4'b0001;
			endcase // case(m_haddr[1:0])
		 end
		 else begin // 16bits
		   if(m_haddr[1] == 1'b0)
			 m_bl <= 4'b0011;
		   else m_bl <= 4'b1100;
		 end // else: !if(m_hsize[0] == 1'b0)
	  end // if (m_hsize[2:1] == 2'b00)
	  else m_bl <= 4'b1111;
   end // always@ (m_hsize or m_haddr)
   

   AHB2AXIBridge       AHB2AXI_USB
	 (
	  //	Common Interface
	  .CLK               ( CLK ), 
	  .RESETn            ( RESETn ), 
	  
	  // AHB Interface
	  .HADDR              ( m_haddr ),
	  .HTRANS             ( m_htrans ),
	  .HWRITE             ( m_hwrite ),
	  .HSIZE              ( m_hsize ),
      .HBL                ( m_bl ),
	  .HBURST             ( m_hburst ),
	  .HPROT              ( m_hprot ),
	  .HWDATA             ( m_hwdata ),
	  .HRDATA             ( m_hrdata ),
	  .HREADY_IN          ( m_hready ),
	  .HREADY_OUT         ( m_hready ),
	  .HRESP              ( m_hresp ),
	  
	  .HSEL               ( 1'b1 ),
	  .HMASTLOCK          ( m_hlock ),
	  
	  // AXI Interface
	  // Write Address Channel
	  .AWADDR             ( AWADDR ),
	  .AWLEN              ( AWLEN ),
	  .AWSIZE             ( AWSIZE ),
	  .AWBURST            ( AWBURST ),
	  .AWLOCK             ( AWLOCK ),
	  .AWCACHE            ( AWCACHE ),
	  .AWPROT             ( AWPROT ),
	  .AWVALID            ( AWVALID ),
	  .AWREADY            ( AWREADY ),
	  
	  // Write Data Channel
	  .WDATA              ( WDATA ),
	  .WSTRB              ( WSTRB ),
	  .WLAST              ( WLAST ),
	  .WVALID             ( WVALID ),
	  .WREADY             ( WREADY ),
	  
	  // Write Response Channel
	  .BRESP              ( BRESP ),
	  .BVALID             ( BVALID ),
	  .BREADY             ( BREADY ),
	  
	  // Read Address Channel
	  .ARADDR             ( ARADDR ),
	  .ARLEN              ( ARLEN ),
	  .ARSIZE             ( ARSIZE ),
	  .ARBURST            ( ARBURST ),
	  .ARLOCK             ( ARLOCK ),
	  .ARCACHE            ( ARCACHE ),
	  .ARPROT             ( ARPROT ),
	  .ARVALID            ( ARVALID ),
	  .ARREADY            ( ARREADY ),
	  
	  // Read Data Channel
	  .RDATA              ( RDATA ),
	  .RRESP              ( RRESP ),
	  .RLAST              ( RLAST ),
	  .RVALID             ( RVALID ),
	  .RREADY             ( RREADY )
	  );

   

   HSDEVIFBtlgnoPHY     USB_DEVICE
	 (
	  .clk                    ( CLK ), 
	  .rst                    ( ~RESETn ), 
	  .scanmode               ( scanmode ), 
	  .s_penable	          ( s_penable ), 
	  .s_psel                 ( s_psel ), 
	  .s_paddr                ( s_paddr ), 
	  .s_pwrite               ( s_pwrite ), 
	  .s_pwdata               ( s_pwdata ), 
	  .s_prdata               ( s_prdata ), 
	  .s_pready               ( s_pready ),
	  
	  .m_haddr	              ( m_haddr ), 
	  .m_htrans	              ( m_htrans ), 
	  .m_hwrite	              ( m_hwrite ), 
	  .m_hsize	              ( m_hsize ), 
	  .m_hburst	              ( m_hburst ), 
	  .m_hprot	              ( m_hprot ), 
	  .m_htypeinfo            ( m_htypeinfo ), 
	  .m_hwdata               ( m_hwdata ), 
	  .m_hrdata               ( m_hrdata ), 
	  .m_hready               ( m_hready ), 
	  .m_hresp	              ( m_hresp ), 
	  .m_hbusreq	          ( m_hbusreq ), 
	  .m_hgrant	              ( m_hgrant ), 
	  .m_hlock	              ( m_hlock ), 
	  
	  .interrupt              ( interrupt ), 
	  
	  .pwrctl_utmi_xcvr_clk   ( pwrctl_utmi_xcvr_clk ),
	  
	  .rx_buf_addr_a          ( rx_buf_addr_a ), 
	  .rx_buf_data_wr_a       ( rx_buf_data_wr_a ), 
	  .rx_buf_wr_en_a         ( rx_buf_wr_en_a ), 
	  .rx_buf_clk_a           ( rx_buf_clk_a ), 
	  .rx_buf_addr_b          ( rx_buf_addr_b ), 
	  .rx_buf_rd_en_b         ( rx_buf_rd_en_b ), 
	  .rx_buf_data_rd_b       ( rx_buf_data_rd_b ), 
	  .rx_buf_clk_b           ( rx_buf_clk_b ), 
	  .tx_buf_addr_a          ( tx_buf_addr_a ), 
	  .tx_buf_data_wr_a       ( tx_buf_data_wr_a ), 
	  .tx_buf_wr_en_a         ( tx_buf_wr_en_a ), 
	  .tx_buf_clk_a           ( tx_buf_clk_a ), 
	  .tx_buf_addr_b          ( tx_buf_addr_b ), 
	  .tx_buf_data_rd_b       ( tx_buf_data_rd_b ), 
	  .tx_buf_rd_en_b         ( tx_buf_rd_en_b ), 
	  .tx_buf_clk_b           ( tx_buf_clk_b ), 
	   
	  .ctrl_utmi_datain_l     ( ctrl_utmi_datain_l ),
	  .ctrl_utmi_dataoe       ( ctrl_utmi_dataoe ),
	  .ctrl_utmi_opmode       ( ctrl_utmi_opmode ),
	  .ctrl_utmi_txvalid      ( ctrl_utmi_txvalid ),
	  .ctrl_utmi_reset        ( ctrl_utmi_reset ),
	  .ctrl_utmi_termselect   ( ctrl_utmi_termselect ),
	  .ctrl_utmi_xcvrsel      ( ctrl_utmi_xcvrsel ),
	  
	  .pwrctl_linestate       ( pwrctl_linestate ),
	  .phy_utmi_dataout_l     ( phy_utmi_dataout_l ),
	  .phy_utmi_txready       ( phy_utmi_txready ),
	  .phy_utmi_rxvalid       ( phy_utmi_rxvalid ),
	  .phy_utmi_rxactive      ( phy_utmi_rxactive ),
	  .phy_utmi_rxerror       ( phy_utmi_rxerror ),
	  
	  .ctrl_utmi_chrgvbus     ( ctrl_utmi_chrgvbus ),
	  .ctrl_utmi_dischrgvbus  ( ctrl_utmi_dischrgvbus ),
	  .pwrctl_suspendn        ( pwrctl_suspendn ),
	  .id_dig		          ( id_dig ),
	  .idpullup		          ( idpullup ),
	  
	  .phy_utmi_hostdisconnect( phy_utmi_hostdisconnect ),
	  .ctrl_utmi_dmpulldown   ( ctrl_utmi_dmpulldown ),
	  .ctrl_utmi_dppulldown   ( ctrl_utmi_dppulldown ),
	  .sessend		          ( sessend ),
	  .sessvld		          ( sessvld ),
	  .vbusvld                ( vbusvld )
   ); //USB_DEVICE

   
   // Buffer memory for USB
   DPSSRAM128x36      USB_RX_BUFF
	 (
	  .QA               (  ),
	  .CLKA             ( rx_buf_clk_a ),
	  .CENA             ( 1'b0 ),
	  .WENA             ( rx_buf_wr_en_a ),
	  .AA               ( rx_buf_addr_a ),
	  .DA               ( rx_buf_data_wr_a ),
	  .QB               ( rx_buf_data_rd_b ),
	  .CLKB             ( rx_buf_clk_b ),
	  .CENB             ( rx_buf_rd_en_b ),
	  .WENB             ( 1'b1 ),
	  .AB               ( rx_buf_addr_b ),
	  .DB               ( {36{1'b0}} )
	  ); // USB_RX_BUFF

   DPSSRAM128x36      USB_TX_BUFF
	 (
	  .QA               (  ),
	  .CLKA             ( tx_buf_clk_a ),
	  .CENA             ( 1'b0 ),
	  .WENA             ( tx_buf_wr_en_a ),
	  .AA               ( tx_buf_addr_a ),
	  .DA               ( tx_buf_data_wr_a ),
	  .QB               ( tx_buf_data_rd_b ),
	  .CLKB             ( tx_buf_clk_b ),
	  .CENB             ( tx_buf_rd_en_b ),
	  .WENB             ( 1'b1 ),
	  .AB               ( tx_buf_addr_b ),
	  .DB               ( {36{1'b0}} )
	  ); // USB_TX_BUFF
   
endmodule // USB20




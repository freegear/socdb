//============================
// Define variable
//============================
`define GLOBAL_BLOCK_AREA_   8'hc3
`define DMA_BLOCK_AREA_      8'hc2
`define U_BLOCK_AREA_        8'hc1

`define U_RXINTR_            4'h2
`define U_TXINTR_            4'h3

`define DESC_AREA_           20'h8180_1
`define DATA_AREA_           8'h81
`define DESC_BADDR_          {`DESC_AREA_,12'h000}      // (128 * 16) bytes
`define DATA_BADDR_          {`DATA_AREA_,24'h00_0000}  // 1Mbytes

`define REMAP_               32'h0000_0001

`define ALLOC_BUFSIZE_       32'h0000_0300
`define LBUF_BADDR_          {`DMA_BLOCK_AREA_,24'h00_0040}
`define DBUF_BADDR_          {`DMA_BLOCK_AREA_,24'h00_00c0}

`define TX_ENABLE_           32'h0000_0001
`define RX_ENABLE_           32'h0000_0002
`define GMII_                32'h0000_0004
`define FULL_DUPLEX_         32'h0000_0010
`define PROMISCUOUS_         32'h0000_0020
`define ACC_GADDR_           32'h0000_0040
`define CF_PASS_             32'h0000_0080
`define TXPAUSE_EN_          32'h0000_0100
`define TXFC_ENABLE_         32'h0000_0200
`define LIMIT_COL_           32'h0000_0400
`define CRCTR_MODE_          32'h0000_0800
`define STRST_ONREAD_        32'h0000_2000
`define RXST_RESET_          32'h0000_4000
`define TXST_RESET_          32'h0000_8000

`define TXFC_THRED_          32'h0008_0000
`define COL_LIMIT_NUM_       32'h0000_0008
`define MHASH_F0_            32'h0000_1111
`define MHASH_F1_            32'h1000_0001
`define SMAC_HADDR_          32'h5c55_aaaa
`define SMAC_LADDR_          32'h33cc_0000
`define DMAC_HADDR_          32'hcc57_9bdf
`define DMAC_LADDR_          32'h8642_0000
`define FCTRL_HDA_           32'h0180_c200
`define FCTRL_LDA_           32'h0001_0000
`define LEN_TYPE_            32'h0000_0806
`define FC_LTYPE_            32'h8808_0000
`define FCTRL_OC_            32'h0000_0001
`define FC_STIME_            32'h0008_0000
`define PHYST_MASK_          32'h0002_ffff
`define PHYST_READ_          32'h8c41_0040 // Read PHY status per 16K main clock
`define INTR_ENABLE_         32'h0000_003f
`define INTR_MASK_           32'h0000_003f
`define INC_TXPQ_            32'h0000_0100
`define U_INTR_ENABLE_       32'h0000_0003
`define U_INTR_MASK_         32'h0000_0003


//============================
// Register Definition.
//============================

///////////////////////////////////////////////////////////////////
// GLOBAL
///////////////////////////////////////////////////////////////////
`define irq_int_src          {`GLOBAL_BLOCK_AREA_,24'h00_0000}
`define irq_rawint_src       {`GLOBAL_BLOCK_AREA_,24'h00_0004}
`define irq_enable           {`GLOBAL_BLOCK_AREA_,24'h00_0008}
`define irq_clr              {`GLOBAL_BLOCK_AREA_,24'h00_000c}

///////////////////////////////////////////////////////////////////
// DMA
///////////////////////////////////////////////////////////////////
`define buf_ptr_reg          {`DMA_BLOCK_AREA_,24'h00_000c}
`define bufsize_reg          {`DMA_BLOCK_AREA_,24'h00_0010}

///////////////////////////////////////////////////////////////////
// USB
///////////////////////////////////////////////////////////////////
`define u_cfg_reg            {`U_BLOCK_AREA_,24'h00_0000}
`define u_e0_status_reg      {`U_BLOCK_AREA_,24'h00_0004}
`define u_e1_status_reg      {`U_BLOCK_AREA_,24'h00_0008}
`define u_e2_status_reg      {`U_BLOCK_AREA_,24'h00_000c}
`define u_e3_status_reg      {`U_BLOCK_AREA_,24'h00_0010}
`define u_txpkt_que_reg      {`U_BLOCK_AREA_,24'h00_0014}
`define u_txpkt_sptr_reg     {`U_BLOCK_AREA_,24'h00_0018}
`define u_txpkt_len_reg      {`U_BLOCK_AREA_,24'h00_001c}
`define u_intr_en_reg        {`U_BLOCK_AREA_,24'h00_0020}
`define u_intr_mask_reg      {`U_BLOCK_AREA_,24'h00_0024}
`define u_intr_src_reg       {`U_BLOCK_AREA_,24'h00_0028}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_002c}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_0030}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_0034}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_0038}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_003c}
`define u_dev_d0_reg         {`U_BLOCK_AREA_,24'h00_0040}
`define u_dev_d1_reg         {`U_BLOCK_AREA_,24'h00_0044}
`define u_dev_d2_reg         {`U_BLOCK_AREA_,24'h00_0048}
`define u_dev_d3_reg         {`U_BLOCK_AREA_,24'h00_004c}
`define u_dev_d4_reg         {`U_BLOCK_AREA_,24'h00_0050}
`define u_dev_q0_reg         {`U_BLOCK_AREA_,24'h00_0054}
`define u_dev_q1_reg         {`U_BLOCK_AREA_,24'h00_0058}
`define u_dev_q2_reg         {`U_BLOCK_AREA_,24'h00_005c}
`define u_cfg_d0_reg         {`U_BLOCK_AREA_,24'h00_0060}
`define u_cfg_d1_reg         {`U_BLOCK_AREA_,24'h00_0064}
`define u_cfg_d2_reg         {`U_BLOCK_AREA_,24'h00_0068}
`define u_oscfg_d0_reg       {`U_BLOCK_AREA_,24'h00_006c}
`define u_oscfg_d1_reg       {`U_BLOCK_AREA_,24'h00_0070}
`define u_oscfg_d2_reg       {`U_BLOCK_AREA_,24'h00_0074}
`define u_intf_d0_reg        {`U_BLOCK_AREA_,24'h00_0078}
`define u_intf_d1_reg        {`U_BLOCK_AREA_,24'h00_007c}
`define u_intf_d2_reg        {`U_BLOCK_AREA_,24'h00_0080}
`define u_endp1_d0_reg       {`U_BLOCK_AREA_,24'h00_0084}
`define u_endp1_d1_reg       {`U_BLOCK_AREA_,24'h00_0088}
`define u_endp2_d0_reg       {`U_BLOCK_AREA_,24'h00_008c}
`define u_endp2_d1_reg       {`U_BLOCK_AREA_,24'h00_0090}
`define u_endp3_d0_reg       {`U_BLOCK_AREA_,24'h00_0094}
`define u_endp3_d1_reg       {`U_BLOCK_AREA_,24'h00_0098}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_009c}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00a0}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00a4}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00a8}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00ac}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00b0}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00b4}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00b8}
//`define xxx_reg            {`U_BLOCK_AREA_,24'h00_00bc}

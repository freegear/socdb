library verilog;
use verilog.vl_types.all;
entity AHB1_ReqInterBuff is
    generic(
        BUS_WID         : integer := 32;
        ADDR_WID        : integer := 32;
        MASTERID_WID    : integer := 1;
        SLAVEID_WID     : integer := 2;
        AWLEN_WID       : integer := 4;
        AWSIZE_WID      : integer := 3;
        AWBURST_WID     : integer := 2;
        AWLOCK_WID      : integer := 2;
        AWCACHE_WID     : integer := 4;
        AWPROT_WID      : integer := 3;
        WSTRB_WID       : integer := 4;
        BRESP_WID       : integer := 2;
        RRESP_WID       : integer := 2;
        ARLEN_WID       : integer := 4;
        ARBURST_WID     : integer := 2;
        ARLOCK_WID      : integer := 2;
        ARCACHE_WID     : integer := 4;
        ARPROT_WID      : integer := 3;
        MASTER_WID      : integer := 3;
        SLAVE_WID       : integer := 4;
        SLAVE_NUM       : integer := 8;
        MASTER_NUM      : integer := 5;
        SELMASTER_WID   : integer := 1;
        Wr_REQDEPTH_WID : integer := 1;
        Rd_REQDEPTH_WID : integer := 1;
        WrPermit_SLAVECNTWID: integer := 1;
        RdPermit_SLAVECNTWID: integer := 1;
        ARSIZE_WID      : integer := 3
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        AWVALID         : in     vl_logic;
        AWREADY         : in     vl_logic;
        MASTERNUM       : in     vl_logic_vector;
        BVALID          : in     vl_logic;
        BREADY          : in     vl_logic;
        CtlData         : out    vl_logic_vector;
        ReqFull         : out    vl_logic;
        ReqEmpty        : out    vl_logic;
        NxReqEmpty      : out    vl_logic
    );
end AHB1_ReqInterBuff;

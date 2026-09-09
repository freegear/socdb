library verilog;
use verilog.vl_types.all;
entity WRCH_ARMD_PermitCtl is
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
        SELMASTER_WID   : integer := 2;
        Wr_REQDEPTH_WID : integer := 1;
        Rd_REQDEPTH_WID : integer := 1;
        WrPermit_SLAVECNTWID: integer := 1;
        RdPermit_SLAVECNTWID: integer := 1;
        ARSIZE_WID      : integer := 3;
        WR_WID          : integer := 0;
        HOLD_WID        : integer := 1;
        WAIT_WID        : integer := 2
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        SlaveNum        : in     vl_logic_vector;
        SID             : in     vl_logic_vector;
        AREADY          : in     vl_logic;
        AVALID          : in     vl_logic;
        WID             : in     vl_logic_vector;
        WREADY          : in     vl_logic;
        WVALID          : in     vl_logic;
        WLAST           : in     vl_logic;
        LID             : in     vl_logic_vector;
        LAST            : in     vl_logic;
        READY           : in     vl_logic;
        RVALID          : in     vl_logic;
        CtlData2datach  : out    vl_logic_vector;
        CtlData2writech : out    vl_logic_vector
    );
end WRCH_ARMD_PermitCtl;

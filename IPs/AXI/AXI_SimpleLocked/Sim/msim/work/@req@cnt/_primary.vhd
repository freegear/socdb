library verilog;
use verilog.vl_types.all;
entity ReqCnt is
    generic(
        BUS_WID         : integer := 32;
        ADDR_WID        : integer := 32;
        ID_WID          : integer := 4;
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
        ARSIZE_WID      : integer := 3;
        ARBURST_WID     : integer := 2;
        ARLOCK_WID      : integer := 2;
        ARCACHE_WID     : integer := 4;
        ARPROT_WID      : integer := 3;
        MASTER_WID      : integer := 4;
        SLAVE_WID       : integer := 3;
        SLAVE_NUM       : integer := 6;
        MASTER_NUM      : integer := 4;
        SLAVECNTWID     : integer := 5;
        RQCNT_WID       : integer := 3;
        RQCNT_MAX       : integer := 1
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        ARVALID         : in     vl_logic;
        ARREADY         : in     vl_logic;
        RVALID          : in     vl_logic;
        RREADY          : in     vl_logic;
        RLAST           : in     vl_logic;
        DataCNTEmpty    : out    vl_logic;
        DataCNTFull     : out    vl_logic
    );
end ReqCnt;

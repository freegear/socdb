library verilog;
use verilog.vl_types.all;
entity ReqInterBuff is
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
        REQDEPTH_WID    : integer := 2
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
        ReqEmpty        : out    vl_logic
    );
end ReqInterBuff;

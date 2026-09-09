library verilog;
use verilog.vl_types.all;
entity PermitCtl is
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
        SLAVECNTWID     : integer := 5
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        SlaveNum        : in     vl_logic_vector;
        AREADY          : in     vl_logic;
        AVALID          : in     vl_logic;
        LAST            : in     vl_logic;
        READY           : in     vl_logic;
        RVALID          : in     vl_logic;
        CtlData2datach  : out    vl_logic_vector;
        CtlData2resch   : out    vl_logic_vector;
        CtlData2writech : out    vl_logic_vector;
        CtlData2rddatach: out    vl_logic_vector
    );
end PermitCtl;

library verilog;
use verilog.vl_types.all;
entity AHB0_LockCtlWrmi is
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
        ARSIZE_WID      : integer := 3;
        IDLE            : integer := 0;
        FULL_MASK       : integer := 1;
        MASK            : integer := 2;
        LOCK            : integer := 3;
        RELEASE         : integer := 4;
        VMASK           : integer := 5
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        ReqIntEmpty     : in     vl_logic;
        DataCntEmptyRdmi2Wrmi: in     vl_logic;
        ALOCK           : in     vl_logic_vector;
        AVALID          : in     vl_logic;
        OVALID          : in     vl_logic;
        LockPort        : in     vl_logic_vector;
        Lock_in         : in     vl_logic;
        UnLock_in       : in     vl_logic;
        Lock_out        : out    vl_logic;
        UnLock_out      : out    vl_logic;
        CtlData         : in     vl_logic_vector;
        EnAMUXn         : out    vl_logic;
        EnAREADYMUXn    : out    vl_logic;
        LockArbiter     : out    vl_logic_vector(5 downto 0)
    );
end AHB0_LockCtlWrmi;

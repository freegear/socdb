library verilog;
use verilog.vl_types.all;
entity s0_lockctlwrmi is
    generic(
        bus_wid         : integer := 32;
        addr_wid        : integer := 32;
        masterid_wid    : integer := 4;
        slaveid_wid     : integer := 6;
        awlen_wid       : integer := 4;
        awsize_wid      : integer := 3;
        awburst_wid     : integer := 2;
        awlock_wid      : integer := 2;
        awcache_wid     : integer := 4;
        awprot_wid      : integer := 3;
        wstrb_wid       : integer := 4;
        bresp_wid       : integer := 2;
        rresp_wid       : integer := 2;
        arlen_wid       : integer := 4;
        arburst_wid     : integer := 2;
        arlock_wid      : integer := 2;
        arcache_wid     : integer := 4;
        arprot_wid      : integer := 3;
        master_wid      : integer := 3;
        slave_wid       : integer := 3;
        slave_num       : integer := 6;
        master_num      : integer := 4;
        selmaster_wid   : integer := 2;
        wr_reqdepth_wid : integer := 4;
        rd_reqdepth_wid : integer := 4;
        wrpermit_slavecntwid: integer := 3;
        rdpermit_slavecntwid: integer := 3;
        arsize_wid      : integer := 3;
        idle            : integer := 0;
        full_mask       : integer := 1;
        mask            : integer := 2;
        lock            : integer := 3;
        release         : integer := 4;
        vmask           : integer := 5
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        reqintempty     : in     vl_logic;
        datacntemptyrdmi2wrmi: in     vl_logic;
        alock           : in     vl_logic_vector;
        avalid          : in     vl_logic;
        ovalid          : in     vl_logic;
        lockport        : in     vl_logic_vector;
        lock_in         : in     vl_logic;
        unlock_in       : in     vl_logic;
        lock_out        : out    vl_logic;
        unlock_out      : out    vl_logic;
        ctldata         : in     vl_logic_vector;
        enamuxn         : out    vl_logic;
        enareadymuxn    : out    vl_logic;
        lockarbiter     : out    vl_logic_vector(5 downto 0)
    );
end s0_lockctlwrmi;

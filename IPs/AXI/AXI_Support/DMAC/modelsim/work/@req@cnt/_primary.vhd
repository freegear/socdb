library verilog;
use verilog.vl_types.all;
entity reqcnt is
    generic(
        bus_wid         : integer := 32;
        addr_wid        : integer := 32;
        id_wid          : integer := 4;
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
        arsize_wid      : integer := 3;
        arburst_wid     : integer := 2;
        arlock_wid      : integer := 2;
        arcache_wid     : integer := 4;
        arprot_wid      : integer := 3;
        master_wid      : integer := 4;
        slave_wid       : integer := 3;
        slave_num       : integer := 6;
        master_num      : integer := 4;
        slavecntwid     : integer := 5;
        reqdepth_wid    : integer := 2;
        rqcnt_wid       : integer := 3;
        rqcnt_max       : integer := 1
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        arvalid         : in     vl_logic;
        arready         : in     vl_logic;
        rvalid          : in     vl_logic;
        rready          : in     vl_logic;
        rlast           : in     vl_logic;
        datacntempty    : out    vl_logic;
        datacntfull     : out    vl_logic
    );
end reqcnt;

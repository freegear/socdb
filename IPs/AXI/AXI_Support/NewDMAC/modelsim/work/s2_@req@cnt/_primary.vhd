library verilog;
use verilog.vl_types.all;
entity s2_reqcnt is
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
        wrpermit_slavecntwid: integer := 0;
        rdpermit_slavecntwid: integer := 0;
        arsize_wid      : integer := 3
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
end s2_reqcnt;

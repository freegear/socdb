library verilog;
use verilog.vl_types.all;
entity wrch_m3_permitctl is
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
        wr_wid          : integer := 0;
        hold_wid        : integer := 1;
        wait_wid        : integer := 2
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        slavenum        : in     vl_logic_vector;
        sid             : in     vl_logic_vector;
        aready          : in     vl_logic;
        avalid          : in     vl_logic;
        wid             : in     vl_logic_vector;
        wready          : in     vl_logic;
        wvalid          : in     vl_logic;
        wlast           : in     vl_logic;
        lid             : in     vl_logic_vector;
        last            : in     vl_logic;
        ready           : in     vl_logic;
        rvalid          : in     vl_logic;
        ctldata2datach  : out    vl_logic_vector;
        ctldata2writech : out    vl_logic_vector
    );
end wrch_m3_permitctl;

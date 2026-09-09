library verilog;
use verilog.vl_types.all;
entity reqinterbuff is
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
        reqdepth_wid    : integer := 2
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        awvalid         : in     vl_logic;
        awready         : in     vl_logic;
        masternum       : in     vl_logic_vector;
        bvalid          : in     vl_logic;
        bready          : in     vl_logic;
        ctldata         : out    vl_logic_vector;
        reqfull         : out    vl_logic;
        reqempty        : out    vl_logic
    );
end reqinterbuff;

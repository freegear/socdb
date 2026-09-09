library verilog;
use verilog.vl_types.all;
entity wd_fully_registered is
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
        information_s   : in     vl_logic_vector;
        valid_s         : in     vl_logic;
        ready_s         : out    vl_logic;
        information_r   : out    vl_logic_vector;
        valid_r         : out    vl_logic;
        ready_r         : in     vl_logic
    );
end wd_fully_registered;

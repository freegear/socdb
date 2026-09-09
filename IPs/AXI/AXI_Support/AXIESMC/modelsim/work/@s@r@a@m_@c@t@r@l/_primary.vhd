library verilog;
use verilog.vl_types.all;
entity sram_ctrl is
    generic(
        idle            : integer := 1;
        tas             : integer := 2;
        tcss            : integer := 4;
        tacc            : integer := 8;
        tcsh            : integer := 16;
        tah             : integer := 32;
        cont            : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        addr            : in     vl_logic_vector(19 downto 0);
        write           : in     vl_logic;
        read            : in     vl_logic;
        wdata           : in     vl_logic_vector(31 downto 0);
        wbeb            : in     vl_logic_vector(3 downto 0);
        trans_size      : in     vl_logic_vector(2 downto 0);
        bank_sel        : in     vl_logic_vector(3 downto 0);
        sram_start      : in     vl_logic;
        addr_setup      : in     vl_logic_vector(2 downto 0);
        addr_hold       : in     vl_logic_vector(2 downto 0);
        cs_setup        : in     vl_logic_vector(2 downto 0);
        cs_hold         : in     vl_logic_vector(2 downto 0);
        acc_cycle       : in     vl_logic_vector(3 downto 0);
        bus_width       : in     vl_logic_vector(1 downto 0);
        addr_shift      : in     vl_logic_vector(1 downto 0);
        ready           : out    vl_logic;
        rdata           : out    vl_logic_vector(31 downto 0);
        ext_addr        : out    vl_logic_vector(19 downto 0);
        ext_wdata       : out    vl_logic_vector(31 downto 0);
        ext_rdata       : in     vl_logic_vector(31 downto 0);
        ext_csb         : out    vl_logic_vector(3 downto 0);
        ext_web         : out    vl_logic;
        ext_oeb         : out    vl_logic;
        ext_beb         : out    vl_logic_vector(3 downto 0);
        ext_wbeb        : out    vl_logic_vector(3 downto 0);
        ext_biden       : out    vl_logic
    );
end sram_ctrl;

library verilog;
use verilog.vl_types.all;
entity ahbslaveram_model is
    generic(
        addr_width      : integer := 9;
        htrans_idle     : integer := 0;
        htrans_busy     : integer := 1;
        htrans_nonseq   : integer := 2;
        htrans_seq      : integer := 3;
        hburst_single   : integer := 0;
        hburst_incr     : integer := 1;
        hburst_wrap4    : integer := 2;
        hburst_incr4    : integer := 3;
        hburst_wrap8    : integer := 4;
        hburst_incr8    : integer := 5;
        hburst_wrap16   : integer := 6;
        hburst_incr16   : integer := 7;
        hresp_okay      : integer := 0;
        hresp_error     : integer := 1;
        hresp_retry     : integer := 2;
        hresp_split     : integer := 3;
        hsize_1b        : integer := 0;
        hsize_2b        : integer := 1;
        hsize_4b        : integer := 2;
        hsize_8b        : integer := 3
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        shsel           : in     vl_logic;
        shwrite         : in     vl_logic;
        shreadyin       : in     vl_logic;
        shtrans         : in     vl_logic_vector(1 downto 0);
        shsize          : in     vl_logic_vector(2 downto 0);
        shburst         : in     vl_logic_vector(2 downto 0);
        shaddr          : in     vl_logic_vector(31 downto 0);
        shwdata         : in     vl_logic_vector(31 downto 0);
        shrdata         : out    vl_logic_vector(31 downto 0);
        shreadyout      : out    vl_logic;
        shresp          : out    vl_logic_vector(1 downto 0)
    );
end ahbslaveram_model;

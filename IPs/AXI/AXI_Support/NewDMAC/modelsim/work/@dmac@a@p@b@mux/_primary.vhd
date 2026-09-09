library verilog;
use verilog.vl_types.all;
entity dmacapbmux is
    generic(
        paddr_max       : integer := 6
    );
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        penable         : in     vl_logic;
        psel            : in     vl_logic;
        pwrite          : in     vl_logic;
        paddr           : in     vl_logic_vector;
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        pclk0           : out    vl_logic;
        presetn0        : out    vl_logic;
        penable0        : out    vl_logic;
        psel0           : out    vl_logic;
        pwrite0         : out    vl_logic;
        paddr0          : out    vl_logic_vector;
        pwdata0         : out    vl_logic_vector(31 downto 0);
        prdata0         : in     vl_logic_vector(31 downto 0);
        pclk1           : out    vl_logic;
        presetn1        : out    vl_logic;
        penable1        : out    vl_logic;
        psel1           : out    vl_logic;
        pwrite1         : out    vl_logic;
        paddr1          : out    vl_logic_vector;
        pwdata1         : out    vl_logic_vector(31 downto 0);
        prdata1         : in     vl_logic_vector(31 downto 0)
    );
end dmacapbmux;

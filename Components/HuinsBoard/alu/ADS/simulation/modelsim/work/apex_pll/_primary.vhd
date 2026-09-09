library verilog;
use verilog.vl_types.all;
entity apex_pll is
    port(
        clk_ref         : in     vl_logic;
        clk_pll         : out    vl_logic;
        entest          : in     vl_logic;
        por             : in     vl_logic;
        lock            : out    vl_logic;
        up              : out    vl_logic;
        down            : out    vl_logic;
        enablepin       : in     vl_logic;
        rcpm            : in     vl_logic_vector(3 downto 1);
        rlock           : in     vl_logic_vector(2 downto 0);
        rlockcy         : in     vl_logic_vector(1 downto 0);
        rreglock        : in     vl_logic;
        rprelock        : in     vl_logic;
        rnenlock        : in     vl_logic;
        rspare0         : in     vl_logic;
        nclrlock        : in     vl_logic;
        rplllock        : in     vl_logic;
        rkcnt_l         : in     vl_logic_vector(1 downto 0);
        rkcnt_m         : in     vl_logic_vector(10 downto 8);
        rkcntct         : in     vl_logic_vector(2 downto 0);
        rmcnt_l         : in     vl_logic_vector(2 downto 0);
        rmcnt_m         : in     vl_logic_vector(11 downto 8);
        rmcntct         : in     vl_logic_vector(2 downto 0);
        rncnt_l         : in     vl_logic_vector(2 downto 0);
        rncnt_m         : in     vl_logic_vector(11 downto 8);
        rncntct         : in     vl_logic_vector(2 downto 0)
    );
end apex_pll;

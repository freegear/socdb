library verilog;
use verilog.vl_types.all;
entity VideoCSC is
    port(
        Clk             : in     vl_logic;
        nRST            : in     vl_logic;
        ValidIn         : in     vl_logic;
        Yin             : in     vl_logic_vector(7 downto 0);
        Cbin            : in     vl_logic_vector(7 downto 0);
        Crin            : in     vl_logic_vector(7 downto 0);
        ValidOut        : out    vl_logic;
        Rout            : out    vl_logic_vector(7 downto 0);
        Gout            : out    vl_logic_vector(7 downto 0);
        Bout            : out    vl_logic_vector(7 downto 0)
    );
end VideoCSC;

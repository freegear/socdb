library verilog;
use verilog.vl_types.all;
entity VideoFC is
    port(
        Clk             : in     vl_logic;
        nRST            : in     vl_logic;
        ValidIn         : in     vl_logic;
        Yin             : in     vl_logic_vector(7 downto 0);
        Cin             : in     vl_logic_vector(7 downto 0);
        ValidOut        : out    vl_logic;
        Yout            : out    vl_logic_vector(7 downto 0);
        CbOut           : out    vl_logic_vector(7 downto 0);
        CrOut           : out    vl_logic_vector(7 downto 0)
    );
end VideoFC;

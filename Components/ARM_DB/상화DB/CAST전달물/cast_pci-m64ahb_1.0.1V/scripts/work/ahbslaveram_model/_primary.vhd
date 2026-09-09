library verilog;
use verilog.vl_types.all;
entity ahbslaveram_model is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        shsel           : in     vl_logic;
        shwrite         : in     vl_logic;
        shtrans         : in     vl_logic_vector(1 downto 0);
        shsize          : in     vl_logic_vector(2 downto 0);
        shburst         : in     vl_logic_vector(2 downto 0);
        shaddr          : in     vl_logic_vector(31 downto 0);
        shwdata         : in     vl_logic_vector(31 downto 0);
        shrdata         : out    vl_logic_vector(31 downto 0);
        shready         : out    vl_logic;
        shresp          : out    vl_logic_vector(1 downto 0)
    );
end ahbslaveram_model;

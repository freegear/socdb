library verilog;
use verilog.vl_types.all;
entity ahbslave is
    generic(
        addr_width      : integer := 32
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        shsel           : in     vl_logic;
        shwrite         : in     vl_logic;
        shtrans         : in     vl_logic_vector(1 downto 0);
        shsize          : in     vl_logic_vector(2 downto 0);
        shburst         : in     vl_logic_vector(2 downto 0);
        shaddr          : in     vl_logic_vector;
        ldrdy           : in     vl_logic;
        lerr            : in     vl_logic;
        lretry          : in     vl_logic;
        shready         : out    vl_logic;
        shresp          : out    vl_logic_vector(1 downto 0);
        lsel            : out    vl_logic;
        lwe             : out    vl_logic;
        lrd             : out    vl_logic;
        lben            : out    vl_logic_vector(3 downto 0);
        laddr           : out    vl_logic_vector
    );
end ahbslave;

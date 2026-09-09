library verilog;
use verilog.vl_types.all;
entity dmacchregfile is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        fifowren        : in     vl_logic;
        fifowrptr       : in     vl_logic_vector(1 downto 0);
        fifowrdata      : in     vl_logic_vector(31 downto 0);
        fifowrmask      : in     vl_logic_vector(31 downto 0);
        fifordptr       : in     vl_logic_vector(1 downto 0);
        fiforddata      : out    vl_logic_vector(31 downto 0)
    );
end dmacchregfile;

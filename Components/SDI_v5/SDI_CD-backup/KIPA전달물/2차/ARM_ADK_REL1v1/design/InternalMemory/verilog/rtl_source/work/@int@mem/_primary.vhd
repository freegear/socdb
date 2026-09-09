library verilog;
use verilog.vl_types.all;
entity intmem is
    generic(
        membits         : integer := 10;
        filename        : string  := "intram.dat"
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hwrite          : in     vl_logic;
        hsize           : in     vl_logic_vector(2 downto 0);
        hwdata          : in     vl_logic_vector(31 downto 0);
        hselintmem      : in     vl_logic;
        hready          : in     vl_logic;
        hrdata          : out    vl_logic_vector(31 downto 0);
        hreadyout       : out    vl_logic;
        hresp           : out    vl_logic_vector(1 downto 0)
    );
end intmem;

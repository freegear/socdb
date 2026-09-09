library verilog;
use verilog.vl_types.all;
entity pld_slave is
    port(
        hclock          : in     vl_logic;
        hsel            : in     vl_logic;
        hresetn         : in     vl_logic;
        hwrite          : in     vl_logic;
        haddress        : in     vl_logic_vector(31 downto 0);
        hburst          : in     vl_logic_vector(2 downto 0);
        hsize           : in     vl_logic_vector(1 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hwdata          : in     vl_logic_vector(31 downto 0);
        hready          : out    vl_logic;
        hrdata          : out    vl_logic_vector(31 downto 0);
        hresp           : out    vl_logic_vector(1 downto 0)
    );
end pld_slave;

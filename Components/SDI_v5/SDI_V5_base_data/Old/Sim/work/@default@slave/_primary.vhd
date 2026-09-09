library verilog;
use verilog.vl_types.all;
entity DefaultSlave is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HSEL            : in     vl_logic;
        HREADY          : in     vl_logic;
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0);
        SCANENABLE      : in     vl_logic;
        SCANINHCLK      : in     vl_logic;
        SCANOUTHCLK     : out    vl_logic
    );
end DefaultSlave;

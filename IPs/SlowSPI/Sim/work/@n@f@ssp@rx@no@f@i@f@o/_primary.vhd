library verilog;
use verilog.vl_types.all;
entity nfssprxnofifo is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        roric           : in     vl_logic;
        ms              : in     vl_logic;
        rxfwr           : in     vl_logic;
        rxfrdptrinc     : in     vl_logic;
        srxfwrdata      : in     vl_logic_vector(15 downto 0);
        mrxfwrdata      : in     vl_logic_vector(15 downto 0);
        rxwrite         : out    vl_logic;
        rne             : out    vl_logic;
        rorris          : out    vl_logic;
        rxfrddata       : out    vl_logic_vector(15 downto 0)
    );
end nfssprxnofifo;

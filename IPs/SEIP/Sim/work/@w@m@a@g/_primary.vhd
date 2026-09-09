library verilog;
use verilog.vl_types.all;
entity WMAG is
    port(
        WDB             : in     vl_logic_vector(15 downto 0);
        WADI            : in     vl_logic_vector(15 downto 0);
        XRST            : in     vl_logic;
        WADBLE          : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        MCK             : in     vl_logic;
        WR3LE           : in     vl_logic;
        WMADR           : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end WMAG;

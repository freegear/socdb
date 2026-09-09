library verilog;
use verilog.vl_types.all;
entity FG20 is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        SFT             : in     vl_logic;
        SAWPH           : in     vl_logic;
        RECPH           : in     vl_logic;
        \ABS\           : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end FG20;

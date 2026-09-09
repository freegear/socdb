library verilog;
use verilog.vl_types.all;
entity TSPTG is
    port(
        A               : in     vl_logic_vector(4 downto 0);
        Y0              : out    vl_logic;
        Y19             : out    vl_logic;
        Y23             : out    vl_logic
    );
end TSPTG;

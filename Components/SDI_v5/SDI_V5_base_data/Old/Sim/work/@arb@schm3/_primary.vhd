library verilog;
use verilog.vl_types.all;
entity ArbSchm3 is
    port(
        Request         : in     vl_logic_vector(3 downto 0);
        SplitMaskDefault: in     vl_logic;
        BurstInProgress : in     vl_logic;
        AddrMaster      : in     vl_logic_vector(3 downto 0);
        TopRequest      : out    vl_logic_vector(3 downto 0)
    );
end ArbSchm3;

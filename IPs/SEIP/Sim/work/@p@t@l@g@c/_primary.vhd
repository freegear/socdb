library verilog;
use verilog.vl_types.all;
entity PTLGC is
    port(
        PIT             : in     vl_logic_vector(1 downto 0);
        P1              : in     vl_logic;
        P2              : in     vl_logic;
        P3              : in     vl_logic;
        P0              : in     vl_logic;
        CI              : in     vl_logic;
        PITA            : out    vl_logic_vector(3 downto 0);
        RLD             : out    vl_logic_vector(2 downto 0)
    );
end PTLGC;

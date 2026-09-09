library verilog;
use verilog.vl_types.all;
entity sync_x15 is
    port(
        resetn          : in     vl_logic;
        clk1            : in     vl_logic;
        stb1            : in     vl_logic_vector(14 downto 0);
        clk2            : in     vl_logic;
        stb2            : out    vl_logic_vector(14 downto 0)
    );
end sync_x15;

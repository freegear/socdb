library verilog;
use verilog.vl_types.all;
entity NFRnBFilter is
    generic(
        FILTER          : integer := 3
    );
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        RnB1In          : in     vl_logic;
        RnB0In          : in     vl_logic;
        FiltRnB1Out     : out    vl_logic;
        FiltRnB0Out     : out    vl_logic
    );
end NFRnBFilter;

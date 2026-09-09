library verilog;
use verilog.vl_types.all;
entity ETREG is
    port(
        EDB             : in     vl_logic_vector(19 downto 0);
        ET5EN           : in     vl_logic;
        TE              : in     vl_logic;
        XRST            : in     vl_logic;
        ET4EN           : in     vl_logic;
        ET3EN           : in     vl_logic;
        ET2EN           : in     vl_logic;
        ET1EN           : in     vl_logic;
        ET0EN           : in     vl_logic;
        ETLE            : in     vl_logic;
        MCK             : in     vl_logic;
        TI              : in     vl_logic;
        ETO             : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end ETREG;

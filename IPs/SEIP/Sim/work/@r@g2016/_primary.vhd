library verilog;
use verilog.vl_types.all;
entity RG2016 is
    port(
        D               : in     vl_logic_vector(19 downto 0);
        S               : in     vl_logic_vector(3 downto 0);
        RN              : in     vl_logic;
        EN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        MCK             : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end RG2016;

library verilog;
use verilog.vl_types.all;
entity RG44 is
    port(
        D               : in     vl_logic_vector(3 downto 0);
        S1              : in     vl_logic;
        S0              : in     vl_logic;
        EN              : in     vl_logic;
        TE              : in     vl_logic;
        RN              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        Y               : out    vl_logic_vector(3 downto 0);
        \TO\            : out    vl_logic
    );
end RG44;

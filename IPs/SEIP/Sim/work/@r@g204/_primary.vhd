library verilog;
use verilog.vl_types.all;
entity RG204 is
    port(
        D               : in     vl_logic_vector(19 downto 0);
        S1              : in     vl_logic;
        S0              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        W3LE            : in     vl_logic;
        W2LE            : in     vl_logic;
        W1LE            : in     vl_logic;
        W0LE            : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end RG204;

library verilog;
use verilog.vl_types.all;
entity DS086 is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        C               : in     vl_logic_vector(7 downto 0);
        D               : in     vl_logic_vector(7 downto 0);
        E               : in     vl_logic_vector(7 downto 0);
        F               : in     vl_logic_vector(7 downto 0);
        FE              : in     vl_logic;
        EE              : in     vl_logic;
        DE              : in     vl_logic;
        CE              : in     vl_logic;
        BE              : in     vl_logic;
        AE              : in     vl_logic;
        Y               : out    vl_logic_vector(7 downto 0)
    );
end DS086;

library verilog;
use verilog.vl_types.all;
entity OFR8 is
    port(
        D               : in     vl_logic_vector(7 downto 0);
        S               : in     vl_logic_vector(2 downto 0);
        RN              : in     vl_logic;
        SE              : in     vl_logic;
        OFDT            : in     vl_logic;
        TE              : in     vl_logic;
        DE4             : in     vl_logic;
        DE3             : in     vl_logic;
        DE2             : in     vl_logic;
        DE1             : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        Q               : out    vl_logic_vector(7 downto 0);
        CHQ             : out    vl_logic;
        \TO\            : out    vl_logic
    );
end OFR8;

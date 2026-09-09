library verilog;
use verilog.vl_types.all;
entity Decoder is
    port(
        HADDR           : in     vl_logic_vector(31 downto 0);
        BootMode        : in     vl_logic;
        HSELS0          : out    vl_logic;
        HSELS1          : out    vl_logic;
        HSELS1_0        : out    vl_logic;
        HSELS1_1        : out    vl_logic;
        HSELS1_2        : out    vl_logic;
        HSELS1_3        : out    vl_logic;
        HSELS2          : out    vl_logic;
        HSELS3          : out    vl_logic;
        HSELSR          : out    vl_logic
    );
end Decoder;

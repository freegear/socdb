library verilog;
use verilog.vl_types.all;
entity System_Decoder is
    port(
        HADDR           : in     vl_logic_vector(31 downto 0);
        Remap           : in     vl_logic;
        HSELS0B         : out    vl_logic;
        HSELS0R         : out    vl_logic;
        HSELS0EM        : out    vl_logic;
        HSELS0IF        : out    vl_logic;
        HSELS0          : out    vl_logic;
        HSELS1          : out    vl_logic;
        HSELS2          : out    vl_logic;
        HSELS3          : out    vl_logic;
        HSELS4          : out    vl_logic;
        HSELS5          : out    vl_logic;
        HSELS6          : out    vl_logic;
        HSELS7          : out    vl_logic;
        HSELS_Resv1     : out    vl_logic;
        HSELS_Resv2     : out    vl_logic;
        HSELS_Resv3     : out    vl_logic;
        HSELS_Abort     : out    vl_logic
    );
end System_Decoder;

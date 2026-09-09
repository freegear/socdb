library verilog;
use verilog.vl_types.all;
entity LCD_TOP is
    generic(
        INIT_PHASE      : integer := 0;
        DATA_PHASE      : integer := 1
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        address         : in     vl_logic_vector(7 downto 0);
        data_in         : in     vl_logic_vector(31 downto 0);
        write           : in     vl_logic;
        enable          : in     vl_logic;
        data_out        : out    vl_logic_vector(7 downto 0);
        mode            : out    vl_logic_vector(1 downto 0);
        init_done       : out    vl_logic;
        rd_address      : out    vl_logic_vector(5 downto 0);
        read_reg        : out    vl_logic_vector(31 downto 0);
        phase           : out    vl_logic;
        lcd_en          : out    vl_logic
    );
end LCD_TOP;

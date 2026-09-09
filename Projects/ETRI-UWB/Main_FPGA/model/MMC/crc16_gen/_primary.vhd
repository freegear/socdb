library verilog;
use verilog.vl_types.all;
entity crc16_gen is
    generic(
        seed            : integer := 0
    );
    port(
        mresetn         : in     vl_logic;
        mclk            : in     vl_logic;
        crcin           : in     vl_logic;
        crc_on_off      : in     vl_logic;
        wr_crc_enable   : in     vl_logic;
        crc_enable      : in     vl_logic;
        crc_check       : in     vl_logic;
        crc_ok          : out    vl_logic;
        crc16           : out    vl_logic_vector(15 downto 0)
    );
end crc16_gen;

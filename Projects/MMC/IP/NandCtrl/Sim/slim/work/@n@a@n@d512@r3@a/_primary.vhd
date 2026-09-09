library verilog;
use verilog.vl_types.all;
entity NAND512R3A is
    generic(
        NUM_BLKS        : integer := 5;
        MEM_SIZE        : integer := 84480;
        CMD_READ_A      : integer := 0;
        CMD_READ_B      : integer := 1;
        CMD_READ_C      : integer := 80;
        CMD_RESET       : integer := 255;
        CMD_READ_ES     : integer := 144;
        CMD_READ_SR     : integer := 112;
        CMD_PAGE_PROGRAM_1: integer := 128;
        CMD_PAGE_PROGRAM_2: integer := 16;
        CMD_COPY_BACK_PG: integer := 138;
        CMD_BLOCK_ERASE_1: integer := 96;
        CMD_BLOCK_ERASE_2: integer := 208;
        OP_READY        : integer := 0;
        OP_READ         : integer := 1;
        OP_PROGRAM      : integer := 2;
        OP_ERASE        : integer := 3
    );
    port(
        IO              : inout  vl_logic_vector(7 downto 0);
        CE              : in     vl_logic;
        WE              : in     vl_logic;
        RE              : in     vl_logic;
        WP              : in     vl_logic;
        CLE             : in     vl_logic;
        ALE             : in     vl_logic;
        RY_BY           : out    vl_logic;
        VDD             : in     vl_logic;
        VSS             : in     vl_logic
    );
end NAND512R3A;

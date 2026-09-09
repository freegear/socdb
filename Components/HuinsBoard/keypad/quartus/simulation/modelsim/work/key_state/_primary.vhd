library verilog;
use verilog.vl_types.all;
entity key_state is
    generic(
        Hig             : integer := 1;
        Low             : integer := 0;
        IDLE            : integer := 0;
        DATA_PHASE      : integer := 1;
        WAIT_STATE      : integer := 2;
        READ_STATE      : integer := 3;
        WAIT_STATE2     : integer := 4
    );
    port(
        reset           : in     vl_logic;
        clock           : in     vl_logic;
        DATA_AVAIL      : in     vl_logic;
        DATA_A          : in     vl_logic;
        DATA_B          : in     vl_logic;
        DATA_C          : in     vl_logic;
        DATA_D          : in     vl_logic;
        address         : in     vl_logic_vector(31 downto 0);
        write           : in     vl_logic;
        read_data       : out    vl_logic_vector(31 downto 0);
        Int_reg         : out    vl_logic;
        Hready_i        : out    vl_logic
    );
end key_state;

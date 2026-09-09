library verilog;
use verilog.vl_types.all;
entity DmARIf is
    generic(
        RID_WIDTH       : integer := 2;
        DATA_WIDTH      : integer := 32;
        AIDLE           : integer := 0;
        AWAIT           : integer := 1;
        ST_DIDLE        : integer := 1;
        ST_DDATA        : integer := 0;
        SM_WIDTH        : integer := 4;
        IDLE            : integer := 0;
        CALC_LEN        : integer := 1;
        RD_CMD          : integer := 2;
        RD_DATA         : integer := 3
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        ARID            : out    vl_logic_vector;
        ARADDR          : out    vl_logic_vector(31 downto 0);
        ARLEN           : out    vl_logic_vector(3 downto 0);
        ARSIZE          : out    vl_logic_vector(2 downto 0);
        ARBURST         : out    vl_logic_vector(1 downto 0);
        ARLOCK          : out    vl_logic_vector(1 downto 0);
        ARCACHE         : out    vl_logic_vector(3 downto 0);
        ARPROT          : out    vl_logic_vector(2 downto 0);
        ARVALID         : out    vl_logic;
        ARREADY         : in     vl_logic;
        RID             : in     vl_logic_vector;
        RDATA           : in     vl_logic_vector;
        RRESP           : in     vl_logic_vector(1 downto 0);
        RLAST           : in     vl_logic;
        RVALID          : in     vl_logic;
        RREADY          : out    vl_logic;
        grd             : in     vl_logic;
        grid            : in     vl_logic_vector;
        graddr          : in     vl_logic_vector(31 downto 0);
        grsize          : in     vl_logic_vector(4 downto 0);
        grbe            : out    vl_logic_vector;
        grdata          : out    vl_logic_vector;
        grvalid         : out    vl_logic;
        grdid           : out    vl_logic_vector;
        grlast          : out    vl_logic;
        grbusy          : out    vl_logic
    );
end DmARIf;

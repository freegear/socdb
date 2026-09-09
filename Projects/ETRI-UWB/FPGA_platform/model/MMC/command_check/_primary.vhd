library verilog;
use verilog.vl_types.all;
entity command_check is
    generic(
        mmc_idle        : integer := 0;
        mmc_ready       : integer := 1;
        mmc_ident       : integer := 2;
        mmc_stby        : integer := 3;
        mmc_tran        : integer := 4;
        mmc_data        : integer := 5;
        mmc_rcv         : integer := 6;
        mmc_prg         : integer := 7;
        mmc_dis         : integer := 8;
        mmc_btst        : integer := 9;
        mmc_irq         : integer := 10;
        spi_idle        : integer := 16;
        spi_stby        : integer := 19;
        spi_data        : integer := 21;
        spi_rcv         : integer := 22;
        spi_prg         : integer := 23;
        spi_dis         : integer := 24;
        mmc_ina         : integer := 11;
        ifield          : integer := 0;
        sfield          : integer := 1;
        tfield          : integer := 2;
        xfield          : integer := 3;
        afield          : integer := 4;
        cfield          : integer := 5;
        efield          : integer := 6;
        hfield          : integer := 7;
        rfield          : integer := 8;
        lfield          : integer := 9;
        dfield          : integer := 10;
        ufield          : integer := 11;
        bfield          : integer := 12;
        pfield          : integer := 13;
        gfield          : integer := 14
    );
    port(
        mresetn         : in     vl_logic;
        mclk            : in     vl_logic;
        mcselect        : in     vl_logic;
        mcommand        : in     vl_logic_vector(47 downto 0);
        mcstate         : in     vl_logic_vector(4 downto 0);
        crc7_ok         : in     vl_logic;
        mrca_match      : in     vl_logic;
        cmd_eoe         : in     vl_logic;
        mgo_irq_state   : in     vl_logic;
        mstby_cmd2      : in     vl_logic;
        mstby_cmd3      : in     vl_logic;
        mbusy_cmd12     : in     vl_logic;
        mcmddef         : in     vl_logic_vector(63 downto 0);
        resp_cmd_error  : in     vl_logic;
        no_response     : out    vl_logic;
        cmd_error       : out    vl_logic_vector(7 downto 0)
    );
end command_check;

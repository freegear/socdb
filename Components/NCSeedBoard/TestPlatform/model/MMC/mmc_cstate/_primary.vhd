library verilog;
use verilog.vl_types.all;
entity mmc_cstate is
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
        mstatus         : in     vl_logic_vector(31 downto 0);
        mcstatewr       : in     vl_logic_vector(3 downto 0);
        mcstatewr_manu  : in     vl_logic;
        rd_field        : in     vl_logic_vector(3 downto 0);
        crc16_ok        : in     vl_logic;
        cstnormal       : in     vl_logic_vector(4 downto 0);
        cststop         : in     vl_logic_vector(4 downto 0);
        mocr            : in     vl_logic_vector(31 downto 0);
        mcstnorm        : in     vl_logic_vector(4 downto 0);
        mcststop        : in     vl_logic_vector(4 downto 0);
        mcstmanu        : in     vl_logic_vector(4 downto 0);
        mdis2rcv        : in     vl_logic;
        mcstate         : out    vl_logic_vector(4 downto 0)
    );
end mmc_cstate;

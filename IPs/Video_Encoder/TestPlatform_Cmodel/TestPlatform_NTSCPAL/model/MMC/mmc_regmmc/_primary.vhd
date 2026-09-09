library verilog;
use verilog.vl_types.all;
entity mmc_regmmc is
    port(
        mresetn         : in     vl_logic;
        msreset         : in     vl_logic;
        hsreset         : in     vl_logic;
        mclk            : in     vl_logic;
        hmmcxwr         : in     vl_logic_vector(24 downto 0);
        hmmcxrd         : in     vl_logic_vector(24 downto 0);
        hcommand_ok3wr  : in     vl_logic;
        hwdata          : in     vl_logic_vector(31 downto 0);
        mocr_update     : in     vl_logic;
        mrca_update     : in     vl_logic;
        mrca_up_data    : in     vl_logic_vector(15 downto 0);
        \Access\        : in     vl_logic_vector(1 downto 0);
        index           : in     vl_logic_vector(7 downto 0);
        value           : in     vl_logic_vector(7 downto 0);
        switch_error    : in     vl_logic;
        wr_block_buffer_4word: in     vl_logic_vector(127 downto 0);
        mcmdindex       : in     vl_logic_vector(5 downto 0);
        mcommand_ok     : in     vl_logic;
        mwrfield        : in     vl_logic_vector(3 downto 0);
        wr_count        : in     vl_logic_vector(15 downto 0);
        cid_csd_overwrite: in     vl_logic;
        csd_update      : in     vl_logic_vector(127 downto 0);
        hcid            : out    vl_logic_vector(127 downto 0);
        hrca            : out    vl_logic_vector(15 downto 0);
        hdsr            : out    vl_logic_vector(15 downto 0);
        hcsd            : out    vl_logic_vector(127 downto 0);
        hext_csd        : out    vl_logic_vector(191 downto 0);
        hsfr_out        : out    vl_logic_vector(7 downto 0);
        hsfr_read       : out    vl_logic_vector(31 downto 0);
        hbuswidth_cmd   : out    vl_logic_vector(31 downto 0);
        hocr            : out    vl_logic_vector(31 downto 0);
        hcommand_ok3    : out    vl_logic
    );
end mmc_regmmc;

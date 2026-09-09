--------------------------------------------------------------------------------
--  File Name: s25fl008a.vhd
--------------------------------------------------------------------------------
-- Copyright (C) 2004-2005 Spansion, LLC.
--
--  MODIFICATION HISTORY:
--
--  version: |  author:        | mod date: | changes made:
--   V1.0     J.Bogosavljevic    04 Aug 16   Inital Release
--   V1.1     R. Munden          05 Mar 09   Nomenclature changed from s25fl008m
--------------------------------------------------------------------------------
--  PART DESCRIPTION:
--
--  Library:    FLASH
--  Technology: Flash Memory
--  Part:       s25fl008a
--
--   Description: 8 Megabit Serial Flash Memory
--
--------------------------------------------------------------------------------
--  Known Bugs:
--
--------------------------------------------------------------------------------
LIBRARY IEEE;
    USE IEEE.std_logic_1164.ALL;
    USE IEEE.VITAL_timing.ALL;
    USE IEEE.VITAL_primitives.ALL;
    USE STD.textio.ALL;

LIBRARY FMF;
    USE FMF.gen_utils.ALL;
    USE FMF.conversions.ALL;

-------------------------------------------------------------------------------
-- ENTITY DECLARATION
-------------------------------------------------------------------------------
ENTITY s25fl008a IS
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_SCK            : VitalDelayType01 := VitalZeroDelay01;
        tipd_SI             : VitalDelayType01 := VitalZeroDelay01;
        tipd_CSNeg          : VitalDelayType01 := VitalZeroDelay01;
        tipd_HOLDNeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_WNeg           : VitalDelayType01 := VitalZeroDelay01;

        -- tpd delays
        tpd_SCK_SO          : VitalDelayType01Z := UnitDelay01Z;--tV
        tpd_CSNeg_SO        : VitalDelayType01Z := UnitDelay01Z;--tDIS
        tpd_HOLDNeg_SO      : VitalDelayType01Z := UnitDelay01Z;--tLZ,tHZ

        --tsetup values
        tsetup_SI_SCK       : VitalDelayType := UnitDelay;  --tsuDAT /
        tsetup_CSNeg_SCK    : VitalDelayType := UnitDelay;  --tCSS /
        tsetup_HOLDNeg_SCK  : VitalDelayType := UnitDelay;  --tHD, tHC /
        tsetup_WNeg_CSNeg   : VitalDelayType := UnitDelay;  --tWPS \

        --thold values
        thold_SI_SCK        : VitalDelayType := UnitDelay;  --thdDAT /
        thold_CSNeg_SCK     : VitalDelayType := UnitDelay;  --tCSH /
        thold_HOLDNeg_SCK   : VitalDelayType := UnitDelay;  --tCD , tCH/
        thold_WNeg_CSNeg    : VitalDelayType := UnitDelay;  --tWPH \

        --tpw values: pulse width
        tpw_SCK_posedge     : VitalDelayType := UnitDelay; --tWH
        tpw_SCK_negedge     : VitalDelayType := UnitDelay; --tWL
        tpw_CSNeg_posedge   : VitalDelayType := UnitDelay; --tCS

        -- tperiod min (calculated as 1/max freq)
        tperiod_SCK_rd      : VitalDelayType := UnitDelay; -- fSCK=33MHz
        tperiod_SCK_fast_rd : VitalDelayType := UnitDelay; -- fSCK=50MHz
        -- tdevice values: values for internal delays
            -- Page Program Operation
        tdevice_PP          : VitalDelayType    := 3 ms;   --tPP
            --Sector Erase Operation
        tdevice_SE          : VitalDelayType    := 3 sec;  --tSE       
            --Bulk Erase Operation
        tdevice_BE          : VitalDelayType    := 96 sec; --tBE
            --Write Status Register Operation
        tdevice_WR          : VitalDelayType    := 65 ms;  --tW
            --Deep Power Down
        tdevice_DP          : VitalDelayType    := 3 us;   --tDP
            --Release from Software Protect Mode
        tdevice_RES         : VitalDelayType    := 30 us;  --tRES
            --VCC (min) to CS# Low
        tdevice_PU          : VitalDelayType    := 4 ms;
        -- generic control parameters
        InstancePath        : STRING    := DefaultInstancePath;
        TimingChecksOn      : BOOLEAN   := DefaultTimingChecks;
        MsgOn               : BOOLEAN   := DefaultMsgOn;
        XOn                 : BOOLEAN   := DefaultXon;
        -- memory file to be loaded
        mem_file_name       : STRING    := "s25fl008a.mem";

        UserPreload         : BOOLEAN   := FALSE; --TRUE;
        LongTimming         : BOOLEAN   := TRUE;

        -- For FMF SDF technology file usage
        TimingModel         : STRING    := DefaultTimingModel
    );
    PORT (
        SCK             : IN    std_ulogic := 'U'; -- serial clock input
        SI              : IN    std_ulogic := 'U'; -- serial data input
        CSNeg           : IN    std_ulogic := 'U'; -- chip select input
        HOLDNeg         : IN    std_ulogic := 'U'; -- hold input
        WNeg            : IN    std_ulogic := 'U'; -- write protect input
        SO              : OUT   std_ulogic := 'U'  -- serial data output
    );
    ATTRIBUTE VITAL_LEVEL0 of s25fl008a : ENTITY IS TRUE;
END s25fl008a;

-------------------------------------------------------------------------------
-- ARCHITECTURE DECLARATION
-------------------------------------------------------------------------------
ARCHITECTURE vhdl_behavioral of s25fl008a IS
    ATTRIBUTE VITAL_LEVEL0 OF vhdl_behavioral : ARCHITECTURE IS TRUE;

    CONSTANT PartID        : STRING  := "s25fl008a";
    CONSTANT MaxData       : NATURAL := 16#FF#; --255;
    CONSTANT SecSize       : NATURAL := 16#FFFF#; --65535
    CONSTANT SecNum        : NATURAL := 15;
    -- address bits 19 downto 0 are used, others are ignored
    -- but 24 bits are used because of 3 address bytes in transactions
    CONSTANT HiAddrBit     : NATURAL := 23;
    CONSTANT HiAddrBitUsed : NATURAL := 19;
    CONSTANT AddrRange     : NATURAL := 16#FFFFF#;
    CONSTANT BYTE          : NATURAL := 8;
    --Electronic Signature
    CONSTANT ES            : NATURAL := 16#14#;-- check
    --Device ID
    --Manufacturer Identification && Memory Type && Memory Capacity
    CONSTANT DeviceID      : NATURAL := 16#010207#;

    -- interconnect path delay signals
    SIGNAL SCK_ipd         : std_ulogic := 'U';
    SIGNAL SI_ipd          : std_ulogic := 'U';
    SIGNAL CSNeg_ipd       : std_ulogic := 'U';
    SIGNAL HOLDNeg_ipd     : std_ulogic := 'U';
    SIGNAL WNeg_ipd        : std_ulogic := 'U';

    ---  internal delays
    SIGNAL PP_in           : std_ulogic := '0';
    SIGNAL PP_out          : std_ulogic := '0';
    SIGNAL PU_in           : std_ulogic := '0';
    SIGNAL PU_out          : std_ulogic := '0';
    SIGNAL SE_in           : std_ulogic := '0';
    SIGNAL SE_out          : std_ulogic := '0';
    SIGNAL BE_in           : std_ulogic := '0';
    SIGNAL BE_out          : std_ulogic := '0';
    SIGNAL WR_in           : std_ulogic := '0';
    SIGNAL WR_out          : std_ulogic := '0';
    SIGNAL DP_in           : std_ulogic := '0';
    SIGNAL DP_out          : std_ulogic := '0';
    SIGNAL RES_in          : std_ulogic := '0';
    SIGNAL RES_out         : std_ulogic := '0';

BEGIN
    ---------------------------------------------------------------------------
    -- Internal Delays
    ---------------------------------------------------------------------------
    -- Artificial VITAL primitives to incorporate internal delays
    PP     :VitalBuf(PP_out,  PP_in,      (tdevice_PP     ,UnitDelay));
    PU     :VitalBuf(PU_out,  PU_in,      (tdevice_PU     ,UnitDelay));
    SE     :VitalBuf(SE_out,  SE_in,      (tdevice_SE     ,UnitDelay));
    BE     :VitalBuf(BE_out,  BE_in,      (tdevice_BE     ,UnitDelay));
    WR     :VitalBuf(WR_out,  WR_in,      (tdevice_WR     ,UnitDelay));
    DP     :VitalBuf(DP_out,  DP_in,      (tdevice_DP     ,UnitDelay));
    RES    :VitalBuf(RES_out, RES_in,     (tdevice_RES    ,UnitDelay));

    ---------------------------------------------------------------------------
    -- Wire Delays
    ---------------------------------------------------------------------------
    WireDelay : BLOCK
    BEGIN
        w_1 : VitalWireDelay (SCK_ipd,     SCK,     tipd_SCK);
        w_2 : VitalWireDelay (SI_ipd,      SI,      tipd_SI);
        w_3 : VitalWireDelay (CSNeg_ipd,   CSNeg,   tipd_CSNeg);
        w_4 : VitalWireDelay (HOLDNeg_ipd, HOLDNeg, tipd_HOLDNeg);
        w_5 : VitalWireDelay (WNeg_ipd,    WNeg,    tipd_WNeg);
    END BLOCK;

    ---------------------------------------------------------------------------
    -- Main Behavior Block
    ---------------------------------------------------------------------------
    Behavior: BLOCK

        -- State Machine : State_Type
        TYPE state_type IS (IDLE,
                            DP_DOWN,
                            WRITE_SR,
                            SECTOR_ER,
                            BULK_ER,
                            PAGE_PG
                            );

        -- Instruction Type
        TYPE instruction_type IS (NONE,
                                  WREN,
                                  WRDI,
                                  RDSR,
                                  WRSR,
                                  READ,
                                  FAST_READ,
                                  RDID,
                                  SE,
                                  BE,
                                  PP,
                                  DP,
                                  RES_READ_ES
                                  );

        TYPE WByteType IS ARRAY (0 TO 255) OF INTEGER RANGE -1 TO MaxData;
        --Flash Memory Array
        TYPE MemArray IS ARRAY (0 TO AddrRange) OF INTEGER RANGE -1 TO MaxData;

    ---------------------------------------------------------------------------
    --  memory declaration
    ---------------------------------------------------------------------------
        SHARED VARIABLE Mem     : MemArray := (OTHERS => MaxData);

        -- states
        SIGNAL current_state    : state_type;  --
        SIGNAL next_state       : state_type;  --

        SIGNAL WByte            : WByteType := (others => 0);
        SIGNAL Instruct         : instruction_type;
       --zero delay signal
        SIGNAL SO_zd            : std_logic :='Z';
        -- HOLD enable on output data
        SIGNAL SO_z             : std_logic :='Z';
        -- powerup
        SIGNAL PoweredUp        : std_logic := '0';

        SHARED VARIABLE Status_reg   : std_logic_vector(7 downto 0)
                                                := (others => '0');

        SIGNAL Status_reg_in         : std_logic_vector(7 downto 0)
                                              := (others => '0');

        ALIAS WEL    :std_logic IS Status_reg(1);
        ALIAS WIP    :std_logic IS Status_reg(0);
        ALIAS BP0    :std_logic IS Status_reg(2);
        ALIAS BP1    :std_logic IS Status_reg(3);
        ALIAS BP2    :std_logic IS Status_reg(4);
        ALIAS SRWD   :std_logic IS Status_reg(7);
        --Command Register
        SIGNAL write            : std_logic := '0';
        SIGNAL read_out         : std_logic := '0';
        SIGNAL rd               : BOOLEAN   := FALSE;
        SIGNAL fast_rd          : BOOLEAN   := TRUE;
        SIGNAL change_addr      : std_logic := '0';

        --FSM control signals

        SIGNAL PDONE            : std_logic := '1'; -- Page Prog. Done
        SIGNAL PSTART           : std_logic := '0'; -- Start Page Programming

        SIGNAL WDONE            : std_logic := '1'; -- Write. Done
        SIGNAL WSTART           : std_logic := '0'; -- Start Write

        SIGNAL ESTART           : std_logic := '0'; -- Start Erase
        SIGNAL EDONE            : std_logic := '1'; -- Erase Done

        SIGNAL SA               : NATURAL RANGE 0 TO SecNum := 0;
        SIGNAL Byte_number      : NATURAL RANGE 0 TO 255 := 0;

        SHARED VARIABLE Sec_Prot    : std_logic_vector(SecNum downto 0) :=
                                                   (OTHERS => '0');

        SIGNAL Address          : NATURAL RANGE 0 TO AddrRange := 0;
        SIGNAL sect             : NATURAL RANGE 0 TO SecNum := 0;
        -- timing check violation
        SIGNAL Viol                : X01 := '0';

        -- Returns Starting and ending sector address
        PROCEDURE Sesa(
            VARIABLE   AddrLOW  : INOUT NATURAL RANGE 0 to ADDRRange;
            VARIABLE   AddrHIGH : INOUT NATURAL RANGE 0 to ADDRRange;
            VARIABLE   Addr     : NATURAL) IS
            VARIABLE   sector   : NATURAL RANGE 0 TO SecNum;
        BEGIN
            sector   := Addr/16#10000#;
            AddrLOW  := sector*16#10000#;
            AddrHIGH := sector*16#10000# + 16#0FFFF#;
        END Sesa;

        -- Returns Starting and ending page address
        PROCEDURE sepa(
            VARIABLE   AddrLOW  : INOUT NATURAL RANGE 0 to ADDRRange;
            VARIABLE   AddrHIGH : INOUT NATURAL RANGE 0 to ADDRRange;
            VARIABLE   Addr     : NATURAL) IS
            VARIABLE   page     : NATURAL RANGE 0 TO 65535;
        BEGIN
            page     := Addr/16#100#;
            AddrLOW  := Page*16#100#;
            AddrHIGH := Page*16#100# + 16#FF#;
        END sepa;

        -- Read status register, MSB is output first
        --ReadStatusReg(SO_zd, Status_reg, read_cnt);
        PROCEDURE ReadStatusReg (
                       VARIABLE Status_reg  : IN std_logic_vector(7 downto 0);
                       SIGNAL SO_zd         : INOUT std_logic;
                       VARIABLE read_cnt    : INOUT NATURAL
                       ) IS
        BEGIN
            SO_zd <= Status_reg(7-read_cnt);
            read_cnt := read_cnt + 1;
            IF read_cnt = 8 THEN
                read_cnt := 0;
            END IF;
        END ReadStatusReg;

        -- Read Memory, MSB is output first
        --ReadMem(SO_zd, read_cnt, read_addr);
        PROCEDURE ReadMem (
                       SIGNAL SO_zd         : INOUT std_logic;
                       VARIABLE read_cnt    : INOUT NATURAL;
                       VARIABLE read_addr   : INOUT NATURAL RANGE 0 TO AddrRANGE
                       ) IS
        VARIABLE data_out : std_logic_vector(7 downto 0);
        BEGIN
            --Read Memory array
            data_out := to_slv(Mem(read_addr),8);
            SO_zd <= data_out(7-read_cnt);
            read_cnt := read_cnt + 1;
            IF read_cnt = 8 THEN
                read_cnt := 0;
                IF read_addr = AddrRANGE THEN
                    read_addr := 0;
                ELSE
                    read_addr := read_addr + 1;
                END IF;
            END IF;
        END ReadMem;

        -- Read ES, MSB is output first
        --ReadES(SO_zd, read_cnt);
        PROCEDURE ReadEs (
                       SIGNAL SO_zd         : INOUT std_logic;
                       VARIABLE read_cnt    : INOUT NATURAL
                       ) IS
        VARIABLE data_out : std_logic_vector(7 downto 0);
        BEGIN

            data_out := to_slv(ES,8);
            SO_zd    <= data_out(7 - read_cnt);
            read_cnt := read_cnt + 1;
            IF read_cnt = 8 THEN
                read_cnt := 0;
            END IF;
        END ReadEs;

        PROCEDURE ReadDeviceID (
                       SIGNAL SO_zd         : INOUT std_logic;
                       VARIABLE read_cnt    : INOUT NATURAL
                       ) IS
        VARIABLE ident_out : std_logic_vector(23 downto 0);
        BEGIN
            ident_out := to_slv(DeviceID,24);
            SO_zd     <= ident_out(23-read_cnt);
            read_cnt  := read_cnt + 1;
            IF read_cnt = 24 THEN
                read_cnt := 0;
            END IF;
        END ReadDeviceID;

        PROCEDURE ReadX (
                       SIGNAL SO_zd         : INOUT std_logic;
                       VARIABLE read_cnt    : INOUT NATURAL
                       ) IS
        BEGIN
            SO_zd <= 'X';
            read_cnt := read_cnt + 1;
            IF read_cnt = 8 THEN
                read_cnt := 0;
            END IF;
        END ReadX;

--         ProtectSectors(BP, Sec_Prot);
        PROCEDURE ProtectSectors (
                   VARIABLE BP        : IN std_logic_vector(2 downto 0);
                   VARIABLE Sec_Prot  : INOUT std_logic_vector(SecNum downto 0)
                   ) IS
        VARIABLE tmp : NATURAL;
        BEGIN
            CASE BP IS
                WHEN "000" =>
                    Sec_Prot := (others => '0');
                WHEN "001" =>--1/16
                    Sec_Prot(SecNum)          := '1';
                    Sec_Prot(SecNum-1 downto 0) := (others => '0');
                WHEN "010" =>-- 1/8
                    tmp := SecNum+1 - (SecNum+1)/8;--14
                    Sec_Prot(SecNum downto tmp):= "11";
                    Sec_Prot(tmp-1 downto 0) := (others => '0');
                WHEN "011" =>-- 1/4
                    tmp := SecNum+1 - (SecNum+1)/4;--12
                    Sec_Prot(SecNum downto tmp):= to_slv(16#F#,4);
                    Sec_Prot(tmp-1 downto 0) := (others => '0');
                WHEN "100" =>-- 1/2
                    tmp := SecNum+1 - (SecNum+1)/2;--8
                    Sec_Prot(SecNum downto tmp):= to_slv(16#FF#,8);
                    Sec_Prot(tmp-1 downto 0) := (others => '0');
                WHEN others =>-- all
                    Sec_Prot := (others => '1');
            END CASE;
        END ProtectSectors;

    BEGIN
   ----------------------------------------------------------------------------
    --Power Up time;
    ---------------------------------------------------------------------------

    PoweredUp <= '1' AFTER tdevice_PU;

    ---------------------------------------------------------------------------
    -- VITAL Timing Checks Procedures
    ---------------------------------------------------------------------------
    VITALTimingCheck: PROCESS(SI_ipd, SCK_ipd, CSNeg_ipd, HOLDNeg_ipd,
                              WNeg_ipd)
         -- Timing Check Variables
        VARIABLE Tviol_SI_SCK     : X01 := '0';
        VARIABLE TD_SI_SCK        : VitalTimingDataType;

        VARIABLE Tviol_HOLD_SCK   : X01 := '0';
        VARIABLE TD_HOLD_SCK      : VitalTimingDataType;

        VARIABLE Tviol_CS_SCK     : X01 := '0';
        VARIABLE TD_CS_SCK        : VitalTimingDataType;

        VARIABLE Tviol_WS_CS      : X01 := '0';
        VARIABLE TD_WS_CS         : VitalTimingDataType;

        VARIABLE Tviol_WH_CS      : X01 := '0';
        VARIABLE TD_WH_CS         : VitalTimingDataType;

        VARIABLE Pviol_CS         : X01 := '0';
        VARIABLE PD_CS            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_SCK        : X01 := '0';
        VARIABLE PD_SCK           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_SCK_rd     : X01 := '0';
        VARIABLE PD_SCK_rd        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_SCK_fast_rd: X01 := '0';
        VARIABLE PD_SCK_fast_rd   : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Violation         : X01 := '0';

    BEGIN
    ---------------------------------------------------------------------------
    -- Timing Check Section
    ---------------------------------------------------------------------------
    IF (TimingChecksOn) THEN

        -- Setup/Hold Check between SI and SCK
        VitalSetupHoldCheck (
            TestSignal      => SI_ipd,
            TestSignalName  => "SI",
            RefSignal       => SCK_ipd,
            RefSignalName   => "SCK",
            SetupHigh       => tsetup_SI_SCK,
            SetupLow        => tsetup_SI_SCK,
            HoldHigh        => thold_SI_SCK,
            HoldLow         => thold_SI_SCK,
            CheckEnabled    => true,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_SI_SCK,
            Violation       => Tviol_SI_SCK
        );

        -- Setup/Hold Check between HOLD# and SCK /
        VitalSetupHoldCheck (
            TestSignal      => HOLDNeg_ipd,
            TestSignalName  => "HOLD#",
            RefSignal       => SCK_ipd,
            RefSignalName   => "SCK",
            SetupHigh       => tsetup_HOLDNeg_SCK,
            SetupLow        => tsetup_HOLDNeg_SCK,
            HoldHigh        => thold_HOLDNeg_SCK,
            HoldLow         => thold_HOLDNeg_SCK,
            CheckEnabled    => true,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_HOLD_SCK,
            Violation       => Tviol_HOLD_SCK
        );

        -- Setup/Hold Check between CS# and SCK
        VitalSetupHoldCheck (
            TestSignal      => CSNeg_ipd,
            TestSignalName  => "CS#",
            RefSignal       => SCK_ipd,
            RefSignalName   => "SCK",
            SetupHigh       => tsetup_CSNeg_SCK,
            SetupLow        => tsetup_CSNeg_SCK,
            HoldHigh        => thold_CSNeg_SCK,
            HoldLow         => thold_CSNeg_SCK,
            CheckEnabled    => true,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_CS_SCK,
            Violation       => Tviol_CS_SCK
        );

        -- Setup Check between W# and CS# \
        VitalSetupHoldCheck (
            TestSignal      => WNeg_ipd,
            TestSignalName  => "W#",
            RefSignal       => CSNeg_ipd,
            RefSignalName   => "CS#",
            SetupHigh       => tsetup_WNeg_CSNeg,
            CheckEnabled    => true,
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_WS_CS,
            Violation       => Tviol_WS_CS
        );

        -- Hold Check between W# and CS# /
        VitalSetupHoldCheck (
            TestSignal      => WNeg_ipd,
            TestSignalName  => "W#",
            RefSignal       => CSNeg_ipd,
            RefSignalName   => "CS#",
            HoldHigh        => thold_WNeg_CSNeg,
            CheckEnabled    => true,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_WH_CS,
            Violation       => Tviol_WH_CS
        );

        -- Period Check CS# m
        VitalPeriodPulseCheck (
            TestSignal      =>  CSNeg_ipd,
            TestSignalName  =>  "CS#",
            PulseWidthHigh  =>  tpw_CSNeg_posedge,
            PeriodData      =>  PD_CS,
            XOn             =>  XOn,
            MsgOn           =>  MsgOn,
            Violation       =>  Pviol_CS,
            HeaderMsg       =>  InstancePath & PartID,
            CheckEnabled    =>  true );

        -- Period Check SCK
        VitalPeriodPulseCheck (
            TestSignal      =>  SCK_ipd,
            TestSignalName  =>  "SCK",
            PulseWidthLow   =>  tpw_SCK_negedge,
            PulseWidthHigh  =>  tpw_SCK_posedge,
            PeriodData      =>  PD_SCK,
            XOn             =>  XOn,
            MsgOn           =>  MsgOn,
            Violation       =>  Pviol_SCK,
            HeaderMsg       =>  InstancePath & PartID,
            CheckEnabled    =>  true );

        -- Period Check SCK for READ
        VitalPeriodPulseCheck (
            TestSignal      =>  SCK_ipd,
            TestSignalName  =>  "SCK",
            Period          =>  tperiod_SCK_rd,
            PeriodData      =>  PD_SCK_rd,
            XOn             =>  XOn,
            MsgOn           =>  MsgOn,
            Violation       =>  Pviol_SCK_rd,
            HeaderMsg       =>  InstancePath & PartID,
            CheckEnabled    =>  rd );

        -- Period Check SCK for other than READ
        VitalPeriodPulseCheck (
            TestSignal      =>  SCK_ipd,
            TestSignalName  =>  "SCK",
            Period          =>  tperiod_SCK_fast_rd,
            PeriodData      =>  PD_SCK_fast_rd,
            XOn             =>  XOn,
            MsgOn           =>  MsgOn,
            Violation       =>  Pviol_SCK_fast_rd,
            HeaderMsg       =>  InstancePath & PartID,
            CheckEnabled    =>  fast_rd );

        Violation := Tviol_SI_SCK            OR
                     Tviol_HOLD_SCK          OR
                     Tviol_CS_SCK            OR
                     Tviol_WS_CS             OR
                     Tviol_WH_CS             OR
                     Pviol_SCK               OR
                     Pviol_SCK_rd            OR
                     Pviol_SCK_fast_rd       OR
                     Pviol_CS;

        Viol <= Violation;
        ASSERT Violation = '0'
            REPORT InstancePath & partID & ": simulation may be" &
                    " inaccurate due to timing violations"
            SEVERITY WARNING;

    END IF;
END PROCESS VITALTimingCheck;

    ----------------------------------------------------------------------------
    -- sequential process for FSM state transition
    ----------------------------------------------------------------------------
    StateTransition : PROCESS(next_state, PoweredUp)
    BEGIN
        IF PoweredUp = '1' THEN
            current_state <= next_state;
        ELSE
             current_state <= IDLE;
        END IF;
    END PROCESS StateTransition;

    ---------------------------------------------------------------------------
    --  Write cycle decode
    ---------------------------------------------------------------------------
    BusCycleDecode : PROCESS(SCK_ipd, CSNeg_ipd, HOLDNeg_ipd, SI_ipd)

        TYPE bus_cycle_type IS (STAND_BY,
                                CODE_BYTE,
                                ADDRESS_BYTES,
                                DUMMY_BYTES,
                                DATA_BYTES
                                );

        VARIABLE bus_cycle_state    : bus_cycle_type;

        VARIABLE data_cnt        : NATURAL := 0;
        VARIABLE addr_cnt        : NATURAL := 0;
        VARIABLE code_cnt        : NATURAL := 0;
        VARIABLE dummy_cnt       : NATURAL := 0;
        VARIABLE bit_cnt         : NATURAL := 0;
        VARIABLE Data_in         : std_logic_vector(2047 downto 0)
                                                    := (others => '0');
        VARIABLE code            : std_logic_vector(7 downto 0);
        VARIABLE code_in         : std_logic_vector(7 downto 0);
        VARIABLE Byte_slv        : std_logic_vector(7 downto 0);
        VARIABLE addr_bytes      : std_logic_vector(HiAddrBitUsed downto 0);
        VARIABLE Address_in      : std_logic_vector(23 downto 0);
    BEGIN
    IF PoweredUp = '1' THEN

        IF rising_edge(CSNeg_ipd) AND NOT(bus_cycle_state = DATA_BYTES)
           AND NOT(bus_cycle_state = DUMMY_BYTES) THEN
            bus_cycle_state := STAND_BY;
        ELSE
        CASE bus_cycle_state IS
            WHEN STAND_BY =>
                IF falling_edge(CSNeg_ipd) THEN
                    Instruct <= NONE;
                    write <= '1';
                    code_cnt := 0;
                    addr_cnt := 0;
                    data_cnt := 0;
                    dummy_cnt := 0;
                    bus_cycle_state := CODE_BYTE;
                END IF;

            WHEN CODE_BYTE =>
                IF rising_edge(SCK_ipd) AND HOLDNeg_ipd = '1' THEN
                    Code_in(code_cnt) := SI_ipd;
                    code_cnt := code_cnt + 1;
                    IF code_cnt = BYTE THEN
                        --MSB first
                        FOR I IN 7 DOWNTO 0 LOOP
                            code(i) := code_in(7-i);
                        END LOOP;
                        CASE code IS
                            WHEN "00000110" =>
                                Instruct <= WREN;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "00000100" =>
                                Instruct <= WRDI;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "00000101" =>
                                Instruct <= RDSR;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "00000001" =>
                                Instruct <= WRSR;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "00000011" =>
                                Instruct <= READ;
                                bus_cycle_state := ADDRESS_BYTES;
                            WHEN "00001011" =>
                                Instruct <= FAST_READ;
                                bus_cycle_state := ADDRESS_BYTES;
                            WHEN "10011111" =>
                                Instruct <= RDID;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "11011000" =>
                                Instruct <= SE;
                                bus_cycle_state := ADDRESS_BYTES;
                            WHEN "11000111" =>
                                Instruct <= BE;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "00000010" =>
                                Instruct <= PP;
                                bus_cycle_state := ADDRESS_BYTES;
                            WHEN "10111001" =>
                                Instruct <= DP;
                                bus_cycle_state := DATA_BYTES;
                            WHEN "10101011" =>
                                Instruct <= RES_READ_ES;
                                bus_cycle_state := DUMMY_BYTES;
                            WHEN others =>
                                Instruct <= NONE;
                                bus_cycle_state := STAND_BY;
                                ASSERT false
                                REPORT "Invalid command, further attempts to" &
                                " write to device are ignored"
                                SEVERITY WARNING;
                        END CASE;
                    END IF;
                END IF;

                WHEN ADDRESS_BYTES =>
                    IF rising_edge(SCK_ipd) AND HOLDNeg_ipd = '1' THEN
                        Address_in(addr_cnt) := SI_ipd;
                        addr_cnt := addr_cnt + 1;
                        IF addr_cnt = 3*BYTE THEN
                            FOR I IN HiAddrBit DOWNTO
                                  (HiAddrBit - HiAddrBitUsed) LOOP
                                addr_bytes(HiAddrBit-i) := Address_in(i);
                            END LOOP;
                            Address <= to_nat(addr_bytes);
                            sect <= to_nat(addr_bytes) / (SecSize + 1);
                            change_addr <= '1','0' AFTER 1 ns;
                            IF Instruct = FAST_READ THEN
                                bus_cycle_state := DUMMY_BYTES;
                            ELSE
                                bus_cycle_state := DATA_BYTES;
                            END IF;
                        END IF;
                    END IF;

                WHEN DUMMY_BYTES =>
                    IF rising_edge(SCK_ipd) AND HOLDNeg_ipd = '1' THEN
                        dummy_cnt := dummy_cnt + 1;
                        IF dummy_cnt = BYTE THEN
                            IF Instruct = FAST_READ THEN
                                bus_cycle_state := DATA_BYTES;
                            END IF;
                        ELSIF dummy_cnt = 3*BYTE THEN
                            IF Instruct = RES_READ_ES THEN
                                bus_cycle_state := DATA_BYTES;
                            END IF;
                        END IF;
                    END IF;

                    IF rising_edge(CSNeg_ipd) THEN
                        IF (HOLDNeg_ipd = '1' AND dummy_cnt = 0 AND
                           Instruct = RES_READ_ES) THEN
                            write <= '0';
                        END IF;
                        bus_cycle_state := STAND_BY;
                    END IF;

                WHEN DATA_BYTES =>
                    IF falling_edge(SCK_ipd) AND CSNeg_ipd = '0' THEN
                        IF Instruct = READ OR Instruct = RES_READ_ES
                           OR Instruct = FAST_READ OR Instruct = RDSR
                           OR Instruct = RDID THEN
                            read_out <= '1', '0' AFTER 1 ns;
                        END IF;
                    END IF;

                    IF rising_edge(SCK_ipd) AND HOLDNeg_ipd = '1' THEN
                        IF data_cnt > 2047 THEN
                        --In case of PP, if more than 256 bytes are
                        --sent to the device
                            IF bit_cnt = 0 THEN
                                FOR I IN 0 TO (255*BYTE - 1) LOOP
                                    Data_in(i) := Data_in(i+8);
                                END LOOP;
                            END IF;
                            Data_in(2040 + bit_cnt) := SI_ipd;
                            bit_cnt := bit_cnt + 1;
                            IF bit_cnt = 8 THEN
                                bit_cnt := 0;
                            END IF;
                            data_cnt := data_cnt + 1;
                        ELSE
                            Data_in(data_cnt) := SI_ipd;
                            data_cnt := data_cnt + 1;
                            bit_cnt := 0;
                        END IF;
                    END IF;

                    IF rising_edge(CSNeg_ipd) THEN
                        bus_cycle_state := STAND_BY;
                        IF  HOLDNeg_ipd = '1' THEN
                            CASE Instruct IS
                                WHEN WREN | WRDI | DP | BE | SE =>
                                    IF data_cnt = 0 THEN
                                        write <= '0';
                                    END IF;
                                WHEN RES_READ_ES =>
                                    write <= '0';
                                WHEN WRSR =>
                                    IF data_cnt = 8 THEN
                                        write <= '0';
                                        Status_reg_in <= Data_in(7 downto 0);
                                        --MSB first
                                    END IF;
                                WHEN PP =>
                                    IF ((data_cnt mod 8) = 0 AND
                                        data_cnt > BYTE) THEN
                                        write <= '0';
                                        FOR I IN 0 TO 255 LOOP
                                            FOR J IN 7 DOWNTO 0 LOOP
                                                Byte_slv(j) :=
                                                Data_in((i*8) + (7-j));
                                            END LOOP;
                                            WByte(i) <= to_nat(Byte_slv);
                                        END LOOP;
                                        IF data_cnt > 256*BYTE THEN
                                            Byte_number <= 255;
                                        ELSE
                                            Byte_number <= data_cnt/8-1;
                                        END IF;
                                    END IF;
                                WHEN others =>
                                    null;
                            END CASE;
                        END IF;
                    END IF;

            END CASE;
            END IF;
        END IF;

END PROCESS BusCycleDecode;
    ---------------------------------------------------------------------------
    -- Timing control for the Page Program
    ---------------------------------------------------------------------------
    ProgTime : PROCESS(PSTART)
        VARIABLE pob      : time;
    BEGIN
        IF LongTimming THEN
            pob  := tdevice_PP;
        ELSE
            pob  := tdevice_PP / 100;
        END IF;
        IF rising_edge(PSTART) AND PDONE = '1' THEN
            IF NOT Sec_Prot(SA) = '1' THEN
                PDONE <= '0', '1' AFTER pob;
            END IF;
        END IF;
    END PROCESS ProgTime;
    ---------------------------------------------------------------------------
    -- Timing control for the Write Status Register
    ---------------------------------------------------------------------------
    WriteTime : PROCESS(WSTART)
        VARIABLE wob      : time;
    BEGIN
        IF LongTimming THEN
            wob  := tdevice_WR;
        ELSE
            wob  := tdevice_WR / 100;
        END IF;
        IF rising_edge(WSTART) AND WDONE = '1' THEN
            WDONE <= '0', '1' AFTER wob;
        END IF;
    END PROCESS WriteTime;
    ---------------------------------------------------------------------------
    -- Timing control for the Bulk Erase
    ---------------------------------------------------------------------------
    ErsTime : PROCESS(ESTART)
        VARIABLE seo      : time;
        VARIABLE beo      : time;
        VARIABLE ers_time : time;
        VARIABLE duration : time;
    BEGIN
        seo := tdevice_SE;
        beo := tdevice_BE;

        IF rising_edge(ESTART) AND EDONE = '1' THEN
            IF Instruct = BE THEN
                ers_time := beo;
            ELSIF Instruct = SE THEN
                ers_time := seo;
            END IF;
            IF LongTimming THEN
                duration := ers_time;
            ELSE
                duration := ers_time/100;
            END IF;
            EDONE <= '0', '1' AFTER duration;
        END IF;
    END PROCESS ErsTime;

    CheckCEOnPowerUP :PROCESS
    BEGIN
        IF CSNeg /= '1' THEN
            REPORT InstancePath & partID &
            ": Device is selected during Power Up"
            SEVERITY WARNING;
        END IF;
        WAIT;
    END PROCESS;

    ---------------------------------------------------------------------------
    -- Main Behavior Process
    -- combinational process for next state generation
    ---------------------------------------------------------------------------
    StateGen :PROCESS(write, WDONE, PDONE, EDONE, PoweredUp)

    BEGIN
        -----------------------------------------------------------------------
        -- Functionality Section
        -----------------------------------------------------------------------
        IF PoweredUp = '0' THEN
            next_state <= current_state;
        ELSE

        CASE current_state IS
            WHEN IDLE          =>
                IF falling_edge(write) THEN
                    IF Instruct = WRSR AND WEL = '1'
                       AND not(SRWD = '1' AND WNeg = '0') THEN
                       -- can not execute if HPM is entered
                       -- or if WEL bit is zero
                        next_state <= WRITE_SR;
                    ELSIF Instruct = PP AND WEL = '1' THEN
                        IF Sec_Prot(sect) = '0' THEN
                            next_state <=  PAGE_PG;
                        END IF;
                    ELSIF Instruct = SE AND WEL = '1' THEN
                        IF Sec_Prot(sect) = '0' THEN
                            next_state <=  SECTOR_ER;
                        END IF;
                    ELSIF Instruct = BE AND WEL = '1' AND
                          (BP0 = '0' AND BP1 = '0' AND BP2 = '0') THEN
                        next_state <= BULK_ER;
                    ELSIF Instruct = DP THEN
                        next_state <= DP_DOWN;
                    ELSE
                        next_state <= IDLE;
                    END IF;
                END IF;

            WHEN WRITE_SR      =>
                IF rising_edge(WDONE) THEN
                    next_state <= IDLE;
                END IF;

            WHEN PAGE_PG       =>
                IF rising_edge(PDONE) THEN
                    next_state <= IDLE;
                END IF;

            WHEN BULK_ER | SECTOR_ER  =>
                IF rising_edge(EDONE) THEN
                    next_state <= IDLE;
                END IF;

            WHEN DP_DOWN     =>
                IF falling_edge(write) AND Instruct = RES_READ_ES THEN
                    next_state <= IDLE;
                END IF;

        END CASE;
        END IF;

END PROCESS StateGen;

    ---------------------------------------------------------------------------
    --FSM Output generation and general funcionality
    ---------------------------------------------------------------------------
    Functional : PROCESS(write,read_out, WDONE, PDONE, EDONE, current_state,
                         CSNeg_ipd, HOLDNeg_ipd, Instruct, Address, WByte,
                         RES_out, change_addr, PoweredUp, WNeg_ipd)

        TYPE WDataType IS ARRAY (0 TO 255) OF INTEGER RANGE -1 TO MaxData;

        VARIABLE WData       : WDataType:= (OTHERS => 0);

        VARIABLE oe          : boolean := FALSE;

        VARIABLE AddrLo      : NATURAL;
        VARIABLE AddrHi      : NATURAL;
        VARIABLE Addr        : NATURAL;

        VARIABLE read_cnt    : NATURAL;
        VARIABLE read_addr   : NATURAL RANGE 0 TO AddrRANGE;
        VARIABLE data_out    : std_logic_vector(7 downto 0);
        VARIABLE ident_out   : std_logic_vector(23 downto 0);

        VARIABLE old_bit     : std_logic_vector(7 downto 0);
        VARIABLE new_bit     : std_logic_vector(7 downto 0);
        VARIABLE old_int     : INTEGER RANGE -1 to MaxData;
        VARIABLE new_int     : INTEGER RANGE -1 to MaxData;
        VARIABLE wr_cnt      : NATURAL RANGE 0 TO 255;

        VARIABLE BP          : std_logic_vector(2 downto 0) := "000";

    BEGIN
        -----------------------------------------------------------------------
        -- Functionality Section
        -----------------------------------------------------------------------

        oe := rising_edge(read_out) AND PoweredUp = '1' AND HOLDNeg_ipd = '1';
        IF Instruct'EVENT THEN
            read_cnt := 0;
            fast_rd  <= true;
            rd       <= false;

        END IF;

        IF rising_edge(change_addr) THEN
            read_addr := Address;
        END IF;

        IF RES_out'EVENT AND RES_out = '1' THEN
            RES_in <= '0';
        END IF;

        IF PoweredUp = '1' THEN
        CASE current_state IS
            WHEN IDLE          =>
                IF falling_edge(write) THEN

                    IF Instruct = WREN THEN
                        WEL := '1';
                    ELSIF Instruct = WRDI THEN
                        WEL := '0';
                    ELSIF Instruct = WRSR AND WEL = '1'
                          AND not(SRWD = '1' AND WNeg_ipd = '0') THEN
                       -- can not execute if HPM is entered
                       -- or if WEL bit is zero
                        WSTART <= '1', '0' AFTER 1 ns;
                        WIP := '1';
                    ELSIF Instruct = PP AND WEL = '1' THEN
                        IF Sec_Prot(sect) = '0' THEN
                            PSTART <= '1', '0' AFTER 1 ns;
                            WIP := '1';
                            SA <= sect;
                            Addr := Address;
                            wr_cnt := Byte_number;
                            FOR I IN wr_cnt DOWNTO 0 LOOP
                                IF Viol /= '0' THEN
                                    WData(i) := -1;
                                ELSE
                                    WData(i) := WByte(i);
                                END IF;
                            END LOOP;
                        END IF;
                    ELSIF Instruct = SE AND WEL = '1' THEN
                        IF Sec_Prot(sect) = '0' THEN
                            ESTART <= '1', '0' AFTER 1 ns;
                            WIP := '1';
                            Addr := Address;
                        END IF;
                    ELSIF Instruct = BE AND WEL = '1' AND
                          (BP0 = '0' AND BP1 = '0' AND BP2 = '0') THEN
                        ESTART <= '1', '0' AFTER 1 ns;
                        WIP := '1';
                    END IF;

                    IF RES_in = '1' THEN
                        ASSERT false
                            REPORT InstancePath & partID & "Command results" &
                                  " can be corrupted, a delay of tRES" &
                                  " currently in progress."
                            SEVERITY WARNING;
                    END IF;
                ELSIF oe THEN
                    IF RES_in = '0' THEN
                        IF Instruct = RDSR THEN
                            ReadStatusReg(Status_reg, SO_zd, read_cnt);
                        ELSIF Instruct = READ OR Instruct = FAST_READ THEN
                            ReadMem(SO_zd, read_cnt, read_addr);
                            IF Instruct = READ THEN
                                fast_rd <= false;
                                rd      <= true;
                            END IF;
                        ELSIF Instruct = RDID THEN
                            ReadDeviceID(SO_zd, read_cnt);
                        END IF;
                    ELSE--RES_in = '1' THEN
                        ReadX(SO_zd, read_cnt);

                        ASSERT false
                            REPORT InstancePath & partID & "Command results" &
                                  " can be corrupted, a delay of tRES" &
                                  " currently in progress."
                            SEVERITY WARNING;
                    END IF;
                END IF;

            WHEN WRITE_SR      =>

                IF oe AND Instruct = RDSR THEN
                    ReadStatusReg(Status_reg, SO_zd, read_cnt);
                END IF;

                IF WDONE = '1' THEN
                    WIP  := '0';
                    WEL  := '0';
                    SRWD := Status_reg_in(0);--MSB first
                    BP2  := Status_reg_in(3);
                    BP1  := Status_reg_in(4);
                    BP0  := Status_reg_in(5);
                    BP   := BP2 & BP1 & BP0;
                    ProtectSectors(BP, Sec_Prot);
                END IF;

            WHEN PAGE_PG       =>

                IF oe AND Instruct = RDSR THEN
                    ReadStatusReg(Status_reg, SO_zd, read_cnt);
                END IF;

                Sepa(AddrLo, AddrHi, Addr);
                IF (Addr + wr_cnt) > AddrHi THEN
                    wr_cnt := AddrHi - Addr;
                END IF;

                FOR I IN Addr TO Addr + wr_cnt LOOP
                    new_int := WData(i-Addr);
                    old_int := Mem(i);
                    IF new_int > -1 THEN
                        new_bit := to_slv(new_int,8);
                        IF old_int > -1 THEN
                            old_bit := to_slv(old_int,8);
                            FOR j IN 0 TO 7 LOOP
                                IF old_bit(j) = '0' THEN
                                    new_bit(j) := '0';
                                END IF;
                            END LOOP;
                            new_int := to_nat(new_bit);
                        END IF;
                        WData(i-Addr) := new_int;
                    ELSE
                        WData(i-Addr) := -1;
                    END IF;
                END LOOP;

                FOR I IN Addr TO Addr + wr_cnt LOOP
                     Mem (i) :=  -1;
                END LOOP;

                IF PDONE = '1' THEN
                    WIP := '0';
                    WEL := '0';
                    FOR i IN Addr TO Addr + wr_cnt LOOP
                        Mem(i) := WData(i-Addr);
                    END LOOP;
                END IF;

            WHEN SECTOR_ER     =>

                IF oe AND Instruct = RDSR THEN
                    ReadStatusReg(Status_reg, SO_zd, read_cnt);
                END IF;

                Sesa(AddrLo, AddrHi, Addr);
                FOR i IN AddrLo TO AddrHi LOOP
                    Mem(i) := -1;
                END LOOP;
                IF EDONE = '1' THEN
                    WIP := '0';
                    WEL := '0';
                    FOR i IN AddrLo TO AddrHi LOOP
                        Mem(i) :=  MaxData;
                    END LOOP;
                END IF;

            WHEN BULK_ER       =>

                IF oe AND Instruct = RDSR THEN
                    ReadStatusReg(Status_reg, SO_zd, read_cnt);
                END IF;

                FOR i IN 0 TO AddrRANGE LOOP
                    Mem(i) := -1;
                END LOOP;
                IF EDONE = '1' THEN
                    WIP := '0';
                    WEL := '0';
                    FOR i IN 0 TO AddrRANGE LOOP
                        Mem(i) :=  MaxData;
                    END LOOP;
                END IF;

            WHEN DP_DOWN     =>
                IF falling_edge(write) THEN
                    IF Instruct = RES_READ_ES THEN
                        RES_in <= '1';
                    END IF;
                ELSIF oe AND Instruct = RES_READ_ES THEN
                    REadEs(SO_zd, read_cnt);
                END IF;

        END CASE;
        END IF;

        --Output Disable Control
        IF (CSNeg_ipd = '1' ) THEN
            SO_zd <= 'Z';
        END IF;

END PROCESS Functional;
    HOLD_FRAME_ON_SO_ZD : PROCESS( SO_zd, HOLDNeg_ipd)
    BEGIN
        IF (HOLDNeg_ipd = '0') THEN
            SO_z <= 'Z';
        ELSE
            SO_z <= SO_zd;
        END IF;
    END PROCESS HOLD_FRAME_ON_SO_ZD;

    ---------------------------------------------------------------------------
    ---- File Read Section - Preload Control
    ---------------------------------------------------------------------------
    MemPreload : PROCESS

        -- text file input variables
        FILE mem_file        : text  is  mem_file_name;
        VARIABLE ind         : NATURAL RANGE 0 TO AddrRANGE+1 := 0;
        VARIABLE buf         : line;
        VARIABLE reported    : NATURAL RANGE 0 TO 1 := 0;
    BEGIN
    ---------------------------------------------------------------------------
    --s25fl008a memory preload file format  -----------------------------------
    ---------------------------------------------------------------------------
    --   /       - comment
    --   @aaaaa  - <aaaaa> stands for address
    --   dd      - <dd> is byte to be written at Mem(aaaaa++)
    --             (aaaaa is incremented at every load)
    --   only first 1-6 columns are loaded. NO empty lines !!!!!!!!!!!!!!!!
    ---------------------------------------------------------------------------

         -- memory preload
        IF (mem_file_name /= "none" AND UserPreload) THEN
            ind := 0;
            Mem := (OTHERS => MaxData);
            WHILE (not ENDFILE (mem_file)) LOOP
                READLINE (mem_file, buf);
                IF buf(1) = '/' THEN
                    NEXT;
                ELSIF buf(1) = '@' THEN
                    ind := h(buf(2 to 6)); --address
                ELSE
                    IF ind <= AddrRange THEN
                        Mem(ind) := h(buf(1 to 2));
                        ind := ind + 1;
                    ELSIF reported = 0 THEN
                        REPORT " Memory address out of range"
                        SEVERITY warning;
                        reported := 1;
                    END IF;
                END IF;
            END LOOP;
        END IF;

        WAIT;
    END PROCESS MemPreload;

    SO_OUT: PROCESS(SO_z)

        VARIABLE SO_GlitchData : VitalGlitchDataType;
    BEGIN
        VitalPathDelay01Z (
            OutSignal       => SO,
            OutSignalName   => "SO",
            OutTemp         => SO_z,
            GlitchData      => SO_GlitchData,
            XOn             => XOn,
            MsgOn           => MsgOn,
            Paths           => (
                0 => (InputChangeTime => SCK_ipd'LAST_EVENT,
                      PathDelay       => tpd_SCK_SO,
                      PathCondition   => SO_z /= 'Z'),
                1 => (InputChangeTime => CSNeg_ipd'LAST_EVENT,
                      PathDelay       => tpd_CSNeg_SO,
                      PathCondition   => CSNeg_ipd = '1'),
                2 => (InputChangeTime => HOLDNeg_ipd'LAST_EVENT,
                      PathDelay       => tpd_HOLDNeg_SO,
                      PathCondition   => TRUE)
            )
        );
    END PROCESS SO_OUT;

    END BLOCK behavior;
END vhdl_behavioral;

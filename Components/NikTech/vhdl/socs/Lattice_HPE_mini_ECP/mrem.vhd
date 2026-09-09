
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- synopsys translate_off
library ecp;
use ecp.components.all;
-- synopsys translate_on

entity ecp_mem is
    port (Clock   : in  std_logic;
          ClockEn : in  std_logic;
          Reset   : in  std_logic;
          WE      : in  std_logic;
          Address : in  std_logic_vector(8 downto 0);
          Data    : in  std_logic_vector(31 downto 0);
          Q       : out std_logic_vector(31 downto 0));
end ecp_mem;

architecture Structure of ecp_mem is

    -- internal signal declarations
    signal scuba_vhi : std_logic;
    signal scuba_vlo : std_logic;

    -- local component declarations
    component SP8KA
        -- synopsys translate_off
        generic (INITVAL_1F : in String; INITVAL_1E : in String;
        INITVAL_1D  : in String; INITVAL_1C : in String;
        INITVAL_1B  : in String; INITVAL_1A : in String;
        INITVAL_19  : in String; INITVAL_18 : in String;
        INITVAL_17  : in String; INITVAL_16 : in String;
        INITVAL_15  : in String; INITVAL_14 : in String;
        INITVAL_13  : in String; INITVAL_12 : in String;
        INITVAL_11  : in String; INITVAL_10 : in String;
        INITVAL_0F  : in String; INITVAL_0E : in String;
        INITVAL_0D  : in String; INITVAL_0C : in String;
        INITVAL_0B  : in String; INITVAL_0A : in String;
        INITVAL_09  : in String; INITVAL_08 : in String;
        INITVAL_07  : in String; INITVAL_06 : in String;
        INITVAL_05  : in String; INITVAL_04 : in String;
        INITVAL_03  : in String; INITVAL_02 : in String;
        INITVAL_01  : in String; INITVAL_00 : in String;
        DATA_WIDTH  : in Integer; CSDECODE : in String;
        RESETMODE   : in String; WRITEMODE : in String;
        GSR         : in String; REGMODE : in String);
        -- synopsys translate_on
        port (CE : in  std_logic; CLK : in std_logic; WE : in std_logic;
        CS0  : in  std_logic; CS1 : in std_logic; CS2 : in std_logic;
        RST  : in  std_logic; DI0 : in std_logic; DI1 : in std_logic;
        DI2  : in  std_logic; DI3 : in std_logic; DI4 : in std_logic;
        DI5  : in  std_logic; DI6 : in std_logic; DI7 : in std_logic;
        DI8  : in  std_logic; DI9 : in std_logic; DI10 : in std_logic;
        DI11 : in  std_logic; DI12 : in std_logic;
        DI13 : in  std_logic; DI14 : in std_logic;
        DI15 : in  std_logic; DI16 : in std_logic;
        DI17 : in  std_logic; AD0 : in std_logic; AD1 : in std_logic;
        AD2  : in  std_logic; AD3 : in std_logic; AD4 : in std_logic;
        AD5  : in  std_logic; AD6 : in std_logic; AD7 : in std_logic;
        AD8  : in  std_logic; AD9 : in std_logic; AD10 : in std_logic;
        AD11 : in  std_logic; AD12 : in std_logic;
        DO0  : out std_logic; DO1 : out std_logic;
        DO2  : out std_logic; DO3 : out std_logic;
        DO4  : out std_logic; DO5 : out std_logic;
        DO6  : out std_logic; DO7 : out std_logic;
        DO8  : out std_logic; DO9 : out std_logic;
        DO10 : out std_logic; DO11 : out std_logic;
        DO12 : out std_logic; DO13 : out std_logic;
        DO14 : out std_logic; DO15 : out std_logic;
        DO16 : out std_logic; DO17 : out std_logic);
    end component;
    component VHI
        port (Z : out std_logic);
    end component;
    component VLO
        port (Z : out std_logic);
    end component;
    attribute MEM_LPC_FILE                   : string;
    attribute MEM_INIT_FILE                  : string;
    attribute INITVAL_1F                     : string;
    attribute INITVAL_1E                     : string;
    attribute INITVAL_1D                     : string;
    attribute INITVAL_1C                     : string;
    attribute INITVAL_1B                     : string;
    attribute INITVAL_1A                     : string;
    attribute INITVAL_19                     : string;
    attribute INITVAL_18                     : string;
    attribute INITVAL_17                     : string;
    attribute INITVAL_16                     : string;
    attribute INITVAL_15                     : string;
    attribute INITVAL_14                     : string;
    attribute INITVAL_13                     : string;
    attribute INITVAL_12                     : string;
    attribute INITVAL_11                     : string;
    attribute INITVAL_10                     : string;
    attribute INITVAL_0F                     : string;
    attribute INITVAL_0E                     : string;
    attribute INITVAL_0D                     : string;
    attribute INITVAL_0C                     : string;
    attribute INITVAL_0B                     : string;
    attribute INITVAL_0A                     : string;
    attribute INITVAL_09                     : string;
    attribute INITVAL_08                     : string;
    attribute INITVAL_07                     : string;
    attribute INITVAL_06                     : string;
    attribute INITVAL_05                     : string;
    attribute INITVAL_04                     : string;
    attribute INITVAL_03                     : string;
    attribute INITVAL_02                     : string;
    attribute INITVAL_01                     : string;
    attribute INITVAL_00                     : string;
    attribute CSDECODE                       : string;
    attribute GSR                            : string;
    attribute WRITEMODE                      : string;
    attribute RESETMODE                      : string;
    attribute REGMODE                        : string;
    attribute DATA_WIDTH                     : string;
    attribute MEM_LPC_FILE of ecp_mem_0_0_1  : label is "ecp_mem.lpc";
    attribute MEM_INIT_FILE of ecp_mem_0_0_1 : label is "manikremote.mem";
    attribute INITVAL_1F of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1E of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1D of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1C of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1B of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1A of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_19 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_18 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_17 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_16 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_15 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_14 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_13 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_12 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_11 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_10 of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_0F of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_0E of ecp_mem_0_0_1    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_0D of ecp_mem_0_0_1    : label is "0x00000000010000000000000000000000000000000000000000100002C0110240000000100002D017";
    attribute INITVAL_0C of ecp_mem_0_0_1    : label is "0x0000131E01040710EC02003600000001C0518050136460F40401D07130703FF51160042805023040";
    attribute INITVAL_0B of ecp_mem_0_0_1    : label is "0x330702257302157121550246102454041300125100020003600035C0002F1610C07010084B0082D0";
    attribute INITVAL_0A of ecp_mem_0_0_1    : label is "0x080F02907B340690EFAD000491761B2F4020FBFF021210F4080FBFF021211E407321113777200067";
    attribute INITVAL_09 of ecp_mem_0_0_1    : label is "0x3F4123241D13C2F131E73767D00CF81F80030CF800079026F135F1F0007F224F11F80030CD805FDF";
    attribute INITVAL_08 of ecp_mem_0_0_1    : label is "0x1F8000008B2F43A231E73EC051767D27572131E73E40607674331E715FEF000A10009B075183915C";
    attribute INITVAL_07 of ecp_mem_0_0_1    : label is "0x3826C02176321772837C030733437A030721E4123507F3297F0307035071000B137011164B409650";
    attribute INITVAL_06 of ecp_mem_0_0_1    : label is "0x091E0195A001251094B002400024003F7FF0080001C0508250080F02130704065260E12130704067";
    attribute INITVAL_05 of ecp_mem_0_0_1    : label is "0x25F1F3F800330FF000E72741D19250191E0090F03FBFF0040001C0508250180F02130704065060E1";
    attribute INITVAL_04 of ecp_mem_0_0_1    : label is "0x2F80021307040683EC0E16FFF024E2091E001251024000035C01C050805031D07330700407401251";
    attribute INITVAL_03 of ecp_mem_0_0_1    : label is "0x02400003F8200000620C0132F0130F0131F0132F0136F0137F0138F0139F013AF0630C08DD008BB0";
    attribute INITVAL_02 of ecp_mem_0_0_1    : label is "0x08990087700855008330181100008312410327110FBFF012F1012F036D0400129324100FBFF012F1";
    attribute INITVAL_01 of ecp_mem_0_0_1    : label is "0x012F036D0400045324100FBFF012F1012F016D0409EE009CC009AA00988009660094400922009000";
    attribute INITVAL_00 of ecp_mem_0_0_1    : label is "0x080F0012FA012F9012F8012F7012F6012F3012F2312F21100F1701000005000360002C0004600009";
    attribute CSDECODE of ecp_mem_0_0_1      : label is "000";
    attribute GSR of ecp_mem_0_0_1           : label is "DISABLED";
    attribute WRITEMODE of ecp_mem_0_0_1     : label is "NORMAL";
    attribute RESETMODE of ecp_mem_0_0_1     : label is "ASYNC";
    attribute REGMODE of ecp_mem_0_0_1       : label is "NOREG";
    attribute DATA_WIDTH of ecp_mem_0_0_1    : label is "18";
    attribute MEM_LPC_FILE of ecp_mem_0_1_0  : label is "ecp_mem.lpc";
    attribute MEM_INIT_FILE of ecp_mem_0_1_0 : label is "manikremote.mem";
    attribute INITVAL_1F of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1E of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1D of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1C of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1B of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_1A of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_19 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_18 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_17 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_16 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_15 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_14 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_13 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_12 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_11 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_10 of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_0F of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_0E of ecp_mem_0_1_0    : label is "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    attribute INITVAL_0D of ecp_mem_0_1_0    : label is "0x0000000000000000000000000000000000000000000000200000780010040090002000007800101C";
    attribute INITVAL_0C of ecp_mem_0_1_0    : label is "0x020000340501C4400C0400000001000180103BF9018100000003B010201D03CFF004C50390103B03";
    attribute INITVAL_0B of ecp_mem_0_1_0    : label is "0x0084C0201D01919008550105C01C100241401BC300004000000000003C00004C502168020F002078";
    attribute INITVAL_0A of ecp_mem_0_1_0    : label is "0x021940099D0201E00C2803E0001C2803FD701C050090B03FD101C050090B0084400C79017C703E00";
    attribute INITVAL_09 of ecp_mem_0_1_0    : label is "0x0090B03B0300F07009BC017C70001D009BC017C703E000033E017FF03E0000020009B4017C700022";
    attribute INITVAL_08 of ecp_mem_0_1_0    : label is "0x0093403E0003B0901DDC00C7903D0103B0201D1F00D3903B1201D9C0093803E0003E0003D1602419";
    attribute INITVAL_07 of ecp_mem_0_1_0    : label is "0x02015010DA0085D0391803D02039000205F00C1C00ADD03B0501C280091F03E000203E00930024B4";
    attribute INITVAL_06 of ecp_mem_0_1_0    : label is "0x0243C0092C024F001B81009000090003FFF00000018030207803DFC0095D0049C034070099D0049C";
    attribute INITVAL_05 of ecp_mem_0_1_0    : label is "0x0003A03B0301BFF03E00009380093C0049401BC103FFF00000018030207803DFC0095D0049C00040";
    attribute INITVAL_04 of ecp_mem_0_1_0    : label is "0x030070099D0049C00C3F0093C024940243C01BC10090000000018010000003B000201D0241401BC3";
    attribute INITVAL_03 of ecp_mem_0_1_0    : label is "0x0090000000007800203C0207C020BC020FC0213C021BC021FC0223C0227C022BC023B802330022A8";
    attribute INITVAL_02 of ecp_mem_0_1_0    : label is "0x0222002198021100208803D0003E00004D803FEF024FC024BC0243C03D0303E0003FF2024FC024BC";
    attribute INITVAL_01 of ecp_mem_0_1_0    : label is "0x0243C03D0603E0003FF5024FC024BC0243C0078002774026EC02664025DC02554024CC0244401B01";
    attribute INITVAL_00 of ecp_mem_0_1_0    : label is "0x026BC0267C0263C025FC025BC0257C0253C0247C03D0E004C0010C203C0003C0003C0003C0003C00";
    attribute CSDECODE of ecp_mem_0_1_0      : label is "000";
    attribute GSR of ecp_mem_0_1_0           : label is "DISABLED";
    attribute WRITEMODE of ecp_mem_0_1_0     : label is "NORMAL";
    attribute RESETMODE of ecp_mem_0_1_0     : label is "ASYNC";
    attribute REGMODE of ecp_mem_0_1_0       : label is "NOREG";
    attribute DATA_WIDTH of ecp_mem_0_1_0    : label is "18";

begin
    -- component instantiation statements
    ecp_mem_0_0_1 : SP8KA
        -- synopsys translate_off
        generic map (INITVAL_1F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1E              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1D              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1C              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1B              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1A              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_19              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_18              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_17              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_16              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_15              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_14              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_13              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_12              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_11              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_10              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_0F              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_0E              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_0D              => "0x00000000010000000000000000000000000000000000000000100002C0110240000000100002D017",
                     INITVAL_0C              => "0x0000131E01040710EC02003600000001C0518050136460F40401D07130703FF51160042805023040",
                     INITVAL_0B              => "0x330702257302157121550246102454041300125100020003600035C0002F1610C07010084B0082D0",
                     INITVAL_0A              => "0x080F02907B340690EFAD000491761B2F4020FBFF021210F4080FBFF021211E407321113777200067",
                     INITVAL_09              => "0x3F4123241D13C2F131E73767D00CF81F80030CF800079026F135F1F0007F224F11F80030CD805FDF",
                     INITVAL_08              => "0x1F8000008B2F43A231E73EC051767D27572131E73E40607674331E715FEF000A10009B075183915C",
                     INITVAL_07              => "0x3826C02176321772837C030733437A030721E4123507F3297F0307035071000B137011164B409650",
                     INITVAL_06              => "0x091E0195A001251094B002400024003F7FF0080001C0508250080F02130704065260E12130704067",
                     INITVAL_05              => "0x25F1F3F800330FF000E72741D19250191E0090F03FBFF0040001C0508250180F02130704065060E1",
                     INITVAL_04              => "0x2F80021307040683EC0E16FFF024E2091E001251024000035C01C050805031D07330700407401251",
                     INITVAL_03              => "0x02400003F8200000620C0132F0130F0131F0132F0136F0137F0138F0139F013AF0630C08DD008BB0",
                     INITVAL_02              => "0x08990087700855008330181100008312410327110FBFF012F1012F036D0400129324100FBFF012F1",
                     INITVAL_01              => "0x012F036D0400045324100FBFF012F1012F016D0409EE009CC009AA00988009660094400922009000",
                     INITVAL_00              => "0x080F0012FA012F9012F8012F7012F6012F3012F2312F21100F1701000005000360002C0004600009",
                     CSDECODE                => "000", GSR => "DISABLED", WRITEMODE => "NORMAL",
                     RESETMODE               => "ASYNC", REGMODE => "NOREG", DATA_WIDTH => 18)
        -- synopsys translate_on
        port map (CE => ClockEn, CLK => Clock, WE => WE, CS0 => scuba_vlo,
                  CS1      => scuba_vlo, CS2 => scuba_vlo, RST => Reset, DI0 => Data(0),
                  DI1      => Data(1), DI2 => Data(2), DI3 => Data(3), DI4 => Data(4),
                  DI5      => Data(5), DI6 => Data(6), DI7 => Data(7), DI8 => Data(8),
                  DI9      => Data(9), DI10 => Data(10), DI11 => Data(11), DI12 => Data(12),
                  DI13     => Data(13), DI14 => Data(14), DI15 => Data(15),
                  DI16     => Data(16), DI17 => Data(17), AD0 => scuba_vhi,
                  AD1      => scuba_vhi, AD2 => scuba_vlo, AD3 => scuba_vlo,
                  AD4      => Address(0), AD5 => Address(1), AD6 => Address(2),
                  AD7      => Address(3), AD8 => Address(4), AD9 => Address(5),
                  AD10     => Address(6), AD11 => Address(7), AD12 => Address(8),
                  DO0      => Q(0), DO1 => Q(1), DO2 => Q(2), DO3 => Q(3), DO4 => Q(4),
                  DO5      => Q(5), DO6 => Q(6), DO7 => Q(7), DO8 => Q(8), DO9 => Q(9),
                  DO10     => Q(10), DO11 => Q(11), DO12 => Q(12), DO13 => Q(13),
                  DO14     => Q(14), DO15 => Q(15), DO16 => Q(16), DO17 => Q(17));

    scuba_vhi_inst : VHI
        port map (Z => scuba_vhi);

    scuba_vlo_inst : VLO
        port map (Z => scuba_vlo);

    ecp_mem_0_1_0 : SP8KA
        -- synopsys translate_off
        generic map (INITVAL_1F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1E              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1D              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1C              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1B              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_1A              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_19              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_18              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_17              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_16              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_15              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_14              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_13              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_12              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_11              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_10              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_0F              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_0E              => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
                     INITVAL_0D              => "0x0000000000000000000000000000000000000000000000200000780010040090002000007800101C",
                     INITVAL_0C              => "0x020000340501C4400C0400000001000180103BF9018100000003B010201D03CFF004C50390103B03",
                     INITVAL_0B              => "0x0084C0201D01919008550105C01C100241401BC300004000000000003C00004C502168020F002078",
                     INITVAL_0A              => "0x021940099D0201E00C2803E0001C2803FD701C050090B03FD101C050090B0084400C79017C703E00",
                     INITVAL_09              => "0x0090B03B0300F07009BC017C70001D009BC017C703E000033E017FF03E0000020009B4017C700022",
                     INITVAL_08              => "0x0093403E0003B0901DDC00C7903D0103B0201D1F00D3903B1201D9C0093803E0003E0003D1602419",
                     INITVAL_07              => "0x02015010DA0085D0391803D02039000205F00C1C00ADD03B0501C280091F03E000203E00930024B4",
                     INITVAL_06              => "0x0243C0092C024F001B81009000090003FFF00000018030207803DFC0095D0049C034070099D0049C",
                     INITVAL_05              => "0x0003A03B0301BFF03E00009380093C0049401BC103FFF00000018030207803DFC0095D0049C00040",
                     INITVAL_04              => "0x030070099D0049C00C3F0093C024940243C01BC10090000000018010000003B000201D0241401BC3",
                     INITVAL_03              => "0x0090000000007800203C0207C020BC020FC0213C021BC021FC0223C0227C022BC023B802330022A8",
                     INITVAL_02              => "0x0222002198021100208803D0003E00004D803FEF024FC024BC0243C03D0303E0003FF2024FC024BC",
                     INITVAL_01              => "0x0243C03D0603E0003FF5024FC024BC0243C0078002774026EC02664025DC02554024CC0244401B01",
                     INITVAL_00              => "0x026BC0267C0263C025FC025BC0257C0253C0247C03D0E004C0010C203C0003C0003C0003C0003C00",
                     CSDECODE                => "000", GSR => "DISABLED", WRITEMODE => "NORMAL",
                     RESETMODE               => "ASYNC", REGMODE => "NOREG", DATA_WIDTH => 18)
        -- synopsys translate_on
        port map (CE => ClockEn, CLK => Clock, WE => WE, CS0 => scuba_vlo,
                  CS1      => scuba_vlo, CS2 => scuba_vlo, RST => Reset, DI0 => Data(18),
                  DI1      => Data(19), DI2 => Data(20), DI3 => Data(21), DI4 => Data(22),
                  DI5      => Data(23), DI6 => Data(24), DI7 => Data(25), DI8 => Data(26),
                  DI9      => Data(27), DI10 => Data(28), DI11 => Data(29),
                  DI12     => Data(30), DI13 => Data(31), DI14 => scuba_vlo,
                  DI15     => scuba_vlo, DI16 => scuba_vlo, DI17 => scuba_vlo,
                  AD0      => scuba_vhi, AD1 => scuba_vhi, AD2 => scuba_vlo,
                  AD3      => scuba_vlo, AD4 => Address(0), AD5 => Address(1),
                  AD6      => Address(2), AD7 => Address(3), AD8 => Address(4),
                  AD9      => Address(5), AD10 => Address(6), AD11 => Address(7),
                  AD12     => Address(8), DO0 => Q(18), DO1 => Q(19), DO2 => Q(20),
                  DO3      => Q(21), DO4 => Q(22), DO5 => Q(23), DO6 => Q(24), DO7 => Q(25),
                  DO8      => Q(26), DO9 => Q(27), DO10 => Q(28), DO11 => Q(29),
                  DO12     => Q(30), DO13 => Q(31), DO14 => open, DO15 => open, DO16 => open,
                  DO17     => open);

end Structure;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- synopsys translate_on
entity manikremote is
    generic (WIDTH      : integer := 32;
             ADDR_WIDTH : integer := 32);
    port (clk   : std_logic;
          reset : std_logic;

          -- Wishbone slave interface
          WBS_ADR_I : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
          WBS_SEL_I : in  std_logic_vector (3 downto 0);
          WBS_DAT_I : in  std_logic_vector (WIDTH-1 downto 0);
          WBS_WE_I  : in  std_logic;
          WBS_STB_I : in  std_logic;
          WBS_CYC_I : in  std_logic;
          WBS_CTI_I : in  std_logic_vector (2 downto 0);
          WBS_BTE_I : in  std_logic_vector (1 downto 0);
          WBS_DAT_O : out std_logic_vector (WIDTH-1 downto 0);
          WBS_ACK_O : out std_logic;
          WBS_ERR_O : out std_logic);
end manikremote;

architecture RTL of manikremote is
    signal ben : std_logic_vector (3 downto 0) := "0000";
    signal wen : std_logic_vector (3 downto 0) := "0000";
    signal ack,we  : std_logic := '0';

    component ecp_mem
        port (Clock   : in  std_logic;
              ClockEn : in  std_logic;
              Reset   : in  std_logic;
              WE      : in  std_logic;
              Address : in  std_logic_vector(8 downto 0);
              Data    : in  std_logic_vector(31 downto 0);
              Q       : out std_logic_vector(31 downto 0));
    end component;
    signal data_w , data_r : std_logic_vector (31 downto 0);
    
begin
    ben(0) <= WBS_STB_I and WBS_SEL_I(3);
    ben(1) <= WBS_STB_I and WBS_SEL_I(2);
    ben(2) <= WBS_STB_I and WBS_SEL_I(1);
    ben(3) <= WBS_STB_I and WBS_SEL_I(0);
    wen(0) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(3);
    wen(1) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(2);
    wen(2) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(1);
    wen(3) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(0);

    process (clk, reset)
    begin
        if reset = '1' then
            ack <= '0';
            we  <= '0';
        elsif rising_edge(clk) then
            if ack = '1' then
                ack <= '0' after 1 ns;
            else
                ack <= WBS_STB_I after 1 ns;
            end if;
            if WBS_STB_I = '1' and WBS_WE_I = '1'  and ack = '0' then
                we <= '1';
            else
                we <= '0';
            end if;      
        end if;
    end process;
    
    WBS_ACK_O <= ack;
    WBS_ERR_O <= '0';

    data_w(WIDTH-1 downto 3*WIDTH/4) <= WBS_DAT_I(WIDTH-1 downto 3*WIDTH/4) when WBS_SEL_I(3) = '1' else
                                        data_r(WIDTH-1 downto 3*WIDTH/4); 
    data_w((3*WIDTH/4)-1 downto 2*WIDTH/4) <= WBS_DAT_I((3*WIDTH/4)-1 downto 2*WIDTH/4) when WBS_SEL_I(2) = '1' else
                                              data_r((3*WIDTH/4)-1 downto 2*WIDTH/4); 
    data_w((2*WIDTH/4)-1 downto 1*WIDTH/4) <= WBS_DAT_I((2*WIDTH/4)-1 downto 1*WIDTH/4) when WBS_SEL_I(1) = '1' else
                                              data_r((2*WIDTH/4)-1 downto 1*WIDTH/4); 
    data_w((1*WIDTH/4)-1 downto 0*WIDTH/4) <= WBS_DAT_I((1*WIDTH/4)-1 downto 0*WIDTH/4) when WBS_SEL_I(0) = '1' else
                                              data_r((1*WIDTH/4)-1 downto 0*WIDTH/4); 
    WBS_DAT_O <= data_r;

    ecp_mem_1: ecp_mem
        port map (Clock   => clk,
                  ClockEn => '1',
                  Reset   => '0',
                  WE      => we,
                  Address => WBS_ADR_I(10 downto 2),
                  Data    => data_w,
                  Q       => data_r);
end RTL;

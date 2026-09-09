-- *************************************************************************** --
--   ISA Base Board for SH-3 (CQ RISC評価キット/SH-3 + FLEX10K30A)
--        ATA(IDE)/ATAPI	[ビッグエンディアン]
--        2000/9/1  Ver1.1
-- *************************************************************************** --

library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ATA is

	port(
		HCLK : in std_logic;	-- ホストクロック(CqREEK/SH-3 60MHz)
		HRSTn : in std_logic;	-- ホストパワーONリセット
		HA : in std_logic_vector(25 downto 0);		-- ホストアドレスバス
		HD : inout std_logic_vector(15 downto 0);	-- ホストデータバス
		HCE1An, HCE1Bn : in std_logic;	-- ホストチップセレクト(CS5/CS6)
		HCE2An, HCE2Bn : in std_logic;	-- ホストチップセレクト(MD3/MD4)
		HRDn, HWEn, HIORDn, HIOWRn : in std_logic;	-- ホストリード/ライト(RD/WE1/WE2/WE3)
		HBSn, HRW : in std_logic;	-- ホスト制御信号
		HWAITn : out std_logic;		-- ホストウェイト
		HIOIS16n : out std_logic;	-- 16ビットデバイス
		HIRL : out std_logic_vector(3 downto 0);	-- ホスト割り込み制御

		-- 共通信号
		RESETn : out std_logic;	-- リセット
		LA : out std_logic_vector(25 downto 0);		-- ローカルアドレスバス(SA0～SA19/LA20～LA23/LA17/LA18)
		LD : inout std_logic_vector(15 downto 0);	-- ローカルデータバス(SD0～SD15)
		RDn, WEn, IORDn, IOWRn : out std_logic;		-- メモリリード/ライト　I/Oリード/ライト(MEMR/MEMW/IOR/IOW)

		-- ATA/ATAPI
		DDA : out std_logic_vector(2 downto 0);		-- ATAアドレスバス
		DDD : inout std_logic_vector(15 downto 0);	-- ATAデータバス
		DCS0n, DCS1n : out std_logic;	-- ATAチップセレクト
		DDMARQ, DINTRQ, DIORDY : in std_logic;	-- ATA DMAリクエスト/割り込み/レディ
		DDIOWn, DDIORn, DDMACKn : out std_logic;	-- ATAリード/ライト/DMAアクノリッジ

		SLTx_DIR : out std_logic;	-- PCカードバスバッファ ディレクション
		-- PCカードスロット0
		SLT0_ENn, SLT0_DEn : out std_logic;	-- イネーブル/データバスイネーブル
		C0RST, C0REGn, C0VCCEn : out std_logic;	-- リセット/REG信号/電源イネーブル
		C0CE1n, C0CE2n : out std_logic;	-- チップセレクト
		C0CD1n, C0CD2n : in std_logic;	-- カードデテクト
		C0WAITn, C0WP_IOIS16n, C0RDY_IRQn : in std_logic;	-- ウェイト/IOIS16信号/IRQ信号
		C0INPACKn, C0STSCHGn, C0SPKRn : in std_logic;	-- INPACK信号/STSCHG信号/SPKR信号

		-- PCカードスロット1
		SLT1_ENn, SLT1_DEn : out std_logic;	-- イネーブル/データバスイネーブル
		C1RST, C1REGn, C1VCCEn : out std_logic;	-- リセット/REG信号/電源イネーブル(RESETDRV/AEN/OSC)
		C1CE1n, C1CE2n : out std_logic;	-- チップセレクト(BALE/SBHE)
		C1CD1n, C1CD2n : in std_logic;	-- カードデテクト(IRQ3/IRQ4)
		C1WAITn, C1WP_IOIS16n, C1RDY_IRQn : in std_logic;	-- ウェイト/IOIS16信号/IRQ信号(IOCHRDY/IOCS16/MEMCS16)
		C1INPACKn, C1STSCHGn, C1SPKRn : in std_logic;	-- INPACK信号/STSCHG信号/SPKR信号(IRQ5/IRQ6/IRQ7)

		-- ISAバス専用信号
		ICLKOUT, ISALA19 : out std_logic;	-- ISAバスクロック/LA19(CLK/LA19)
		ISAMRn, ISAMWn : out std_logic;		-- ISAバスメモリリード/ライト(SMEMR/SMEMW)
		IIRQ15, IIRQ14, IIRQ12, IIRQ11, IIRQ10, IIRQ9 : in std_logic;	-- ISAバス割り込み(IRQ15～9)

		-- USB専用信号
		USBCSn : out std_logic;	-- USBチップセレクト
		USBINTn : in std_logic	-- USB割り込み

	);

end entity ATA;

architecture RTL of ATA is

-- ************************************************************************* --
-- ********** レジスタ 定義部分
-- ************************************************************************* --

	signal HD_Port    : std_logic_vector(15 downto 0);	-- ホストデータバス 出力レジスタ
	signal HRDY       : std_logic;	-- ウェイト制御
	signal HBEl       : std_logic;	-- 下位データバスイネーブル
	signal HBEh       : std_logic;	-- 上位データバスイネーブル
	signal SYSCLK     : std_logic;	-- コントローラ内部クロック(33MHz)
--	signal ISA0CLK    : std_logic;	-- ISA0バスクロック(15.6MHz)
--	signal ISA1CLK    : std_logic;	-- ISA1バスクロック(7.8MHz)

	signal Hit_Device : std_logic;	-- ブリッジコントローラ選択
	signal Hit_CTRL   : std_logic;	-- ブリッジ制御レジスタ空間選択
--	signal Hit_USB    : std_logic;	-- USBアダプタ空間選択
--	signal Hit_ISAM   : std_logic;	-- ISAバス メモリ空間選択
--	signal Hit_ISAI   : std_logic;	-- ISAバス I/O空間選択
--	signal Hit_PC0    : std_logic;	-- PCカード0 空間選択
--	signal Hit_PC1    : std_logic;	-- PCカード1 空間選択
--	signal Hit_PCxM   : std_logic;	-- PCカード メモリ空間選択
--	signal Hit_PCxI   : std_logic;	-- PCカード I/O空間選択
--	signal Hit_PC0I   : std_logic;	-- PCカード0 I/O空間選択
--	signal Hit_PC1I   : std_logic;	-- PCカード1 I/O空間選択
--	signal Hit_PC0M   : std_logic;	-- PCカード0 メモリ空間選択
--	signal Hit_PC1M   : std_logic;	-- PCカード1 メモリ空間選択

--	-- ローカルデータバス 出力レジスタ&制御レジスタ
--	signal LD_HiZ  : std_logic;
--	signal LD_Port : std_logic_vector(15 downto 0);

	-- ATAデータバス 出力レジスタ&制御レジスタ
	signal DDD_HiZ  : std_logic;
	signal DDD_Port : std_logic_vector(15 downto 0);

	-- ブリッジ制御レジスタ
	signal BRIDGE_En  : std_logic;
	constant Version  : std_logic_vector(15 downto 0) := X"0100";			-- Version 1.0
	constant IFBusBit : std_logic_vector(15 downto 0) := "0000000000000001";-- ATA

	-- ATA制御レジスタ
	signal ATA_RST    : std_logic;
	signal ATA_Mode   : std_logic_vector( 1 downto 0);
	signal ATAIntLvl  : std_logic_vector( 3 downto 0);
	signal ATAIntMsk  : std_logic;

--	-- USBアダプタ制御レジスタ
--	signal USBIntLvl  : std_logic_vector( 3 downto 0);
--	signal USBIntMsk  : std_logic;

	-- ダミー'H'レベル信号
	signal DUMMY      : std_logic;


begin


-- ************************************************************************* --
-- ********** 常時並列実行部分
-- ************************************************************************* --

-- ダミー'H'レベル信号
DUMMY    <= HRSTn or not BRIDGE_En;	-- 常時'H'レベル

-- ホストデータバス出力バッファ制御
HD <= HD_Port	when (BRIDGE_En = '1') and (Hit_Device = '1') and (HRDn = '0') else (others => 'Z');

-- ホストバイトイネーブル信号
-- SH-4 ビッグエンディアン時
--HBEl <= HBE1n;
--HBEh <= HBE0n;
-- SH-3 ビッグエンディアン時
HBEl <= HCE1An;
HBEh <= HCE2An;

-- ホスト制御信号
--HRDYn  <= HRDY	when (Hit_Device = '1') else 'Z';	-- ウェイト制御(SH-4)
HWAITn   <= not HRDY	when (Hit_Device = '1') else 'Z';	-- ウェイト制御(SH-3)
HIOIS16n <= '0'	when (BRIDGE_En = '1') else 'Z';	-- 16ビット幅固定

-- ATA(USB)リセット信号
RESETn   <= ATA_RST;	-- ソフトウェアリセット制御

-- ATA/ATAPI信号
DDD      <= DDD_Port when DDD_HiZ = '0' else (others => 'Z');
DDMACKn  <= DUMMY;	-- DMA未使用


-- 未使用信号
LD       <= (others => '0');		-- ローカルデータバス
LA(25 downto  0) <= (others => '0');-- ローカルアドレスバス
RDn      <= DUMMY;
WEn      <= DUMMY;
IORDn    <= DUMMY;
IOWRn    <= DUMMY;
-- USB
USBCSn   <= DUMMY;
-- ISAバス
ICLKOUT  <= '0';
ISALA19  <= '0';
ISAMRn   <= DUMMY;
ISAMWn   <= DUMMY;
-- PCカード共通
SLTx_DIR <= DUMMY;
-- PCカードソケット0
SLT0_ENn <= DUMMY;
SLT0_DEn <= DUMMY;
C0RST    <= DUMMY;
C0REGn   <= '0';
C0VCCEn  <= DUMMY;
C0CE1n   <= DUMMY;
C0CE2n   <= DUMMY;
-- PCカードソケット1
SLT1_ENn <= DUMMY;
SLT1_DEn <= DUMMY;
C1RST    <= DUMMY;
C1REGn   <= '0';
C1VCCEn  <= DUMMY;
C1CE1n   <= DUMMY;
C1CE2n   <= DUMMY;



-- ************************************************************************* --
-- ********** ブリッジコントローラ&ATA コントロールシーケンサ
-- ************************************************************************* --
CTRL_ATAUSB : process(SYSCLK,HRSTn)

-- ブリッジコントローラ&ATAシーケンサ ステートバリューレジスタ
	variable CTRLATA_CSTATE	: std_logic_vector (2 downto 0);	-- 現在のステート
	variable CTRLATA_NSTATE	: std_logic_vector (2 downto 0);	-- 次のステート

-- ブリッジコントローラ&ATAシーケンサ ステートマシン定義
	constant CTRLATA_IDLE	: std_logic_vector (2 downto 0) :="000";
	constant CTRLATA_CTRL	: std_logic_vector (2 downto 0) :="001";
	constant CTRLATA_WAIT0	: std_logic_vector (2 downto 0) :="010";
	constant CTRLATA_WAIT1	: std_logic_vector (2 downto 0) :="011";
	constant CTRLATA_ACCESS : std_logic_vector (2 downto 0) :="100";
	constant CTRLATA_DUMMY	: std_logic_vector (2 downto 0) :="101";
	constant CTRLATA_TURNA	: std_logic_vector (2 downto 0) :="111";

-- ブリッジコントローライネーブルフラグ
	variable BRIDGE_Ef : std_logic;

-- ATAレジスタアクセスウェイト
	variable WAIT_Count : unsigned(3 downto 0);
	variable ATA_Count  : unsigned(3 downto 0);

begin

-- ********** リセット時動作 **************** --
	if (HRSTn = '0') then	-- ホストCPUリセット

		-- ホストCPU側信号
		HD_Port   <= (others => '0');
		HRDY      <= '0';

		-- ブリッジコントローラ&ATAシーケンサ ステート初期化
		CTRLATA_CSTATE := CTRLATA_IDLE;
		CTRLATA_NSTATE := CTRLATA_IDLE;
		WAIT_Count := (others => '0');
		ATA_Count  := (others => '1');
		BRIDGE_En <= '0';	-- ブリッジコントローラ ディセーブル
		BRIDGE_Ef := '0';

		-- ATA制御レジスタ
		ATA_RST   <= '0';				-- ATAリセット制御レジスタ
		ATA_Mode  <= (others => '0');	-- PIO転送モード設定レジスタ
		ATAIntLvl <= (others => '0');
		ATAIntMsk <= '0';

		-- ATA/ATAPI信号初期化
		DDD_Port <= (others => '0');
		DDD_HiZ  <= '0';	-- ATAデータバス出力方向
		DCS0n    <= '1';
		DCS1n    <= '1';
		DDIOWn   <= '1';
		DDIORn   <= '1';
		DDA      <= (others => '0');



	-- 立ち上がりクロックで動作
	elsif (SYSCLK'event and SYSCLK = '1') then


		CTRLATA_CSTATE := CTRLATA_NSTATE;
		case CTRLATA_CSTATE is


	-- ********** CTRLATA_IDLE時の動作 ********** --
		when CTRLATA_IDLE =>		-- アイドル時

			if (Hit_Device = '1') and (Hit_CTRL = '1') then	-- ブリッジコントローラ選択時

				HRDY <= '1';	-- ホストへウェイト出力

				if (HA(8 downto 3) = "111110") then	-- ATAレジスタ空間選択

					if (ATA_Count = "1111") then	-- ATAサイクルタイムウェイト完了

						if (HA(9 downto 3) = "0111110") then	-- ATAコマンドブロックレジスタ空間(1F0h～1F7h)
							DCS0n <= '0';
						end if;
						if (HA(9 downto 3) = "1111110") then	-- ATAコントロールブロックレジスタ空間(3F0h～3F7h)
							DCS1n <= '0';
						end if;
						DDA   <= HA(2 downto 0);
						if (HRW = '1') then	-- リードサイクル
							DDD_HiZ <= '1';	-- ATA(IDE)データバスドライブ解放
						end  if;
						if (ATA_Mode = "00") then
							CTRLATA_NSTATE := CTRLATA_WAIT0;	-- モード0
						else
							CTRLATA_NSTATE := CTRLATA_WAIT1;	-- モード3/4
						end if;

					else	-- ATAサイクルウェイトが経過するまでアイドルに待機
						CTRLATA_NSTATE := CTRLATA_IDLE;
					end if;


				else	-- コントロールレジスタ空間選択
					CTRLATA_NSTATE := CTRLATA_CTRL;
				end if;

			else
				CTRLATA_NSTATE := CTRLATA_IDLE;
			end if;

			-- ATAアクセスサイクルウェイトカウンタ
			if (ATA_Count /= "1111") then
				ATA_Count := ATA_Count + 1;
			end if;



	-- ********** CTRLATA_CTRL時の動作 ********** --
		when CTRLATA_CTRL =>	-- ブリッジコントローラ制御レジスタ

			if (HRW = '1') then	-- リードアクセス

				case HA(9 downto 1) is
				when "000000000" =>	-- +00h Verisonレジスタ
					HD_Port <= Version;	-- ブリッジコントローラバージョン
				when "000000001" =>	-- +02h IFBusBitレジスタ
					HD_Port <= IFBusBit;	-- インターフェース実装ビット

				when "000001100" =>	-- +18h ATACtrlレジスタ
					HD_Port(15) <= ATA_RST;
					HD_Port(14 downto  2) <= (others => '0');
					HD_Port( 1 downto  0) <= ATA_Mode;
				when "000001101" =>	-- +1Ah ATAIntLvlレジスタ
					HD_Port(15 downto  4) <= (others => '0');
					HD_Port( 3 downto  0) <= ATAIntLvl;
				when "000001110" =>	-- +1Ch ATAIntMskレジスタ
					HD_Port(15 downto  1) <= (others => '0');
					HD_Port(0) <= ATAIntMsk;
				when "000001111" =>	-- +1Eh ATAIntStsレジスタ
					HD_Port(15 downto  1) <= (others => '0');
					HD_Port(0) <= DINTRQ;

				when others =>
					HD_Port(15 downto  0) <= (others => '0');
				end case;

			else					-- ライトサイクル

				if (HBEl = '0') and (HBEh = '0') then	-- 16ビットアクセス専用

					case HA(9 downto 1) is
					when "000000000" =>	-- +00h BridgeEnableレジスタ
						if (HD = X"4949") then	-- ブリッジイネーブルシグネチャ
							BRIDGE_Ef := '1';
						end if;

					when "000001100" =>	-- +18h ATACtrlレジスタ
						ATA_RST   <= HD(15);
						ATA_Mode  <= HD( 1 downto  0);
					when "000001101" =>	-- +1Ah ATAIntLvlレジスタ
						ATAIntLvl <= HD( 3 downto  0);
					when "000001110" =>	-- +1Ch ATAIntMskレジスタ
						ATAIntMsk <= HD(0);

					when others => null;
					end case;

				else
					null;	-- 8ビットアクセスの書き込みは無視
				end if;

			end if;

			WAIT_Count := "0001";	-- すでに1ステート実行しているので、ウェイトカウンタは1から
			CTRLATA_NSTATE := CTRLATA_DUMMY;



	-- ********** CTRLATA_DUMMY時の動作 ********** --
		when CTRLATA_DUMMY =>		-- ATAレジスタアクセス時の約400nsウェイト生成用ステート

			if (WAIT_Count = "1010") then	-- 10クロック目(11クロック=330ns)ウェイト
				CTRLATA_NSTATE := CTRLATA_TURNA;
			else
				CTRLATA_NSTATE := CTRLATA_DUMMY;
			end if;

			WAIT_Count := WAIT_Count + 1;	-- ウェイトカウンタ+1

			-- このステートの後に2ステートあるので、合計390nsのウェイト+α >= 400ns



	-- ********** CTRLATA_WAIT0時の動作 ********** --
		when CTRLATA_WAIT0 =>		-- ATAレジスタアクセス開始ウェイト(モード0)

			-- ウェイトカウンタは0からカウント開始
			case WAIT_Count is

			when "0010" =>		-- 2クロック目
				if (HRW = '1') then	-- リードサイクル
					DDIORn <= '0';
				else					-- ライトサイクル
					if (HA(0) = '0') then	-- 偶数アドレスアクセス
						DDD_Port(15 downto 8) <= HD( 7 downto 0);
						DDD_Port( 7 downto 0) <= HD(15 downto 8);
					else					-- 奇数アドレスアクセス
						DDD_Port( 7 downto 0) <= HD( 7 downto 0);
					end if;
					DDIOWn <= '0';
				end if;
				CTRLATA_NSTATE := CTRLATA_WAIT0;

			when "1011" =>		-- 11クロック目
				CTRLATA_NSTATE := CTRLATA_ACCESS;	-- アクセス完了

			when others =>
				CTRLATA_NSTATE := CTRLATA_WAIT0;
			end case;

			WAIT_Count := WAIT_Count + 1;	-- ウェイトカウンタ+1



	-- ********** CTRLATA_WAIT1時の動作 ********** --
		when CTRLATA_WAIT1 =>		-- ATAレジスタアクセス開始ウェイト(モード3/4)

			-- ウェイトカウンタは0からカウント開始
			case WAIT_Count is

			when "0000" =>		-- 0クロック目
				if (HRW = '1') then	-- リードサイクル
					DDIORn <= '0';
				else					-- ライトサイクル
					if (HA(0) = '0') then	-- 偶数アドレスアクセス
						DDD_Port(15 downto 8) <= HD( 7 downto 0);
						DDD_Port( 7 downto 0) <= HD(15 downto 8);
					else					-- 奇数アドレスアクセス
						DDD_Port( 7 downto 0) <= HD( 7 downto 0);
					end if;
					DDIOWn <= '0';
				end if;
				CTRLATA_NSTATE := CTRLATA_WAIT1;

			when "0010" =>		-- 2クロック目
				CTRLATA_NSTATE := CTRLATA_ACCESS;	-- アクセス完了

			when others =>
				CTRLATA_NSTATE := CTRLATA_WAIT1;
			end case;

			WAIT_Count := WAIT_Count + 1;	-- ウェイトカウンタ+1



	-- ********** CTRLATA_ACCESSA時の動作 ********** --
		when CTRLATA_ACCESS =>		-- ATAレジスタリード/ライト

			if (DIORDY = '1') then	-- ATAデバイスウェイト未要求

				if (HRW = '1') then	-- リードサイクル
					if (HA(0) = '0') then	-- 偶数アドレスアクセス
						HD_Port(15 downto 8) <= DDD( 7 downto 0);
						HD_Port( 7 downto 0) <= DDD(15 downto 8);
					else					-- 奇数アドレスアクセス
						HD_Port( 7 downto 0) <= DDD( 7 downto 0);
					end if;
				end if;
				DDIORn <= '1';
				DDIOWn <= '1';
				if (ATA_Mode = "00") then		-- モード0
					ATA_Count := "0101";
				elsif (ATA_Mode = "01") then	-- モード3
					ATA_Count := "1110";
				else							-- モード4
					ATA_Count := "1111";
				end if;
				CTRLATA_NSTATE := CTRLATA_TURNA;

			else					-- ATAデバイスウェイト要求中
				CTRLATA_NSTATE := CTRLATA_ACCESS;
			end if;



	-- ********** CTRLATA_TURNA時の動作 ********** --
		when CTRLATA_TURNA =>		-- アクセス完了処理

			WAIT_Count := (others => '0');
			DCS0n   <= '1';
			DCS1n   <= '1';
			DDD_HiZ <= '0';	-- ATAデータバスドライブ開始

			if (HRDY = '1') then
				HRDY           <= '0';	-- ホストウェイト出力解除
				CTRLATA_NSTATE := CTRLATA_TURNA;
			else
				BRIDGE_En      <= BRIDGE_Ef;-- ブリッジイネーブルビットは最後に設定
				CTRLATA_NSTATE := CTRLATA_IDLE;
			end if;



	-- ********************************************** --
		when others =>			-- ステートマシン異常時処理
			DDIORn    <= '1';
			DDIOWn    <= '1';
			CTRLATA_NSTATE := CTRLATA_TURNA;

		end case;

	end if;

end process CTRL_ATAUSB;




-- ************************************************************************* --
-- ********** ホスト割り込み出力制御
-- ************************************************************************* --
INT_Ctrl : process (DINTRQ, ATAIntLvl, ATAIntMsk)
begin
	if (DINTRQ = '1') and (ATAIntMsk = '1') then	-- ATA割り込み
		HIRL <= not ATAIntLvl;
	else
		HIRL <= (others => '1');	-- 非割り込み要求時
	end if;
end process INT_Ctrl;




-- ************************************************************************* --
-- **********	アドレスデコーダ
-- ************************************************************************* --

-- SH-3 エリア5使用時 メモリマップ
-- 物理アドレス 論理アドレス 空間
-- 1400_0000h   B400_0000h    2Mバイト ブリッジコントローラレジスタ空間
-- 141F_FFFFh   B41F_FFFFh
-- 1420_0000h   B420_0000h    2Mバイト(未使用)
-- 143F_FFFFh   B43F_FFFFh
-- 1440_0000h   B440_0000h    2Mバイト(未使用)
-- 145F_FFFFh   B45F_FFFFh
-- 1460_0000h   B460_0000h    2Mバイト(未使用)
-- 147F_FFFFh   B47F_FFFFh
-- 1480_0000h   B480_0000h    2Mバイト USBアダプタ空間
-- 149F_FFFFh   B49F_FFFFh
-- 14A0_0000h   B4A0_0000h    2Mバイト ISAバス I/O空間
-- 14BF_FFFFh   B4BF_FFFFh
-- 14C0_0000h   B4C0_0000h    2Mバイト PCカードソケット0 I/O空間
-- 14DF_FFFFh   B4DF_FFFFh
-- 14E0_0000h   B4E0_0000h    2Mバイト PCカードソケット1 I/O空間
-- 14FF_FFFFh   B4FF_FFFFh
-- 1500_0000h   B500_0000h   16Mバイト ISAバスメモリ空間
-- 15FF_FFFFh   B5FF_FFFFh
-- 1600_0000h   B600_0000h   16Mバイト PCカードソケット0 I/O空間
-- 16FF_FFFFh   B6FF_FFFFh
-- 1700_0000h   B700_0000h   16Mバイト PCカードソケット1 I/O空間
-- 17FF_FFFFh   B7FF_FFFFh

Address_Decoder1 : process (HRSTn,HCLK)
begin
	if (HRSTn = '0') then
		Hit_Device <= '0';
	elsif (HCLK'event and HCLK = '1') then
		-- ホストクロックの立ち上がりで/CSnをサンプリング
		if (HCE1An = '0') or (HCE2An = '0') then	-- SH-3 エリア5
	--	if (HCE1Bn = '0') or (HCE2Bn = '0') then	-- SH-3 エリア6
			Hit_Device <= '1';
		else
			Hit_Device <= '0';
		end if;
	end if;
end process Address_Decoder1;

--                      ((HCE1An = '0') or (HCE2An = '0'))	-- SH-3 エリア5
--                      ((HCE1Bn = '0') or (HCE2Bn = '0'))	-- SH-3 エリア6
Hit_CTRL	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 21) = "00000") else '0';	-- ブリッジコントローラ&ATAレジスタ空間
--Hit_USB	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 21) = "00100") else '0';	-- USBアダプタ空間
--Hit_ISAI	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 21) = "00101") else '0';	-- ISAバス I/O空間
--Hit_PC0I	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 21) = "00110") else '0';	-- PCカードソケット0 I/O空間
--Hit_PC1I	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 21) = "00111") else '0';	-- PCカードソケット1 I/O空間
--Hit_ISAM	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 24) = "01")    else '0';	-- ISAバスメモリ空間
--Hit_PC0M	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 24) = "10")    else '0';	-- PCカードソケット0 メモリ空間
--Hit_PC1M	<= '1' when ((HCE1An = '0') or (HCE2An = '0')) and (HA(25 downto 24) = "11")    else '0';	-- PCカードソケット1 メモリ空間

--Hit_PC0	<= Hit_PC0I or Hit_PC0M;	-- PCカード ソケット0選択
--Hit_PC1	<= Hit_PC1I or Hit_PC1M;	-- PCカード ソケット1選択
--Hit_PCxM	<= Hit_PC0M or Hit_PC1M;	-- PCカード メモリ空間選択
--Hit_PCxI	<= Hit_PC0I or Hit_PC1I;	-- PCカード I/O空間選択




-- ************************************************************************* --
-- **********	ホストクロック分周(SH-3外部バスクロックの1/2)
-- ************************************************************************* --
SYSCLK_Ctrl : process(HCLK,HRSTn)
begin
	if (HRSTn = '0') then
		SYSCLK <= '0';
	elsif (HCLK'event and HCLK = '1') then
		SYSCLK <= not SYSCLK;	-- 60MHz / 2 = 30MHz = システムクロック
	end if;
end process SYSCLK_Ctrl;


end architecture RTL;

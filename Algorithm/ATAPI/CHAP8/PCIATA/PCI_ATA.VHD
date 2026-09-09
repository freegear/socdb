-- ************************************************************************* --
-- PCI ATAインターフェース（PIO転送専用）
-- ************************************************************************* --
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity PCI_ATA is
	port(

	-- PCIバス信号ピン(PCI_ATAで使用する信号) --
		PCICLK		: in	std_logic;			-- PCIバスクロック
		PCIRST_n	: in	std_logic;			-- 非同期リセット
		PCIAD		: inout std_logic_vector(31 downto 0);	-- アドレス/データバス
		C_nBE		: in 	std_logic_vector(3 downto 0);	-- PCIバスコマンド/バイトイネーブル
		FRAME_n		: in	std_logic;			-- フレーム
		IRDY_n		: in	std_logic;			-- イニシエータレディ
		DEVSEL_n	: out	std_logic;			-- デバイスセレクション
		TRDY_n		: out	std_logic;			-- ターゲットレディ
		IDSEL		: in	std_logic;			-- コンフィグレーションデバイスセレクト
		INTA_n		: out	std_logic;			-- 割り込み出力 INTA#
		STOP_n		: out	std_logic;			-- 転送ストップ要求
		PAR			: inout std_logic;			-- パリティビット

	-- PCIバス信号ピン(未使用信号) --
		PERR_n		: out	std_logic;			-- パリティエラー
		SERR_n 		: out	std_logic;			-- システムエラー
		REQ_n 		: out	std_logic;			-- バス使用要求信号
		GNT_n 		: in	std_logic;			-- バス使用許諾信号
		INTB_n 		: out	std_logic;			-- 割り込み出力 INTB#
		INTC_n 		: out	std_logic;			-- 割り込み出力 INTC#
		INTD_n 		: out	std_logic;			-- 割り込み出力 INTD#
		LOCK_n 		: in	std_logic;			-- 排他アクセス制御
		SBO_n 		: inout std_logic;			-- スヌープバックオフ
		SDONE_n 	: inout std_logic;			-- スヌープ完了

		-- ATA/ATAPI信号ピン
		RESETn 		: out	std_logic;			-- リセット
		DA			: out	std_logic_vector(2 downto 0);	-- ATAアドレスバス
		DD			: inout	std_logic_vector(15 downto 0);	-- ATAデータバス
		CS0n		: out	std_logic;			-- ATAチップセレクト
		CS1n		: out	std_logic;			-- ATAチップセレクト
		DMARQ		: in	std_logic;			-- ATA DMAリクエスト
		INTRQ		: in	std_logic;			-- ATA 割り込み
		IORDY		: in	std_logic;			-- ATA レディ
		DIOWn		: out	std_logic;			-- ATA リード
		DIORn		: out	std_logic;			-- ATA ライト
		DMACKn		: out	std_logic			-- ATA DMAアクノリッジ

	);
end entity PCI_ATA;

architecture RTL of PCI_ATA is


-- ************************************************************************* --
-- **********	レジスタ/定数 定義部分
-- ************************************************************************* --

-- PCIバスコマンド/アドレス/IDSELホールドレジスタ --
	signal PCI_BusCommand		: std_logic_vector(3 downto 0);	-- PCIバスコマンドレジスタ
	signal PCI_Address			: std_logic_vector(31 downto 0);	-- PCIアドレスレジスタ
	signal PCI_IDSEL			: std_logic;						-- IDSELレジスタ

-- ローカルバスシーケンサ スタートフラグ
	signal LOCAL_Bus_Start 		: std_logic;
-- ローカルバスシーケンサ データ転送完了フラグ
	signal LOCAL_DTACK			: std_logic;

-- トライステートバッファ制御用のフリップフロップ定義 --
	-- PCIバス信号線
	signal PCIAD_HiZ 				: std_logic;						-- ADポート出力ドライブ制御
	signal PCIAD_Port				: std_logic_vector(31 downto 0);	-- ADポート出力レジスタ
	signal DEVSEL_HiZ, DEVSEL_Port	: std_logic;	-- DEVSEL#出力ドライブ制御/出力レジスタ
	signal TRDY_HiZ, TRDY_Port		: std_logic;	-- TRDY#出力ドライブ制御/出力レジスタ
	signal INTA_HiZ, INTA_Port		: std_logic;	-- INTA#出力ドライブ制御/出力レジスタ
	signal PAR_HiZ,  PAR_Port		: std_logic;	-- PAR出力ドライブ制御/出力レジスタ
	signal STOP_HiZ, STOP_Port		: std_logic;	-- STOP出力ドライブ制御/出力レジスタ

	signal PERR_HiZ, PERR_Port		: std_logic;	-- ダミーノード(PIO未使用)
	signal SERR_HiZ, SERR_Port		: std_logic;
	signal REQ_HiZ,  REQ_Port		: std_logic;
	signal INTB_HiZ, INTB_Port		: std_logic;
	signal INTC_HiZ, INTC_Port		: std_logic;
	signal INTD_HiZ, INTD_Port		: std_logic;
	signal SBO_HiZ,  SBO_Port		: std_logic;
	signal SDONE_HiZ,SDONE_Port		: std_logic;

--  PCIバスコマンド(ビットパターン定義) --
	-- コンフィギュレーションサイクル
	constant PCI_CfgCycle		: std_logic_vector(3 downto 1) := ("101");
	constant PCI_CfgReadCycle	: std_logic_vector(3 downto 0) := ("1010");
	constant PCI_CfgWriteCycle	: std_logic_vector(3 downto 0) := ("1011");
	-- メモリサイクル
	constant PCI_MemCycle		: std_logic_vector(3 downto 1) := ("011");
	constant PCI_MemReadCycle	: std_logic_vector(3 downto 0) := ("0110");
	constant PCI_MemWriteCycle	: std_logic_vector(3 downto 0) := ("0111");
	-- I/Oサイクル
	constant PCI_IoCycle		: std_logic_vector(3 downto 1) := ("001");
	constant PCI_IoReadCycle	: std_logic_vector(3 downto 0) := ("0010");
	constant PCI_IoWriteCycle	: std_logic_vector(3 downto 0) := ("0011");

-- コンフィギュレーションレジスタ群(読み出し専用レジスタ) --
	constant CFG_VendorID		: std_logic_vector(15 downto 0) := (X"6809");	-- ベンダID 6809h
	constant CFG_DeviceID		: std_logic_vector(15 downto 0) := (X"8117");	-- デバイスID 8117h
	constant CFG_Command		: std_logic_vector(15 downto 0) := (X"0000");
	constant CFG_Status			: std_logic_vector(15 downto 0) := (X"0200");	-- DEVSEL# 中速応答
	constant CFG_BaseClass		: std_logic_vector(7  downto 0) := (X"01");		-- ストレージ
	constant CFG_SubClass		: std_logic_vector(7  downto 0) := (X"80");		-- その他
	constant CFG_ProgramIF		: std_logic_vector(7  downto 0) := (X"00");
	constant CFG_RevisionID		: std_logic_vector(7  downto 0) := (X"01");		-- レビジョン 1
	constant CFG_HeaderType		: std_logic_vector(7  downto 0) := (X"00");		-- ヘッダタイプ0
	constant CFG_SubVendorID	: std_logic_vector(15 downto 0) := CFG_VendorID ;
	constant CFG_SubDeviceID	: std_logic_vector(15 downto 0) := CFG_DeviceID ;
	constant CFG_Int_Pin		: std_logic_vector(7  downto 0) := (X"01");		-- INTA#のみ使用

-- コンフィギュレーションレジスタ群(読み書きレジスタ) --
	-- コマンドレジスタ I/Oイネーブルビット
	signal CFG_Cmd_Io : std_logic;
	-- ベースアドレスレジスタ(I/O空間)
	signal CFG_Base_Addr0 : std_logic_vector(15 downto 5);
	-- インタラプトラインレジスタ
	signal CFG_Int_Line : std_logic_vector(7 downto 0);
	-- PIO転送モードレジスタ
	signal PIO_Mode   : std_logic_vector(2 downto 0);

-- アドレスデコードフラグ
	signal Hit_Device : std_logic;	-- デバイスヒット
	signal Hit_Io : std_logic;		-- I/Oサイクルヒット
	signal Hit_Config : std_logic;	-- コンフィグレーションサイクルヒット

-- ATAデータバス 出力レジスタ&制御レジスタ
	signal DD_HiZ  : std_logic;
	signal DD_Port : std_logic_vector(15 downto 0);

-- ダミー'H'レベル信号
	signal DUMMY	  : std_logic;


begin


-- ************************************************************************* --
-- **********	同時処理文
-- ************************************************************************* --

-- トライステートバッファ動作
	PCIAD	 <= (others => 'Z') when PCIAD_HiZ = '1'	else PCIAD_Port;
	DEVSEL_n <= 'Z'				when DEVSEL_HiZ = '1'	else DEVSEL_Port;
	TRDY_n   <= 'Z'				when TRDY_HiZ = '1'		else TRDY_Port;
	INTA_n	 <= 'Z'				when INTA_HiZ = '1'		else INTA_Port;
	PAR		 <= 'Z'				when PAR_HiZ = '1'		else PAR_Port;
	STOP_n	 <= 'Z'				when STOP_HiZ = '1'		else STOP_Port;

-- 未使用ピンの状態設定(ハイインピーダンス状態に固定)
	PERR_n	<= 'Z'	when PERR_HiZ = '1'	 else PERR_Port;  PERR_HiZ  <= '1'; PERR_Port  <= '0';
	SERR_n	<= 'Z'	when SERR_HiZ = '1'	 else SERR_Port;  SERR_HiZ  <= '1'; SERR_Port  <= '0';
	REQ_n	<= 'Z'	when REQ_HiZ = '1'	 else REQ_Port;	  REQ_HiZ   <= '1'; REQ_Port   <= '0';
	INTB_n	<= 'Z'	when INTB_HiZ = '1'	 else INTB_Port;  INTB_HiZ  <= '1'; INTB_Port  <= '0';
	INTC_n	<= 'Z'	when INTC_HiZ = '1'	 else INTC_Port;  INTC_HiZ  <= '1'; INTC_Port  <= '0';
	INTD_n	<= 'Z'	when INTD_HiZ = '1'	 else INTD_Port;  INTD_HiZ  <= '1'; INTD_Port  <= '0';
	SBO_n	<= 'Z'	when SBO_HiZ = '1'	 else SBO_Port;   SBO_HiZ   <= '1'; SBO_Port   <= '0';
	SDONE_n	<= 'Z'	when SDONE_HiZ = '1' else SDONE_Port; SDONE_HiZ <= '1'; SDONE_Port <= '0';

-- ATAリセット信号
	RESETn   <= PCIRST_n;	-- PCIバスリセット

-- ATA/ATAPI信号
	DD		<= DD_Port when DD_HiZ = '0' else (others => 'Z');
	DMACKn  <= '1' ;		-- DMA未使用

-- ダミー'H'レベル信号
	DUMMY	<= not PCIRST_n or not CFG_Cmd_Io;	-- 常時'H'レベル



-- ************************************************************************* --
-- **********	PCIターゲットシーケンサ
-- ************************************************************************* --

PCI_TGT_Seq : process( PCICLK, PCIRST_n )

-- PCIターゲットシーケンサ ステートバリューレジスタ --
	variable PCI_CURRENT_STATE	: std_logic_vector (2 downto 0);	-- 現在のステート
	variable PCI_NEXT_STATE		: std_logic_vector (2 downto 0);	-- 次のステート

-- PCIターゲットシーケンサ ステートマシン定義
	constant BUS_IDLE		: std_logic_vector (2 downto 0) :="000";
	constant ADRS_COMPARE	: std_logic_vector (2 downto 0) :="001";
	constant BUS_BUSY		: std_logic_vector (2 downto 0) :="010";
	constant WAIT_IRDY		: std_logic_vector (2 downto 0) :="011";
	constant WAIT_LOCAL_ACK : std_logic_vector (2 downto 0) :="100";
	constant ACC_COMPLETE	: std_logic_vector (2 downto 0) :="101";
	constant DIS_CONNECT	: std_logic_vector (2 downto 0) :="110";
	constant TURN_AROUND	: std_logic_vector (2 downto 0) :="111";

begin

-- ********** リセット時動作 ********** --
	if (PCIRST_n = '0') then	-- PCIバスリセット時(非同期リセット)

		PCI_CURRENT_STATE	:= BUS_IDLE;	-- ステートマシン IDLE状態 リセット
		PCI_NEXT_STATE		:= BUS_IDLE;	-- ステートマシン IDLE状態 リセット

		LOCAL_Bus_Start <= '0';		-- ローカルバスシーケンサ スタートフラグ クリア

		PCI_BusCommand <= (others => '0');	-- PCIバスコマンドレジスタ クリア
		PCI_Address <= (others => '0');		-- PCIバスアドレスレジスタ クリア
		PCI_IDSEL <= '0';					-- IDSELレジスタ クリア

	-- 制御出力端子をハイインピーダンス
		PCIAD_HiZ <= '1';
		DEVSEL_HiZ <= '1'; DEVSEL_Port <= '1';	-- DEVSEL#="H"
		TRDY_HiZ   <= '1'; TRDY_Port   <= '1';	-- TRDY#="H"
		STOP_HiZ   <= '1'; STOP_Port   <= '1';	-- STOP#="H"
		PAR_HiZ   <= '1';	-- PAR_Portはパリティジェネレータで生成


-- ********** PCIターゲットシーケンサ ステートマシン ********** --
	elsif (PCICLK'event and PCICLK = '1') then

		PCI_CURRENT_STATE := PCI_NEXT_STATE;	-- ステートマシン制御
		case PCI_CURRENT_STATE is

	-- ********** BUS_IDLE時の動作 ********** --
		when BUS_IDLE =>	-- トランザクションの開始待ち

			if (FRAME_n = '0' and IRDY_n = '1') then	-- トランザクション開始
				PCI_BusCommand <= C_nBE;	-- PCIバスコマンド取得
				PCI_Address <= PCIAD;		-- アドレス取得
				PCI_IDSEL <= IDSEL;			-- IDSEL取得
				PCI_NEXT_STATE := ADRS_COMPARE;

			else	-- バスアイドル時このステートにとどまる
				PCI_NEXT_STATE := BUS_IDLE;
			end if;


	-- ********** ADRS_COMPARE時の動作 ********** --
		when ADRS_COMPARE =>	-- アドレスデコード結果を調べる

			if (Hit_Device = '1') then	-- 自分が選択された
				DEVSEL_Port <= '0'; DEVSEL_HiZ <= '0';	-- DEVLSEL#アサート
				TRDY_HiZ <= '0';	-- TRDY# を "H"にドライブ
				STOP_HiZ <= '0';	-- STOP# を "H"にドライブ
				PCI_NEXT_STATE := WAIT_IRDY;	-- イニシエータレディを待つステートへ

			else	-- 自分が選択されていない
				PCI_NEXT_STATE := BUS_BUSY;	-- トランザクションの終了を待つステートへ
			end if;


	-- ********** BUS_BUSY時の動作 ********** --
		when BUS_BUSY =>	-- トランザクション終了待ち

			if (FRAME_n = '1' and IRDY_n = '1') then	-- トランザクション終了(アイドル)
				PCI_NEXT_STATE := BUS_IDLE;	-- トランザクション開始待ちステートへ

			else	-- トランザクション中ならこのステートにとどまる
				PCI_NEXT_STATE := BUS_BUSY;
			end if;


	-- ********** WAIT_IRDY時の動作 ********** --
		when WAIT_IRDY =>	-- イニシエータレディ待ち

			if (IRDY_n = '0') then	-- イニシエータの準備完了
				if (PCI_BusCommand(0) = '0') then	-- リードサイクルのとき
					PCIAD_HiZ <= '0' ;				-- PCIAD[31:0]バスドライブ
				end if;
				LOCAL_Bus_Start <= '1';	-- ローカルバスシーケンサ スタート!
				PCI_NEXT_STATE := WAIT_LOCAL_ACK;	-- ローカルバスシーケンサ終了待ちステートへ

			else	-- イニシエータの準備がまだならこのステートにとどまる
				PCI_NEXT_STATE := WAIT_IRDY;
			end if;


	-- ********** WAIT_LOCAL_ACK時の動作 ********** --
		when WAIT_LOCAL_ACK =>	-- ローカルバスシーケンサ終了待ち

			LOCAL_Bus_Start <= '0';	-- ローカルバスシーケンサ スタートフラグ クリア

			if (LOCAL_DTACK = '1') then	-- ローカルバスシーケンサ データ転送完了
				TRDY_Port <= '0';	-- TRDY# アサート
				STOP_Port <= '0';	-- STOP# アサート
				PCI_NEXT_STATE := ACC_COMPLETE;	-- アクセス完了ステートへ

			else	-- ローカルバスシーケンサの準備がまだならこのステートにとどまる
				PCI_NEXT_STATE := WAIT_LOCAL_ACK;
			end if;


	-- ********** ACC_COMPLETE時の動作 ********** --
		when ACC_COMPLETE =>	-- アクセス完了ステート

			TRDY_Port <= '1';		-- TRDY# ディアサート
			PCIAD_HiZ <= '1' ;		-- PCIAD[31:0]バスドライブ解放
			if (PCI_BusCommand(0) = '0') then	-- リードサイクルであれば
				PAR_HiZ <= '0' ;				-- PAR ドライブ開始
			end if;

			if (FRAME_n = '0') then			-- FRAME# = 'L'ならバースト転送要求
				PCI_NEXT_STATE := DIS_CONNECT;	-- ディスコネクトステートへ

			else	-- 単一データフェーズのトランザクションの時
				DEVSEL_Port <= '1';		-- DEVSEL#ディアサート
				STOP_Port   <= '1';		-- STOP#ディアサート
				PCI_NEXT_STATE := TURN_AROUND;	--  ターンアラウンドステートへ
			end if;


	-- ********** DIS_CONNECT時の動作 ********** --
		when DIS_CONNECT =>		-- ディスコネクト処理

			if (FRAME_n = '1') then	-- イニシエータがSTOP#を認識
				DEVSEL_Port <= '1';	-- DEVSEL# ディアサート
				STOP_Port <= '1';	-- STOP# ディアサート
				PCI_NEXT_STATE := TURN_AROUND;	-- 次はTURN_AROUNDステートへ

			else	-- イニシエータがSTOP#を認識していなければこのステートにとどまる
				PCI_NEXT_STATE := DIS_CONNECT;
			end if;


	-- ********** TURN_AROUND時の動作 ********** --
		when TURN_AROUND =>		-- ターンアラウンドステート

			DEVSEL_HiZ <= '1';			-- DEVSEL#ドライブ解放
			TRDY_HiZ <= '1';			-- TRDY#ドライブ解放
			STOP_HiZ <= '1';			-- STOP#ドライブ解放
			PAR_HiZ <= '1';				-- PARドライブ解放
			PCI_NEXT_STATE := BUS_IDLE;	-- トランザクション開始待ちステートへ


	-- ****************************************** --
		when others => null;	-- これ以外の値では何もしない場合でも必ず入れる

	end case;

	end if;

end process PCI_TGT_Seq;



-- ************************************************************************* --
-- **********	ローカルバスシーケンサ
-- ************************************************************************* --
LOCAL_BUS_Seq : process( PCICLK, PCIRST_n )

-- ローカルバスシーケンサ ステートバリューレジスタ --
	variable LOCAL_CURRENT_STATE : std_logic_vector (2 downto 0);	-- 現在のステート
	variable LOCAL_NEXT_STATE : std_logic_vector (2 downto 0);		-- 次のステート

-- ローカルバスシーケンサ ステートマシン定義
	constant LOCAL_IDLE			: std_logic_vector(2 downto 0) := "000";
	constant LOCAL_SETUP_WAIT	: std_logic_vector(2 downto 0) := "001";
	constant LOCAL_WIDTH_WAIT	: std_logic_vector(2 downto 0) := "010";
	constant LOCAL_ATA_ACCESS	: std_logic_vector(2 downto 0) := "011";
	constant LOCAL_CFG_ACCESS	: std_logic_vector(2 downto 0) := "100";
	constant LOCAL_400n_WAIT	: std_logic_vector(2 downto 0) := "101";
	constant LOCAL_STATE_COMP	: std_logic_vector(2 downto 0) := "111";

-- ATAレジスタアクセスウェイト
	variable ATA_Count   : std_logic;
	variable SETUP_Count : std_logic_vector(1 downto 0);
	variable WIDTH_Count : std_logic_vector(3 downto 0);
	variable WAIT_Count  : unsigned(3 downto 0);

begin

-- ********** リセット時動作 ********** --
	if ( PCIRST_n = '0' ) then	-- PCIバスリセットがアサートされたとき

		-- ステートバリューレジスタクリア
		LOCAL_CURRENT_STATE := (others => '0');	-- ローカルバスシーケンサ リセット
		LOCAL_NEXT_STATE := (others => '0');	-- ローカルバスシーケンサ リセット

		-- コンフィグレーションレジスタ リード/ライトレジスタ インタラプトライン クリア
		CFG_Cmd_Io  <= '0';
		CFG_Base_Addr0 <= (others => '0');
		CFG_Int_Line <= (others => '0');

		-- AD出力レジスタ クリア
		PCIAD_Port <= (others => '0');

		-- PCI割り込み出力クリア
		INTA_Port <= '0';
		INTA_HiZ  <= '1';	-- 割り込み非出力

		-- ローカルバスシーケンサ データ転送完了フラグ クリア
		LOCAL_DTACK <= '0' ;

		-- PIO転送モードレジスタ
		PIO_Mode  <= (others => '0');

		-- ATA/ATAPI信号初期化
		DD_Port <= (others => '0');
		DD_HiZ  <= '0';	-- ATAデータバス出力方向
		CS0n	<= '1';
		CS1n	<= '1';
		DIOWn   <= '1';
		DIORn   <= '1';
		DA	  <= (others => '0');

		-- ATAレジスタアクセスウェイトクリア
		ATA_Count   := '0';
		SETUP_Count := (others => '0');
		WIDTH_Count := (others => '0');
		WAIT_Count  := (others => '0');


	elsif (PCICLK'event and PCICLK = '1') then


		-- PCI INTA#割り込み出力
		if (INTRQ = '1' ) then		-- ATA割り込み入力
			INTA_HiZ <= '0';		-- 割り込み出力
		else
			INTA_HiZ <= '1';		-- 割り込み非出力
		end if;


-- ********** ローカルバスシーケンサ ステートマシン ********** --

		LOCAL_CURRENT_STATE := LOCAL_NEXT_STATE ;
		case LOCAL_CURRENT_STATE is


	-- ********** LOCAL_IDLE時の動作 ********** --
		when LOCAL_IDLE =>	-- ローカルバスシーケンサ スタート指示待ち

			if (LOCAL_Bus_Start = '1' ) then	-- ローカルバスシーケンサ スタート!

				if (Hit_Config = '1') then	-- コンフィグレーションサイクルヒット
					LOCAL_NEXT_STATE := LOCAL_CFG_ACCESS;	-- コンフィグレーションステートへ
				end if;

				if (Hit_Io = '1') then		-- I/Oサイクルヒット

					if (PCI_Address(4) = '1') then	-- 400nsウェイト用I/Oアクセス
						WAIT_Count  := (others => '0');
						LOCAL_NEXT_STATE := LOCAL_400n_WAIT;

					else	-- ATAレジスタアクセス

						if (ATA_Count = '1') then	-- ATAサイクルタイムウェイト完了

							if (PCI_Address(3) = '0') then	-- ATAコマンドブロックレジスタ空間(0h～7h)
								CS0n <= '0';
							else							-- ATAコントロールブロックレジスタ空間(8h～Fh)
								CS1n <= '0';
							end if;
							DA   <= PCI_Address(2 downto 0);

							if (PCI_BusCommand(0) = '0' ) then	-- リードサイクル
								DD_HiZ <= '1';	-- ATA(IDE)データバスドライブ解放
							end  if;

							case PIO_Mode is	-- PIO転送モード別パラメータ設定
							when "000" =>	-- モード0
								SETUP_Count := "11";	-- アドレスセットアップウェイト 3クロック
								WIDTH_Count := "1010";	-- クロック幅ウェイト 10クロック
							when "001" =>	-- モード1
								SETUP_Count := "10";	-- アドレスセットアップウェイト 2クロック
								WIDTH_Count := "1010";	-- クロック幅ウェイト 10クロック
							when "010" =>	-- モード2
								SETUP_Count := "01";	-- アドレスセットアップウェイト 1クロック
								WIDTH_Count := "1010";	-- クロック幅ウェイト 10クロック
							when others =>	-- モード3/4
								SETUP_Count := "01";	-- アドレスセットアップウェイト 1クロック
								WIDTH_Count := "0011";	-- クロック幅ウェイト 3クロック
							end case;
							WAIT_Count := "0001";	-- ウェイトカウンタクリア(次のステート遷移分で1ウェイトカウント)
							LOCAL_NEXT_STATE := LOCAL_SETUP_WAIT;

						else	-- ATAサイクルウェイトが経過するまでアイドルに待機
							LOCAL_NEXT_STATE := LOCAL_IDLE;
						end if;

					end if;

				end if;


			else	-- ローカルバスシーケンサ スタートフラグがまだならこのステートにとどまる

				LOCAL_NEXT_STATE := LOCAL_IDLE;
			end if;

			ATA_Count := '1';	-- ATAサイクルタイムウェイト(ATA_Count=ATA_Count+1だが、1ビットしかないので)


	-- ********** LOCAL_SETUP_WAIT時の動作 ********** --
		when LOCAL_SETUP_WAIT =>	-- アドレスセットアップウェイト

			if (WAIT_Count(1 downto 0) = unsigned(SETUP_Count(1 downto 0)) ) then	-- 最終ウェイト

				if (PCI_BusCommand(0) = '0' ) then	-- リードサイクル
					DIORn <= '0';

				else								-- ライトサイクル
					case PCI_Address(1 downto 0) is
					when "00" =>	-- +0アドレスアクセス
						DD_Port(15 downto 0) <= PCIAD(15 downto 0);	-- Dataレジスタがあるのでここだけ16ビット渡し
					when "01" =>	-- +1アドレスアクセス
						DD_Port( 7 downto 0) <= PCIAD(15 downto 8 );
					when "10" =>	-- +2アドレスアクセス
						DD_Port( 7 downto 0) <= PCIAD(23 downto 16);
					when others =>	-- +3アドレスアクセス
						DD_Port( 7 downto 0) <= PCIAD(31 downto 24);
					end case;
					DIOWn <= '0';
				end if;

				WAIT_Count := "0010";	-- ウェイトカウンタクリア(2ウェイト)
				-- 次のステート遷移分で1ウェイト さらにLOCAL_ATA_ACCESSステートへの遷移分で1ウェイト)
				LOCAL_NEXT_STATE := LOCAL_WIDTH_WAIT;

			else
				WAIT_Count := WAIT_Count + 1;	-- ウェイトカウンタ+1
				LOCAL_NEXT_STATE := LOCAL_SETUP_WAIT;
			end if;


	-- ********** LOCAL_WIDTH_WAIT時の動作 ********** --
		when LOCAL_WIDTH_WAIT =>		-- DIOR#/DIOW#クロック幅ウェイト

			if (WAIT_Count(3 downto 0) = unsigned(WIDTH_Count(3 downto 0)) ) then	-- 最終ウェイト
				LOCAL_NEXT_STATE := LOCAL_ATA_ACCESS;	-- アクセス完了

			else
				WAIT_Count := WAIT_Count + 1;	-- ウェイトカウンタ+1
				LOCAL_NEXT_STATE := LOCAL_WIDTH_WAIT;
			end if;


	-- ********** LOCAL_ATA_ACCESSA時の動作 ********** --
		when LOCAL_ATA_ACCESS =>		-- ATAレジスタリード/ライト

			if (IORDY = '1') then	-- ATAデバイスウェイト未要求

				if (PCI_BusCommand(0) = '0' ) then	-- リードサイクル
					case PCI_Address(1 downto 0) is
					when "00" =>	-- +0アドレスアクセス
						PCIAD_Port(31 downto 16) <= (others => '0');
						PCIAD_Port(15 downto 0 ) <= DD(15 downto 0);	-- Dataレジスタがあるのでここだけ16ビット渡し
					when "01" =>	-- +1アドレスアクセス
						PCIAD_Port(31 downto 16) <= (others => '0');
						PCIAD_Port(15 downto 8 ) <= DD(7 downto 0);
						PCIAD_Port( 7 downto 0 ) <= (others => '0');
					when "10" =>	-- +2アドレスアクセス
						PCIAD_Port(31 downto 24) <= (others => '0');
						PCIAD_Port(23 downto 16) <= DD(7 downto 0);
						PCIAD_Port(15 downto 0 ) <= (others => '0');
					when others =>	-- +3アドレスアクセス
						PCIAD_Port(31 downto 24) <= DD(7 downto 0);
						PCIAD_Port(23 downto 0 ) <= (others => '0');
					end case;
				end if;

				DIORn <= '1';
				DIOWn <= '1';

				if (PIO_Mode = "000") then		-- モード0
					ATA_Count := '0';
				else							-- それ以外モード
					ATA_Count := '1';
				end if;

				LOCAL_DTACK <= '1' ;	-- ローカルバスシーケンサ データ転送完了フラグ セット
				LOCAL_NEXT_STATE := LOCAL_STATE_COMP;

			else					-- ATAデバイスウェイト要求中
				LOCAL_NEXT_STATE := LOCAL_ATA_ACCESS;
			end if;


	-- ********** LOCAL_CFG_ACCESS時の動作 ********** --
		when LOCAL_CFG_ACCESS =>	-- コンフィグレーションサイクル

			if (PCI_BusCommand(0) = '1' ) then	-- コンフィグレーションライトサイクル

				case PCI_Address(7 downto 2) is

					when "000001" =>	-- コマンドレジスタ メモリイネーブル
						if (C_nBE(0) = '0') then
							CFG_Cmd_Io  <= PCIAD(0);
						end if;

					when "000100" =>	-- ベースアドレスレジスタ0
						if (C_nBE(1) = '0') then
							CFG_Base_Addr0(15 downto 5) <= PCIAD(15 downto 5);
						end if;

					when "001111" =>	-- 割り込みラインレジスタ
						if (C_nBE(0) = '0') then
							CFG_Int_Line(7 downto 0) <= PCIAD(7 downto 0);
						end if;

					when "010000" =>	-- +40h PIO転送モードレジスタ
						if (C_nBE(0) = '0') then
							PIO_Mode  <= PCIAD(2 downto 0);
						end if;

					when others => null;	-- これ以外の値では何もしない場合でも必ず入れる

				end case;


			else	-- コンフィグレーションリードサイクル

				case PCI_Address(7 downto 2) is

					when "000000" =>	-- ベンダID/デバイスID
						PCIAD_Port(31 downto 16) <= CFG_DeviceID;
						PCIAD_Port(15 downto  0) <= CFG_VendorID;

					when "000001" =>	-- コマンド/ステータスレジスタ
						PCIAD_Port(31 downto 16) <= CFG_Status;
						PCIAD_Port(15 downto  2) <= CFG_Command(15 downto 2);
						PCIAD_Port(1)			<= '0';
						PCIAD_Port(0)			<= CFG_Cmd_Io;

					when "000010" =>	-- クラスコード
						PCIAD_Port(31 downto 24) <= CFG_BaseClass;
						PCIAD_Port(23 downto 16) <= CFG_SubClass;
						PCIAD_Port(15 downto  8) <= CFG_ProgramIF;
						PCIAD_Port( 7 downto  0) <= CFG_RevisionID;

					when "000011" =>	-- ヘッダタイプほか
						PCIAD_Port(31 downto 24) <= (others => '0');
						PCIAD_Port(23 downto 16) <= CFG_HeaderType;
						PCIAD_Port(15 downto  0) <= (others => '0');

					when "000100" =>	-- ベースアドレスレジスタ0
						PCIAD_Port(31 downto 16) <= (others => '0');
						PCIAD_Port(15 downto  5) <= CFG_Base_Addr0;
						PCIAD_Port( 4 downto  0) <= "00001";

					when "001011" =>	-- サブベンダID/サブデバイスID
						PCIAD_Port(31 downto 16) <= CFG_SubDeviceID;
						PCIAD_Port(15 downto  0) <= CFG_SubVendorID;

					when "001111" =>	-- 割り込み関連レジスタ
						PCIAD_Port(31 downto 16) <= (others => '0');
						PCIAD_Port(15 downto  8) <= CFG_Int_Pin;
						PCIAD_Port( 7 downto  0) <= CFG_Int_Line;

					when "010000" =>	-- +40h PIO転送モードレジスタ
						PCIAD_Port(31 downto  3) <= (others => '0');
						PCIAD_Port( 2 downto  0) <= PIO_Mode;	

					when others => -- その他のレジスタ
						PCIAD_Port <= (others => '0');	-- すべて0を返す

				end case;

			end if;

			LOCAL_DTACK <= '1' ;	-- ローカルバスシーケンサ データ転送完了フラグ セット
			LOCAL_NEXT_STATE := LOCAL_STATE_COMP;


	-- ********** LOCAL_400n_WAIT時の動作 ********** --
		when LOCAL_400n_WAIT =>		-- 400ns ウェイトステート

			-- 400ns/30ns=13.33.. → 14クロック
			-- PCI側シーケンサで前後6クロックのウェイトが入るのでローカルバスステートでは 8クロック
			-- IDLEステートとSTATE_COMPステートがあるので このステートでは 6クロックウェイト
			if (WAIT_Count = "0110") then	-- 最終ウェイト
				PCIAD_Port(31 downto 16) <= CFG_DeviceID;	-- ライトサイクル時は無視
				PCIAD_Port(15 downto  0) <= CFG_VendorID;	-- リードサイクル時はベンダIDとデバイスIDを返す
				LOCAL_DTACK <= '1' ;	-- ローカルバスシーケンサ データ転送完了フラグ セット
				LOCAL_NEXT_STATE := LOCAL_STATE_COMP;
			else
				WAIT_Count := WAIT_Count + 1;	-- ウェイトカウンタ+1
				LOCAL_NEXT_STATE := LOCAL_400n_WAIT;
			end if;


	-- ********** LOCAL_STATE_COMP時の動作 ********** --
		when LOCAL_STATE_COMP =>	-- ローカルバスアクセス完了

			WAIT_Count := (others => '0');
			CS0n   <= '1';
			CS1n   <= '1';
			DD_HiZ <= '0';	-- ATAデータバスドライブ開始

			LOCAL_DTACK <= '0';		-- ローカルバスシーケンサ データ転送完了フラグ クリア
			LOCAL_NEXT_STATE := LOCAL_IDLE;


	-- ********************************************** --
		when others =>	-- シーケンサがおかしくなったときの復帰処理
			DIORn	<= '1';
			DIOWn	<= '1';
			LOCAL_NEXT_STATE := LOCAL_STATE_COMP;

		end case;

	end if;

end process LOCAL_BUS_Seq ;





-- ************************************************************************* --
-- **********	アドレスデコーダ
-- ************************************************************************* --

-- メモリサイクルorコンフィグレーションサイクルヒット = 自分が選択されている
Hit_Device <= Hit_Config or Hit_Io;

Address_Decoder : process (
				PCI_IDSEL,		-- コンフィグレーションデバイスセレクト
				PCI_Address,	-- PCIバスアドレス
				PCI_BusCommand,	-- バスコマンド
				CFG_Base_Addr0,	-- ベースアドレスレジスタ0
				CFG_Cmd_Io		-- コンフィグレーションレジスタ I/Oイネーブルビット
				)
begin

	-- I/O空間へのアクセスアドレスとベースアドレス1が一致したか
	if (
			PCI_BusCommand(3 downto 1) = PCI_IoCycle	-- I/Oサイクル
		) and (
			CFG_Cmd_Io = '1' -- コンフィグレーション コマンドレジスタ I/Oイネーブルビット
		) and (
			PCI_Address(31 downto 16) = X"0000"		-- 上位16ビットが0か
		) and (
			PCI_Address(15 downto 5 ) = CFG_Base_Addr0(15 downto 5)
		)
	then
		Hit_Io <= '1';	-- I/Oサイクルヒット
	else
		Hit_Io <= '0';
	end if;

	-- コンフィグレーション空間へのアクセスかどうかを認識
	if (
			PCI_BusCommand(3 downto 1) = PCI_CfgCycle	-- コンフィグレーションサイクル
		) and (
			PCI_IDSEL = '1'		-- 自分が選択されているか
		) and (
			PCI_Address(10 downto 8) = "000"	-- ファンクション番号0のみ
		) and (
			PCI_Address(1 downto 0) = "00"		-- タイプ0のみ
		)
	then
		Hit_Config <= '1';	-- コンフィグレーションサイクルヒット
	else
		Hit_Config <= '0';
	end if;

end process Address_Decoder;



-- ************************************************************************* --
-- **********	パリティジェネレータ
-- ************************************************************************* --

PCI_Parity_Gen : process ( PCIAD_Port, C_nBE )
	variable temp : std_logic_vector(5 downto 0);	-- テンポラリ
begin
	-- 中間パリティ生成 --
	temp(0) := PCIAD_Port(31) xor PCIAD_Port(30) xor PCIAD_Port(29) xor PCIAD_Port(28) xor PCIAD_Port(27) xor PCIAD_Port(26);
	temp(1) := PCIAD_Port(25) xor PCIAD_Port(24) xor PCIAD_Port(23) xor PCIAD_Port(22) xor PCIAD_Port(21) xor PCIAD_Port(20);
	temp(2) := PCIAD_Port(19) xor PCIAD_Port(18) xor PCIAD_Port(17) xor PCIAD_Port(16) xor PCIAD_Port(15) xor PCIAD_Port(14);
	temp(3) := PCIAD_Port(13) xor PCIAD_Port(12) xor PCIAD_Port(11) xor PCIAD_Port(10) xor PCIAD_Port(9)  xor PCIAD_Port(8);
	temp(4) := PCIAD_Port(7)  xor PCIAD_Port(6)  xor PCIAD_Port(5)  xor PCIAD_Port(4)  xor PCIAD_Port(3)  xor PCIAD_Port(2);
	temp(5) := PCIAD_Port(1)  xor PCIAD_Port(0)  xor C_nBE(3) xor C_nBE(2) xor C_nBE(1) xor C_nBE(0);
	-- パリティ生成 --
	PAR_Port <= temp(0) xor temp(1) xor temp(2) xor temp(3) xor temp(4) xor temp(5);
end process PCI_Parity_Gen ;

end RTL;

-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo         : Pixel_Generator
-- Funcionalidad  : Controlador del VGA.                                         
-- Fecha          : D:21 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY Pixel_Generator IS

	GENERIC(	Max		:	INTEGER:= 10;
				PIXEL 	: 	INTEGER:= 12;
				PAC_Q 	:  INTEGER:= 20;
				ADDR_PAC	:  INTEGER:= 5); 
		PORT(	
		      clk 		 : IN	 STD_LOGIC;
				rst       : IN  STD_LOGIC;
				Start     : IN  STD_LOGIC;
            pixel_x   : IN  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
				pixel_Y   : IN  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
				Pacmanx	 : IN  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
				Pacmany	 : IN  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
				Ghost_x_IN	 : IN  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
				Ghost_y_IN	 : IN  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
            RGB       : OUT STD_LOGIC_VECTOR(PIXEL-1 DOWNTO 0);
			   Score_Pac :	OUT STD_LOGIC_VECTOR(12 DOWNTO 0)
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF Pixel_Generator IS

	SIGNAL  adr_pacman_R	 : STD_LOGIC_VECTOR(ADDR_PAC-1 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_pacman_R1 : INTEGER:=0;
   SIGNAL  pacman_R	 	 : STD_LOGIC_VECTOR(0 TO PAC_Q-1 ):=(OTHERS => '0');
	SIGNAL  pacman_R1	 	 : INTEGER:=0;
	SIGNAL  adr_pacman_G	 : STD_LOGIC_VECTOR(ADDR_PAC-1 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_pacman_G1 : INTEGER:=0;
   SIGNAL  pacman_G	 	 : STD_LOGIC_VECTOR(0 TO PAC_Q-1 ):=(OTHERS => '0');
	SIGNAL  pacman_G1	 	 : INTEGER:=0;
	-----------------------------------------------------------------------------------
	SIGNAL  adr_cookies_R : STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_cookies_R1: INTEGER:=0;
   SIGNAL  cookies_R	 	 : STD_LOGIC_VECTOR(0 TO 15):=(OTHERS => '0');
	SIGNAL  cookies_R1	 : INTEGER:=0;
	SIGNAL  adr_cookies_G : STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_cookies_G1: INTEGER:=0;
   SIGNAL  cookies_G	 	 : STD_LOGIC_VECTOR(0 TO  15):=(OTHERS => '0');
	SIGNAL  cookies_G1	 : INTEGER:=0;
	SIGNAL  q_galleta		 : STD_LOGIC_VECTOR(0 TO 15):=(OTHERS => '0');
	--------------------------------------------------------------------------------
	SIGNAL  adr_Block_B	 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL  adr_Block_B1  : INTEGER;
   SIGNAL  Block_B	 	 : STD_LOGIC_VECTOR(0 TO 255);
	SIGNAL  Block_B1	 	 : INTEGER;
   SIGNAL  Block_B_L	 	 : STD_LOGIC_VECTOR(255 DOWNTO 0);
	SIGNAL  Block_B1_L	 : INTEGER;
	--------------------------------------------------------------------------------
	SIGNAL  adr_EndGame	 : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL  adr_EndGame1  : INTEGER;
   SIGNAL  End_GameMe	 : STD_LOGIC_VECTOR(0 TO 239);
	SIGNAL  End_GameMe1	 : INTEGER;
 
	-------------------------------------------------------------------------------
	SIGNAL  adr_Ghost_R	 : STD_LOGIC_VECTOR(4 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_Ghost_R1 : INTEGER:=0;
	SIGNAL  adr_Ghost_G	 : STD_LOGIC_VECTOR(4 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_Ghost_G1  : INTEGER:=0;
	SIGNAL  adr_Ghost_B	 : STD_LOGIC_VECTOR(4 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_Ghost_B1  : INTEGER:=0;
   SIGNAL  Ghost_R	 	 : STD_LOGIC_VECTOR(19 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  Ghost_R1	 	 : INTEGER:=0;
   SIGNAL  Ghost_B	 	 : STD_LOGIC_VECTOR(19 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  Ghost_B1	 	 : INTEGER:=0;
	SIGNAL  Ghost_G	 	 : STD_LOGIC_VECTOR(19 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  Ghost_G1	 	 : INTEGER:=0;

	-------------------------------------------------------------------------------
	SIGNAL  adr_welcome_R	 : STD_LOGIC_VECTOR(7 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_welcome_R1   : INTEGER:=0;
	SIGNAL  adr_welcome_G	 : STD_LOGIC_VECTOR(7 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_welcome_G1   : INTEGER:=0;
	SIGNAL  adr_welcome_B	 : STD_LOGIC_VECTOR(7 DOWNTO 0):=(OTHERS => '0');
	SIGNAL  adr_welcome_B1   : INTEGER:=0;
   SIGNAL  Welcome_R	 	    : STD_LOGIC_VECTOR(0 TO 323):=(OTHERS => '0');
	SIGNAL  Welcome_R1	 	 : INTEGER:=0;
   SIGNAL  Welcome_B	    	 : STD_LOGIC_VECTOR(0 TO 323):=(OTHERS => '0');
	SIGNAL  Welcome_B1	 	 : INTEGER:=0;
	SIGNAL  Welcome_G	 	    : STD_LOGIC_VECTOR(0 TO 323):=(OTHERS => '0');
	SIGNAL  Welcome_G1	 	 : INTEGER:=0;
	---------------------------------------------------------------------------
	SIGNAL    pixel_x_s1	    : INTEGER;
	SIGNAL    pixel_y_s1	    : INTEGER;
	SIGNAL    anclaPacx	 	 : INTEGER;
	SIGNAL    anclaPacy		 : INTEGER;
	
	SIGNAL  anclaGhostx 	 : INTEGER;
	SIGNAL  anclaGhosty 	 : INTEGER;
	
	CONSTANT  anclaBlockx	 : INTEGER:= 20;
	CONSTANT  anclaBlocky	 : INTEGER:= 1;
	
   CONSTANT  anclaBlocky_L	 : INTEGER:= 1;
	CONSTANT  anclaBlockx_L	 : INTEGER:= 350;

	CONSTANT  anclaWelcomex 	 : INTEGER:= 158;
	CONSTANT  anclaWelcomey	    : INTEGER:= 140;
	
	CONSTANT  anclaEndGamex 	 : INTEGER:= 200;
	CONSTANT  anclaEndGamey	    : INTEGER:= 222;
	----------------------------------------------------------------------
	----------------------------------------------------------------------
	--LADO IZQUIERDO
	CONSTANT  anclaCookiex_1, anclaCookiex_3, anclaCookiex_5,anclaCookiex_9, anclaCookiex_12,
             anclaCookiex_15,  anclaCookiex_19, anclaCookiex_22,
				 anclaCookiex_28, anclaCookiex_29, anclaCookiex_30 : INTEGER:= 23+20;
				 
	CONSTANT  anclaCookiex_2, anclaCookiex_4, anclaCookiex_6,anclaCookiex_18,anclaCookiex_23, anclaCookiex_31: INTEGER:= 63+20;
	
	CONSTANT  anclaCookiex_7, anclaCookiex_10, anclaCookiex_13,anclaCookiex_16  : INTEGER:= 116+20;
	
	CONSTANT  anclaCookiex_8, anclaCookiex_11, anclaCookiex_14,anclaCookiex_17 : INTEGER:= 156+20;
	
	CONSTANT  anclaCookiex_24, anclaCookiex_32, anclaCookiex_36  : INTEGER:= 103+20;
	
	CONSTANT  anclaCookiex_25, anclaCookiex_33, anclaCookiex_37 : INTEGER:= 143+20;
	
	CONSTANT  anclaCookiex_20,anclaCookiex_26, anclaCookiex_34, anclaCookiex_38 : INTEGER:= 183+20;
	
	CONSTANT  anclaCookiex_21,anclaCookiex_27, anclaCookiex_35, anclaCookiex_39 : INTEGER:= 223+20;
	
	CONSTANT  anclaCookiex_40, anclaCookiex_63, anclaCookiex_65, anclaCookiex_79 : INTEGER:= 20+350;
	
	CONSTANT  anclaCookiex_41,anclaCookiex_64, anclaCookiex_66,anclaCookiex_78: INTEGER:= 60+350;
	
	CONSTANT  anclaCookiex_42,anclaCookiex_50, anclaCookiex_54, anclaCookiex_57,
	          anclaCookiex_60, anclaCookiex_67, anclaCookiex_77: INTEGER:= 100+350;
	
	CONSTANT  anclaCookiex_43,anclaCookiex_51, anclaCookiex_55, anclaCookiex_58,
	          anclaCookiex_61, anclaCookiex_68, anclaCookiex_76: INTEGER:= 140+350;
	
	CONSTANT  anclaCookiex_44,anclaCookiex_46 ,anclaCookiex_48, anclaCookiex_52,
	          anclaCookiex_69, anclaCookiex_75: INTEGER:= 180+350;
	
	CONSTANT  anclaCookiex_45,anclaCookiex_47 ,anclaCookiex_49, anclaCookiex_53,
	          anclaCookiex_56, anclaCookiex_59, anclaCookiex_62, anclaCookiex_71,
				 anclaCookiex_70, anclaCookiex_72,anclaCookiex_73,anclaCookiex_74: INTEGER:= 220+350;

	
	---------------------
	
	CONSTANT  anclaCookiey_1, anclaCookiey_2, anclaCookiey_46, anclaCookiey_47 	 : INTEGER:= 57+1;

	CONSTANT  anclaCookiey_3, anclaCookiey_4, anclaCookiey_48, anclaCookiey_49	 : INTEGER:= 97+1;
	
	CONSTANT  anclaCookiey_5,anclaCookiey_6,anclaCookiey_7,anclaCookiey_8,
             anclaCookiey_50, anclaCookiey_51, anclaCookiey_52, anclaCookiey_53	: INTEGER:= 137+1;
	
	CONSTANT  anclaCookiey_9,anclaCookiey_10,anclaCookiey_11, anclaCookiey_54,
             anclaCookiey_55, anclaCookiey_56	: INTEGER:= 177+1;
	
	CONSTANT  anclaCookiey_12,anclaCookiey_13,anclaCookiey_14, anclaCookiey_57, anclaCookiey_58,
             anclaCookiey_59	: INTEGER:= 217+1;
	
	CONSTANT  anclaCookiey_15,anclaCookiey_16,anclaCookiey_17, anclaCookiey_60, anclaCookiey_61,
             anclaCookiey_62	: INTEGER:= 257+1;
	
	CONSTANT  anclaCookiey_18, anclaCookiey_36,anclaCookiey_37,anclaCookiey_38,anclaCookiey_39, 
	          anclaCookiey_40, anclaCookiey_41, anclaCookiey_42, anclaCookiey_43, anclaCookiey_44,
				 anclaCookiey_45: INTEGER:= 19+1;
	
	CONSTANT  anclaCookiey_19, anclaCookiey_71: INTEGER:= 297+1;
	
	CONSTANT  anclaCookiey_20, anclaCookiey_21, anclaCookiey_63, anclaCookiey_64: INTEGER:= 295+1;
	
	CONSTANT  anclaCookiey_22,anclaCookiey_23,anclaCookiey_24,anclaCookiey_25,anclaCookiey_26, 
	          anclaCookiey_27, anclaCookiey_65, anclaCookiey_66, anclaCookiey_67,
				 anclaCookiey_68, anclaCookiey_69, anclaCookiey_70: INTEGER:= 337+1;
	
	CONSTANT  anclaCookiey_28, anclaCookiey_72: INTEGER:= 377+1;
	
	CONSTANT  anclaCookiey_29, anclaCookiey_73: INTEGER:= 409+1;
	
	CONSTANT  anclaCookiey_30,anclaCookiey_31,anclaCookiey_32,anclaCookiey_33,anclaCookiey_34,
	          anclaCookiey_35, anclaCookiey_74, anclaCookiey_75, anclaCookiey_76, 
				 anclaCookiey_77, anclaCookiey_78, anclaCookiey_79: INTEGER:= 444+1;
	
	
	--CENTRO
	
	CONSTANT  anclaCookiey_80,anclaCookiey_81: INTEGER:= 437;
	CONSTANT  anclaCookiey_82,anclaCookiey_83: INTEGER:= 384;
	CONSTANT  anclaCookiey_84,anclaCookiey_85: INTEGER:= 340;
	CONSTANT  anclaCookiey_86,anclaCookiey_87: INTEGER:= 296;
	CONSTANT  anclaCookiey_88,anclaCookiey_89: INTEGER:= 250;
	CONSTANT  anclaCookiey_90,anclaCookiey_91: INTEGER:= 205;
	CONSTANT  anclaCookiey_92,anclaCookiey_93: INTEGER:= 156;
	CONSTANT  anclaCookiey_94,anclaCookiey_95: INTEGER:= 113;
	CONSTANT  anclaCookiey_96,anclaCookiey_97: INTEGER:= 72;
	CONSTANT  anclaCookiey_98,anclaCookiey_99,anclaCookiey_100: INTEGER:= 27;
	

	CONSTANT  anclaCookiex_80,anclaCookiex_82,anclaCookiex_84,anclaCookiex_86,
	          anclaCookiex_88, anclaCookiex_90, anclaCookiex_92, anclaCookiex_94,
				 anclaCookiex_96, anclaCookiex_98: INTEGER:= 289;
				
	CONSTANT  anclaCookiex_81,anclaCookiex_83,anclaCookiex_85,anclaCookiex_87,
	          anclaCookiex_89, anclaCookiex_91, anclaCookiex_93, anclaCookiex_95,
				 anclaCookiex_97, anclaCookiex_99,anclaCookiex_100: INTEGER:= 326;
				 
				 
	----------------------------------------------------------------------
	SIGNAL 	 PrioriImg	    : INTEGER := 0;
	SIGNAL 	 Personajes	    : INTEGER := 0;
	SIGNAL    Inicio_screen  : INTEGER := 0;
	SIGNAL    Fin_screen     : INTEGER := 0;
	-----------------------------------------------------------------------
	
	SIGNAL    Invisible_G1,Invisible_G2,Invisible_G3,Invisible_G4,Invisible_G5,
	          Invisible_G6,Invisible_G7,Invisible_G8,Invisible_G9,Invisible_G10,
				 Invisible_G11,Invisible_G12,Invisible_G13,Invisible_G14,Invisible_G15,
				 Invisible_G16,Invisible_G17,Invisible_G18,Invisible_G19,Invisible_G20,
				 Invisible_G21,Invisible_G22,Invisible_G23,Invisible_G24,Invisible_G25,
				 Invisible_G26,Invisible_G27,Invisible_G28,Invisible_G29,Invisible_G30,
				 Invisible_G31,Invisible_G32,Invisible_G33,Invisible_G34,Invisible_G35,
				 Invisible_G36,Invisible_G37,Invisible_G38,Invisible_G39,Invisible_G40,
             Invisible_G41,Invisible_G42,Invisible_G43,Invisible_G44,Invisible_G45,
				 Invisible_G46,Invisible_G47,Invisible_G48,Invisible_G49,Invisible_G50,
				 Invisible_G51,Invisible_G52,Invisible_G53,Invisible_G54,Invisible_G55,
				 Invisible_G56,Invisible_G57,Invisible_G58,Invisible_G59,Invisible_G60,
				 Invisible_G61,Invisible_G62,Invisible_G63,Invisible_G64,Invisible_G65,
				 Invisible_G66,Invisible_G67,Invisible_G68,Invisible_G69,Invisible_G70,
				 Invisible_G71,Invisible_G72,Invisible_G73,Invisible_G74,Invisible_G75,
             Invisible_G76,Invisible_G77,Invisible_G78,Invisible_G79,Invisible_G80,
				 Invisible_G81,Invisible_G82,Invisible_G83,Invisible_G84,Invisible_G85,
				 Invisible_G86,Invisible_G87,Invisible_G88,Invisible_G89,Invisible_G90,
				 Invisible_G91,Invisible_G92,Invisible_G93,Invisible_G94,Invisible_G95,
				 Invisible_G96,Invisible_G97,Invisible_G98,Invisible_G99,Invisible_G100 : STD_LOGIC:= '0';
				 
	SIGNAL    Count_G1,Count_G2,Count_G3,Count_G4,Count_G5,
	          Count_G6,Count_G7,Count_G8,Count_G9,Count_G10,
				 Count_G11,Count_G12,Count_G13,Count_G14,Count_G15,
				 Count_G16,Count_G17,Count_G18,Count_G19,Count_G20,
				 Count_G21,Count_G22,Count_G23,Count_G24,Count_G25,
				 Count_G26,Count_G27,Count_G28,Count_G29,Count_G30,
				 Count_G31,Count_G32,Count_G33,Count_G34,Count_G35,
				 Count_G36,Count_G37,Count_G38,Count_G39,Count_G40,
             Count_G41,Count_G42,Count_G43,Count_G44,Count_G45,
				 Count_G46,Count_G47,Count_G48,Count_G49,Count_G50,
				 Count_G51,Count_G52,Count_G53,Count_G54,Count_G55,
				 Count_G56,Count_G57,Count_G58,Count_G59,Count_G60,
				 Count_G61,Count_G62,Count_G63,Count_G64,Count_G65,
				 Count_G66,Count_G67,Count_G68,Count_G69,Count_G70,
				 Count_G71,Count_G72,Count_G73,Count_G74,Count_G75,
             Count_G76,Count_G77,Count_G78,Count_G79,Count_G80,
				 Count_G81,Count_G82,Count_G83,Count_G84,Count_G85,
				 Count_G86,Count_G87,Count_G88,Count_G89,Count_G90,
				 Count_G91,Count_G92,Count_G93,Count_G94,Count_G95,
				 Count_G96,Count_G97,Count_G98,Count_G99,Count_G100 : INTEGER := 0;
				 
	SIGNAL    Count_Start    : INTEGER :=0;
	SIGNAL    Start_signal   : STD_LOGIC := '0';
	
	SIGNAL    Score_temp        : STD_LOGIC;
	SIGNAL    Score             : STD_LOGIC_VECTOR(12 DOWNTO 0):= (OTHERS => '0');
	
	SIGNAL    Count_End_Game    : INTEGER :=0;
	SIGNAL    End_Game          : STD_LOGIC:= '0';
	
	
BEGIN

   Block_B_L <= Block_B;

	-----------------------------------------------------------------------------
	Pacman_Rojo:ENTITY WORK.Pacman_Red 
		PORT MAP(
			address => adr_pacman_R,
			clock	  => clk,
			q		  => pacman_R
		);

	-----------------------------------------------------------------------------
	Pacman_Verde:ENTITY WORK.Pacman_Red 
		PORT MAP(
			address => adr_pacman_G,
			clock	  => clk,
			q		  => pacman_G
		);
	-----------------------------------------------------------------------------
	Laberinto:ENTITY WORK.C_Right_Blue
		PORT MAP(
			address => adr_Block_B,
			clock	  => clk,
			q		  => Block_B
		);
	-----------------------------------------------------------------------------
	FantasmaR:ENTITY WORK.GhostRed
		PORT MAP(
			address => adr_Ghost_R,
			clock	  => clk,
			q		  => Ghost_R
		);

	-----------------------------------------------------------------------------
	FantasmaB:ENTITY WORK.GhostBlue
		PORT MAP(
			address => adr_Ghost_B,
			clock	  => clk,
			q		  => Ghost_B
		);	
   -----------------------------------------------------------------------------
	FantasmaG:ENTITY WORK.GhostGreen
		PORT MAP(
			address => adr_Ghost_G,
			clock	  => clk,
			q		  => Ghost_G
		);	
	----------------------------------------------------------------------------
	-----------------------------------------------------------------------------
	GalletaR:ENTITY WORK.Cookies_R
		PORT MAP(
			address => adr_cookies_R,
			clock	  => clk,
			q		  => Cookies_R
		);	
	-----------------------------------------------------------------------------
	GalletaG:ENTITY WORK.Cookies_GB
		PORT MAP(
			address => adr_cookies_G,
			clock	  => clk,
			q		  => Cookies_G
		);	
   ----------------------------------------------------------------------------
	-----------------------------------------------------------------------------
	Welcome_Red:ENTITY WORK.Welcome_R
		PORT MAP(
			address => adr_welcome_R,
			clock	  => clk,
			q		  => Welcome_R
		);	
	-----------------------------------------------------------------------------
	Welcome_GR:ENTITY WORK.Welcome_G
		PORT MAP(
			address => adr_welcome_G,
			clock	  => clk,
			q		  => Welcome_G
		);	
	-----------------------------------------------------------------------------
	Welcome_Blue:ENTITY WORK.Welcome_B
		PORT MAP(
			address => adr_welcome_B,
			clock	  => clk,
			q		  => Welcome_B
		);	
	-----------------------------------------------------------------------------
	EGMem:ENTITY WORK.Game_Over_Mem
		PORT MAP(
			address => adr_EndGame,
			clock	  => clk,
			q		  => End_GameMe
		);	
	-----------------------------------------------------------------------------
	--==========================================================================
	-- Output Logic
	--==========================================================================
	pixel_x_s1   <= TO_INTEGER(UNSIGNED(pixel_x));
	pixel_y_s1 	 <= TO_INTEGER(UNSIGNED(pixel_y));
	AnclaPacx    <= TO_INTEGER(UNSIGNED(Pacmanx));
	AnclaPacy 	 <= TO_INTEGER(UNSIGNED(Pacmany));
	
	anclaGhostx  <= TO_INTEGER(UNSIGNED(Ghost_x_IN));
	anclaGhosty  <= TO_INTEGER(UNSIGNED(Ghost_y_IN));
	
	adr_pacman_R <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_pacman_R1,ADDR_PAC));
	adr_pacman_G <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_pacman_G1,ADDR_PAC));
	
	adr_Block_B   <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Block_B1,9));
	adr_EndGame   <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_EndGame1,6));
	
	adr_Ghost_R <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Ghost_R1,5));
	adr_Ghost_B <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Ghost_B1,5));
	adr_Ghost_G <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Ghost_G1,5));
	
	adr_Cookies_R <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Cookies_R1,4));
	adr_Cookies_G <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Cookies_G1,4));
	
	adr_Welcome_R <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Welcome_R1,8));
	adr_Welcome_G <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Welcome_G1,8));
	adr_Welcome_B <= STD_LOGIC_VECTOR(TO_UNSIGNED(adr_Welcome_B1,8));
	-----------------------------------------------------------------------------
	--==========================================================================
	--  Start Logic
	--==========================================================================
	Start_signal <= '1'   WHEN (Start='1' AND Count_Start=0) ELSE
					    '1'   WHEN Count_Start=1 ELSE
                   '0';
	
   Bottom_Start: PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			Count_Start <= 0;
		ELSIF (rising_edge(clk)) THEN
			IF (Count_Start = 0 AND Start_signal = '1') THEN
				Count_Start <= 1;
			ELSIF(Count_Start = 1) THEN
			   Count_Start <= Count_Start;
		   END IF;
	   END IF;

	END PROCESS Bottom_Start;	
	
	-----------------------------------------------------------------------------
	--==========================================================================
	--  Cookies Logic
	--==========================================================================
	invisible_G1 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_1-20) AND (AnclaPacx < (anclaCookiex_1 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_1-20)  AND  (AnclaPacy < (anclaCookiey_1 + (22) )))) AND Count_G1=0) ELSE
					    '1'   WHEN Count_G1=1 ELSE
                   '0';
					 
	invisible_G2 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_2-20) AND (AnclaPacx < (anclaCookiex_2 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_2-20)  AND  (AnclaPacy < (anclaCookiey_2 + (22) )))) AND Count_G2=0) ELSE
					    '1'   WHEN Count_G2=1 ELSE
                   '0';
	
	invisible_G3 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_3-20) AND (AnclaPacx < (anclaCookiex_3 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_3-20)  AND  (AnclaPacy < (anclaCookiey_3 + (22) )))) AND Count_G3=0) ELSE
					    '1'   WHEN Count_G3=1 ELSE
                   '0';
						 
	invisible_G4 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_4-20) AND (AnclaPacx < (anclaCookiex_4 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_4-20)  AND  (AnclaPacy < (anclaCookiey_4 + (22) )))) AND Count_G4=0) ELSE
					    '1'   WHEN Count_G4=1 ELSE
                   '0';
						 
	invisible_G5 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_5-20) AND (AnclaPacx < (anclaCookiex_5 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_5-20)  AND  (AnclaPacy < (anclaCookiey_5 + (22) )))) AND Count_G5=0) ELSE
					    '1'   WHEN Count_G5=1 ELSE
                   '0';		

	invisible_G6 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_6-20) AND (AnclaPacx < (anclaCookiex_6 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_6-20)  AND  (AnclaPacy < (anclaCookiey_6 + (22) )))) AND Count_G6=0) ELSE
					    '1'   WHEN Count_G6=1 ELSE
                   '0';		
	
   invisible_G7 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_7-20) AND (AnclaPacx < (anclaCookiex_7 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_7-20)  AND  (AnclaPacy < (anclaCookiey_7 + (22) )))) AND Count_G7=0) ELSE
					    '1'   WHEN Count_G7=1 ELSE
                   '0';		
	
   invisible_G8 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_8-20) AND (AnclaPacx < (anclaCookiex_8 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_8-20)  AND  (AnclaPacy < (anclaCookiey_8 + (22) )))) AND Count_G8=0) ELSE
					    '1'   WHEN Count_G8=1 ELSE
                   '0';		
						
	invisible_G9 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_9-20) AND (AnclaPacx < (anclaCookiex_9 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_9-20)  AND  (AnclaPacy < (anclaCookiey_9 + (22) )))) AND Count_G9=0) ELSE
					    '1'   WHEN Count_G9=1 ELSE
                   '0';		
						
					
	invisible_G10 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_10-20) AND (AnclaPacx < (anclaCookiex_10 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_10-20)  AND  (AnclaPacy < (anclaCookiey_10 + (22) )))) AND Count_G10=0) ELSE
					    '1'   WHEN Count_G10=1 ELSE
                   '0';	
   
   invisible_G11 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_11-20) AND (AnclaPacx < (anclaCookiex_11 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_11-20)  AND  (AnclaPacy < (anclaCookiey_11 + (22) )))) AND Count_G11=0) ELSE
					    '1'   WHEN Count_G11=1 ELSE
                   '0';		
	
	invisible_G12 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_12-20) AND (AnclaPacx < (anclaCookiex_12 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_12-20)  AND  (AnclaPacy < (anclaCookiey_12 + (22) )))) AND Count_G12=0) ELSE
					    '1'   WHEN Count_G12=1 ELSE
                   '0';		
						 
	invisible_G13 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_13-20) AND (AnclaPacx < (anclaCookiex_13 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_13-20)  AND  (AnclaPacy < (anclaCookiey_13 + (22) )))) AND Count_G13=0) ELSE
					    '1'   WHEN Count_G13=1 ELSE
                   '0';	
						 
	invisible_G14 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_14-20) AND (AnclaPacx < (anclaCookiex_14 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_14-20)  AND  (AnclaPacy < (anclaCookiey_14 + (22) )))) AND Count_G14=0) ELSE
					    '1'   WHEN Count_G14=1 ELSE
                   '0'; 
	
   invisible_G15 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_15-20) AND (AnclaPacx < (anclaCookiex_15 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_15-20)  AND  (AnclaPacy < (anclaCookiey_15 + (22) )))) AND Count_G15=0) ELSE
					    '1'   WHEN Count_G15=1 ELSE
                   '0';
	invisible_G16 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_16-20) AND (AnclaPacx < (anclaCookiex_16 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_16-20)  AND  (AnclaPacy < (anclaCookiey_16 + (22) )))) AND Count_G16=0) ELSE
					    '1'   WHEN Count_G16=1 ELSE
                   '0';

	invisible_G17 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_17-20) AND (AnclaPacx < (anclaCookiex_17 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_17-20)  AND  (AnclaPacy < (anclaCookiey_17 + (22) )))) AND Count_G17=0) ELSE
					    '1'   WHEN Count_G17=1 ELSE
                   '0';
	
	invisible_G18 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_18-20) AND (AnclaPacx < (anclaCookiex_18 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_18-20)  AND  (AnclaPacy < (anclaCookiey_18 + (22) )))) AND Count_G18=0) ELSE
					    '1'   WHEN Count_G18=1 ELSE
                   '0';
						 
	invisible_G19 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_19-20) AND (AnclaPacx < (anclaCookiex_19 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_19-20)  AND  (AnclaPacy < (anclaCookiey_19 + (22) )))) AND Count_G19=0) ELSE
					    '1'   WHEN Count_G19=1 ELSE
                   '0';
						 
	invisible_G20 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_20-20) AND (AnclaPacx < (anclaCookiex_20 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_20-20)  AND  (AnclaPacy < (anclaCookiey_20 + (22) )))) AND Count_G20=0) ELSE
					    '1'   WHEN Count_G20=1 ELSE
                   '0';
	
	invisible_G21 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_21-20) AND (AnclaPacx < (anclaCookiex_21 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_21-20)  AND  (AnclaPacy < (anclaCookiey_21 + (22) )))) AND Count_G21=0) ELSE
					    '1'   WHEN Count_G21=1 ELSE
                   '0';
	
	invisible_G22 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_22-20) AND (AnclaPacx < (anclaCookiex_22 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_22-20)  AND  (AnclaPacy < (anclaCookiey_22 + (22) )))) AND Count_G22=0) ELSE
					    '1'   WHEN Count_G22=1 ELSE
                   '0';
	
   invisible_G23 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_23-20) AND (AnclaPacx < (anclaCookiex_23 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_23-20)  AND  (AnclaPacy < (anclaCookiey_23 + (22) )))) AND Count_G23=0) ELSE
					    '1'   WHEN Count_G23=1 ELSE
                   '0';	
						 
  invisible_G24 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_24-20) AND (AnclaPacx < (anclaCookiex_24 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_24-20)  AND  (AnclaPacy < (anclaCookiey_24 + (22) )))) AND Count_G24=0) ELSE
					    '1'   WHEN Count_G24=1 ELSE
                   '0';	
						 
	invisible_G25 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_25-20) AND (AnclaPacx < (anclaCookiex_25 + (12))) ) AND 
										 ((AnclaPacy > anclaCookiey_25-20)  AND  (AnclaPacy < (anclaCookiey_25 + (22) )))) AND Count_G25=0) ELSE
						  '1'   WHEN Count_G25=1 ELSE
						'0';	
	invisible_G26 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_26-20) AND (AnclaPacx < (anclaCookiex_26 + (12))) ) AND 
										((AnclaPacy > anclaCookiey_26-20)  AND  (AnclaPacy < (anclaCookiey_26 + (22) )))) AND Count_G26=0) ELSE
							 '1'   WHEN Count_G26=1 ELSE
							 '0';	
	invisible_G27 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_27-20) AND (AnclaPacx < (anclaCookiex_27 + (12))) ) AND 
										((AnclaPacy > anclaCookiey_27-20)  AND  (AnclaPacy < (anclaCookiey_27 + (22) )))) AND Count_G27=0) ELSE
							 '1'   WHEN Count_G27=1 ELSE
							 '0';	
	invisible_G28 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_28-20) AND (AnclaPacx < (anclaCookiex_28 + (12))) ) AND 
										((AnclaPacy > anclaCookiey_28-20)  AND  (AnclaPacy < (anclaCookiey_28 + (22) )))) AND Count_G28=0) ELSE
							 '1'   WHEN Count_G28=1 ELSE
							 '0';							 
	invisible_G29 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_29-20) AND (AnclaPacx < (anclaCookiex_29 + (12))) ) AND 
										((AnclaPacy > anclaCookiey_29-20)  AND  (AnclaPacy < (anclaCookiey_29 + (22) )))) AND Count_G29=0) ELSE
							 '1'   WHEN Count_G29=1 ELSE
							 '0';			
	invisible_G30 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_30-20) AND (AnclaPacx < (anclaCookiex_30 + (12))) ) AND 
										((AnclaPacy > anclaCookiey_30-20)  AND  (AnclaPacy < (anclaCookiey_30 + (22) )))) AND Count_G30=0) ELSE
							 '1'   WHEN Count_G30=1 ELSE
							 '0';
	
   invisible_G31 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_31-20) AND (AnclaPacx < (anclaCookiex_31 + (12))) ) AND 
										((AnclaPacy > anclaCookiey_31-20)  AND  (AnclaPacy < (anclaCookiey_31 + (22) )))) AND Count_G31=0) ELSE
							 '1'   WHEN Count_G31=1 ELSE
							 '0';				 
						 
	invisible_G32 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_32-20) AND (AnclaPacx < (anclaCookiex_32 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_32-20)  AND  (AnclaPacy < (anclaCookiey_32 + (22) )))) AND Count_G32=0) ELSE
								 '1'   WHEN Count_G32=1 ELSE
								 '0';
								 
	invisible_G33 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_33-20) AND (AnclaPacx < (anclaCookiex_33 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_33-20)  AND  (AnclaPacy < (anclaCookiey_33 + (22) )))) AND Count_G33=0) ELSE
								 '1'   WHEN Count_G33=1 ELSE
								 '0';							 

	invisible_G34 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_34-20) AND (AnclaPacx < (anclaCookiex_34 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_34-20)  AND  (AnclaPacy < (anclaCookiey_34 + (22) )))) AND Count_G34=0) ELSE
								 '1'   WHEN Count_G34=1 ELSE
								 '0';

	invisible_G35 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_35-20) AND (AnclaPacx < (anclaCookiex_35 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_35-20)  AND  (AnclaPacy < (anclaCookiey_35 + (22) )))) AND Count_G35=0) ELSE
								 '1'   WHEN Count_G35=1 ELSE
								 '0';
	invisible_G36 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_36-20) AND (AnclaPacx < (anclaCookiex_36 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_36-20)  AND  (AnclaPacy < (anclaCookiey_36 + (22) )))) AND Count_G36=0) ELSE
								 '1'   WHEN Count_G36=1 ELSE
								 '0';

	invisible_G37 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_37-20) AND (AnclaPacx < (anclaCookiex_37 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_37-20)  AND  (AnclaPacy < (anclaCookiey_37 + (22) )))) AND Count_G37=0) ELSE
								 '1'   WHEN Count_G37=1 ELSE
								 '0';
								 
	invisible_G38 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_38-20) AND (AnclaPacx < (anclaCookiex_38 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_38-20)  AND  (AnclaPacy < (anclaCookiey_38 + (22) )))) AND Count_G38=0) ELSE
								 '1'   WHEN Count_G38=1 ELSE
								 '0';	
	invisible_G39 <= '1'   WHEN ((((AnclaPacx > anclaCookiex_39-20) AND (AnclaPacx < (anclaCookiex_39 + (12))) ) AND 
											((AnclaPacy > anclaCookiey_39-20)  AND  (AnclaPacy < (anclaCookiey_39 + (22) )))) AND Count_G39=0) ELSE
								 '1'   WHEN Count_G39=1 ELSE
								 '0';		
	invisible_G40<= '1'   WHEN ((((AnclaPacx > anclaCookiex_40-20) AND (AnclaPacx < (anclaCookiex_40+ (12))) ) AND  ((AnclaPacy > anclaCookiey_40-20)  AND  (AnclaPacy < (anclaCookiey_40 + (22) )))) AND Count_G40=0) ELSE    '1'   WHEN Count_G40=1 ELSE    '0';
	invisible_G41<= '1'   WHEN ((((AnclaPacx > anclaCookiex_41-20) AND (AnclaPacx < (anclaCookiex_41+ (12))) ) AND  ((AnclaPacy > anclaCookiey_41-20)  AND  (AnclaPacy < (anclaCookiey_41 + (22) )))) AND Count_G41=0) ELSE    '1'   WHEN Count_G41=1 ELSE    '0';
	invisible_G42<= '1'   WHEN ((((AnclaPacx > anclaCookiex_42-20) AND (AnclaPacx < (anclaCookiex_42+ (12))) ) AND  ((AnclaPacy > anclaCookiey_42-20)  AND  (AnclaPacy < (anclaCookiey_42 + (22) )))) AND Count_G42=0) ELSE    '1'   WHEN Count_G42=1 ELSE    '0';
	invisible_G43<= '1'   WHEN ((((AnclaPacx > anclaCookiex_43-20) AND (AnclaPacx < (anclaCookiex_43+ (12))) ) AND  ((AnclaPacy > anclaCookiey_43-20)  AND  (AnclaPacy < (anclaCookiey_43 + (22) )))) AND Count_G43=0) ELSE    '1'   WHEN Count_G43=1 ELSE    '0';
	invisible_G44<= '1'   WHEN ((((AnclaPacx > anclaCookiex_44-20) AND (AnclaPacx < (anclaCookiex_44+ (12))) ) AND  ((AnclaPacy > anclaCookiey_44-20)  AND  (AnclaPacy < (anclaCookiey_44 + (22) )))) AND Count_G44=0) ELSE    '1'   WHEN Count_G44=1 ELSE    '0';
	invisible_G45<= '1'   WHEN ((((AnclaPacx > anclaCookiex_45-20) AND (AnclaPacx < (anclaCookiex_45+ (12))) ) AND  ((AnclaPacy > anclaCookiey_45-20)  AND  (AnclaPacy < (anclaCookiey_45 + (22) )))) AND Count_G45=0) ELSE    '1'   WHEN Count_G45=1 ELSE    '0';
	invisible_G46<= '1'   WHEN ((((AnclaPacx > anclaCookiex_46-20) AND (AnclaPacx < (anclaCookiex_46+ (12))) ) AND  ((AnclaPacy > anclaCookiey_46-20)  AND  (AnclaPacy < (anclaCookiey_46 + (22) )))) AND Count_G46=0) ELSE    '1'   WHEN Count_G46=1 ELSE    '0';
	invisible_G47<= '1'   WHEN ((((AnclaPacx > anclaCookiex_47-20) AND (AnclaPacx < (anclaCookiex_47+ (12))) ) AND  ((AnclaPacy > anclaCookiey_47-20)  AND  (AnclaPacy < (anclaCookiey_47 + (22) )))) AND Count_G47=0) ELSE    '1'   WHEN Count_G47=1 ELSE    '0';
	invisible_G48<= '1'   WHEN ((((AnclaPacx > anclaCookiex_48-20) AND (AnclaPacx < (anclaCookiex_48+ (12))) ) AND  ((AnclaPacy > anclaCookiey_48-20)  AND  (AnclaPacy < (anclaCookiey_48 + (22) )))) AND Count_G48=0) ELSE    '1'   WHEN Count_G48=1 ELSE    '0';
	invisible_G49<= '1'   WHEN ((((AnclaPacx > anclaCookiex_49-20) AND (AnclaPacx < (anclaCookiex_49+ (12))) ) AND  ((AnclaPacy > anclaCookiey_49-20)  AND  (AnclaPacy < (anclaCookiey_49 + (22) )))) AND Count_G49=0) ELSE    '1'   WHEN Count_G49=1 ELSE    '0';
	invisible_G50<= '1'   WHEN ((((AnclaPacx > anclaCookiex_50-20) AND (AnclaPacx < (anclaCookiex_50+ (12))) ) AND  ((AnclaPacy > anclaCookiey_50-20)  AND  (AnclaPacy < (anclaCookiey_50 + (22) )))) AND Count_G50=0) ELSE    '1'   WHEN Count_G50=1 ELSE    '0';
	invisible_G51<= '1'   WHEN ((((AnclaPacx > anclaCookiex_51-20) AND (AnclaPacx < (anclaCookiex_51+ (12))) ) AND  ((AnclaPacy > anclaCookiey_51-20)  AND  (AnclaPacy < (anclaCookiey_51 + (22) )))) AND Count_G51=0) ELSE    '1'   WHEN Count_G51=1 ELSE    '0';
	invisible_G52<= '1'   WHEN ((((AnclaPacx > anclaCookiex_52-20) AND (AnclaPacx < (anclaCookiex_52+ (12))) ) AND  ((AnclaPacy > anclaCookiey_52-20)  AND  (AnclaPacy < (anclaCookiey_52 + (22) )))) AND Count_G52=0) ELSE    '1'   WHEN Count_G52=1 ELSE    '0';
	invisible_G53<= '1'   WHEN ((((AnclaPacx > anclaCookiex_53-20) AND (AnclaPacx < (anclaCookiex_53+ (12))) ) AND  ((AnclaPacy > anclaCookiey_53-20)  AND  (AnclaPacy < (anclaCookiey_53 + (22) )))) AND Count_G53=0) ELSE    '1'   WHEN Count_G53=1 ELSE    '0';
	invisible_G54<= '1'   WHEN ((((AnclaPacx > anclaCookiex_54-20) AND (AnclaPacx < (anclaCookiex_54+ (12))) ) AND  ((AnclaPacy > anclaCookiey_54-20)  AND  (AnclaPacy < (anclaCookiey_54 + (22) )))) AND Count_G54=0) ELSE    '1'   WHEN Count_G54=1 ELSE    '0';
	invisible_G55<= '1'   WHEN ((((AnclaPacx > anclaCookiex_55-20) AND (AnclaPacx < (anclaCookiex_55+ (12))) ) AND  ((AnclaPacy > anclaCookiey_55-20)  AND  (AnclaPacy < (anclaCookiey_55 + (22) )))) AND Count_G55=0) ELSE    '1'   WHEN Count_G55=1 ELSE    '0';
	invisible_G56<= '1'   WHEN ((((AnclaPacx > anclaCookiex_56-20) AND (AnclaPacx < (anclaCookiex_56+ (12))) ) AND  ((AnclaPacy > anclaCookiey_56-20)  AND  (AnclaPacy < (anclaCookiey_56 + (22) )))) AND Count_G56=0) ELSE    '1'   WHEN Count_G56=1 ELSE    '0';
	invisible_G57<= '1'   WHEN ((((AnclaPacx > anclaCookiex_57-20) AND (AnclaPacx < (anclaCookiex_57+ (12))) ) AND  ((AnclaPacy > anclaCookiey_57-20)  AND  (AnclaPacy < (anclaCookiey_57 + (22) )))) AND Count_G57=0) ELSE    '1'   WHEN Count_G57=1 ELSE    '0';
	invisible_G58<= '1'   WHEN ((((AnclaPacx > anclaCookiex_58-20) AND (AnclaPacx < (anclaCookiex_58+ (12))) ) AND  ((AnclaPacy > anclaCookiey_58-20)  AND  (AnclaPacy < (anclaCookiey_58 + (22) )))) AND Count_G58=0) ELSE    '1'   WHEN Count_G58=1 ELSE    '0';
	invisible_G59<= '1'   WHEN ((((AnclaPacx > anclaCookiex_59-20) AND (AnclaPacx < (anclaCookiex_59+ (12))) ) AND  ((AnclaPacy > anclaCookiey_59-20)  AND  (AnclaPacy < (anclaCookiey_59 + (22) )))) AND Count_G59=0) ELSE    '1'   WHEN Count_G59=1 ELSE    '0';
	invisible_G60<= '1'   WHEN ((((AnclaPacx > anclaCookiex_60-20) AND (AnclaPacx < (anclaCookiex_60+ (12))) ) AND  ((AnclaPacy > anclaCookiey_60-20)  AND  (AnclaPacy < (anclaCookiey_60 + (22) )))) AND Count_G60=0) ELSE    '1'   WHEN Count_G60=1 ELSE    '0';
	invisible_G61<= '1'   WHEN ((((AnclaPacx > anclaCookiex_61-20) AND (AnclaPacx < (anclaCookiex_61+ (12))) ) AND  ((AnclaPacy > anclaCookiey_61-20)  AND  (AnclaPacy < (anclaCookiey_61 + (22) )))) AND Count_G61=0) ELSE    '1'   WHEN Count_G61=1 ELSE    '0';
	invisible_G62<= '1'   WHEN ((((AnclaPacx > anclaCookiex_62-20) AND (AnclaPacx < (anclaCookiex_62+ (12))) ) AND  ((AnclaPacy > anclaCookiey_62-20)  AND  (AnclaPacy < (anclaCookiey_62 + (22) )))) AND Count_G62=0) ELSE    '1'   WHEN Count_G62=1 ELSE    '0';
	invisible_G63<= '1'   WHEN ((((AnclaPacx > anclaCookiex_63-20) AND (AnclaPacx < (anclaCookiex_63+ (12))) ) AND  ((AnclaPacy > anclaCookiey_63-20)  AND  (AnclaPacy < (anclaCookiey_63 + (22) )))) AND Count_G63=0) ELSE    '1'   WHEN Count_G63=1 ELSE    '0';
	invisible_G64<= '1'   WHEN ((((AnclaPacx > anclaCookiex_64-20) AND (AnclaPacx < (anclaCookiex_64+ (12))) ) AND  ((AnclaPacy > anclaCookiey_64-20)  AND  (AnclaPacy < (anclaCookiey_64 + (22) )))) AND Count_G64=0) ELSE    '1'   WHEN Count_G64=1 ELSE    '0';
	invisible_G65<= '1'   WHEN ((((AnclaPacx > anclaCookiex_65-20) AND (AnclaPacx < (anclaCookiex_65+ (12))) ) AND  ((AnclaPacy > anclaCookiey_65-20)  AND  (AnclaPacy < (anclaCookiey_65 + (22) )))) AND Count_G65=0) ELSE    '1'   WHEN Count_G65=1 ELSE    '0';
	invisible_G66<= '1'   WHEN ((((AnclaPacx > anclaCookiex_66-20) AND (AnclaPacx < (anclaCookiex_66+ (12))) ) AND  ((AnclaPacy > anclaCookiey_66-20)  AND  (AnclaPacy < (anclaCookiey_66 + (22) )))) AND Count_G66=0) ELSE    '1'   WHEN Count_G66=1 ELSE    '0';
	invisible_G67<= '1'   WHEN ((((AnclaPacx > anclaCookiex_67-20) AND (AnclaPacx < (anclaCookiex_67+ (12))) ) AND  ((AnclaPacy > anclaCookiey_67-20)  AND  (AnclaPacy < (anclaCookiey_67 + (22) )))) AND Count_G67=0) ELSE    '1'   WHEN Count_G67=1 ELSE    '0';
	invisible_G68<= '1'   WHEN ((((AnclaPacx > anclaCookiex_68-20) AND (AnclaPacx < (anclaCookiex_68+ (12))) ) AND  ((AnclaPacy > anclaCookiey_68-20)  AND  (AnclaPacy < (anclaCookiey_68 + (22) )))) AND Count_G68=0) ELSE    '1'   WHEN Count_G68=1 ELSE    '0';
	invisible_G69<= '1'   WHEN ((((AnclaPacx > anclaCookiex_69-20) AND (AnclaPacx < (anclaCookiex_69+ (12))) ) AND  ((AnclaPacy > anclaCookiey_69-20)  AND  (AnclaPacy < (anclaCookiey_69 + (22) )))) AND Count_G69=0) ELSE    '1'   WHEN Count_G69=1 ELSE    '0';
	invisible_G70<= '1'   WHEN ((((AnclaPacx > anclaCookiex_70-20) AND (AnclaPacx < (anclaCookiex_70+ (12))) ) AND  ((AnclaPacy > anclaCookiey_70-20)  AND  (AnclaPacy < (anclaCookiey_70 + (22) )))) AND Count_G70=0) ELSE    '1'   WHEN Count_G70=1 ELSE    '0';
	invisible_G71<= '1'   WHEN ((((AnclaPacx > anclaCookiex_71-20) AND (AnclaPacx < (anclaCookiex_71+ (12))) ) AND  ((AnclaPacy > anclaCookiey_71-20)  AND  (AnclaPacy < (anclaCookiey_71 + (22) )))) AND Count_G71=0) ELSE    '1'   WHEN Count_G71=1 ELSE    '0';
	invisible_G72<= '1'   WHEN ((((AnclaPacx > anclaCookiex_72-20) AND (AnclaPacx < (anclaCookiex_72+ (12))) ) AND  ((AnclaPacy > anclaCookiey_72-20)  AND  (AnclaPacy < (anclaCookiey_72 + (22) )))) AND Count_G72=0) ELSE    '1'   WHEN Count_G72=1 ELSE    '0';
	invisible_G73<= '1'   WHEN ((((AnclaPacx > anclaCookiex_73-20) AND (AnclaPacx < (anclaCookiex_73+ (12))) ) AND  ((AnclaPacy > anclaCookiey_73-20)  AND  (AnclaPacy < (anclaCookiey_73 + (22) )))) AND Count_G73=0) ELSE    '1'   WHEN Count_G73=1 ELSE    '0';
	invisible_G74<= '1'   WHEN ((((AnclaPacx > anclaCookiex_74-20) AND (AnclaPacx < (anclaCookiex_74+ (12))) ) AND  ((AnclaPacy > anclaCookiey_74-20)  AND  (AnclaPacy < (anclaCookiey_74 + (22) )))) AND Count_G74=0) ELSE    '1'   WHEN Count_G74=1 ELSE    '0';
	invisible_G75<= '1'   WHEN ((((AnclaPacx > anclaCookiex_75-20) AND (AnclaPacx < (anclaCookiex_75+ (12))) ) AND  ((AnclaPacy > anclaCookiey_75-20)  AND  (AnclaPacy < (anclaCookiey_75 + (22) )))) AND Count_G75=0) ELSE    '1'   WHEN Count_G75=1 ELSE    '0';
	invisible_G76<= '1'   WHEN ((((AnclaPacx > anclaCookiex_76-20) AND (AnclaPacx < (anclaCookiex_76+ (12))) ) AND  ((AnclaPacy > anclaCookiey_76-20)  AND  (AnclaPacy < (anclaCookiey_76 + (22) )))) AND Count_G76=0) ELSE    '1'   WHEN Count_G76=1 ELSE    '0';
	invisible_G77<= '1'   WHEN ((((AnclaPacx > anclaCookiex_77-20) AND (AnclaPacx < (anclaCookiex_77+ (12))) ) AND  ((AnclaPacy > anclaCookiey_77-20)  AND  (AnclaPacy < (anclaCookiey_77 + (22) )))) AND Count_G77=0) ELSE    '1'   WHEN Count_G77=1 ELSE    '0';
	invisible_G78<= '1'   WHEN ((((AnclaPacx > anclaCookiex_78-20) AND (AnclaPacx < (anclaCookiex_78+ (12))) ) AND  ((AnclaPacy > anclaCookiey_78-20)  AND  (AnclaPacy < (anclaCookiey_78 + (22) )))) AND Count_G78=0) ELSE    '1'   WHEN Count_G78=1 ELSE    '0';
	invisible_G79<= '1'   WHEN ((((AnclaPacx > anclaCookiex_79-20) AND (AnclaPacx < (anclaCookiex_79+ (12))) ) AND  ((AnclaPacy > anclaCookiey_79-20)  AND  (AnclaPacy < (anclaCookiey_79 + (22) )))) AND Count_G79=0) ELSE    '1'   WHEN Count_G79=1 ELSE    '0';
	invisible_G80<= '1'   WHEN ((((AnclaPacx > anclaCookiex_80-20) AND (AnclaPacx < (anclaCookiex_80+ (12))) ) AND  ((AnclaPacy > anclaCookiey_80-20)  AND  (AnclaPacy < (anclaCookiey_80 + (22) )))) AND Count_G80=0) ELSE    '1'   WHEN Count_G80=1 ELSE    '0';
	invisible_G81<= '1'   WHEN ((((AnclaPacx > anclaCookiex_81-20) AND (AnclaPacx < (anclaCookiex_81+ (12))) ) AND  ((AnclaPacy > anclaCookiey_81-20)  AND  (AnclaPacy < (anclaCookiey_81 + (22) )))) AND Count_G81=0) ELSE    '1'   WHEN Count_G81=1 ELSE    '0';
	invisible_G82<= '1'   WHEN ((((AnclaPacx > anclaCookiex_82-20) AND (AnclaPacx < (anclaCookiex_82+ (12))) ) AND  ((AnclaPacy > anclaCookiey_82-20)  AND  (AnclaPacy < (anclaCookiey_82 + (22) )))) AND Count_G82=0) ELSE    '1'   WHEN Count_G82=1 ELSE    '0';
	invisible_G83<= '1'   WHEN ((((AnclaPacx > anclaCookiex_83-20) AND (AnclaPacx < (anclaCookiex_83+ (12))) ) AND  ((AnclaPacy > anclaCookiey_83-20)  AND  (AnclaPacy < (anclaCookiey_83 + (22) )))) AND Count_G83=0) ELSE    '1'   WHEN Count_G83=1 ELSE    '0';
	invisible_G84<= '1'   WHEN ((((AnclaPacx > anclaCookiex_84-20) AND (AnclaPacx < (anclaCookiex_84+ (12))) ) AND  ((AnclaPacy > anclaCookiey_84-20)  AND  (AnclaPacy < (anclaCookiey_84 + (22) )))) AND Count_G84=0) ELSE    '1'   WHEN Count_G84=1 ELSE    '0';
	invisible_G85<= '1'   WHEN ((((AnclaPacx > anclaCookiex_85-20) AND (AnclaPacx < (anclaCookiex_85+ (12))) ) AND  ((AnclaPacy > anclaCookiey_85-20)  AND  (AnclaPacy < (anclaCookiey_85 + (22) )))) AND Count_G85=0) ELSE    '1'   WHEN Count_G85=1 ELSE    '0';
	invisible_G86<= '1'   WHEN ((((AnclaPacx > anclaCookiex_86-20) AND (AnclaPacx < (anclaCookiex_86+ (12))) ) AND  ((AnclaPacy > anclaCookiey_86-20)  AND  (AnclaPacy < (anclaCookiey_86 + (22) )))) AND Count_G86=0) ELSE    '1'   WHEN Count_G86=1 ELSE    '0';
	invisible_G87<= '1'   WHEN ((((AnclaPacx > anclaCookiex_87-20) AND (AnclaPacx < (anclaCookiex_87+ (12))) ) AND  ((AnclaPacy > anclaCookiey_87-20)  AND  (AnclaPacy < (anclaCookiey_87 + (22) )))) AND Count_G87=0) ELSE    '1'   WHEN Count_G87=1 ELSE    '0';
	invisible_G88<= '1'   WHEN ((((AnclaPacx > anclaCookiex_88-20) AND (AnclaPacx < (anclaCookiex_88+ (12))) ) AND  ((AnclaPacy > anclaCookiey_88-20)  AND  (AnclaPacy < (anclaCookiey_88 + (22) )))) AND Count_G88=0) ELSE    '1'   WHEN Count_G88=1 ELSE    '0';
	invisible_G89<= '1'   WHEN ((((AnclaPacx > anclaCookiex_89-20) AND (AnclaPacx < (anclaCookiex_89+ (12))) ) AND  ((AnclaPacy > anclaCookiey_89-20)  AND  (AnclaPacy < (anclaCookiey_89 + (22) )))) AND Count_G89=0) ELSE    '1'   WHEN Count_G89=1 ELSE    '0';
	invisible_G90<= '1'   WHEN ((((AnclaPacx > anclaCookiex_90-20) AND (AnclaPacx < (anclaCookiex_90+ (12))) ) AND  ((AnclaPacy > anclaCookiey_90-20)  AND  (AnclaPacy < (anclaCookiey_90 + (22) )))) AND Count_G90=0) ELSE    '1'   WHEN Count_G90=1 ELSE    '0';
	invisible_G91<= '1'   WHEN ((((AnclaPacx > anclaCookiex_91-20) AND (AnclaPacx < (anclaCookiex_91+ (12))) ) AND  ((AnclaPacy > anclaCookiey_91-20)  AND  (AnclaPacy < (anclaCookiey_91 + (22) )))) AND Count_G91=0) ELSE    '1'   WHEN Count_G91=1 ELSE    '0';
	invisible_G92<= '1'   WHEN ((((AnclaPacx > anclaCookiex_92-20) AND (AnclaPacx < (anclaCookiex_92+ (12))) ) AND  ((AnclaPacy > anclaCookiey_92-20)  AND  (AnclaPacy < (anclaCookiey_92 + (22) )))) AND Count_G92=0) ELSE    '1'   WHEN Count_G92=1 ELSE    '0';
	invisible_G93<= '1'   WHEN ((((AnclaPacx > anclaCookiex_93-20) AND (AnclaPacx < (anclaCookiex_93+ (12))) ) AND  ((AnclaPacy > anclaCookiey_93-20)  AND  (AnclaPacy < (anclaCookiey_93 + (22) )))) AND Count_G93=0) ELSE    '1'   WHEN Count_G93=1 ELSE    '0';
	invisible_G94<= '1'   WHEN ((((AnclaPacx > anclaCookiex_94-20) AND (AnclaPacx < (anclaCookiex_94+ (12))) ) AND  ((AnclaPacy > anclaCookiey_94-20)  AND  (AnclaPacy < (anclaCookiey_94 + (22) )))) AND Count_G94=0) ELSE    '1'   WHEN Count_G94=1 ELSE    '0';
	invisible_G95<= '1'   WHEN ((((AnclaPacx > anclaCookiex_95-20) AND (AnclaPacx < (anclaCookiex_95+ (12))) ) AND  ((AnclaPacy > anclaCookiey_95-20)  AND  (AnclaPacy < (anclaCookiey_95 + (22) )))) AND Count_G95=0) ELSE    '1'   WHEN Count_G95=1 ELSE    '0';
	invisible_G96<= '1'   WHEN ((((AnclaPacx > anclaCookiex_96-20) AND (AnclaPacx < (anclaCookiex_96+ (12))) ) AND  ((AnclaPacy > anclaCookiey_96-20)  AND  (AnclaPacy < (anclaCookiey_96 + (22) )))) AND Count_G96=0) ELSE    '1'   WHEN Count_G96=1 ELSE    '0';
	invisible_G97<= '1'   WHEN ((((AnclaPacx > anclaCookiex_97-20) AND (AnclaPacx < (anclaCookiex_97+ (12))) ) AND  ((AnclaPacy > anclaCookiey_97-20)  AND  (AnclaPacy < (anclaCookiey_97 + (22) )))) AND Count_G97=0) ELSE    '1'   WHEN Count_G97=1 ELSE    '0';
	invisible_G98<= '1'   WHEN ((((AnclaPacx > anclaCookiex_98-20) AND (AnclaPacx < (anclaCookiex_98+ (12))) ) AND  ((AnclaPacy > anclaCookiey_98-20)  AND  (AnclaPacy < (anclaCookiey_98 + (22) )))) AND Count_G98=0) ELSE    '1'   WHEN Count_G98=1 ELSE    '0';
	invisible_G99<= '1'   WHEN ((((AnclaPacx > anclaCookiex_99-20) AND (AnclaPacx < (anclaCookiex_99+ (12))) ) AND  ((AnclaPacy > anclaCookiey_99-20)  AND  (AnclaPacy < (anclaCookiey_99 + (22) )))) AND Count_G99=0) ELSE    '1'   WHEN Count_G99=1 ELSE    '0';
	invisible_G100<= '1'   WHEN ((((AnclaPacx > anclaCookiex_100-20) AND (AnclaPacx < (anclaCookiex_100+ (12))) ) AND  ((AnclaPacy > anclaCookiey_100-20)  AND  (AnclaPacy < (anclaCookiey_100 + (22) )))) AND Count_G100=0) ELSE    '1'   WHEN Count_G100=1 ELSE    '0';
	
						 
	Count_Galletas: PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			Count_G1 <= 0;
			Count_G2 <= 0;
			Count_G3 <= 0;
			Count_G4 <= 0;
			Count_G5 <= 0;
			Count_G6 <= 0;
			Count_G7 <= 0;
			Count_G8 <= 0;
			Count_G9 <= 0;
			Count_G10 <= 0;
			Count_G11 <= 0;
			Count_G12 <= 0;
			Count_G13 <= 0;
			Count_G14 <= 0;
			Count_G15 <= 0;
			Count_G16 <= 0;
			Count_G17 <= 0;
			Count_G18 <= 0;
			Count_G19 <= 0;
			Count_G20 <= 0;
			Count_G21 <= 0;
			Count_G22 <= 0;
			Count_G23 <= 0;
			Count_G24 <= 0;
			Count_G25 <= 0;
			Count_G26 <= 0;
			Count_G27 <= 0;
			Count_G28 <= 0;
			Count_G29 <= 0;
			Count_G30 <= 0;
			Count_G31 <= 0;
			Count_G32 <= 0;
			Count_G33 <= 0;
			Count_G34 <= 0;
			Count_G35 <= 0;
			Count_G36 <= 0;
			Count_G37 <= 0;
			Count_G38 <= 0;
			Count_G39 <= 0;
			Count_G40 <= 0;
			Count_G41 <= 0;
			Count_G42 <= 0;
			Count_G43 <= 0;
			Count_G44 <= 0;
			Count_G45 <= 0;
			Count_G46 <= 0;
			Count_G47 <= 0;
			Count_G48 <= 0;
			Count_G49 <= 0;
			Count_G50 <= 0;
			Count_G51 <= 0;
			Count_G52 <= 0;
			Count_G53 <= 0;
			Count_G54 <= 0;
			Count_G55 <= 0;
			Count_G56 <= 0;
			Count_G57 <= 0;
			Count_G58 <= 0;
			Count_G59 <= 0;
			Count_G60 <= 0;
			Count_G61 <= 0;
			Count_G62 <= 0;
			Count_G63 <= 0;
			Count_G64 <= 0;
			Count_G65 <= 0;
			Count_G66 <= 0;
			Count_G67 <= 0;
			Count_G68 <= 0;
			Count_G69 <= 0;
			Count_G70 <= 0;
			Count_G71 <= 0;
			Count_G72 <= 0;
			Count_G73 <= 0;
			Count_G74 <= 0;
			Count_G75 <= 0;
			Count_G76 <= 0;
			Count_G77 <= 0;
			Count_G78 <= 0;
			Count_G79 <= 0;
			Count_G80 <= 0;
			Count_G81 <= 0;
			Count_G82 <= 0;
			Count_G83 <= 0;
			Count_G84 <= 0;
			Count_G85 <= 0;
			Count_G86 <= 0;
			Count_G87 <= 0;
			Count_G88 <= 0;
			Count_G89 <= 0;
			Count_G90 <= 0;
			Count_G91 <= 0;
			Count_G92 <= 0;
			Count_G93 <= 0;
			Count_G94 <= 0;
			Count_G95 <= 0;
			Count_G96 <= 0;
			Count_G97 <= 0;
			Count_G98 <= 0;
			Count_G99 <= 0;
			Count_G100 <= 0;

		ELSIF (rising_edge(clk)) THEN
			IF (Count_G1 = 0 AND invisible_G1 = '1') THEN
				Count_G1 <= 1;
			ELSIF(Count_G2= 0 AND invisible_G2 = '1') THEN
			   Count_G2 <= 1;
			ELSIF(Count_G3= 0 AND invisible_G3 = '1') THEN
			   Count_G3 <= 1;			
			ELSIF(Count_G4= 0 AND invisible_G4 = '1') THEN
				Count_G4 <= 1;		
			ELSIF(Count_G5= 0 AND invisible_G5 = '1') THEN
				Count_G5 <= 1;	
			ELSIF(Count_G6= 0 AND invisible_G6 = '1') THEN
				Count_G6 <= 1;	
			ELSIF(Count_G7= 0 AND invisible_G7 = '1') THEN
				Count_G7 <= 1;	
			ELSIF(Count_G8= 0 AND invisible_G8 = '1') THEN
				Count_G8 <= 1;	
			ELSIF(Count_G9= 0 AND invisible_G9 = '1') THEN
				Count_G9 <= 1;	
			ELSIF(Count_G10= 0 AND invisible_G10 = '1') THEN
				Count_G10 <= 1;
			ELSIF (Count_G11 = 0 AND invisible_G11 = '1') THEN
				Count_G11 <= 1;
			ELSIF(Count_G12= 0 AND invisible_G12 = '1') THEN
			   Count_G12 <= 1;
			ELSIF(Count_G13= 0 AND invisible_G13 = '1') THEN
			   Count_G13 <= 1;			
			ELSIF(Count_G14= 0 AND invisible_G14 = '1') THEN
				Count_G14 <= 1;		
			ELSIF(Count_G15= 0 AND invisible_G15 = '1') THEN
				Count_G15 <= 1;	
			ELSIF(Count_G16= 0 AND invisible_G16 = '1') THEN
				Count_G16 <= 1;	
			ELSIF(Count_G17= 0 AND invisible_G17 = '1') THEN
				Count_G17 <= 1;	
			ELSIF(Count_G18= 0 AND invisible_G18 = '1') THEN
				Count_G18 <= 1;	
			ELSIF(Count_G19= 0 AND invisible_G19 = '1') THEN
				Count_G19 <= 1;	
			ELSIF(Count_G20= 0 AND invisible_G20 = '1') THEN
				Count_G20 <= 1;
			ELSIF (Count_G21 = 0 AND invisible_G21 = '1') THEN
				Count_G21 <= 1;
			ELSIF(Count_G22= 0 AND invisible_G22 = '1') THEN
			   Count_G22 <= 1;
			ELSIF(Count_G23= 0 AND invisible_G23 = '1') THEN
			   Count_G23 <= 1;			
			ELSIF(Count_G24= 0 AND invisible_G24 = '1') THEN
				Count_G24 <= 1;		
			ELSIF(Count_G25= 0 AND invisible_G25 = '1') THEN
				Count_G25 <= 1;	
			ELSIF(Count_G26= 0 AND invisible_G26 = '1') THEN
				Count_G26 <= 1;	
			ELSIF(Count_G27= 0 AND invisible_G27 = '1') THEN
				Count_G27 <= 1;	
			ELSIF(Count_G28= 0 AND invisible_G28 = '1') THEN
				Count_G28 <= 1;	
			ELSIF(Count_G29= 0 AND invisible_G29 = '1') THEN
				Count_G29 <= 1;	
			ELSIF(Count_G30= 0 AND invisible_G30 = '1') THEN
				Count_G30 <= 1;
			ELSIF (Count_G31 = 0 AND invisible_G31 = '1') THEN
				Count_G31 <= 1;
			ELSIF(Count_G32= 0 AND invisible_G32 = '1') THEN
			   Count_G32 <= 1;
			ELSIF(Count_G33= 0 AND invisible_G33 = '1') THEN
			   Count_G33 <= 1;			
			ELSIF(Count_G34= 0 AND invisible_G34 = '1') THEN
				Count_G34 <= 1;		
			ELSIF(Count_G35= 0 AND invisible_G35 = '1') THEN
				Count_G35 <= 1;	
			ELSIF(Count_G36= 0 AND invisible_G36 = '1') THEN
				Count_G36 <= 1;	
			ELSIF(Count_G37= 0 AND invisible_G37 = '1') THEN
				Count_G37 <= 1;	
			ELSIF(Count_G38= 0 AND invisible_G38 = '1') THEN
				Count_G38 <= 1;	
			ELSIF(Count_G39= 0 AND invisible_G39 = '1') THEN
				Count_G39 <= 1;
			ELSIF(Count_G40= 0  AND invisible_G40 = '1')THEN   
			Count_G40 <= 1;
			ELSIF(Count_G41= 0  AND invisible_G41 = '1')THEN   
			Count_G41 <= 1;
			ELSIF(Count_G42= 0  AND invisible_G42 = '1')THEN   
			Count_G42 <= 1;
			ELSIF(Count_G43= 0  AND invisible_G43 = '1')THEN   
			Count_G43 <= 1;
			ELSIF(Count_G44= 0  AND invisible_G44 = '1')THEN   
			Count_G44 <= 1;
			ELSIF(Count_G45= 0  AND invisible_G45 = '1')THEN   
			Count_G45 <= 1;
			ELSIF(Count_G46= 0  AND invisible_G46 = '1')THEN   
			Count_G46 <= 1;
			ELSIF(Count_G47= 0  AND invisible_G47 = '1')THEN  
			Count_G47 <= 1;
			ELSIF(Count_G48= 0  AND invisible_G48 = '1')THEN   
			Count_G48 <= 1;
			ELSIF(Count_G49= 0  AND invisible_G49 = '1')THEN   
			Count_G49 <= 1;
			ELSIF(Count_G50= 0  AND invisible_G50 = '1')THEN   
			Count_G50 <= 1;
			ELSIF(Count_G51= 0  AND invisible_G51 = '1')THEN   
			Count_G51 <= 1;
			ELSIF(Count_G52= 0  AND invisible_G52 = '1')THEN   
			Count_G52 <= 1;
			ELSIF(Count_G53= 0  AND invisible_G53 = '1')THEN   
			Count_G53 <= 1;
			ELSIF(Count_G54= 0  AND invisible_G54 = '1')THEN   
			Count_G54 <= 1;
			ELSIF(Count_G55= 0  AND invisible_G55 = '1')THEN   
			Count_G55 <= 1;
			ELSIF(Count_G56= 0  AND invisible_G56 = '1')THEN   
			Count_G56 <= 1;
			ELSIF(Count_G57= 0  AND invisible_G57 = '1')THEN   
			Count_G57 <= 1;
			ELSIF(Count_G58= 0  AND invisible_G58 = '1')THEN   
			Count_G58 <= 1;
			ELSIF(Count_G59= 0  AND invisible_G59 = '1')THEN   
			Count_G59 <= 1;
			ELSIF(Count_G60= 0  AND invisible_G60 = '1')THEN   
			Count_G60 <= 1;
			ELSIF(Count_G61= 0  AND invisible_G61 = '1')THEN   
			Count_G61 <= 1;
			ELSIF(Count_G62= 0  AND invisible_G62 = '1')THEN   
			Count_G62 <= 1;
			ELSIF(Count_G63= 0  AND invisible_G63 = '1')THEN   
			Count_G63 <= 1;
			ELSIF(Count_G64= 0  AND invisible_G64 = '1')THEN   
			Count_G64 <= 1;
			ELSIF(Count_G65= 0  AND invisible_G65 = '1')THEN   
			Count_G65 <= 1;
			ELSIF(Count_G66= 0  AND invisible_G66 = '1')THEN   
			Count_G66 <= 1;
			ELSIF(Count_G67= 0  AND invisible_G67 = '1')THEN   
			Count_G67 <= 1;
			ELSIF(Count_G68= 0  AND invisible_G68 = '1')THEN   
			Count_G68 <= 1;
			ELSIF(Count_G69= 0  AND invisible_G69 = '1')THEN   
			Count_G69 <= 1;
			ELSIF(Count_G70= 0  AND invisible_G70 = '1')THEN   
			Count_G70 <= 1;
			ELSIF(Count_G71= 0  AND invisible_G71 = '1')THEN   
			Count_G71 <= 1;
			ELSIF(Count_G72= 0  AND invisible_G72 = '1')THEN  
			Count_G72 <= 1;
			ELSIF(Count_G73= 0  AND invisible_G73 = '1')THEN   
			Count_G73 <= 1;
			ELSIF(Count_G74= 0  AND invisible_G74 = '1')THEN   
			Count_G74 <= 1;
			ELSIF(Count_G75= 0  AND invisible_G75 = '1')THEN   
			Count_G75 <= 1;
			ELSIF(Count_G76= 0  AND invisible_G76 = '1')THEN   
			Count_G76 <= 1;
			ELSIF(Count_G77= 0  AND invisible_G77 = '1')THEN   
			Count_G77 <= 1;
			ELSIF(Count_G78= 0  AND invisible_G78 = '1')THEN   
			Count_G78 <= 1;
			ELSIF(Count_G79= 0  AND invisible_G79 = '1')THEN   
			Count_G79 <= 1;
			ELSIF(Count_G80= 0  AND invisible_G80 = '1')THEN   
			Count_G80 <= 1;
			ELSIF(Count_G81= 0  AND invisible_G81 = '1')THEN   
			Count_G81 <= 1;
			ELSIF(Count_G82= 0  AND invisible_G82 = '1')THEN   
			Count_G82 <= 1;
			ELSIF(Count_G83= 0  AND invisible_G83 = '1')THEN   
			Count_G83 <= 1;
			ELSIF(Count_G84= 0  AND invisible_G84 = '1')THEN   
			Count_G84 <= 1;
			ELSIF(Count_G85= 0  AND invisible_G85 = '1')THEN   
			Count_G85 <= 1;
			ELSIF(Count_G86= 0  AND invisible_G86 = '1')THEN   
			Count_G86 <= 1;
			ELSIF(Count_G87= 0  AND invisible_G87 = '1')THEN   
			Count_G87 <= 1;
			ELSIF(Count_G88= 0  AND invisible_G88 = '1')THEN   
			Count_G88 <= 1;
			ELSIF(Count_G89= 0  AND invisible_G89 = '1')THEN   
			Count_G89 <= 1;
			ELSIF(Count_G90= 0  AND invisible_G90 = '1')THEN   
			Count_G90 <= 1;
			ELSIF(Count_G91= 0  AND invisible_G91 = '1')THEN   
			Count_G91 <= 1;
			ELSIF(Count_G92= 0  AND invisible_G92 = '1')THEN   
			Count_G92 <= 1;
			ELSIF(Count_G93= 0  AND invisible_G93 = '1')THEN   
			Count_G93 <= 1;
			ELSIF(Count_G94= 0  AND invisible_G94 = '1')THEN   
			Count_G94 <= 1;
			ELSIF(Count_G95= 0  AND invisible_G95 = '1')THEN   
			Count_G95 <= 1;
			ELSIF(Count_G96= 0  AND invisible_G96 = '1')THEN   
			Count_G96 <= 1;
			ELSIF(Count_G97= 0  AND invisible_G97 = '1')THEN   
			Count_G97 <= 1;
			ELSIF(Count_G98= 0  AND invisible_G98 = '1')THEN   
			Count_G98 <= 1;
			ELSIF(Count_G99= 0  AND invisible_G99 = '1')THEN   
			Count_G99 <= 1;
			ELSIF(Count_G100= 0  AND invisible_G100 = '1')THEN   
			Count_G100 <= 1;
	
			ELSIF(Count_G1 = 1 OR Count_G2=1 OR Count_G3=1 OR Count_G4=1 OR Count_G5=1 OR
			      Count_G6 = 1 OR Count_G7=1 OR Count_G8=1 OR Count_G9=1 OR Count_G10=1 OR
					Count_G11 = 1 OR Count_G12=1 OR Count_G13=1 OR Count_G14=1 OR Count_G15=1 OR
					Count_G16 = 1 OR Count_G17=1 OR Count_G18=1 OR Count_G19=1 OR Count_G20=1 OR
					Count_G21 = 1 OR Count_G22=1 OR Count_G23=1 OR Count_G24=1 OR Count_G25=1 OR
					Count_G26 = 1 OR Count_G27=1 OR Count_G28=1 OR Count_G29=1 OR Count_G30=1 OR
					Count_G31 = 1 OR Count_G32=1 OR Count_G33=1 OR Count_G34=1 OR Count_G35=1 OR
					Count_G36 = 1 OR Count_G37=1 OR Count_G38=1 OR Count_G39=1 OR Count_G40 = 1 OR Count_G41 = 1
					OR Count_G42 = 1 OR Count_G43 = 1 OR Count_G44 = 1 OR Count_G45 = 1 OR Count_G46 = 1 OR Count_G47 = 1 OR Count_G48 = 1 
					OR Count_G49 = 1 OR Count_G50 = 1 OR Count_G51 = 1 OR Count_G52 = 1 OR Count_G53 = 1 OR Count_G54 = 1 OR Count_G55 = 1 
					OR Count_G56 = 1 OR Count_G57 = 1 OR Count_G58 = 1 OR Count_G59 = 1 OR Count_G60 = 1 OR Count_G61 = 1 OR Count_G62 = 1 
					OR Count_G63 = 1 OR Count_G64 = 1 OR Count_G65 = 1 OR Count_G66 = 1 OR Count_G67 = 1 OR Count_G68 = 1 OR Count_G69 = 1
					OR Count_G70 = 1 OR Count_G71 = 1 OR Count_G72 = 1 OR Count_G73 = 1 OR Count_G74 = 1 OR Count_G75 = 1 OR Count_G76 = 1
					OR Count_G77 = 1 OR Count_G78 = 1 OR Count_G79 = 1 OR Count_G80 = 1 OR Count_G81 = 1 OR Count_G82 = 1 OR Count_G83 = 1 
					OR Count_G84 = 1 OR Count_G85 = 1 OR Count_G86 = 1 OR Count_G87 = 1 OR Count_G88 = 1 OR Count_G89 = 1 OR Count_G90 = 1
					OR Count_G91 = 1 OR Count_G92 = 1 OR Count_G93 = 1 OR Count_G94 = 1 OR Count_G95 = 1 OR Count_G96 = 1 OR Count_G97 = 1
					OR Count_G98 = 1 OR Count_G99 = 1 OR Count_G100 = 1) THEN
			   Count_G1 <= Count_G1;
				Count_G2 <= Count_G2;
				Count_G3 <= Count_G3;
				Count_G4 <= Count_G4;
				Count_G5 <= Count_G5;
				Count_G6 <= Count_G6;
				Count_G7 <= Count_G7;
				Count_G8 <= Count_G8;
				Count_G9 <= Count_G9;
				Count_G10 <= Count_G10;
				Count_G11 <= Count_G11;
				Count_G12 <= Count_G12;
				Count_G13 <= Count_G13;
				Count_G14 <= Count_G14;
				Count_G15 <= Count_G15;
				Count_G16 <= Count_G16;
				Count_G17 <= Count_G17;
				Count_G18 <= Count_G18;
				Count_G19 <= Count_G19;
				Count_G20 <= Count_G20;
				 Count_G21 <= Count_G21;
				Count_G22 <= Count_G22;
				Count_G23 <= Count_G23;
				Count_G24 <= Count_G24;
				Count_G25 <= Count_G25;
				Count_G26 <= Count_G26;
				Count_G27 <= Count_G27;
				Count_G28 <= Count_G28;
				Count_G29 <= Count_G29;
				Count_G30 <= Count_G30;
				Count_G31 <= Count_G31;
				Count_G32 <= Count_G32;
				Count_G33 <= Count_G33;
				Count_G34 <= Count_G34;
				Count_G35 <= Count_G35;
				Count_G36 <= Count_G36;
				Count_G37 <= Count_G37;
				Count_G38 <= Count_G38;
				Count_G39 <= Count_G39;
				Count_G40 <= Count_G40;
				Count_G41 <= Count_G41;
				Count_G42 <= Count_G42;
				Count_G43 <= Count_G43;
				Count_G44 <= Count_G44;
				Count_G45 <= Count_G45;
				Count_G46 <= Count_G46;
				Count_G47 <= Count_G47;
				Count_G48 <= Count_G48;
				Count_G49 <= Count_G49;
				Count_G50 <= Count_G50;
				Count_G51 <= Count_G51;
				Count_G52 <= Count_G52;
				Count_G53 <= Count_G53;
				Count_G54 <= Count_G54;
				Count_G55 <= Count_G55;
				Count_G56 <= Count_G56;
				Count_G57 <= Count_G57;
				Count_G58 <= Count_G58;
				Count_G59 <= Count_G59;
				Count_G60 <= Count_G60;
				Count_G61 <= Count_G61;
				Count_G62 <= Count_G62;
				Count_G63 <= Count_G63;
				Count_G64 <= Count_G64;
				Count_G65 <= Count_G65;
				Count_G66 <= Count_G66;
				Count_G67 <= Count_G67;
				Count_G68 <= Count_G68;
				Count_G69 <= Count_G69;
				Count_G70 <= Count_G70;
				Count_G71 <= Count_G71;
				Count_G72 <= Count_G72;
				Count_G73 <= Count_G73;
				Count_G74 <= Count_G74;
				Count_G75 <= Count_G75;
				Count_G76 <= Count_G76;
				Count_G77 <= Count_G77;
				Count_G78 <= Count_G78;
				Count_G79 <= Count_G79;
				Count_G80 <= Count_G80;
				Count_G81 <= Count_G81;
				Count_G82 <= Count_G82;
				Count_G83 <= Count_G83;
				Count_G84 <= Count_G84;
				Count_G85 <= Count_G85;
				Count_G86 <= Count_G86;
				Count_G87 <= Count_G87;
				Count_G88 <= Count_G88;
				Count_G89 <= Count_G89;
				Count_G90 <= Count_G90;
				Count_G91 <= Count_G91;
				Count_G92 <= Count_G92;
				Count_G93 <= Count_G93;
				Count_G94 <= Count_G94;
				Count_G95 <= Count_G95;
				Count_G96 <= Count_G96;
				Count_G97 <= Count_G97;
				Count_G98 <= Count_G98;
				Count_G99 <= Count_G99;
				Count_G100 <= Count_G100;

		   END IF;
	   END IF;

	END PROCESS Count_Galletas;
	
	Score_temp <= '1' WHEN ((((((AnclaPacx > anclaCookiex_1-20) AND (AnclaPacx < (anclaCookiex_1 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_1-20)  AND  (AnclaPacy < (anclaCookiey_1 + (22) )))) AND Count_G1=0) OR
									((((AnclaPacx > anclaCookiex_2-20) AND (AnclaPacx < (anclaCookiex_2 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_2-20)  AND  (AnclaPacy < (anclaCookiey_2 + (22) )))) AND Count_G2=0)  OR 
                            ((((AnclaPacx > anclaCookiex_3-20) AND (AnclaPacx < (anclaCookiex_3 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_3-20)  AND  (AnclaPacy < (anclaCookiey_3 + (22) )))) AND Count_G3=0) OR
									((((AnclaPacx > anclaCookiex_4-20) AND (AnclaPacx < (anclaCookiex_4 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_4-20)  AND  (AnclaPacy < (anclaCookiey_4 + (22) )))) AND Count_G4=0) OR
									((((AnclaPacx > anclaCookiex_5-20) AND (AnclaPacx < (anclaCookiex_5 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_5-20)  AND  (AnclaPacy < (anclaCookiey_5 + (22) )))) AND Count_G5=0) OR
									((((AnclaPacx > anclaCookiex_6-20) AND (AnclaPacx < (anclaCookiex_6 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_6-20)  AND  (AnclaPacy < (anclaCookiey_6 + (22) )))) AND Count_G6=0) OR
									((((AnclaPacx > anclaCookiex_7-20) AND (AnclaPacx < (anclaCookiex_7 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_7-20)  AND  (AnclaPacy < (anclaCookiey_7 + (22) )))) AND Count_G7=0) OR
									((((AnclaPacx > anclaCookiex_8-20) AND (AnclaPacx < (anclaCookiex_8 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_8-20)  AND  (AnclaPacy < (anclaCookiey_8 + (22) )))) AND Count_G8=0) OR
									((((AnclaPacx > anclaCookiex_9-20) AND (AnclaPacx < (anclaCookiex_9 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_9-20)  AND  (AnclaPacy < (anclaCookiey_9 + (22) )))) AND Count_G9=0) OR
									((((AnclaPacx > anclaCookiex_10-20) AND (AnclaPacx < (anclaCookiex_10 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_10-20)  AND  (AnclaPacy < (anclaCookiey_10 + (22) )))) AND Count_G10=0) OR
									((((AnclaPacx > anclaCookiex_11-20) AND (AnclaPacx < (anclaCookiex_11 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_11-20)  AND  (AnclaPacy < (anclaCookiey_11 + (22) )))) AND Count_G11=0) OR
									((((AnclaPacx > anclaCookiex_12-20) AND (AnclaPacx < (anclaCookiex_12 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_12-20)  AND  (AnclaPacy < (anclaCookiey_12 + (22) )))) AND Count_G12=0)  OR 
                            ((((AnclaPacx > anclaCookiex_13-20) AND (AnclaPacx < (anclaCookiex_13 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_13-20)  AND  (AnclaPacy < (anclaCookiey_13 + (22) )))) AND Count_G13=0) OR
									((((AnclaPacx > anclaCookiex_14-20) AND (AnclaPacx < (anclaCookiex_14 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_14-20)  AND  (AnclaPacy < (anclaCookiey_14 + (22) )))) AND Count_G14=0) OR
									((((AnclaPacx > anclaCookiex_15-20) AND (AnclaPacx < (anclaCookiex_15 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_15-20)  AND  (AnclaPacy < (anclaCookiey_15 + (22) )))) AND Count_G15=0) OR
									((((AnclaPacx > anclaCookiex_16-20) AND (AnclaPacx < (anclaCookiex_16 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_16-20)  AND  (AnclaPacy < (anclaCookiey_16 + (22) )))) AND Count_G16=0) OR
									((((AnclaPacx > anclaCookiex_17-20) AND (AnclaPacx < (anclaCookiex_17 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_17-20)  AND  (AnclaPacy < (anclaCookiey_17 + (22) )))) AND Count_G17=0) OR
									((((AnclaPacx > anclaCookiex_18-20) AND (AnclaPacx < (anclaCookiex_18 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_18-20)  AND  (AnclaPacy < (anclaCookiey_18 + (22) )))) AND Count_G18=0) OR
									((((AnclaPacx > anclaCookiex_19-20) AND (AnclaPacx < (anclaCookiex_19 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_19-20)  AND  (AnclaPacy < (anclaCookiey_19 + (22) )))) AND Count_G19=0) OR
									((((AnclaPacx > anclaCookiex_20-20) AND (AnclaPacx < (anclaCookiex_20 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_20-20)  AND  (AnclaPacy < (anclaCookiey_20 + (22) )))) AND Count_G20=0) OR
									((((AnclaPacx > anclaCookiex_21-20) AND (AnclaPacx < (anclaCookiex_21 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_21-20)  AND  (AnclaPacy < (anclaCookiey_21 + (22) )))) AND Count_G21=0) OR
									((((AnclaPacx > anclaCookiex_22-20) AND (AnclaPacx < (anclaCookiex_22 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_22-20)  AND  (AnclaPacy < (anclaCookiey_22 + (22) )))) AND Count_G22=0)  OR 
                            ((((AnclaPacx > anclaCookiex_23-20) AND (AnclaPacx < (anclaCookiex_23 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_23-20)  AND  (AnclaPacy < (anclaCookiey_23 + (22) )))) AND Count_G23=0) OR
									((((AnclaPacx > anclaCookiex_24-20) AND (AnclaPacx < (anclaCookiex_24 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_24-20)  AND  (AnclaPacy < (anclaCookiey_24 + (22) )))) AND Count_G24=0) OR
									((((AnclaPacx > anclaCookiex_25-20) AND (AnclaPacx < (anclaCookiex_25 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_25-20)  AND  (AnclaPacy < (anclaCookiey_25 + (22) )))) AND Count_G25=0) OR
									((((AnclaPacx > anclaCookiex_26-20) AND (AnclaPacx < (anclaCookiex_26 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_26-20)  AND  (AnclaPacy < (anclaCookiey_26 + (22) )))) AND Count_G26=0) OR
									((((AnclaPacx > anclaCookiex_27-20) AND (AnclaPacx < (anclaCookiex_27 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_27-20)  AND  (AnclaPacy < (anclaCookiey_27 + (22) )))) AND Count_G27=0) OR
									((((AnclaPacx > anclaCookiex_28-20) AND (AnclaPacx < (anclaCookiex_28 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_28-20)  AND  (AnclaPacy < (anclaCookiey_28 + (22) )))) AND Count_G28=0) OR
									((((AnclaPacx > anclaCookiex_29-20) AND (AnclaPacx < (anclaCookiex_29 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_29-20)  AND  (AnclaPacy < (anclaCookiey_29 + (22) )))) AND Count_G29=0) OR
									((((AnclaPacx > anclaCookiex_30-20) AND (AnclaPacx < (anclaCookiex_30 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_30-20)  AND  (AnclaPacy < (anclaCookiey_30 + (22) )))) AND Count_G30=0) OR
									((((AnclaPacx > anclaCookiex_31-20) AND (AnclaPacx < (anclaCookiex_31 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_31-20)  AND  (AnclaPacy < (anclaCookiey_31 + (22) )))) AND Count_G31=0) OR
									((((AnclaPacx > anclaCookiex_32-20) AND (AnclaPacx < (anclaCookiex_32 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_32-20)  AND  (AnclaPacy < (anclaCookiey_32 + (22) )))) AND Count_G32=0)  OR 
                            ((((AnclaPacx > anclaCookiex_33-20) AND (AnclaPacx < (anclaCookiex_33 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_33-20)  AND  (AnclaPacy < (anclaCookiey_33 + (22) )))) AND Count_G33=0) OR
									((((AnclaPacx > anclaCookiex_34-20) AND (AnclaPacx < (anclaCookiex_34 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_34-20)  AND  (AnclaPacy < (anclaCookiey_34 + (22) )))) AND Count_G34=0) OR
									((((AnclaPacx > anclaCookiex_35-20) AND (AnclaPacx < (anclaCookiex_35 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_35-20)  AND  (AnclaPacy < (anclaCookiey_35 + (22) )))) AND Count_G35=0) OR
									((((AnclaPacx > anclaCookiex_36-20) AND (AnclaPacx < (anclaCookiex_36 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_36-20)  AND  (AnclaPacy < (anclaCookiey_36 + (22) )))) AND Count_G36=0) OR
									((((AnclaPacx > anclaCookiex_37-20) AND (AnclaPacx < (anclaCookiex_37 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_37-20)  AND  (AnclaPacy < (anclaCookiey_37 + (22) )))) AND Count_G37=0) OR
									((((AnclaPacx > anclaCookiex_38-20) AND (AnclaPacx < (anclaCookiex_38 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_38-20)  AND  (AnclaPacy < (anclaCookiey_38 + (22) )))) AND Count_G38=0) OR
									((((AnclaPacx > anclaCookiex_39-20) AND (AnclaPacx < (anclaCookiex_39 + (12))) ) AND 
								   ((AnclaPacy > anclaCookiey_39-20)  AND  (AnclaPacy < (anclaCookiey_39 + (22) )))) AND Count_G39=0) OR
									((((AnclaPacx > anclaCookiex_40-20) AND (AnclaPacx < (anclaCookiex_40+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_40-20)  AND  (AnclaPacy < (anclaCookiey_40+ (22) )))) AND Count_G40=0) OR
									((((AnclaPacx > anclaCookiex_41-20) AND (AnclaPacx < (anclaCookiex_41+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_41-20)  AND  (AnclaPacy < (anclaCookiey_41+ (22) )))) AND Count_G41=0) OR
									((((AnclaPacx > anclaCookiex_42-20) AND (AnclaPacx < (anclaCookiex_42+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_42-20)  AND  (AnclaPacy < (anclaCookiey_42+ (22) )))) AND Count_G42=0) OR
									((((AnclaPacx > anclaCookiex_43-20) AND (AnclaPacx < (anclaCookiex_43+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_43-20)  AND  (AnclaPacy < (anclaCookiey_43+ (22) )))) AND Count_G43=0) OR
									((((AnclaPacx > anclaCookiex_44-20) AND (AnclaPacx < (anclaCookiex_44+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_44-20)  AND  (AnclaPacy < (anclaCookiey_44+ (22) )))) AND Count_G44=0) OR
									((((AnclaPacx > anclaCookiex_45-20) AND (AnclaPacx < (anclaCookiex_45+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_45-20)  AND  (AnclaPacy < (anclaCookiey_45+ (22) )))) AND Count_G45=0) OR
									((((AnclaPacx > anclaCookiex_46-20) AND (AnclaPacx < (anclaCookiex_46+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_46-20)  AND  (AnclaPacy < (anclaCookiey_46+ (22) )))) AND Count_G46=0) OR
									((((AnclaPacx > anclaCookiex_47-20) AND (AnclaPacx < (anclaCookiex_47+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_47-20)  AND  (AnclaPacy < (anclaCookiey_47+ (22) )))) AND Count_G47=0) OR
									((((AnclaPacx > anclaCookiex_48-20) AND (AnclaPacx < (anclaCookiex_48+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_48-20)  AND  (AnclaPacy < (anclaCookiey_48+ (22) )))) AND Count_G48=0) OR
									((((AnclaPacx > anclaCookiex_49-20) AND (AnclaPacx < (anclaCookiex_49+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_49-20)  AND  (AnclaPacy < (anclaCookiey_49+ (22) )))) AND Count_G49=0) OR
									((((AnclaPacx > anclaCookiex_50-20) AND (AnclaPacx < (anclaCookiex_50+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_50-20)  AND  (AnclaPacy < (anclaCookiey_50+ (22) )))) AND Count_G50=0) OR
									((((AnclaPacx > anclaCookiex_51-20) AND (AnclaPacx < (anclaCookiex_51+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_51-20)  AND  (AnclaPacy < (anclaCookiey_51+ (22) )))) AND Count_G51=0) OR
									((((AnclaPacx > anclaCookiex_52-20) AND (AnclaPacx < (anclaCookiex_52+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_52-20)  AND  (AnclaPacy < (anclaCookiey_52+ (22) )))) AND Count_G52=0) OR
									((((AnclaPacx > anclaCookiex_53-20) AND (AnclaPacx < (anclaCookiex_53+ (12))) ) AND 
									((AnclaPacy > anclaCookiey_53-20)  AND  (AnclaPacy < (anclaCookiey_53+ (22) )))) AND Count_G53=0) OR
									((((AnclaPacx > anclaCookiex_54-20) AND (AnclaPacx < (anclaCookiex_54+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_54-20)  AND  (AnclaPacy < (anclaCookiey_54+ (22) )))) AND Count_G54=0) OR
									((((AnclaPacx > anclaCookiex_55-20) AND (AnclaPacx < (anclaCookiex_55+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_55-20)  AND  (AnclaPacy < (anclaCookiey_55+ (22) )))) AND Count_G55=0) OR
									((((AnclaPacx > anclaCookiex_56-20) AND (AnclaPacx < (anclaCookiex_56+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_56-20)  AND  (AnclaPacy < (anclaCookiey_56+ (22) )))) AND Count_G56=0) OR
									((((AnclaPacx > anclaCookiex_57-20) AND (AnclaPacx < (anclaCookiex_57+ (12))) ) AND 
									((AnclaPacy > anclaCookiey_57-20)  AND  (AnclaPacy < (anclaCookiey_57+ (22) )))) AND Count_G57=0) OR
									((((AnclaPacx > anclaCookiex_58-20) AND (AnclaPacx < (anclaCookiex_58+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_58-20)  AND  (AnclaPacy < (anclaCookiey_58+ (22) )))) AND Count_G58=0) OR
									((((AnclaPacx > anclaCookiex_59-20) AND (AnclaPacx < (anclaCookiex_59+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_59-20)  AND  (AnclaPacy < (anclaCookiey_59+ (22) )))) AND Count_G59=0) OR
									((((AnclaPacx > anclaCookiex_60-20) AND (AnclaPacx < (anclaCookiex_60+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_60-20)  AND  (AnclaPacy < (anclaCookiey_60+ (22) )))) AND Count_G60=0) OR
									((((AnclaPacx > anclaCookiex_61-20) AND (AnclaPacx < (anclaCookiex_61+ (12))) ) AND  
									((AnclaPacy > anclaCookiey_61-20)  AND  (AnclaPacy < (anclaCookiey_61+ (22) )))) AND Count_G61=0) OR
									((((AnclaPacx > anclaCookiex_62-20) AND (AnclaPacx < (anclaCookiex_62+ (12))) ) AND  ((AnclaPacy > anclaCookiey_62-20)  AND  (AnclaPacy < (anclaCookiey_62+ (22) )))) AND Count_G62=0) OR
									((((AnclaPacx > anclaCookiex_63-20) AND (AnclaPacx < (anclaCookiex_63+ (12))) ) AND  ((AnclaPacy > anclaCookiey_63-20)  AND  (AnclaPacy < (anclaCookiey_63+ (22) )))) AND Count_G63=0) OR
									((((AnclaPacx > anclaCookiex_64-20) AND (AnclaPacx < (anclaCookiex_64+ (12))) ) AND  ((AnclaPacy > anclaCookiey_64-20)  AND  (AnclaPacy < (anclaCookiey_64+ (22) )))) AND Count_G64=0) OR
									((((AnclaPacx > anclaCookiex_65-20) AND (AnclaPacx < (anclaCookiex_65+ (12))) ) AND  ((AnclaPacy > anclaCookiey_65-20)  AND  (AnclaPacy < (anclaCookiey_65+ (22) )))) AND Count_G65=0) OR
									((((AnclaPacx > anclaCookiex_66-20) AND (AnclaPacx < (anclaCookiex_66+ (12))) ) AND  ((AnclaPacy > anclaCookiey_66-20)  AND  (AnclaPacy < (anclaCookiey_66+ (22) )))) AND Count_G66=0) OR
									((((AnclaPacx > anclaCookiex_67-20) AND (AnclaPacx < (anclaCookiex_67+ (12))) ) AND  ((AnclaPacy > anclaCookiey_67-20)  AND  (AnclaPacy < (anclaCookiey_67+ (22) )))) AND Count_G67=0) OR
									((((AnclaPacx > anclaCookiex_68-20) AND (AnclaPacx < (anclaCookiex_68+ (12))) ) AND  ((AnclaPacy > anclaCookiey_68-20)  AND  (AnclaPacy < (anclaCookiey_68+ (22) )))) AND Count_G68=0) OR
									((((AnclaPacx > anclaCookiex_69-20) AND (AnclaPacx < (anclaCookiex_69+ (12))) ) AND  ((AnclaPacy > anclaCookiey_69-20)  AND  (AnclaPacy < (anclaCookiey_69+ (22) )))) AND Count_G69=0) OR
									((((AnclaPacx > anclaCookiex_70-20) AND (AnclaPacx < (anclaCookiex_70+ (12))) ) AND  ((AnclaPacy > anclaCookiey_70-20)  AND  (AnclaPacy < (anclaCookiey_70+ (22) )))) AND Count_G70=0) OR
									((((AnclaPacx > anclaCookiex_71-20) AND (AnclaPacx < (anclaCookiex_71+ (12))) ) AND  ((AnclaPacy > anclaCookiey_71-20)  AND  (AnclaPacy < (anclaCookiey_71+ (22) )))) AND Count_G71=0) OR
									((((AnclaPacx > anclaCookiex_72-20) AND (AnclaPacx < (anclaCookiex_72+ (12))) ) AND  ((AnclaPacy > anclaCookiey_72-20)  AND  (AnclaPacy < (anclaCookiey_72+ (22) )))) AND Count_G72=0) OR
									((((AnclaPacx > anclaCookiex_73-20) AND (AnclaPacx < (anclaCookiex_73+ (12))) ) AND  ((AnclaPacy > anclaCookiey_73-20)  AND  (AnclaPacy < (anclaCookiey_73+ (22) )))) AND Count_G73=0) OR
									((((AnclaPacx > anclaCookiex_74-20) AND (AnclaPacx < (anclaCookiex_74+ (12))) ) AND  ((AnclaPacy > anclaCookiey_74-20)  AND  (AnclaPacy < (anclaCookiey_74+ (22) )))) AND Count_G74=0) OR
									((((AnclaPacx > anclaCookiex_75-20) AND (AnclaPacx < (anclaCookiex_75+ (12))) ) AND  ((AnclaPacy > anclaCookiey_75-20)  AND  (AnclaPacy < (anclaCookiey_75+ (22) )))) AND Count_G75=0) OR
									((((AnclaPacx > anclaCookiex_76-20) AND (AnclaPacx < (anclaCookiex_76+ (12))) ) AND  ((AnclaPacy > anclaCookiey_76-20)  AND  (AnclaPacy < (anclaCookiey_76+ (22) )))) AND Count_G76=0) OR
									((((AnclaPacx > anclaCookiex_77-20) AND (AnclaPacx < (anclaCookiex_77+ (12))) ) AND  ((AnclaPacy > anclaCookiey_77-20)  AND  (AnclaPacy < (anclaCookiey_77+ (22) )))) AND Count_G77=0) OR
									((((AnclaPacx > anclaCookiex_78-20) AND (AnclaPacx < (anclaCookiex_78+ (12))) ) AND  ((AnclaPacy > anclaCookiey_78-20)  AND  (AnclaPacy < (anclaCookiey_78+ (22) )))) AND Count_G78=0) OR
									((((AnclaPacx > anclaCookiex_79-20) AND (AnclaPacx < (anclaCookiex_79+ (12))) ) AND  ((AnclaPacy > anclaCookiey_79-20)  AND  (AnclaPacy < (anclaCookiey_79+ (22) )))) AND Count_G79=0) OR
									((((AnclaPacx > anclaCookiex_80-20) AND (AnclaPacx < (anclaCookiex_80+ (12))) ) AND  ((AnclaPacy > anclaCookiey_80-20)  AND  (AnclaPacy < (anclaCookiey_80+ (22) )))) AND Count_G80=0) OR
									((((AnclaPacx > anclaCookiex_81-20) AND (AnclaPacx < (anclaCookiex_81+ (12))) ) AND  ((AnclaPacy > anclaCookiey_81-20)  AND  (AnclaPacy < (anclaCookiey_81+ (22) )))) AND Count_G81=0) OR
									((((AnclaPacx > anclaCookiex_82-20) AND (AnclaPacx < (anclaCookiex_82+ (12))) ) AND  ((AnclaPacy > anclaCookiey_82-20)  AND  (AnclaPacy < (anclaCookiey_82+ (22) )))) AND Count_G82=0) OR
									((((AnclaPacx > anclaCookiex_83-20) AND (AnclaPacx < (anclaCookiex_83+ (12))) ) AND  ((AnclaPacy > anclaCookiey_83-20)  AND  (AnclaPacy < (anclaCookiey_83+ (22) )))) AND Count_G83=0) OR
									((((AnclaPacx > anclaCookiex_84-20) AND (AnclaPacx < (anclaCookiex_84+ (12))) ) AND  ((AnclaPacy > anclaCookiey_84-20)  AND  (AnclaPacy < (anclaCookiey_84+ (22) )))) AND Count_G84=0) OR
									((((AnclaPacx > anclaCookiex_85-20) AND (AnclaPacx < (anclaCookiex_85+ (12))) ) AND  ((AnclaPacy > anclaCookiey_85-20)  AND  (AnclaPacy < (anclaCookiey_85+ (22) )))) AND Count_G85=0) OR
									((((AnclaPacx > anclaCookiex_86-20) AND (AnclaPacx < (anclaCookiex_86+ (12))) ) AND  ((AnclaPacy > anclaCookiey_86-20)  AND  (AnclaPacy < (anclaCookiey_86+ (22) )))) AND Count_G86=0) OR
									((((AnclaPacx > anclaCookiex_87-20) AND (AnclaPacx < (anclaCookiex_87+ (12))) ) AND  ((AnclaPacy > anclaCookiey_87-20)  AND  (AnclaPacy < (anclaCookiey_87+ (22) )))) AND Count_G87=0) OR
									((((AnclaPacx > anclaCookiex_88-20) AND (AnclaPacx < (anclaCookiex_88+ (12))) ) AND  ((AnclaPacy > anclaCookiey_88-20)  AND  (AnclaPacy < (anclaCookiey_88+ (22) )))) AND Count_G88=0) OR
									((((AnclaPacx > anclaCookiex_89-20) AND (AnclaPacx < (anclaCookiex_89+ (12))) ) AND  ((AnclaPacy > anclaCookiey_89-20)  AND  (AnclaPacy < (anclaCookiey_89+ (22) )))) AND Count_G89=0) OR
									((((AnclaPacx > anclaCookiex_90-20) AND (AnclaPacx < (anclaCookiex_90+ (12))) ) AND  ((AnclaPacy > anclaCookiey_90-20)  AND  (AnclaPacy < (anclaCookiey_90+ (22) )))) AND Count_G90=0) OR
									((((AnclaPacx > anclaCookiex_91-20) AND (AnclaPacx < (anclaCookiex_91+ (12))) ) AND  ((AnclaPacy > anclaCookiey_91-20)  AND  (AnclaPacy < (anclaCookiey_91+ (22) )))) AND Count_G91=0) OR
									((((AnclaPacx > anclaCookiex_92-20) AND (AnclaPacx < (anclaCookiex_92+ (12))) ) AND  ((AnclaPacy > anclaCookiey_92-20)  AND  (AnclaPacy < (anclaCookiey_92+ (22) )))) AND Count_G92=0) OR
									((((AnclaPacx > anclaCookiex_93-20) AND (AnclaPacx < (anclaCookiex_93+ (12))) ) AND  ((AnclaPacy > anclaCookiey_93-20)  AND  (AnclaPacy < (anclaCookiey_93+ (22) )))) AND Count_G93=0) OR
									((((AnclaPacx > anclaCookiex_94-20) AND (AnclaPacx < (anclaCookiex_94+ (12))) ) AND  ((AnclaPacy > anclaCookiey_94-20)  AND  (AnclaPacy < (anclaCookiey_94+ (22) )))) AND Count_G94=0) OR
									((((AnclaPacx > anclaCookiex_95-20) AND (AnclaPacx < (anclaCookiex_95+ (12))) ) AND  ((AnclaPacy > anclaCookiey_95-20)  AND  (AnclaPacy < (anclaCookiey_95+ (22) )))) AND Count_G95=0) OR
									((((AnclaPacx > anclaCookiex_96-20) AND (AnclaPacx < (anclaCookiex_96+ (12))) ) AND  ((AnclaPacy > anclaCookiey_96-20)  AND  (AnclaPacy < (anclaCookiey_96+ (22) )))) AND Count_G96=0) OR
									((((AnclaPacx > anclaCookiex_97-20) AND (AnclaPacx < (anclaCookiex_97+ (12))) ) AND  ((AnclaPacy > anclaCookiey_97-20)  AND  (AnclaPacy < (anclaCookiey_97+ (22) )))) AND Count_G97=0) OR
									((((AnclaPacx > anclaCookiex_98-20) AND (AnclaPacx < (anclaCookiex_98+ (12))) ) AND  ((AnclaPacy > anclaCookiey_98-20)  AND  (AnclaPacy < (anclaCookiey_98+ (22) )))) AND Count_G98=0) OR
									((((AnclaPacx > anclaCookiex_99-20) AND (AnclaPacx < (anclaCookiex_99+ (12))) ) AND  ((AnclaPacy > anclaCookiey_99-20)  AND  (AnclaPacy < (anclaCookiey_99+ (22) )))) AND Count_G99=0)) AND End_Game='0' AND Start_signal='1') ELSE
									'0';
	
	
	Score_PACMAN: PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			Score <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (Score_temp = '1') THEN
				Score <= STD_LOGIC_VECTOR(UNSIGNED(Score)+1) ;
			ELSE
				Score <= Score;
		   END IF;
	   END IF;

	END PROCESS Score_PACMAN;
	
	-----------------------------------------------------------------------------------------------------------------------------
	--===========================================================================================================================
	--  END LOGIC
	--===========================================================================================================================
	End_Game <= '1'   WHEN ((((anclaGhostx > anclaPacx-20) AND (anclaGhostx < (anclaPacx+ (20))) ) AND 
									((anclaGhosty > anclaPacy-20)  AND  (anclaGhosty< (anclaPacy + (20) )))) AND Count_End_Game=0) ELSE
					'1'   WHEN  Count_End_Game=1 ELSE
               '0';
	
   End_G: PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			Count_End_Game <= 0;
		ELSIF (rising_edge(clk)) THEN
			IF (Count_End_Game = 0 AND End_Game = '1') THEN
				Count_End_Game <= 1;
			ELSIF(Count_End_Game = 1) THEN
			   Count_End_Game <= Count_End_Game;
		   END IF;
	   END IF;

	END PROCESS End_G;
	

	----------------------------------------------------------------------------------------------
	--********************************************************************************************
	----------------------------------------------------------------------------------------------
	Inicio_screen <= 1 WHEN (( (pixel_x_s1 >= anclaWelcomex) AND (pixel_x_s1 < (anclaWelcomex+324)) ) AND 
	                         ( (pixel_y_s1 >= anclaWelcomey AND pixel_y_s1 < (anclaWelcomey+ 200)) )AND 
									    Start_signal = '0'AND End_Game='0') ELSE
	                 0;
	Fin_screen    <= 1 WHEN (( (pixel_x_s1 >= anclaEndGamex) AND (pixel_x_s1 < (anclaEndGamex+240)) ) AND 
	                           ( (pixel_y_s1 >= anclaEndGamey AND pixel_y_s1 < (anclaEndGamey + 36)) )  AND 
										Start_signal = '1' AND End_Game = '1') ELSE
	                 0;
	
	PrioriImg <= 1 WHEN (( (pixel_x_s1 >= anclaBlockx+2) AND (pixel_x_s1 < (AnclaBlockx+255)) ) AND 
	                    ( (pixel_y_s1 >= AnclaBlocky) AND (pixel_y_s1 < (AnclaBlocky+ 480)) ) AND 
							    Start_signal = '1'AND End_Game='0')     ELSE
					 2 WHEN (( (pixel_x_s1 >= AnclaBlockx_L+2) AND (pixel_x_s1 < (AnclaBlockx_L+255)) ) 
					        AND ( (pixel_y_s1 >= AnclaBlocky_L AND pixel_y_s1 < (AnclaBlocky_L+ 480)) ) AND
							  Start_signal = '1'AND End_Game='0') ELSE
					 0 ;
					 
					
					 
	Personajes <= 1 WHEN (( (pixel_x_s1 >= AnclaPacx)   AND (pixel_x_s1 < (AnclaPacx+20)) ) AND ((pixel_y_s1 >= AnclaPacy) AND (pixel_y_s1 < (AnclaPacy + 20)) )) ELSE --
					  2 WHEN (( (pixel_x_s1 >= anclaGhostx) AND (pixel_x_s1 < (anclaGhostx+20)) ) AND ((pixel_y_s1 >= anclaGhosty) AND (pixel_y_s1 < (anclaGhosty+ 20)) ))ELSE
					  3 WHEN (( (pixel_x_s1 >= anclaCookiex_1) AND (pixel_x_s1 < (anclaCookiex_1+16)) ) AND ((pixel_y_s1 >= anclaCookiey_1) AND (pixel_y_s1 < (anclaCookiey_1+ 16)) ))ELSE
					  4 WHEN (( (pixel_x_s1 >= anclaCookiex_2) AND (pixel_x_s1 < (anclaCookiex_2+16)) ) AND ((pixel_y_s1 >= anclaCookiey_2) AND (pixel_y_s1 < (anclaCookiey_2+ 16)) ))ELSE
					  5 WHEN (( (pixel_x_s1 >= anclaCookiex_3) AND (pixel_x_s1 < (anclaCookiex_3+16)) ) AND ((pixel_y_s1 >= anclaCookiey_3) AND (pixel_y_s1 < (anclaCookiey_3+ 16)) ))ELSE
					  6 WHEN (( (pixel_x_s1 >= anclaCookiex_4) AND (pixel_x_s1 < (anclaCookiex_4+16)) ) AND ((pixel_y_s1 >= anclaCookiey_4) AND (pixel_y_s1 < (anclaCookiey_4+ 16)) ))ELSE
					  7 WHEN (( (pixel_x_s1 >= anclaCookiex_5) AND (pixel_x_s1 < (anclaCookiex_5+16)) ) AND ((pixel_y_s1 >= anclaCookiey_5) AND (pixel_y_s1 < (anclaCookiey_5+ 16)) ))ELSE
					  8 WHEN (( (pixel_x_s1 >= anclaCookiex_6) AND (pixel_x_s1 < (anclaCookiex_6+16)) ) AND ((pixel_y_s1 >= anclaCookiey_6) AND (pixel_y_s1 < (anclaCookiey_6+ 16)) ))ELSE
					  9 WHEN (( (pixel_x_s1 >= anclaCookiex_7) AND (pixel_x_s1 < (anclaCookiex_7+16)) ) AND ((pixel_y_s1 >= anclaCookiey_7) AND (pixel_y_s1 < (anclaCookiey_7+ 16)) ))ELSE
					  10 WHEN (( (pixel_x_s1 >= anclaCookiex_8) AND (pixel_x_s1 < (anclaCookiex_8+16)) ) AND ((pixel_y_s1 >= anclaCookiey_8) AND (pixel_y_s1 < (anclaCookiey_8+ 16)) ))ELSE
					  11 WHEN (( (pixel_x_s1 >= anclaCookiex_9) AND (pixel_x_s1 < (anclaCookiex_9+16)) ) AND ((pixel_y_s1 >= anclaCookiey_9) AND (pixel_y_s1 < (anclaCookiey_9+ 16)) ))ELSE
					  12 WHEN (( (pixel_x_s1 >= anclaCookiex_10) AND (pixel_x_s1 < (anclaCookiex_10+16)) ) AND ((pixel_y_s1 >= anclaCookiey_10) AND (pixel_y_s1 < (anclaCookiey_10+ 16)) ))ELSE
					  13 WHEN (( (pixel_x_s1 >= anclaCookiex_11) AND (pixel_x_s1 < (anclaCookiex_11+16)) ) AND ((pixel_y_s1 >= anclaCookiey_11) AND (pixel_y_s1 < (anclaCookiey_11+ 16)) ))ELSE
					  14 WHEN (( (pixel_x_s1 >= anclaCookiex_12) AND (pixel_x_s1 < (anclaCookiex_12+16)) ) AND ((pixel_y_s1 >= anclaCookiey_12) AND (pixel_y_s1 < (anclaCookiey_12+ 16)) ))ELSE
					  15 WHEN (( (pixel_x_s1 >= anclaCookiex_13) AND (pixel_x_s1 < (anclaCookiex_13+16)) ) AND ((pixel_y_s1 >= anclaCookiey_13) AND (pixel_y_s1 < (anclaCookiey_13+ 16)) ))ELSE
					  16 WHEN (( (pixel_x_s1 >= anclaCookiex_14) AND (pixel_x_s1 < (anclaCookiex_14+16)) ) AND ((pixel_y_s1 >= anclaCookiey_14) AND (pixel_y_s1 < (anclaCookiey_14+ 16)) ))ELSE
					  17 WHEN (( (pixel_x_s1 >= anclaCookiex_15) AND (pixel_x_s1 < (anclaCookiex_15+16)) ) AND ((pixel_y_s1 >= anclaCookiey_15) AND (pixel_y_s1 < (anclaCookiey_15+ 16)) ))ELSE
					  18 WHEN (( (pixel_x_s1 >= anclaCookiex_16) AND (pixel_x_s1 < (anclaCookiex_16+16)) ) AND ((pixel_y_s1 >= anclaCookiey_16) AND (pixel_y_s1 < (anclaCookiey_16+ 16)) ))ELSE
					  19 WHEN (( (pixel_x_s1 >= anclaCookiex_17) AND (pixel_x_s1 < (anclaCookiex_17+16)) ) AND ((pixel_y_s1 >= anclaCookiey_17) AND (pixel_y_s1 < (anclaCookiey_17+ 16)) ))ELSE
					  20 WHEN (( (pixel_x_s1 >= anclaCookiex_18) AND (pixel_x_s1 < (anclaCookiex_18+16)) ) AND ((pixel_y_s1 >= anclaCookiey_18) AND (pixel_y_s1 < (anclaCookiey_18+ 16)) ))ELSE
					  21 WHEN (( (pixel_x_s1 >= anclaCookiex_19) AND (pixel_x_s1 < (anclaCookiex_19+16)) ) AND ((pixel_y_s1 >= anclaCookiey_19) AND (pixel_y_s1 < (anclaCookiey_19+ 16)) ))ELSE
					  22 WHEN (( (pixel_x_s1 >= anclaCookiex_20) AND (pixel_x_s1 < (anclaCookiex_20+16)) ) AND ((pixel_y_s1 >= anclaCookiey_20) AND (pixel_y_s1 < (anclaCookiey_20+ 16)) ))ELSE
					  23 WHEN (( (pixel_x_s1 >= anclaCookiex_21) AND (pixel_x_s1 < (anclaCookiex_21+16)) ) AND ((pixel_y_s1 >= anclaCookiey_21) AND (pixel_y_s1 < (anclaCookiey_21+ 16)) ))ELSE
					  24 WHEN (( (pixel_x_s1 >= anclaCookiex_22) AND (pixel_x_s1 < (anclaCookiex_22+16)) ) AND ((pixel_y_s1 >= anclaCookiey_22) AND (pixel_y_s1 < (anclaCookiey_22+ 16)) ))ELSE
					  25 WHEN (( (pixel_x_s1 >= anclaCookiex_23) AND (pixel_x_s1 < (anclaCookiex_23+16)) ) AND ((pixel_y_s1 >= anclaCookiey_23) AND (pixel_y_s1 < (anclaCookiey_23+ 16)) ))ELSE
					  26 WHEN (( (pixel_x_s1 >= anclaCookiex_24) AND (pixel_x_s1 < (anclaCookiex_24+16)) ) AND ((pixel_y_s1 >= anclaCookiey_24) AND (pixel_y_s1 < (anclaCookiey_24+ 16)) ))ELSE
					  27 WHEN (( (pixel_x_s1 >= anclaCookiex_25) AND (pixel_x_s1 < (anclaCookiex_25+16)) ) AND ((pixel_y_s1 >= anclaCookiey_25) AND (pixel_y_s1 < (anclaCookiey_25+ 16)) ))ELSE
					  28 WHEN (( (pixel_x_s1 >= anclaCookiex_26) AND (pixel_x_s1 < (anclaCookiex_26+16)) ) AND ((pixel_y_s1 >= anclaCookiey_26) AND (pixel_y_s1 < (anclaCookiey_26+ 16)) ))ELSE
					  29 WHEN (( (pixel_x_s1 >= anclaCookiex_27) AND (pixel_x_s1 < (anclaCookiex_27+16)) ) AND ((pixel_y_s1 >= anclaCookiey_27) AND (pixel_y_s1 < (anclaCookiey_27+ 16)) ))ELSE
					  30 WHEN (( (pixel_x_s1 >= anclaCookiex_28) AND (pixel_x_s1 < (anclaCookiex_28+16)) ) AND ((pixel_y_s1 >= anclaCookiey_28) AND (pixel_y_s1 < (anclaCookiey_28+ 16)) ))ELSE
					  31 WHEN (( (pixel_x_s1 >= anclaCookiex_29) AND (pixel_x_s1 < (anclaCookiex_29+16)) ) AND ((pixel_y_s1 >= anclaCookiey_29) AND (pixel_y_s1 < (anclaCookiey_29+ 16)) ))ELSE
					  32 WHEN (( (pixel_x_s1 >= anclaCookiex_30) AND (pixel_x_s1 < (anclaCookiex_30+16)) ) AND ((pixel_y_s1 >= anclaCookiey_30) AND (pixel_y_s1 < (anclaCookiey_30+ 16)) ))ELSE
					  33 WHEN (( (pixel_x_s1 >= anclaCookiex_31) AND (pixel_x_s1 < (anclaCookiex_31+16)) ) AND ((pixel_y_s1 >= anclaCookiey_31) AND (pixel_y_s1 < (anclaCookiey_31+ 16)) ))ELSE
					  34 WHEN (( (pixel_x_s1 >= anclaCookiex_32) AND (pixel_x_s1 < (anclaCookiex_32+16)) ) AND ((pixel_y_s1 >= anclaCookiey_32) AND (pixel_y_s1 < (anclaCookiey_32+ 16)) ))ELSE
					  35 WHEN (( (pixel_x_s1 >= anclaCookiex_33) AND (pixel_x_s1 < (anclaCookiex_33+16)) ) AND ((pixel_y_s1 >= anclaCookiey_33) AND (pixel_y_s1 < (anclaCookiey_33+ 16)) ))ELSE
					  36 WHEN (( (pixel_x_s1 >= anclaCookiex_34) AND (pixel_x_s1 < (anclaCookiex_34+16)) ) AND ((pixel_y_s1 >= anclaCookiey_34) AND (pixel_y_s1 < (anclaCookiey_34+ 16)) ))ELSE
                 37 WHEN (( (pixel_x_s1 >= anclaCookiex_35) AND (pixel_x_s1 < (anclaCookiex_35+16)) ) AND ((pixel_y_s1 >= anclaCookiey_35) AND (pixel_y_s1 < (anclaCookiey_35+ 16)) ))ELSE
					  38 WHEN (( (pixel_x_s1 >= anclaCookiex_36) AND (pixel_x_s1 < (anclaCookiex_36+16)) ) AND ((pixel_y_s1 >= anclaCookiey_36) AND (pixel_y_s1 < (anclaCookiey_36+ 16)) ))ELSE
					  39 WHEN (( (pixel_x_s1 >= anclaCookiex_37) AND (pixel_x_s1 < (anclaCookiex_37+16)) ) AND ((pixel_y_s1 >= anclaCookiey_37) AND (pixel_y_s1 < (anclaCookiey_37+ 16)) ))ELSE
					  40 WHEN (( (pixel_x_s1 >= anclaCookiex_38) AND (pixel_x_s1 < (anclaCookiex_38+16)) ) AND ((pixel_y_s1 >= anclaCookiey_38) AND (pixel_y_s1 < (anclaCookiey_38+ 16)) ))ELSE
                 41 WHEN (( (pixel_x_s1 >= anclaCookiex_39) AND (pixel_x_s1 < (anclaCookiex_39+16)) ) AND ((pixel_y_s1 >= anclaCookiey_39) AND (pixel_y_s1 < (anclaCookiey_39+ 16)) ))ELSE
					  42 WHEN(( ( pixel_x_s1 >= anclaCookiex_40) AND ( pixel_x_s1 < (anclaCookiex_40+16)) ) AND (( pixel_y_s1 >= anclaCookiey_40) AND (pixel_y_s1 < (anclaCookiey_40+ 16 )) )) ELSE									
						43 WHEN(( ( pixel_x_s1 >= anclaCookiex_41) AND ( pixel_x_s1 < (anclaCookiex_41+16)) ) AND (( pixel_y_s1 >= anclaCookiey_41) AND (pixel_y_s1 < (anclaCookiey_41+ 16 )) )) ELSE									
						44 WHEN(( ( pixel_x_s1 >= anclaCookiex_42) AND ( pixel_x_s1 < (anclaCookiex_42+16)) ) AND (( pixel_y_s1 >= anclaCookiey_42) AND (pixel_y_s1 < (anclaCookiey_42+ 16 )) )) ELSE									
						45 WHEN(( ( pixel_x_s1 >= anclaCookiex_43) AND ( pixel_x_s1 < (anclaCookiex_43+16)) ) AND (( pixel_y_s1 >= anclaCookiey_43) AND (pixel_y_s1 < (anclaCookiey_43+ 16 )) )) ELSE									
						46 WHEN(( ( pixel_x_s1 >= anclaCookiex_44) AND ( pixel_x_s1 < (anclaCookiex_44+16)) ) AND (( pixel_y_s1 >= anclaCookiey_44) AND (pixel_y_s1 < (anclaCookiey_44+ 16 )) )) ELSE									
						47 WHEN(( ( pixel_x_s1 >= anclaCookiex_45) AND ( pixel_x_s1 < (anclaCookiex_45+16)) ) AND (( pixel_y_s1 >= anclaCookiey_45) AND (pixel_y_s1 < (anclaCookiey_45+ 16 )) )) ELSE									
						48 WHEN(( ( pixel_x_s1 >= anclaCookiex_46) AND ( pixel_x_s1 < (anclaCookiex_46+16)) ) AND (( pixel_y_s1 >= anclaCookiey_46) AND (pixel_y_s1 < (anclaCookiey_46+ 16 )) )) ELSE									
						49 WHEN(( ( pixel_x_s1 >= anclaCookiex_47) AND ( pixel_x_s1 < (anclaCookiex_47+16)) ) AND (( pixel_y_s1 >= anclaCookiey_47) AND (pixel_y_s1 < (anclaCookiey_47+ 16 )) )) ELSE									
						50 WHEN(( ( pixel_x_s1 >= anclaCookiex_48) AND ( pixel_x_s1 < (anclaCookiex_48+16)) ) AND (( pixel_y_s1 >= anclaCookiey_48) AND (pixel_y_s1 < (anclaCookiey_48+ 16 )) )) ELSE									
						51 WHEN(( ( pixel_x_s1 >= anclaCookiex_49) AND ( pixel_x_s1 < (anclaCookiex_49+16)) ) AND (( pixel_y_s1 >= anclaCookiey_49) AND (pixel_y_s1 < (anclaCookiey_49+ 16 )) )) ELSE									
						52 WHEN(( ( pixel_x_s1 >= anclaCookiex_50) AND ( pixel_x_s1 < (anclaCookiex_50+16)) ) AND (( pixel_y_s1 >= anclaCookiey_50) AND (pixel_y_s1 < (anclaCookiey_50+ 16 )) )) ELSE									
						53 WHEN(( ( pixel_x_s1 >= anclaCookiex_51) AND ( pixel_x_s1 < (anclaCookiex_51+16)) ) AND (( pixel_y_s1 >= anclaCookiey_51) AND (pixel_y_s1 < (anclaCookiey_51+ 16 )) )) ELSE									
						54 WHEN(( ( pixel_x_s1 >= anclaCookiex_52) AND ( pixel_x_s1 < (anclaCookiex_52+16)) ) AND (( pixel_y_s1 >= anclaCookiey_52) AND (pixel_y_s1 < (anclaCookiey_52+ 16 )) )) ELSE									
						55 WHEN(( ( pixel_x_s1 >= anclaCookiex_53) AND ( pixel_x_s1 < (anclaCookiex_53+16)) ) AND (( pixel_y_s1 >= anclaCookiey_53) AND (pixel_y_s1 < (anclaCookiey_53+ 16 )) )) ELSE									
						56 WHEN(( ( pixel_x_s1 >= anclaCookiex_54) AND ( pixel_x_s1 < (anclaCookiex_54+16)) ) AND (( pixel_y_s1 >= anclaCookiey_54) AND (pixel_y_s1 < (anclaCookiey_54+ 16 )) )) ELSE									
						57 WHEN(( ( pixel_x_s1 >= anclaCookiex_55) AND ( pixel_x_s1 < (anclaCookiex_55+16)) ) AND (( pixel_y_s1 >= anclaCookiey_55) AND (pixel_y_s1 < (anclaCookiey_55+ 16 )) )) ELSE									
						58 WHEN(( ( pixel_x_s1 >= anclaCookiex_56) AND ( pixel_x_s1 < (anclaCookiex_56+16)) ) AND (( pixel_y_s1 >= anclaCookiey_56) AND (pixel_y_s1 < (anclaCookiey_56+ 16 )) )) ELSE									
						59 WHEN(( ( pixel_x_s1 >= anclaCookiex_57) AND ( pixel_x_s1 < (anclaCookiex_57+16)) ) AND (( pixel_y_s1 >= anclaCookiey_57) AND (pixel_y_s1 < (anclaCookiey_57+ 16 )) )) ELSE									
						60 WHEN(( ( pixel_x_s1 >= anclaCookiex_58) AND ( pixel_x_s1 < (anclaCookiex_58+16)) ) AND (( pixel_y_s1 >= anclaCookiey_58) AND (pixel_y_s1 < (anclaCookiey_58+ 16 )) )) ELSE									
						61 WHEN(( ( pixel_x_s1 >= anclaCookiex_59) AND ( pixel_x_s1 < (anclaCookiex_59+16)) ) AND (( pixel_y_s1 >= anclaCookiey_59) AND (pixel_y_s1 < (anclaCookiey_59+ 16 )) )) ELSE									
						62 WHEN(( ( pixel_x_s1 >= anclaCookiex_60) AND ( pixel_x_s1 < (anclaCookiex_60+16)) ) AND (( pixel_y_s1 >= anclaCookiey_60) AND (pixel_y_s1 < (anclaCookiey_60+ 16 )) )) ELSE									
						63 WHEN(( ( pixel_x_s1 >= anclaCookiex_61) AND ( pixel_x_s1 < (anclaCookiex_61+16)) ) AND (( pixel_y_s1 >= anclaCookiey_61) AND (pixel_y_s1 < (anclaCookiey_61+ 16 )) )) ELSE									
						64 WHEN(( ( pixel_x_s1 >= anclaCookiex_62) AND ( pixel_x_s1 < (anclaCookiex_62+16)) ) AND (( pixel_y_s1 >= anclaCookiey_62) AND (pixel_y_s1 < (anclaCookiey_62+ 16 )) )) ELSE									
						65 WHEN(( ( pixel_x_s1 >= anclaCookiex_63) AND ( pixel_x_s1 < (anclaCookiex_63+16)) ) AND (( pixel_y_s1 >= anclaCookiey_63) AND (pixel_y_s1 < (anclaCookiey_63+ 16 )) )) ELSE									
						66 WHEN(( ( pixel_x_s1 >= anclaCookiex_64) AND ( pixel_x_s1 < (anclaCookiex_64+16)) ) AND (( pixel_y_s1 >= anclaCookiey_64) AND (pixel_y_s1 < (anclaCookiey_64+ 16 )) )) ELSE									
						67 WHEN(( ( pixel_x_s1 >= anclaCookiex_65) AND ( pixel_x_s1 < (anclaCookiex_65+16)) ) AND (( pixel_y_s1 >= anclaCookiey_65) AND (pixel_y_s1 < (anclaCookiey_65+ 16 )) )) ELSE									
						68 WHEN(( ( pixel_x_s1 >= anclaCookiex_66) AND ( pixel_x_s1 < (anclaCookiex_66+16)) ) AND (( pixel_y_s1 >= anclaCookiey_66) AND (pixel_y_s1 < (anclaCookiey_66+ 16 )) )) ELSE									
						69 WHEN(( ( pixel_x_s1 >= anclaCookiex_67) AND ( pixel_x_s1 < (anclaCookiex_67+16)) ) AND (( pixel_y_s1 >= anclaCookiey_67) AND (pixel_y_s1 < (anclaCookiey_67+ 16 )) )) ELSE									
						70 WHEN(( ( pixel_x_s1 >= anclaCookiex_68) AND ( pixel_x_s1 < (anclaCookiex_68+16)) ) AND (( pixel_y_s1 >= anclaCookiey_68) AND (pixel_y_s1 < (anclaCookiey_68+ 16 )) )) ELSE									
						71 WHEN(( ( pixel_x_s1 >= anclaCookiex_69) AND ( pixel_x_s1 < (anclaCookiex_69+16)) ) AND (( pixel_y_s1 >= anclaCookiey_69) AND (pixel_y_s1 < (anclaCookiey_69+ 16 )) )) ELSE									
						72 WHEN(( ( pixel_x_s1 >= anclaCookiex_70) AND ( pixel_x_s1 < (anclaCookiex_70+16)) ) AND (( pixel_y_s1 >= anclaCookiey_70) AND (pixel_y_s1 < (anclaCookiey_70+ 16 )) )) ELSE									
						73 WHEN(( ( pixel_x_s1 >= anclaCookiex_71) AND ( pixel_x_s1 < (anclaCookiex_71+16)) ) AND (( pixel_y_s1 >= anclaCookiey_71) AND (pixel_y_s1 < (anclaCookiey_71+ 16 )) )) ELSE									
						74 WHEN(( ( pixel_x_s1 >= anclaCookiex_72) AND ( pixel_x_s1 < (anclaCookiex_72+16)) ) AND (( pixel_y_s1 >= anclaCookiey_72) AND (pixel_y_s1 < (anclaCookiey_72+ 16 )) )) ELSE									
						75 WHEN(( ( pixel_x_s1 >= anclaCookiex_73) AND ( pixel_x_s1 < (anclaCookiex_73+16)) ) AND (( pixel_y_s1 >= anclaCookiey_73) AND (pixel_y_s1 < (anclaCookiey_73+ 16 )) )) ELSE									
						76 WHEN(( ( pixel_x_s1 >= anclaCookiex_74) AND ( pixel_x_s1 < (anclaCookiex_74+16)) ) AND (( pixel_y_s1 >= anclaCookiey_74) AND (pixel_y_s1 < (anclaCookiey_74+ 16 )) )) ELSE									
						77 WHEN(( ( pixel_x_s1 >= anclaCookiex_75) AND ( pixel_x_s1 < (anclaCookiex_75+16)) ) AND (( pixel_y_s1 >= anclaCookiey_75) AND (pixel_y_s1 < (anclaCookiey_75+ 16 )) )) ELSE									
						78 WHEN(( ( pixel_x_s1 >= anclaCookiex_76) AND ( pixel_x_s1 < (anclaCookiex_76+16)) ) AND (( pixel_y_s1 >= anclaCookiey_76) AND (pixel_y_s1 < (anclaCookiey_76+ 16 )) )) ELSE									
						79 WHEN(( ( pixel_x_s1 >= anclaCookiex_77) AND ( pixel_x_s1 < (anclaCookiex_77+16)) ) AND (( pixel_y_s1 >= anclaCookiey_77) AND (pixel_y_s1 < (anclaCookiey_77+ 16 )) )) ELSE									
						80 WHEN(( ( pixel_x_s1 >= anclaCookiex_78) AND ( pixel_x_s1 < (anclaCookiex_78+16)) ) AND (( pixel_y_s1 >= anclaCookiey_78) AND (pixel_y_s1 < (anclaCookiey_78+ 16 )) )) ELSE									
						81 WHEN(( ( pixel_x_s1 >= anclaCookiex_79) AND ( pixel_x_s1 < (anclaCookiex_79+16)) ) AND (( pixel_y_s1 >= anclaCookiey_79) AND (pixel_y_s1 < (anclaCookiey_79+ 16 )) )) ELSE									
						82 WHEN(( ( pixel_x_s1 >= anclaCookiex_80) AND ( pixel_x_s1 < (anclaCookiex_80+16)) ) AND (( pixel_y_s1 >= anclaCookiey_80) AND (pixel_y_s1 < (anclaCookiey_80+ 16 )) )) ELSE									
						83 WHEN(( ( pixel_x_s1 >= anclaCookiex_81) AND ( pixel_x_s1 < (anclaCookiex_81+16)) ) AND (( pixel_y_s1 >= anclaCookiey_81) AND (pixel_y_s1 < (anclaCookiey_81+ 16 )) )) ELSE									
						84 WHEN(( ( pixel_x_s1 >= anclaCookiex_82) AND ( pixel_x_s1 < (anclaCookiex_82+16)) ) AND (( pixel_y_s1 >= anclaCookiey_82) AND (pixel_y_s1 < (anclaCookiey_82+ 16 )) )) ELSE									
						85 WHEN(( ( pixel_x_s1 >= anclaCookiex_83) AND ( pixel_x_s1 < (anclaCookiex_83+16)) ) AND (( pixel_y_s1 >= anclaCookiey_83) AND (pixel_y_s1 < (anclaCookiey_83+ 16 )) )) ELSE									
						86 WHEN(( ( pixel_x_s1 >= anclaCookiex_84) AND ( pixel_x_s1 < (anclaCookiex_84+16)) ) AND (( pixel_y_s1 >= anclaCookiey_84) AND (pixel_y_s1 < (anclaCookiey_84+ 16 )) )) ELSE									
						87 WHEN(( ( pixel_x_s1 >= anclaCookiex_85) AND ( pixel_x_s1 < (anclaCookiex_85+16)) ) AND (( pixel_y_s1 >= anclaCookiey_85) AND (pixel_y_s1 < (anclaCookiey_85+ 16 )) )) ELSE									
						88 WHEN(( ( pixel_x_s1 >= anclaCookiex_86) AND ( pixel_x_s1 < (anclaCookiex_86+16)) ) AND (( pixel_y_s1 >= anclaCookiey_86) AND (pixel_y_s1 < (anclaCookiey_86+ 16 )) )) ELSE									
						89 WHEN(( ( pixel_x_s1 >= anclaCookiex_87) AND ( pixel_x_s1 < (anclaCookiex_87+16)) ) AND (( pixel_y_s1 >= anclaCookiey_87) AND (pixel_y_s1 < (anclaCookiey_87+ 16 )) )) ELSE									
						90 WHEN(( ( pixel_x_s1 >= anclaCookiex_88) AND ( pixel_x_s1 < (anclaCookiex_88+16)) ) AND (( pixel_y_s1 >= anclaCookiey_88) AND (pixel_y_s1 < (anclaCookiey_88+ 16 )) )) ELSE									
						91 WHEN(( ( pixel_x_s1 >= anclaCookiex_89) AND ( pixel_x_s1 < (anclaCookiex_89+16)) ) AND (( pixel_y_s1 >= anclaCookiey_89) AND (pixel_y_s1 < (anclaCookiey_89+ 16 )) )) ELSE									
						92 WHEN(( ( pixel_x_s1 >= anclaCookiex_90) AND ( pixel_x_s1 < (anclaCookiex_90+16)) ) AND (( pixel_y_s1 >= anclaCookiey_90) AND (pixel_y_s1 < (anclaCookiey_90+ 16 )) )) ELSE									
						93 WHEN(( ( pixel_x_s1 >= anclaCookiex_91) AND ( pixel_x_s1 < (anclaCookiex_91+16)) ) AND (( pixel_y_s1 >= anclaCookiey_91) AND (pixel_y_s1 < (anclaCookiey_91+ 16 )) )) ELSE									
						94 WHEN(( ( pixel_x_s1 >= anclaCookiex_92) AND ( pixel_x_s1 < (anclaCookiex_92+16)) ) AND (( pixel_y_s1 >= anclaCookiey_92) AND (pixel_y_s1 < (anclaCookiey_92+ 16 )) )) ELSE									
						95 WHEN(( ( pixel_x_s1 >= anclaCookiex_93) AND ( pixel_x_s1 < (anclaCookiex_93+16)) ) AND (( pixel_y_s1 >= anclaCookiey_93) AND (pixel_y_s1 < (anclaCookiey_93+ 16 )) )) ELSE									
						96 WHEN(( ( pixel_x_s1 >= anclaCookiex_94) AND ( pixel_x_s1 < (anclaCookiex_94+16)) ) AND (( pixel_y_s1 >= anclaCookiey_94) AND (pixel_y_s1 < (anclaCookiey_94+ 16 )) )) ELSE									
						97 WHEN(( ( pixel_x_s1 >= anclaCookiex_95) AND ( pixel_x_s1 < (anclaCookiex_95+16)) ) AND (( pixel_y_s1 >= anclaCookiey_95) AND (pixel_y_s1 < (anclaCookiey_95+ 16 )) )) ELSE									
						98 WHEN(( ( pixel_x_s1 >= anclaCookiex_96) AND ( pixel_x_s1 < (anclaCookiex_96+16)) ) AND (( pixel_y_s1 >= anclaCookiey_96) AND (pixel_y_s1 < (anclaCookiey_96+ 16 )) )) ELSE									
						99 WHEN(( ( pixel_x_s1 >= anclaCookiex_97) AND ( pixel_x_s1 < (anclaCookiex_97+16)) ) AND (( pixel_y_s1 >= anclaCookiey_97) AND (pixel_y_s1 < (anclaCookiey_97+ 16 )) )) ELSE									
						100 WHEN(( ( pixel_x_s1 >= anclaCookiex_98) AND ( pixel_x_s1 < (anclaCookiex_98+16)) ) AND (( pixel_y_s1 >= anclaCookiey_98) AND (pixel_y_s1 < (anclaCookiey_98+ 16 )) )) ELSE									
						101 WHEN(( ( pixel_x_s1 >= anclaCookiex_99) AND ( pixel_x_s1 < (anclaCookiex_99+16)) ) AND (( pixel_y_s1 >= anclaCookiey_99) AND (pixel_y_s1 < (anclaCookiey_99+ 16 )) )) ELSE									
						102 WHEN(( ( pixel_x_s1 >= anclaCookiex_100) AND ( pixel_x_s1 < (anclaCookiex_100+16)) ) AND (( pixel_y_s1 >= anclaCookiey_100) AND (pixel_y_s1 < (anclaCookiey_100+ 16 )) )) ELSE									

					  0 ;	  
					 
	adr_pacman_R1 <= pixel_y_s1 - AnclaPacy WHEN Personajes = 1 ELSE 0;
	pacman_R1     <= pixel_x_s1 - AnclaPacx WHEN Personajes = 1 ELSE 0;
	adr_pacman_G1 <= pixel_y_s1 - AnclaPacy WHEN Personajes = 1 ELSE 0;
	pacman_G1     <= pixel_x_s1 - AnclaPacx WHEN Personajes = 1 ELSE 0;
	
	
	adr_Ghost_R1 <= pixel_y_s1 - anclaGhosty WHEN Personajes = 2 ELSE 0;
	Ghost_R1 	 <= pixel_x_s1 - anclaGhostx WHEN Personajes = 2 ELSE 0;
	adr_Ghost_B1 <= pixel_y_s1 - anclaGhosty WHEN Personajes = 2 ELSE 0;
	Ghost_B1 	 <= pixel_x_s1 - anclaGhostx WHEN Personajes = 2 ELSE 0;
	adr_Ghost_G1 <= pixel_y_s1 - anclaGhosty WHEN Personajes = 2 ELSE 0;
	Ghost_G1 	 <= pixel_x_s1 - anclaGhostx WHEN Personajes = 2 ELSE 0;
	
	
	adr_Block_B1   <= pixel_y_s1 - AnclaBlocky WHEN PrioriImg = 1 ELSE 
	                  pixel_y_s1 - AnclaBlocky_L WHEN PrioriImg = 2 ELSE 0;
							
	Block_B1 	   <= pixel_x_s1 - AnclaBlockx WHEN PrioriImg = 1 ELSE 0;
	Block_B1_L 	   <= pixel_x_s1 - AnclaBlockx_L WHEN PrioriImg = 2 ELSE 0;
					

	adr_Welcome_R1 <= pixel_y_s1 - anclaWelcomey WHEN Inicio_screen = 1 ELSE 0;
	Welcome_R1 	   <= pixel_x_s1 - anclaWelcomex WHEN Inicio_screen = 1 ELSE 0;
	adr_Welcome_B1 <= pixel_y_s1 - anclaWelcomey WHEN Inicio_screen = 1 ELSE 0;
	Welcome_B1 	   <= pixel_x_s1 - anclaWelcomex WHEN Inicio_screen = 1 ELSE 0;
	adr_Welcome_G1 <= pixel_y_s1 - anclaWelcomey WHEN Inicio_screen = 1 ELSE 0;
	Welcome_G1 	   <= pixel_x_s1 - anclaWelcomex WHEN Inicio_screen = 1 ELSE 0;
	
	
	adr_EndGame1  <= pixel_y_s1 - anclaEndGamey WHEN Fin_screen = 1 ELSE 0;
	End_GameMe1   <= pixel_x_s1 - anclaEndGamex WHEN Fin_screen = 1 ELSE 0;
	
	
	
	adr_cookies_R1 <= pixel_y_s1 - anclaCookiey_1 WHEN Personajes = 3  ELSE
                     pixel_y_s1 - anclaCookiey_2 WHEN Personajes = 4  ELSE
						   pixel_y_s1 - anclaCookiey_3 WHEN Personajes = 5  ELSE
							pixel_y_s1 - anclaCookiey_4 WHEN Personajes = 6  ELSE
							pixel_y_s1 - anclaCookiey_5 WHEN Personajes = 7  ELSE
							pixel_y_s1 - anclaCookiey_6 WHEN Personajes = 8  ELSE
							pixel_y_s1 - anclaCookiey_7 WHEN Personajes = 9  ELSE
							pixel_y_s1 - anclaCookiey_8 WHEN Personajes = 10  ELSE
							pixel_y_s1 - anclaCookiey_9 WHEN Personajes = 11  ELSE
							pixel_y_s1 - anclaCookiey_10 WHEN Personajes = 12  ELSE
							pixel_y_s1 - anclaCookiey_11 WHEN Personajes = 13 ELSE
							pixel_y_s1 - anclaCookiey_12 WHEN Personajes = 14 ELSE
							pixel_y_s1 - anclaCookiey_13 WHEN Personajes = 15 ELSE
							pixel_y_s1 - anclaCookiey_14 WHEN Personajes = 16 ELSE
							pixel_y_s1 - anclaCookiey_15 WHEN Personajes = 17 ELSE
							pixel_y_s1 - anclaCookiey_16 WHEN Personajes = 18 ELSE
							pixel_y_s1 - anclaCookiey_17 WHEN Personajes = 19 ELSE
							pixel_y_s1 - anclaCookiey_18 WHEN Personajes = 20 ELSE
							pixel_y_s1 - anclaCookiey_19 WHEN Personajes = 21 ELSE
							pixel_y_s1 - anclaCookiey_20 WHEN Personajes = 22 ELSE
							pixel_y_s1 - anclaCookiey_21 WHEN Personajes = 23 ELSE
							pixel_y_s1 - anclaCookiey_22 WHEN Personajes = 24 ELSE
							pixel_y_s1 - anclaCookiey_23 WHEN Personajes = 25 ELSE
							pixel_y_s1 - anclaCookiey_24 WHEN Personajes = 26 ELSE
							pixel_y_s1 - anclaCookiey_25 WHEN Personajes = 27 ELSE
							pixel_y_s1 - anclaCookiey_26 WHEN Personajes = 28 ELSE
							pixel_y_s1 - anclaCookiey_27 WHEN Personajes = 29 ELSE
							pixel_y_s1 - anclaCookiey_28 WHEN Personajes = 30 ELSE
							pixel_y_s1 - anclaCookiey_29 WHEN Personajes = 31 ELSE
							pixel_y_s1 - anclaCookiey_30 WHEN Personajes = 32 ELSE
							pixel_y_s1 - anclaCookiey_31 WHEN Personajes = 33 ELSE
							pixel_y_s1 - anclaCookiey_32 WHEN Personajes = 34  ELSE
							pixel_y_s1 - anclaCookiey_33 WHEN Personajes = 35  ELSE
							pixel_y_s1 - anclaCookiey_34 WHEN Personajes = 36  ELSE
							pixel_y_s1 - anclaCookiey_35 WHEN Personajes = 37  ELSE
							pixel_y_s1 - anclaCookiey_36 WHEN Personajes = 38  ELSE
							pixel_y_s1 - anclaCookiey_37 WHEN Personajes = 39  ELSE
							pixel_y_s1 - anclaCookiey_38 WHEN Personajes = 40  ELSE
							pixel_y_s1 - anclaCookiey_39 WHEN Personajes = 41  ELSE
							pixel_y_s1 - anclaCookiey_40   WHEN Personajes =42    ELSE
							pixel_y_s1 - anclaCookiey_41   WHEN Personajes =43    ELSE
							pixel_y_s1 - anclaCookiey_42   WHEN Personajes =44    ELSE
							pixel_y_s1 - anclaCookiey_43   WHEN Personajes =45    ELSE
							pixel_y_s1 - anclaCookiey_44   WHEN Personajes =46    ELSE
							pixel_y_s1 - anclaCookiey_45   WHEN Personajes =47    ELSE
							pixel_y_s1 - anclaCookiey_46   WHEN Personajes =48    ELSE
							pixel_y_s1 - anclaCookiey_47   WHEN Personajes =49    ELSE
							pixel_y_s1 - anclaCookiey_48   WHEN Personajes =50    ELSE
							pixel_y_s1 - anclaCookiey_49   WHEN Personajes =51    ELSE
							pixel_y_s1 - anclaCookiey_50   WHEN Personajes =52    ELSE
							pixel_y_s1 - anclaCookiey_51   WHEN Personajes =53    ELSE
							pixel_y_s1 - anclaCookiey_52   WHEN Personajes =54    ELSE
							pixel_y_s1 - anclaCookiey_53   WHEN Personajes =55    ELSE
							pixel_y_s1 - anclaCookiey_54   WHEN Personajes =56    ELSE
							pixel_y_s1 - anclaCookiey_55   WHEN Personajes =57    ELSE
							pixel_y_s1 - anclaCookiey_56   WHEN Personajes =58    ELSE
							pixel_y_s1 - anclaCookiey_57   WHEN Personajes =59    ELSE
							pixel_y_s1 - anclaCookiey_58   WHEN Personajes =60    ELSE
							pixel_y_s1 - anclaCookiey_59   WHEN Personajes =61    ELSE
							pixel_y_s1 - anclaCookiey_60   WHEN Personajes =62    ELSE
							pixel_y_s1 - anclaCookiey_61   WHEN Personajes =63    ELSE
							pixel_y_s1 - anclaCookiey_62   WHEN Personajes =64    ELSE
							pixel_y_s1 - anclaCookiey_63   WHEN Personajes =65    ELSE
							pixel_y_s1 - anclaCookiey_64   WHEN Personajes =66    ELSE
							pixel_y_s1 - anclaCookiey_65   WHEN Personajes =67    ELSE
							pixel_y_s1 - anclaCookiey_66   WHEN Personajes =68    ELSE
							pixel_y_s1 - anclaCookiey_67   WHEN Personajes =69    ELSE
							pixel_y_s1 - anclaCookiey_68   WHEN Personajes =70    ELSE
							pixel_y_s1 - anclaCookiey_69   WHEN Personajes =71    ELSE
							pixel_y_s1 - anclaCookiey_70   WHEN Personajes =72    ELSE
							pixel_y_s1 - anclaCookiey_71   WHEN Personajes =73    ELSE
							pixel_y_s1 - anclaCookiey_72   WHEN Personajes =74    ELSE
							pixel_y_s1 - anclaCookiey_73   WHEN Personajes =75    ELSE
							pixel_y_s1 - anclaCookiey_74   WHEN Personajes =76    ELSE
							pixel_y_s1 - anclaCookiey_75   WHEN Personajes =77    ELSE
							pixel_y_s1 - anclaCookiey_76   WHEN Personajes =78    ELSE
							pixel_y_s1 - anclaCookiey_77   WHEN Personajes =79    ELSE
							pixel_y_s1 - anclaCookiey_78   WHEN Personajes =80    ELSE
							pixel_y_s1 - anclaCookiey_79   WHEN Personajes =81    ELSE
							pixel_y_s1 - anclaCookiey_80   WHEN Personajes =82    ELSE
							pixel_y_s1 - anclaCookiey_81   WHEN Personajes =83    ELSE
							pixel_y_s1 - anclaCookiey_82   WHEN Personajes =84    ELSE
							pixel_y_s1 - anclaCookiey_83   WHEN Personajes =85    ELSE
							pixel_y_s1 - anclaCookiey_84   WHEN Personajes =86    ELSE
							pixel_y_s1 - anclaCookiey_85   WHEN Personajes =87    ELSE
							pixel_y_s1 - anclaCookiey_86   WHEN Personajes =88    ELSE
							pixel_y_s1 - anclaCookiey_87   WHEN Personajes =89    ELSE
							pixel_y_s1 - anclaCookiey_88   WHEN Personajes =90    ELSE
							pixel_y_s1 - anclaCookiey_89   WHEN Personajes =91    ELSE
							pixel_y_s1 - anclaCookiey_90   WHEN Personajes =92    ELSE
							pixel_y_s1 - anclaCookiey_91   WHEN Personajes =93    ELSE
							pixel_y_s1 - anclaCookiey_92   WHEN Personajes =94    ELSE
							pixel_y_s1 - anclaCookiey_93   WHEN Personajes =95    ELSE
							pixel_y_s1 - anclaCookiey_94   WHEN Personajes =96    ELSE
							pixel_y_s1 - anclaCookiey_95   WHEN Personajes =97    ELSE
							pixel_y_s1 - anclaCookiey_96   WHEN Personajes =98    ELSE
							pixel_y_s1 - anclaCookiey_97   WHEN Personajes =99    ELSE
							pixel_y_s1 - anclaCookiey_98   WHEN Personajes =100   ELSE
							pixel_y_s1 - anclaCookiey_99   WHEN Personajes =101   ELSE
							pixel_y_s1 - anclaCookiey_100  WHEN Personajes =102    ELSE
							0;
							
							
	Cookies_R1 	   <= pixel_x_s1 - anclaCookiex_1 WHEN Personajes = 3  ELSE
                     pixel_x_s1 - anclaCookiex_2 WHEN Personajes = 4  ELSE
						   pixel_x_s1 - anclaCookiex_3 WHEN Personajes = 5  ELSE
							pixel_x_s1 - anclaCookiex_4 WHEN Personajes = 6  ELSE
							pixel_x_s1 - anclaCookiex_5 WHEN Personajes = 7  ELSE
							pixel_x_s1 - anclaCookiex_6 WHEN Personajes = 8  ELSE
							pixel_x_s1 - anclaCookiex_7 WHEN Personajes = 9  ELSE
							pixel_x_s1 - anclaCookiex_8 WHEN Personajes = 10  ELSE
							pixel_x_s1 - anclaCookiex_9 WHEN Personajes = 11  ELSE
							pixel_x_s1 - anclaCookiex_10 WHEN Personajes = 12  ELSE
							pixel_x_s1 - anclaCookiex_11 WHEN Personajes = 13 ELSE
							pixel_x_s1 - anclaCookiex_12 WHEN Personajes = 14 ELSE
							pixel_x_s1 - anclaCookiex_13 WHEN Personajes = 15 ELSE
							pixel_x_s1 - anclaCookiex_14 WHEN Personajes = 16 ELSE
							pixel_x_s1 - anclaCookiex_15 WHEN Personajes = 17 ELSE
							pixel_x_s1 - anclaCookiex_16 WHEN Personajes = 18 ELSE
							pixel_x_s1 - anclaCookiex_17 WHEN Personajes = 19 ELSE
							pixel_x_s1 - anclaCookiex_18 WHEN Personajes = 20 ELSE
							pixel_x_s1 - anclaCookiex_19 WHEN Personajes = 21 ELSE
							pixel_x_s1 - anclaCookiex_20 WHEN Personajes = 22 ELSE
							pixel_x_s1 - anclaCookiex_21 WHEN Personajes = 23 ELSE
							pixel_x_s1 - anclaCookiex_22 WHEN Personajes = 24 ELSE
							pixel_x_s1 - anclaCookiex_23 WHEN Personajes = 25 ELSE
							pixel_x_s1 - anclaCookiex_24 WHEN Personajes = 26 ELSE
							pixel_x_s1 - anclaCookiex_25 WHEN Personajes = 27 ELSE
							pixel_x_s1 - anclaCookiex_26 WHEN Personajes = 28 ELSE
							pixel_x_s1 - anclaCookiex_27 WHEN Personajes = 29 ELSE
							pixel_x_s1 - anclaCookiex_28 WHEN Personajes = 30 ELSE
							pixel_x_s1 - anclaCookiex_29 WHEN Personajes = 31 ELSE
							pixel_x_s1 - anclaCookiex_30 WHEN Personajes = 32 ELSE
							pixel_x_s1 - anclaCookiex_31 WHEN Personajes = 33 ELSE
							pixel_x_s1 - anclaCookiex_32 WHEN Personajes = 34  ELSE
							pixel_x_s1 - anclaCookiex_33 WHEN Personajes = 35  ELSE
							pixel_x_s1 - anclaCookiex_34 WHEN Personajes = 36  ELSE
							pixel_x_s1 - anclaCookiex_35 WHEN Personajes = 37  ELSE
							pixel_x_s1 - anclaCookiex_36 WHEN Personajes = 38  ELSE
							pixel_x_s1 - anclaCookiex_37 WHEN Personajes = 39  ELSE
							pixel_x_s1 - anclaCookiex_38 WHEN Personajes = 40  ELSE
							pixel_x_s1 - anclaCookiex_39 WHEN Personajes = 41  ELSE
							pixel_x_s1 - anclaCookiex_40 WHEN Personajes =  42 ELSE 
							pixel_x_s1 - anclaCookiex_41 WHEN Personajes =  43 ELSE 
							pixel_x_s1 - anclaCookiex_42 WHEN Personajes =  44 ELSE 
							pixel_x_s1 - anclaCookiex_43 WHEN Personajes =  45 ELSE 
							pixel_x_s1 - anclaCookiex_44 WHEN Personajes =  46 ELSE 
							pixel_x_s1 - anclaCookiex_45 WHEN Personajes =  47 ELSE 
							pixel_x_s1 - anclaCookiex_46 WHEN Personajes =  48 ELSE 
							pixel_x_s1 - anclaCookiex_47 WHEN Personajes =  49 ELSE 
							pixel_x_s1 - anclaCookiex_48 WHEN Personajes =  50 ELSE 
							pixel_x_s1 - anclaCookiex_49 WHEN Personajes =  51 ELSE 
							pixel_x_s1 - anclaCookiex_50 WHEN Personajes =  52 ELSE 
							pixel_x_s1 - anclaCookiex_51 WHEN Personajes =  53 ELSE 
							pixel_x_s1 - anclaCookiex_52 WHEN Personajes =  54 ELSE 
							pixel_x_s1 - anclaCookiex_53 WHEN Personajes =  55 ELSE 
							pixel_x_s1 - anclaCookiex_54 WHEN Personajes =  56 ELSE 
							pixel_x_s1 - anclaCookiex_55 WHEN Personajes =  57 ELSE 
							pixel_x_s1 - anclaCookiex_56 WHEN Personajes =  58 ELSE 
							pixel_x_s1 - anclaCookiex_57 WHEN Personajes =  59 ELSE 
							pixel_x_s1 - anclaCookiex_58 WHEN Personajes =  60 ELSE 
							pixel_x_s1 - anclaCookiex_59 WHEN Personajes =  61 ELSE 
							pixel_x_s1 - anclaCookiex_60 WHEN Personajes =  62 ELSE 
							pixel_x_s1 - anclaCookiex_61 WHEN Personajes =  63 ELSE 
							pixel_x_s1 - anclaCookiex_62 WHEN Personajes =  64 ELSE 
							pixel_x_s1 - anclaCookiex_63 WHEN Personajes =  65 ELSE 
							pixel_x_s1 - anclaCookiex_64 WHEN Personajes =  66 ELSE 
							pixel_x_s1 - anclaCookiex_65 WHEN Personajes =  67 ELSE 
							pixel_x_s1 - anclaCookiex_66 WHEN Personajes =  68 ELSE 
							pixel_x_s1 - anclaCookiex_67 WHEN Personajes =  69 ELSE 
							pixel_x_s1 - anclaCookiex_68 WHEN Personajes =  70 ELSE 
							pixel_x_s1 - anclaCookiex_69 WHEN Personajes =  71 ELSE 
							pixel_x_s1 - anclaCookiex_70 WHEN Personajes =  72 ELSE 
							pixel_x_s1 - anclaCookiex_71 WHEN Personajes =  73 ELSE 
							pixel_x_s1 - anclaCookiex_72 WHEN Personajes =  74 ELSE 
							pixel_x_s1 - anclaCookiex_73 WHEN Personajes =  75 ELSE 
							pixel_x_s1 - anclaCookiex_74 WHEN Personajes =  76 ELSE 
							pixel_x_s1 - anclaCookiex_75 WHEN Personajes =  77 ELSE 
							pixel_x_s1 - anclaCookiex_76 WHEN Personajes =  78 ELSE 
							pixel_x_s1 - anclaCookiex_77 WHEN Personajes =  79 ELSE 
							pixel_x_s1 - anclaCookiex_78 WHEN Personajes =  80 ELSE 
							pixel_x_s1 - anclaCookiex_79 WHEN Personajes =  81 ELSE 
							pixel_x_s1 - anclaCookiex_80 WHEN Personajes =  82 ELSE 
							pixel_x_s1 - anclaCookiex_81 WHEN Personajes =  83 ELSE 
							pixel_x_s1 - anclaCookiex_82 WHEN Personajes =  84 ELSE 
							pixel_x_s1 - anclaCookiex_83 WHEN Personajes =  85 ELSE 
							pixel_x_s1 - anclaCookiex_84 WHEN Personajes =  86 ELSE 
							pixel_x_s1 - anclaCookiex_85 WHEN Personajes =  87 ELSE 
							pixel_x_s1 - anclaCookiex_86 WHEN Personajes =  88 ELSE 
							pixel_x_s1 - anclaCookiex_87 WHEN Personajes =  89 ELSE 
							pixel_x_s1 - anclaCookiex_88 WHEN Personajes =  90 ELSE 
							pixel_x_s1 - anclaCookiex_89 WHEN Personajes =  91 ELSE 
							pixel_x_s1 - anclaCookiex_90 WHEN Personajes =  92 ELSE 
							pixel_x_s1 - anclaCookiex_91 WHEN Personajes =  93 ELSE 
							pixel_x_s1 - anclaCookiex_92 WHEN Personajes =  94 ELSE 
							pixel_x_s1 - anclaCookiex_93 WHEN Personajes =  95 ELSE 
							pixel_x_s1 - anclaCookiex_94 WHEN Personajes =  96 ELSE 
							pixel_x_s1 - anclaCookiex_95 WHEN Personajes =  97 ELSE 
							pixel_x_s1 - anclaCookiex_96 WHEN Personajes =  98 ELSE 
							pixel_x_s1 - anclaCookiex_97 WHEN Personajes =  99 ELSE 
							pixel_x_s1 - anclaCookiex_98 WHEN Personajes =  100 ELSE 
							pixel_x_s1 - anclaCookiex_99 WHEN Personajes =  101 ELSE 
							pixel_x_s1 - anclaCookiex_100 WHEN Personajes =  102 ELSE 
							0;
							
	adr_cookies_G1 <= pixel_y_s1 - anclaCookiey_1 WHEN Personajes = 3  ELSE
                     pixel_y_s1 - anclaCookiey_2 WHEN Personajes = 4  ELSE
						   pixel_y_s1 - anclaCookiey_3 WHEN Personajes = 5  ELSE
							pixel_y_s1 - anclaCookiey_4 WHEN Personajes = 6  ELSE
							pixel_y_s1 - anclaCookiey_5 WHEN Personajes = 7  ELSE
							pixel_y_s1 - anclaCookiey_6 WHEN Personajes = 8  ELSE
							pixel_y_s1 - anclaCookiey_7 WHEN Personajes = 9  ELSE
							pixel_y_s1 - anclaCookiey_8 WHEN Personajes = 10  ELSE
							pixel_y_s1 - anclaCookiey_9 WHEN Personajes = 11  ELSE
							pixel_y_s1 - anclaCookiey_10 WHEN Personajes = 12  ELSE
							pixel_y_s1 - anclaCookiey_11 WHEN Personajes = 13 ELSE
							pixel_y_s1 - anclaCookiey_12 WHEN Personajes = 14 ELSE
							pixel_y_s1 - anclaCookiey_13 WHEN Personajes = 15 ELSE
							pixel_y_s1 - anclaCookiey_14 WHEN Personajes = 16 ELSE
							pixel_y_s1 - anclaCookiey_15 WHEN Personajes = 17 ELSE
							pixel_y_s1 - anclaCookiey_16 WHEN Personajes = 18 ELSE
							pixel_y_s1 - anclaCookiey_17 WHEN Personajes = 19 ELSE
							pixel_y_s1 - anclaCookiey_18 WHEN Personajes = 20 ELSE
							pixel_y_s1 - anclaCookiey_19 WHEN Personajes = 21 ELSE
							pixel_y_s1 - anclaCookiey_20 WHEN Personajes = 22 ELSE
							pixel_y_s1 - anclaCookiey_21 WHEN Personajes = 23 ELSE
							pixel_y_s1 - anclaCookiey_22 WHEN Personajes = 24 ELSE
							pixel_y_s1 - anclaCookiey_23 WHEN Personajes = 25 ELSE
							pixel_y_s1 - anclaCookiey_24 WHEN Personajes = 26 ELSE
							pixel_y_s1 - anclaCookiey_25 WHEN Personajes = 27 ELSE
							pixel_y_s1 - anclaCookiey_26 WHEN Personajes = 28 ELSE
							pixel_y_s1 - anclaCookiey_27 WHEN Personajes = 29 ELSE
							pixel_y_s1 - anclaCookiey_28 WHEN Personajes = 30 ELSE
							pixel_y_s1 - anclaCookiey_29 WHEN Personajes = 31 ELSE
							pixel_y_s1 - anclaCookiey_30 WHEN Personajes = 32 ELSE
							pixel_y_s1 - anclaCookiey_31 WHEN Personajes = 33 ELSE
							pixel_y_s1 - anclaCookiey_32 WHEN Personajes = 34  ELSE
							pixel_y_s1 - anclaCookiey_33 WHEN Personajes = 35  ELSE
							pixel_y_s1 - anclaCookiey_34 WHEN Personajes = 36  ELSE
							pixel_y_s1 - anclaCookiey_35 WHEN Personajes = 37  ELSE
							pixel_y_s1 - anclaCookiey_36 WHEN Personajes = 38  ELSE
							pixel_y_s1 - anclaCookiey_37 WHEN Personajes = 39  ELSE
							pixel_y_s1 - anclaCookiey_38 WHEN Personajes = 40  ELSE
							pixel_y_s1 - anclaCookiey_39 WHEN Personajes = 41  ELSE
							pixel_y_s1 - anclaCookiey_40   WHEN Personajes =42    ELSE
							pixel_y_s1 - anclaCookiey_41   WHEN Personajes =43    ELSE
							pixel_y_s1 - anclaCookiey_42   WHEN Personajes =44    ELSE
							pixel_y_s1 - anclaCookiey_43   WHEN Personajes =45    ELSE
							pixel_y_s1 - anclaCookiey_44   WHEN Personajes =46    ELSE
							pixel_y_s1 - anclaCookiey_45   WHEN Personajes =47    ELSE
							pixel_y_s1 - anclaCookiey_46   WHEN Personajes =48    ELSE
							pixel_y_s1 - anclaCookiey_47   WHEN Personajes =49    ELSE
							pixel_y_s1 - anclaCookiey_48   WHEN Personajes =50    ELSE
							pixel_y_s1 - anclaCookiey_49   WHEN Personajes =51    ELSE
							pixel_y_s1 - anclaCookiey_50   WHEN Personajes =52    ELSE
							pixel_y_s1 - anclaCookiey_51   WHEN Personajes =53    ELSE
							pixel_y_s1 - anclaCookiey_52   WHEN Personajes =54    ELSE
							pixel_y_s1 - anclaCookiey_53   WHEN Personajes =55    ELSE
							pixel_y_s1 - anclaCookiey_54   WHEN Personajes =56    ELSE
							pixel_y_s1 - anclaCookiey_55   WHEN Personajes =57    ELSE
							pixel_y_s1 - anclaCookiey_56   WHEN Personajes =58    ELSE
							pixel_y_s1 - anclaCookiey_57   WHEN Personajes =59    ELSE
							pixel_y_s1 - anclaCookiey_58   WHEN Personajes =60    ELSE
							pixel_y_s1 - anclaCookiey_59   WHEN Personajes =61    ELSE
							pixel_y_s1 - anclaCookiey_60   WHEN Personajes =62    ELSE
							pixel_y_s1 - anclaCookiey_61   WHEN Personajes =63    ELSE
							pixel_y_s1 - anclaCookiey_62   WHEN Personajes =64    ELSE
							pixel_y_s1 - anclaCookiey_63   WHEN Personajes =65    ELSE
							pixel_y_s1 - anclaCookiey_64   WHEN Personajes =66    ELSE
							pixel_y_s1 - anclaCookiey_65   WHEN Personajes =67    ELSE
							pixel_y_s1 - anclaCookiey_66   WHEN Personajes =68    ELSE
							pixel_y_s1 - anclaCookiey_67   WHEN Personajes =69    ELSE
							pixel_y_s1 - anclaCookiey_68   WHEN Personajes =70    ELSE
							pixel_y_s1 - anclaCookiey_69   WHEN Personajes =71    ELSE
							pixel_y_s1 - anclaCookiey_70   WHEN Personajes =72    ELSE
							pixel_y_s1 - anclaCookiey_71   WHEN Personajes =73    ELSE
							pixel_y_s1 - anclaCookiey_72   WHEN Personajes =74    ELSE
							pixel_y_s1 - anclaCookiey_73   WHEN Personajes =75    ELSE
							pixel_y_s1 - anclaCookiey_74   WHEN Personajes =76    ELSE
							pixel_y_s1 - anclaCookiey_75   WHEN Personajes =77    ELSE
							pixel_y_s1 - anclaCookiey_76   WHEN Personajes =78    ELSE
							pixel_y_s1 - anclaCookiey_77   WHEN Personajes =79    ELSE
							pixel_y_s1 - anclaCookiey_78   WHEN Personajes =80    ELSE
							pixel_y_s1 - anclaCookiey_79   WHEN Personajes =81    ELSE
							pixel_y_s1 - anclaCookiey_80   WHEN Personajes =82    ELSE
							pixel_y_s1 - anclaCookiey_81   WHEN Personajes =83    ELSE
							pixel_y_s1 - anclaCookiey_82   WHEN Personajes =84    ELSE
							pixel_y_s1 - anclaCookiey_83   WHEN Personajes =85    ELSE
							pixel_y_s1 - anclaCookiey_84   WHEN Personajes =86    ELSE
							pixel_y_s1 - anclaCookiey_85   WHEN Personajes =87    ELSE
							pixel_y_s1 - anclaCookiey_86   WHEN Personajes =88    ELSE
							pixel_y_s1 - anclaCookiey_87   WHEN Personajes =89    ELSE
							pixel_y_s1 - anclaCookiey_88   WHEN Personajes =90    ELSE
							pixel_y_s1 - anclaCookiey_89   WHEN Personajes =91    ELSE
							pixel_y_s1 - anclaCookiey_90   WHEN Personajes =92    ELSE
							pixel_y_s1 - anclaCookiey_91   WHEN Personajes =93    ELSE
							pixel_y_s1 - anclaCookiey_92   WHEN Personajes =94    ELSE
							pixel_y_s1 - anclaCookiey_93   WHEN Personajes =95    ELSE
							pixel_y_s1 - anclaCookiey_94   WHEN Personajes =96    ELSE
							pixel_y_s1 - anclaCookiey_95   WHEN Personajes =97    ELSE
							pixel_y_s1 - anclaCookiey_96   WHEN Personajes =98    ELSE
							pixel_y_s1 - anclaCookiey_97   WHEN Personajes =99    ELSE
							pixel_y_s1 - anclaCookiey_98   WHEN Personajes =100   ELSE
							pixel_y_s1 - anclaCookiey_99   WHEN Personajes =101   ELSE
							pixel_y_s1 - anclaCookiey_100  WHEN Personajes =102    ELSE
							0;
							
	Cookies_G1 	   <= pixel_x_s1 - anclaCookiex_1 WHEN Personajes = 3  ELSE
                     pixel_x_s1 - anclaCookiex_2 WHEN Personajes = 4  ELSE
						   pixel_x_s1 - anclaCookiex_3 WHEN Personajes = 5  ELSE
							pixel_x_s1 - anclaCookiex_4 WHEN Personajes = 6  ELSE
							pixel_x_s1 - anclaCookiex_5 WHEN Personajes = 7  ELSE
							pixel_x_s1 - anclaCookiex_6 WHEN Personajes = 8  ELSE
							pixel_x_s1 - anclaCookiex_7 WHEN Personajes = 9  ELSE
							pixel_x_s1 - anclaCookiex_8 WHEN Personajes = 10  ELSE
							pixel_x_s1 - anclaCookiex_9 WHEN Personajes = 11  ELSE
							pixel_x_s1 - anclaCookiex_10 WHEN Personajes = 12  ELSE
							pixel_x_s1 - anclaCookiex_11 WHEN Personajes = 13 ELSE
							pixel_x_s1 - anclaCookiex_12 WHEN Personajes = 14 ELSE
							pixel_x_s1 - anclaCookiex_13 WHEN Personajes = 15 ELSE
							pixel_x_s1 - anclaCookiex_14 WHEN Personajes = 16 ELSE
							pixel_x_s1 - anclaCookiex_15 WHEN Personajes = 17 ELSE
							pixel_x_s1 - anclaCookiex_16 WHEN Personajes = 18 ELSE
							pixel_x_s1 - anclaCookiex_17 WHEN Personajes = 19 ELSE
							pixel_x_s1 - anclaCookiex_18 WHEN Personajes = 20 ELSE
							pixel_x_s1 - anclaCookiex_19 WHEN Personajes = 21 ELSE
							pixel_x_s1 - anclaCookiex_20 WHEN Personajes = 22 ELSE
							pixel_x_s1 - anclaCookiex_21 WHEN Personajes = 23 ELSE
							pixel_x_s1 - anclaCookiex_22 WHEN Personajes = 24 ELSE
							pixel_x_s1 - anclaCookiex_23 WHEN Personajes = 25 ELSE
							pixel_x_s1 - anclaCookiex_24 WHEN Personajes = 26 ELSE
							pixel_x_s1 - anclaCookiex_25 WHEN Personajes = 27 ELSE
							pixel_x_s1 - anclaCookiex_26 WHEN Personajes = 28 ELSE
							pixel_x_s1 - anclaCookiex_27 WHEN Personajes = 29 ELSE
							pixel_x_s1 - anclaCookiex_28 WHEN Personajes = 30 ELSE
							pixel_x_s1 - anclaCookiex_29 WHEN Personajes = 31 ELSE
							pixel_x_s1 - anclaCookiex_30 WHEN Personajes = 32 ELSE
							pixel_x_s1 - anclaCookiex_31 WHEN Personajes = 33 ELSE
							pixel_x_s1 - anclaCookiex_32 WHEN Personajes = 34  ELSE
							pixel_x_s1 - anclaCookiex_33 WHEN Personajes = 35  ELSE
							pixel_x_s1 - anclaCookiex_34 WHEN Personajes = 36  ELSE
							pixel_x_s1 - anclaCookiex_35 WHEN Personajes = 37  ELSE
							pixel_x_s1 - anclaCookiex_36 WHEN Personajes = 38  ELSE
							pixel_x_s1 - anclaCookiex_37 WHEN Personajes = 39  ELSE
							pixel_x_s1 - anclaCookiex_38 WHEN Personajes = 40  ELSE
							pixel_x_s1 - anclaCookiex_39 WHEN Personajes = 41  ELSE
							pixel_x_s1 - anclaCookiex_40 WHEN Personajes =  42 ELSE 
							pixel_x_s1 - anclaCookiex_41 WHEN Personajes =  43 ELSE 
							pixel_x_s1 - anclaCookiex_42 WHEN Personajes =  44 ELSE 
							pixel_x_s1 - anclaCookiex_43 WHEN Personajes =  45 ELSE 
							pixel_x_s1 - anclaCookiex_44 WHEN Personajes =  46 ELSE 
							pixel_x_s1 - anclaCookiex_45 WHEN Personajes =  47 ELSE 
							pixel_x_s1 - anclaCookiex_46 WHEN Personajes =  48 ELSE 
							pixel_x_s1 - anclaCookiex_47 WHEN Personajes =  49 ELSE 
							pixel_x_s1 - anclaCookiex_48 WHEN Personajes =  50 ELSE 
							pixel_x_s1 - anclaCookiex_49 WHEN Personajes =  51 ELSE 
							pixel_x_s1 - anclaCookiex_50 WHEN Personajes =  52 ELSE 
							pixel_x_s1 - anclaCookiex_51 WHEN Personajes =  53 ELSE 
							pixel_x_s1 - anclaCookiex_52 WHEN Personajes =  54 ELSE 
							pixel_x_s1 - anclaCookiex_53 WHEN Personajes =  55 ELSE 
							pixel_x_s1 - anclaCookiex_54 WHEN Personajes =  56 ELSE 
							pixel_x_s1 - anclaCookiex_55 WHEN Personajes =  57 ELSE 
							pixel_x_s1 - anclaCookiex_56 WHEN Personajes =  58 ELSE 
							pixel_x_s1 - anclaCookiex_57 WHEN Personajes =  59 ELSE 
							pixel_x_s1 - anclaCookiex_58 WHEN Personajes =  60 ELSE 
							pixel_x_s1 - anclaCookiex_59 WHEN Personajes =  61 ELSE 
							pixel_x_s1 - anclaCookiex_60 WHEN Personajes =  62 ELSE 
							pixel_x_s1 - anclaCookiex_61 WHEN Personajes =  63 ELSE 
							pixel_x_s1 - anclaCookiex_62 WHEN Personajes =  64 ELSE 
							pixel_x_s1 - anclaCookiex_63 WHEN Personajes =  65 ELSE 
							pixel_x_s1 - anclaCookiex_64 WHEN Personajes =  66 ELSE 
							pixel_x_s1 - anclaCookiex_65 WHEN Personajes =  67 ELSE 
							pixel_x_s1 - anclaCookiex_66 WHEN Personajes =  68 ELSE 
							pixel_x_s1 - anclaCookiex_67 WHEN Personajes =  69 ELSE 
							pixel_x_s1 - anclaCookiex_68 WHEN Personajes =  70 ELSE 
							pixel_x_s1 - anclaCookiex_69 WHEN Personajes =  71 ELSE 
							pixel_x_s1 - anclaCookiex_70 WHEN Personajes =  72 ELSE 
							pixel_x_s1 - anclaCookiex_71 WHEN Personajes =  73 ELSE 
							pixel_x_s1 - anclaCookiex_72 WHEN Personajes =  74 ELSE 
							pixel_x_s1 - anclaCookiex_73 WHEN Personajes =  75 ELSE 
							pixel_x_s1 - anclaCookiex_74 WHEN Personajes =  76 ELSE 
							pixel_x_s1 - anclaCookiex_75 WHEN Personajes =  77 ELSE 
							pixel_x_s1 - anclaCookiex_76 WHEN Personajes =  78 ELSE 
							pixel_x_s1 - anclaCookiex_77 WHEN Personajes =  79 ELSE 
							pixel_x_s1 - anclaCookiex_78 WHEN Personajes =  80 ELSE 
							pixel_x_s1 - anclaCookiex_79 WHEN Personajes =  81 ELSE 
							pixel_x_s1 - anclaCookiex_80 WHEN Personajes =  82 ELSE 
							pixel_x_s1 - anclaCookiex_81 WHEN Personajes =  83 ELSE 
							pixel_x_s1 - anclaCookiex_82 WHEN Personajes =  84 ELSE 
							pixel_x_s1 - anclaCookiex_83 WHEN Personajes =  85 ELSE 
							pixel_x_s1 - anclaCookiex_84 WHEN Personajes =  86 ELSE 
							pixel_x_s1 - anclaCookiex_85 WHEN Personajes =  87 ELSE 
							pixel_x_s1 - anclaCookiex_86 WHEN Personajes =  88 ELSE 
							pixel_x_s1 - anclaCookiex_87 WHEN Personajes =  89 ELSE 
							pixel_x_s1 - anclaCookiex_88 WHEN Personajes =  90 ELSE 
							pixel_x_s1 - anclaCookiex_89 WHEN Personajes =  91 ELSE 
							pixel_x_s1 - anclaCookiex_90 WHEN Personajes =  92 ELSE 
							pixel_x_s1 - anclaCookiex_91 WHEN Personajes =  93 ELSE 
							pixel_x_s1 - anclaCookiex_92 WHEN Personajes =  94 ELSE 
							pixel_x_s1 - anclaCookiex_93 WHEN Personajes =  95 ELSE 
							pixel_x_s1 - anclaCookiex_94 WHEN Personajes =  96 ELSE 
							pixel_x_s1 - anclaCookiex_95 WHEN Personajes =  97 ELSE 
							pixel_x_s1 - anclaCookiex_96 WHEN Personajes =  98 ELSE 
							pixel_x_s1 - anclaCookiex_97 WHEN Personajes =  99 ELSE 
							pixel_x_s1 - anclaCookiex_98 WHEN Personajes =  100 ELSE 
							pixel_x_s1 - anclaCookiex_99 WHEN Personajes =  101 ELSE 
							pixel_x_s1 - anclaCookiex_100 WHEN Personajes =  102 ELSE 
							0;

	
	 RGB(3 DOWNTO 0) <=  "1111" WHEN  ((Inicio_screen=1  AND Welcome_R(Welcome_R1) = '1' )     OR
	                                  (Personajes = 1  AND Start_signal = '1' AND End_Game = '0'AND Pacman_R(Pacman_R1) = '1')    OR 
	                                  (Personajes = 2  AND Ghost_R(Ghost_R1) = '1' AND Start_signal = '1' AND End_Game = '0' )     OR 
												 ((((Personajes = 3 AND invisible_G1= '0') OR (Personajes = 4 AND invisible_G2= '0') OR (Personajes = 5 AND invisible_G3= '0' ) OR (Personajes= 6 AND invisible_G4= '0' ) OR (Personajes= 7 AND invisible_G5= '0' ) OR 
												     (Personajes=8 AND invisible_G6= '0' ) OR (Personajes=9 AND invisible_G7= '0' ) OR (Personajes=10 AND invisible_G8= '0' ) OR (Personajes=11 AND invisible_G9= '0' )  OR (Personajes=12 AND invisible_G10= '0' ) OR 
													  (Personajes=13 AND invisible_G11= '0' )  OR (Personajes=14 AND invisible_G12= '0' )  OR (Personajes=15 AND invisible_G13= '0' )
													   OR (Personajes=16 AND invisible_G14= '0' )  OR (Personajes=17 AND invisible_G15= '0' )  OR (Personajes=18 AND invisible_G16= '0' )  OR (Personajes=19 AND invisible_G17= '0' )  OR (Personajes=20 AND invisible_G18= '0' )  OR 
														(Personajes=21 AND invisible_G19= '0' )  OR (Personajes=22 AND invisible_G20= '0' )  OR (Personajes=23 AND invisible_G21= '0' ) 
														 OR (Personajes=24 AND invisible_G22= '0' )  OR (Personajes=25 AND invisible_G23= '0' )  OR (Personajes=26 AND invisible_G24= '0' )  OR (Personajes=27 AND invisible_G25= '0' )  OR (Personajes=28 AND invisible_G26= '0' )  OR
														 (Personajes=29 AND invisible_G27= '0' )  OR (Personajes=30 AND invisible_G28= '0' )  OR (Personajes=31 AND invisible_G29= '0' ) 
														 OR (Personajes=32 AND invisible_G30= '0' )  OR (Personajes=33 AND invisible_G31= '0' )  OR (Personajes=34 AND invisible_G32= '0' )  OR (Personajes=35 AND invisible_G33= '0' ) OR (Personajes=36 AND invisible_G34= '0' )  OR 
														 (Personajes=37 AND invisible_G35= '0' ) OR (Personajes=38 AND invisible_G36= '0' )OR (Personajes=39 AND invisible_G37= '0' )OR (Personajes=40 AND invisible_G38= '0' ) OR (Personajes=41 AND invisible_G39= '0' ) OR (Personajes=42    AND invisible_G40= '0' )
														OR (Personajes=43    AND invisible_G41= '0' )
														OR (Personajes=44    AND invisible_G42= '0' )
														OR (Personajes=45    AND invisible_G43= '0' )
														OR (Personajes=46    AND invisible_G44= '0' )
														OR (Personajes=47    AND invisible_G45= '0' )
														OR (Personajes=48    AND invisible_G46= '0' )
														OR (Personajes=49    AND invisible_G47= '0' )
														OR (Personajes=50    AND invisible_G48= '0' )
														OR (Personajes=51    AND invisible_G49= '0' )
														OR (Personajes=52    AND invisible_G50= '0' )
														OR (Personajes=53    AND invisible_G51= '0' )
														OR (Personajes=54    AND invisible_G52= '0' )
														OR (Personajes=55    AND invisible_G53= '0' )
														OR (Personajes=56    AND invisible_G54= '0' )
														OR (Personajes=57    AND invisible_G55= '0' )
														OR (Personajes=58    AND invisible_G56= '0' )
														OR (Personajes=59    AND invisible_G57= '0' )
														OR (Personajes=60    AND invisible_G58= '0' )
														OR (Personajes=61    AND invisible_G59= '0' )
														OR (Personajes=62    AND invisible_G60= '0' )
														OR (Personajes=63    AND invisible_G61= '0' )
														OR (Personajes=64    AND invisible_G62= '0' )
														OR (Personajes=65    AND invisible_G63= '0' )
														OR (Personajes=66    AND invisible_G64= '0' )
														OR (Personajes=67    AND invisible_G65= '0' )
														OR (Personajes=68    AND invisible_G66= '0' )
														OR (Personajes=69    AND invisible_G67= '0' )
														OR (Personajes=70    AND invisible_G68= '0' )
														OR (Personajes=71    AND invisible_G69= '0' )
														OR (Personajes=72    AND invisible_G70= '0' )
														OR (Personajes=73    AND invisible_G71= '0' )
														OR (Personajes=74    AND invisible_G72= '0' )
														OR (Personajes=75    AND invisible_G73= '0' )
														OR (Personajes=76    AND invisible_G74= '0' )
														OR (Personajes=77    AND invisible_G75= '0' )
														OR (Personajes=78    AND invisible_G76= '0' )
														OR (Personajes=79    AND invisible_G77= '0' )
														OR (Personajes=80    AND invisible_G78= '0' )
														OR (Personajes=81    AND invisible_G79= '0' )
														OR (Personajes=82    AND invisible_G80= '0' )
														OR (Personajes=83    AND invisible_G81= '0' )
														OR (Personajes=84    AND invisible_G82= '0' )
														OR (Personajes=85    AND invisible_G83= '0' )
														OR (Personajes=86    AND invisible_G84= '0' )
														OR (Personajes=87    AND invisible_G85= '0' )
														OR (Personajes=88    AND invisible_G86= '0' )
														OR (Personajes=89    AND invisible_G87= '0' )
														OR (Personajes=90    AND invisible_G88= '0' )
														OR (Personajes=91    AND invisible_G89= '0' )
														OR (Personajes=92    AND invisible_G90= '0' )
														OR (Personajes=93    AND invisible_G91= '0' )
														OR (Personajes=94    AND invisible_G92= '0' )
														OR (Personajes=95    AND invisible_G93= '0' )
														OR (Personajes=96    AND invisible_G94= '0' )
														OR (Personajes=97    AND invisible_G95= '0' )
														OR (Personajes=98    AND invisible_G96= '0' )
														OR (Personajes=99    AND invisible_G97= '0' )
														OR (Personajes=100    AND invisible_G98= '0' )
														OR (Personajes=101    AND invisible_G99= '0' )
														OR (Personajes=102    AND invisible_G100= '0' ))  AND Cookies_R(Cookies_R1) = '1') AND Start_signal = '1' AND End_Game = '0')) ELSE --rojo--
							  "0000";  

    RGB(7 DOWNTO 4) <= "1111" WHEN ((Inicio_screen=1 AND Welcome_G(Welcome_G1) = '1' )      OR
	                                (Personajes = 1  AND Pacman_G(Pacman_G1) = '1' AND Start_signal = '1' AND End_Game = '0')     OR 
	                                 (Personajes = 2  AND Ghost_G(Ghost_G1) = '1' AND Start_signal = '1' AND End_Game = '0')       OR 
											   (((Personajes = 3 AND invisible_G1= '0') OR (Personajes = 4 AND invisible_G2= '0') OR (Personajes = 5 AND invisible_G3= '0' ) OR (Personajes= 6 AND invisible_G4= '0' ) OR (Personajes= 7 AND invisible_G5= '0' ) OR 
												     (Personajes=8 AND invisible_G6= '0' ) OR (Personajes=9 AND invisible_G7= '0' ) OR (Personajes=10 AND invisible_G8= '0' ) OR (Personajes=11 AND invisible_G9= '0' )  OR (Personajes=12 AND invisible_G10= '0' ) OR 
													  (Personajes=13 AND invisible_G11= '0' )  OR (Personajes=14 AND invisible_G12= '0' )  OR (Personajes=15 AND invisible_G13= '0' )
													   OR (Personajes=16 AND invisible_G14= '0' )  OR (Personajes=17 AND invisible_G15= '0' )  OR (Personajes=18 AND invisible_G16= '0' )  OR (Personajes=19 AND invisible_G17= '0' )  OR (Personajes=20 AND invisible_G18= '0' )  OR 
														(Personajes=21 AND invisible_G19= '0' )  OR (Personajes=22 AND invisible_G20= '0' )  OR (Personajes=23 AND invisible_G21= '0' ) 
														 OR (Personajes=24 AND invisible_G22= '0' )  OR (Personajes=25 AND invisible_G23= '0' )  OR (Personajes=26 AND invisible_G24= '0' )  OR (Personajes=27 AND invisible_G25= '0' )  OR (Personajes=28 AND invisible_G26= '0' )  OR
														 (Personajes=29 AND invisible_G27= '0' )  OR (Personajes=30 AND invisible_G28= '0' )  OR (Personajes=31 AND invisible_G29= '0' ) 
														 OR (Personajes=32 AND invisible_G30= '0' )  OR (Personajes=33 AND invisible_G31= '0' )  OR (Personajes=34 AND invisible_G32= '0' )  OR (Personajes=35 AND invisible_G33= '0' ) OR (Personajes=36 AND invisible_G34= '0' )  OR 
														 (Personajes=37 AND invisible_G35= '0' ) OR (Personajes=38 AND invisible_G36= '0' )OR (Personajes=39 AND invisible_G37= '0' )OR (Personajes=40 AND invisible_G38= '0' ) OR (Personajes=41 AND invisible_G39= '0' ) OR (Personajes=42    AND invisible_G40= '0' ) 
														 OR (Personajes=43    AND invisible_G41= '0' )
														OR (Personajes=44    AND invisible_G42= '0' )
														OR (Personajes=45    AND invisible_G43= '0' )
														OR (Personajes=46    AND invisible_G44= '0' )
														OR (Personajes=47    AND invisible_G45= '0' )
														OR (Personajes=48    AND invisible_G46= '0' )
														OR (Personajes=49    AND invisible_G47= '0' )
														OR (Personajes=50    AND invisible_G48= '0' )
														OR (Personajes=51    AND invisible_G49= '0' )
														OR (Personajes=52    AND invisible_G50= '0' )
														OR (Personajes=53    AND invisible_G51= '0' )
														OR (Personajes=54    AND invisible_G52= '0' )
														OR (Personajes=55    AND invisible_G53= '0' )
														OR (Personajes=56    AND invisible_G54= '0' )
														OR (Personajes=57    AND invisible_G55= '0' )
														OR (Personajes=58    AND invisible_G56= '0' )
														OR (Personajes=59    AND invisible_G57= '0' )
														OR (Personajes=60    AND invisible_G58= '0' )
														OR (Personajes=61    AND invisible_G59= '0' )
														OR (Personajes=62    AND invisible_G60= '0' )
														OR (Personajes=63    AND invisible_G61= '0' )
														OR (Personajes=64    AND invisible_G62= '0' )
														OR (Personajes=65    AND invisible_G63= '0' )
														OR (Personajes=66    AND invisible_G64= '0' )
														OR (Personajes=67    AND invisible_G65= '0' )
														OR (Personajes=68    AND invisible_G66= '0' )
														OR (Personajes=69    AND invisible_G67= '0' )
														OR (Personajes=70    AND invisible_G68= '0' )
														OR (Personajes=71    AND invisible_G69= '0' )
														OR (Personajes=72    AND invisible_G70= '0' )
														OR (Personajes=73    AND invisible_G71= '0' )
														OR (Personajes=74    AND invisible_G72= '0' )
														OR (Personajes=75    AND invisible_G73= '0' )
														OR (Personajes=76    AND invisible_G74= '0' )
														OR (Personajes=77    AND invisible_G75= '0' )
														OR (Personajes=78    AND invisible_G76= '0' )
														OR (Personajes=79    AND invisible_G77= '0' )
														OR (Personajes=80    AND invisible_G78= '0' )
														OR (Personajes=81    AND invisible_G79= '0' )
														OR (Personajes=82    AND invisible_G80= '0' )
														OR (Personajes=83    AND invisible_G81= '0' )
														OR (Personajes=84    AND invisible_G82= '0' )
														OR (Personajes=85    AND invisible_G83= '0' )
														OR (Personajes=86    AND invisible_G84= '0' )
														OR (Personajes=87    AND invisible_G85= '0' )
														OR (Personajes=88    AND invisible_G86= '0' )
														OR (Personajes=89    AND invisible_G87= '0' )
														OR (Personajes=90    AND invisible_G88= '0' )
														OR (Personajes=91    AND invisible_G89= '0' )
														OR (Personajes=92    AND invisible_G90= '0' )
														OR (Personajes=93    AND invisible_G91= '0' )
														OR (Personajes=94    AND invisible_G92= '0' )
														OR (Personajes=95    AND invisible_G93= '0' )
														OR (Personajes=96    AND invisible_G94= '0' )
														OR (Personajes=97    AND invisible_G95= '0' )
														OR (Personajes=98    AND invisible_G96= '0' )
														OR (Personajes=99    AND invisible_G97= '0' )
														OR (Personajes=100    AND invisible_G98= '0' )
														OR (Personajes=101    AND invisible_G99= '0' )
														OR (Personajes=102    AND invisible_G100= '0' ))   AND Cookies_G(Cookies_G1) = '1' AND Start_signal = '1' AND End_Game = '0')) ELSE --verde
							  "0000";

    RGB(11 DOWNTO 8) <= "1111" WHEN  (Inicio_screen = 1  AND Welcome_B(Welcome_B1) = '1'  )   ELSE
								"1111" WHEN  (Fin_screen= 1  AND End_GameMe(End_GameMe1) = '1' ) ELSE
								"1111" WHEN  ( PrioriImg = 1   AND  Block_B(Block_B1) = '1') ELSE
								"1111" WHEN  ( PrioriImg = 2   AND Block_B_L(Block_B1_L) = '1' ) ELSE
								"1111" WHEN  (Start_signal = '1'AND End_Game='0' AND Personajes= 2  AND Ghost_B(Ghost_B1) = '1') ELSE
                         -- --azul
                        "0000";

								
	Score_PAC <= Score;
		
  
END ARCHITECTURE;
-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo          : Counter_Count_Pixel_Y
-- Funcionalidad   : Contador para generar el PIXEL Y                  
-- Fecha           : D:21 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY Counter_Pixel_Y IS

	GENERIC(	N			:	INTEGER:= 10);
		PORT(	
				Clk 		: IN		STD_LOGIC;
				Rst		: IN		STD_LOGIC;
				Ena      : IN		STD_LOGIC;
				 
				Sequence_V   	: OUT		STD_LOGIC_VECTOR(2 DOWNTO 0);
				Count_Pixel_Y  : OUT    STD_LOGIC_VECTOR(N-1 DOWNTO 0)
				
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF Counter_Pixel_Y IS

	CONSTANT ZEROS		: UNSIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
	
	SIGNAL 	CountS	 : UNSIGNED(N-1 DOWNTO 0);
	SIGNAL	CountNext : UNSIGNED(N-1 DOWNTO 0);
	SIGNAL   MaxTick_S : STD_LOGIC;
	SIGNAL   MaxCount  : UNSIGNED(N-1 DOWNTO 0) := "1000001100";
	                                              --525 pulsos
	SIGNAL   SynClr	 : STD_LOGIC;
	SIGNAL   Load		 : STD_LOGIC:= '0';
	SIGNAL   Up			 : STD_LOGIC:= '1';
	SIGNAL   D			 : STD_LOGIC_VECTOR(N-1 DOWNTO 0):= (OTHERS => '0');
	SIGNAL   MinTick	 : STD_LOGIC;
	SIGNAL	sequence:	UNSIGNED (2 DOWNTO 0);
	

BEGIN

   --==========================================================================
	-- Next state logic
	--==========================================================================
	countNext <= (OTHERS => '0')	WHEN	SynClr   = '1'						  ELSE
					  UNSIGNED(D)		WHEN	Load     = '1'						  ELSE
					  CountS + 1		WHEN	((Ena = '1') AND (Up = '1'))    ELSE
					  CountS - 1		WHEN	((Ena = '1') AND (Up = '0'))    ELSE
					  CountS;
				  

		PROCESS(Clk, Rst, SynClr)
			VARIABLE Temp	: UNSIGNED(N-1 DOWNTO 0);
		BEGIN
			IF(Rst = '1'OR  SynClr= '1') THEN
				Temp := (OTHERS => '0');
			  ELSIF(RISING_EDGE(Clk)) THEN
					IF(Ena = '1')			THEN
						Temp := CountNext;
			       END IF;
			END IF;
			CountS  <= Temp;
		
			
		END PROCESS;
		
	--==========================================================================
	-- Output Logic
	--==========================================================================
						
	MaxTick_S <= '1' WHEN (CountS = "0000000001" OR CountS="0000100010" OR 
	                       CountS = "1000000010" OR CountS="1000001100")ELSE 
					  '0';
					  
	MinTick   <= '1' WHEN CountS = ZEROS    ELSE '0';
	
	Count_Pixel_Y <=STD_LOGIC_VECTOR(CountS);
	
	--========================================================
	--	Secuence Counter Process
	--========================================================	
	sequence_counter: PROCESS (clk, rst, MaxTick_S, Ena)
	BEGIN
		IF (rst = '1') THEN
			sequence		<= "000";
		ELSIF (rising_edge(clk)) THEN
			IF (sequence > "011") THEN
				sequence	<=	"000";
				SynClr  <= '1';
			ELSIF (MaxTick_S = '1' AND Ena='1') THEN
				sequence	<=	sequence+1;
			ELSE
			   SynClr <= '0';
				sequence	<=	sequence;
		   END IF;
		Sequence_V <= STD_LOGIC_VECTOR(sequence);
	   END IF;

	END PROCESS sequence_counter;
	
END ARCHITECTURE;
-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo :   Counter_Data_Logic
-- Funcionalidad: Contador para saber si el dato esta listo                                     
-- Fecha  :   D:13 M:03 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY Counter_Data_Logic IS

	GENERIC(	N			:	INTEGER:= 4);
		PORT(	
				Clk 		: IN		STD_LOGIC;
				Rst		: IN		STD_LOGIC;
				Ena		: IN		STD_LOGIC;
				SynClr	: IN		STD_LOGIC;
				 
				MaxTick	: OUT		STD_LOGIC
				
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF Counter_Data_Logic IS

	CONSTANT ZEROS		: UNSIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
	
	SIGNAL 	CountS	: UNSIGNED(N-1 DOWNTO 0);
	SIGNAL	CountNext: UNSIGNED(N-1 DOWNTO 0);
	SIGNAL   MaxTick_S : STD_LOGIC;
	CONSTANT MaxCount : UNSIGNED(N-1 DOWNTO 0) := "0011";
	                                              --4 pulsos
	SIGNAL   Load		 : STD_LOGIC:= '0';
	SIGNAL   Up			 : STD_LOGIC:= '1';
	SIGNAL   D			 : STD_LOGIC_VECTOR(N-1 DOWNTO 0):= (OTHERS => '0');
	SIGNAL   MinTick	 : STD_LOGIC;
	
	SIGNAL   Counter	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

   --==========================================================================
	-- Next state logic
	--==========================================================================
	countNext <= (OTHERS => '0')	WHEN	SynClr   = '1'						  ELSE
					 (OTHERS => '0')	WHEN  MaxTick_S = '1'					  ELSE
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
			Counter <= STD_LOGIC_VECTOR(Temp);
			CountS  <= Temp;
		
			
		END PROCESS;
		
	--==========================================================================
	-- Output Logic
	--==========================================================================
	
	MaxTick_S <= '1' WHEN CountS = MaxCount ELSE '0';
	MinTick  <= '1' WHEN CountS = ZEROS    ELSE '0';

	MaxTick <= MaxTick_S;

END ARCHITECTURE;
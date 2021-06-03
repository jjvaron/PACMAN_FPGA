-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo :   Debouncer
-- Funcionalidad: FSM para evitar el antirrebote (Debouncer) en un pulsador                                          
-- Fecha  :   D:18 M:03 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY Debouncer IS
	GENERIC(	
				N			:	INTEGER:= 16;
				MAX		:  INTEGER:= 25);
		PORT(	
		      clk 		            : IN		STD_LOGIC;
				rst		            : IN		STD_LOGIC;
				InputPulse           : IN     STD_LOGIC;
				
				led						: OUT 	STD_LOGIC
--				clk_10_out				: OUT 	STD_LOGIC
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF Debouncer IS

	SIGNAL clk_10	  : 	STD_LOGIC;
	SIGNAL outputPulse_s : STD_LOGIC;
	SIGNAL MaxTick_S 	  :	STD_LOGIC;
	SIGNAL MinTick_S 	  :	STD_LOGIC;
	SIGNAL SynClr_S  	  :	STD_LOGIC;
	SIGNAL EnaCounter_S :	STD_LOGIC;
	SIGNAL CurrentCount :	STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL FixedData    :   STD_LOGIC_VECTOR(N-1 DOWNTO 0):="0000000000000000";
	CONSTANT CountUp	  :   STD_LOGIC:='1';
	CONSTANT FixedLoad  :   STD_LOGIC:='0';
BEGIN

   ------------------------------------------------		
 pll: ENTITY work.my_pll
	PORT MAP ( 	inclk0		=> clk,
					c0				=> clk_10);

   ------------------------------------------------		
	FSM: ENTITY work.DebouncerFSM
	PORT MAP(Clk 				 => clk_10,
				Rst				 => rst,
				InputPulse		 => InputPulse,
				MaxTickCounter  => MaxTick_S,				
				EnableCounter   => EnaCounter_S,
				SynClrCounter   => SynClr_S,
				OutputPulse     => outputPulse_s);
		
   ------------------------------------------------		

	Counter: ENTITY work.Counter5mseg
	GENERIC MAP   ( N => N )
	PORT MAP(Clk 		=> clk_10,
				Rst		=> rst,
				Ena		=> EnaCounter_S, 
				SynClr	=> SynClr_S,
				Load		=> FixedLoad,
				Up			=> CountUp,
				D			=> FixedData,
				MaxTick	=> MaxTick_S ,
				MinTick	=> MinTick_S,
				Counter	=>	CurrentCount);
	
   ------------------------------------------------		

--	BIST: ENTITY work.test_signal_generator
--	GENERIC MAP	(	DELAY_PULSES		=> 4)		
--	PORT MAP		(	clk				=> clk_10,
--						rst				=> rst,
--						InputPulse		=> InputPulse);
--						
						
	--clk_10_out <= clk_10;
	led <= (NOT outputPulse_s);
	
	END ARCHITECTURE;
-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo :   DebouncerFSM
-- Funcionalidad: FSM para evitar el antirrebote (Debouncer) en un pulsador                                          
-- Fecha  :   D:18 M:03 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY DebouncerFSM IS

		PORT(	
		      Clk 		            : IN		STD_LOGIC;
				Rst		            : IN		STD_LOGIC;
				InputPulse        	: IN		STD_LOGIC;							
				MaxTickCounter       : IN     STD_LOGIC;
				EnableCounter			: OUT		STD_LOGIC;
				SynClrCounter        : OUT    STD_LOGIC;
				OutputPulse				: OUT		STD_LOGIC
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF DebouncerFSM IS

	TYPE state IS ( InitialState, FirstIntState, SecondIntState, ThirdIntState, 
						 OutputState);
	SIGNAL	PrState, NxState : state;
	
BEGIN

	lower_fsm: PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			PrState <= InitialState;
		ELSIF (rising_edge(clk)) THEN
			PrState <= NxState;
		END IF;
	END PROCESS lower_fsm;
	
	--========================================================
	--Upper part FSM
	--========================================================
	upper_fsm: PROCESS(PrState, Clk, InputPulse, MaxTickCounter)
	BEGIN
		CASE PrState IS
			------------------------------------------------------
			WHEN InitialState => -- Estado inicial
				
				SynClrCounter		<= '0'; 										
				OutputPulse			<= '0';														
				EnableCounter 		<= '0'; -- habilito counter5mseg(este enable permanece activo hasta que se vuela a cambiar?)
				
				
				IF (InputPulse = '1') THEN -- Si se presiona el pulsador
					NxState		<=	FirstIntState;					
				ELSE 					
					NxState		<=	InitialState;	
				END IF;
				
			------------------------------------------------------
			WHEN FirstIntState => 		   -- Primer Intervalo (First Interval)
				-- asignación al valor de las salidas 										
				SynClrCounter		<= '0'; 										
				OutputPulse			<= '0';														
				EnableCounter 		<= '1';				
						
				IF ((MaxTickCounter = '0') AND (InputPulse = '1')) THEN
					NxState			<=	FirstIntState;
				ELSIF ((MaxTickCounter = '1') AND (InputPulse = '1')) THEN
					NxState			<=	SecondIntState;
				ELSE 
					NxState		<=	InitialState;
				END IF;
	
			------------------------------------------------------
			WHEN SecondIntState => 		 		-- Segundo Intervalo (Second Interval)
				SynClrCounter		<= '0'; 										
				OutputPulse			<= '0';														
				EnableCounter 		<= '1';				
						
				IF ((MaxTickCounter = '0') AND (InputPulse = '1')) THEN
					NxState			<=	SecondIntState;
				ELSIF ((MaxTickCounter = '1') AND (InputPulse = '1')) THEN
					NxState			<=	ThirdIntState;
				ELSE 
					NxState		<=	InitialState;
				END IF;
			------------------------------------------------------
			WHEN ThirdIntState =>
				
				SynClrCounter		<= '0'; 										
				OutputPulse			<= '0';														
				EnableCounter 		<= '1';				
						
				IF ((MaxTickCounter = '0') AND (InputPulse = '1')) THEN
					NxState			<=	ThirdIntState;
				ELSIF ((MaxTickCounter = '1') AND (InputPulse = '1')) THEN
					NxState			<=	OutputState;
				ELSE 
					NxState		<=	InitialState;
				END IF;
			------------------------------------------------------
			WHEN OutputState => 			
																		
				SynClrCounter		<= '1'; 										
				OutputPulse			<= '1';														
				EnableCounter 		<= '0';				
				
				IF (InputPulse = '1') THEN
				NxState			<=	OutputState;
				ELSE
				NxState			<=	InitialState;
				END IF;				
			------------------------------------------------------
		END CASE;
	END PROCESS;


END ARCHITECTURE;
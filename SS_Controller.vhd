-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo :   SS_Controller
-- Funcionalidad: Crontrol de los enables de los contadores del cronometro                                          
-- Fecha  :   D:10 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY SS_Controller IS
		PORT(	
		      clk 		            : IN		STD_LOGIC;
				rst		            : IN		STD_LOGIC;
				enable               : IN     STD_LOGIC;
				ena_display          : IN     STD_LOGIC;
				fin_s                : IN     STD_LOGIC;
				MaxTick_S            : IN     STD_LOGIC;
			   data_ready_d         : IN     STD_LOGIC;
				
				enable7Seg				: OUT		STD_LOGIC_VECTOR(3 DOWNTO 0);	
				SynClrCounter        : OUT    STD_LOGIC;
				enable_counter  		: OUT		STD_LOGIC;
				ena_c_data           : OUT    STD_LOGIC;
            clr_cdata            : OUT    STD_LOGIC;
	         ena_divide           : OUT    STD_LOGIC_VECTOR (2 DOWNTO 0);
            aclr_divide          : OUT    STD_LOGIC_VECTOR (2 DOWNTO 0)
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF SS_Controller IS

	TYPE state IS ( Initial, Wait_Ena, Divide_Mil, Wait_Mil, Divide_Cen, Wait_Cen, Divide_Dec, Wait_Dec, 
	                Result_7Seg, Check_End);
	SIGNAL	pr_state, nx_state : state;
	
BEGIN

	lower_fsm: PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			pr_state <= Initial;
		ELSIF (rising_edge(clk)) THEN
			pr_state <= nx_state;
		END IF;
	END PROCESS lower_fsm;

	--========================================================
	--Upper part FSM
	--========================================================
	upper_fsm: PROCESS(pr_state, clk, MaxTick_S,enable, data_ready_d,ena_display, fin_s)
	BEGIN
		CASE pr_state IS
		   ------------------------------------------------------
			WHEN Initial => 
			   				
				enable7Seg				<= "0000";	
				SynClrCounter        <= '1';
				enable_counter 		<= '0';
				ena_c_data           <= '0';
            clr_cdata            <= '1';
	         ena_divide           <= "000"; 
            aclr_divide          <= "111";

				IF (enable = '1') THEN 
					nx_state	<=	Wait_Ena;					
				ELSE 					
					nx_state	<=	Initial;	
				END IF;
			------------------------------------------------------
			WHEN Wait_Ena => 
			   				
				enable7Seg				<= "1111";	
				SynClrCounter        <= '1';
				enable_counter 		<= '0';
				ena_c_data           <= '0';
            clr_cdata            <= '1';
	         ena_divide           <= "000"; 
            aclr_divide          <= "000";

				IF (ena_display = '1') THEN 
					nx_state	<=	Divide_Mil;					
				ELSE 					
					nx_state	<=	Wait_Ena;	
				END IF;

			------------------------------------------------------
			WHEN Divide_Mil => 
			   				
				enable7Seg				<= "0000";
				SynClrCounter        <= '0';
				enable_counter 		<= '0';
				ena_c_data           <= '1';
            clr_cdata            <= '0';
	         ena_divide           <= "001"; 
            aclr_divide          <= "000";

				nx_state	<=	Wait_Mil;					
			------------------------------------------------------
			WHEN Wait_Mil => 
			   				
				enable7Seg				<= "0000";
				SynClrCounter        <= '0';
				enable_counter 		<= '0';
				ena_c_data           <= '1';
            clr_cdata            <= '0';
	         ena_divide           <= "001"; 
            aclr_divide          <= "000";

				IF (data_ready_d= '1') THEN 
					nx_state	<=	Divide_Cen;					
				ELSE 					
					nx_state	<=	Wait_Mil;	
				END IF;	
				
			------------------------------------------------------
			WHEN Divide_Cen => 
			   				
				enable7Seg				<= "0000";
				SynClrCounter        <= '0';
				enable_counter 		<= '0';
				ena_c_data           <= '1';
            clr_cdata            <= '0';
	         ena_divide           <= "010"; 
            aclr_divide          <= "000";

				nx_state	<=	Wait_Cen;					
			------------------------------------------------------
			WHEN Wait_Cen => 
			   				
				enable7Seg				<= "0000";	
				SynClrCounter        <= '0';
				enable_counter 		<= '0';
				ena_c_data           <= '1';
            clr_cdata            <= '0';
	         ena_divide           <= "010"; 
            aclr_divide          <= "000";

				IF (data_ready_d= '1') THEN 
					nx_state	<=	Divide_Dec;					
				ELSE 					
					nx_state	<=	Wait_Cen;	
				END IF;	
			------------------------------------------------------
			WHEN Divide_Dec => 
			   				
				enable7Seg				<= "0000";	
				SynClrCounter        <= '0';
				enable_counter 		<= '0';
				ena_c_data           <= '1';
            clr_cdata            <= '0';
	         ena_divide           <= "100"; 
            aclr_divide          <= "000";

				nx_state	<=	Wait_Dec;					
			------------------------------------------------------
			WHEN Wait_Dec => 
			   				
				enable7Seg				<= "0000";
				SynClrCounter        <= '0';
				enable_counter 		<= '0';
				ena_c_data           <= '1';
            clr_cdata            <= '0';
	         ena_divide           <= "100"; 
            aclr_divide          <= "000";

				IF (data_ready_d= '1') THEN 
					nx_state	<=	Result_7Seg;					
				ELSE 					
					nx_state	<=	Wait_Dec;	
				END IF;	
			------------------------------------------------------
			WHEN Result_7Seg => 
			   				
				enable7Seg				<= "1111";	
				SynClrCounter        <= '0';
				enable_counter 		<= '1';
				ena_c_data           <= '0';
            clr_cdata            <= '1';
	         ena_divide           <= "000"; 
            aclr_divide          <= "000";

				IF (MaxTick_S= '1') THEN 
					nx_state	<=	Check_End;					
				ELSE 					
					nx_state	<=	Result_7Seg;	
				END IF;		
			------------------------------------------------------
			WHEN Check_End => 
			   				
				enable7Seg				<= "1111";	
				SynClrCounter        <= '1';
				enable_counter 		<= '0';
				ena_c_data           <= '0';
            clr_cdata            <= '1';
	         ena_divide           <= "000"; 
            aclr_divide          <= "000";

				IF (fin_s= '1') THEN 
					nx_state	<=	Initial;					
				ELSE 					
					nx_state	<=	Wait_Ena;
				END IF;		
			------------------------------------------------------
		END CASE;
	END PROCESS;


	
END ARCHITECTURE;
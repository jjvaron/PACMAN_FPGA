-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo          : CTRL_Vsync
-- Funcionalidad   : Control VGA para Vsync                 
-- Fecha           : D:23 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY CTRL_Vsync IS

		PORT(	
			Sequence_V     :  IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
			vsync          :  OUT  STD_LOGIC;
			v_video_on     :  OUT  STD_LOGIC
				
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF CTRL_Vsync IS

BEGIN
   vsync  <= '1' WHEN (sequence_V= "001" OR sequence_V="010" OR 
	                    sequence_V= "011") ELSE
	          '0';
   v_video_on <= '1' WHEN (Sequence_V="010") ELSE
	              '0';
	
END ARCHITECTURE;
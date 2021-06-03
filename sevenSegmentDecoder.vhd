--***********************************************************--
--		       PONTIFICIA UNIVERSIDAD JAVERIANA              	 --
--				       DISEÑO EN FPGA 	                 			 --
--		      	            											 --
-- Nombres:Jelitza Varon,Pilar Chaparro,Lorena Castillo  	 --
-- Decoder 7 segmentos						                      --
--***********************************************************--

--***********************************************************--
--DEFINICIÓN DE LIBRERIAS 				                         --
--***********************************************************--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


--***********************************************************--
--DEFINICIÓN DE LA ENTIDAD 			                         --
--***********************************************************--
ENTITY sevenSegmentDecoder IS 
PORT (
		enable: IN STD_LOGIC; 
		input : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
		output: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
	
END ENTITY sevenSegmentDecoder;

ARCHITECTURE functional OF sevenSegmentDecoder IS

SIGNAL UNO, DOS, TRES, CUATRO,CERO  	 :  STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL CINCO, SEIS, SIETE, OCHO, NUEVE  :  STD_LOGIC_VECTOR(12 DOWNTO 0);
--**********************************************************--
--INSTANCIAS Y CONECTIVIDAD                                 --
--**********************************************************--
BEGIN 
	CERO   <= "0000000000000";
	UNO    <= "0000000000001";
	DOS    <= "0000000000010";
	TRES   <= "0000000000011";
	CUATRO <= "0000000000100";
	CINCO  <= "0000000000101";
	SEIS   <= "0000000000110";
	SIETE  <= "0000000000111";
	OCHO   <= "0000000001000";
	NUEVE  <= "0000000001001";
	
		output <= "1000000" WHEN ((input = CERO)   AND (enable = '1'))    ELSE --0
					 "1111001" WHEN ((input = UNO) 	 AND (enable = '1'))    ELSE --1
					 "0100100" WHEN ((input = DOS) 	 AND (enable = '1'))    ELSE --2
					 "0110000" WHEN ((input = TRES) 	 AND (enable = '1'))    ELSE --3
					 "0011001" WHEN ((input = CUATRO) AND (enable = '1'))    ELSE --4
					 "0010010" WHEN ((input = CINCO)  AND (enable = '1'))    ELSE --5
					 "0000010" WHEN ((input = SEIS)   AND (enable = '1'))    ELSE --6
					 "1111000" WHEN ((input = SIETE)  AND (enable = '1'))    ELSE --7
					 "0000000" WHEN ((input = OCHO)   AND (enable = '1'))    ELSE --8
					 "0011000" WHEN ((input = NUEVE)  AND (enable = '1'))    ELSE --9
		          "1111111";
	
END ARCHITECTURE; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;

entity Operator_to_7_segment is
		generic ( n : integer := 5);
		Port ( clock  : in  std_logic;	-- system clock
				 data_i 	: in  STD_LOGIC_VECTOR (n-1 downto 0);
				 data_out : out std_logic_vector (1 downto 0);
				 seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0));
end Operator_to_7_segment;

architecture converter of Operator_to_7_segment is
 signal op_logic : STD_LOGIC_VECTOR (1 downto 0);
	begin
		process(clock)  -- sensitivity list
			begin
				op_logic(0) <= data_i(0);
				op_logic(1) <= data_i(1);
				data_out <= op_logic;
				case op_logic is
					when "00" => 
						seven_seg_digit_1 <= "0001111";
						seven_seg_digit_2 <= "1111111";
					when "01" => 
						seven_seg_digit_1 <= "0111111";
						seven_seg_digit_2 <= "1111111";
					when "10" => 
						seven_seg_digit_1 <= "0011100";
						seven_seg_digit_2 <= "1111111";
					when "11" => 
						seven_seg_digit_1 <= "1001111";
						seven_seg_digit_2 <= "1111111";
					when others => 
						seven_seg_digit_1 <= "1110001";
						seven_seg_digit_2 <= "1110001";
				end case;
		end process; 
end converter;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;

entity Binary_to_BCD_sign is
		generic ( n : integer := 5);
		Port ( clk_i  : in  std_logic;	-- system clock
             enb  : in  std_logic; 	-- synchronous reset, active-high
				 data 	: in  STD_LOGIC_VECTOR (n-1 downto 0);
				 BCD_digit_1 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_2 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_3 : out STD_LOGIC_VECTOR (3 downto 0);
				 ovf : in std_logic );
					  
end Binary_to_BCD_sign;

architecture Behavioral of Binary_to_BCD_sign is
signal int_data_1 : integer := 0;
signal int_data_2 : integer:= 0;
signal int_data_3 : integer:= 0;
	begin
		process(clk_i, enb)
			begin
				if (enb='1' ) then  
					
					if (clk_i'event and clk_i='1') then  
						int_data_1 <= conv_integer(unsigned(data)) mod 10;
						int_data_2 <= ((conv_integer(unsigned(data))mod 100) / 10 );
						int_data_3 <= ((conv_integer(unsigned(data))mod 1000) / 100 );
						if ovf = '1' then
							int_data_1 <= 15;
							int_data_2 <= 15;
							int_data_3 <= 15;
						end if;
					end if;
					BCD_digit_1 <= conv_std_logic_vector(int_data_1, 4);
					BCD_digit_2 <= conv_std_logic_vector(int_data_2, 4);
					BCD_digit_3 <= conv_std_logic_vector(int_data_3, 4);
				end if;
		end process;

		
end Behavioral;
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;

entity fullAdder_1_bit is
		Port ( clk_i  : in  std_logic;	-- system clock
             rst_i  : in  std_logic; 	-- synchronous reset, active-high
				 data_a 	: in  std_logic;
				 data_b	: in  std_logic;
				 carry_in : in std_logic;
				 sum : out std_logic;
				 carry_out : out std_logic );
					  
end fullAdder_1_bit;

architecture Behavioral of fullAdder_1_bit is
	begin
		process(clk_i, rst_i)
			begin
				if (rst_i='1' ) then  
					if (clk_i'event and clk_i='1') then  
						sum <= (data_a XOR data_b) XOR carry_in;
						carry_out <= (data_a and data_b) OR ((data_a XOR data_b) and carry_in);
					end if;
				end if;
		end process;

		
end Behavioral;
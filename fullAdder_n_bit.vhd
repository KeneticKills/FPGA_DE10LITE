library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;

entity fullAdder_n_bit is
		Generic (n : integer := 5);
		Port ( clk_i, rst_i, m  : in  std_logic; 	-- synchronous reset, active-high
				 data_a, data_b 	: in  STD_LOGIC_VECTOR (n-1 downto 0);
				 overflow, carry : out std_logic;
				 data_out : out STD_LOGIC_VECTOR (n-1 downto 0));
					  
end fullAdder_n_bit;

architecture Behavioral of fullAdder_n_bit is
	signal sum : STD_LOGIC_VECTOR (n-1 downto 0);
	signal x : STD_LOGIC_VECTOR (n downto 0);
	signal carry_out : std_logic;
		begin  
			adder : for i in 0 to n-1 generate
				 com1 : if i = 0 generate
					 FA_1 : entity work.fullAdder_1_bit(Behavioral)
					 port map(
						 clk_i => clk_i,
						 rst_i => rst_i,
						 data_a  => data_a(i),
						 data_b  => data_b(i) XOR m,
						 carry_in => m,
						 sum => sum(i),
						 carry_out => x(i));
				end generate;
				com2 : if i > 0 and i < n-1 generate
					FA_2 : entity work.fullAdder_1_bit(Behavioral)
					port map(
						 clk_i => clk_i,
						 rst_i => rst_i,
						 data_a  => data_a(i),
						 data_b  => data_b(i) XOR m,
						 carry_in => x(i-1),
						 sum => sum(i),
						 carry_out => x(i));
			  end generate;
			  com3 : if i = n-1 generate
				  FA_3 : entity work.fullAdder_1_bit(Behavioral)
				  port map(
						 clk_i => clk_i,
						 rst_i => rst_i,
						 data_a  => data_a(i),
						 data_b  => data_b(i) XOR m,
						 carry_in => x(i-1),
						 sum => sum(i),
						 carry_out => carry_out);
			  end generate;
		end generate;
		process(clk_i,rst_i)  -- sensitivity list
			begin
				if rst_i = '1' then
					data_out <= sum;
					carry <= carry_out;
					overflow <= (carry_out Xor x(n-2));
				end if;
		end process;
		
end Behavioral;
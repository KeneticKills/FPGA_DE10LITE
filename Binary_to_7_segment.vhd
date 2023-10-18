library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;

entity Binary_to_7_segment is
		generic ( n : integer := 5);
		Port ( clock  : in  std_logic;	-- system clock
             enable  : in  std_logic; 	-- synchronous reset, active-high
				 data_i 	: in  STD_LOGIC_VECTOR (n-1 downto 0);
				 seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_3 : out STD_LOGIC_VECTOR (6 downto 0) );
end Binary_to_7_segment;

architecture converter of Binary_to_7_segment is
 signal UNSIGNED_DATA : STD_LOGIC_VECTOR (n-1 downto 0);
 signal BCD_data_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_2 : STD_LOGIC_VECTOR (3 downto 0);
 signal sign_bit : STD_LOGIC := data_i(n-1);
 signal overflow : STD_LOGIC ;
	begin
		unsigned_convert:		entity work.fullAdder_n_bit(Behavioral)
									generic map( n => n )
									port map(
										clk_i => clock,
										rst_i => enable,
										m => data_i(n-1),
										data_a => conv_std_logic_vector(0, n),
										data_b => data_i,
										data_out => UNSIGNED_DATA,
										overflow => overflow);
		
		convert_binary:		entity work.Binary_to_BCD_sign(Behavioral)
									generic map( n => n)
									port map(
										clk_i => clock,
										enb => enable,
										data  => UNSIGNED_DATA,
										BCD_digit_1 => BCD_data_digit_1,
										BCD_digit_2 => BCD_data_digit_2,
										ovf => '0');
		seven_seg_display_1: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => clock,
										enb => enable,
										BCD_i  => BCD_data_digit_1,
										seven_seg  =>seven_seg_digit_1 );
		seven_seg_display_2: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => clock,
										enb => enable,
										BCD_i  => BCD_data_digit_2,
										seven_seg  =>seven_seg_digit_2 );
		seven_seg_display_3: entity work. sign_to_7_segment(data_process)
									port map(
										clk_i => clock,
										enb => enable,
										sign  => sign_bit,
										ovf => '0',
										seven_seg  =>seven_seg_digit_3 );
end converter;


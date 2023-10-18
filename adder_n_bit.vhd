library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;

entity adder_n_bit is
    generic (
        n : integer := 5
    );
    Port (
		  CLK,m : in std_logic;
        A,B: in STD_LOGIC_VECTOR(N - 1 downto 0):= (others => '0');
		  seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_3 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_4 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_5 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_6 : out STD_LOGIC_VECTOR (6 downto 0)
    );
end adder_n_bit;

architecture Behavioral of adder_n_bit is
signal UNSIGNED_DATA : STD_LOGIC_VECTOR (n-1 downto 0);
signal result : std_logic_vector(n-1 downto 0):= (others => '0'); 
signal BCD_data_digit_1, BCD_data_digit_2,BCD_data_digit_3 : std_logic_vector(3 downto 0);
signal D,overflow : std_logic ;
signal enable : std_logic := '1';
begin
		AdderSubtracter :		entity work.fullAdder_n_bit(Behavioral)
										generic map( n => n)
											port map(
											clk_i => CLK,
											rst_i => enable,
											data_a => A,
											data_b => B,
											m => m,
											data_out => result,
											overflow => overflow
										);
		unsigned_convert:		entity work.fullAdder_n_bit(Behavioral)
									generic map( n => n )
									port map(
										clk_i => CLK,
										rst_i => enable,
										m => result(n-1),
										data_a => conv_std_logic_vector(0, n),
										data_b => result,
										data_out => UNSIGNED_DATA);
		convert_binary:		entity work.Binary_to_BCD_sign(Behavioral)
										generic map( n => n)
										port map(
											clk_i => CLK,
											enb => enable,
											data  => UNSIGNED_DATA,
											BCD_digit_1 => BCD_data_digit_1,
											BCD_digit_2 => BCD_data_digit_2,
											BCD_digit_3 => BCD_data_digit_3,
											ovf => overflow);
		seven_seg_display_1: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => CLK,
										enb => enable,
										BCD_i  => BCD_data_digit_1,
										seven_seg  =>seven_seg_digit_1 );
		seven_seg_display_2: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => CLK,
										enb => enable,
										BCD_i  => BCD_data_digit_2,
										seven_seg  =>seven_seg_digit_2 );
		seven_seg_display_3: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => CLK,
										enb => enable,
										BCD_i  => BCD_data_digit_3,
										seven_seg  =>seven_seg_digit_3 );
		seven_seg_display_4: entity work. sign_to_7_segment(data_process)
									port map(
										clk_i => CLK,
										enb => enable,
										sign  => result(n-1),
										ovf => overflow,
										seven_seg  =>seven_seg_digit_4 );
		process(CLK)
		begin
			if(overflow = '0') then
				seven_seg_digit_5 <= "1000000";
				seven_seg_digit_6 <= "1000000";
			elsif(overflow = '1') then
				seven_seg_digit_5 <= "0001110";
				seven_seg_digit_6 <= "0001110";
			end if;
		end process;
end Behavioral;
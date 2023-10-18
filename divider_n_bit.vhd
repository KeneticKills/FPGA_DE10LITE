library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity divider_n_bit is
    generic (
        n : integer := 5
    );
    Port (
		  CLK : in std_logic;
        A,B: in STD_LOGIC_VECTOR(N - 1 downto 0):= (others => '0');
		  seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_3 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_4 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_5 : out STD_LOGIC_VECTOR (6 downto 0);
		  seven_seg_digit_6 : out STD_LOGIC_VECTOR (6 downto 0)
    );
end divider_n_bit;

architecture Behavioral of divider_n_bit is
signal result,remider,zero : std_logic_vector(n - 1 downto 0):= (others => '0'); 
signal BCD_data_digit_1, BCD_data_digit_2,BCD_data_digit_3 : std_logic_vector(3 downto 0);
signal BCD_remider_digit_1, BCD_remider_digit_2 : std_logic_vector(3 downto 0);
signal sign_tem,D,ovf : std_logic ;
signal enable : std_logic := '1';
begin
		divider : entity work.BinaryDivider(Behavioral)
					generic map(N => n)
					port map(
						clk => CLK,
						d => A,
						m => B,
						q => result,
						r => remider,
						sign => sign_tem,
						done => D,
						ovf => ovf
					);
		convert_binary:		entity work.Binary_to_BCD_sign(Behavioral)
										generic map( n => n)
										port map(
											clk_i => CLK,
											enb => enable,
											data  => result,
											BCD_digit_1 => BCD_data_digit_1,
											BCD_digit_2 => BCD_data_digit_2,
											BCD_digit_3 => BCD_data_digit_3,
											ovf => ovf);
		convert_binary_remider:		entity work.Binary_to_BCD_sign(Behavioral)
										generic map( n => n)
										port map(
											clk_i => CLK,
											enb => enable,
											data  => remider,
											BCD_digit_1 => BCD_remider_digit_1,
											BCD_digit_2 => BCD_remider_digit_2,
											ovf => ovf);
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
										sign  => sign_tem,
										ovf => ovf,
										seven_seg  =>seven_seg_digit_4 );
		
		seven_seg_display_5: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => CLK,
										enb => enable,
										BCD_i  => BCD_remider_digit_1,
										seven_seg  =>seven_seg_digit_5 );
		seven_seg_display_6: entity work. BDC_to_7_segment(data_process)
									port map(
										clk_i => CLK,
										enb => enable,
										BCD_i  => BCD_remider_digit_2,
										seven_seg  =>seven_seg_digit_6 );
end Behavioral;
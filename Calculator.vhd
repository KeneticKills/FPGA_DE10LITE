library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;

entity Calculator is
		Generic (
			n : integer := 5
		);
		Port ( clock  : in  std_logic;	-- system clock
             reset  : in  std_logic; 	-- synchronous reset, active-high
				 data_in_1 	: in  STD_LOGIC_VECTOR (n-1 downto 0);
				 data_in_2 	: in  STD_LOGIC_VECTOR (n-1 downto 0);
				 start		: in std_logic;
				 DONE 		: out STD_LOGIC_VECTOR(10 downto 0);
				 seven_seg_digit_A_1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_A_2 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_A_3 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_B_1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_B_2 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_B_3 : out STD_LOGIC_VECTOR (6 downto 0)  );
end Calculator;

architecture converter of Calculator is
signal value_get_A_1,
		 value_get_A_2,
		 value_get_A_3,
		 value_get_B_1,
		 value_get_B_2,
		 value_get_B_3 : STD_LOGIC_VECTOR (6 downto 0);
signal result_7seg_M_1,
		 result_7seg_M_2,
		 result_7seg_M_3,
		 result_7seg_M_4,
		 remider_7seg_M_1,
		 remider_7seg_M_2 : STD_LOGIC_VECTOR (6 downto 0);
signal result_7seg_D_1,
		 result_7seg_D_2,
		 result_7seg_D_3,
		 result_7seg_D_4,
		 remider_7seg_D_1,
		 remider_7seg_D_2 : STD_LOGIC_VECTOR (6 downto 0);
signal result_7seg_AS_1,
		 result_7seg_AS_2,
		 result_7seg_AS_3,
		 result_7seg_AS_4,
		 remider_7seg_AS_1,
		 remider_7seg_AS_2 : STD_LOGIC_VECTOR (6 downto 0);
signal show_op_B_1,
		 show_op_B_2 : STD_LOGIC_VECTOR (6 downto 0);
signal value_get_data_A, value_get_data_B , tem_data_A , tem_data_B : std_logic_vector (n-1 downto 0);

signal value_get_op,tem_op : std_logic_vector (1 downto 0);

signal remider, result , result_AS : std_logic_vector (n-1 downto 0);
signal overflow_A : STD_LOGIC ;

signal BCD_data_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
signal BCD_data_digit_2 : STD_LOGIC_VECTOR (3 downto 0);
signal final_data_1, final_data_2 : STD_LOGIC_VECTOR (n-1 downto 0);
signal sign : STD_LOGIC_VECTOR(1 downto 0);
signal enable_1 : STD_LOGIC := '0';
signal enable_2 : STD_LOGIC := '0';
signal enable_3 : STD_LOGIC := '0';
signal old_st : std_logic := '1';
type cal_type is (
		INUM,
		IOP,
		OUTP);
signal cal_state : cal_type := INUM;
	begin
		state_1_A : entity work.Binary_to_7_segment(converter)
						 generic map( n => n )
						 port map(
						 clock => clock,
						 data_i => data_in_1,
						 enable => enable_1,
						 seven_seg_digit_1 => value_get_A_1,
						 seven_seg_digit_2 => value_get_A_2,
						 seven_seg_digit_3 => value_get_A_3);
					 
		state_1_B :entity work.Binary_to_7_segment(converter)
						 generic map( n => n )
						 port map(
						 clock => clock,
						 data_i => data_in_2,
						 enable => enable_1,
						 seven_seg_digit_1 => value_get_B_1,
						 seven_seg_digit_2 => value_get_B_2,
						 seven_seg_digit_3 => value_get_B_3);
		
		state_2	:entity work.Operator_to_7_segment(converter)
						generic map( n => n)
						port map(
						clock => clock,
						data_i => data_in_2,
						data_out => value_get_op,
						seven_seg_digit_1 => show_op_B_1,
						seven_seg_digit_2 => show_op_B_2
						);
					 
		state_3_AS :entity work.adder_n_bit(Behavioral)
						generic map( n => n)
						port map(
						 CLK => clock,
						 A => tem_data_A,
						 B => tem_data_B,
						 m => tem_op(0),
						 seven_seg_digit_1 => result_7seg_AS_1,
						 seven_seg_digit_2 => result_7seg_AS_2,
						 seven_seg_digit_3 => result_7seg_AS_3,
						 seven_seg_digit_4 => result_7seg_AS_4,
						 seven_seg_digit_5 => remider_7seg_AS_1,
						 seven_seg_digit_6 => remider_7seg_AS_2);
						
		state_3_M :entity work.multiply_n_bit(Behavioral)
						generic map( N => n )
						 port map(
						 CLK => clock,
						 enable => enable_2,
						 A => tem_data_A,
						 B => tem_data_B,
						 seven_seg_digit_1 => result_7seg_M_1,
						 seven_seg_digit_2 => result_7seg_M_2,
						 seven_seg_digit_3 => result_7seg_M_3,
						 seven_seg_digit_4 => result_7seg_M_4,
						 seven_seg_digit_5 => remider_7seg_M_1,
						 seven_seg_digit_6 => remider_7seg_M_2);
						 
		state_3_D :entity work.divider_n_bit(Behavioral)
						generic map( N => n )
						 port map(
						 CLK => clock,
						 A => tem_data_A,
						 B => tem_data_B,
						 seven_seg_digit_1 => result_7seg_D_1,
						 seven_seg_digit_2 => result_7seg_D_2,
						 seven_seg_digit_3 => result_7seg_D_3,
						 seven_seg_digit_4 => result_7seg_D_4,
						 seven_seg_digit_5 => remider_7seg_D_1,
						 seven_seg_digit_6 => remider_7seg_D_2);
					 
		process(clock,reset)
		begin
			if(reset = '0') then
				cal_state <= INUM;
			elsif rising_edge(clock) then
				case cal_state is
					when INUM =>
						if(start /= old_st) then
							old_st <= start;
							if(start='0') then
								cal_state <= IOP;
							else
								cal_state <= INUM;
							end if;
						elsif start = old_st then
							cal_state <= INUM;
							enable_1 <= '1';
							enable_2 <= '0';
							enable_3 <= '0';
							seven_seg_digit_A_1 <= value_get_A_1;
							seven_seg_digit_A_2 <= value_get_A_2;
							seven_seg_digit_A_3 <= value_get_A_3;
							seven_seg_digit_B_1 <= value_get_B_1;
							seven_seg_digit_B_2 <= value_get_B_2;
							seven_seg_digit_B_3 <= value_get_B_3;
							tem_data_A <= data_in_1;
							tem_data_B <= data_in_2;
							DONE <= "10000000000";
						end if;
						
					when IOP =>
						if(start /= old_st) then
							old_st <= start;
							if (start='0') then
								cal_state <= OUTP;
							else
								cal_state <= IOP;
							end if;
						elsif start = old_st then
							cal_state <= IOP;
							enable_1 <= '0';
							enable_2 <= '1';
							enable_3 <= '0';
							seven_seg_digit_A_1 <= "1111111";
							seven_seg_digit_A_2 <= "1111111";
							seven_seg_digit_A_3 <= "1111111";
							seven_seg_digit_B_1 <= show_op_B_1;
							seven_seg_digit_B_2 <= show_op_B_2;
							seven_seg_digit_B_3 <= "1111111";
							tem_op <= value_get_op;
							DONE <= "10000000000";
						end if;
					when OUTP =>
							if(start /= old_st) then
							old_st <= start;
							if (start='0') then
								cal_state <= OUTP;
							else
								cal_state <= OUTP;
							end if;
						elsif start = old_st then
							cal_state <= OUTP;
							enable_1 <= '0';
							enable_2 <= '1';
							enable_3 <= '1';
							if tem_op(1) = '0' then
								result <= result_AS;
								remider <= conv_std_logic_vector(0, n);
								seven_seg_digit_B_3 <= result_7seg_AS_1;
								seven_seg_digit_A_1 <= result_7seg_AS_2;
								seven_seg_digit_A_2 <= result_7seg_AS_3;
								seven_seg_digit_A_3 <= result_7seg_AS_4;
								seven_seg_digit_B_1 <= remider_7seg_AS_1;
								seven_seg_digit_B_2 <= remider_7seg_AS_2;
							elsif tem_op = "10" then
								seven_seg_digit_B_3 <= result_7seg_M_1;
								seven_seg_digit_A_1 <= result_7seg_M_2;
								seven_seg_digit_A_2 <= result_7seg_M_3;
								seven_seg_digit_A_3 <= result_7seg_M_4;
								seven_seg_digit_B_1 <= remider_7seg_M_1;
								seven_seg_digit_B_2 <= remider_7seg_M_2;
							elsif tem_op = "11" then
								seven_seg_digit_B_3 <= result_7seg_D_1;
								seven_seg_digit_A_1 <= result_7seg_D_2;
								seven_seg_digit_A_2 <= result_7seg_D_3;
								seven_seg_digit_A_3 <= result_7seg_D_4;
								seven_seg_digit_B_1 <= remider_7seg_D_1;
								seven_seg_digit_B_2 <= remider_7seg_D_2;
							end if;
							DONE <= "01111111111";
						end if;
				end case;
			end if;
		end process;
end converter;


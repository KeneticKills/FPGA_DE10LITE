library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Multi is
    generic (
        N : integer := 5
    );
    Port (
		  CLK : in std_logic;
        A,B: in STD_LOGIC_VECTOR(N - 1 downto 0):= (others => '0');
        R: out STD_LOGIC_VECTOR((2*N) - 1 downto 0):= (others => '0');
		  sign : out std_logic;
        DONE : out STD_LOGIC := '0'
    );
end Multi;

architecture Behave of Multi is
	 signal temp_two : STD_LOGIC_VECTOR(N-1 downto 0);
	 signal A_reg: std_logic_vector(N-1 downto 0);
	 signal B_reg: std_logic_vector(N-1 downto 0);
	 signal sign_1: std_logic := '0';
	 signal sign_2: std_logic := '0';
	 

begin
	temp_two <= (0 => '1', others => '0');
	
		process (A,B,CLK)
		variable TA,TB: std_logic_vector(N-1 downto 0);
		variable Data_A  : STD_LOGIC_VECTOR((2*N)-1 downto 0):= (others => '0');
		variable Data_Poduct: STD_LOGIC_VECTOR((2*N)-1 downto 0):= (others => '0');
		variable Data_B   : STD_LOGIC_VECTOR(N-1 downto 0):= (others => '0');
		begin
		if rising_edge (CLK) then
		        TA := not A;
				  TB := not B;
				  
				  if A(N-1) = '1' then
						A_reg <= TA + temp_two;
						sign_1 <= '1';
				  else
						A_reg <= A;
						sign_1 <= '0';				  
					end if;
				  if B(N-1) = '1' then
						B_reg <= TB + temp_two;
						sign_2 <= '1';
				  else
						B_reg <= B;
						sign_2 <= '0';
				  end if;
				  
				  if sign_1 = sign_2 then
							sign <= '0';
					else
							sign <= '1';
					end if;
					
					Data_A (N-1 downto 0) := A_reg; --Keep data A
					Data_B:= B_reg;
					
					for i in 1 to N loop
						if Data_B(i-1) = '1' then
							Data_Poduct := Data_Poduct + Data_A;
						end if;
						Data_A := Data_A((2*N)-2 downto 0) & '0';
					end loop;
					
					R <= Data_Poduct;
					Data_Poduct := (others => '0');
					Data_B :=(others => '0');
					Data_A :=(others => '0');
					DONE <= '1';
					
			
			
		end if; 
		end process;
end Behave;
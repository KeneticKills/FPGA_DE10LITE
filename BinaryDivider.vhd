library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BinaryDivider is
    Generic (N : integer := 5); -- N-bit inputs
    Port (
		  clk : in std_logic;
        d  : in STD_LOGIC_VECTOR(N-1 downto 0);
        m   : in STD_LOGIC_VECTOR(N-1 downto 0);
        q  : out STD_LOGIC_VECTOR(N-1 downto 0);
        r : out STD_LOGIC_VECTOR(N-1 downto 0);
		  sign : out std_logic;
        done : out STD_LOGIC := '0';
		  ovf : out std_logic
    );
end BinaryDivider;

architecture Behavioral of BinaryDivider is
    signal temp_bit: std_logic_vector(N-1 downto 0);
	 signal temp_two: std_logic_vector(N-1 downto 0);
	 signal over: std_logic_vector(N-1 downto 0) := (others => '1');
	 signal d_reg: std_logic_vector(N-1 downto 0);
	 signal m_reg: std_logic_vector(N-1 downto 0);
	 signal q_reg: std_logic_vector(N-1 downto 0);
	 signal sign_1: std_logic := '0';
	 signal sign_2: std_logic := '0';

begin
	temp_bit <= (others => '0');
	temp_two <= (0 => '1', others => '0');
	
    process(d,m,clk)
		
        variable aq: std_logic_vector((2*N) -1 downto 0);
		  variable MB,TD,TM,TQ: std_logic_vector(N-1 downto 0);
		  
		  begin
			  if rising_edge(clk) then
					if(m = temp_bit)then
						q <= over;
						r <= over;
						sign <= '1';
						ovf <= '1';
						done <= '1';
					elsif(m /= temp_bit) then
				
					  TD := not d;
					  TM := not m;
					  
					  if d(N-1) = '1' then
							d_reg <= TD + temp_two;
							sign_1 <= '1';
					  else
							d_reg <= d;
							sign_1 <= '0';
					  end if;
					  if m(N-1) = '1' then
							m_reg <= TM + temp_two;
							sign_2 <= '1';
					  else
							m_reg <= m;
							sign_2 <= '0';
					  end if;
					  
					  MB := not m_reg;
					  aq := temp_bit & d_reg;
					  
					  for i in 1 to N loop
							aq((2*N) -1 downto 0) := aq((2*N) -2 downto 0) & 'U';
							aq((2*N) -1 downto N) := aq((2*N) -1 downto N)+MB+temp_two;
							if aq((2*N) -1) ='1' then
								aq(0) := '0';
								aq((2*N) -1 downto N) := aq((2*N) -1 downto N)+m_reg;
							else
								aq(0) := '1';
							end if;
						end loop;
						
						if sign_1 = sign_2 then
							sign <= '0';
						else
							sign <= '1';
						end if;
						
						q <= aq(N-1 downto 0);
						r <= aq((2*N) -1 downto N);
						done <= '1';
						ovf <= '0';
					end if;
					
				
			end if;
    end process;
end Behavioral;

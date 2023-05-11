library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mine_sensor is 

	port (	clk		: in  std_logic;
		reset		: in  std_logic;
		
		sensor		: in  std_logic;
		mine_out	: out std_logic
	);
end entity mine_sensor;

architecture behavioural of mine_sensor is


	type mine_state is (	rst,
				count_state,
				start_count,
				compare
				);

	signal state, new_state: mine_state;
	signal count, old_count, current_count: unsigned (9 downto 0);
begin

process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state <= rst;
			else
				state <= new_state;
			end if;
		end if;
end process;
process (sensor, clk)
begin
case state is
	when rst =>  
		
		
		if (rising_edge (sensor)) then
			new_state <= start_count;
		elsif (falling_edge (sensor)) then
			new_state <= compare;
		else
			new_state <= rst;
		end if;

	when start_count =>
		old_count <= count;
		count <= ( others => '0'); -------------------check pls
		
		new_state <= count_state;
	when count_state =>
		if (rising_edge (clk)) then
			current_count <=  count + 1;
			count <= current_count;
		end if;
		
		if (sensor = '1') then
			new_state <= count_state;
		elsif (falling_edge (sensor)) then
			new_state <= compare;
		else
			new_state <= rst;
		end if;



	when compare =>
		
		if count > old_count then
			mine_out <= '1';
		else
			mine_out <= '0';
		end if;
		
		new_state <= rst;
end case;
end process;

end architecture behavioural;

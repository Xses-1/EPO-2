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

type sensor_states is (reset_state, count_state, compare_state, detected_state);

signal count, new_count: unsigned (11 downto 0) := to_unsigned(0,12);
signal state, next_state : sensor_states;
begin
	process(clk)
		begin
			if (rising_edge(clk)) then
				if (reset = '1') then
					state <= reset_state;
					count <= (others => '0');
				else
					state <= next_state;
					count <= new_count;
				end if;
			end if;
		end process;
	
	process(state, count, sensor)
		begin	
		case state is
			when reset_state =>
				mine_out <= '0';
				new_count <= (others => '0');

				if (sensor = '1') then
					next_state <= reset_state;
				else
					next_state <= count_state;
				end if;

			when count_state =>
				mine_out <= '0';
				if (sensor = '0') then
					new_count <= count + 1;
					next_state <= count_state;
				else
					new_count <= count;
					next_state <= compare_state;
				end if;

			when compare_state =>
				mine_out <= '0';
				new_count <= count;
				if (count > 2269) then
					next_state <= detected_state;
				else
					next_state <= reset_state;
				end if;


			when detected_state =>
				mine_out <= '1';
				new_count <= count;
				next_state <= detected_state;	

			when others =>

			end case;
		end process;

end architecture behavioural;
					
					
		
		

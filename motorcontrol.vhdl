library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Please add necessary libraries:

entity motorcontrol is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (19 downto 0);  -- Please enter upper bound

		pwm		: out	std_logic
	);
end entity motorcontrol;

architecture behavioural of motorcontrol is
	
	type motorcontrol_state is (state0, state1, state2);

	signal state, new_state: motorcontrol_state;

begin 

	process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state <= state0;
			else
				state <= new_state;
			end if;
		end if;
	end process;


	process (direction, count_in, state)
	begin
		case state is

			when state0 => pwm <= '0';
				new_state<=state1;
			

			when state1 => pwm <= '1';
				if (direction ='0' and unsigned(count_in) >= to_unsigned(50000, 20)) then
					new_state <= state2;
					
				elsif (direction ='1' and unsigned(count_in) >= to_unsigned(100000, 20)) then
					new_state <= state2;

				else
					new_state <= state1;
				end if;


			when state2 => pwm <='0';
				new_state <= state2;

		end case;
	end process;
end architecture behavioural;



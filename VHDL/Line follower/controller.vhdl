library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Please add necessary libraries:


entity controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (19 downto 0);  -- Please enter upper bound
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);

end entity controller;

architecture behavioural of controller is
	
	type controller_state is (state_r, state_f, state_gl, state_sl, state_gr, state_sr);

	signal state, new_state: controller_state;


begin
	process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				state <= state_r;
			else
				state <= new_state;
			end if;
		end if;
	end process;


	
	process (sensor_l, sensor_m, sensor_r, count_in, state)
	begin 
		case state is

		when state_r =>		count_reset <= '1';
					motor_l_reset <= '1';
					motor_r_reset <= '1';

					motor_l_direction <= '0';
					motor_r_direction <= '0';
				
				if ((sensor_l = '0') and (sensor_m = '0') and (sensor_r = '0')) then	
					new_state <= state_f;
				

				elsif (sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
					new_state <= state_gl;


				elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '0') then
					new_state <= state_f;


				elsif (sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
					new_state <= state_sl;



				elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
					new_state <= state_gr;



				elsif (sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then
					new_state <= state_f;



				elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
					new_state <= state_sr;



				elsif (sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
					new_state <= state_f;
					

				else 
					new_state <= state_r;
				
				end if;

		

		when state_f =>		count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '0';
			
				
				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_f;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;


		when state_gl =>	count_reset <= '0';
					motor_l_reset <= '1';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;

				
				
		when state_sl =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '0';
					motor_r_direction <= '0';

				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sl;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;



		when state_gr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '1';

					motor_l_direction <= '1';
					motor_r_direction <= '0';

				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_gr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;


		when state_sr =>	count_reset <= '0';
					motor_l_reset <= '0';
					motor_r_reset <= '0';

					motor_l_direction <= '1';
					motor_r_direction <= '1';		

				if (unsigned(count_in) < to_unsigned(1000000, 20)) then
					new_state <= state_sr;
					
				elsif (unsigned(count_in) >= to_unsigned(1000000, 20)) then
					new_state <= state_r;

				end if;

		end case;
	end process;
end architecture behavioural;

				

				
		
					
				
		













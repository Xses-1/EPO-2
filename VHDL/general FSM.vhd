

type FSM_states is (rst, uturn1, uturn2, gleft, sleft, forward, gright, sright, BBB, BBW, BWB, BWW, WBB, WBW, WWB, WWW);

signal state, new_state: FSM_states;
signal sensor : std_logic_vector (2 downto 0);

begin
	lbl0: 	sensor (2) <= sensor_1_in;
		sensor (1) <= sensor_2_in;
		sensor (0) <= sensor_3_in;

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

process (--controlfrom C, count_in, state, sensor)
begin

case state is
	when rst =>
		uturn <= '0';

		direction_l <= '0';    --motors of
		direction_r <= '0';
		off_l <= '1';
		off_r <= '1';
		--other signals that need to be set

		if () then
			new_state <= --define state
		elsif () then
			new_state <= --define state
		elsif () then
			new_state <= --define state
		elsif () then
			new_state <= --define state
		elsif () then
			new_state <= --define state
		elsif () then
			new_state <= --define state
		elsif () then
			new_state <= --define state
		elsif (--c equals null) then
			if (sensor = "000") then
				new_state <= BBB;
			elsif (sensor = "001") then
				new_state <= BBW;
			elsif (sensor = "010") then
				new_state <= BWB;
			elsif (sensor = "011") then
				new_state <= BWW;
			elsif (sensor = "100") then
				new_state <= WBB;
			elsif (sensor = "101") then
				new_state <= WBW;
			elsif (sensor = "110") then
				new_state <= WWB;
			elsif (sensor = "111") then
				new_state <= WWW;
			end if;
		end if;

		--..........................

	when gleft =>
		uturn <= '0';

		direction_l <= '0';	--gentle left
		direction_r <= '0';
		off_l <= '1';
		off_r <= '0';
		--other signals that need to be set

		--define new_state

	when sleft =>
		uturn <= '0';

		direction_l <= '0';	--sharp left
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		--other signals that need to be set

		--define new_state

	when gright =>
		uturn <= '0';

		direction_l <= '1';	--gentle right
		direction_r <= '0';
		off_l <= '0';
		off_r <= '1';
		--other signals that need to be set

		--define new_state

	when sright =>
		uturn <= '0';

		direction_l <= '1';	--sharp right
		direction_r <= '1';
		off_l <= '0';
		off_r <= '0';
		--other signals that need to be set

		--define new_state

	when forward =>
		uturn <= '0';

		direction_l <= '1';	--forward
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		--other signals that need to be set

		--define new_state

	when turn1 =>
		uturn <= '1';

		direction_l <= '1';   --sharp right can be edited
		direction_r <= '1';
		off_l <= '0';
		off_r <= '0';
		--other signals that need to be set

		if (--sensorvector = "000") then
			new_state <= turn2;
		else
			new_state <= turn1;
		end if;

	when turn2 =>
		uturn <= '1';

		direction_l <= '1';  --sharp right can be edited
		direction_r <= '1';
		off_l <= '0';
		off_r <= '0';

		if (--sensorvector = "010") then
			new_state <= reset;
		else
			new_state <= turn2;
		end if;

	when BBB =>
		uturn <= '0';

		direction_l <= '1';
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		reset_out <= '0';
				
		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= BBB;
		end if;
				
	when BBW =>
		uturn <= '0';

		direction_l <= '0';
		direction_r <= '0';
		off_l <= '1';
		off_r <= '0';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= BBW;
		end if;
				
	when BWB =>
		uturn <= '0';

		direction_l <= '1';
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= BWB;
		end if;
				
	when BWW =>
		uturn <= '0';

		direction_l <= '0';
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= BWW;
		end if;
				
	when WBB =>
		uturn <= '0';

		direction_l <= '1';
		direction_r <= '0';
		off_l <= '0';
		off_r <= '1';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= WBB;
		end if;
				
	when WBW =>
		uturn <= '0';

		direction_l <= '1';
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= WBW;
		end if;
				
	when WWB =>
		uturn <= '0';

		direction_l <= '1';
		direction_r <= '1';
		off_l <= '0';
		off_r <= '0';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= WWB;
		end if;
				
	when WWW =>
		uturn <= '0';

		direction_l <= '1';
		direction_r <= '0';
		off_l <= '0';
		off_r <= '0';
		reset_out <= '0';

		if (unsigned(count_in) >= 1000000) then
			new_state <= rst;
		else
			new_state <= WWW;
		end if;

	end case;
end process;



	
		

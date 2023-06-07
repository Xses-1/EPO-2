library IEEE ;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_register is
        port (  clk      : in std_logic;
		sensor_l : in std_logic;
		sensor_r : in std_logic;
		sensor_m : in std_logic;
		outs_l   : inout std_logic;
		outs_r   : inout std_logic;
		outs_m   : inout std_logic

        );
end entity shift_register;

library IEEE ;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift is
	port (  clk	: in std_logic;
		sr_in	: in std_logic;
		sr_out	: out std_logic
	);
end entity shift;

architecture behavioural of shift is

	--signal sr : unsigned (31 downto 0);
	signal sr : unsigned (1 downto 0);

	begin
		process ( clk )
		variable richard : std_logic := '0';
		begin
			if ( rising_edge ( clk )) then

				sr <= shift_left ( sr, 1 );
				sr ( sr'low ) <= sr_in;
				--sr_out <= and sr;
				sr_out <= sr ( sr'high );

			elsif ( richard = '0') then
				--sr <= "00000000000000000000000000000000";
				sr <= "00";
				richard := '1';
			end if;
		end process;
end architecture behavioural;

architecture structural of shift_register is
	
	component shift
		port ( clk 	: in std_logic;
			sr_in	: in std_logic;
			sr_out	: out std_logic
		);
	end component;

	begin
		lbl1: shift port map ( clk => clk, sr_in => sensor_l, sr_out => outs_l );
		lbl2: shift port map ( clk => clk, sr_in => sensor_m, sr_out => outs_m );
		lbl3: shift port map ( clk => clk, sr_in => sensor_r, sr_out => outs_r );

end structural;

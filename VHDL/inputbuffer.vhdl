library IEEE ;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity inputbuffer is
        port (  clk      : in std_logic;
		sensor_l_in : in std_logic;
		sensor_r_in : in std_logic;
		sensor_m_in : in std_logic;
		sensor_l_out   : out std_logic;
		sensor_r_out   : out std_logic;
		sensor_m_out   : out std_logic

        );
end entity inputbuffer;

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

	signal sr : unsigned (31 downto 0); -- This is a vector that defines the length
					    -- of your shift register

	begin
		process ( clk )
		begin
			if ( rising_edge ( clk )) then

				sr <= shift_left ( sr, 1 );
				sr ( sr'low ) <= sr_in;		-- You have to comment that out
				--sr_out <= and sr;		-- and uncomment this line
								-- to do the proper debouncing
				sr_out <= sr ( sr'high );
				
			end if;
		end process;
end architecture behavioural;

architecture structural of inputbuffer is
	
	component shift
		port ( clk 	: in std_logic;
			sr_in	: in std_logic;
			sr_out	: out std_logic
		);
	end component;

	begin
		lbl1: shift port map ( clk => clk, sr_in => sensor_l_in, sr_out => sensor_l_out );
		lbl2: shift port map ( clk => clk, sr_in => sensor_m_in, sr_out => sensor_m_out );
		lbl3: shift port map ( clk => clk, sr_in => sensor_r_in, sr_out => sensor_r_out );

end structural;

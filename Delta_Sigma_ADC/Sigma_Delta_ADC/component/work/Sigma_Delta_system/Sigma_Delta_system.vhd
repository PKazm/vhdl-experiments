----------------------------------------------------------------------
-- Created by SmartDesign Mon Feb  3 22:28:03 2020
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- Sigma_Delta_system entity declaration
----------------------------------------------------------------------
entity Sigma_Delta_system is
    -- Port list
    port(
        -- Inputs
        PADN               : in  std_logic;
        PADP               : in  std_logic;
        PCLK               : in  std_logic;
        RSTn               : in  std_logic;
        -- Outputs
        Data_out           : out std_logic_vector(7 downto 0);
        Data_out_ready     : out std_logic;
        LVDS_PADN_feedback : out std_logic
        );
end Sigma_Delta_system;
----------------------------------------------------------------------
-- Sigma_Delta_system architecture body
----------------------------------------------------------------------
architecture RTL of Sigma_Delta_system is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- Averaging_Filter
-- using entity instantiation for component Averaging_Filter
-- INBUF_DIFF
component INBUF_DIFF
    generic( 
        IOSTD : string := "" 
        );
    -- Port list
    port(
        -- Inputs
        PADN : in  std_logic;
        PADP : in  std_logic;
        -- Outputs
        Y    : out std_logic
        );
end component;
-- Sigma_Delta_LVDS_ADC
-- using entity instantiation for component Sigma_Delta_LVDS_ADC
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal Data_out_0                        : std_logic_vector(7 downto 0);
signal Data_out_ready_net_0              : std_logic;
signal INBUF_DIFF_0_Y                    : std_logic;
signal LVDS_PADN_feedback_net_0          : std_logic;
signal Sigma_Delta_LVDS_ADC_0_Data_out_0 : std_logic_vector(7 downto 0);
signal Sigma_Delta_LVDS_ADC_0_Data_Ready : std_logic;
signal LVDS_PADN_feedback_net_1          : std_logic;
signal Data_out_ready_net_1              : std_logic;
signal Data_out_0_net_0                  : std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 LVDS_PADN_feedback_net_1 <= LVDS_PADN_feedback_net_0;
 LVDS_PADN_feedback       <= LVDS_PADN_feedback_net_1;
 Data_out_ready_net_1     <= Data_out_ready_net_0;
 Data_out_ready           <= Data_out_ready_net_1;
 Data_out_0_net_0         <= Data_out_0;
 Data_out(7 downto 0)     <= Data_out_0_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- Averaging_Filter_0
Averaging_Filter_0 : entity work.Averaging_Filter
    generic map( 
        g_data_bits         => ( 8 ),
        g_enable_data_out   => ( 1 ),
        g_sample_window_exp => ( 2 )
        )
    port map( 
        -- Inputs
        PCLK           => PCLK,
        RSTn           => RSTn,
        Data_in_ready  => Sigma_Delta_LVDS_ADC_0_Data_Ready,
        Data_in        => Sigma_Delta_LVDS_ADC_0_Data_out_0,
        -- Outputs
        Data_out_ready => Data_out_ready_net_0,
        Data_out       => Data_out_0 
        );
-- INBUF_DIFF_0
INBUF_DIFF_0 : INBUF_DIFF
    port map( 
        -- Inputs
        PADP => PADP,
        PADN => PADN,
        -- Outputs
        Y    => INBUF_DIFF_0_Y 
        );
-- Sigma_Delta_LVDS_ADC_0
Sigma_Delta_LVDS_ADC_0 : entity work.Sigma_Delta_LVDS_ADC
    generic map( 
        g_data_bits    => ( 8 ),
        g_invert_count => ( 1 ),
        g_pclk_period  => ( 10 ),
        g_sample_div   => ( 4 )
        )
    port map( 
        -- Inputs
        PCLK               => PCLK,
        RSTn               => RSTn,
        LVDS_in            => INBUF_DIFF_0_Y,
        -- Outputs
        LVDS_PADN_feedback => LVDS_PADN_feedback_net_0,
        Data_out           => Sigma_Delta_LVDS_ADC_0_Data_out_0,
        Data_Ready         => Sigma_Delta_LVDS_ADC_0_Data_Ready 
        );

end RTL;

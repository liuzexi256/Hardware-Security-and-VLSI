

create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_nets clk]
set_property DONT_TOUCH 1 [get_cells picorv32_top_inst]
set_property DONT_TOUCH 1 [get_cells u_bus]
set_property DONT_TOUCH 1 [get_cells sha256_top_inst]
set_property DONT_TOUCH 1 [get_cells wbram_inst]
set_property DONT_TOUCH 1 [get_cells idft_top_top_inst]
set_property DONT_TOUCH 1 [get_cells dft_top_top_inst]
set_property DONT_TOUCH 1 [get_cells iir_top_inst]
set_property DONT_TOUCH 1 [get_cells fir_top_inst]
set_property DONT_TOUCH 1 [get_cells des3_top_inst]
set_property DONT_TOUCH 1 [get_cells aes_top_inst]
set_property DONT_TOUCH 1 [get_cells uart_top_inst]
set_property DONT_TOUCH 1 [get_cells md5_top_inst]

reset_switching_activity -all 
set_switching_activity -deassert_resets 
set_switching_activity -toggle_rate 100.000 -type {lut} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {register} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {shift_register} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {lut_ram} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {bram} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {dsp} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {gt_rxdata} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {gt_txdata} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {io_output} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {bram_enable} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {bram_wr_enable} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {io_bidir_enable} -static_probability 0.500 -all 

set_switching_activity -deassert_resets 
set_switching_activity -toggle_rate 100.000 -type {lut} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {register} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {shift_register} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {lut_ram} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {bram} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {dsp} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {gt_rxdata} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {gt_txdata} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {io_output} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {bram_enable} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {bram_wr_enable} -static_probability 0.500 -all 
set_switching_activity -toggle_rate 100.000 -type {io_bidir_enable} -static_probability 0.500 -all 

create_clock -period 1.000 -name clk -waveform {0.000 0.500} [get_nets core_clk]


set_property DONT_TOUCH true [get_cells clkgen_inst]
set_property DONT_TOUCH true [get_cells ram_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells uart_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells picorv32_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells aes_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells des3_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells sha256_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells iir_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells fir_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells dft_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells idft_top_axi4lite_inst]
set_property DONT_TOUCH true [get_cells md5_top_axi4lite_inst]


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

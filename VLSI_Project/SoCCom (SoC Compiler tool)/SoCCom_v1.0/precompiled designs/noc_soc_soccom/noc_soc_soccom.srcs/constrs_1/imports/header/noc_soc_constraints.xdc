create_clock -period 1.000 -name clk -waveform {0.000 0.500} [get_nets u_system/clk]

set_property DONT_TOUCH true [get_cells u_system]

set_property DONT_TOUCH true [get_cells u_system/tile_idft_top_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_idft_top_top_inst/idft_top_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_idft_top_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_idft_top_top_inst/idft_top_top_na]

set_property DONT_TOUCH true [get_cells u_system/tile_dft_top_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_dft_top_top_inst/dft_top_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_dft_top_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_dft_top_top_inst/dft_top_top_na]

set_property DONT_TOUCH true [get_cells u_system/tile_picorv32_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_picorv32_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_picorv32_top_inst/u_na]
set_property DONT_TOUCH true [get_cells u_system/tile_picorv32_top_inst/picorv32_top_inst]

set_property DONT_TOUCH true [get_cells u_system/tile_fir_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_fir_top_inst/fir_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_fir_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_fir_top_inst/fir_top_na]

set_property DONT_TOUCH true [get_cells u_system/noc_router_R_1_inst]
set_property DONT_TOUCH true [get_cells u_system/noc_router_R_2_inst]
set_property DONT_TOUCH true [get_cells u_system/noc_router_R_3_inst]
set_property DONT_TOUCH true [get_cells u_system/noc_router_R_4_inst]
set_property DONT_TOUCH true [get_cells u_system/noc_router_R_5_inst]

set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_01_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_01_inst/ram_wb_01_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_01_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_01_inst/ram_wb_01_na]

set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_02_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_02_inst/ram_wb_02_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_02_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_ram_wb_02_inst/ram_wb_02_na]

set_property DONT_TOUCH true [get_cells u_system/tile_md5_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_md5_top_inst/md5_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_md5_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_md5_top_inst/md5_top_na]

set_property DONT_TOUCH true [get_cells u_system/tile_aes_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_aes_top_inst/aes_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_aes_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_aes_top_inst/aes_top_na]

set_property DONT_TOUCH true [get_cells u_system/tile_des3_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_des3_top_inst/des3_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_des3_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_des3_top_inst/des3_top_na]

#set_property DONT_TOUCH true [get_cells u_system/tile_sha256_top_inst]
#set_property DONT_TOUCH true [get_cells u_system/tile_sha256_top_inst/sha256_top_inst]
#set_property DONT_TOUCH true [get_cells u_system/tile_sha256_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_sha256_top_inst/u_na]

set_property DONT_TOUCH true [get_cells u_system/tile_uart_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_uart_top_inst/uart_top_inst]
set_property DONT_TOUCH true [get_cells u_system/tile_uart_top_inst/u_bus]
#set_property DONT_TOUCH true [get_cells u_system/tile_uart_top_inst/uart_top_na]



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
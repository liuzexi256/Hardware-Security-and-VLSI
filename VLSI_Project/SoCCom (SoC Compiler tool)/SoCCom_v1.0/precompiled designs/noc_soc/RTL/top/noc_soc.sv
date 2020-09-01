`include "dbg_config.vh"
module noc_soc_top
(
input clk,
input rst,
output[4 * 32 - 1:0] wb_ext_adr_i,
output[4 * 1 - 1:0] wb_ext_cyc_i,
output[4 * 32 - 1:0] wb_ext_dat_i,
output[4 * 4 - 1:0] wb_ext_sel_i,
output[4 * 1 - 1:0] wb_ext_stb_i,
output[4 * 1 - 1:0] wb_ext_we_i,
output[4 * 1 - 1:0] wb_ext_cab_i,
output[4 * 3 - 1:0] wb_ext_cti_i,
output[4 * 2 - 1:0] wb_ext_bte_i,
input[4 * 1 - 1:0] wb_ext_ack_o,
input[4 * 1 - 1:0] wb_ext_rty_o,
input[4 * 1 - 1:0] wb_ext_err_o,
input[4 * 32 - 1:0] wb_ext_dat_o
);


import dii_package::*; 
import optimsoc_config:: *; 
import optimsoc_functions:: *; 

parameter config_t CONFIG = 'x; 
localparam FLIT_WIDTH = CONFIG.NOC_FLIT_WIDTH; 
localparam CHANNELS = CONFIG.NOC_CHANNELS; 
localparam VCHANNELS = 2;




wire [3:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_in_flit_R_1_EP;
wire [3:0][CHANNELS-1:0]noc_in_last_R_1_EP;
wire [3:0][CHANNELS-1:0]noc_in_valid_R_1_EP;
wire [3:0][CHANNELS-1:0]noc_out_ready_R_1_EP;
wire [3:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_out_flit_R_1_EP;
wire [3:0][CHANNELS-1:0]noc_out_last_R_1_EP;
wire [3:0][CHANNELS-1:0]noc_out_valid_R_1_EP;
wire [3:0][CHANNELS-1:0]noc_in_ready_R_1_EP;


tile_picorv32_top
#(
.CONFIG(CONFIG)
)
tile_picorv32_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_1_EP[3]),
.noc_in_last (noc_in_last_R_1_EP[3]),
.noc_in_valid (noc_in_valid_R_1_EP[3]),
.noc_out_ready (noc_out_ready_R_1_EP[3]),
.noc_in_ready (noc_in_ready_R_1_EP[3]),
.noc_out_flit (noc_out_flit_R_1_EP[3]),
.noc_out_last (noc_out_last_R_1_EP[3]),
.noc_out_valid (noc_out_valid_R_1_EP[3]));


tile_dft_top_top
#(
.CONFIG(CONFIG)
)
tile_dft_top_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_1_EP[2]),
.noc_in_last (noc_in_last_R_1_EP[2]),
.noc_in_valid (noc_in_valid_R_1_EP[2]),
.noc_out_ready (noc_out_ready_R_1_EP[2]),
.noc_in_ready (noc_in_ready_R_1_EP[2]),
.noc_out_flit (noc_out_flit_R_1_EP[2]),
.noc_out_last (noc_out_last_R_1_EP[2]),
.noc_out_valid (noc_out_valid_R_1_EP[2]));


tile_idft_top_top
#(
.CONFIG(CONFIG)
)
tile_idft_top_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_1_EP[1]),
.noc_in_last (noc_in_last_R_1_EP[1]),
.noc_in_valid (noc_in_valid_R_1_EP[1]),
.noc_out_ready (noc_out_ready_R_1_EP[1]),
.noc_in_ready (noc_in_ready_R_1_EP[1]),
.noc_out_flit (noc_out_flit_R_1_EP[1]),
.noc_out_last (noc_out_last_R_1_EP[1]),
.noc_out_valid (noc_out_valid_R_1_EP[1]));


tile_fir_top
#(
.CONFIG(CONFIG)
)
tile_fir_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_1_EP[0]),
.noc_in_last (noc_in_last_R_1_EP[0]),
.noc_in_valid (noc_in_valid_R_1_EP[0]),
.noc_out_ready (noc_out_ready_R_1_EP[0]),
.noc_in_ready (noc_in_ready_R_1_EP[0]),
.noc_out_flit (noc_out_flit_R_1_EP[0]),
.noc_out_last (noc_out_last_R_1_EP[0]),
.noc_out_valid (noc_out_valid_R_1_EP[0]));


wire [FLIT_WIDTH-1:0]in_flit_R_1_2;
wire in_last_R_1_2;
wire [VCHANNELS-1:0]in_valid_R_1_2;
wire [VCHANNELS-1:0]out_ready_R_1_2;
wire [VCHANNELS-1:0]in_ready_R_1_2;
wire [FLIT_WIDTH-1:0]out_flit_R_1_2;
wire out_last_R_1_2;
wire [VCHANNELS-1:0]out_valid_R_1_2;

noc_router
#(
.INPUTS (9),
.OUTPUTS (9),
.DESTS      (32)
)

noc_router_R_1_inst(
.clk (clk),
.rst (rst),
.in_flit ({noc_out_flit_R_1_EP[3],noc_out_flit_R_1_EP[2],noc_out_flit_R_1_EP[1],noc_out_flit_R_1_EP[0],in_flit_R_1_2}),
.in_last ({noc_out_last_R_1_EP[3],noc_out_last_R_1_EP[2],noc_out_last_R_1_EP[1],noc_out_last_R_1_EP[0],in_last_R_1_2}),
.in_valid ({noc_out_valid_R_1_EP[3],noc_out_valid_R_1_EP[2],noc_out_valid_R_1_EP[1],noc_out_valid_R_1_EP[0],in_valid_R_1_2}),
.out_ready ({noc_in_ready_R_1_EP[3],noc_in_ready_R_1_EP[2],noc_in_ready_R_1_EP[1],noc_in_ready_R_1_EP[0],out_ready_R_1_2}),
.out_flit ({noc_in_flit_R_1_EP[3],noc_in_flit_R_1_EP[2],noc_in_flit_R_1_EP[1],noc_in_flit_R_1_EP[0],out_flit_R_1_2}),
.out_last ({noc_in_last_R_1_EP[3],noc_in_last_R_1_EP[2],noc_in_last_R_1_EP[1],noc_in_last_R_1_EP[0],out_last_R_1_2}),
.out_valid ({noc_in_valid_R_1_EP[3],noc_in_valid_R_1_EP[2],noc_in_valid_R_1_EP[1],noc_in_valid_R_1_EP[0],out_valid_R_1_2}),
.in_ready ({noc_out_ready_R_1_EP[3],noc_out_ready_R_1_EP[2],noc_out_ready_R_1_EP[1],noc_out_ready_R_1_EP[0],in_ready_R_1_2}));


wire [1:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_in_flit_R_2_EP;
wire [1:0][CHANNELS-1:0]noc_in_last_R_2_EP;
wire [1:0][CHANNELS-1:0]noc_in_valid_R_2_EP;
wire [1:0][CHANNELS-1:0]noc_out_ready_R_2_EP;
wire [1:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_out_flit_R_2_EP;
wire [1:0][CHANNELS-1:0]noc_out_last_R_2_EP;
wire [1:0][CHANNELS-1:0]noc_out_valid_R_2_EP;
wire [1:0][CHANNELS-1:0]noc_in_ready_R_2_EP;


tile_ram_wb_02
#(
.CONFIG(CONFIG)
)
tile_ram_wb_02_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_2_EP[1]),
.noc_in_last (noc_in_last_R_2_EP[1]),
.noc_in_valid (noc_in_valid_R_2_EP[1]),
.noc_out_ready (noc_out_ready_R_2_EP[1]),
.noc_in_ready (noc_in_ready_R_2_EP[1]),
.noc_out_flit (noc_out_flit_R_2_EP[1]),
.noc_out_last (noc_out_last_R_2_EP[1]),
.noc_out_valid (noc_out_valid_R_2_EP[1]));


tile_ram_wb_01
#(
.CONFIG(CONFIG)
)
tile_ram_wb_01_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_2_EP[0]),
.noc_in_last (noc_in_last_R_2_EP[0]),
.noc_in_valid (noc_in_valid_R_2_EP[0]),
.noc_out_ready (noc_out_ready_R_2_EP[0]),
.noc_in_ready (noc_in_ready_R_2_EP[0]),
.noc_out_flit (noc_out_flit_R_2_EP[0]),
.noc_out_last (noc_out_last_R_2_EP[0]),
.noc_out_valid (noc_out_valid_R_2_EP[0]));


wire [FLIT_WIDTH-1:0]in_flit_R_2_3;
wire in_last_R_2_3;
wire [VCHANNELS-1:0]in_valid_R_2_3;
wire [VCHANNELS-1:0]out_ready_R_2_3;
wire [VCHANNELS-1:0]in_ready_R_2_3;
wire [FLIT_WIDTH-1:0]out_flit_R_2_3;
wire out_last_R_2_3;
wire [VCHANNELS-1:0]out_valid_R_2_3;

noc_router
#(
.INPUTS (6),
.OUTPUTS (6),
.DESTS      (32)
)

noc_router_R_2_inst(
.clk (clk),
.rst (rst),
.in_flit ({noc_out_flit_R_2_EP[1],noc_out_flit_R_2_EP[0],out_flit_R_1_2,in_flit_R_2_3}),
.in_last ({noc_out_last_R_2_EP[1],noc_out_last_R_2_EP[0],out_last_R_1_2,in_last_R_2_3}),
.in_valid ({noc_out_valid_R_2_EP[1],noc_out_valid_R_2_EP[0],out_valid_R_1_2,in_valid_R_2_3}),
.out_ready ({noc_in_ready_R_2_EP[1],noc_in_ready_R_2_EP[0],in_ready_R_1_2,out_ready_R_2_3}),
.out_flit ({noc_in_flit_R_2_EP[1],noc_in_flit_R_2_EP[0],in_flit_R_1_2,out_flit_R_2_3}),
.out_last ({noc_in_last_R_2_EP[1],noc_in_last_R_2_EP[0],in_last_R_1_2,out_last_R_2_3}),
.out_valid ({noc_in_valid_R_2_EP[1],noc_in_valid_R_2_EP[0],in_valid_R_1_2,out_valid_R_2_3}),
.in_ready ({noc_out_ready_R_2_EP[1],noc_out_ready_R_2_EP[0],out_ready_R_1_2,in_ready_R_2_3}));


wire [0:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_in_flit_R_3_EP;
wire [0:0][CHANNELS-1:0]noc_in_last_R_3_EP;
wire [0:0][CHANNELS-1:0]noc_in_valid_R_3_EP;
wire [0:0][CHANNELS-1:0]noc_out_ready_R_3_EP;
wire [0:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_out_flit_R_3_EP;
wire [0:0][CHANNELS-1:0]noc_out_last_R_3_EP;
wire [0:0][CHANNELS-1:0]noc_out_valid_R_3_EP;
wire [0:0][CHANNELS-1:0]noc_in_ready_R_3_EP;


tile_md5_top
#(
.CONFIG(CONFIG)
)
tile_md5_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_3_EP[0]),
.noc_in_last (noc_in_last_R_3_EP[0]),
.noc_in_valid (noc_in_valid_R_3_EP[0]),
.noc_out_ready (noc_out_ready_R_3_EP[0]),
.noc_in_ready (noc_in_ready_R_3_EP[0]),
.noc_out_flit (noc_out_flit_R_3_EP[0]),
.noc_out_last (noc_out_last_R_3_EP[0]),
.noc_out_valid (noc_out_valid_R_3_EP[0]));


wire [FLIT_WIDTH-1:0]in_flit_R_3_4;
wire in_last_R_3_4;
wire [VCHANNELS-1:0]in_valid_R_3_4;
wire [VCHANNELS-1:0]out_ready_R_3_4;
wire [VCHANNELS-1:0]in_ready_R_3_4;
wire [FLIT_WIDTH-1:0]out_flit_R_3_4;
wire out_last_R_3_4;
wire [VCHANNELS-1:0]out_valid_R_3_4;
wire [FLIT_WIDTH-1:0]in_flit_R_3_5;
wire in_last_R_3_5;
wire [VCHANNELS-1:0]in_valid_R_3_5;
wire [VCHANNELS-1:0]out_ready_R_3_5;
wire [VCHANNELS-1:0]in_ready_R_3_5;
wire [FLIT_WIDTH-1:0]out_flit_R_3_5;
wire out_last_R_3_5;
wire [VCHANNELS-1:0]out_valid_R_3_5;

noc_router
#(
.INPUTS (5),
.OUTPUTS (5),
.DESTS      (32)
)

noc_router_R_3_inst(
.clk (clk),
.rst (rst),
.in_flit ({noc_out_flit_R_3_EP[0],out_flit_R_2_3,in_flit_R_3_4,in_flit_R_3_5}),
.in_last ({noc_out_last_R_3_EP[0],out_last_R_2_3,in_last_R_3_4,in_last_R_3_5}),
.in_valid ({noc_out_valid_R_3_EP[0],out_valid_R_2_3,in_valid_R_3_4,in_valid_R_3_5}),
.out_ready ({noc_in_ready_R_3_EP[0],in_ready_R_2_3,out_ready_R_3_4,out_ready_R_3_5}),
.out_flit ({noc_in_flit_R_3_EP[0],in_flit_R_2_3,out_flit_R_3_4,out_flit_R_3_5}),
.out_last ({noc_in_last_R_3_EP[0],in_last_R_2_3,out_last_R_3_4,out_last_R_3_5}),
.out_valid ({noc_in_valid_R_3_EP[0],in_valid_R_2_3,out_valid_R_3_4,out_valid_R_3_5}),
.in_ready ({noc_out_ready_R_3_EP[0],out_ready_R_2_3,in_ready_R_3_4,in_ready_R_3_5}));


wire [1:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_in_flit_R_4_EP;
wire [1:0][CHANNELS-1:0]noc_in_last_R_4_EP;
wire [1:0][CHANNELS-1:0]noc_in_valid_R_4_EP;
wire [1:0][CHANNELS-1:0]noc_out_ready_R_4_EP;
wire [1:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_out_flit_R_4_EP;
wire [1:0][CHANNELS-1:0]noc_out_last_R_4_EP;
wire [1:0][CHANNELS-1:0]noc_out_valid_R_4_EP;
wire [1:0][CHANNELS-1:0]noc_in_ready_R_4_EP;


tile_aes_top
#(
.CONFIG(CONFIG)
)
tile_aes_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_4_EP[1]),
.noc_in_last (noc_in_last_R_4_EP[1]),
.noc_in_valid (noc_in_valid_R_4_EP[1]),
.noc_out_ready (noc_out_ready_R_4_EP[1]),
.noc_in_ready (noc_in_ready_R_4_EP[1]),
.noc_out_flit (noc_out_flit_R_4_EP[1]),
.noc_out_last (noc_out_last_R_4_EP[1]),
.noc_out_valid (noc_out_valid_R_4_EP[1]));


tile_des3_top
#(
.CONFIG(CONFIG)
)
tile_des3_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_4_EP[0]),
.noc_in_last (noc_in_last_R_4_EP[0]),
.noc_in_valid (noc_in_valid_R_4_EP[0]),
.noc_out_ready (noc_out_ready_R_4_EP[0]),
.noc_in_ready (noc_in_ready_R_4_EP[0]),
.noc_out_flit (noc_out_flit_R_4_EP[0]),
.noc_out_last (noc_out_last_R_4_EP[0]),
.noc_out_valid (noc_out_valid_R_4_EP[0]));



noc_router
#(
.INPUTS (5),
.OUTPUTS (5),
.DESTS      (32)
)

noc_router_R_4_inst(
.clk (clk),
.rst (rst),
.in_flit ({noc_out_flit_R_4_EP[1],noc_out_flit_R_4_EP[0],out_flit_R_3_4}),
.in_last ({noc_out_last_R_4_EP[1],noc_out_last_R_4_EP[0],out_last_R_3_4}),
.in_valid ({noc_out_valid_R_4_EP[1],noc_out_valid_R_4_EP[0],out_valid_R_3_4}),
.out_ready ({noc_in_ready_R_4_EP[1],noc_in_ready_R_4_EP[0],in_ready_R_3_4}),
.out_flit ({noc_in_flit_R_4_EP[1],noc_in_flit_R_4_EP[0],in_flit_R_3_4}),
.out_last ({noc_in_last_R_4_EP[1],noc_in_last_R_4_EP[0],in_last_R_3_4}),
.out_valid ({noc_in_valid_R_4_EP[1],noc_in_valid_R_4_EP[0],in_valid_R_3_4}),
.in_ready ({noc_out_ready_R_4_EP[1],noc_out_ready_R_4_EP[0],out_ready_R_3_4}));


wire [0:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_in_flit_R_5_EP;
wire [0:0][CHANNELS-1:0]noc_in_last_R_5_EP;
wire [0:0][CHANNELS-1:0]noc_in_valid_R_5_EP;
wire [0:0][CHANNELS-1:0]noc_out_ready_R_5_EP;
wire [0:0][CHANNELS-1:0][FLIT_WIDTH-1:0]noc_out_flit_R_5_EP;
wire [0:0][CHANNELS-1:0]noc_out_last_R_5_EP;
wire [0:0][CHANNELS-1:0]noc_out_valid_R_5_EP;
wire [0:0][CHANNELS-1:0]noc_in_ready_R_5_EP;


tile_uart_top
#(
.CONFIG(CONFIG)
)
tile_uart_top_inst(
.clk (clk),
.rst_sys (rst),
.noc_in_flit (noc_in_flit_R_5_EP[0]),
.noc_in_last (noc_in_last_R_5_EP[0]),
.noc_in_valid (noc_in_valid_R_5_EP[0]),
.noc_out_ready (noc_out_ready_R_5_EP[0]),
.noc_in_ready (noc_in_ready_R_5_EP[0]),
.noc_out_flit (noc_out_flit_R_5_EP[0]),
.noc_out_last (noc_out_last_R_5_EP[0]),
.noc_out_valid (noc_out_valid_R_5_EP[0]));



noc_router
#(
.INPUTS (3),
.OUTPUTS (3),
.DESTS      (32)
)

noc_router_R_5_inst(
.clk (clk),
.rst (rst),
.in_flit ({noc_out_flit_R_5_EP[0],out_flit_R_3_5}),
.in_last ({noc_out_last_R_5_EP[0],out_last_R_3_5}),
.in_valid ({noc_out_valid_R_5_EP[0],out_valid_R_3_5}),
.out_ready ({noc_in_ready_R_5_EP[0],in_ready_R_3_5}),
.out_flit ({noc_in_flit_R_5_EP[0],in_flit_R_3_5}),
.out_last ({noc_in_last_R_5_EP[0],in_last_R_3_5}),
.out_valid ({noc_in_valid_R_5_EP[0],in_valid_R_3_5}),
.in_ready ({noc_out_ready_R_5_EP[0],out_ready_R_3_5}));


endmodule

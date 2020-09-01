module top

(
input clk,
input rst,
input srx_pad_i,
input cts_pad_i,
output stx_pad_o,
output rts_pad_o
);
import wb_soc_config::*;
import wb_soc_functions::*;



localparam NR_MASTERS = 1;
localparam NR_SLAVES = 10;
localparam S0 = 0;
localparam S1 = 1;
localparam S2 = 2;
localparam S3 = 3;
localparam S4 = 4;
localparam S5 = 5;
localparam S6 = 6;
localparam S7 = 7;
localparam S8 = 8;
localparam S9 = 9;




wire [31:0]   busms_adr_o[0:NR_MASTERS-1];
wire          busms_cyc_o[0:NR_MASTERS-1];
wire [31:0]   busms_dat_o[0:NR_MASTERS-1];
wire [3:0]    busms_sel_o[0:NR_MASTERS-1];
wire          busms_stb_o[0:NR_MASTERS-1];
wire          busms_we_o[0:NR_MASTERS-1];
wire          busms_cab_o[0:NR_MASTERS-1];
wire [2:0]    busms_cti_o[0:NR_MASTERS-1];
wire [1:0]    busms_bte_o[0:NR_MASTERS-1];
wire          busms_ack_i[0:NR_MASTERS-1];
wire          busms_rty_i[0:NR_MASTERS-1];
wire          busms_err_i[0:NR_MASTERS-1];
wire [31:0]   busms_dat_i[0:NR_MASTERS-1];

wire [31:0]   bussl_adr_i[0:NR_SLAVES-1];
wire          bussl_cyc_i[0:NR_SLAVES-1];
wire [31:0]   bussl_dat_i[0:NR_SLAVES-1];
wire [3:0]    bussl_sel_i[0:NR_SLAVES-1];
wire          bussl_stb_i[0:NR_SLAVES-1];
wire          bussl_we_i[0:NR_SLAVES-1];
wire          bussl_cab_i[0:NR_SLAVES-1];
wire [2:0]    bussl_cti_i[0:NR_SLAVES-1];
wire [1:0]    bussl_bte_i[0:NR_SLAVES-1];
wire          bussl_ack_o[0:NR_SLAVES-1];
wire          bussl_rty_o[0:NR_SLAVES-1];
wire          bussl_err_o[0:NR_SLAVES-1];
wire [31:0]   bussl_dat_o[0:NR_SLAVES-1];


wire          snoop_enable;
wire [31:0]   snoop_adr;
wire [31:0]   pic_ints_i [0:1];
assign pic_ints_i[0][31:4] = 28'h0;
assign pic_ints_i[0][1:0] = 2'b00;

genvar        m, s;
wire [32*NR_MASTERS-1:0] busms_adr_o_flat;
wire [NR_MASTERS-1:0]    busms_cyc_o_flat;
wire [32*NR_MASTERS-1:0] busms_dat_o_flat;
wire [4*NR_MASTERS-1:0]  busms_sel_o_flat;
wire [NR_MASTERS-1:0]    busms_stb_o_flat;
wire [NR_MASTERS-1:0]    busms_we_o_flat;
wire [NR_MASTERS-1:0]    busms_cab_o_flat;
wire [3*NR_MASTERS-1:0]  busms_cti_o_flat;
wire [2*NR_MASTERS-1:0]  busms_bte_o_flat;
wire [NR_MASTERS-1:0]    busms_ack_i_flat;
wire [NR_MASTERS-1:0]    busms_rty_i_flat;
wire [NR_MASTERS-1:0]    busms_err_i_flat;
wire [32*NR_MASTERS-1:0] busms_dat_i_flat;
wire [32*NR_SLAVES-1:0] bussl_adr_i_flat;
wire [NR_SLAVES-1:0]    bussl_cyc_i_flat;
wire [32*NR_SLAVES-1:0] bussl_dat_i_flat;
wire [4*NR_SLAVES-1:0]  bussl_sel_i_flat;
wire [NR_SLAVES-1:0]    bussl_stb_i_flat;
wire [NR_SLAVES-1:0]    bussl_we_i_flat;
wire [NR_SLAVES-1:0]    bussl_cab_i_flat;
wire [3*NR_SLAVES-1:0]  bussl_cti_i_flat;
wire [2*NR_SLAVES-1:0]  bussl_bte_i_flat;
wire [NR_SLAVES-1:0]    bussl_ack_o_flat;
wire [NR_SLAVES-1:0]    bussl_rty_o_flat;
wire [NR_SLAVES-1:0]    bussl_err_o_flat;
wire [32*NR_SLAVES-1:0] bussl_dat_o_flat;




generate
for (m = 0; m < NR_MASTERS; m = m + 1) begin : gen_busms_flat
assign busms_adr_o_flat[32*(m+1)-1:32*m] = busms_adr_o[m];
assign busms_cyc_o_flat[m] = busms_cyc_o[m];
assign busms_dat_o_flat[32*(m+1)-1:32*m] = busms_dat_o[m];
assign busms_sel_o_flat[4*(m+1)-1:4*m] = busms_sel_o[m];
assign busms_stb_o_flat[m] = busms_stb_o[m];
assign busms_we_o_flat[m] = busms_we_o[m];
assign busms_cab_o_flat[m] = busms_cab_o[m];
assign busms_cti_o_flat[3*(m+1)-1:3*m] = busms_cti_o[m];
assign busms_bte_o_flat[2*(m+1)-1:2*m] = busms_bte_o[m];
assign busms_ack_i[m] = busms_ack_i_flat[m];
assign busms_rty_i[m] = busms_rty_i_flat[m];
assign busms_err_i[m] = busms_err_i_flat[m];
assign busms_dat_i[m] = busms_dat_i_flat[32*(m+1)-1:32*m];
end
for (s = 0; s < NR_SLAVES; s = s + 1) begin : gen_bussl_flat
assign bussl_adr_i[s] = bussl_adr_i_flat[32*(s+1)-1:32*s];
assign bussl_cyc_i[s] = bussl_cyc_i_flat[s];
assign bussl_dat_i[s] = bussl_dat_i_flat[32*(s+1)-1:32*s];
assign bussl_sel_i[s] = bussl_sel_i_flat[4*(s+1)-1:4*s];
assign bussl_stb_i[s] = bussl_stb_i_flat[s];
assign bussl_we_i[s] = bussl_we_i_flat[s];
assign bussl_cab_i[s] = bussl_cab_i_flat[s];
assign bussl_cti_i[s] = bussl_cti_i_flat[3*(s+1)-1:3*s];
assign bussl_bte_i[s] = bussl_bte_i_flat[2*(s+1)-1:2*s];
assign bussl_ack_o_flat[s] = bussl_ack_o[s];
assign bussl_rty_o_flat[s] = bussl_rty_o[s];
assign bussl_err_o_flat[s] = bussl_err_o[s];
assign bussl_dat_o_flat[32*(s+1)-1:32*s] = bussl_dat_o[s];
end
endgenerate


aes_top aes_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S1]),
.wb_cyc_i(bussl_cyc_i[S1]),
.wb_dat_i(bussl_dat_i[S1]),
.wb_sel_i(bussl_sel_i[S1]),
.wb_stb_i(bussl_stb_i[S1]),
.wb_we_i(bussl_we_i[S1]),
.wb_ack_o(bussl_ack_o[S1]),
.wb_dat_o(bussl_dat_o[S1]),
.wb_err_o(bussl_err_o[S1])

);


wbram wbram_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S2]),
.wb_cyc_i(bussl_cyc_i[S2]),
.wb_dat_i(bussl_dat_i[S2]),
.wb_sel_i(bussl_sel_i[S2]),
.wb_stb_i(bussl_stb_i[S2]),
.wb_we_i(bussl_we_i[S2]),
.wb_ack_o(bussl_ack_o[S2]),
.wb_dat_o(bussl_dat_o[S2])

);


picorv32_top picorv32_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wbm_ack_i(busms_ack_i_flat),
.wbm_dat_i(busms_dat_i_flat),
.wbm_adr_o(busms_adr_o_flat),
.wbm_cyc_o(busms_cyc_o_flat),
.wbm_dat_o(busms_dat_o_flat),
.wbm_sel_o(busms_sel_o_flat),
.wbm_stb_o(busms_stb_o_flat),
.wbm_we_o(busms_we_o_flat)
);
des3_top des3_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S3]),
.wb_cyc_i(bussl_cyc_i[S3]),
.wb_dat_i(bussl_dat_i[S3]),
.wb_sel_i(bussl_sel_i[S3]),
.wb_stb_i(bussl_stb_i[S3]),
.wb_we_i(bussl_we_i[S3]),
.wb_ack_o(bussl_ack_o[S3]),
.wb_dat_o(bussl_dat_o[S3]),
.wb_err_o(bussl_err_o[S3])

);


sha256_top sha256_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S4]),
.wb_cyc_i(bussl_cyc_i[S4]),
.wb_dat_i(bussl_dat_i[S4]),
.wb_sel_i(bussl_sel_i[S4]),
.wb_stb_i(bussl_stb_i[S4]),
.wb_we_i(bussl_we_i[S4]),
.wb_ack_o(bussl_ack_o[S4]),
.wb_dat_o(bussl_dat_o[S4]),
.wb_err_o(bussl_err_o[S4])

);


fir_top fir_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S5]),
.wb_cyc_i(bussl_cyc_i[S5]),
.wb_dat_i(bussl_dat_i[S5]),
.wb_sel_i(bussl_sel_i[S5]),
.wb_stb_i(bussl_stb_i[S5]),
.wb_we_i(bussl_we_i[S5]),
.wb_ack_o(bussl_ack_o[S5]),
.wb_dat_o(bussl_dat_o[S5]),
.wb_err_o(bussl_err_o[S5])

);


idft_top_top idft_top_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S6]),
.wb_cyc_i(bussl_cyc_i[S6]),
.wb_dat_i(bussl_dat_i[S6]),
.wb_sel_i(bussl_sel_i[S6]),
.wb_stb_i(bussl_stb_i[S6]),
.wb_we_i(bussl_we_i[S6]),
.wb_ack_o(bussl_ack_o[S6]),
.wb_dat_o(bussl_dat_o[S6]),
.wb_err_o(bussl_err_o[S6])

);


dft_top_top dft_top_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S7]),
.wb_cyc_i(bussl_cyc_i[S7]),
.wb_dat_i(bussl_dat_i[S7]),
.wb_sel_i(bussl_sel_i[S7]),
.wb_stb_i(bussl_stb_i[S7]),
.wb_we_i(bussl_we_i[S7]),
.wb_ack_o(bussl_ack_o[S7]),
.wb_dat_o(bussl_dat_o[S7]),
.wb_err_o(bussl_err_o[S7])

);


md5_top md5_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S8]),
.wb_cyc_i(bussl_cyc_i[S8]),
.wb_dat_i(bussl_dat_i[S8]),
.wb_sel_i(bussl_sel_i[S8]),
.wb_stb_i(bussl_stb_i[S8]),
.wb_we_i(bussl_we_i[S8]),
.wb_ack_o(bussl_ack_o[S8]),
.wb_dat_o(bussl_dat_o[S8]),
.wb_err_o(bussl_err_o[S8])

);


iir_top iir_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S9]),
.wb_cyc_i(bussl_cyc_i[S9]),
.wb_dat_i(bussl_dat_i[S9]),
.wb_sel_i(bussl_sel_i[S9]),
.wb_stb_i(bussl_stb_i[S9]),
.wb_we_i(bussl_we_i[S9]),
.wb_ack_o(bussl_ack_o[S9]),
.wb_dat_o(bussl_dat_o[S9]),
.wb_err_o(bussl_err_o[S9])

);




assign bussl_dat_o[S0][31:24] = 8'd0;
assign bussl_dat_o[S0][15:0] = 16'd0;


uart_top uart_top_inst
(
.wb_clk_i(clk),
.wb_rst_i(rst),
.wb_adr_i(bussl_adr_i[S0][2:0]),
.wb_dat_i(bussl_dat_i[S0][23:16]),
.wb_we_i(bussl_we_i[S0]),
.wb_stb_i(bussl_stb_i[S0]),
.wb_cyc_i(bussl_cyc_i[S0]),
.wb_sel_i(bussl_sel_i[S0]),
.wb_dat_o(bussl_dat_o[S0][23:16]),
.wb_ack_o(bussl_ack_o[S0]),
.wb_err_o(),
.srx_pad_i(srx_pad_i),
.stx_pad_o(stx_pad_o),
.rts_pad_o(rts_pad_o),
.cts_pad_i(cts_pad_i),
.dtr_pad_o(),
.dsr_pad_i(),
.ri_pad_i(),
.dcd_pad_i(),
.int_o()
 );




wb_bus_b3 
# (
.MASTERS(NR_MASTERS),.SLAVES(NR_SLAVES),
.S0_ENABLE(CONFIG.ENABLE_S0),
.S0_RANGE_WIDTH(CONFIG.S0_RANGE_WIDTH),.S0_RANGE_MATCH(CONFIG.S0_RANGE_MATCH),
.S1_ENABLE(CONFIG.ENABLE_S1),
.S1_RANGE_WIDTH(CONFIG.S1_RANGE_WIDTH),.S1_RANGE_MATCH(CONFIG.S1_RANGE_MATCH),
.S2_ENABLE(CONFIG.ENABLE_S2),
.S2_RANGE_WIDTH(CONFIG.S2_RANGE_WIDTH),.S2_RANGE_MATCH(CONFIG.S2_RANGE_MATCH),
.S3_ENABLE(CONFIG.ENABLE_S3),
.S3_RANGE_WIDTH(CONFIG.S3_RANGE_WIDTH),.S3_RANGE_MATCH(CONFIG.S3_RANGE_MATCH),
.S4_ENABLE(CONFIG.ENABLE_S4),
.S4_RANGE_WIDTH(CONFIG.S4_RANGE_WIDTH),.S4_RANGE_MATCH(CONFIG.S4_RANGE_MATCH),
.S5_ENABLE(CONFIG.ENABLE_S5),
.S5_RANGE_WIDTH(CONFIG.S5_RANGE_WIDTH),.S5_RANGE_MATCH(CONFIG.S5_RANGE_MATCH),
.S6_ENABLE(CONFIG.ENABLE_S6),
.S6_RANGE_WIDTH(CONFIG.S6_RANGE_WIDTH),.S6_RANGE_MATCH(CONFIG.S6_RANGE_MATCH),
.S7_ENABLE(CONFIG.ENABLE_S7),
.S7_RANGE_WIDTH(CONFIG.S7_RANGE_WIDTH),.S7_RANGE_MATCH(CONFIG.S7_RANGE_MATCH),
.S8_ENABLE(CONFIG.ENABLE_S8),
.S8_RANGE_WIDTH(CONFIG.S8_RANGE_WIDTH),.S8_RANGE_MATCH(CONFIG.S8_RANGE_MATCH),
.S9_ENABLE(CONFIG.ENABLE_S9),
.S9_RANGE_WIDTH(CONFIG.S9_RANGE_WIDTH),.S9_RANGE_MATCH(CONFIG.S9_RANGE_MATCH)
)
u_bus(
// Outputs
.m_dat_o(busms_dat_i_flat),
.m_ack_o(busms_ack_i_flat),
.m_err_o(busms_err_i_flat),
.m_rty_o(busms_rty_i_flat),
.s_adr_o(bussl_adr_i_flat),
.s_dat_o(bussl_dat_i_flat),
.s_cyc_o(bussl_cyc_i_flat),
.s_stb_o(bussl_stb_i_flat),
.s_sel_o(bussl_sel_i_flat),
.s_we_o(bussl_we_i_flat),
.s_cti_o(bussl_cti_i_flat),
.s_bte_o(bussl_bte_i_flat),
.snoop_adr_o(snoop_adr),
.snoop_en_o(snoop_enable),
.bus_hold_ack(),
// Inputs
.clk_i(clk),
.rst_i(rst),
.m_adr_i(busms_adr_o_flat),
.m_dat_i(busms_dat_o_flat),
.m_cyc_i(busms_cyc_o_flat),
.m_stb_i(busms_stb_o_flat),
.m_sel_i(busms_sel_o_flat),
.m_we_i(busms_we_o_flat),
.m_cti_i(busms_cti_o_flat),
.m_bte_i(busms_bte_o_flat),
.s_dat_i(bussl_dat_o_flat),
.s_ack_i(bussl_ack_o_flat),
.s_err_i(bussl_err_o_flat),
.s_rty_i(bussl_rty_o_flat),
.bus_hold()
);

endmodule

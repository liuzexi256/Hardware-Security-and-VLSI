`include "orpsoc-defines.sv"
`include "axi_intf.sv"
`include "axi_bus.sv"

`timescale 1 ns / 1 ps

import axi_pkg::*;

module axi_top (

sys_clk_in_p,
sys_clk_in_n,
`ifdef RESET_HIGH
    rst_pad_i, 
 `else
    rst_n_pad_i, 
`endif
uart_srx_pad_i,
uart_cts_pad_i,
uart_stx_pad_o,
uart_rts_pad_o
);


input    sys_clk_in_p;
input    sys_clk_in_n;
`ifdef RESET_HIGH
    input   rst_pad_i; 
 `else
    input   rst_n_pad_i; 
`endif
input    uart_srx_pad_i;
input    uart_cts_pad_i;
output    uart_stx_pad_o;
output    uart_rts_pad_o;


wire    core_clk;
wire    core_rst;
// AXI4 - Lite declerations
// Master defininitions
// Master 0
// Master 1
AXI_LITE  # (
            .AXI_ADDR_WIDTH(`CEP_AXI_ADDR_WIDTH),
            .AXI_DATA_WIDTH(`CEP_AXI_DATA_WIDTH)
            ) master[1:0]();
// Slave Bus Declaration(see orpsoc - defines.sv for additional info including slave assignment)
AXI_LITE  # (
           .AXI_ADDR_WIDTH (`CEP_AXI_ADDR_WIDTH),
           .AXI_DATA_WIDTH (`CEP_AXI_DATA_WIDTH)
            ) slave[11:0]();
// Declaration the routing rules for the AXI4 - Lite Crossbar
AXI_ROUTING_RULES  # (
                    .AXI_ADDR_WIDTH (`CEP_AXI_ADDR_WIDTH),
                    .NUM_SLAVE      (`CEP_NUM_OF_SLAVES),
                    .NUM_RULES      (1)
                     ) routing();
//Assign the routing rules (cep_routing_rules is declared and explained in orpsoc-defines.v)
   for (genvar i = 0; i < `CEP_NUM_OF_SLAVES; i++) begin
        assign routing.rules[i][0].enabled  = cep_routing_rules[i][0][0];
        assign routing.rules[i][0].mask     = cep_routing_rules[i][1];
        assign routing.rules[i][0].base     = cep_routing_rules[i][2];
   end // for (genvar i = 0; i < CEP_NUM_OF_SLAVES; i++)



axi_lite_xbar #(
    .ADDR_WIDTH     (`CEP_AXI_ADDR_WIDTH ),
    .DATA_WIDTH     (`CEP_AXI_DATA_WIDTH ),
    .NUM_MASTER     (`CEP_NUM_OF_MASTERS ),
    .NUM_SLAVE      (`CEP_NUM_OF_SLAVES  ),
    .NUM_RULES      (1)
) axi_lite_xbar_inst (
    .clk_i          ( core_clk          ),
    .rst_ni         ( ~core_rst         ),
    .master         ( master            ),
    .slave          ( slave             ),
    .rules          ( routing           )
);


// Instantiating Clock and Reset Generator IP
clkgen clkgen_inst (

`ifdef RESET_HIGH
    .rst_n_pad_i(~rst_pad_i), 
 `else
    .rst_n_pad_i(rst_n_pad_i), 
`endif
.sys_clk_in_p    (sys_clk_in_p),
.sys_clk_in_n    (sys_clk_in_n),
.core_clk_o    (core_clk),
.core_rst_o    (core_rst)
);

// Instantiating RAM IP
ram_top_axi4lite # (
    .MEMORY_SIZE(`CEP_RAM_SIZE)
) ram_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`RAM_SLAVE_NUMBER])
);


// Instantiating UART IP
wire    uart_irq;
uart_top_axi4lite uart_top_axi4lite_inst (

// UART Signals
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`UART_SLAVE_NUMBER]),

.srx_pad_i      (uart_srx_pad_i ),
.stx_pad_o      (uart_stx_pad_o ),
.rts_pad_o      (uart_rts_pad_o ),
.cts_pad_i      (uart_cts_pad_i ),
.dtr_pad_o      (               ),
.dsr_pad_i      (1'b0           ),
.ri_pad_i       (1'b0           ),
.dcd_pad_i      (1'b0           ),
// Processor Interrupt
.int_o          (uart_irq       )
);


// Instantiating PICORV IP
picorv32_top_axi4lite picorv32_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_i    (core_rst),
.master_d    (master [0])
);


// Instantiating AES IP
generate
if(cep_routing_rules[`AES_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
aes_top_axi4lite aes_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`AES_SLAVE_NUMBER])

);
endgenerate

// Instantiating DES3 IP
generate
if(cep_routing_rules[`DES3_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
des3_top_axi4lite des3_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`DES3_SLAVE_NUMBER])

);
endgenerate

// Instantiating SHA256 IP
generate
if(cep_routing_rules[`SHA256_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
sha256_top_axi4lite sha256_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`SHA256_SLAVE_NUMBER])

);
endgenerate

// Instantiating IIR IP
generate
if(cep_routing_rules[`IIR_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
iir_top_axi4lite iir_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`IIR_SLAVE_NUMBER])

);
endgenerate

// Instantiating FIR IP
generate
if(cep_routing_rules[`FIR_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
fir_top_axi4lite fir_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`FIR_SLAVE_NUMBER])

);
endgenerate

// Instantiating DFT IP
generate
if(cep_routing_rules[`DFT_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
dft_top_top_axi4lite dft_top_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`DFT_SLAVE_NUMBER])

);
endgenerate

// Instantiating IDFT IP
generate
if(cep_routing_rules[`IDFT_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
idft_top_top_axi4lite idft_top_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`IDFT_SLAVE_NUMBER])

);
endgenerate

// Instantiating MD5 IP
generate
if(cep_routing_rules[`MD5_SLAVE_NUMBER][0] == `CEP_SLAVE_ENABLED)
md5_top_axi4lite md5_top_axi4lite_inst (
.clk_i    (core_clk),
.rst_ni    (~core_rst),
.slave    (slave[`MD5_SLAVE_NUMBER])

);
endgenerate

endmodule
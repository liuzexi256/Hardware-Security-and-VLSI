//
// Copyright (C) 2018 Massachusetts Institute of Technology
//

// Project      : Common Evaluation Platform (CEP)
// Description  : This file provides an axi4-lite wrapper for the wishbone based-MOR1KX processor
//

`timescale 1 ns / 1 ps
// `default_nettype none
// `define DEBUGNETS
// `define DEBUGREGS
// `define DEBUGASM
// `define DEBUG

`ifdef DEBUG
  `define debug(debug_command) debug_command
`else
  `define debug(debug_command)
`endif

`ifdef FORMAL
  `define FORMAL_KEEP (* keep *)
  `define assert(assert_expr) assert(assert_expr)
`else
  `ifdef DEBUGNETS
    `define FORMAL_KEEP (* keep *)
  `else
    `define FORMAL_KEEP
  `endif
  `define assert(assert_expr) empty_statement
`endif

// uncomment this for register file in extra module
// `define PICORV32_REGS picorv32_regs

// this macro can be used to check if the verilog files in your
// design are read in the correct order.
`define PICORV32_V


module picorv32_top_axi4lite (
    
    // Clock and Resets
    input                                   clk_i,
    input                                   rst_i,

    AXI_LITE.Master                            master_d 
    
);


 picoaxi #(
    .ENABLE_COUNTERS (),
	.ENABLE_COUNTERS64 (),
	.ENABLE_REGS_16_31 (),
	.ENABLE_REGS_DUALPORT (),
	.TWO_STAGE_SHIFT(),
	.BARREL_SHIFTER (),
	.TWO_CYCLE_COMPARE (),
	.TWO_CYCLE_ALU (),
	.COMPRESSED_ISA (),
	.CATCH_MISALIGN (),
	.CATCH_ILLINSN (),
	.ENABLE_PCPI (),
	.ENABLE_MUL (),
	.ENABLE_FAST_MUL (),
	.ENABLE_DIV (),
	.ENABLE_IRQ (),
    .ENABLE_IRQ_QREGS (),
	.ENABLE_IRQ_TIMER (),
	.ENABLE_TRACE (),
	.REGS_INIT_ZERO (),
	.MASKED_IRQ (),
	.LATCHED_IRQ (),
	.PROGADDR_RESET (),
	.PROGADDR_IRQ (),
	.STACKADDR ()
    ) 
   
   
picoaxi_inst (

	.clk_i (clk_i),
	.rst_i (rst_i),
	


	// AXI4-lite master memory interface 

	.mem_axi_awvalid (master_d.aw_valid),
	.mem_axi_awready (master_d.aw_ready),
	.mem_axi_awaddr (master_d.aw_addr),
	.mem_axi_awprot(),

	.mem_axi_wvalid (master_d.w_valid),
	.mem_axi_wready (master_d.w_ready),
	.mem_axi_wdata (master_d.w_data),
	.mem_axi_bvalid (master_d.b_valid),
	.mem_axi_bready (master_d.b_ready),

	.mem_axi_arvalid (master_d.ar_valid),
	.mem_axi_arready (master_d.ar_ready),
	.mem_axi_araddr (master_d.ar_addr),
	.mem_axi_arprot (),

	.mem_axi_rvalid (master_d.r_valid),
	.mem_axi_rready (master_d.r_ready),
	.mem_axi_rdata (master_d.r_data)
	
);
 

endmodule // picorv32_axi4lite
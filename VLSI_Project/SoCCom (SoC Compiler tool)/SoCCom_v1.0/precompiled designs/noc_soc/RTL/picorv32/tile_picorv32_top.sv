/* Copyright (c) 2013-2017 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================*/


module tile_picorv32_top

    import dii_package::*;
    import optimsoc_functions::*;
    import optimsoc_config::*;

   #(
    parameter config_t CONFIG = 'x,

    localparam CHANNELS = CONFIG.NOC_CHANNELS,
    localparam FLIT_WIDTH = CONFIG.NOC_FLIT_WIDTH,

    
    /* User parameters */
    // Set the number of masters and slaves
    parameter MASTERS = 1,
    parameter SLAVES = 10,

    // Set bus address and data width in bits
    // DATA_WIDTH must be a multiple of 8 (full bytes)!
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,

    // Memory range definitions, see above
    // The number of parameters actually limits the number of slaves as
    // there is no generic way that is handled by all tools to define
    // variable width parameter arrays.
    parameter S0_ENABLE = 1,
    parameter S0_RANGE_WIDTH = 1,
    parameter S0_RANGE_MATCH = 1'b0,
    parameter S1_ENABLE = 1,
    parameter S1_RANGE_WIDTH = 1,
    parameter S1_RANGE_MATCH = 1'b0,
    parameter S2_ENABLE = 1,
    parameter S2_RANGE_WIDTH = 1,
    parameter S2_RANGE_MATCH = 1'b0,
    parameter S3_ENABLE = 1,
    parameter S3_RANGE_WIDTH = 1,
    parameter S3_RANGE_MATCH = 1'b0,
    parameter S4_ENABLE = 1,
    parameter S4_RANGE_WIDTH = 1,
    parameter S4_RANGE_MATCH = 1'b0,
    parameter S5_ENABLE = 1,
    parameter S5_RANGE_WIDTH = 1,
    parameter S5_RANGE_MATCH = 1'b0,
    parameter S6_ENABLE = 1,
    parameter S6_RANGE_WIDTH = 1,
    parameter S6_RANGE_MATCH = 1'b0,
    parameter S7_ENABLE = 1,
    parameter S7_RANGE_WIDTH = 1,
    parameter S7_RANGE_MATCH = 1'b0,
    parameter S8_ENABLE = 1,
    parameter S8_RANGE_WIDTH = 1,
    parameter S8_RANGE_MATCH = 1'b0,
    parameter S9_ENABLE = 1,
    parameter S9_RANGE_WIDTH = 1,
    parameter S9_RANGE_MATCH = 1'b0,

   /* Derived local parameters */
   // Width of byte select registers
   localparam SEL_WIDTH = DATA_WIDTH >> 3
    
    )
   (


    input                                 clk,
    input                                 rst_sys,

    input [CHANNELS-1:0][FLIT_WIDTH-1:0]  noc_in_flit,
    input [CHANNELS-1:0]                  noc_in_last,
    input [CHANNELS-1:0]                  noc_in_valid,
    output [CHANNELS-1:0]                 noc_in_ready,
    output [CHANNELS-1:0][FLIT_WIDTH-1:0] noc_out_flit,
    output [CHANNELS-1:0]                 noc_out_last,
    output [CHANNELS-1:0]                 noc_out_valid,
    input [CHANNELS-1:0]                  noc_out_ready

   );



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

   localparam SLAVE_NA        =     S0;
   localparam SLAVE_AES       =     S1;
   localparam SLAVE_DES3      =     S2;
   localparam SLAVE_SHA256    =     S3;
   localparam SLAVE_MD5       =     S4;
   localparam SLAVE_DFT       =     S5;
   localparam SLAVE_FIR       =     S6;
   localparam SLAVE_IDFT      =     S7;
   localparam SLAVE_WBRAM     =     S8;
   localparam SLAVE_UART      =     S9;


   wire [31:0]   busms_adr_o;
   wire          busms_cyc_o;
   wire [31:0]   busms_dat_o;
   wire [3:0]    busms_sel_o;
   wire          busms_stb_o;
   wire          busms_we_o;
   wire          busms_cab_o;
   wire [2:0]    busms_cti_o;
   wire [1:0]    busms_bte_o;
   wire          busms_ack_i;
   wire          busms_rty_i;
   wire          busms_err_i;
   wire [31:0]   busms_dat_i;

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

   genvar         m, s;

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




wb_bus_b3
    # (
      .MASTERS(NR_MASTERS),.SLAVES(NR_SLAVES),

       .S0_ENABLE(S0_ENABLE),
       .S0_RANGE_WIDTH(S0_RANGE_WIDTH),.S0_RANGE_MATCH(S0_RANGE_MATCH),

       .S1_ENABLE(S1_ENABLE),
       .S1_RANGE_WIDTH(S1_RANGE_WIDTH),.S1_RANGE_MATCH(S1_RANGE_MATCH),

       .S2_ENABLE(S2_ENABLE),
       .S2_RANGE_WIDTH(S2_RANGE_WIDTH),.S2_RANGE_MATCH(S2_RANGE_MATCH),

       .S3_ENABLE(S3_ENABLE),
       .S3_RANGE_WIDTH(S3_RANGE_WIDTH),.S3_RANGE_MATCH(S3_RANGE_MATCH),

       .S4_ENABLE(S4_ENABLE),
       .S4_RANGE_WIDTH(S4_RANGE_WIDTH),.S4_RANGE_MATCH(S4_RANGE_MATCH),

       .S5_ENABLE(S5_ENABLE),
       .S5_RANGE_WIDTH(S5_RANGE_WIDTH),.S5_RANGE_MATCH(S5_RANGE_MATCH),

       .S6_ENABLE(S6_ENABLE),
       .S6_RANGE_WIDTH(S6_RANGE_WIDTH),.S6_RANGE_MATCH(S6_RANGE_MATCH),

       .S7_ENABLE(S7_ENABLE),
       .S7_RANGE_WIDTH(S7_RANGE_WIDTH),.S7_RANGE_MATCH(S7_RANGE_MATCH),

       .S8_ENABLE(S8_ENABLE),
       .S8_RANGE_WIDTH(S8_RANGE_WIDTH),.S8_RANGE_MATCH(S8_RANGE_MATCH),

       .S9_ENABLE(S9_ENABLE),
       .S9_RANGE_WIDTH(S9_RANGE_WIDTH),.S9_RANGE_MATCH(S9_RANGE_MATCH)
      )
   u_bus(/*AUTOINST*/
         // Outputs
         .m_dat_o                       (busms_dat_i),      // Templated
         .m_ack_o                       (busms_ack_i),      // Templated
         .m_err_o                       (busms_err_i),      // Templated
         .m_rty_o                       (busms_rty_i),      // Templated
         .s_adr_o                       (bussl_adr_i_flat),      // Templated
         .s_dat_o                       (bussl_dat_i_flat),      // Templated
         .s_cyc_o                       (bussl_cyc_i_flat),      // Templated
         .s_stb_o                       (bussl_stb_i_flat),      // Templated
         .s_sel_o                       (bussl_sel_i_flat),      // Templated
         .s_we_o                        (bussl_we_i_flat),       // Templated
         .s_cti_o                       (bussl_cti_i_flat),      // Templated
         .s_bte_o                       (bussl_bte_i_flat),      // Templated
         .snoop_adr_o                   (snoop_adr),             // Templated
         .snoop_en_o                    (snoop_enable),          // Templated
         .bus_hold_ack                  (),                      // Templated
         // Inputs
         .clk_i                         (clk),                   // Templated
         .rst_i                         (rst_sys),               // Templated
         .m_adr_i                       (busms_adr_o),      // Templated
         .m_dat_i                       (busms_dat_o),      // Templated
         .m_cyc_i                       (busms_cyc_o),      // Templated
         .m_stb_i                       (busms_stb_o),      // Templated
         .m_sel_i                       (busms_sel_o),      // Templated
         .m_we_i                        (busms_we_o),       // Templated
         .m_cti_i                       (busms_cti_o),      // Templated
         .m_bte_i                       (busms_bte_o),      // Templated
         .s_dat_i                       (bussl_dat_o_flat),      // Templated
         .s_ack_i                       (bussl_ack_o_flat),      // Templated
         .s_err_i                       (bussl_err_o_flat),      // Templated
         .s_rty_i                       (bussl_rty_o_flat),      // Templated
         .bus_hold                      (1'b0));                         // Templated

   // Unused leftover from an older Wishbone spec version
   assign bussl_cab_i_flat = NR_SLAVES'(1'b0);


   networkadapter_ct
      #(.CONFIG(CONFIG)
        )
      u_na(
           // Outputs
           .noc_in_ready                (noc_in_ready),
           .noc_out_flit                (noc_out_flit),
           .noc_out_last                (noc_out_last),
           .noc_out_valid               (noc_out_valid),
           .wbm_adr_o                   (busms_adr_o),
           .wbm_cyc_o                   (busms_cyc_o),
           .wbm_dat_o                   (busms_dat_o),
           .wbm_sel_o                   (busms_sel_o),
           .wbm_stb_o                   (busms_stb_o),
           .wbm_we_o                    (busms_we_o),
           .wbm_cab_o                   (busms_cab_o),
           .wbm_cti_o                   (busms_cti_o),
           .wbm_bte_o                   (busms_bte_o),
           .wbs_ack_o                   (bussl_ack_o[S0]),
           .wbs_rty_o                   (bussl_rty_o[S0]),
           .wbs_err_o                   (bussl_err_o[S0]),
           .wbs_dat_o                   (bussl_dat_o[S0]),
           .irq                         (),
           // Inputs
           .clk                         (clk),
           .rst                         (rst_sys),
           .noc_in_flit                 (noc_in_flit),
           .noc_in_last                 (noc_in_last),
           .noc_in_valid                (noc_in_valid),
           .noc_out_ready               (noc_out_ready),
           .wbm_ack_i                   (busms_ack_i),
           .wbm_rty_i                   (busms_rty_i),
           .wbm_err_i                   (busms_err_i),
           .wbm_dat_i                   (busms_dat_i),
           .wbs_adr_i                   (bussl_adr_i[S0]),
           .wbs_cyc_i                   (bussl_cyc_i[S0]),
           .wbs_dat_i                   (bussl_dat_i[S0]),
           .wbs_sel_i                   (bussl_sel_i[S0]),
           .wbs_stb_i                   (bussl_stb_i[S0]),
           .wbs_we_i                    (bussl_we_i[S0]),
           .wbs_cab_i                   (bussl_cab_i[S0]),
           .wbs_cti_i                   (bussl_cti_i[S0]),
           .wbs_bte_i                   (bussl_bte_i[S0]));
  
      
      picorv32_top picorv32_top_inst
     (
        
        .wb_clk_i(clk),
        .wb_rst_i(rst_sys),
		.wbm_adr_o                 (busms_adr_o), // Templated
        .wbm_dat_i                 (busms_dat_i), // Templated
        .wbm_cyc_o                 (busms_cyc_o), // Templated
        .wbm_stb_o                 (busms_stb_o), // Templated
        .wbm_we_o                  (busms_we_o), // Templated
		.wbm_dat_o                 (busms_dat_o), // Templated
        .wbm_ack_i                 (busms_ack_i), // Templated
        .wbm_sel_o                 ()
        ); // Templated
     



endmodule

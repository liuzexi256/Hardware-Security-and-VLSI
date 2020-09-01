//======================================================================
//
// tb_sha256_axi4.v
// ----------------
// Testbench for the SHA256 AXI4 wrapper.
//
//
// Author: Sanjay A Menon
// Copyright (c) 2020
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module tb_sha256_axi4();

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter DEBUG = 0;

  parameter CLK_HALF_PERIOD = 2;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;


  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg [31 : 0] cycle_ctr;
  reg [31 : 0] error_ctr;
  reg [31 : 0] tc_ctr;

  reg            tb_clk;
  reg            tb_reset_n;

  reg [7:0]      tb_awaddr;
  reg [2:0]      tb_awprot;
  reg            tb_awvalid;
  wire           tb_awready;
  reg [31:0]     tb_wdata;
  reg [3:0]      tb_wstrb;
  reg            tb_wvalid;
  wire           tb_wready;
  wire [1:0]     tb_bresp;
  wire           tb_bvalid;
  reg            tb_bready;
  reg [7:0]      tb_araddr;
  reg [2:0]      tb_arprot;
  reg            tb_arvalid;
  wire           tb_arready;
  wire [31:0]    tb_rdata;
  wire [1:0]     tb_rresp;
  wire           tb_rvalid;
  reg            tb_rready;
  wire           complete;

  reg            tb_init;
  reg            tb_next;
  reg            tb_mode;
  reg [511 : 0]  tb_block;
  wire           tb_ready;
  reg [255 : 0] tb_digest;
  wire           tb_digest_valid;
  reg [31:0] i;


  //----------------------------------------------------------------
  // Device Under Test.
  //----------------------------------------------------------------
  sha256_axi4 dut(
                  .hash_complete(complete),
                  .s00_axi_aclk(tb_clk),
                  .s00_axi_aresetn(tb_reset_n),
                  .s00_axi_awaddr(tb_awaddr),
                  .s00_axi_awprot(tb_awprot),
                  .s00_axi_awvalid(tb_awvalid),
                  .s00_axi_awready(tb_awready),
                  .s00_axi_wdata(tb_wdata),
                  .s00_axi_wstrb(tb_wstrb),
                  .s00_axi_wvalid(tb_wvalid),
                  .s00_axi_wready(tb_wready),
                  .s00_axi_bresp(tb_bresp),
                  .s00_axi_bvalid(tb_bvalid),
                  .s00_axi_bready(tb_bready),
                  .s00_axi_araddr(tb_araddr),
                  .s00_axi_arprot(tb_arprot),
                  .s00_axi_arvalid(tb_arvalid),
                  .s00_axi_arready(tb_arready),
                  .s00_axi_rdata(tb_rdata),
                  .s00_axi_rresp(tb_rresp),
                  .s00_axi_rvalid(tb_rvalid),
                  .s00_axi_rready(tb_rready)
                 );


  //----------------------------------------------------------------
  // clk_gen
  //
  // Always running clock generator process.
  //----------------------------------------------------------------
  always
    begin : clk_gen
      #CLK_HALF_PERIOD;
      tb_clk = !tb_clk;
    end // clk_gen


  //----------------------------------------------------------------
  // sys_monitor()
  //
  // An always running process that creates a cycle counter and
  // conditionally displays information about the DUT.
  //----------------------------------------------------------------
  always
    begin : sys_monitor
      cycle_ctr = cycle_ctr + 1;
      #(2 * CLK_HALF_PERIOD);
      if (DEBUG)
        begin
          //dump_dut_state();
        end
    end


  //----------------------------------------------------------------
  // dump_dut_state()
  //
  // Dump the state of the dump when needed.
  //----------------------------------------------------------------
  /*task dump_dut_state;
    begin
      $display("State of DUT");
      $display("------------");
      $display("Inputs and outputs:");
      $display("init   = 0x%01x, next  = 0x%01x",
               dut.init, dut.next);
      $display("block  = 0x%0128x", dut.block);

      $display("ready  = 0x%01x, valid = 0x%01x",
               dut.ready, dut.digest_valid);
      $display("digest = 0x%064x", dut.digest);
      $display("H0_reg = 0x%08x, H1_reg = 0x%08x, H2_reg = 0x%08x, H3_reg = 0x%08x",
               dut.H0_reg, dut.H1_reg, dut.H2_reg, dut.H3_reg);
      $display("H4_reg = 0x%08x, H5_reg = 0x%08x, H6_reg = 0x%08x, H7_reg = 0x%08x",
               dut.H4_reg, dut.H5_reg, dut.H6_reg, dut.H7_reg);
      $display("");

      $display("Control signals and counter:");
      $display("sha256_ctrl_reg = 0x%02x", dut.sha256_ctrl_reg);
      $display("digest_init     = 0x%01x, digest_update = 0x%01x",
               dut.digest_init, dut.digest_update);
      $display("state_init      = 0x%01x, state_update  = 0x%01x",
               dut.state_init, dut.state_update);
      $display("first_block     = 0x%01x, ready_flag    = 0x%01x, w_init    = 0x%01x",
               dut.first_block, dut.ready_flag, dut.w_init);
      $display("t_ctr_inc       = 0x%01x, t_ctr_rst     = 0x%01x, t_ctr_reg = 0x%02x",
               dut.t_ctr_inc, dut.t_ctr_rst, dut.t_ctr_reg);
      $display("");

      $display("State registers:");
      $display("a_reg = 0x%08x, b_reg = 0x%08x, c_reg = 0x%08x, d_reg = 0x%08x",
               dut.a_reg, dut.b_reg, dut.c_reg, dut.d_reg);
      $display("e_reg = 0x%08x, f_reg = 0x%08x, g_reg = 0x%08x, h_reg = 0x%08x",
               dut.e_reg, dut.f_reg, dut.g_reg, dut.h_reg);
      $display("");
      $display("a_new = 0x%08x, b_new = 0x%08x, c_new = 0x%08x, d_new = 0x%08x",
               dut.a_new, dut.b_new, dut.c_new, dut.d_new);
      $display("e_new = 0x%08x, f_new = 0x%08x, g_new = 0x%08x, h_new = 0x%08x",
               dut.e_new, dut.f_new, dut.g_new, dut.h_new);
      $display("");

      $display("State update values:");
      $display("w  = 0x%08x, k  = 0x%08x", dut.w_data, dut.k_data);
      $display("t1 = 0x%08x, t2 = 0x%08x", dut.t1, dut.t2);
      $display("");
    end
  endtask // dump_dut_state */


  //----------------------------------------------------------------
  // reset_dut()
  //
  // Toggle reset to put the DUT into a well known state.
  //----------------------------------------------------------------
  task reset_dut;
    begin
      $display("*** Toggle reset.");
      tb_reset_n = 0;
      #(4 * CLK_HALF_PERIOD);
      tb_reset_n = 1;
    end
  endtask // reset_dut


  //----------------------------------------------------------------
  // init_sim()
  //
  // Initialize all counters and testbed functionality as well
  // as setting the DUT inputs to defined values.
  //----------------------------------------------------------------
  task init_sim;
    begin
      cycle_ctr = 0;
      error_ctr = 0;
      tc_ctr = 0;

      tb_clk = 0;
      tb_reset_n = 1;


      tb_awaddr = 8'h00;
      tb_awprot = 3'b000;
      tb_awvalid = 0;
      tb_wdata = 32'h00000000;
      tb_wstrb = 4'h0;
      tb_wvalid = 0;
      tb_bready = 0;
      tb_araddr = 8'h00;
      tb_arprot = 3'b000;
      tb_arvalid = 0;
      tb_rready = 0;
      i = 0;
    end
  endtask // init_dut


  //----------------------------------------------------------------
  // display_test_result()
  //
  // Display the accumulated test results.
  //----------------------------------------------------------------
  task display_test_result;
    begin
      if (error_ctr == 0)
        begin
          $display("*** All %02d test cases completed successfully", tc_ctr);
        end
      else
        begin
          $display("*** %02d test cases did not complete successfully.", error_ctr);
        end
    end
  endtask // display_test_result


  //----------------------------------------------------------------
  // wait_ready()
  //
  // Wait for the ready flag in the dut to be set.
  //
  // Note: It is the callers responsibility to call the function
  // when the dut is actively processing and will in fact at some
  // point set the flag.
  //----------------------------------------------------------------
  task wait_ready;
    begin
      while (!tb_awready)
        begin
          #(CLK_PERIOD);
        end
    end
  endtask // wait_ready

  task wait_read;
    begin
      while (!tb_arready)//tb_arready
        begin
          #(CLK_PERIOD);
        end
    end
  endtask // wait_read

  task wait_hash_complete;
    begin
      while (!complete)
        begin
          #(CLK_PERIOD);
        end
    end
  endtask // wait_hash_complete


  //----------------------------------------------------------------
  // single_block_test()
  //
  // Run a test case spanning a single data block.
  //----------------------------------------------------------------
  task single_block_test(input [7 : 0]   tc_number,
                         input [511 : 0] block,
                         input [255 : 0] expected);
   begin
     $display("*** TC %0d single block test case started.", tc_number);
     tc_ctr = tc_ctr + 1;

     tb_awprot = 1;
     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000005;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_bready = 1;
     //$display("0x%08x",block[31:0]);
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h1f;
     tb_wdata = block[31:0];
     #(CLK_PERIOD);
     wait_ready();


     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     //tb_bready = 1;
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h1e;
     tb_wdata = block[63:32];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[1]);


     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h1d;
     tb_wdata = block[95:64];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[2]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h1c;
     tb_wdata = block[127:96];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[3]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h1b;
     tb_wdata = block[159:128];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[4]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h1a;
     tb_wdata = block[191:160];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[5]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h19;
     tb_wdata = block[223:192];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[6]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h18;
     tb_wdata = block[255:224];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[7]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h17;
     tb_wdata = block[287:256];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[8]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h16;
     tb_wdata = block[319:288];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[9]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h15;
     tb_wdata = block[351:320];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[10]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h14;
     tb_wdata = block[383:352];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[11]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h13;
     tb_wdata = block[415:384];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[12]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h12;
     tb_wdata = block[447:416];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[13]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h11;
     tb_wdata = block[479:448];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[14]);

     //tb_awvalid = 1;
     //tb_wvalid = 1;
     //tb_awaddr = 8'h08;
     //tb_wdata = 32'h00000006;
     //#(CLK_PERIOD);
     //wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h10;
     tb_wdata = block[511:480];
     #(CLK_PERIOD);
     wait_ready();
     //$display(dut.block_reg[15]);
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h08;
     tb_wdata = 32'h00000005;
     #(CLK_PERIOD);
     wait_ready();
     tb_awvalid = 1;
     tb_wvalid = 1;
     tb_awaddr = 8'h08;
     tb_wdata = 32'h00000004;
     #(CLK_PERIOD);
     wait_ready();

     //tb_init = 1;
     //tb_mode = 1;
     //output section

     wait_hash_complete();
     tb_awvalid = 0;
     tb_wvalid = 0;
     //tb_bready = 0;
     //tb_init = 0;

     tb_araddr = 8'h20;
     tb_arprot = 1;
     tb_arvalid = 1;
     tb_rready = 1;
     wait_read();
     #(CLK_PERIOD);
     tb_digest[31:0] = tb_rdata;
     //$display(dut.tmp_read_data);
     //$display(dut.core_block);
     $display("abc2= 0x%032x",dut.core_digest);
     #(CLK_PERIOD);
     wait_read();

     tb_arvalid = 1;
     tb_rready = 1;
     tb_araddr = 8'h21;
     tb_digest[63:32] = tb_rdata;
     #(CLK_PERIOD);
     wait_read();

     //tb_arvalid = 1;
     //tb_rready = 1;
     //tb_araddr = 8'h22;
     //tb_digest[95:64] = tb_rdata;
     //#(CLK_PERIOD);
     //wait_read();

     //tb_arvalid = 1;
     //tb_rready = 1;
     //tb_araddr = 8'h23;
     //tb_digest[127:96] = tb_rdata;
     //#(CLK_PERIOD);
     //wait_read();

     //tb_arvalid = 1;
     //tb_rready = 1;
     //tb_araddr = 8'h24;
     //tb_digest[159:128] = tb_rdata;
     //#(CLK_PERIOD);
     //wait_read();

     //tb_arvalid = 1;
     //tb_rready = 1;
     //tb_araddr = 8'h25;
     //tb_digest[191:160] = tb_rdata;
     //#(CLK_PERIOD);
     //wait_read();

     //tb_arvalid = 1;
     //tb_rready = 1;
     //tb_araddr = 8'h26;
     //tb_digest[223:192] = tb_rdata;
     //#(CLK_PERIOD);
     //wait_read();

     //tb_arvalid = 1;
     //tb_rready = 1;
     //tb_araddr = 8'h27;
     //tb_digest[255:224] = tb_rdata;
     //#(CLK_PERIOD);
     //wait_read();


     //wait_ready();


 //    if (tb_digest == expected)
 //      begin
 //        $display("*** TC %0d successful.", tc_number);
 //      end
 //    else
 //      begin
 //        $display("*** ERROR: TC %0d NOT successful.", tc_number);
 //        $display("Expected: 0x%064x", expected);
 //        $display("Got:      0x%064x", tb_digest);
 //        $display("");
 //
 //        error_ctr = error_ctr + 1;
 //      end
    end

  endtask // single_block_test


  //----------------------------------------------------------------
  // double_block_test()
  //
  // Run a test case spanning two data blocks. We check both
  // intermediate and final digest.
  //----------------------------------------------------------------
  task double_block_test(input [7 : 0]   tc_number,
                         input [511 : 0] block1,
                         input [255 : 0] expected1,
                         input [511 : 0] block2,
                         input [255 : 0] expected2);

     reg [255 : 0] db_digest1;
     reg [255 : 0] db_digest2;
     reg           db_error;
   begin
     $display("*** TC %0d double block test case started.", tc_number);
     db_error = 0;
     tc_ctr = tc_ctr + 1;

     $display("*** TC %0d first block started.", tc_number);
     tb_block = block1;
     tb_init = 1;
     #(CLK_PERIOD);
     tb_init = 0;
     wait_ready();
     db_digest1 = tb_digest;
     $display("*** TC %0d first block done.", tc_number);

     $display("*** TC %0d second block started.", tc_number);
     tb_block = block2;
     tb_next = 1;
     #(CLK_PERIOD);
     tb_next = 0;
     wait_ready();
     db_digest2 = tb_digest;
     $display("*** TC %0d second block done.", tc_number);

     if (DEBUG)
       begin
         $display("Generated digests:");
         $display("Expected 1: 0x%064x", expected1);
         $display("Got      1: 0x%064x", db_digest1);
         $display("Expected 2: 0x%064x", expected2);
         $display("Got      2: 0x%064x", db_digest2);
         $display("");
       end

     if (db_digest1 == expected1)
       begin
         $display("*** TC %0d first block successful", tc_number);
         $display("");
       end
     else
       begin
         $display("*** ERROR: TC %0d first block NOT successful", tc_number);
         $display("Expected: 0x%064x", expected1);
         $display("Got:      0x%064x", db_digest1);
         $display("");
         db_error = 1;
       end

     if (db_digest2 == expected2)
       begin
         $display("*** TC %0d second block successful", tc_number);
         $display("");
       end
     else
       begin
         $display("*** ERROR: TC %0d second block NOT successful", tc_number);
         $display("Expected: 0x%064x", expected2);
         $display("Got:      0x%064x", db_digest2);
         $display("");
         db_error = 1;
       end

     if (db_error)
       begin
         error_ctr = error_ctr + 1;
       end
   end
  endtask // double_block_test


  //----------------------------------------------------------------
  // issue_test()
  //----------------------------------------------------------------
  task issue_test;
    reg [511 : 0] block0;
    reg [511 : 0] block1;
    reg [511 : 0] block2;
    reg [511 : 0] block3;
    reg [511 : 0] block4;
    reg [511 : 0] block5;
    reg [511 : 0] block6;
    reg [511 : 0] block7;
    reg [511 : 0] block8;
    reg [255 : 0] expected;
    begin : issue_test;
      block0 = 512'h6b900001_496e2074_68652061_72656120_6f662049_6f542028_496e7465_726e6574_206f6620_5468696e_6773292c_206d6f72_6520616e_64206d6f_7265626f_6f6d2c20;
      block1 = 512'h69742068_61732062_65656e20_6120756e_69766572_73616c20_636f6e73_656e7375_73207468_61742064_61746120_69732074_69732061_206e6577_20746563_686e6f6c;
      block2 = 512'h6f677920_74686174_20696e74_65677261_74657320_64656365_6e747261_6c697a61_74696f6e_2c496e20_74686520_61726561_206f6620_496f5420_28496e74_65726e65;
      block3 = 512'h74206f66_20546869_6e677329_2c206d6f_72652061_6e64206d_6f726562_6f6f6d2c_20697420_68617320_6265656e_20612075_6e697665_7273616c_20636f6e_73656e73;
      block4 = 512'h75732074_68617420_64617461_20697320_74697320_61206e65_77207465_63686e6f_6c6f6779_20746861_7420696e_74656772_61746573_20646563_656e7472_616c697a;
      block5 = 512'h6174696f_6e2c496e_20746865_20617265_61206f66_20496f54_2028496e_7465726e_6574206f_66205468_696e6773_292c206d_6f726520_616e6420_6d6f7265_626f6f6d;
      block6 = 512'h2c206974_20686173_20626565_6e206120_756e6976_65727361_6c20636f_6e73656e_73757320_74686174_20646174_61206973_20746973_2061206e_65772074_6563686e;
      block7 = 512'h6f6c6f67_79207468_61742069_6e746567_72617465_73206465_63656e74_72616c69_7a617469_6f6e2c49_6e207468_65206172_6561206f_6620496f_54202849_6e746572;
      block8 = 512'h6e657420_6f662054_68696e67_73292c20_6d6f7265_20616e64_206d6f72_65800000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_000010e8;

      expected = 256'h7758a30bbdfc9cd92b284b05e9be9ca3d269d3d149e7e82ab4a9ed5e81fbcf9d;

      $display("Running test for 9 block issue.");
      tc_ctr = tc_ctr + 1;
      tb_block = block0;
      tb_init = 1;
      #(CLK_PERIOD);
      tb_init = 0;
      wait_ready();

      tb_block = block1;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block2;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block3;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block4;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block5;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block6;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block7;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      tb_block = block8;
      tb_next = 1;
      #(CLK_PERIOD);
      tb_next = 0;
      wait_ready();

      if (tb_digest == expected)
        begin
          $display("Digest ok.");
        end
      else
        begin
          error_ctr = error_ctr + 1;
          $display("Error! Got:      0x%064x", tb_digest);
          $display("Error! Expected: 0x%064x", expected);
        end
    end
  endtask // issue_test


  //----------------------------------------------------------------
  // sha256_core_test
  // Test cases taken from:
  // http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA256.pdf
  //----------------------------------------------------------------
  task sha256_core_test;
    reg [511 : 0] tc1;
    reg [255 : 0] res1;
    reg [511 : 0] tc2_1;
    reg [255 : 0] res2_1;
    reg [511 : 0] tc2_2;
    reg [255 : 0] res2_2;
    begin : sha256_core_test
      // TC1: Single block message: "abc".
      tc1 = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
      res1 = 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD;
      //single_block_test(1, tc1, res1);

      // TC2: Double block message.
      // "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      tc2_1 = 512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000;
      res2_1 = 256'h85E655D6417A17953363376A624CDE5C76E09589CAC5F811CC4B32C1F20E533A;

      tc2_2 = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0;
      res2_2 = 256'h248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1;
      //double_block_test(2, tc2_1, res2_1, tc2_2, res2_2);
      single_block_test(1, tc1, res1);
      //issue_test();
    end
  endtask // sha256_core_test


  //----------------------------------------------------------------
  // main()
  //----------------------------------------------------------------
  initial
    begin : main
      $display("   -- Testbench for sha256_axi4 started --");

      init_sim();
      //dump_dut_state();
      reset_dut();
      //dump_dut_state();

      sha256_core_test();
      //issue_test();

      display_test_result();
      $display("*** Simulation done.");
      $finish;
    end // main
endmodule // tb_sha256_axi4

//======================================================================
// EOF tb_sha256_axi4.v
//======================================================================

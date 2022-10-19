/* 
 * Copyright 2020 <+YOU OR YOUR COMPANY+>.
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

`timescale 1ns/1ps
`define NS_PER_TICK 1
`define NUM_TEST_CASES 5

`include "sim_exec_report.vh"
`include "sim_clks_rsts.vh"
`include "sim_rfnoc_lib.svh"

module noc_block_lorapackdetect_tb();
  `TEST_BENCH_INIT("noc_block_lorapackdetect",`NUM_TEST_CASES,`NS_PER_TICK);
  localparam BUS_CLK_PERIOD = $ceil(1e9/166.67e6);
  localparam CE_CLK_PERIOD  = $ceil(1e9/200e6);
  localparam NUM_CE         = 1;  // Number of Computation Engines / User RFNoC blocks to simulate
  localparam NUM_STREAMS    = 2;  // Number of test bench streams
  `RFNOC_SIM_INIT(NUM_CE, NUM_STREAMS, BUS_CLK_PERIOD, CE_CLK_PERIOD);
  `RFNOC_ADD_BLOCK(noc_block_lorapackdetect, 0);
  `RFNOC_ADD_BLOCK(noc_block_lorabusytone,2);

  localparam SPP = 256; // Samples per packet
  localparam NSAMP = 2048; // Total Number of samples to read

  /********************************************************
  ** Verification
  ********************************************************/
  initial begin : tb_main
    string s;
    logic [31:0] random_word;
    logic [63:0] readback;

    // For File handling
    integer data_in_file,data_out_file,scan_file;
    logic [15:0] real_p,imag_p;

    /********************************************************
    ** Test 1 -- Reset
    ********************************************************/
    `TEST_CASE_START("Wait for Reset");
    while (bus_rst) @(posedge bus_clk);
    while (ce_rst) @(posedge ce_clk);
    `TEST_CASE_DONE(~bus_rst & ~ce_rst);

    /********************************************************
    ** Test 2 -- Check for correct NoC IDs
    ********************************************************/
    `TEST_CASE_START("Check NoC ID");
    // Read NOC IDs
    tb_streamer.read_reg(sid_noc_block_lorapackdetect, RB_NOC_ID, readback);
    $display("Read lorapackdetect NOC ID: %16x", readback);
    `ASSERT_ERROR(readback == noc_block_lorapackdetect.NOC_ID, "Incorrect NOC ID");
    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 3 -- Connect RFNoC blocks
    ********************************************************/
    `TEST_CASE_START("Connect RFNoC blocks");
    `RFNOC_CONNECT(noc_block_tb,noc_block_lorapackdetect,SC16,SPP);
    `RFNOC_CONNECT(noc_block_lorapackdetect,noc_block_tb,SC16,SPP);

    // `RFNOC_CONNECT(noc_block_tb,noc_block_lorapackdetect,SC16,SPP);
    // `RFNOC_CONNECT(noc_block_lorapackdetect,noc_block_lorabusytone,SC16,SPP);
    // `RFNOC_CONNECT(noc_block_lorabusytone,noc_block_tb,SC16,SPP);

    // Connect the Busytone Block as well
    // `RFNOC_CONNECT(noc_block_tb,noc_block_lorabusytone,SC16,SPP);
    // `RFNOC_CONNECT(noc_block_lorabusytone,noc_block_tb,SC16,SPP);
    `RFNOC_CONNECT_BLOCK_PORT(noc_block_tb,1,noc_block_lorabusytone,0,SC16,SPP);
    `RFNOC_CONNECT_BLOCK_PORT(noc_block_lorabusytone,0,noc_block_tb,1,SC16,SPP);

    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 4 -- Write / readback user registers
    ********************************************************/
    `TEST_CASE_START("Write / readback user registers");
    random_word = $random();
    tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_0, random_word);
    tb_streamer.read_user_reg(sid_noc_block_lorapackdetect, 0, readback);
    $sformat(s, "User register 0 incorrect readback! Expected: %0d, Actual %0d", readback[31:0], random_word);
    `ASSERT_ERROR(readback[31:0] == random_word, s);
    random_word = $random();
    tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_1, random_word);
    tb_streamer.read_user_reg(sid_noc_block_lorapackdetect, 1, readback);
    $sformat(s, "User register 1 incorrect readback! Expected: %0d, Actual %0d", readback[31:0], random_word);
    `ASSERT_ERROR(readback[31:0] == random_word, s);
    random_word = $random();
    tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_2, random_word);
    tb_streamer.read_user_reg(sid_noc_block_lorapackdetect, 2, readback);
    $sformat(s, "User register 2 incorrect readback! Expected: %0d, Actual %0d", readback[31:0], random_word);
    `ASSERT_ERROR(readback[31:0] == random_word, s);

    // Check Busytone Regs
    random_word = 32'b0;
    tb_streamer.read_user_reg(sid_noc_block_lorabusytone, 3, readback);
    begin
      $display ("Reg3: %0h",readback[31:0]);
      $display ("SID BTONE: %0h",sid_noc_block_lorabusytone);
      $display ("SID PACKDET: %0h",sid_noc_block_lorapackdetect);
      // $display
    end
    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 5 -- Test sequence PackDet
    ********************************************************/
    `TEST_CASE_START("Test sequence PackDet");
    tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_0, 32'b1);
    tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_1, 32'b10000000001111100000000);
    // tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_2, 32'd2097282);
    tb_streamer.write_user_reg(sid_noc_block_lorapackdetect, noc_block_lorapackdetect.SR_TEST_REG_2, 32'd2097292);
    

    // tb_streamer.write_user_reg(sid_noc_block_lorabusytone, noc_block_lorabusytone.SR_TEST_REG_2, 32'd5);
    // Read from file: /home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_in0.csv
    // Write to file: /home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_out0.csv
    data_in_file = $fopen("/home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_in0.csv", "r");
    data_out_file = $fopen("/home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_out0.csv", "w");
    if (data_in_file == 0)
    begin
        $display("Input data/config handle was NULL");
        $finish;
    end
    if (data_out_file == 0)
    begin
        $display("Output file handle was NULL");
        $finish;
    end

    // scan_file = $fscanf(data_in_file,"%x,%x,%x,%x,%x,\n",data_in,data_in_valid,data_in_keep,data_in_user,data_in_last);
    //$fwrite(data_out_file, "%x,%x,%x,%x,%x,\n", rdata_out,rdata_out_valid,rdata_out_keep,rdata_out_tuser,rdata_out_last);
    scan_file = $fscanf(data_in_file,"%s\n",s); // Get the headings
    $fwrite(data_out_file, "%s\n", s); //Write the headings

    fork
      begin
        int n_samp_sent = 0;
        for (n_samp_sent = 0; n_samp_sent < NSAMP/(SPP); n_samp_sent++) begin
            for (int i = 0; i < (SPP-1); i++) begin
              scan_file = $fscanf(data_in_file,"%d,%d\n",real_p,imag_p);
              tb_streamer.push_word({real_p,imag_p},1'b0,0);
            end
            scan_file = $fscanf(data_in_file,"%d,%d\n",real_p,imag_p);
            tb_streamer.push_word({real_p,imag_p},1'b1,0);
        end

      end

      begin
        logic [31:0] expected_value;
        logic [31:0] recv_payload;
        logic eop_out;
        for (int n_samp_rx = 0; n_samp_rx < NSAMP; n_samp_rx++) begin
          tb_streamer.pull_word(recv_payload,eop_out,0);
          $fwrite(data_out_file, "%d,%d\n", recv_payload[31:16],recv_payload[15:0]);
          // begin
            // $display("Sample %d\n",n_samp_rx);
          // end
        end

      begin
      logic [63:0] cmd_responsea;
      // tb_streamer.push_cmd(16'h20,{24'd0,8'd130,32'd9},cmd_responsea);
      end

    $fclose(data_in_file);
    $fclose(data_out_file);

      end
    join
    `TEST_CASE_DONE(1);

    /********************************************************
    ** Test 6 -- Test sequence Busytone
    ********************************************************/
    `TEST_CASE_START("Test sequence Busytone");
    tb_streamer.write_user_reg(sid_noc_block_lorabusytone, noc_block_lorabusytone.SR_TEST_REG_0, 32'h0001);
    tb_streamer.write_user_reg(sid_noc_block_lorabusytone, noc_block_lorabusytone.SR_TEST_REG_1, 32'h1);
    tb_streamer.write_user_reg(sid_noc_block_lorabusytone, noc_block_lorabusytone.SR_TEST_REG_2, 32'd1);

    begin
      logic [63:0] readback_rega;
      tb_streamer.read_user_reg(16'h20,2,readback_rega);
      $display("After PackDet, the Busytone Trig Is: %d",readback_rega);
    end

    // Read from file: /home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_in0.csv
    // Write to file: /home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_out0.csv
    data_in_file = $fopen("/home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_pack_detect_in0.csv", "r");
    data_out_file = $fopen("/home/rsubbaraman/gitrepos/fdr_lpwan/hls_ip/sim_data/verilog_busytone_out0.csv", "w");
    if (data_in_file == 0)
    begin
        $display("Input data/config handle was NULL");
        $finish;
    end
    if (data_out_file == 0)
    begin
        $display("Output file handle was NULL");
        $finish;
    end

    // scan_file = $fscanf(data_in_file,"%x,%x,%x,%x,%x,\n",data_in,data_in_valid,data_in_keep,data_in_user,data_in_last);
    //$fwrite(data_out_file, "%x,%x,%x,%x,%x,\n", rdata_out,rdata_out_valid,rdata_out_keep,rdata_out_tuser,rdata_out_last);
    scan_file = $fscanf(data_in_file,"%s\n",s); // Get the headings
    $fwrite(data_out_file, "%s\n", s); //Write the headings

    fork
      begin
        int n_samp_sent = 0;
        for (n_samp_sent = 0; n_samp_sent < NSAMP/(SPP); n_samp_sent++) begin
            for (int i = 0; i < (SPP-1); i++) begin
              scan_file = $fscanf(data_in_file,"%d,%d\n",real_p,imag_p);
              tb_streamer.push_word({real_p,imag_p},1'b0,1);
            end
            scan_file = $fscanf(data_in_file,"%d,%d\n",real_p,imag_p);
            tb_streamer.push_word({real_p,imag_p},1'b1,1);
        end

      end

      begin
        logic [31:0] expected_value;
        logic [31:0] recv_payload;
        logic eop_out;
        for (int n_samp_rx = 0; n_samp_rx < NSAMP; n_samp_rx++) begin
          tb_streamer.pull_word(recv_payload,eop_out,1);
          $fwrite(data_out_file, "%d,%d\n", recv_payload[31:16],recv_payload[15:0]);
          // begin
            // $display("Sample %d\n",n_samp_rx);
          // end
        end

    $fclose(data_in_file);
    $fclose(data_out_file);

      end
    join
    `TEST_CASE_DONE(1);

    `TEST_BENCH_DONE;

  end
endmodule

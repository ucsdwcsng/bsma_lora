
//
/* 
 * Copyright 2020 UC San Diego.
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

//
module noc_block_lorapackdetect #(
  parameter NOC_ID = 64'hDD96C54210E31F70,
  parameter STR_SINK_FIFOSIZE = 11)
(
  input bus_clk, input bus_rst,
  input ce_clk, input ce_rst,
  input  [63:0] i_tdata, input  i_tlast, input  i_tvalid, output i_tready,
  output [63:0] o_tdata, output o_tlast, output o_tvalid, input  o_tready,
  output [63:0] debug
);

  ////////////////////////////////////////////////////////////
  //
  // RFNoC Shell
  //
  ////////////////////////////////////////////////////////////
  wire [31:0] set_data;
  wire [7:0]  set_addr;
  wire        set_stb;
  reg  [63:0] rb_data;
  wire [7:0]  rb_addr;

  wire [63:0] cmdout_tdata, ackin_tdata;
  wire        cmdout_tlast, cmdout_tvalid, cmdout_tready, ackin_tlast, ackin_tvalid, ackin_tready;

  wire [63:0] str_sink_tdata, str_src_tdata;
  wire        str_sink_tlast, str_sink_tvalid, str_sink_tready, str_src_tlast, str_src_tvalid, str_src_tready;

  wire [15:0] src_sid;
  wire [15:0] next_dst_sid, resp_out_dst_sid;
  wire [15:0] resp_in_dst_sid;

  wire        clear_tx_seqnum;

  noc_shell #(
    .NOC_ID(NOC_ID),
    .STR_SINK_FIFOSIZE(STR_SINK_FIFOSIZE))
  noc_shell (
    .bus_clk(bus_clk), .bus_rst(bus_rst),
    .i_tdata(i_tdata), .i_tlast(i_tlast), .i_tvalid(i_tvalid), .i_tready(i_tready),
    .o_tdata(o_tdata), .o_tlast(o_tlast), .o_tvalid(o_tvalid), .o_tready(o_tready),
    // Computer Engine Clock Domain
    .clk(ce_clk), .reset(ce_rst),
    // Control Sink
    .set_data(set_data), .set_addr(set_addr), .set_stb(set_stb), .set_time(), .set_has_time(),
    .rb_stb(1'b1), .rb_data(rb_data), .rb_addr(rb_addr),
    // Control Source
    .cmdout_tdata(cmdout_tdata), .cmdout_tlast(cmdout_tlast), .cmdout_tvalid(cmdout_tvalid), .cmdout_tready(cmdout_tready),
    .ackin_tdata(ackin_tdata), .ackin_tlast(ackin_tlast), .ackin_tvalid(ackin_tvalid), .ackin_tready(ackin_tready),
    // Stream Sink
    .str_sink_tdata(str_sink_tdata), .str_sink_tlast(str_sink_tlast), .str_sink_tvalid(str_sink_tvalid), .str_sink_tready(str_sink_tready),
    // Stream Source
    .str_src_tdata(str_src_tdata), .str_src_tlast(str_src_tlast), .str_src_tvalid(str_src_tvalid), .str_src_tready(str_src_tready),
    // Stream IDs set by host
    .src_sid(src_sid),                   // SID of this block
    .next_dst_sid(next_dst_sid),         // Next destination SID
    .resp_in_dst_sid(resp_in_dst_sid),   // Response destination SID for input stream responses / errors
    .resp_out_dst_sid(resp_out_dst_sid), // Response destination SID for output stream responses / errors
    // Misc
    .vita_time('d0), .clear_tx_seqnum(clear_tx_seqnum),
    .debug(debug));

  ////////////////////////////////////////////////////////////
  //
  // AXI Wrapper
  // Convert RFNoC Shell interface into AXI stream interface
  //
  ////////////////////////////////////////////////////////////
  wire [31:0] m_axis_data_tdata;
  wire        m_axis_data_tlast;
  wire        m_axis_data_tvalid;
  wire        m_axis_data_tready;

  wire [31:0] s_axis_data_tdata;
  wire        s_axis_data_tlast;
  wire        s_axis_data_tvalid;
  wire        s_axis_data_tready;

  axi_wrapper #(
    .SIMPLE_MODE(1))
  axi_wrapper (
    .clk(ce_clk), .reset(ce_rst),
    .bus_clk(bus_clk), .bus_rst(bus_rst),
    .clear_tx_seqnum(clear_tx_seqnum),
    .next_dst(next_dst_sid),
    .set_stb(set_stb), .set_addr(set_addr), .set_data(set_data),
    .i_tdata(str_sink_tdata), .i_tlast(str_sink_tlast), .i_tvalid(str_sink_tvalid), .i_tready(str_sink_tready),
    .o_tdata(str_src_tdata), .o_tlast(str_src_tlast), .o_tvalid(str_src_tvalid), .o_tready(str_src_tready),
    .m_axis_data_tdata(m_axis_data_tdata),
    .m_axis_data_tlast(m_axis_data_tlast),
    .m_axis_data_tvalid(m_axis_data_tvalid),
    .m_axis_data_tready(m_axis_data_tready),
    .m_axis_data_tuser(),
    .s_axis_data_tdata(s_axis_data_tdata),
    .s_axis_data_tlast(s_axis_data_tlast),
    .s_axis_data_tvalid(s_axis_data_tvalid),
    .s_axis_data_tready(s_axis_data_tready),
    .s_axis_data_tuser(),
    .m_axis_config_tdata(),
    .m_axis_config_tlast(),
    .m_axis_config_tvalid(),
    .m_axis_config_tready(),
    .m_axis_pkt_len_tdata(),
    .m_axis_pkt_len_tvalid(),
    .m_axis_pkt_len_tready());

  ////////////////////////////////////////////////////////////
  //
  // User code
  //
  ////////////////////////////////////////////////////////////
  // NoC Shell registers 0 - 127,
  // User register address space starts at 128
  localparam SR_USER_REG_BASE = 128;

  // Control Source Used by bustyone_trig_1
  // assign cmdout_tdata  = 64'd0;
  // assign cmdout_tlast  = 1'b0;
  // assign cmdout_tvalid = 1'b0;
  assign ackin_tready  = 1'b1;

  // Settings registers
  //
  // - The settings register bus is a simple strobed interface.
  // - Transactions include both a write and a readback.
  // - The write occurs when set_stb is asserted.
  //   The settings register with the address matching set_addr will
  //   be loaded with the data on set_data.
  // - Readback occurs when rb_stb is asserted. The read back strobe
  //   must assert at least one clock cycle after set_stb asserts /
  //   rb_stb is ignored if asserted on the same clock cycle of set_stb.
  //   Example valid and invalid timing:
  //              __    __    __    __
  //   clk     __|  |__|  |__|  |__|  |__
  //               _____
  //   set_stb ___|     |________________
  //                     _____
  //   rb_stb  _________|     |__________     (Valid)
  //                           _____
  //   rb_stb  _______________|     |____     (Valid)
  //           __________________________
  //   rb_stb                                 (Valid if readback data is a constant)
  //               _____
  //   rb_stb  ___|     |________________     (Invalid / ignored, same cycle as set_stb)
  //
  localparam [7:0] SR_TEST_REG_0 = SR_USER_REG_BASE;
  localparam [7:0] SR_TEST_REG_1 = SR_USER_REG_BASE + 8'd1;
  localparam [7:0] SR_TEST_REG_2 = SR_USER_REG_BASE + 8'd2;
  localparam [7:0] SR_TEST_REG_3 = SR_USER_REG_BASE + 8'd3;

  wire [31:0] ener_thresh;
  setting_reg #(
    .my_addr(SR_TEST_REG_0), .awidth(8), .width(32))
  sr_test_reg_0 (
    .clk(ce_clk), .rst(ce_rst),
    .strobe(set_stb), .addr(set_addr), .in(set_data), .out(ener_thresh), .changed());

  wire [31:0] test_reg_1;
  setting_reg #(
    .my_addr(SR_TEST_REG_1), .awidth(8), .width(32))
  sr_test_reg_1 (
    .clk(ce_clk), .rst(ce_rst),
    .strobe(set_stb), .addr(set_addr), .in(set_data), .out(test_reg_1), .changed());

  wire [31:0] test_reg_2;
  setting_reg #(
    .my_addr(SR_TEST_REG_2), .awidth(8), .width(32))
  sr_test_reg_2 (
    .clk(ce_clk), .rst(ce_rst),
    .strobe(set_stb), .addr(set_addr), .in(set_data), .out(test_reg_2), .changed());

  wire [31:0] test_reg_3;
  setting_reg #(
    .my_addr(SR_TEST_REG_3), .awidth(8), .width(32))
  sr_test_reg_3 (
    .clk(ce_clk), .rst(ce_rst),
    .strobe(set_stb), .addr(set_addr), .in(set_data), .out(test_reg_3), .changed());

  // Readback registers
  // rb_stb set to 1'b1 on NoC Shell
  always @(posedge ce_clk) begin
    case(rb_addr)
      8'd0 : rb_data <= {32'd0, ener_thresh};
      8'd1 : rb_data <= {32'd0, test_reg_1};
      8'd2 : rb_data <= {32'd0, test_reg_2};
      8'd3 : rb_data <= {32'd0, test_reg_3};
      default : rb_data <= 64'h0BADC0DE0BADC0DE;
    endcase
  end

  // Debug
  // always @* begin
  //  $display("m_valid %b, m_ready %b",m_axis_data_tvalid,m_axis_data_tready);
  //  $display("s_valid %b, s_ready %b",s_axis_data_tvalid,s_axis_data_tready);
  //  $display("s_data %b, m_data %b",s_axis_data_tdata,m_axis_data_tdata);
  // end

  wire  rst_n;
  assign rst_n = ~ce_rst;

  wire [31:0] split_axis_data_tdata;
  wire        split_axis_data_tvalid;
  wire        split_axis_data_tready;
  wire        split_axis_data_tlast;

  wire [31:0] meso_axis_data_tdata;
  wire        meso_axis_data_tlast;
  wire        meso_axis_data_tvalid;
  wire        meso_axis_data_tready;

  axis_copy_stream axis_copy_stream_0 (
        .ap_clk(ce_clk),
        .ap_rst_n(rst_n),
        .data_in_TDATA(meso_axis_data_tdata),
        .data_in_TVALID(meso_axis_data_tvalid),
        .data_in_TREADY(meso_axis_data_tready),
        .data_in_TLAST(meso_axis_data_tlast),
        .data_out1_TDATA(s_axis_data_tdata),
        .data_out1_TVALID(s_axis_data_tvalid),
        .data_out1_TREADY(s_axis_data_tready),
        .data_out1_TLAST(s_axis_data_tlast),
        .data_out2_TDATA(split_axis_data_tdata),
        .data_out2_TVALID(split_axis_data_tvalid),
        .data_out2_TREADY(split_axis_data_tready),
        .data_out2_TLAST(split_axis_data_tlast));

  packet_det packet_det_0(
        .ap_clk(ce_clk),
        .ap_rst_n(rst_n),
        .data_in_TDATA(m_axis_data_tdata),
        .data_in_TVALID(m_axis_data_tvalid),
        .data_in_TREADY(m_axis_data_tready),
        .data_in_TLAST(m_axis_data_tlast),
        .data_out_TDATA(meso_axis_data_tdata),
        .data_out_TVALID(meso_axis_data_tvalid),
        .data_out_TREADY(meso_axis_data_tready),
        .data_out_TLAST(meso_axis_data_tlast),
        .power_threshold_in_V(ener_thresh));

  wire [15:0] input_src_sid;
  assign input_src_sid = src_sid;

  busytone_trig busytone_trig_1 (
        .ap_clk(ce_clk),
        .ap_rst_n(rst_n),
        .data_in_TDATA(split_axis_data_tdata),
        .data_in_TVALID(split_axis_data_tvalid),
        .data_in_TREADY(split_axis_data_tready),
        .data_in_TLAST(split_axis_data_tlast),
        .data_out_TDATA(cmdout_tdata),
        .data_out_TVALID(cmdout_tvalid),
        .data_out_TREADY(cmdout_tready),
        .data_out_TLAST(cmdout_tlast),
        .param1_V(test_reg_1),
        .param2_V(test_reg_2),
        .src_sid_V(input_src_sid));

endmodule

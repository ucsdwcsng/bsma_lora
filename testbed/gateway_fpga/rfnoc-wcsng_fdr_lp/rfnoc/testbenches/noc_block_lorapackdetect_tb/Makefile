

# 
# Copyright 2020 <+YOU OR YOUR COMPANY+>.
# 
# This is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this software; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
# 

#-------------------------------------------------
# Top-of-Makefile
#-------------------------------------------------
# Define BASE_DIR to point to the "top" dir
BASE_DIR = $(FPGA_TOP_DIR)/usrp3/top
# Include viv_sim_preample after defining BASE_DIR
include $(BASE_DIR)/../tools/make/viv_sim_preamble.mak

#-------------------------------------------------
# Testbench Specific
#-------------------------------------------------
# Define only one toplevel module
SIM_TOP = noc_block_lorapackdetect_tb

# Add test bench, user design under test, and
# additional user created files
SIM_SRCS = \
$(abspath noc_block_lorapackdetect_tb.sv) \
$(abspath ../../fpga-src/noc_block_lorapackdetect.v) \
$(abspath ../../fpga-src/noc_block_lorabusytone.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_preamble_vec_M_imag.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_preamble_vec_M_imag_rom.dat) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_preamble_vec_M_real.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_preamble_vec_M_real_rom.dat) \
$(abspath ../../fpga-src/busytone_tx_src/null_sink.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_level_buf_V.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_level_buf_V_ram.dat) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mac_muladd_16s_16s_32s_32_1_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_31s_31s_62_3_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_31s_32s_61_3_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_32s_31s_61_3_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_34ns_44s_77_5_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_35ns_44s_78_5_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_44s_32ns_76_5_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_mul_mul_16s_16s_32_1_1.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_prev_buffer_M_real_s.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_prev_buffer_M_real_s_ram.dat) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_thresh_vec.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_thresh_vec_rom.dat) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_ToSubE_vec_V.v) \
$(abspath ../../fpga-src/packet_detect_src/packet_det_ToSubE_vec_V_ram.dat) \
$(abspath ../../fpga-src/busytone_trig_src/ratio_counter.v) \
$(abspath ../../fpga-src/busytone_trig_src/busytone_trig.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_wlan_preamble_vec_M.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_wlan_preamble_vec_M_1.v) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_wlan_preamble_vec_M_1_rom.dat) \
$(abspath ../../fpga-src/busytone_tx_src/busytone_tx_wlan_preamble_vec_M_rom.dat) \
$(abspath ../../fpga-src/packet_detect_src/axis_copy_stream.v) 

MODELSIM_USER_DO =

#-------------------------------------------------
# Bottom-of-Makefile
#-------------------------------------------------
# Include all simulator specific makefiles here
# Each should define a unique target to simulate
# e.g. xsim, vsim, etc and a common "clean" target
include $(BASE_DIR)/../tools/make/viv_simulator.mak

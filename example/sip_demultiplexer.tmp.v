// Copyright (c) 2022 Princeton University
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



module sip_demultiplexer_0 (
  input clk,
  input rst_n,

  output [63:0] noc0_Pout_data,
  output noc0_Pout_valid,
  input noc0_Pout_ready,
  output [63:0] noc1_Pout_data,
  output noc1_Pout_valid,
  input noc1_Pout_ready,
  output [63:0] noc2_Pout_data,
  output noc2_Pout_valid,
  input noc2_Pout_ready,
  input [63:0] nop0_Pout_vr_data,
  input nop0_Pout_vr_valid,
  output nop0_Pout_vr_ready
);



noc_fbits_splitter noc_fbits_splitter(
  .clk(clk),
  .rst_n(rst_n),
  .num_targets(3),
  .splitter_dst0_vr_noc_dat(noc0_Pout_data),
  .splitter_dst0_vr_noc_val(noc0_Pout_valid),
  .splitter_dst0_vr_noc_rdy(noc0_Pout_ready),
  .fbits_type0(),
  .splitter_dst1_vr_noc_dat(noc1_Pout_data),
  .splitter_dst1_vr_noc_val(noc1_Pout_valid),
  .splitter_dst1_vr_noc_rdy(noc1_Pout_ready),
  .fbits_type1(),
  .splitter_dst2_vr_noc_dat(noc2_Pout_data),
  .splitter_dst2_vr_noc_val(noc2_Pout_valid),
  .splitter_dst2_vr_noc_rdy(noc2_Pout_ready),
  .fbits_type2(),
  .src_splitter_vr_noc_dat(nop2_Pout_vr_data),
  .src_splitter_vr_noc_val(nop2_Pout_vr_valid),
  .src_splitter_vr_noc_rdy(nop2_Pout_vr_ready)
);
endmodule
  


module sip_demultiplexer_1 (
  input clk,
  input rst_n,

  output [63:0] noc3_Pout_data,
  output noc3_Pout_valid,
  input noc3_Pout_ready,
  output [63:0] noc4_Pout_data,
  output noc4_Pout_valid,
  input noc4_Pout_ready,
  input [63:0] nop1_Pout_vr_data,
  input nop1_Pout_vr_valid,
  output nop1_Pout_vr_ready
);



noc_fbits_splitter noc_fbits_splitter(
  .clk(clk),
  .rst_n(rst_n),
  .num_targets(2),
  .splitter_dst3_vr_noc_dat(noc3_Pout_data),
  .splitter_dst3_vr_noc_val(noc3_Pout_valid),
  .splitter_dst3_vr_noc_rdy(noc3_Pout_ready),
  .fbits_type3(),
  .splitter_dst4_vr_noc_dat(noc4_Pout_data),
  .splitter_dst4_vr_noc_val(noc4_Pout_valid),
  .splitter_dst4_vr_noc_rdy(noc4_Pout_ready),
  .fbits_type4(),
  .src_splitter_vr_noc_dat(nop4_Pout_vr_data),
  .src_splitter_vr_noc_val(nop4_Pout_vr_valid),
  .src_splitter_vr_noc_rdy(nop4_Pout_vr_ready)
);
endmodule
  



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



module sip_multiplexer_0 (
  input clk,
  input rst_n,

  input [63:0] noc0_Pin_data,
  input noc0_Pin_valid,
  output noc0_Pin_ready,
  input [63:0] noc1_Pin_data,
  input noc1_Pin_valid,
  output noc1_Pin_ready,
  input [63:0] noc2_Pin_data,
  input noc2_Pin_valid,
  output noc2_Pin_ready,
  output [63:0] nop0_Pin_vr_data,
  output nop0_Pin_vr_valid,
  input nop0_Pin_vr_ready
);



noc_prio_merger noc_prio_merger(
  .clk(clk),
  .rst_n(rst_n),
  .num_sources(3),
  .src0_merger_vr_noc_dat(noc0_Pin_data),
  .src0_merger_vr_noc_val(noc0_Pin_valid),
  .src0_merger_vr_noc_rdy(noc0_Pin_ready),
  .src1_merger_vr_noc_dat(noc1_Pin_data),
  .src1_merger_vr_noc_val(noc1_Pin_valid),
  .src1_merger_vr_noc_rdy(noc1_Pin_ready),
  .src2_merger_vr_noc_dat(noc2_Pin_data),
  .src2_merger_vr_noc_val(noc2_Pin_valid),
  .src2_merger_vr_noc_rdy(noc2_Pin_ready),
  .merger_dst_vr_noc_dat(nop2_Pin_vr_data),
  .merger_dst_vr_noc_val(nop2_Pin_vr_valid),
  .merger_dst_vr_noc_rdy(nop2_Pin_vr_ready)
);
endmodule
  


module sip_multiplexer_1 (
  input clk,
  input rst_n,

  input [63:0] noc3_Pin_data,
  input noc3_Pin_valid,
  output noc3_Pin_ready,
  input [63:0] noc4_Pin_data,
  input noc4_Pin_valid,
  output noc4_Pin_ready,
  output [63:0] nop1_Pin_vr_data,
  output nop1_Pin_vr_valid,
  input nop1_Pin_vr_ready
);



noc_prio_merger noc_prio_merger(
  .clk(clk),
  .rst_n(rst_n),
  .num_sources(2),
  .src3_merger_vr_noc_dat(noc3_Pin_data),
  .src3_merger_vr_noc_val(noc3_Pin_valid),
  .src3_merger_vr_noc_rdy(noc3_Pin_ready),
  .src4_merger_vr_noc_dat(noc4_Pin_data),
  .src4_merger_vr_noc_val(noc4_Pin_valid),
  .src4_merger_vr_noc_rdy(noc4_Pin_ready),
  .merger_dst_vr_noc_dat(nop4_Pin_vr_data),
  .merger_dst_vr_noc_val(nop4_Pin_vr_valid),
  .merger_dst_vr_noc_rdy(nop4_Pin_vr_ready)
);
endmodule
  



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




module sip_interconnect(
    input clk, 
    input rst_n, 
    input [:0] config_chipid_x, 
    input [:0] config_chipid_y,

    input nop0_Sin_data[63:0],
    input nop0_Sin_valid,
    output nop0_Sin_credit, 
    output nop0_Sout_data[63:0],
    output nop0_Sout_valid,
    input nop0_Sout_credit,
    input nop0_Ein_data[63:0],
    input nop0_Ein_valid,
    output nop0_Ein_credit,
    output nop0_Eout_data[63:0],
    output nop0_Eout_valid,
    input nop0_Eout_credit,
    input nop0_Win_data[63:0],
    input nop0_Win_valid,
    output nop0_Win_credit,
    output nop0_Wout_data[63:0],
    output nop0_Wout_valid,
    input nop0_Wout_credit,
    input nop0_Nin_data[63:0],
    input nop0_Nin_valid,
    output nop0_Nin_credit,
    output nop0_Nout_data[63:0],
    output nop0_Nout_valid,
    input nop0_Nout_credit,
    input nop1_Sin_data[63:0],
    input nop1_Sin_valid,
    output nop1_Sin_credit, 
    output nop1_Sout_data[63:0],
    output nop1_Sout_valid,
    input nop1_Sout_credit,
    input nop1_Ein_data[63:0],
    input nop1_Ein_valid,
    output nop1_Ein_credit,
    output nop1_Eout_data[63:0],
    output nop1_Eout_valid,
    input nop1_Eout_credit,
    input nop1_Win_data[63:0],
    input nop1_Win_valid,
    output nop1_Win_credit,
    output nop1_Wout_data[63:0],
    output nop1_Wout_valid,
    input nop1_Wout_credit,
    input nop1_Nin_data[63:0],
    input nop1_Nin_valid,
    output nop1_Nin_credit,
    output nop1_Nout_data[63:0],
    output nop1_Nout_valid,
    input nop1_Nout_credit,
    input noc0_Pin_data[63:0],
    input noc0_Pin_valid,
    output noc0_Pin_credit, 
    output noc0_Pout_data[63:0],
    output noc0_Pout_valid,
    input noc0_Pout_credit,
    input noc1_Pin_data[63:0],
    input noc1_Pin_valid,
    output noc1_Pin_credit, 
    output noc1_Pout_data[63:0],
    output noc1_Pout_valid,
    input noc1_Pout_credit,
    input noc2_Pin_data[63:0],
    input noc2_Pin_valid,
    output noc2_Pin_credit, 
    output noc2_Pout_data[63:0],
    output noc2_Pout_valid,
    input noc2_Pout_credit,
    input noc3_Pin_data[63:0],
    input noc3_Pin_valid,
    output noc3_Pin_credit, 
    output noc3_Pout_data[63:0],
    output noc3_Pout_valid,
    input noc3_Pout_credit,
    input noc4_Pin_data[63:0],
    input noc4_Pin_valid,
    output noc4_Pin_credit, 
    output noc4_Pout_data[63:0],
    output noc4_Pout_valid,
    input noc4_Pout_credit

);

    wire nop0_Pin_vr_data[63:0];
    wire nop0_Pin_vr_valid;
    wire nop0_Pin_vr_ready;
    wire nop0_Pout_vr_data[63:0];
    wire nop0_Pout_vr_valid;
    wire nop0_Pout_vr_ready;
    wire nop1_Pin_vr_data[63:0];
    wire nop1_Pin_vr_valid;
    wire nop1_Pin_vr_ready;
    wire nop1_Pout_vr_data[63:0];
    wire nop1_Pout_vr_valid;
    wire nop1_Pout_vr_ready;


sip_multiplexer_0 sip_multiplexer_0 (
    .clk(clk),
    .rst_n(rst_n),
  
    .noc0_Pin_data(noc0_Pin_data),
    .noc0_Pin_valid(noc0_Pin_valid),
    .noc0_Pin_read(noc0_Pin_ready)
    .noc1_Pin_data(noc1_Pin_data),
    .noc1_Pin_valid(noc1_Pin_valid),
    .noc1_Pin_read(noc1_Pin_ready)
    .noc2_Pin_data(noc2_Pin_data),
    .noc2_Pin_valid(noc2_Pin_valid),
    .noc2_Pin_read(noc2_Pin_ready),
    .nop0_Pin_data(nop0_Pin_vr_data),
    .nop0_Pin_valid(nop0_Pin_vr_valid),
    .nop0_Pin_ready(nop0_Pin_vr_ready)
);

valrdy_to_credit noc0_v2c(
  .clk(clk),
  .reset(~rst_n),

  .data_in(nop0_Pin_vr_data),
  .valid_in(nop0_Pin_vr_valid),
  .ready_in(nop0_Pin_vr_ready),
  .data_out(nop0_Pin_data),
  .valid_out(nop0_Pin_valid),
  .yummy_out(nop0_Pin_credit),
);

sip_router sip_router_0 (
    .clk(clk),
    .rst_n(rst_n),
    .config_chipid_x(config_chipid_x),
    .config_chipid_y(config_chipid_y),
  
    .nop_Sin_data(nop0_Sin_data),
    .nop_Sin_valid(nop0_Sin_valid),
    .nop_Sin_credit(nop0_Sin_credit),
    .nop_Sout_data(nop0_Sout_data),
    .nop_Sout_valid(nop0_Sout_valid),
    .nop_Sout_credit(nop0_Sout_credit)
    .nop_Ein_data(nop0_Ein_data),
    .nop_Ein_valid(nop0_Ein_valid),
    .nop_Ein_credit(nop0_Ein_credit),
    .nop_Eout_data(nop0_Eout_data),
    .nop_Eout_valid(nop0_Eout_valid),
    .nop_Eout_credit(nop0_Eout_credit)
    .nop_Win_data(nop0_Win_data),
    .nop_Win_valid(nop0_Win_valid),
    .nop_Win_credit(nop0_Win_credit),
    .nop_Wout_data(nop0_Wout_data),
    .nop_Wout_valid(nop0_Wout_valid),
    .nop_Wout_credit(nop0_Wout_credit)
    .nop_Nin_data(nop0_Nin_data),
    .nop_Nin_valid(nop0_Nin_valid),
    .nop_Nin_credit(nop0_Nin_credit),
    .nop_Nout_data(nop0_Nout_data),
    .nop_Nout_valid(nop0_Nout_valid),
    .nop_Nout_credit(nop0_Nout_credit)
    .nop_Pin_data(nop0_Pin_data),
    .nop_Pin_valid(nop0_Pin_valid),
    .nop_Pin_credit(nop0_Pin_credit),
    .nop_Pout_data(nop0_Pout_data),
    .nop_Pout_valid(nop0_Pout_valid),
    .nop_Pout_credit(nop0_Pout_credit)
);

credit_to_valrdy noc0_c2v(
  .clk(clk),
  .reset(~rst_n),

  .data_in(nop0_Pout_data),
  .valid_in(nop0_Pout_valid),
  .yummy_in(nop0_Pout_credit),

  .data_out(nop0_Pout_vr_data),
  .valid_out(nop0_Pout_vr_valid),
  .ready_out(nop0_Pout_vr_ready),
);

sip_demultiplexer_0 sip_demultiplexer_0 (
    .clk(clk),
    .rst_n(rst_n),
  
    .noc0_Pout_data(noc0_Pout_data),
    .noc0_Pout_valid(noc0_Pout_valid),
    .noc0_Pout_ready(noc0_Pout_ready)
    .noc1_Pout_data(noc1_Pout_data),
    .noc1_Pout_valid(noc1_Pout_valid),
    .noc1_Pout_ready(noc1_Pout_ready)
    .noc2_Pout_data(noc2_Pout_data),
    .noc2_Pout_valid(noc2_Pout_valid),
    .noc2_Pout_ready(noc2_Pout_ready),
    .nop0_Pout_vr_data(nop0_Pout_vr_data),
    .nop0_Pout_vr_valid(nop0_Pout_vr_valid),
    .nop0_Pout_vr_ready(nop0_Pout_vr_ready)
);

sip_multiplexer_1 sip_multiplexer_1 (
    .clk(clk),
    .rst_n(rst_n),
  
    .noc3_Pin_data(noc3_Pin_data),
    .noc3_Pin_valid(noc3_Pin_valid),
    .noc3_Pin_read(noc3_Pin_ready)
    .noc4_Pin_data(noc4_Pin_data),
    .noc4_Pin_valid(noc4_Pin_valid),
    .noc4_Pin_read(noc4_Pin_ready),
    .nop1_Pin_data(nop1_Pin_vr_data),
    .nop1_Pin_valid(nop1_Pin_vr_valid),
    .nop1_Pin_ready(nop1_Pin_vr_ready)
);

valrdy_to_credit noc1_v2c(
  .clk(clk),
  .reset(~rst_n),

  .data_in(nop1_Pin_vr_data),
  .valid_in(nop1_Pin_vr_valid),
  .ready_in(nop1_Pin_vr_ready),
  .data_out(nop1_Pin_data),
  .valid_out(nop1_Pin_valid),
  .yummy_out(nop1_Pin_credit),
);

sip_router sip_router_1 (
    .clk(clk),
    .rst_n(rst_n),
    .config_chipid_x(config_chipid_x),
    .config_chipid_y(config_chipid_y),
  
    .nop_Sin_data(nop1_Sin_data),
    .nop_Sin_valid(nop1_Sin_valid),
    .nop_Sin_credit(nop1_Sin_credit),
    .nop_Sout_data(nop1_Sout_data),
    .nop_Sout_valid(nop1_Sout_valid),
    .nop_Sout_credit(nop1_Sout_credit)
    .nop_Ein_data(nop1_Ein_data),
    .nop_Ein_valid(nop1_Ein_valid),
    .nop_Ein_credit(nop1_Ein_credit),
    .nop_Eout_data(nop1_Eout_data),
    .nop_Eout_valid(nop1_Eout_valid),
    .nop_Eout_credit(nop1_Eout_credit)
    .nop_Win_data(nop1_Win_data),
    .nop_Win_valid(nop1_Win_valid),
    .nop_Win_credit(nop1_Win_credit),
    .nop_Wout_data(nop1_Wout_data),
    .nop_Wout_valid(nop1_Wout_valid),
    .nop_Wout_credit(nop1_Wout_credit)
    .nop_Nin_data(nop1_Nin_data),
    .nop_Nin_valid(nop1_Nin_valid),
    .nop_Nin_credit(nop1_Nin_credit),
    .nop_Nout_data(nop1_Nout_data),
    .nop_Nout_valid(nop1_Nout_valid),
    .nop_Nout_credit(nop1_Nout_credit)
    .nop_Pin_data(nop1_Pin_data),
    .nop_Pin_valid(nop1_Pin_valid),
    .nop_Pin_credit(nop1_Pin_credit),
    .nop_Pout_data(nop1_Pout_data),
    .nop_Pout_valid(nop1_Pout_valid),
    .nop_Pout_credit(nop1_Pout_credit)
);

credit_to_valrdy noc1_c2v(
  .clk(clk),
  .reset(~rst_n),

  .data_in(nop1_Pout_data),
  .valid_in(nop1_Pout_valid),
  .yummy_in(nop1_Pout_credit),

  .data_out(nop1_Pout_vr_data),
  .valid_out(nop1_Pout_vr_valid),
  .ready_out(nop1_Pout_vr_ready),
);

sip_demultiplexer_1 sip_demultiplexer_1 (
    .clk(clk),
    .rst_n(rst_n),
  
    .noc3_Pout_data(noc3_Pout_data),
    .noc3_Pout_valid(noc3_Pout_valid),
    .noc3_Pout_ready(noc3_Pout_ready)
    .noc4_Pout_data(noc4_Pout_data),
    .noc4_Pout_valid(noc4_Pout_valid),
    .noc4_Pout_ready(noc4_Pout_ready),
    .nop1_Pout_vr_data(nop1_Pout_vr_data),
    .nop1_Pout_vr_valid(nop1_Pout_vr_valid),
    .nop1_Pout_vr_ready(nop1_Pout_vr_ready)
);


endmodule
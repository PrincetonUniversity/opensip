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



module sip_router (
  input clk,
  input reset,
  input [:0] config_chipid_x, 
  input [:0] config_chipid_y, 
  
  input [63:0] nop_Sin_data,
  input nop_Sin_valid,
  output nop_Sin_credit,
  input [63:0] nop_Ein_data,
  input nop_Ein_valid,
  output nop_Ein_credit,
  input [63:0] nop_Win_data,
  input nop_Win_valid,
  output nop_Win_credit,
  input [63:0] nop_Nin_data,
  input nop_Nin_valid,
  output nop_Nin_credit,
  output [63:0] nop_Sout_data,
  output nop_Sout_valid,
  input nop_Sout_credit,
  output [63:0] nop_Eout_data,
  output nop_Eout_valid,
  input nop_Eout_credit,
  output [63:0] nop_Wout_data,
  output nop_Wout_valid,
  input nop_Wout_credit,
  output [63:0] nop_Nout_data,
  output nop_Nout_valid,
  input nop_Nout_credit,
  
  input [63:0] nop_Pin_muxed_data,
  input nop_Pin_muxed_valid,
  output nop_Pin_muxed_credit,
  input [63:0] nop_Pout_muxed_data,
  input nop_Pout_muxed_valid,
  output nop_Pout_muxed_credit
);


// router borrowed from openpiton
dynamic_node_top_wrap user_dynamic_network(
    .clk(clk),
    .reset_in(~rst_n),

    // My Absolute Address
    .myLocX(config_chipid_x),
    .myLocY(config_chipid_y),
    .myChipID(0),

    // dataIn (to input blocks)
    .dataIn_N(nop_Nin_data),
    .dataIn_E(nop_Ein_data),
    .dataIn_S(nop_Sin_data),
    .dataIn_W(nop_Win_data),
    .dataIn_P(nop_Pin_muxed_data),
    // validIn (to input blocks)
    .validIn_N(nop_Nin_valid),
    .validIn_E(nop_Ein_valid),
    .validIn_S(nop_Sin_valid),
    .validIn_W(nop_Win_valid),
    .validIn_P(nop_Pin_muxed_valid),
    // yummy (from nighboring input blocks)
    .yummyIn_N(nop_Nout_credit),
    .yummyIn_E(nop_Eout_credit),
    .yummyIn_S(nop_Sout_credit),
    .yummyIn_W(nop_Wout_credit),
    .yummyIn_P(nop_Pout_muxed_credit),

    //.ec_cfg(15'b0),//ec_dyn_cfg[14:0]),
    //.store_meter_partner_address_X(5'b0),
    //.store_meter_partner_address_Y(5'b0),
    // DataOut (from crossbar)
    .dataOut_N(nop_Nout_data),
    .dataOut_E(nop_Eout_data),
    .dataOut_S(nop_Sout_data),
    .dataOut_W(nop_Wout_data),
    .dataOut_P(nop_Pout_muxed_data),
    //data output to processor
    // validOut (from crossbar)
    .validOut_N(nop_Nout_valid),
    .validOut_E(nop_Eout_valid),
    .validOut_S(nop_Sout_valid),
    .validOut_W(nop_Wout_valid),
    .validOut_P(nop_Pout_muxed_valid),
    //data valid to processor
    // yummyOut (to neighboring output blocks)
    .yummyOut_N(nop_Nin_credit),
    .yummyOut_E(nop_Ein_credit),
    .yummyOut_W(nop_Win_credit),
    .yummyOut_S(nop_Sin_credit),
    .yummyOut_P(nop_Pin_muxed_credit)
    //yummy out to neighboring
    // thanksIn (to CGNO)
    //.thanksIn_P()
    //.external_interrupt(),
    //.store_meter_ack_partner(),
    //.store_meter_ack_non_partner(),
    //.ec_out(ec_dyn0));
);

endmodule
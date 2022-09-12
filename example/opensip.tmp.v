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



module opensip(
    input clk, 
    input rst_n, 

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
    input nop1_Nout_credit

);

    wire noc0_Pin_data[63:0];
    wire noc0_Pin_valid;
    wire noc0_Pin_credit;
    wire noc0_Pout_data[63:0];
    wire noc0_Pout_valid;
    wire noc0_Pout_credit;
    wire noc1_Pin_data[63:0];
    wire noc1_Pin_valid;
    wire noc1_Pin_credit;
    wire noc1_Pout_data[63:0];
    wire noc1_Pout_valid;
    wire noc1_Pout_credit;
    wire noc2_Pin_data[63:0];
    wire noc2_Pin_valid;
    wire noc2_Pin_credit;
    wire noc2_Pout_data[63:0];
    wire noc2_Pout_valid;
    wire noc2_Pout_credit;
    wire noc3_Pin_data[63:0];
    wire noc3_Pin_valid;
    wire noc3_Pin_credit;
    wire noc3_Pout_data[63:0];
    wire noc3_Pout_valid;
    wire noc3_Pout_credit;
    wire noc4_Pin_data[63:0];
    wire noc4_Pin_valid;
    wire noc4_Pin_credit;
    wire noc4_Pout_data[63:0];
    wire noc4_Pout_valid;
    wire noc4_Pout_credit;


wire [:0] config_chipid_x = 0;
wire [:0] config_chipid_y = 0;



sip_interconnect sip_interconnect(
    .clk(clk),
    .rst_n(rst_n),
    .config_chipid_x(config_chipid_x),
    .config_chipid_y(config_chipid_y),
    
    .nop0_Sin_data(nop0_Sin_data),
    .nop0_Sin_valid(nop0_Sin_valid),
    .nop0_Sin_credit(nop0_Sin_credit),
    .nop0_Sout_data(nop0_Sout_data),
    .nop0_Sout_valid(nop0_Sout_valid),
    .nop0_Sout_credit(nop0_Sout_credit),
    .nop0_Ein_data(nop0_Ein_data),
    .nop0_Ein_valid(nop0_Ein_valid),
    .nop0_Ein_credit(nop0_Ein_credit),
    .nop0_Eout_data(nop0_Eout_data),
    .nop0_Eout_valid(nop0_Eout_valid),
    .nop0_Eout_credit(nop0_Eout_credit),
    .nop0_Win_data(nop0_Win_data),
    .nop0_Win_valid(nop0_Win_valid),
    .nop0_Win_credit(nop0_Win_credit),
    .nop0_Wout_data(nop0_Wout_data),
    .nop0_Wout_valid(nop0_Wout_valid),
    .nop0_Wout_credit(nop0_Wout_credit),
    .nop0_Nin_data(nop0_Nin_data),
    .nop0_Nin_valid(nop0_Nin_valid),
    .nop0_Nin_credit(nop0_Nin_credit),
    .nop0_Nout_data(nop0_Nout_data),
    .nop0_Nout_valid(nop0_Nout_valid),
    .nop0_Nout_credit(nop0_Nout_credit),
    .nop1_Sin_data(nop1_Sin_data),
    .nop1_Sin_valid(nop1_Sin_valid),
    .nop1_Sin_credit(nop1_Sin_credit),
    .nop1_Sout_data(nop1_Sout_data),
    .nop1_Sout_valid(nop1_Sout_valid),
    .nop1_Sout_credit(nop1_Sout_credit),
    .nop1_Ein_data(nop1_Ein_data),
    .nop1_Ein_valid(nop1_Ein_valid),
    .nop1_Ein_credit(nop1_Ein_credit),
    .nop1_Eout_data(nop1_Eout_data),
    .nop1_Eout_valid(nop1_Eout_valid),
    .nop1_Eout_credit(nop1_Eout_credit),
    .nop1_Win_data(nop1_Win_data),
    .nop1_Win_valid(nop1_Win_valid),
    .nop1_Win_credit(nop1_Win_credit),
    .nop1_Wout_data(nop1_Wout_data),
    .nop1_Wout_valid(nop1_Wout_valid),
    .nop1_Wout_credit(nop1_Wout_credit),
    .nop1_Nin_data(nop1_Nin_data),
    .nop1_Nin_valid(nop1_Nin_valid),
    .nop1_Nin_credit(nop1_Nin_credit),
    .nop1_Nout_data(nop1_Nout_data),
    .nop1_Nout_valid(nop1_Nout_valid),
    .nop1_Nout_credit(nop1_Nout_credit),
    .noc0_Pin_data(noc0_Pin_data),
    .noc0_Pin_valid(noc0_Pin_valid),
    .noc0_Pin_credit(noc0_Pin_credit),
    .noc0_Pout_data(noc0_Pout_data),
    .noc0_Pout_valid(noc0_Pout_valid),
    .noc0_Pout_credit(noc0_Pout_credit),
    .noc1_Pin_data(noc1_Pin_data),
    .noc1_Pin_valid(noc1_Pin_valid),
    .noc1_Pin_credit(noc1_Pin_credit),
    .noc1_Pout_data(noc1_Pout_data),
    .noc1_Pout_valid(noc1_Pout_valid),
    .noc1_Pout_credit(noc1_Pout_credit),
    .noc2_Pin_data(noc2_Pin_data),
    .noc2_Pin_valid(noc2_Pin_valid),
    .noc2_Pin_credit(noc2_Pin_credit),
    .noc2_Pout_data(noc2_Pout_data),
    .noc2_Pout_valid(noc2_Pout_valid),
    .noc2_Pout_credit(noc2_Pout_credit),
    .noc3_Pin_data(noc3_Pin_data),
    .noc3_Pin_valid(noc3_Pin_valid),
    .noc3_Pin_credit(noc3_Pin_credit),
    .noc3_Pout_data(noc3_Pout_data),
    .noc3_Pout_valid(noc3_Pout_valid),
    .noc3_Pout_credit(noc3_Pout_credit),
    .noc4_Pin_data(noc4_Pin_data),
    .noc4_Pin_valid(noc4_Pin_valid),
    .noc4_Pin_credit(noc4_Pin_credit),
    .noc4_Pout_data(noc4_Pout_data),
    .noc4_Pout_valid(noc4_Pout_valid),
    .noc4_Pout_credit(noc4_Pout_credit)

);

// chip instantiation

chip chip(

    // ...
    
    .noc0_Pin_data(noc0_Pin_data),
    .noc0_Pin_valid(noc0_Pin_valid),
    .noc0_Pin_credit(noc0_Pin_credit),
    .noc0_Pout_data(noc0_Pout_data),
    .noc0_Pout_valid(noc0_Pout_valid),
    .noc0_Pout_credit(noc0_Pout_credit),
    .noc1_Pin_data(noc1_Pin_data),
    .noc1_Pin_valid(noc1_Pin_valid),
    .noc1_Pin_credit(noc1_Pin_credit),
    .noc1_Pout_data(noc1_Pout_data),
    .noc1_Pout_valid(noc1_Pout_valid),
    .noc1_Pout_credit(noc1_Pout_credit),
    .noc2_Pin_data(noc2_Pin_data),
    .noc2_Pin_valid(noc2_Pin_valid),
    .noc2_Pin_credit(noc2_Pin_credit),
    .noc2_Pout_data(noc2_Pout_data),
    .noc2_Pout_valid(noc2_Pout_valid),
    .noc2_Pout_credit(noc2_Pout_credit),
    .noc3_Pin_data(noc3_Pin_data),
    .noc3_Pin_valid(noc3_Pin_valid),
    .noc3_Pin_credit(noc3_Pin_credit),
    .noc3_Pout_data(noc3_Pout_data),
    .noc3_Pout_valid(noc3_Pout_valid),
    .noc3_Pout_credit(noc3_Pout_credit),
    .noc4_Pin_data(noc4_Pin_data),
    .noc4_Pin_valid(noc4_Pin_valid),
    .noc4_Pin_credit(noc4_Pin_credit),
    .noc4_Pout_data(noc4_Pout_data),
    .noc4_Pout_valid(noc4_Pout_valid),
    .noc4_Pout_credit(noc4_Pout_credit)

);


endmodule
/*
Copyright (c) 2015 Princeton University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//Function: This ties together a 4 space NIB with the dynamic_input_control_para logic
//
//State:
//
//Instantiates: dynamic_input_control_para, network_input_blk_4elmt
//
//Note:
//
<%
import os
import sys
sys.path.append(os.path.join(os.getcwd(), 'src/dynamic_node/parameter'))
import dynamic_node_para_define
DYNAMIC_NODE_PORT = dynamic_node_para_define.DYNAMIC_NODE_PORT
DYNAMIC_NODE_PORT_LOG2 = dynamic_node_para_define.DYNAMIC_NODE_PORT_LOG2
route_req_outs = ""
default_readys = ""
thanks = ""
for a in range (DYNAMIC_NODE_PORT):
  route_req_outs = route_req_outs + ("route_req_%d_out, " % a)
  default_readys = default_readys + ("default_ready_%d_out, " % a)
  thanks = thanks + ("thanks_%d, " % a)
%>
module dynamic_input_top_4_para(<%= route_req_outs%>
                           <%= default_readys%>
                           tail_out, yummy_out, data_out, valid_out, clk, reset,
                           my_loc_x_in, my_loc_y_in, my_chip_id_in,  valid_in, data_in,
                           <%= thanks[:-2]%>);

// begin port declarations

<%
for a in range (DYNAMIC_NODE_PORT):
  s = "output route_req_%d_out;" % a
  print(s)
for a in range (DYNAMIC_NODE_PORT):
  s = "output default_ready_%d_out;" % a
  print(s)
%>
output tail_out;
output yummy_out;
output [`DATA_WIDTH-1:0] data_out;
output valid_out;

input clk;
input reset;

input [`XY_WIDTH-1:0] my_loc_x_in;
input [`XY_WIDTH-1:0] my_loc_y_in;
input [`CHIP_ID_WIDTH-1:0] my_chip_id_in;
input valid_in;
input [`DATA_WIDTH-1:0] data_in;
<%
for a in range (DYNAMIC_NODE_PORT):
  s = "input thanks_%d;" % a
  print(s)
%>

// end port declarations

//This is the state

//inputs to the state

//wires
wire thanks_all_temp;
wire [`DATA_WIDTH-1:0] data_internal;
wire valid_out_internal;

//wire regs

//assigns
assign valid_out = valid_out_internal;

//instantiations
network_input_blk_multi_out #(.LOG2_NUMBER_FIFO_ELEMENTS(2)) NIB(.clk(clk),
                                      .reset(reset),
                                      .data_in(data_in),
                                      .valid_in(valid_in),
                                      .yummy_out(yummy_out),
                                      .thanks_in(thanks_all_temp),
                                      .data_val(data_out),
                                      .data_val1(data_internal), // same as data_val, done for buffering
                                      .data_avail(valid_out_internal));
<%
route_reqs_inst = ""
for a in range (DYNAMIC_NODE_PORT):
  route_reqs_inst = route_reqs_inst + (".route_req_%d_out(route_req_%d_out), " % (a, a))
default_readys_inst = ""
for a in range (DYNAMIC_NODE_PORT):
  default_readys_inst = default_readys_inst + (".default_ready_%d(default_ready_%d_out), " % (a, a))
thanks_inst = ""
for a in range (DYNAMIC_NODE_PORT):
  thanks_inst = thanks_inst + (".thanks_%d(thanks_%d), " % (a,a))
%>
dynamic_input_control_para control(.thanks_all_temp_out(thanks_all_temp),
                              <%= route_reqs_inst%>
                              <%= default_readys_inst%>
                              .tail_out(tail_out),
                              .clk(clk), .reset(reset),
                              .my_loc_x_in(my_loc_x_in), 
                              .my_loc_y_in(my_loc_y_in), 
                              .my_chip_id_in(my_chip_id_in),
                              .abs_x(data_internal[`DATA_WIDTH-`CHIP_ID_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH]), 
                              .abs_y(data_internal[`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH]), 
                              .abs_chip_id(data_internal[`DATA_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH]),
                              .final_bits(data_internal[`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH-2:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH-4]),
                              .valid_in(valid_out_internal),
                              <%= thanks_inst%>
                              .length(data_internal[`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH-5:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH-4-`PAYLOAD_LEN]));

endmodule

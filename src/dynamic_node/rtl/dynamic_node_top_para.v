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

//Function: This wires everything together to make a crossbar
//

<%
import os
import sys
sys.path.append(os.path.join(os.getcwd(), 'src/dynamic_node/parameter'))
import dynamic_node_para_define
DYNAMIC_NODE_PORT = dynamic_node_para_define.DYNAMIC_NODE_PORT
DYNAMIC_NODE_PORT_LOG2 = dynamic_node_para_define.DYNAMIC_NODE_PORT_LOG2
DYNAMIC_NODE_PORT_P_3 = dynamic_node_para_define.DYNAMIC_NODE_PORT_P_3
DYNAMIC_NODE_PORT_P_3_LOG2 = dynamic_node_para_define.DYNAMIC_NODE_PORT_P_3_LOG2
dataIns = ""
validIns = ""
yummyIns = ""
dataOuts = ""
validOuts = ""
yummyOuts = ""
for a in range (DYNAMIC_NODE_PORT):
  dataIns = dataIns + ("dataIn_%d, " % a)
  validIns = validIns + ("validIn_%d, " % a)
  yummyIns = yummyIns + ("yummyIn_%d," % a)
  dataOuts = dataOuts + ("dataOut_%d, " % a)
  validOuts = validOuts + ("validOut_%d, " % a)
  yummyOuts = yummyOuts + ("yummyOut_%d," % a)
%>
module dynamic_node_top_para(clk,
		    reset_in,
        <%= dataIns%>
        <%= validIns%>
        <%= yummyIns%>
		    myLocX,
		    myLocY,
            myChipID,
		    store_meter_partner_address_X,
		    store_meter_partner_address_Y,
		    ec_cfg,
        <%= dataOuts%>
        <%= validOuts%>
        <%= yummyOuts%>
		    thanksIn_<%= DYNAMIC_NODE_PORT - 1%>,
		    external_interrupt,
		    store_meter_ack_partner,
		    store_meter_ack_non_partner,
		    ec_out);

// begin port declarations

input clk;
input reset_in;

<%
for a in range (DYNAMIC_NODE_PORT):
  print("input [`DATA_WIDTH-1:0] dataIn_%d;" % a)
print("")
for a in range (DYNAMIC_NODE_PORT):
  print("input validIn_%d;" % a)
print("")
for a in range (DYNAMIC_NODE_PORT):
  print("input yummyIn_%d;" % a)
%>
/*
//original 
input [`DATA_WIDTH-1:0] dataIn_N;	// data inputs from neighboring tiles
input [`DATA_WIDTH-1:0] dataIn_E;
input [`DATA_WIDTH-1:0] dataIn_S;
input [`DATA_WIDTH-1:0] dataIn_W;
input [`DATA_WIDTH-1:0] dataIn_P;	// data input from processor
   
input validIn_N;		// valid signals from neighboring tiles
input validIn_E;
input validIn_S;
input validIn_W;
input validIn_P;		// valid signal from processor
   
input yummyIn_N;		// neighbor consumed output data
input yummyIn_E;
input yummyIn_S;
input yummyIn_W;
input yummyIn_P;		// processor consumed output data
*/   
input [`XY_WIDTH-1:0] myLocX;		// this tile's position
input [`XY_WIDTH-1:0] myLocY;
input [`CHIP_ID_WIDTH-1:0] myChipID;

input [4:0] store_meter_partner_address_X;
input [4:0] store_meter_partner_address_Y;

input [<%= DYNAMIC_NODE_PORT * DYNAMIC_NODE_PORT_P_3_LOG2 - 1%>:0] ec_cfg;            // NESWP 3 bits each selecter of event to monitor

<%
for a in range (DYNAMIC_NODE_PORT):
  print("output [`DATA_WIDTH-1:0] dataOut_%d;" % a)
print("")
for a in range (DYNAMIC_NODE_PORT):
  print("output validOut_%d;" % a)
print("")
for a in range (DYNAMIC_NODE_PORT):
  print("output yummyOut_%d;" % a)
%>
/*
//original
output [`DATA_WIDTH-1:0] dataOut_N;	// data outputs to neighbors
output [`DATA_WIDTH-1:0] dataOut_E;
output [`DATA_WIDTH-1:0] dataOut_S;
output [`DATA_WIDTH-1:0] dataOut_W;
output [`DATA_WIDTH-1:0] dataOut_P;	// data output to processor

output validOut_N;		// valid outputs to neighbors
output validOut_E;
output validOut_S;
output validOut_W;
output validOut_P;		// valid output to processor
   
output yummyOut_N;		// yummy signal to neighbors' output buffers
output yummyOut_E;
output yummyOut_S;
output yummyOut_W;
output yummyOut_P;		// yummy signal to processor's output buffer
*/
output thanksIn_<%= DYNAMIC_NODE_PORT - 1%>;		// thanksIn to processor's space_avail

output external_interrupt;	//is used for the proc to know
				//that an external interrupt occured
output store_meter_ack_partner;      // strobes high when a memory ack word is popped off of the network
                                     // and the sender ID matches the "partner port" id from the STORE_METER
output store_meter_ack_non_partner;  // strobes high when a memory ack word is popped off of the network
                                     // and the sender ID does not match the "partner port" id from the STORE_METER


output [<%= DYNAMIC_NODE_PORT - 1%>:0] ec_out;

<%
dynamic_node_para_define.print_ports("wire   ec_wants_to_send_but_cannot_%d;")
%>
// end port declarations

   wire store_ack_received;
   wire store_ack_received_r;
   wire [9:0] store_ack_addr;
   wire [9:0] store_ack_addr_r;

//wires
<%
dynamic_node_para_define.print_ports_nl ("wire node_%d_input_tail;")
dynamic_node_para_define.print_ports_nl ("wire [`DATA_WIDTH-1:0] node_%d_input_data;")
dynamic_node_para_define.print_ports_nl ("wire node_%d_input_valid;")
for a in range (DYNAMIC_NODE_PORT):
  for b in range (DYNAMIC_NODE_PORT):
    print ("wire thanks_%d_to_%d;" % (a, b))
  print("")
for a in range (DYNAMIC_NODE_PORT):
  for b in range (DYNAMIC_NODE_PORT):
    print ("wire route_req_%d_to_%d;" % (a, b))
  print("")
for a in range (DYNAMIC_NODE_PORT):
  print ("wire default_ready_%d_to_%d;" % (dynamic_node_para_define.gen_default_dir(a), a))
print("")
dynamic_node_para_define.print_ports_nl ("wire yummyOut_%d_internal;")
dynamic_node_para_define.print_ports_nl ("wire validOut_%d_internal;")
dynamic_node_para_define.print_ports_nl ("wire [`DATA_WIDTH-1:0] dataOut_%d_internal;")
dynamic_node_para_define.print_ports_nl_nm1("wire yummyOut_%d_flip1_out;")
dynamic_node_para_define.print_ports_nl_nm1("wire validOut_%d_flip1_out;")
dynamic_node_para_define.print_ports_nl_nm1("wire [`DATA_WIDTH-1:0] dataOut_%d_flip1_out;")
dynamic_node_para_define.print_ports_nl ("wire yummyIn_%d_internal;")
dynamic_node_para_define.print_ports_nl_nm1 ("wire validIn_%d_internal;")
dynamic_node_para_define.print_ports_nl_nm1 ("wire [`DATA_WIDTH-1:0] dataIn_%d_internal;")
dynamic_node_para_define.print_ports_nl_nm1 ("wire yummyIn_%d_flip1_out;")
dynamic_node_para_define.print_ports_nl_nm1 ("wire validIn_%d_flip1_out;")
dynamic_node_para_define.print_ports_nm1 ("wire [`DATA_WIDTH-1:0] dataIn_%d_flip1_out;")
%>
/*
//original
wire default_ready_n_to_s;
wire default_ready_e_to_w;
wire default_ready_s_to_n;
wire default_ready_s_to_p;
wire default_ready_w_to_e;

// input/output buffered signals
wire yummyOut_N_internal;
wire yummyOut_E_internal;
wire yummyOut_S_internal;
wire yummyOut_W_internal;
wire yummyOut_P_internal;

wire validOut_N_internal;
wire validOut_E_internal;
wire validOut_S_internal;
wire validOut_W_internal;
wire validOut_P_internal;

wire [`DATA_WIDTH-1:0] dataOut_N_internal;
wire [`DATA_WIDTH-1:0] dataOut_E_internal;
wire [`DATA_WIDTH-1:0] dataOut_S_internal;
wire [`DATA_WIDTH-1:0] dataOut_W_internal;
wire [`DATA_WIDTH-1:0] dataOut_P_internal;

wire yummyOut_N_flip1_out;
wire yummyOut_E_flip1_out;
wire yummyOut_S_flip1_out;
wire yummyOut_W_flip1_out;
//wire yummyOut_P_flip1_out;

wire validOut_N_flip1_out;
wire validOut_E_flip1_out;
wire validOut_S_flip1_out;
wire validOut_W_flip1_out;
//wire validOut_P_flip1_out;

wire [`DATA_WIDTH-1:0] dataOut_N_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_E_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_S_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_W_flip1_out;
//wire [`DATA_WIDTH-1:0] dataOut_P_flip1_out;

wire yummyIn_N_internal;
wire yummyIn_E_internal;
wire yummyIn_S_internal;
wire yummyIn_W_internal;
wire yummyIn_P_internal;

wire validIn_N_internal;
wire validIn_E_internal;
wire validIn_S_internal;
wire validIn_W_internal;
//wire validIn_P_internal;

wire [`DATA_WIDTH-1:0] dataIn_N_internal;
wire [`DATA_WIDTH-1:0] dataIn_E_internal;
wire [`DATA_WIDTH-1:0] dataIn_S_internal;
wire [`DATA_WIDTH-1:0] dataIn_W_internal;
//wire [`DATA_WIDTH-1:0] dataIn_P_internal;

wire yummyIn_N_flip1_out;
wire yummyIn_E_flip1_out;
wire yummyIn_S_flip1_out;
wire yummyIn_W_flip1_out;
//wire yummyIn_P_flip1_out;

wire validIn_N_flip1_out;
wire validIn_E_flip1_out;
wire validIn_S_flip1_out;
wire validIn_W_flip1_out;
//wire validIn_P_flip1_out;

wire [`DATA_WIDTH-1:0] dataIn_N_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_E_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_S_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_W_flip1_out;
//wire [`DATA_WIDTH-1:0] dataIn_P_flip1_out;
*/
//state
reg [`XY_WIDTH-1:0] myLocX_f;
reg [`XY_WIDTH-1:0] myLocY_f;
reg [`CHIP_ID_WIDTH-1:0] myChipID_f;
wire   reset;


// event counter logic
//
//
<%
for a in range (DYNAMIC_NODE_PORT):
  s = " ec_thanks_%d_to_%%d_reg," % a
  dynamic_node_para_define.print_ports_oneline("reg", s)
dynamic_node_para_define.print_ports_oneline("reg", " ec_wants_to_send_but_cannot_%d_reg,")
dynamic_node_para_define.print_ports_oneline("reg", " ec_%d_input_valid_reg,")
%>
/*
//original
reg ec_thanks_n_to_n_reg, ec_thanks_n_to_e_reg, ec_thanks_n_to_s_reg, ec_thanks_n_to_w_reg, ec_thanks_n_to_p_reg;
reg ec_thanks_e_to_n_reg, ec_thanks_e_to_e_reg, ec_thanks_e_to_s_reg, ec_thanks_e_to_w_reg, ec_thanks_e_to_p_reg;
reg ec_thanks_s_to_n_reg, ec_thanks_s_to_e_reg, ec_thanks_s_to_s_reg, ec_thanks_s_to_w_reg, ec_thanks_s_to_p_reg;
reg ec_thanks_w_to_n_reg, ec_thanks_w_to_e_reg, ec_thanks_w_to_s_reg, ec_thanks_w_to_w_reg, ec_thanks_w_to_p_reg;
reg ec_thanks_p_to_n_reg, ec_thanks_p_to_e_reg, ec_thanks_p_to_s_reg, ec_thanks_p_to_w_reg, ec_thanks_p_to_p_reg;
reg ec_wants_to_send_but_cannot_N_reg, ec_wants_to_send_but_cannot_E_reg, ec_wants_to_send_but_cannot_S_reg, ec_wants_to_send_but_cannot_W_reg, ec_wants_to_send_but_cannot_P_reg;
reg ec_north_input_valid_reg, ec_east_input_valid_reg, ec_south_input_valid_reg, ec_west_input_valid_reg, ec_proc_input_valid_reg;
*/

// let's register these babies before they do any damage to the cycle time -- mbt
always @(posedge clk)
  begin
    <%
    print("")
    s1 = "   "
    for a in range (DYNAMIC_NODE_PORT):
      s2 = " ec_thanks_%d_to_%%d_reg <= thanks_%d_to_%%d;" % (a, a)
      dynamic_node_para_define.print_ports_oneline_2(s1, s2)
    dynamic_node_para_define.print_ports_2(s1 + " ec_wants_to_send_but_cannot_%d_reg <= ec_wants_to_send_but_cannot_%d;")
    dynamic_node_para_define.print_ports_2(s1 + " ec_%d_input_valid_reg <= node_%d_input_valid;")
    %>
    /*
    //original
     ec_thanks_n_to_n_reg <= thanks_n_to_n; ec_thanks_n_to_e_reg <= thanks_n_to_e; ec_thanks_n_to_s_reg <= thanks_n_to_s; ec_thanks_n_to_w_reg <= thanks_n_to_w; ec_thanks_n_to_p_reg <= thanks_n_to_p;
     ec_thanks_e_to_n_reg <= thanks_e_to_n; ec_thanks_e_to_e_reg <= thanks_e_to_e; ec_thanks_e_to_s_reg <= thanks_e_to_s; ec_thanks_e_to_w_reg <= thanks_e_to_w; ec_thanks_e_to_p_reg <= thanks_e_to_p;
     ec_thanks_s_to_n_reg <= thanks_s_to_n; ec_thanks_s_to_e_reg <= thanks_s_to_e; ec_thanks_s_to_s_reg <= thanks_s_to_s; ec_thanks_s_to_w_reg <= thanks_s_to_w; ec_thanks_s_to_p_reg <= thanks_s_to_p;
     ec_thanks_w_to_n_reg <= thanks_w_to_n; ec_thanks_w_to_e_reg <= thanks_w_to_e; ec_thanks_w_to_s_reg <= thanks_w_to_s; ec_thanks_w_to_w_reg <= thanks_w_to_w; ec_thanks_w_to_p_reg <= thanks_w_to_p;
     ec_thanks_p_to_n_reg <= thanks_p_to_n; ec_thanks_p_to_e_reg <= thanks_p_to_e; ec_thanks_p_to_s_reg <= thanks_p_to_s; ec_thanks_p_to_w_reg <= thanks_p_to_w; ec_thanks_p_to_p_reg <= thanks_p_to_p;
     ec_wants_to_send_but_cannot_N_reg <= ec_wants_to_send_but_cannot_N;
     ec_wants_to_send_but_cannot_E_reg <= ec_wants_to_send_but_cannot_E;
     ec_wants_to_send_but_cannot_S_reg <= ec_wants_to_send_but_cannot_S;
     ec_wants_to_send_but_cannot_W_reg <= ec_wants_to_send_but_cannot_W;
     ec_wants_to_send_but_cannot_P_reg <= ec_wants_to_send_but_cannot_P;
     ec_north_input_valid_reg <= north_input_valid;
     ec_east_input_valid_reg  <= east_input_valid;
     ec_south_input_valid_reg <= south_input_valid;
     ec_west_input_valid_reg  <= west_input_valid;
     ec_proc_input_valid_reg  <= proc_input_valid;
    */
  end

<%
for a in range (DYNAMIC_NODE_PORT):
  s1 = "wire ec_thanks_to_%d=" % a
  s2 = " ec_thanks_%%d_to_%d_reg |" %a
  dynamic_node_para_define.print_ports_oneline(s1, s2)
%>
/*
//original
   wire ec_thanks_to_n = ec_thanks_n_to_n_reg | ec_thanks_e_to_n_reg | ec_thanks_s_to_n_reg | ec_thanks_w_to_n_reg | ec_thanks_p_to_n_reg;
   wire ec_thanks_to_e = ec_thanks_n_to_e_reg | ec_thanks_e_to_e_reg | ec_thanks_s_to_e_reg | ec_thanks_w_to_e_reg | ec_thanks_p_to_e_reg;
   wire ec_thanks_to_s = ec_thanks_n_to_s_reg | ec_thanks_e_to_s_reg | ec_thanks_s_to_s_reg | ec_thanks_w_to_s_reg | ec_thanks_p_to_s_reg;
   wire ec_thanks_to_w = ec_thanks_n_to_w_reg | ec_thanks_e_to_w_reg | ec_thanks_s_to_w_reg | ec_thanks_w_to_w_reg | ec_thanks_p_to_w_reg;
   wire ec_thanks_to_p = ec_thanks_n_to_p_reg | ec_thanks_e_to_p_reg | ec_thanks_s_to_p_reg | ec_thanks_w_to_p_reg | ec_thanks_p_to_p_reg;
*/
<%
indent = "                        "
for a in range (DYNAMIC_NODE_PORT):
  s = "one_of_n_plus_3 #(1) ec_mux_%d(.in0(ec_wants_to_send_but_cannot_%d),\n"% (a, a)
  for b in range (1, DYNAMIC_NODE_PORT + 1):
    s = s + indent + ".in%d(ec_thanks_%d_to_%d_reg),\n" % (b, (DYNAMIC_NODE_PORT - b), a)
  s = s + indent + ".in%d(ec_thanks_to_%d),\n" % (DYNAMIC_NODE_PORT + 1, a)
  s = s + indent + ".in%d(ec_%d_input_valid_reg & ~ec_thanks_to_%d),\n" % (DYNAMIC_NODE_PORT + 2, a, a)
  s = s + indent + ".sel(ec_cfg[%d:%d]),\n" % ((DYNAMIC_NODE_PORT - a) * DYNAMIC_NODE_PORT_P_3_LOG2 - 1, (DYNAMIC_NODE_PORT - a - 1) * DYNAMIC_NODE_PORT_P_3_LOG2)
  s = s + indent + ".out(ec_out[%d]));" % (DYNAMIC_NODE_PORT - a - 1)
  print(s)

%>
/*
//original
one_of_eight #(1) ec_mux_north(.in0(ec_wants_to_send_but_cannot_N),
                        .in1(ec_thanks_p_to_n_reg),
                        .in2(ec_thanks_w_to_n_reg),
                        .in3(ec_thanks_s_to_n_reg),
                        .in4(ec_thanks_e_to_n_reg),
                        .in5(ec_thanks_n_to_n_reg),
                        .in6(ec_thanks_to_n),
                        .in7(ec_north_input_valid_reg & ~ec_thanks_to_n),
                        .sel(ec_cfg[14:12]),
                        .out(ec_out[4]));

one_of_eight #(1) ec_mux_east(.in0(ec_wants_to_send_but_cannot_E),
                       .in1(ec_thanks_p_to_e_reg),
                       .in2(ec_thanks_w_to_e_reg),
                       .in3(ec_thanks_s_to_e_reg),
                       .in4(ec_thanks_e_to_e_reg),
                       .in5(ec_thanks_n_to_e_reg),
                       .in6(ec_thanks_to_e),
                       .in7(ec_east_input_valid_reg & ~ec_thanks_to_e),
                       .sel(ec_cfg[11:9]),
                       .out(ec_out[3]));

one_of_eight #(1) ec_mux_south(.in0(ec_wants_to_send_but_cannot_S),
                        .in1(ec_thanks_p_to_s_reg),
                        .in2(ec_thanks_w_to_s_reg),
                        .in3(ec_thanks_s_to_s_reg),
                        .in4(ec_thanks_e_to_s_reg),
                        .in5(ec_thanks_n_to_s_reg),
                        .in6(ec_thanks_to_s),
                        .in7(ec_south_input_valid_reg & ~ec_thanks_to_s),
                        .sel(ec_cfg[8:6]),
                        .out(ec_out[2]));

one_of_eight #(1) ec_mux_west( .in0(ec_wants_to_send_but_cannot_W),
                        .in1(ec_thanks_p_to_w_reg),
                        .in2(ec_thanks_w_to_w_reg),
                        .in3(ec_thanks_s_to_w_reg),
                        .in4(ec_thanks_e_to_w_reg),
                        .in5(ec_thanks_n_to_w_reg),
                        .in6(ec_thanks_to_w),
                        .in7(ec_west_input_valid_reg & ~ec_thanks_to_w),
                        .sel(ec_cfg[5:3]),
                        .out(ec_out[1]));

one_of_eight #(1) ec_mux_proc( .in0(ec_wants_to_send_but_cannot_P),
                        .in1(ec_thanks_p_to_p_reg),
                        .in2(ec_thanks_w_to_p_reg),
                        .in3(ec_thanks_s_to_p_reg),
                        .in4(ec_thanks_e_to_p_reg),
                        .in5(ec_thanks_n_to_p_reg),
                        .in6(ec_thanks_to_p),
                        .in7(ec_proc_input_valid_reg & ~ec_thanks_to_p),
                        .sel(ec_cfg[2:0]),
                        .out(ec_out[0]));
*/
// end event counter logic

net_dff #(1) REG_reset_fin(.d(reset_in), .q(reset), .clk(clk));

net_dff #(10) REG_store_ack_addr(   .d(store_ack_addr),     .q(store_ack_addr_r),     .clk(clk));
net_dff #(1) REG_store_ack_received(.d(store_ack_received), .q(store_ack_received_r), .clk(clk));

   wire is_partner_address_v_r;
   bus_compare_equal #(10) CMP_partner_address (.a(store_ack_addr_r),
                                        .b({ store_meter_partner_address_Y, store_meter_partner_address_X } ),
                                        .bus_equal(is_partner_address_v_r));

   assign store_meter_ack_partner     = is_partner_address_v_r & store_ack_received_r;
   assign store_meter_ack_non_partner = ~is_partner_address_v_r & store_ack_received_r;

//make it so that the mdn_cfg location register has
//one cycle latency when being changed
//this was done so that these flops could be put near the
//dynamic network but this does mean that the cycle directly
//folowing a mtsr MDN_CFG which changes the location bits
//will still use the old value
//likewise it would be best to make sure there are no in-flight memory
//operations when setting the X and Y location for a tile.
always @ (posedge clk)
begin
        if(reset)
        begin
                myLocY_f <= `XY_WIDTH'd0;
                myLocX_f <= `XY_WIDTH'd0;
                myChipID_f <= `CHIP_ID_WIDTH'd0;
        end
        else
        begin
                myLocY_f <= myLocY;
                myLocX_f <= myLocX;
                myChipID_f <= myChipID;
        end
end


//wire regs

//assigns
<%
dynamic_node_para_define.print_ports_oneline("assign thanksIn_%d =" % (DYNAMIC_NODE_PORT - 1), " thanks_%%d_to_%d |" % (DYNAMIC_NODE_PORT - 1))
%>
/*
//original
assign thanksIn_P = thanks_n_to_p | thanks_e_to_p | thanks_s_to_p | thanks_w_to_p | thanks_p_to_p;
*/
//assign validOut_N = validOut_N_internal;
//assign validOut_E = validOut_E_internal;
//assign validOut_S = validOut_S_internal;
//assign validOut_W = validOut_W_internal;
assign validOut_<%= DYNAMIC_NODE_PORT - 1%> = validOut_<%= DYNAMIC_NODE_PORT - 1%>_internal;

//assign dataOut_N = dataOut_N_internal;
//assign dataOut_E = dataOut_E_internal;
//assign dataOut_S = dataOut_S_internal;
//assign dataOut_W = dataOut_W_internal;
assign dataOut_<%= DYNAMIC_NODE_PORT - 1%> = dataOut_<%= DYNAMIC_NODE_PORT - 1%>_internal;

//more assigns
assign yummyIn_<%= DYNAMIC_NODE_PORT - 1%>_internal = yummyIn_<%= DYNAMIC_NODE_PORT - 1%>;
assign yummyOut_<%= DYNAMIC_NODE_PORT - 1%> = yummyOut_<%= DYNAMIC_NODE_PORT - 1%>_internal;

<%
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 14) yummyOut_%d_flip1(yummyOut_%d_internal, yummyOut_%d_flip1_out);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 21) yummyOut_%d_flip2(yummyOut_%d_flip1_out, yummyOut_%d);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 14) validOut_%d_flip1(validOut_%d_internal, validOut_%d_flip1_out);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 21) validOut_%d_flip2(validOut_%d_flip1_out, validOut_%d);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(`DATA_WIDTH, 14) dataOut_%d_flip1(dataOut_%d_internal, dataOut_%d_flip1_out);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(`DATA_WIDTH, 21) dataOut_%d_flip2(dataOut_%d_flip1_out, dataOut_%d);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 14) yummyIn_%d_flip1(yummyIn_%d, yummyIn_%d_flip1_out);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 10) yummyIn_%d_flip2(yummyIn_%d_flip1_out, yummyIn_%d_internal);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 14) validIn_%d_flip1(validIn_%d, validIn_%d_flip1_out);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(1, 10) validIn_%d_flip2(validIn_%d_flip1_out, validIn_%d_internal);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(`DATA_WIDTH, 14) dataIn_%d_flip1(dataIn_%d, dataIn_%d_flip1_out);")
dynamic_node_para_define.print_ports_nm1_3_nl("flip_bus #(`DATA_WIDTH, 10) dataIn_%d_flip2(dataIn_%d_flip1_out, dataIn_%d_internal);")
%>
/*
//original
// two sets of inverters for output signals (buffering for timing purposes)
flip_bus #(1, 14) yummyOut_N_flip1(yummyOut_N_internal, yummyOut_N_flip1_out);
flip_bus #(1, 14) yummyOut_E_flip1(yummyOut_E_internal, yummyOut_E_flip1_out);
flip_bus #(1, 14) yummyOut_S_flip1(yummyOut_S_internal, yummyOut_S_flip1_out);
flip_bus #(1, 14) yummyOut_W_flip1(yummyOut_W_internal, yummyOut_W_flip1_out);
//flip_bus #(1, 14) yummyOut_P_flip1(yummyOut_P_internal, yummyOut_P_flip1_out);
flip_bus #(1, 21) yummyOut_N_flip2(yummyOut_N_flip1_out, yummyOut_N);
flip_bus #(1, 21) yummyOut_E_flip2(yummyOut_E_flip1_out, yummyOut_E);
flip_bus #(1, 21) yummyOut_S_flip2(yummyOut_S_flip1_out, yummyOut_S);
flip_bus #(1, 21) yummyOut_W_flip2(yummyOut_W_flip1_out, yummyOut_W);
//flip_bus #(1, 21) yummyOut_P_flip2(yummyOut_P_flip1_out, yummyOut_P);

flip_bus #(1, 14) validOut_N_flip1(validOut_N_internal, validOut_N_flip1_out);
flip_bus #(1, 14) validOut_E_flip1(validOut_E_internal, validOut_E_flip1_out);
flip_bus #(1, 14) validOut_S_flip1(validOut_S_internal, validOut_S_flip1_out);
flip_bus #(1, 14) validOut_W_flip1(validOut_W_internal, validOut_W_flip1_out);
//flip_bus #(1, 14) validOut_P_flip1(validOut_P_internal, validOut_P_flip1_out);
flip_bus #(1, 21) validOut_N_flip2(validOut_N_flip1_out, validOut_N);
flip_bus #(1, 21) validOut_E_flip2(validOut_E_flip1_out, validOut_E);
flip_bus #(1, 21) validOut_S_flip2(validOut_S_flip1_out, validOut_S);
flip_bus #(1, 21) validOut_W_flip2(validOut_W_flip1_out, validOut_W);
//flip_bus #(1, 21) validOut_P_flip2(validOut_P_flip1_out, validOut_P);

flip_bus #(`DATA_WIDTH, 14) dataOut_N_flip1(dataOut_N_internal, dataOut_N_flip1_out);
flip_bus #(`DATA_WIDTH, 14) dataOut_E_flip1(dataOut_E_internal, dataOut_E_flip1_out);
flip_bus #(`DATA_WIDTH, 14) dataOut_S_flip1(dataOut_S_internal, dataOut_S_flip1_out);
flip_bus #(`DATA_WIDTH, 14) dataOut_W_flip1(dataOut_W_internal, dataOut_W_flip1_out);
//flip_bus #(`DATA_WIDTH, 14) dataOut_P_flip1(dataOut_P_internal, dataOut_P_flip1_out);
flip_bus #(`DATA_WIDTH, 21) dataOut_N_flip2(dataOut_N_flip1_out, dataOut_N);
flip_bus #(`DATA_WIDTH, 21) dataOut_E_flip2(dataOut_E_flip1_out, dataOut_E);
flip_bus #(`DATA_WIDTH, 21) dataOut_S_flip2(dataOut_S_flip1_out, dataOut_S);
flip_bus #(`DATA_WIDTH, 21) dataOut_W_flip2(dataOut_W_flip1_out, dataOut_W);
//flip_bus #(`DATA_WIDTH, 21) dataOut_P_flip2(dataOut_P_flip1_out, dataOut_P);

// two sets of inverters for input signals (buffering for timing purposes)
flip_bus #(1, 14) yummyIn_N_flip1(yummyIn_N, yummyIn_N_flip1_out);
flip_bus #(1, 14) yummyIn_E_flip1(yummyIn_E, yummyIn_E_flip1_out);
flip_bus #(1, 14) yummyIn_S_flip1(yummyIn_S, yummyIn_S_flip1_out);
flip_bus #(1, 14) yummyIn_W_flip1(yummyIn_W, yummyIn_W_flip1_out);
//flip_bus #(1, 14) yummyIn_P_flip1(yummyIn_P, yummyIn_P_flip1_out);
flip_bus #(1, 10) yummyIn_N_flip2(yummyIn_N_flip1_out, yummyIn_N_internal);
flip_bus #(1, 10) yummyIn_E_flip2(yummyIn_E_flip1_out, yummyIn_E_internal);
flip_bus #(1, 10) yummyIn_S_flip2(yummyIn_S_flip1_out, yummyIn_S_internal);
flip_bus #(1, 10) yummyIn_W_flip2(yummyIn_W_flip1_out, yummyIn_W_internal);
//flip_bus #(1, 10) yummyIn_P_flip2(yummyIn_P_flip1_out, yummyIn_P_internal);

flip_bus #(1, 14) validIn_N_flip1(validIn_N, validIn_N_flip1_out);
flip_bus #(1, 14) validIn_E_flip1(validIn_E, validIn_E_flip1_out);
flip_bus #(1, 14) validIn_S_flip1(validIn_S, validIn_S_flip1_out);
flip_bus #(1, 14) validIn_W_flip1(validIn_W, validIn_W_flip1_out);
//flip_bus #(1, 14) validIn_P_flip1(validIn_P, validIn_P_flip1_out);
flip_bus #(1, 10) validIn_N_flip2(validIn_N_flip1_out, validIn_N_internal);
flip_bus #(1, 10) validIn_E_flip2(validIn_E_flip1_out, validIn_E_internal);
flip_bus #(1, 10) validIn_S_flip2(validIn_S_flip1_out, validIn_S_internal);
flip_bus #(1, 10) validIn_W_flip2(validIn_W_flip1_out, validIn_W_internal);
//flip_bus #(1, 10) validIn_P_flip2(validIn_P_flip1_out, validIn_P_internal);

flip_bus #(`DATA_WIDTH, 14) dataIn_N_flip1(dataIn_N, dataIn_N_flip1_out);
flip_bus #(`DATA_WIDTH, 14) dataIn_E_flip1(dataIn_E, dataIn_E_flip1_out);
flip_bus #(`DATA_WIDTH, 14) dataIn_S_flip1(dataIn_S, dataIn_S_flip1_out);
flip_bus #(`DATA_WIDTH, 14) dataIn_W_flip1(dataIn_W, dataIn_W_flip1_out);
//flip_bus #(`DATA_WIDTH, 14) dataIn_P_flip1(dataIn_P, dataIn_P_flip1_out);
flip_bus #(`DATA_WIDTH, 10) dataIn_N_flip2(dataIn_N_flip1_out, dataIn_N_internal);
flip_bus #(`DATA_WIDTH, 10) dataIn_E_flip2(dataIn_E_flip1_out, dataIn_E_internal);
flip_bus #(`DATA_WIDTH, 10) dataIn_S_flip2(dataIn_S_flip1_out, dataIn_S_internal);
flip_bus #(`DATA_WIDTH, 10) dataIn_W_flip2(dataIn_W_flip1_out, dataIn_W_internal);
//flip_bus #(`DATA_WIDTH, 10) dataIn_P_flip2(dataIn_P_flip1_out, dataIn_P_internal);
*/

//instantiations


//the following dense code impliments a full crossbar.
//The two main components are a dynamic_input_top_X and a dynamic_output_top_para

//the difference between dynamic_input_top_4_para and dynamic_input_top_16_para are the size of
//the nibs inside of them.

//dynamic inputs
<%
for a in range (DYNAMIC_NODE_PORT):
  if (a == DYNAMIC_NODE_PORT - 1):
    s_init = "dynamic_input_top_4_para node_%d_input(" % a
    s_1 = "validIn_%d" % a
    s_2 = "dataIn_%d" % a
  else:
    s_init = "dynamic_input_top_4_para node_%d_input(" % a
    s_1 = "validIn_%d_internal" % a
    s_2 = "dataIn_%d_internal" % a  
  s_route_req_out = dynamic_node_para_define.string_ports_oneline_2("", ".route_req_%%d_out(route_req_%d_to_%%d), " % a)
  s_default_ready_out = ""
  dynamic_node_para_define.string_ports_oneline("", ".default_ready_%d_out(), ") #ignoring defualt_readys
  for b in range (DYNAMIC_NODE_PORT):
    cur_dir = dynamic_node_para_define.gen_default_dir(b)
    if (cur_dir == a):
      s_default_ready_out = s_default_ready_out + ".default_ready_%d_out(default_ready_%d_to_%d), " % (b, a, b)
    else:
      s_default_ready_out = s_default_ready_out + ".default_ready_%d_out(), " % b
  s_thanks = dynamic_node_para_define.string_ports_oneline_2("", ".thanks_%%d(thanks_%%d_to_%d), " % a)
  s_out = s_init
  s_out = s_out + s_route_req_out + s_default_ready_out
  s_out = s_out + ".tail_out(node_%d_input_tail), " % a
  s_out = s_out + ".yummy_out(yummyOut_%d_internal), " % a
  s_out = s_out + ".data_out(node_%d_input_data), " % a
  s_out = s_out + ".valid_out(node_%d_input_valid), " % a
  s_out = s_out + ".clk(clk), "
  s_out = s_out + ".reset(reset), "
  s_out = s_out + ".my_loc_x_in(myLocX_f), "
  s_out = s_out + ".my_loc_y_in(myLocY_f), "
  s_out = s_out + ".my_chip_id_in(myChipID_f), "
  s_out = s_out + ".valid_in(%s), " % s_1
  s_out = s_out + ".data_in(%s), " % s_2
  s_out = s_out + s_thanks;
  print (s_out[:-2] + ");")
%>
/*
//original
dynamic_input_top_4 north_input(.route_req_n_out(route_req_n_to_n), .route_req_e_out(route_req_n_to_e), .route_req_s_out(route_req_n_to_s), .route_req_w_out(route_req_n_to_w), .route_req_p_out(route_req_n_to_p), .default_ready_n_out(), .default_ready_e_out(), .default_ready_s_out(default_ready_n_to_s), .default_ready_w_out(), .default_ready_p_out(), .tail_out(north_input_tail), .yummy_out(yummyOut_N_internal), .data_out(north_input_data), .valid_out(north_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_N_internal), .data_in(dataIn_N_internal), .thanks_n(thanks_n_to_n), .thanks_e(thanks_e_to_n), .thanks_s(thanks_s_to_n), .thanks_w(thanks_w_to_n), .thanks_p(thanks_p_to_n));

dynamic_input_top_4 east _input(.route_req_n_out(route_req_e_to_n), .route_req_e_out(route_req_e_to_e), .route_req_s_out(route_req_e_to_s), .route_req_w_out(route_req_e_to_w), .route_req_p_out(route_req_e_to_p), .default_ready_n_out(), .default_ready_e_out(), .default_ready_s_out(), .default_ready_w_out(default_ready_e_to_w), .default_ready_p_out(), .tail_out(east_input_tail), .yummy_out(yummyOut_E_internal), .data_out(east_input_data), .valid_out(east_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_E_internal), .data_in(dataIn_E_internal), .thanks_n(thanks_n_to_e), .thanks_e(thanks_e_to_e), .thanks_s(thanks_s_to_e), .thanks_w(thanks_w_to_e), .thanks_p(thanks_p_to_e));

dynamic_input_top_4 south_input(.route_req_n_out(route_req_s_to_n), .route_req_e_out(route_req_s_to_e), .route_req_s_out(route_req_s_to_s), .route_req_w_out(route_req_s_to_w), .route_req_p_out(route_req_s_to_p), .default_ready_n_out(default_ready_s_to_n), .default_ready_e_out(), .default_ready_s_out(), .default_ready_w_out(), .default_ready_p_out(default_ready_s_to_p), .tail_out(south_input_tail), .yummy_out(yummyOut_S_internal), .data_out(south_input_data), .valid_out(south_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_S_internal), .data_in(dataIn_S_internal), .thanks_n(thanks_n_to_s), .thanks_e(thanks_e_to_s), .thanks_s(thanks_s_to_s), .thanks_w(thanks_w_to_s), .thanks_p(thanks_p_to_s));

dynamic_input_top_4 west_input(.route_req_n_out(route_req_w_to_n), .route_req_e_out(route_req_w_to_e), .route_req_s_out(route_req_w_to_s), .route_req_w_out(route_req_w_to_w), .route_req_p_out(route_req_w_to_p), .default_ready_n_out(), .default_ready_e_out(default_ready_w_to_e), .default_ready_s_out(), .default_ready_w_out(), .default_ready_p_out(), .tail_out(west_input_tail), .yummy_out(yummyOut_W_internal), .data_out(west_input_data), .valid_out(west_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_W_internal), .data_in(dataIn_W_internal), .thanks_n(thanks_n_to_w), .thanks_e(thanks_e_to_w), .thanks_s(thanks_s_to_w), .thanks_w(thanks_w_to_w), .thanks_p(thanks_p_to_w));

dynamic_input_top_16 proc_input(.route_req_n_out(route_req_p_to_n), .route_req_e_out(route_req_p_to_e), .route_req_s_out(route_req_p_to_s), .route_req_w_out(route_req_p_to_w), .route_req_p_out(route_req_p_to_p), .default_ready_n_out(), .default_ready_e_out(), .default_ready_s_out(), .default_ready_w_out(), .default_ready_p_out(), .tail_out(proc_input_tail), .yummy_out(yummyOut_P_internal), .data_out(proc_input_data), .valid_out(proc_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_P), .data_in(dataIn_P), .thanks_n(thanks_n_to_p), .thanks_e(thanks_e_to_p), .thanks_s(thanks_s_to_p), .thanks_w(thanks_w_to_p), .thanks_p(thanks_p_to_p));
*/


//dynamic outputs
<%
for a in range (DYNAMIC_NODE_PORT):
  default_dir = 0
  if (a == DYNAMIC_NODE_PORT - 1):
    default_dir = int((0 + (DYNAMIC_NODE_PORT - 1) / 2) % (DYNAMIC_NODE_PORT - 1))
    s_init = "dynamic_output_top_para #(1'b0) node_%d_output(" % a
    s_1 = ".popped_interrupt_mesg_out(external_interrupt), .popped_memory_ack_mesg_out(store_ack_received), .popped_memory_ack_mesg_out_sender(store_ack_addr), "
  else:
    default_dir = int((a + (DYNAMIC_NODE_PORT - 1) / 2) % (DYNAMIC_NODE_PORT - 1))
    s_init = "dynamic_output_top_para node_%d_output(" % a
    s_1 = ".popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), "
  # sequence for input output mapping
  map_list = []
  for i in range (default_dir, default_dir + DYNAMIC_NODE_PORT):
    if (i % DYNAMIC_NODE_PORT != a):
      map_list.append(i % DYNAMIC_NODE_PORT)
  map_list.append(a)
  s_out = s_init
  s_out = s_out + ".data_out(dataOut_%d_internal), " % a
  for b in range (DYNAMIC_NODE_PORT):
    s_out = s_out + ".thanks_%d_out(thanks_%d_to_%d), " % (b, a, map_list[b])
  s_out = s_out + ".valid_out(validOut_%d_internal), " % a
  s_out = s_out + s_1
  s_out = s_out + ".ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_%d), " % a
  s_out = s_out + ".clk(clk), "
  s_out = s_out + ".reset(reset), "
  for b in range (DYNAMIC_NODE_PORT):
    s_out = s_out + ".route_req_%d_in(route_req_%d_to_%d), " % (b, map_list[b], a)
  for b in range (DYNAMIC_NODE_PORT):
    s_out = s_out + ".tail_%d_in(node_%d_input_tail), " % (b, map_list[b])  
  for b in range (DYNAMIC_NODE_PORT):
    s_out = s_out + ".data_%d_in(node_%d_input_data), " % (b, map_list[b])
  for b in range (DYNAMIC_NODE_PORT):
    s_out = s_out + ".valid_%d_in(node_%d_input_valid), " % (b, map_list[b])
  s_out = s_out + ".default_ready_in(default_ready_%d_to_%d)," % (dynamic_node_para_define.gen_default_dir(a), a)
  s_out = s_out + ".yummy_in(yummyIn_%d_internal));" % a
  print (s_out)
%>
/*
//original
dynamic_output_top north_output(.data_out(dataOut_N_internal), .thanks_a_out(thanks_n_to_s), .thanks_b_out(thanks_n_to_w), .thanks_c_out(thanks_n_to_p), .thanks_d_out(thanks_n_to_e), .thanks_x_out(thanks_n_to_n), .valid_out(validOut_N_internal),  .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_N), .clk(clk), .reset(reset), .route_req_a_in(route_req_s_to_n), .route_req_b_in(route_req_w_to_n), .route_req_c_in(route_req_p_to_n), .route_req_d_in(route_req_e_to_n), .route_req_x_in(route_req_n_to_n), .tail_a_in(south_input_tail), .tail_b_in(west_input_tail), .tail_c_in(proc_input_tail), .tail_d_in(east_input_tail), .tail_x_in(north_input_tail), .data_a_in(south_input_data), .data_b_in(west_input_data), .data_c_in(proc_input_data), .data_d_in(east_input_data), .data_x_in(north_input_data), .valid_a_in(south_input_valid), .valid_b_in(west_input_valid), .valid_c_in(proc_input_valid), .valid_d_in(east_input_valid), .valid_x_in(north_input_valid), .default_ready_in(default_ready_s_to_n), .yummy_in(yummyIn_N_internal));

dynamic_output_top east_output(.data_out(dataOut_E_internal), .thanks_a_out(thanks_e_to_w), .thanks_b_out(thanks_e_to_p), .thanks_c_out(thanks_e_to_n), .thanks_d_out(thanks_e_to_s), .thanks_x_out(thanks_e_to_e), .valid_out(validOut_E_internal),   .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_E), .clk(clk), .reset(reset), .route_req_a_in(route_req_w_to_e), .route_req_b_in(route_req_p_to_e), .route_req_c_in(route_req_n_to_e), .route_req_d_in(route_req_s_to_e), .route_req_x_in(route_req_e_to_e), .tail_a_in(west_input_tail), .tail_b_in(proc_input_tail), .tail_c_in(north_input_tail), .tail_d_in(south_input_tail), .tail_x_in(east_input_tail), .data_a_in(west_input_data), .data_b_in(proc_input_data), .data_c_in(north_input_data), .data_d_in(south_input_data), .data_x_in(east_input_data), .valid_a_in(west_input_valid), .valid_b_in(proc_input_valid), .valid_c_in(north_input_valid), .valid_d_in(south_input_valid), .valid_x_in(east_input_valid), .default_ready_in(default_ready_w_to_e), .yummy_in(yummyIn_E_internal));

dynamic_output_top south_output(.data_out(dataOut_S_internal), .thanks_a_out(thanks_s_to_n), .thanks_b_out(thanks_s_to_e), .thanks_c_out(thanks_s_to_w), .thanks_d_out(thanks_s_to_p), .thanks_x_out(thanks_s_to_s), .valid_out(validOut_S_internal),   .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_S), .clk(clk), .reset(reset), .route_req_a_in(route_req_n_to_s), .route_req_b_in(route_req_e_to_s), .route_req_c_in(route_req_w_to_s), .route_req_d_in(route_req_p_to_s), .route_req_x_in(route_req_s_to_s), .tail_a_in(north_input_tail), .tail_b_in(east_input_tail), .tail_c_in(west_input_tail), .tail_d_in(proc_input_tail), .tail_x_in(south_input_tail), .data_a_in(north_input_data), .data_b_in(east_input_data), .data_c_in(west_input_data), .data_d_in(proc_input_data), .data_x_in(south_input_data), .valid_a_in(north_input_valid), .valid_b_in(east_input_valid), .valid_c_in(west_input_valid), .valid_d_in(proc_input_valid), .valid_x_in(south_input_valid), .default_ready_in(default_ready_n_to_s), .yummy_in(yummyIn_S_internal));

dynamic_output_top west_output(.data_out(dataOut_W_internal), .thanks_a_out(thanks_w_to_e), .thanks_b_out(thanks_w_to_s), .thanks_c_out(thanks_w_to_p), .thanks_d_out(thanks_w_to_n), .thanks_x_out(thanks_w_to_w), .valid_out(validOut_W_internal),   .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_W), .clk(clk), .reset(reset), .route_req_a_in(route_req_e_to_w), .route_req_b_in(route_req_s_to_w), .route_req_c_in(route_req_p_to_w), .route_req_d_in(route_req_n_to_w), .route_req_x_in(route_req_w_to_w), .tail_a_in(east_input_tail), .tail_b_in(south_input_tail), .tail_c_in(proc_input_tail), .tail_d_in(north_input_tail), .tail_x_in(west_input_tail), .data_a_in(east_input_data), .data_b_in(south_input_data), .data_c_in(proc_input_data), .data_d_in(north_input_data), .data_x_in(west_input_data), .valid_a_in(east_input_valid), .valid_b_in(south_input_valid), .valid_c_in(proc_input_valid), .valid_d_in(north_input_valid), .valid_x_in(west_input_valid), .default_ready_in(default_ready_e_to_w), .yummy_in(yummyIn_W_internal));
//yanqi change kill headers to 0
dynamic_output_top #(1'b0) proc_output(.data_out(dataOut_P_internal), .thanks_a_out(thanks_p_to_s), .thanks_b_out(thanks_p_to_w), .thanks_c_out(thanks_p_to_n), .thanks_d_out(thanks_p_to_e), .thanks_x_out(thanks_p_to_p), .valid_out(validOut_P_internal),  .popped_interrupt_mesg_out(external_interrupt), .popped_memory_ack_mesg_out(store_ack_received), .popped_memory_ack_mesg_out_sender(store_ack_addr),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_P), .clk(clk), .reset(reset), .route_req_a_in(route_req_s_to_p), .route_req_b_in(route_req_w_to_p), .route_req_c_in(route_req_n_to_p), .route_req_d_in(route_req_e_to_p), .route_req_x_in(route_req_p_to_p), .tail_a_in(south_input_tail), .tail_b_in(west_input_tail), .tail_c_in(north_input_tail), .tail_d_in(east_input_tail), .tail_x_in(proc_input_tail), .data_a_in(south_input_data), .data_b_in(west_input_data), .data_c_in(north_input_data), .data_d_in(east_input_data), .data_x_in(proc_input_data), .valid_a_in(south_input_valid), .valid_b_in(west_input_valid), .valid_c_in(north_input_valid), .valid_d_in(east_input_valid), .valid_x_in(proc_input_valid), .default_ready_in(default_ready_s_to_p), .yummy_in(yummyIn_P_internal));
*/

endmodule // dynamic_node

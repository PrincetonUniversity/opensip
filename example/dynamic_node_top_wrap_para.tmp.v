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

//File: dynamic_node_top_wrap.v
////Creator: Michael McKeown
////Created: Sept. 21, 2014
////
////Function: This wraps the dynamic_node top and ties off signals
//            we will not be using at the tile level
////
////State: 
////
////Instantiates: dynamic_node_top
////
////

`include "define.tmp.h"

module dynamic_node_top_wrap_para
(
    input clk,
    input reset_in,
    
    input [`DATA_WIDTH-1:0] dataIn_0,
    input [`DATA_WIDTH-1:0] dataIn_1,
    input [`DATA_WIDTH-1:0] dataIn_2,

    input validIn_0,
    input validIn_1,
    input validIn_2,

    input yummyIn_0,
    input yummyIn_1,
    input yummyIn_2,

    /*
    //original
    input [`DATA_WIDTH-1:0] dataIn_N,   // data inputs from neighboring tiles
    input [`DATA_WIDTH-1:0] dataIn_E,
    input [`DATA_WIDTH-1:0] dataIn_S,
    input [`DATA_WIDTH-1:0] dataIn_W,
    input [`DATA_WIDTH-1:0] dataIn_P,   // data input from processor
       
    input validIn_N,        // valid signals from neighboring tiles
    input validIn_E,
    input validIn_S,
    input validIn_W,
    input validIn_P,        // valid signal from processor
       
    input yummyIn_N,        // neighbor consumed output data
    input yummyIn_E,
    input yummyIn_S,
    input yummyIn_W,
    input yummyIn_P,        // processor consumed output data
    */   
    input [`XY_WIDTH-1:0] myLocX,       // this tile's position
    input [`XY_WIDTH-1:0] myLocY,
    input [`CHIP_ID_WIDTH-1:0] myChipID,
    
    output [`DATA_WIDTH-1:0] dataOut_0,
    output [`DATA_WIDTH-1:0] dataOut_1,
    output [`DATA_WIDTH-1:0] dataOut_2,

    output validOut_0,
    output validOut_1,
    output validOut_2,

    output yummyOut_0,
    output yummyOut_1,
    output yummyOut_2,


    /*
    //original
    output [`DATA_WIDTH-1:0] dataOut_N, // data outputs to neighbors
    output [`DATA_WIDTH-1:0] dataOut_E,
    output [`DATA_WIDTH-1:0] dataOut_S,
    output [`DATA_WIDTH-1:0] dataOut_W,
    output [`DATA_WIDTH-1:0] dataOut_P, // data output to processor
    
    output validOut_N,      // valid outputs to neighbors
    output validOut_E,
    output validOut_S,
    output validOut_W,
    output validOut_P,      // valid output to processor
       
    output yummyOut_N,      // yummy signal to neighbors' output buffers
    output yummyOut_E,
    output yummyOut_S,
    output yummyOut_W,
    output yummyOut_P,      // yummy signal to processor's output buffer
    */
    
    output thanksIn_2      // thanksIn to processor's space_avail
);

    dynamic_node_top_para dynamic_node_top
    (
        .clk(clk),
        .reset_in(reset_in),
        
        .dataIn_0(dataIn_0),
        .dataIn_1(dataIn_1),
        .dataIn_2(dataIn_2),
        .validIn_0(validIn_0),
        .validIn_1(validIn_1),
        .validIn_2(validIn_2),
        .yummyIn_0(yummyIn_0),
        .yummyIn_1(yummyIn_1),
        .yummyIn_2(yummyIn_2),

        .myLocX(myLocX),
        .myLocY(myLocY),
        .myChipID(myChipID),
        .ec_cfg(9'b0),
        .store_meter_partner_address_X(5'b0),
        .store_meter_partner_address_Y(5'b0),
        
        .dataOut_0(dataOut_0),
        .dataOut_1(dataOut_1),
        .dataOut_2(dataOut_2),
        .validOut_0(validOut_0),
        .validOut_1(validOut_1),
        .validOut_2(validOut_2),
        .yummyOut_0(yummyOut_0),
        .yummyOut_1(yummyOut_1),
        .yummyOut_2(yummyOut_2),

        .thanksIn_2(thanksIn_2),
        .external_interrupt(),
        .store_meter_ack_partner(),
        .store_meter_ack_non_partner(),
        .ec_out()
    ); 

endmodule

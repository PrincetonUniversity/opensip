#!/usr/bin/env python3
# Copyright (c) 2022 Princeton University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Princeton University nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import os
import json

config = json.load(open('scripts/config.json'))
soc_nocs_num = int(config['soc_nocs_num'])
noc_width = int(config['noc_width'])
sip_nocs_num = int(config['sip_nocs_num'])
config_chipid_x = int(config['config_chipid_x'])
config_chipid_y = int(config['config_chipid_y'])
noc_mapping = config['noc_mapping']
chipid_bits = config['chipid_bits']
x_dim = config['x_dim']
y_dim = config['y_dim']


def str_NEWS_intf(id: int):
  return f'''\
    input nop{id}_Sin_data[{noc_width-1}:0],
    input nop{id}_Sin_valid,
    output nop{id}_Sin_credit, 
    output nop{id}_Sout_data[{noc_width-1}:0],
    output nop{id}_Sout_valid,
    input nop{id}_Sout_credit,
    input nop{id}_Ein_data[{noc_width-1}:0],
    input nop{id}_Ein_valid,
    output nop{id}_Ein_credit,
    output nop{id}_Eout_data[{noc_width-1}:0],
    output nop{id}_Eout_valid,
    input nop{id}_Eout_credit,
    input nop{id}_Win_data[{noc_width-1}:0],
    input nop{id}_Win_valid,
    output nop{id}_Win_credit,
    output nop{id}_Wout_data[{noc_width-1}:0],
    output nop{id}_Wout_valid,
    input nop{id}_Wout_credit,
    input nop{id}_Nin_data[{noc_width-1}:0],
    input nop{id}_Nin_valid,
    output nop{id}_Nin_credit,
    output nop{id}_Nout_data[{noc_width-1}:0],
    output nop{id}_Nout_valid,
    input nop{id}_Nout_credit,\
'''

def str_NEWS_inst(id: int):
  return f'''\
    .nop{id}_Sin_data(nop{id}_Sin_data),
    .nop{id}_Sin_valid(nop{id}_Sin_valid),
    .nop{id}_Sin_credit(nop{id}_Sin_credit),
    .nop{id}_Sout_data(nop{id}_Sout_data),
    .nop{id}_Sout_valid(nop{id}_Sout_valid),
    .nop{id}_Sout_credit(nop{id}_Sout_credit),
    .nop{id}_Ein_data(nop{id}_Ein_data),
    .nop{id}_Ein_valid(nop{id}_Ein_valid),
    .nop{id}_Ein_credit(nop{id}_Ein_credit),
    .nop{id}_Eout_data(nop{id}_Eout_data),
    .nop{id}_Eout_valid(nop{id}_Eout_valid),
    .nop{id}_Eout_credit(nop{id}_Eout_credit),
    .nop{id}_Win_data(nop{id}_Win_data),
    .nop{id}_Win_valid(nop{id}_Win_valid),
    .nop{id}_Win_credit(nop{id}_Win_credit),
    .nop{id}_Wout_data(nop{id}_Wout_data),
    .nop{id}_Wout_valid(nop{id}_Wout_valid),
    .nop{id}_Wout_credit(nop{id}_Wout_credit),
    .nop{id}_Nin_data(nop{id}_Nin_data),
    .nop{id}_Nin_valid(nop{id}_Nin_valid),
    .nop{id}_Nin_credit(nop{id}_Nin_credit),
    .nop{id}_Nout_data(nop{id}_Nout_data),
    .nop{id}_Nout_valid(nop{id}_Nout_valid),
    .nop{id}_Nout_credit(nop{id}_Nout_credit),\
'''

def str_P_intf(id: int):
  return f'''\
    input noc{id}_Pin_data[{noc_width-1}:0],
    input noc{id}_Pin_valid,
    output noc{id}_Pin_credit, 
    output noc{id}_Pout_data[{noc_width-1}:0],
    output noc{id}_Pout_valid,
    input noc{id}_Pout_credit,\
'''

def str_P_inst(id: int):
  return f'''\
    .noc{id}_Pin_data(noc{id}_Pin_data),
    .noc{id}_Pin_valid(noc{id}_Pin_valid),
    .noc{id}_Pin_credit(noc{id}_Pin_credit),
    .noc{id}_Pout_data(noc{id}_Pout_data),
    .noc{id}_Pout_valid(noc{id}_Pout_valid),
    .noc{id}_Pout_credit(noc{id}_Pout_credit),\
'''



def str_P_wiring(id: int):
  return f'''\
    wire noc{id}_Pin_data[{noc_width-1}:0];
    wire noc{id}_Pin_valid;
    wire noc{id}_Pin_credit;
    wire noc{id}_Pout_data[{noc_width-1}:0];
    wire noc{id}_Pout_valid;
    wire noc{id}_Pout_credit;\
'''

def str_multiplexer_inst(id: int):
  s =  f'''\
sip_multiplexer_{id} sip_multiplexer_{id} (
    .clk(clk),
    .rst_n(rst_n),
  '''
  for i in noc_mapping[str(id)]:
    s += f'''
    .noc{i}_Pin_data(noc{i}_Pin_data),
    .noc{i}_Pin_valid(noc{i}_Pin_valid),
    .noc{i}_Pin_read(noc{i}_Pin_ready)'''
  s += f''',
    .nop{id}_Pin_data(nop{id}_Pin_vr_data),
    .nop{id}_Pin_valid(nop{id}_Pin_vr_valid),
    .nop{id}_Pin_ready(nop{id}_Pin_vr_ready)
);
'''
  return s

def str_demultiplexer_inst(id: int):
  s =  f'''\
sip_demultiplexer_{id} sip_demultiplexer_{id} (
    .clk(clk),
    .rst_n(rst_n),
  '''
  for i in noc_mapping[str(id)]:
    s += f'''
    .noc{i}_Pout_data(noc{i}_Pout_data),
    .noc{i}_Pout_valid(noc{i}_Pout_valid),
    .noc{i}_Pout_ready(noc{i}_Pout_ready)'''
  s += f''',
    .nop{id}_Pout_vr_data(nop{id}_Pout_vr_data),
    .nop{id}_Pout_vr_valid(nop{id}_Pout_vr_valid),
    .nop{id}_Pout_vr_ready(nop{id}_Pout_vr_ready)
);
'''
  return s

def str_router_inst(id: int):
  s =  f'''\
sip_router sip_router_{id} (
    .clk(clk),
    .rst_n(rst_n),
    .config_chipid_x(config_chipid_x),
    .config_chipid_y(config_chipid_y),
  '''
  for dir in ['S', 'E', 'W', 'N', 'P']:
    s += f'''
    .nop_{dir}in_data(nop{id}_{dir}in_data),
    .nop_{dir}in_valid(nop{id}_{dir}in_valid),
    .nop_{dir}in_credit(nop{id}_{dir}in_credit),
    .nop_{dir}out_data(nop{id}_{dir}out_data),
    .nop_{dir}out_valid(nop{id}_{dir}out_valid),
    .nop_{dir}out_credit(nop{id}_{dir}out_credit)'''
  s += f'''
);
'''
  return s


def str_mux_wiring(id: int):
  s = f'''\
    wire nop{id}_Pin_vr_data[{noc_width-1}:0];
    wire nop{id}_Pin_vr_valid;
    wire nop{id}_Pin_vr_ready;\
'''
  return s

def str_demux_wiring(id: int):
  s = f'''\
    wire nop{id}_Pout_vr_data[{noc_width-1}:0];
    wire nop{id}_Pout_vr_valid;
    wire nop{id}_Pout_vr_ready;\
'''
  return s

def str_router_definition(id: int):
  s = f'''\
module sip_router_{id} (
  input clk,
  input rst_n,
  input [:0] config_chipid_x, 
  input [:0] config_chipid_y,
  
  input [{noc_width-1}:0] nop{id}_Sin_data,
  input nop{id}_Sin_valid,
  output nop{id}_Sin_credit,
  input [{noc_width-1}:0] nop{id}_Ein_data,
  input nop{id}_Ein_valid,
  output nop{id}_Ein_credit,
  input [{noc_width-1}:0] nop{id}_Win_data,
  input nop{id}_Win_valid,
  output nop{id}_Win_credit,
  input [{noc_width-1}:0] nop{id}_Nin_data,
  input nop{id}_Nin_valid,
  output nop{id}_Nin_credit,
  output [{noc_width-1}:0] nop{id}_Sout_data,
  output nop{id}_Sout_valid,
  input nop{id}_Sout_credit,
  output [{noc_width-1}:0] nop{id}_Eout_data,
  output nop{id}_Eout_valid,
  input nop{id}_Eout_credit,
  output [{noc_width-1}:0] nop{id}_Wout_data,
  output nop{id}_Wout_valid,
  input nop{id}_Wout_credit,
  output [{noc_width-1}:0] nop{id}_Nout_data,
  output nop{id}_Nout_valid,
  input nop{id}_Nout_credit,
  
  input [{noc_width-1}:0] nop{id}_Pin_data,
  input nop{id}_Pin_valid,
  output nop{id}_Pin_credit,
  input [{noc_width-1}:0] nop{id}_Pout_data,
  input nop{id}_Pout_valid,
  output nop{id}_Pout_credit
);
'''
  return s

def str_multiplexer_definition(id: int):
  s = f'''\
module sip_multiplexer_{id} (
  input clk,
  input rst_n,
'''
  for i in noc_mapping[str(id)]:
    s += f'''
  input [{noc_width-1}:0] noc{i}_Pin_data,
  input noc{i}_Pin_valid,
  output noc{i}_Pin_ready,'''
  s += f'''
  output [{noc_width-1}:0] nop{id}_Pin_vr_data,
  output nop{id}_Pin_vr_valid,
  input nop{id}_Pin_vr_ready
);
'''
  return s

def str_demultiplexer_definition(id: int):
  s = f'''\
module sip_demultiplexer_{id} (
  input clk,
  input rst_n,
'''
  for i in noc_mapping[str(id)]:
    s += f'''
  output [{noc_width-1}:0] noc{i}_Pout_data,
  output noc{i}_Pout_valid,
  input noc{i}_Pout_ready,'''
  s += f'''
  input [{noc_width-1}:0] nop{id}_Pout_vr_data,
  input nop{id}_Pout_vr_valid,
  output nop{id}_Pout_vr_ready
);
'''
  return s

def str_multiplexer_implementation(id: int): 
  s = f'''\
noc_prio_merger noc_prio_merger(
  .clk(clk),
  .rst_n(rst_n),
  .num_sources({len(noc_mapping[str(id)])}),'''
  for i in noc_mapping[str(id)]:
    s += f'''
  .src{i}_merger_vr_noc_dat(noc{i}_Pin_data),
  .src{i}_merger_vr_noc_val(noc{i}_Pin_valid),
  .src{i}_merger_vr_noc_rdy(noc{i}_Pin_ready),'''
  s += f'''
  .merger_dst_vr_noc_dat(nop{i}_Pin_vr_data),
  .merger_dst_vr_noc_val(nop{i}_Pin_vr_valid),
  .merger_dst_vr_noc_rdy(nop{i}_Pin_vr_ready),'''
  s = s[:-1] + f'''
);
endmodule
  '''
  return s

def str_demultiplexer_implementation(id: int):
  s = f'''\
noc_fbits_splitter noc_fbits_splitter(
  .clk(clk),
  .rst_n(rst_n),
  .num_targets({len(noc_mapping[str(id)])}),'''
  for i in noc_mapping[str(id)]:
    s += f'''
  .splitter_dst{i}_vr_noc_dat(noc{i}_Pout_data),
  .splitter_dst{i}_vr_noc_val(noc{i}_Pout_valid),
  .splitter_dst{i}_vr_noc_rdy(noc{i}_Pout_ready),
  .fbits_type{i}(),'''
  s += f'''
  .src_splitter_vr_noc_dat(nop{i}_Pout_vr_data),
  .src_splitter_vr_noc_val(nop{i}_Pout_vr_valid),
  .src_splitter_vr_noc_rdy(nop{i}_Pout_vr_ready),'''
  s = s[:-1] + f'''
);
endmodule
  '''
  return s

def str_v2c_inst(id: int):
  s = f'''\
valrdy_to_credit noc{id}_v2c(
  .clk(clk),
  .reset(~rst_n),

  .data_in(nop{id}_Pin_vr_data),
  .valid_in(nop{id}_Pin_vr_valid),
  .ready_in(nop{id}_Pin_vr_ready),
  .data_out(nop{id}_Pin_data),
  .valid_out(nop{id}_Pin_valid),
  .yummy_out(nop{id}_Pin_credit),
);
'''
  return s

def str_c2v_inst(id: int):
  s = f'''\
credit_to_valrdy noc{id}_c2v(
  .clk(clk),
  .reset(~rst_n),

  .data_in(nop{id}_Pout_data),
  .valid_in(nop{id}_Pout_valid),
  .yummy_in(nop{id}_Pout_credit),

  .data_out(nop{id}_Pout_vr_data),
  .valid_out(nop{id}_Pout_vr_valid),
  .ready_out(nop{id}_Pout_vr_ready),
);
'''
  return s

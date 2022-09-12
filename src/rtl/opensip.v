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

<%
import os
import sys
sys.path.append(os.path.join(os.getcwd(), 'scripts'))
from opensip_utils import *
%>

module opensip(
    input clk, 
    input rst_n, 

<%  
s = ''
for i in range(sip_nocs_num):
    s += str_NEWS_intf(i) + '\n'
print(s[:-2])
%>
);

<% 
s = ''
for i in range(soc_nocs_num):
    s += str_P_wiring(i) + '\n'
print(s[:-1])
%>

<%
s = ''
s += f'wire [:0] config_chipid_x = {config_chipid_x};\n'
s += f'wire [:0] config_chipid_y = {config_chipid_y};\n'
print(s)
%>

sip_interconnect sip_interconnect(
    .clk(clk),
    .rst_n(rst_n),
    .config_chipid_x(config_chipid_x),
    .config_chipid_y(config_chipid_y),
    
<% 
s = ''
for i in range(sip_nocs_num):
    s += str_NEWS_inst(i) + '\n'
for i in range(soc_nocs_num):
    s += str_P_inst(i) + '\n'
print(s[:-2])
%>
);

// chip instantiation

chip chip(

    // ...
    
<%
s = ''
for i in range(soc_nocs_num):
    s += str_P_inst(i) + '\n'
print(s[:-2])
%>
);


endmodule
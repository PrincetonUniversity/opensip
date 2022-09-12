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
<%
import os
import sys
sys.path.append(os.path.join(os.getcwd(), 'src/dynamic_node/parameter'))
import dynamic_node_para_define
DYNAMIC_NODE_PORT_P_3 = dynamic_node_para_define.DYNAMIC_NODE_PORT_P_3
DYNAMIC_NODE_PORT_P_3_LOG2 = dynamic_node_para_define.DYNAMIC_NODE_PORT_P_3_LOG2
%>
module one_of_n_plus_3(
  <%
  print("")
  for a in range (DYNAMIC_NODE_PORT_P_3):
    s = "  in%d," % a
    print(s)
  %>
  sel,
  out);
    parameter WIDTH = 8;
    parameter BHC = 10;
    input [<%= DYNAMIC_NODE_PORT_P_3_LOG2 - 1%>:0] sel;
    <%
    s1 = ""
    for a in range (DYNAMIC_NODE_PORT_P_3):
      s1 = s1 + ("in%d," % a)
    %>
    input [WIDTH-1:0] <%= s1[:-1]%>;
    output reg [WIDTH-1:0] out;
    always@(*)
    begin
        out={WIDTH{1'b0}};
        case(sel)
        <%
        print("")
        for a in range (DYNAMIC_NODE_PORT_P_3):
          s = "            %d'd%d:out=in%d;" % (DYNAMIC_NODE_PORT_P_3_LOG2, a, a)
          print(s)
        %>
            default:; // indicates null
        endcase
    end
endmodule



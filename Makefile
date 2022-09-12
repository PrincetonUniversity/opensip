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



# all: generated/opensip.tmp.v generated/all.tmp.Flist

# generated/all.Flist: src/opensip.Flist
# 	python3 flatten_flist.py src/opensip.Flist > generated/all.Flist


# generated/opensip.tmp.v: src/opensip.v.pyv generated/sip_interconnect.tmp.v generated/sip_router.tmp.v generated/sip_multiplexer.tmp.v generated/sip_demultiplexer.tmp.v generated/noc_fbits_splitter.tmp.v generated/noc_prio_merger.tmp.v scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling opensip.v.pyv"
# 	python3 ./scripts/pyhp.py src/opensip.v.pyv > generated/opensip.tmp.v

# generated/sip_interconnect.tmp.v: src/sip_interconnect.v.pyv scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling sip_interconnect.v.pyv"
# 	python3 ./scripts/pyhp.py src/sip_interconnect.v.pyv > generated/sip_interconnect.tmp.v

# generated/sip_multiplexer.tmp.v: src/sip_multiplexer.v.pyv scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling sip_multiplexer.v.pyv"
# 	python3 ./scripts/pyhp.py src/sip_multiplexer.v.pyv > generated/sip_multiplexer.tmp.v

# generated/sip_demultiplexer.tmp.v: src/sip_demultiplexer.v.pyv scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling sip_demultiplexer.v.pyv"
# 	python3 ./scripts/pyhp.py src/sip_demultiplexer.v.pyv > generated/sip_demultiplexer.tmp.v

# generated/sip_router.tmp.v: src/sip_router.v.pyv scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling sip_router.v.pyv"
# 	python3 ./scripts/pyhp.py src/sip_router.v.pyv > generated/sip_router.tmp.v

# generated/noc_prio_merger.tmp.v: src/noc_prio_merger.v.pyv scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling noc_prio_merger.v.pyv"
# 	python3 ./scripts/pyhp.py src/noc_prio_merger.v.pyv > generated/noc_prio_merger.tmp.v

# generated/noc_fbits_splitter.tmp.v: src/noc_fbits_splitter.v.pyv scripts/opensip_utils.py scripts/config.json
# 	@echo "Compiling noc_fbits_splitter.v.pyv"
# 	python3 ./scripts/pyhp.py src/noc_fbits_splitter.v.pyv > generated/noc_fbits_splitter.tmp.v


all:
	@echo "Compiling all.Flist"
	python3 ./scripts/flatten_flist.py src/opensip.Flist > generated/all.Flist
	@while read -r file; do \
 		echo "Compiling $$file"; \
 		python3 ./scripts/pyhp.py $$file > generated/$$(basename $$file .v).tmp.v; \
 	done < generated/all.Flist


clean:
	rm -f generated/*

# Language: makefile
# Path: Makefile

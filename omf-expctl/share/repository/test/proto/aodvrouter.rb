#
# Copyright (c) 2006-2009 National ICT Australia (NICTA), Australia
#
# Copyright (c) 2004-2009 WINLAB, Rutgers University, USA
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#
#
# Define a prototype
#

p = Prototype.create("test:proto:aodvrouter")
p.name = "AODV daemon"
p.description = "Nodes which receive packets"
p.defProperty('interface', 'Interface to listen on')
p.defProperty('log', 'Enable logging')
p.defProperty('routelog', 'Enable logging')

aodvd = p.addApplication('aodvd', "test:app:aodvd")
aodvd.bindProperty('interface')
aodvd.bindProperty('log')
aodvd.bindProperty('rttable','routelog')

aodvd.addMeasurement('receiverport',  Filter::SAMPLE,
  {Filter::SAMPLE_SIZE => 1},
  [
    ['flow_no'],
    ['throughput'],
    ['jitter'],
    ['packet_loss']
  ]
)

if $0 == __FILE__
  p.to_xml.write($stdout, 2)
  puts
end


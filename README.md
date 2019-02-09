# myBus
A sample System Verilog test environment for a simple bus with UVM methodology

This repo provides a sample SV-UVM testbench on top of a simple DUT. The DUT can
accept/ respond few commands as below,
000 - Write command input, instructing DUT to write the input data into the input address
001 - Read command input, instructing DUT to read and send the data back from the input address
010 - Response from DUT for the above read command
011 - Request from DUT to send video data
100 - Response from the TB sending video data packets to DUT
101 - Request from DUT to send some meta data
110 - Response from the TB sending meta data packets to DUT
111 - Unused

The bus has 4 signals,
mode - 3 bit signal indicating the operation
addr - 8 bit signal carrying the address of the operation, unused in DUT outputs
data - 8 bit signal carrying the data of the operation, unused in DUT requests
sel  - Select line indicating a valid transaction on the bus

The DUT is available at /DUT/myBus.sv

The test environment has a sequencer, driver, input monitor, output monitor and a scoreboard.
These components are available in /TB/comps

Sequencer - Feeds the sequences to DUT through driver. The sequences are randomized / direct 
cpu write, cpu read, video packets or meta data packets. 
The sequences are available at /TB/seqLibs
The tests that blow up the environment and call the required sequences are available at /TB/tests

Driver - Gets transaction packet data from sequencer and feeds it into the myBus signals to DUT
interface.
The interface and modport definitions are available at /TB/common

Monitor - A common file is used for both input and output bus monitoring, as both are of the same
bus type. This monitor keeps watch of the bus on either side of the DUT. Whenever a transaction
packet flows through the bus, it sniffs the data and feeds it into the scoreboard. The top level
module myBusTop in /TB/myBusTop.sv, connects the proper interface to the corresponding monitor,
by setting config_db, which is accessed in agent (/TB/comps/agent.sv) and the right handles are
passed to right monitor components.

Scoreboard - This component runs a golden reference model triggered by the packets coming from
input monitor and compares this against the data received from output monitor. This issues error
when there are mismatches.

There are enough comments to indicate different phases of the simulation, when there are multiple
ways of doing something why a specific method is chosen, typical errors that would arise if its
not done in a specific manner.

Please contact me if you would like to know anything more in specific.

Thanks to verification academy which is great resource. Please don't miss it at https://verificationacademy.com/

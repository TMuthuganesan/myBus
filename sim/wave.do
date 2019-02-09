onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Driver
add wave -noupdate /myBusTop/drvIntf/rst
add wave -noupdate /myBusTop/drvIntf/clk
add wave -noupdate /myBusTop/drvIntf/sel
add wave -noupdate /myBusTop/drvIntf/mode
add wave -noupdate /myBusTop/drvIntf/addr
add wave -noupdate /myBusTop/drvIntf/data
add wave -noupdate -divider OutputMonitor
add wave -noupdate /myBusTop/opMonIntf/clk
add wave -noupdate /myBusTop/opMonIntf/rst
add wave -noupdate /myBusTop/opMonIntf/sel
add wave -noupdate /myBusTop/opMonIntf/mode
add wave -noupdate /myBusTop/opMonIntf/addr
add wave -noupdate /myBusTop/opMonIntf/data
add wave -noupdate -divider DUT
add wave -noupdate /myBusTop/DUT/rdReq
add wave -noupdate /myBusTop/DUT/smapReq
add wave -noupdate /myBusTop/DUT/vdoReq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {105000 ps} 0} {{Cursor 2} {545000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2940 ns}

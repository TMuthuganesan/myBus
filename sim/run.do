vlib work
vmap work work
vlog -sv -O0 ../dut/myBus.sv
vlog -sv ../TB/common/interface.sv
vlog -sv +incdir+../TB/baseClasses+../TB/transactions+../TB/common+../TB/comps+../TB/seqLibs+../TB/tests ../TB/common/myPkg.sv
vlog -sv ../TB/myBusTop.sv
vsim -logfile questasim.log -uvmcontrol=all -classdebug -voptargs="+acc=npr" +UVM_TESTNAME=cpuWrRdTest work.myBusTop -do "wave.do"

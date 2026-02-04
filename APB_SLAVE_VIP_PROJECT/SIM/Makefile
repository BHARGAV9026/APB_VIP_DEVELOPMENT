

# SIMULATOR = VCS for Synopsys's VCS
SIMULATOR = VCS
FSDB_PATH=/tools/synopsys/verdi/V-2023.12/share/PLI/VCS/linux64
RTL= ../RTL/*
work= work #library name
SVTB1= ../TB/apb_slave_top.sv
INC = +incdir+../TB  +incdir+../APB_SLAVE_AGENT  #directory names
SVTB2= ../TB/apb_slave_package.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 

VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"
VSIMBATCH5= -c -do  " log -r /* ;coverage save -onexit mem_cov5;run -all; exit"
VSIMBATCH6= -c -do  " log -r /* ;coverage save -onexit mem_cov6;run -all; exit"
VSIMBATCH7= -c -do  " log -r /* ;coverage save -onexit mem_cov7;run -all; exit"
VSIMBATCH8= -c -do  " log -r /* ;coverage save -onexit mem_cov8;run -all; exit"
VSIMBATCH9= -c -do  " log -r /* ;coverage save -onexit mem_cov9;run -all; exit"
VSIMBATCH10= -c -do  " log -r /* ;coverage save -onexit mem_cov10;run -all; exit"



help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                  								!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.  						!"
	@echo "! sv_cmp    	=>  Create library and compile the code.           						!"
	@echo "! run_test1	=>  clean, compile & run the simulation for apb_test in batch mode.		        	!" 
	@echo "! run_test2	=>  clean, compile & run the simulation for master_wr_test in batch mode.			!"
	@echo "! run_test3	=>  clean, compile & run the simulation for master_rd_test in batch mode.			!" 
	@echo "! run_test4	=>  clean, compile & run the simulation for master_wr_rd_test in batch mode.			!" 
	@echo "! run_test5	=>  clean, compile & run the simulation for master_cont_wr_test in batch mode.			!" 
	@echo "! run_test6	=>  clean, compile & run the simulation for master_cont_rd_test in batch mode.			!" 
	@echo "! run_test7	=>  clean, compile & run the simulation for master_n_wr_rd_test in batch mode.			!" 
	@echo "! run_test8	=>  clean, compile & run the simulation for toggle_transfer_test in batch mode.			!" 
	@echo "! run_test9	=>  clean, compile & run the simulation for error_inject_test in batch mode.			!" 
	@echo "! run_test10	=>  clean, compile & run the simulation for inject_addr_error_test in batch mode.		!" 
	@echo "! run_test11	=>  clean, compile & run the simulation for inject_no_wait_states_test in batch mode.		!" 


	@echo "! run_test1_cov	=>  check the code coverage for apb_test in batch mode.	         	!" 
	@echo "! run_test2_cov	=>  check the code coverage for master_wr_test in batch mode.		!" 
	@echo "! run_test3_cov	=>  check the code coverage for master_rd_test in batch mode.		!" 
	@echo "! run_test4_cov	=>  check the code coverage for master_wr_rd_test in batch mode.	        !" 
	@echo "! run_test5_cov	=>  check the code coverage for master_cont_wr_test in batch mode.		!" 
	@echo "! run_test6_cov	=>  check the code coverage for master_cont_rd_test in batch mode.		!" 
	@echo "! run_test7_cov	=>  check the code coverage for master_n_wr_rd_test in batch mode.		!" 
	@echo "! run_test8_cov	=>  check the code coverage for toggle_transfer_test in batch mode.		!" 
	@echo "! run_test9_cov	=>  check the code coverage for error_inject_test in batch mode.		!" 
	@echo "! run_test10_cov	=>  check the code coverage for inject_addr_error_test in batch mode.		!" 
	@echo "! run_test11_cov	=>  check the code coverage for inject_no_wait_states_test in batch mode.		!" 


	@echo "! view_wave1 =>  To view the waveform of apb_test	    						!" 
	@echo "! view_wave2 =>  To view the waveform of master_wr_test	    						!" 
	@echo "! view_wave3 =>  To view the waveform of master_rd_test 	  						!" 
	@echo "! view_wave4 =>  To view the waveform of master_wr_rd_test    							!" 
	@echo "! view_wave5 =>  To view the waveform of master_cont_wr_test    							!" 
	@echo "! view_wave6 =>  To view the waveform of master_cont_rd_test    							!" 
	@echo "! view_wave7 =>  To view the waveform of master_n_wr_rd_test    							!" 
	@echo "! view_wave8 =>  To view the waveform of toggle_transfer_test    						!" 
	@echo "! view_wave9 =>  To view the waveform of error_inject_test    							!"
	@echo "! view_wave10 =>  To view the waveform of inject_addr_error_test    					!"
	@echo "! view_wave11 =>  To view the waveform of inject_no_wait_states_test    					!"

	@echo "! regress    =>  clean, compile and run all testcases in batch mode.		    				!"
	@echo "! report     =>  To merge coverage reports for all testcases and  convert to html format.			!"
	@echo "! code_cov  =>  To open code coverage report for respective test cases.		!"
	@echo "! cov        =>  To open merged coverage report in html format.							!"
	@echo ====================================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)
run_test4 : run_test4_$(SIMULATOR)
run_test5 : run_test5_$(SIMULATOR)
run_test6 : run_test6_$(SIMULATOR)
run_test7 : run_test7_$(SIMULATOR)
run_test8 : run_test8_$(SIMULATOR)
run_test9 : run_test9_$(SIMULATOR)
run_test10 : run_test10_$(SIMULATOR)
run_test11 : run_test11_$(SIMULATOR)

view_wave1 : view_wave1_$(SIMULATOR)
view_wave2 : view_wave2_$(SIMULATOR)
view_wave3 : view_wave3_$(SIMULATOR)
view_wave4 : view_wave4_$(SIMULATOR)
view_wave5 : view_wave5_$(SIMULATOR)
view_wave6 : view_wave6_$(SIMULATOR)
view_wave7 : view_wave7_$(SIMULATOR)
view_wave8 : view_wave8_$(SIMULATOR)
view_wave9 : view_wave9_$(SIMULATOR)
view_wave10 : view_wave10_$(SIMULATOR)
view_wave11 : view_wave11_$(SIMULATOR)

regress : regress_$(SIMULATOR)
report : report_$(SIMULATOR)
cov : cov_$(SIMULATOR)
code_cov : code_cov_$(SIMULATOR)

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------#

sv_cmp_VCS:
	vcs -l vcs.log \
       -timescale=1ns/1ps \
       -sverilog \
      +vcs+assertions \
       -ntb_opts uvm \
      -debug_access+all \
      -full64 -kdb  -lca \
      -cm line+tgl+branch+fsm+cond+assert \
      -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a \
       $(RTL) $(INC) $(SVTB2) $(SVTB1) 

run_test1_VCS:	sv_cmp_VCS
	 ./simv -a vcs.log +fsdbfile+wave1.fsdb +fsdb+assertion -cm_dir ./mem_cov1 +ntb_random_seed_automatic +assert_cov +UVM_TESTNAME=apb_test -ucli -do sim.do
	urg -dir mem_cov1.vdb -format both -report urgReport1

run_test1_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=apb_test 
	urg -dir  simv.vdb 

run_test2_VCS: sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave2.fsdb +fsdb+assertion - -cm_dir ./mem_cov2 +ntb_random_seed_automatic +assert_cov +UVM_TESTNAME=master_wr_test -ucli -do sim.do
	urg -dir mem_cov2.vdb -format both -report urgReport2

run_test2_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=master_wr_test 
	urg -dir  simv.vdb 
	
run_test3_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave3.fsdb +fsdb+assertion -cm_dir ./mem_cov3 +ntb_random_seed_automatic +assert_cov +UVM_TESTNAME=master_rd_test -ucli -do sim.do
	urg -dir mem_cov3.vdb -format both -report urgReport3

run_test3_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=master_rd_test 
	urg -dir  simv.vdb 
	
run_test4_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave4.fsdb +fsdb+assertion -cm_dir ./mem_cov4 +ntb_random_seed_automatic +assert_cov +UVM_TESTNAME=master_wr_rd_test -ucli -do sim.do
	 urg -dir mem_cov4.vdb -format both -report urgReport4

run_test4_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=master_wr_rd_test 
	urg -dir  simv.vdb 

run_test5_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave5.fsdb +fsdb+assertion -cm_dir ./mem_cov5 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=master_cont_wr_test -ucli -do sim.do
	 urg -dir mem_cov4.vdb -format both -report urgReport5

run_test5_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=master_cont_wr_test 
	urg -dir  simv.vdb 

run_test6_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave6.fsdb +fsdb+assertion -cm_dir ./mem_cov6 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=master_cont_rd_test -ucli -do sim.do
	 urg -dir mem_cov6.vdb -format both -report urgReport6

run_test6_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=master_cont_rd_test 
	urg -dir  simv.vdb 

run_test7_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave7.fsdb +fsdb+assertion -cm_dir ./mem_cov7 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=master_n_wr_rd_test -ucli -do sim.do
	 urg -dir mem_cov7.vdb -format both -report urgReport7

run_test7_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=master_n_wr_rd_test 
	urg -dir  simv.vdb 

run_test8_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave8.fsdb +fsdb+assertion -cm_dir ./mem_cov8 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=toggle_transfer_test -ucli -do sim.do
	 urg -dir mem_cov8.vdb -format both -report urgReport8

run_test8_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=toggle_transfer_test 
	urg -dir  simv.vdb 

run_test9_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave9.fsdb +fsdb+assertion -cm_dir ./mem_cov9 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=error_inject_test -ucli -do sim.do urg
	 -dir mem_cov9.vdb -format both -report urgReport9

run_test9_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=error_inject_test 
	urg -dir  simv.vdb 

run_test10_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave10.fsdb +fsdb+assertion -cm_dir ./mem_cov10 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=inject_addr_error_test -ucli -do sim.do
	 urg -dir mem_cov10.vdb -format both -report urgReport10

run_test10_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=inject_addr_error_test 
	urg -dir  simv.vdb 

run_test11_VCS:	sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave11.fsdb +fsdb+assertion -cm_dir ./mem_cov11 +ntb_random_seed_automatic  +assert_cov +UVM_TESTNAME=inject_no_wait_states_test -ucli -do sim.do
	 urg -dir mem_cov11.vdb -format both -report urgReport11

run_test11_cov:sv_cmp_VCS
	./simv -a vcs.log  -cm line+tgl+branch+fsm+cond +ntb_random_seed_automatic +UVM_TESTNAME=inject_no_wait_states_test 
	urg -dir  simv.vdb 
	
	
view_wave1_VCS: 
	verdi -ssf wave1.fsdb

view_wave2_VCS: 
	verdi -ssf wave2.fsdb

view_wave3_VCS: 
	verdi -ssf wave3.fsdb	

view_wave4_VCS: 
	verdi -ssf wave4.fsdb	
	
view_wave5_VCS: 
	verdi -ssf wave5.fsdb	
	
view_wave6_VCS: 
	verdi -ssf wave6.fsdb	

view_wave7_VCS: 
	verdi -ssf wave7.fsdb	

view_wave8_VCS: 
	verdi -ssf wave8.fsdb	

view_wave9_VCS: 
	verdi -ssf wave9.fsdb

view_wave10_VCS: 
	verdi -ssf wave10.fsdb	

view_wave11_VCS: 
	verdi -ssf wave11.fsdb	

report_VCS:
	urg -dir mem_cov1.vdb mem_cov2.vdb mem_cov3.vdb mem_cov4.vdb mem_cov5.vdb mem_cov6.vdb mem_cov7.vdb mem_cov8.vdb mem_cov9.vdb mem_cov10.vdb mem_cov11.vdb -dbname merged_dir/merged_test -format both -report urgReport

regress_VCS: clean_VCS sv_cmp_VCS  run_test1_VCS run_test2_VCS run_test3_VCS run_test4_VCS run_test5_VCS run_test6_VCS run_test7_VCS run_test8_VCS run_test9_VCS run_test10_VCS run_test11_VCS report_VCS

cov_VCS:
	verdi -cov -covdir merged_dir.vdb

code_cov_VCS :
	verdi -cov -covdir simv.vdb

clean_VCS:
	rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs *.h urgReport* *.fsdb novas* verdi*
	clear

# ----------------------------- END of Definitions for Synopsys's VCS Specific Targets -------------------------------#





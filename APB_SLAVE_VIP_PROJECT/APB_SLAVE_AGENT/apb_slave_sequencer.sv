class apb_slave_sequencer extends uvm_sequencer#(apb_slave_transaction);
		`uvm_component_utils(apb_slave_sequencer)

function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
		super.build_phase(phase);
endfunction

endclass





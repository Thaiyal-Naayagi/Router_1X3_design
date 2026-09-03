class master_seqr extends uvm_sequencer#(master_seq_item);
        `uvm_component_utils(master_seqr)

        extern function new(string name="master_seqr", uvm_component parent=null);
endclass

function master_seqr::new(string name="master_seqr", uvm_component parent=null);
        super.new(name,parent);
endfunction

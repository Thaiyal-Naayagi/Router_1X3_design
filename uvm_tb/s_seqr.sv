class slave_seqr extends uvm_sequencer#(slave_seq_item);
        `uvm_component_utils(slave_seqr)

        extern function new(string name="slave_seqr", uvm_component parent=null);
endclass

function slave_seqr::new(string name="slave_seqr", uvm_component parent=null);
        super.new(name,parent);
endfunction

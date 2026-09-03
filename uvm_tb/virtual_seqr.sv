class virtual_seqr extends uvm_sequencer;
        `uvm_component_utils(virtual_seqr)

        master_seqr m_seqr[];
        slave_seqr s_seqr[];

        extern function new(string name="virtual_seqr", uvm_component parent = null);
endclass

function virtual_seqr::new(string name="virtual_seqr", uvm_component parent = null);
        super.new(name,parent);
endfunction

class master_agent extends uvm_agent;
        `uvm_component_utils(master_agent)

        master_seqr seqr_h;
        master_driver drv_h;
        master_monitor mon_h;

        master_config m_cfg_h;

        extern function new(string name="master_agent", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
endclass

function master_agent::new(string name="master_agent", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void master_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(master_config)::get(this,"","master_config",m_cfg_h));

        if(m_cfg_h.is_active == UVM_ACTIVE) begin
                seqr_h = master_seqr::type_id::create("seqr_h",this);
                drv_h = master_driver::type_id::create("drv_h",this);
        end

        mon_h = master_monitor::type_id::create("mon_h",this);
endfunction

function void master_agent::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(m_cfg_h.is_active == UVM_ACTIVE) drv_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction

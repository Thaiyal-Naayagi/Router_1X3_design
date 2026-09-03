class slave_agent extends uvm_agent;
        `uvm_component_utils(slave_agent)

        slave_seqr seqr_h;
        slave_driver drv_h;
        slave_monitor mon_h;

        slave_config s_cfg_h;

        extern function new(string name="slave_agent", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
endclass

function slave_agent::new(string name="slave_agent", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void slave_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg_h));

        if(s_cfg_h.is_active == UVM_ACTIVE) begin
                seqr_h = slave_seqr::type_id::create("seqr_h",this);
                drv_h = slave_driver::type_id::create("drv_h",this);
        end

        mon_h = slave_monitor::type_id::create("mon_h",this);
endfunction

function void slave_agent::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(s_cfg_h.is_active == UVM_ACTIVE) drv_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction

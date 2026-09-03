class master_agt_top extends uvm_component;
        `uvm_component_utils(master_agt_top)
        master_agent agt_h[];

        env_config env_cfg_h;
        master_config m_cfg_h[];

        extern function new(string name="master_agt_top", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
endclass

function master_agt_top::new(string name="master_agt_top", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void master_agt_top::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg_h));

        agt_h = new[env_cfg_h.no_of_m_agt];
        m_cfg_h = new[env_cfg_h.no_of_m_agt];
        foreach(agt_h[i]) begin
                m_cfg_h[i] = env_cfg_h.m_cfg_h[i];
                uvm_config_db#(master_config)::set(this,$sformatf("agt_h_%0d*",i),"master_config",m_cfg_h[i]);
                agt_h[i] = master_agent::type_id::create($sformatf("agt_h_%0d",i),this);
        end

endfunction

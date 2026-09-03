class slave_agt_top extends uvm_component;
        `uvm_component_utils(slave_agt_top)
        slave_agent agt_h[];

        env_config env_cfg_h;
        slave_config s_cfg_h[];

        extern function new(string name="slave_agt_top", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
endclass

function slave_agt_top::new(string name="slave_agt_top", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void slave_agt_top::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg_h));

        s_cfg_h = new[env_cfg_h.no_of_s_agt];
        agt_h = new[env_cfg_h.no_of_s_agt];
        foreach(agt_h[i]) begin
                s_cfg_h[i] = env_cfg_h.s_cfg_h[i];
                uvm_config_db#(slave_config)::set(this,$sformatf("agt_h_%0d*",i),"slave_config",s_cfg_h[i]);
                agt_h[i] = slave_agent::type_id::create($sformatf("agt_h_%0d",i),this);
        end
endfunction

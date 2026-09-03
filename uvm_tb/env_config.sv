class env_config extends uvm_object;
        `uvm_object_utils(env_config)

        bit has_scoreboard = 1;
        bit has_m_agt_top = 1;
        bit has_s_agt_top = 1;
        int no_of_m_agt = 1;
        int no_of_s_agt = 1;

        //virtual router_intf vif;

        master_config m_cfg_h[];
        slave_config s_cfg_h[];

        extern function new(string name="env_config");
endclass

function env_config::new(string name="env_config");
        super.new(name);
endfunction

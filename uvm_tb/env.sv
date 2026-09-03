class environment extends uvm_env;
        `uvm_component_utils(environment)
        master_agt_top magt_top_h;
        slave_agt_top sagt_top_h;
        scb scb_h;

        env_config env_cfg_h;
        virtual_seqr v_seqr_h;

        extern function new(string name="environment", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
endclass

function environment::new(string name="environment", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void environment::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg_h));
        if(env_cfg_h.has_m_agt_top) magt_top_h = master_agt_top::type_id::create("magt_top_h",this);
        if(env_cfg_h.has_s_agt_top) sagt_top_h = slave_agt_top::type_id::create("sagt_top_h",this);
        if(env_cfg_h.has_scoreboard) scb_h =  scb::type_id::create("scb",this);

        v_seqr_h = virtual_seqr::type_id::create("v_seqr_h",this);
        v_seqr_h.m_seqr = new[env_cfg_h.no_of_m_agt];
        v_seqr_h.s_seqr = new[env_cfg_h.no_of_s_agt];

endfunction

function void environment::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(env_cfg_h.has_m_agt_top && env_cfg_h.has_scoreboard && env_cfg_h.has_s_agt_top) begin
                magt_top_h.agt_h[0].mon_h.an_port.connect(scb_h.m_an_port.analysis_export);
                foreach(sagt_top_h.agt_h[i]) begin
                        sagt_top_h.agt_h[i].mon_h.an_port.connect(scb_h.s_an_port[i].analysis_export);
                end

                foreach(v_seqr_h.m_seqr[i]) begin
                        v_seqr_h.m_seqr[i] = magt_top_h.agt_h[i].seqr_h;
                end
                foreach(v_seqr_h.s_seqr[i]) begin
                        v_seqr_h.s_seqr[i] = sagt_top_h.agt_h[i].seqr_h;
                end

        end
endfunction

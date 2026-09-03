class test extends uvm_test;
        `uvm_component_utils(test)
        environment env_h;

        env_config env_cfg_h;
        master_config m_cfg_h;
        slave_config s_cfg_h;
        virtual router_intf m_vif, s_vif_0, s_vif_1, s_vif_2;

        bit[1:0] addr;

        extern function new(string name="test", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

function test::new(string name="test", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void test::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual router_intf)::get(this,"","m_router_intf",m_vif));
        assert(uvm_config_db#(virtual router_intf)::get(this,"","s_router_intf_0",s_vif_0));
        assert(uvm_config_db#(virtual router_intf)::get(this,"","s_router_intf_1",s_vif_1));
        assert(uvm_config_db#(virtual router_intf)::get(this,"","s_router_intf_2",s_vif_2));

        env_cfg_h = env_config::type_id::create("env_cfg_h");
        env_cfg_h.no_of_m_agt = 1;
        env_cfg_h.no_of_s_agt = 3;
        env_cfg_h.m_cfg_h = new[env_cfg_h.no_of_m_agt];
        env_cfg_h.s_cfg_h = new[env_cfg_h.no_of_s_agt];

        foreach(env_cfg_h.m_cfg_h[i]) begin
                env_cfg_h.m_cfg_h[i] = master_config::type_id::create($sformatf("m_cfg_h_%0d",i));
                //env_cfg_h.m_cfg_h[i].vif = m_vif;
        end
        env_cfg_h.m_cfg_h[0].vif = m_vif;

        foreach(env_cfg_h.s_cfg_h[i]) begin
                env_cfg_h.s_cfg_h[i] = slave_config::type_id::create($sformatf("s_cfg_h_%0d",i));

        end
        env_cfg_h.s_cfg_h[0].vif = s_vif_0;
        env_cfg_h.s_cfg_h[1].vif = s_vif_1;
        env_cfg_h.s_cfg_h[2].vif = s_vif_2;

        uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg_h);

        env_h = environment::type_id::create("env_h",this);
endfunction

function void test::end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
endfunction

class test_1 extends test;
        `uvm_component_utils(test_1)

        virtual_seq_1 v_seq_1;
        extern function new(string name="test_1", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_1::new(string name="test_1", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void test_1::build_phase(uvm_phase phase);
        super.build_phase(phase);
        v_seq_1 = virtual_seq_1::type_id::create("v_seq_1");
        addr = 0;
        uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task test_1::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        v_seq_1.start(env_h.v_seqr_h);
        repeat(100) @(posedge m_vif.clk);
        phase.drop_objection(this);
endtask

class test_2 extends test;
        `uvm_component_utils(test_2)

        virtual_seq_2 v_seq_2;
        extern function new(string name="test_2", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_2::new(string name="test_2", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void test_2::build_phase(uvm_phase phase);
        super.build_phase(phase);
        v_seq_2 = virtual_seq_2::type_id::create("v_seq_2");
        addr = 1;
        uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task test_2::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        v_seq_2.start(env_h.v_seqr_h);
        repeat(100) @(posedge m_vif.clk);
        phase.drop_objection(this);
endtask


class test_3 extends test;
        `uvm_component_utils(test_3)

        virtual_seq_3 v_seq_3;
        extern function new(string name="test_3", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_3::new(string name="test_3", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void test_3::build_phase(uvm_phase phase);
        super.build_phase(phase);
        v_seq_3 = virtual_seq_3::type_id::create("v_seq_3");
        addr = 2;
        uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task test_3::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        v_seq_3.start(env_h.v_seqr_h);
        repeat(100) @(posedge m_vif.clk);
        phase.drop_objection(this);
endtask

class test_4 extends test;
        `uvm_component_utils(test_4)

        virtual_seq_4 v_seq_4;
        extern function new(string name="test_4", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function test_4::new(string name="test_4", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void test_4::build_phase(uvm_phase phase);
        super.build_phase(phase);
        v_seq_4 = virtual_seq_4::type_id::create("v_seq_4");
        addr = $urandom_range(0,2);
        uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task test_4::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        v_seq_4.start(env_h.v_seqr_h);
        repeat(100) @(posedge m_vif.clk);
        phase.drop_objection(this);
endtask


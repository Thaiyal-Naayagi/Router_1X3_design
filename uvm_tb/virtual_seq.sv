class virtual_seq extends uvm_sequence;
        `uvm_object_utils(virtual_seq)

        bit [1:0] addr;
        env_config env_cfg;

        virtual_seqr v_seqr;
        master_seqr m_seqr[];
        slave_seqr s_seqr[];

        extern function new(string name="virtual_seq");
endclass

function virtual_seq::new(string name="virtual_seq");
        super.new(name);
endfunction

class virtual_seq_1 extends virtual_seq;
        `uvm_object_utils(virtual_seq_1)

        master_small_seq m_seq;
        slave_seq_1 s_seq;

        extern function new(string name="virtual_seq_1");
        extern task body();
endclass

function virtual_seq_1::new(string name="virtual_seq_1");
        super.new(name);
endfunction

task virtual_seq_1::body();
        assert(uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg));
        assert(uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr));

        m_seqr = new[env_cfg.no_of_m_agt];
        s_seqr = new[env_cfg.no_of_s_agt];

        m_seq = master_small_seq::type_id::create("m_seq");
        s_seq = slave_seq_1::type_id::create("s_seq");

        m_seq.addr = addr;

        assert($cast(v_seqr,m_sequencer));

        foreach(m_seqr[i]) begin
                m_seqr[i] = v_seqr.m_seqr[i];
        end
        foreach(s_seqr[i]) begin
                s_seqr[i] = v_seqr.s_seqr[i];
        end


        fork
                case(addr)
                        2'b00: s_seq.start(s_seqr[0]);
                        2'b01: s_seq.start(s_seqr[1]);
                        2'b10: s_seq.start(s_seqr[2]);
                endcase
        join_none

        m_seq.start(m_seqr[0]);
endtask

class virtual_seq_2 extends virtual_seq;
        `uvm_object_utils(virtual_seq_2)

        master_medium_seq m_seq;
        slave_seq_1 s_seq;

        extern function new(string name="virtual_seq_2");
        extern task body();
endclass

function virtual_seq_2::new(string name="virtual_seq_2");
        super.new(name);
endfunction

task virtual_seq_2::body();
         assert(uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg));
        assert(uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr));

        m_seqr = new[env_cfg.no_of_m_agt];
        s_seqr = new[env_cfg.no_of_s_agt];

        m_seq = master_medium_seq::type_id::create("m_seq");
        s_seq = slave_seq_1::type_id::create("s_seq");

        m_seq.addr = addr;

         assert($cast(v_seqr,m_sequencer));

        foreach(m_seqr[i]) begin
                m_seqr[i] = v_seqr.m_seqr[i];
        end
        foreach(s_seqr[i]) begin
                s_seqr[i] = v_seqr.s_seqr[i];
        end


        fork
                case(addr)
                        2'b00: s_seq.start(s_seqr[0]);
                        2'b01: s_seq.start(s_seqr[1]);
                        2'b10: s_seq.start(s_seqr[2]);
                endcase

                m_seq.start(m_seqr[0]);
        join

endtask

class virtual_seq_3 extends virtual_seq;
        `uvm_object_utils(virtual_seq_3)

        master_large_seq m_seq;
        slave_seq_1 s_seq;

        extern function new(string name="virtual_seq_3");
        extern task body();
endclass

function virtual_seq_3::new(string name="virtual_seq_3");
        super.new(name);
endfunction


task virtual_seq_3::body();
         assert(uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg));
        assert(uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr));

        m_seqr = new[env_cfg.no_of_m_agt];
        s_seqr = new[env_cfg.no_of_s_agt];

        m_seq = master_large_seq::type_id::create("m_seq");
        s_seq = slave_seq_1::type_id::create("s_seq");

        m_seq.addr = addr;

         assert($cast(v_seqr,m_sequencer));

        foreach(m_seqr[i]) begin
                m_seqr[i] = v_seqr.m_seqr[i];
        end
        foreach(s_seqr[i]) begin
                s_seqr[i] = v_seqr.s_seqr[i];
        end


        fork
                case(addr)
                        2'b00: s_seq.start(s_seqr[0]);
                        2'b01: s_seq.start(s_seqr[1]);
                        2'b10: s_seq.start(s_seqr[2]);
                endcase

                m_seq.start(m_seqr[0]);
        join

endtask

class virtual_seq_4 extends virtual_seq;
        `uvm_object_utils(virtual_seq_4)

        master_error_seq m_seq;
        slave_seq_1 s_seq;

        extern function new(string name="virtual_seq_4");
        extern task body();
endclass

function virtual_seq_4::new(string name="virtual_seq_4");
        super.new(name);
endfunction

task virtual_seq_4::body();
         assert(uvm_config_db#(env_config)::get(null,get_full_name(),"env_config",env_cfg));
        assert(uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr));

        m_seqr = new[env_cfg.no_of_m_agt];
        s_seqr = new[env_cfg.no_of_s_agt];

        m_seq = master_error_seq::type_id::create("m_seq");
        s_seq = slave_seq_1::type_id::create("s_seq");

        m_seq.addr = addr;

         assert($cast(v_seqr,m_sequencer));

        foreach(m_seqr[i]) begin
                m_seqr[i] = v_seqr.m_seqr[i];
        end
        foreach(s_seqr[i]) begin
                s_seqr[i] = v_seqr.s_seqr[i];
        end


        fork
                case(addr)
                        2'b00: s_seq.start(s_seqr[0]);
                        2'b01: s_seq.start(s_seqr[1]);
                        2'b10: s_seq.start(s_seqr[2]);
                endcase

                m_seq.start(m_seqr[0]);
        join

endtask

class scb extends uvm_scoreboard;
        `uvm_component_utils(scb)
        uvm_tlm_analysis_fifo #(master_seq_item) m_an_port;
        uvm_tlm_analysis_fifo #(slave_seq_item) s_an_port[];

        env_config env_cfg_h;

        master_seq_item m_seq_item;
        slave_seq_item s_seq_item;

        int data_verified = 0;
        int trans = 0;
        int slave_id;

        extern function new(string name="scb", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task compare(master_seq_item m_req, slave_seq_item s_req);
        extern function void report_phase(uvm_phase phase);

        covergroup m_cg;
                option.per_instance = 1;
                ADDR: coverpoint m_seq_item.header[1:0] {
                        bins low = {2'b00};
                        bins mid = {2'b01};
                        bins high = {2'b10};
                }

                PAYLOAD_SIZE: coverpoint m_seq_item.header[7:2] {
                        bins small_pkt = {[1:15]};
                        bins medium_pkt = {[16:30]};
                        bins large_pkt = {[31:63]};
                }

                BAD_PKT: coverpoint m_seq_item.error {
                        bins bad = {1};
                        bins good = {0};
                }
        endgroup

         covergroup s_cg;
                option.per_instance = 1;
                ADDR: coverpoint s_seq_item.header[1:0] {
                        bins low = {2'b00};
                        bins mid = {2'b01};
                        bins high = {2'b10};
                }

                PAYLOAD_SIZE: coverpoint s_seq_item.header[7:2] {
                        bins small_pkt = {[1:15]};
                        bins medium_pkt = {[16:30]};
                        bins large_pkt = {[31:63]};
                }

        endgroup

endclass

function scb::new(string name="scb", uvm_component parent=null);
        super.new(name,parent);
        m_cg = new();
        s_cg = new();
endfunction

function void scb::build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg_h));
        m_an_port = new("m_an_port",this);
        s_an_port = new[env_cfg_h.no_of_s_agt];

        foreach(s_an_port[i]) begin
                s_an_port[i] = new($sformatf("s_an_port[%0d]",i),this);
        end
endfunction

task scb::run_phase(uvm_phase phase);
        forever begin
                m_an_port.get(m_seq_item);
                slave_id = m_seq_item.header[1:0];
                s_an_port[slave_id].get(s_seq_item);
                compare(m_seq_item, s_seq_item);
        end
endtask

task scb::compare(master_seq_item m_req, slave_seq_item s_req);
        bit payload_mismatch = 0, header_mismatch = 0, size_mismatch = 0, parity_mismatch = 0;
        trans++;
        if(m_req.header == s_req.header) `uvm_info("SCB", $sformatf("Pkt %0d header matched",trans), UVM_NONE)
        else begin
                `uvm_error("SCB", $sformatf("Pkt %0d header mismatched",trans))
                header_mismatch = 1;
        end

        if(m_req.data_in.size() == s_req.data_out.size()) `uvm_info("SCB", $sformatf("Pkt %0d payload size matched",trans), UVM_NONE)
        else begin
                `uvm_error("SCB", $sformatf("Pkt %0d payload size mismatched",trans))
                size_mismatch = 1;
        end

        if(size_mismatch == 0) begin
                foreach(m_req.data_in[i]) begin
                        if(m_req.data_in[i] != s_req.data_out[i]) begin
                                 `uvm_error("SCB", $sformatf("Pkt %0d payload %0d mismatched",trans,i))
                                payload_mismatch = 1;
                        end
                end
        end

        if(payload_mismatch == 0 && size_mismatch == 0)`uvm_info("SCB", $sformatf("Pkt %0d payloads matched",trans), UVM_NONE)

        if(m_req.parity == s_req.parity) `uvm_info("SCB", $sformatf("Pkt %0d parity matched",trans), UVM_NONE)
        else begin
                `uvm_error("SCB", $sformatf("Pkt %0d parity mismatched",trans))
                parity_mismatch = 1;
        end

        if(!header_mismatch && !size_mismatch && ! payload_mismatch && !parity_mismatch) begin
                 data_verified++;
                 m_cg.sample();
                 s_cg.sample();
        end

endtask

function void scb::report_phase(uvm_phase phase);
        `uvm_info("SCB",$sformatf("Total packets  = %0d, Verified packets = %0d",trans, data_verified),UVM_NONE)
        `uvm_info("SCB_COV",$sformatf("Master Coverage = %0.2f%%", m_cg.get_coverage()),UVM_NONE)

    `uvm_info("SCB_COV",$sformatf("Slave Coverage = %0.2f%%", s_cg.get_coverage()),UVM_NONE)
endfunction

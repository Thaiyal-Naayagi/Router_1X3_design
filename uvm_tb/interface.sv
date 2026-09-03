interface router_intf(input bit clk);
        bit rst_n;
        bit pkt_valid;
        bit read_enb;
        bit pkt_valid_out;
        bit busy;
        bit error;

        bit [7:0] data_in;
        logic  [7:0] data_out;

        clocking m_drv_cb @(posedge clk);
                default input #1 output #0;
                output rst_n;
                output pkt_valid;
                output data_in;
                input busy;
                input error;
        endclocking

        clocking m_mon_cb @(posedge clk);
                default input #1 output #0;
                input rst_n;
                input pkt_valid;
                input data_in;
                input busy;
                input error;
        endclocking

        clocking s_drv_cb @(posedge clk);
                default input #1 output #0;
                output read_enb;
                input pkt_valid_out;
        endclocking

        clocking s_mon_cb @(posedge clk);
                default input #1 output #0;
                input data_out;
                input read_enb;
        endclocking

        modport M_DRV(clocking m_drv_cb);
        modport M_MON(clocking m_mon_cb);
        modport S_DRV(clocking s_drv_cb);
        modport S_MON(clocking s_mon_cb);
          
endinterface

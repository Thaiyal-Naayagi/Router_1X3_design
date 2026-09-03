class slave_seq extends uvm_sequence#(slave_seq_item);
        `uvm_object_utils(slave_seq)

        extern function new(string name="slave_seq");
        extern task body();
endclass

function slave_seq::new(string name="slave_seq");
        super.new(name);
endfunction

task slave_seq::body();
        repeat(10) begin
                req = slave_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize());
                finish_item(req);
        end
endtask

class slave_seq_1 extends slave_seq;
        `uvm_object_utils(slave_seq_1)

        extern function new(string name="slave_seq_1");
        extern task body();
endclass

function slave_seq_1::new(string name="slave_seq_1");
        super.new(name);
endfunction

task slave_seq_1::body();
        repeat(10) begin
                req = slave_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {delay inside {[1:28]};});
                finish_item(req);
        end
endtask

class slave_seq_2 extends slave_seq;
        `uvm_object_utils(slave_seq_2)

        extern function new(string name="slave_seq_2");
        extern task body();
endclass

function slave_seq_2::new(string name="slave_seq_2");
        super.new(name);
endfunction

task slave_seq_2::body();
        repeat(10) begin
                req = slave_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {delay inside {[29:40]};});
                finish_item(req);
        end
endtask

class master_seq extends uvm_sequence#(master_seq_item);
        `uvm_object_utils(master_seq)

        bit [1:0] addr;
        master_seq_item req;
        extern function new(string name="master_seq");
        extern task body();
endclass

function master_seq::new(string name="master_seq");
        super.new(name);
endfunction

task master_seq::body();
        repeat(10) begin
                req = master_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize());
                finish_item(req);
        end
endtask

//small class

class master_small_seq extends master_seq;
        `uvm_object_utils(master_small_seq)

        extern function new(string name="master_small_seq");
        extern task body();

endclass

function master_small_seq::new(string name="master_small_seq");
        super.new(name);
endfunction

task master_small_seq::body();
        repeat(10) begin
                req = master_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[1:15]}; header[1:0] == addr;});
                finish_item(req);
        end
endtask


//medium class

class master_medium_seq extends master_seq;
        `uvm_object_utils(master_medium_seq)

        extern function new(string name="master_medium_seq");
        extern task body();

endclass

function master_medium_seq::new(string name="master_medium_seq");
        super.new(name);
endfunction

task master_medium_seq::body();
        repeat(10) begin
                req = master_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[16:30]}; header[1:0] == addr;});
                finish_item(req);
        end
endtask

// large class

class master_large_seq extends master_seq;
        `uvm_object_utils(master_large_seq)

        extern function new(string name="master_large_seq");
        extern task body();

endclass

function master_large_seq::new(string name="master_large_seq");
        super.new(name);
endfunction

task master_large_seq::body();
        repeat(10) begin
                req = master_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[7:2] inside {[31:63]}; header[1:0]== addr;});
                finish_item(req);
        end
endtask

//error class
class master_error_seq extends master_seq;
        `uvm_object_utils(master_error_seq)

        extern function new(string name="master_error_seq");
        extern task body();
endclass

function master_error_seq::new(string name="master_error_seq");
        super.new(name);
endfunction

task master_error_seq::body();
        repeat(10) begin
                req = master_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {header[1:0] == addr;});
                req.parity = req.parity ^ 8'h01;
                finish_item(req);
        end
endtask

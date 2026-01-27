class dma_adapter extends uvm_reg_adapter;
  `uvm_object_utils(dma_adapter)

  function new(string name = "dma_adapter");
    super.new(name);
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    dma_seq_item bus;
    bus = dma_seq_item::type_id::create("bus");
    bus.wr_en  = (rw.kind == UVM_WRITE) ? 1'b1 : 1'b0;
    bus.rd_en  = (rw.kind == UVM_READ)  ? 1'b1 : 1'b0;
    bus.addr   = rw.addr;
    if(bus.wr_en == 1) bus.wdata  = rw.data;
    return bus;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    dma_seq_item bus;
    assert($cast(bus, bus_item));
//     if (bus.wr_en) begin
//       rw.kind = UVM_WRITE;
//       rw.data = bus.wdata;
//     end else begin
//       rw.kind = UVM_READ;
//       rw.data = bus.rdata;
//     end
    rw.kind = bus.wr_en ? UVM_WRITE:UVM_READ;
    if (rw.kind == UVM_READ) begin
       rw.data = bus.rdata; 
    end else begin
       rw.data = bus.wdata; 
    end
    rw.addr   = bus.addr;
    rw.status = UVM_IS_OK;
  endfunction
endclass

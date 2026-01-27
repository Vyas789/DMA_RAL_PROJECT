class dma_subscriber extends uvm_subscriber #(dma_seq_item);
  `uvm_component_utils(dma_subscriber)

  dma_seq_item tr;
  real cov;

  covergroup dma_reg_cg;
    option.per_instance = 1;

    cp_wr_en : coverpoint tr.wr_en;
    cp_rd_en : coverpoint tr.rd_en;

    cp_addr:coverpoint tr.addr{
      bins intr            = {32'h400};
      bins ctrl            = {32'h404};
      bins io_addr         = {32'h408};
      bins mem_addr        = {32'h40C};
      bins extra_info      = {32'h410};
      bins status          = {32'h414};
      bins transfer_count  = {32'h418};
      bins descriptor_addr = {32'h41C};
      bins error_status    = {32'h420};
      bins configer        = {32'h424};
    }

    addr_wr_en_cross:cross cp_addr, cp_wr_en;
    addr_rd_en_cross:cross cp_addr, cp_rd_en;
  endgroup

  function new(string name = "dma_subscriber", uvm_component parent = null);
    super.new(name, parent);
    dma_reg_cg = new();
  endfunction

  function void write(dma_seq_item t);
    tr = t;
    dma_reg_cg.sample();
  endfunction
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov = dma_reg_cg.get_coverage();
  endfunction
 
	function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Coverage --> %0.2f", cov), UVM_MEDIUM);
  endfunction

endclass

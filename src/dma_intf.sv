interface dma_intf(input logic clk,rst_n);
  logic [31:0] addr;
  logic        wr_en;
  logic        rd_en;
  logic [31:0] wdata;
  logic [31:0] rdata;

  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output addr;
    output wr_en;
    output rd_en;
    output wdata;
    input  rdata;  
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input addr;
    input wr_en;
    input rd_en;
    input wdata;
    input rdata;  
  endclocking
  
  modport DRIVER  (clocking drv_cb);
  modport MONITOR (clocking mon_cb);
  
endinterface

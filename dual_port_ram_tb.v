module tb;
  
  reg clk,cs,wr_rd_a,wr_rd_b;
  reg [3:0] addr_a,addr_b;
  reg [7:0] wdata_a,wdata_b;
  
  wire [7:0] rdata_a,rdata_b;
  integer i;
  
  dual_port_RAM DUT (clk,cs,wr_rd_a,wr_rd_b,addr_a,addr_b,wdata_a,wdata_b,rdata_a,rdata_b);
  
  initial begin
    clk=0;
    forever
      #5 clk =~clk;
  end
  
  initial begin $monitor("Time=%3t,clk=%0b,cs=%0b,wr_rd_a=%0b,addr_a=%2d,wdata_a=%3d,rdata_a=%3d,wr_rd_b=%0b,addr_b=%2d,wdata_b=%3d,rdata_b=%3d",$time,clk,cs,wr_rd_a,addr_a,wdata_a,rdata_a,wr_rd_b,addr_b,wdata_b,rdata_b);
    
    cs=1; #10 //chip not selected
    
    wr_rd_a=1;
    for(i=0;i<16;i=i+1)
      repeat(1)@(posedge clk)
        begin
          addr_a=i;
          wdata_a=$random;
        end
    
    wr_rd_b=0;
    for(i=0;i<16;i=i+1)
      repeat(1)@(posedge clk)
        begin
          addr_b=i;
        end
    

  
  cs=0; #10 //chip selected
    
    wr_rd_a=1;            //write at port A
    for(i=0;i<16;i=i+1)
      repeat(1)@(posedge clk)
        begin
          addr_a=i;
          wdata_a=$random;
        end
    
    wr_rd_b=0;             //read at port B
    for(i=0;i<16;i=i+1)
      repeat(1)@(posedge clk)
        begin
          addr_b=i;
        end
    
  #10
    
    wr_rd_b=1;              //write at port B
    for(i=0;i<16;i=i+1)
      repeat(1)@(posedge clk)
        begin
          addr_b=i;
          wdata_b=$random;
        end
    
    wr_rd_a=0;              //read at port A
    for(i=0;i<16;i=i+1)
      repeat(1)@(posedge clk)
        begin
          addr_a=i;
        end    
    
    //Write at a port simultaneously
    
    wr_rd_a=0;wr_rd_b=0;
    addr_a=5;
    addr_b=5;
    #10
    wr_rd_a=1;wr_rd_b=1;
    addr_a=5;
    addr_b=5;
    wdata_a = 77;
    wdata_b = 98;
    #10
    wr_rd_a=0;wr_rd_b=0;

  #20 $finish;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end
  
endmodule
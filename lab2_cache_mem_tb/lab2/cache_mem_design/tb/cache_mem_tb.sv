module cache_mem_test(cache_mem_intf.tb cmbus);

  initial
  begin : mem_t

//TO DO : Create your own stimulus (Hint call mem_write and mem_read task of cmbus instance)
  logic [7:0] rd_data;
  logic [7:0] mem_scoreboard [0:31];
  int ra, rn, mismatch;
  mismatch = 0;

  // Check reset
  #10;
  $display("Check reset");
  for (int i=0; i<32; i++) begin
      cmbus.mem_read(i,rd_data);
      check(ra, 0, rd_data, mismatch);
  end

  // Brute force
  for (int i = 0; i < 32; i++) begin
    for (int j = 0; j < 10; j++) begin
      // if (i/8 != 0) continue;
      cmbus.mem_write(i, j);
      mem_scoreboard[i]=j;
      cmbus.mem_read(i, rd_data);
      check(i, mem_scoreboard[i], rd_data, mismatch);
    end
  end

  // Random write/read
  $display("Random 1000 writes");
  for (int i = 0; i<1000; i++) begin
    ra = $urandom()%32;
    rn = $urandom()%256;
    cmbus.mem_write(ra, rn);
    mem_scoreboard[ra] = rn;
  end

  // Random read check
  $display("Check random read");
  foreach (mem_scoreboard[i]) begin
    cmbus.mem_read(i, rd_data);
    check(i, mem_scoreboard[i], rd_data, mismatch);
  end

  $display("Random regression");
  for (int i = 0; i < 100; i++) begin
    ra = $urandom()%32;  // new random address
    rn = $urandom()%256; // new random number
    cmbus.mem_read(ra, rd_data);
    check(ra, mem_scoreboard[ra], rd_data, mismatch);
    cmbus.mem_write(ra, rn);
    mem_scoreboard[ra] = rn;
    $display("Write addr: %0d, data: %0d", ra, rn);
    cmbus.mem_read(ra, rd_data);
    check(ra, mem_scoreboard[ra], rd_data, mismatch);
  end
  $display("Mismatches: %0d", mismatch);

	$finish;
  end

  function automatic void check(int address, int expected, int actual, ref int mismatch);
    $write("Read addr: %0d, data: %0d", address, actual);
    if (expected != actual) begin
      $write(", expected: %0d\t Mismatch!", expected);
      mismatch++;
    end
    $display("");
  endfunction

endmodule

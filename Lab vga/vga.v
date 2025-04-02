module vga(
    input clk_50MHz,  // 50 MHz clock input
    input rst,        // Reset button
    input [2:0] sw,   // 3 switches for R, G, B increment
    output hsync,     // Horizontal sync
    output vsync,     // Vertical sync
    output reg [3:0] vga_r,  // VGA Red signal (4-bit)
    output reg [3:0] vga_g,  // VGA Green signal (4-bit)
    output reg [3:0] vga_b   // VGA Blue signal (4-bit)
);

// Clock divider to obtain 25 MHz from 50 MHz
reg clk_25MHz;
always @(posedge clk_50MHz or negedge rst) begin
    if (!rst)
        clk_25MHz <= 0;
    else
        clk_25MHz <= ~clk_25MHz;
end

// VGA timing parameters
localparam H_SYNC_PULSE = 96;
localparam H_BACK_PORCH = 48;
localparam H_ACTIVE = 640;
localparam H_FRONT_PORCH = 16;
localparam H_TOTAL = 800;

localparam V_SYNC_PULSE = 2;
localparam V_BACK_PORCH = 33;
localparam V_ACTIVE = 480;
localparam V_FRONT_PORCH = 10;
localparam V_TOTAL = 525;

// Counters for sync signals
reg [9:0] h_count;
reg [9:0] v_count;

// Sync signal generation
assign hsync = (h_count < H_SYNC_PULSE) ? 0 : 1;
assign vsync = (v_count < V_SYNC_PULSE) ? 0 : 1;

// H and V counter logic
always @(posedge clk_25MHz or negedge rst) begin
    if (!rst) begin
        h_count <= 0;
        v_count <= 0;
    end else begin
        if (h_count == H_TOTAL - 1) begin
            h_count <= 0;
            if (v_count == V_TOTAL - 1) begin
                v_count <= 0;
            end else begin
                v_count <= v_count + 1;
            end
        end else begin
            h_count <= h_count + 1;
        end
    end
end

// RGB Counters
reg [3:0] r_counter, g_counter, b_counter;
reg sw0_prev, sw1_prev, sw2_prev;

// Increment logic for RGB
always @(posedge clk_25MHz or negedge rst) begin
    if (!rst) begin
        r_counter <= 4'd0;
        g_counter <= 4'd0;
        b_counter <= 4'd0;
        sw0_prev <= 1'b0;
        sw1_prev <= 1'b0;
        sw2_prev <= 1'b0;
    end else begin
        // Detect rising edge for each switch separately and update sw_prev immediately
        if (sw[0] && !sw0_prev) begin
            r_counter <= r_counter + 4'd1;
            sw0_prev <= 1'b1;  // Update only when switch 0 increments
        end else if (!sw[0]) begin
            sw0_prev <= 1'b0;  // Reset when switch 0 is released
        end

        if (sw[1] && !sw1_prev) begin
            g_counter <= g_counter + 4'd1;
            sw1_prev <= 1'b1;  // Update only when switch 1 increments
        end else if (!sw[1]) begin
            sw1_prev <= 1'b0;  // Reset when switch 1 is released
        end

        if (sw[2] && !sw2_prev) begin
            b_counter <= b_counter + 4'd1;
            sw2_prev <= 1'b1;  // Update only when switch 2 increments
        end else if (!sw[2]) begin
            sw2_prev <= 1'b0;  // Reset when switch 2 is released
        end
    end
end

// Display RGB during active video
always @(posedge clk_25MHz or negedge rst) begin
    if (!rst) begin
        vga_r <= 4'd0;
        vga_g <= 4'd0;
        vga_b <= 4'd0;
    end else if ((h_count >= (H_SYNC_PULSE + H_BACK_PORCH)) && 
                 (h_count < (H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE)) &&
                 (v_count >= (V_SYNC_PULSE + V_BACK_PORCH)) && 
                 (v_count < (V_SYNC_PULSE + V_BACK_PORCH + V_ACTIVE))) begin
        vga_r <= r_counter;
        vga_g <= g_counter;
        vga_b <= b_counter;
    end else begin
        vga_r <= 4'd0;
        vga_g <= 4'd0;
        vga_b <= 4'd0;
    end
end

endmodule

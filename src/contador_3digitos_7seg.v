module contador_3digitos_7seg
#(
    parameter integer CLK_FREQ = 50000000,
    parameter integer CNT_HZ   = 4,
    parameter integer MUX_HZ   = 1000
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  [6:0] seg,
    output reg  [2:0] dig
);

    localparam integer DIV_CNT_LIMIT = CLK_FREQ / CNT_HZ;
    reg [31:0] div_cnt;
    reg [7:0]  count_bin;

    initial begin
        div_cnt = 0;
        count_bin = 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_cnt   <= 32'd0;
            count_bin <= 8'd0;
        end else begin
            if (div_cnt >= DIV_CNT_LIMIT - 1) begin
                div_cnt <= 32'd0;
                if (count_bin == 8'd255)
                    count_bin <= 8'd0;
                else
                    count_bin <= count_bin + 8'd1;
            end else begin
                div_cnt <= div_cnt + 32'd1;
            end
        end
    end

    reg [3:0] bcd_centenas;
    reg [3:0] bcd_decenas;
    reg [3:0] bcd_unidades;
    
    integer i;
    reg [19:0] shift;

    always @* begin
        shift = 20'd0;
        shift[7:0] = count_bin;

        for (i = 0; i < 8; i = i + 1) begin
            if (shift[11:8] >= 5)   shift[11:8]   = shift[11:8] + 4'd3;
            if (shift[15:12] >= 5)  shift[15:12]  = shift[15:12] + 4'd3;
            if (shift[19:16] >= 5)  shift[19:16]  = shift[19:16] + 4'd3;
            
            shift = shift << 1;
        end

        bcd_centenas = shift[19:16];
        bcd_decenas  = shift[15:12];
        bcd_unidades = shift[11:8];
    end

    localparam integer DIV_MUX_LIMIT = CLK_FREQ / MUX_HZ;
    reg [31:0] mux_div;
    reg [1:0]  mux_sel;
    reg [3:0]  bcd_actual;

    initial begin
        mux_div = 0;
        mux_sel = 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mux_div <= 32'd0;
            mux_sel <= 2'd0;
        end else begin
            if (mux_div >= DIV_MUX_LIMIT - 1) begin
                mux_div <= 32'd0;
                if(mux_sel == 2'd2) 
                    mux_sel <= 2'd0;
                else 
                    mux_sel <= mux_sel + 2'd1;
            end else begin
                mux_div <= mux_div + 32'd1;
            end
        end
    end

    always @* begin
        case (mux_sel)
            2'd0: begin
                bcd_actual = bcd_unidades;
                dig        = 3'b001; 
            end
            2'd1: begin
                bcd_actual = bcd_decenas;
                dig        = 3'b010; 
            end
            2'd2: begin
                bcd_actual = bcd_centenas;
                dig        = 3'b100; 
            end
            default: begin
                bcd_actual = 4'd0;
                dig        = 3'b000;
            end
        endcase
    end

    always @* begin
        case (bcd_actual)
            4'd0: seg = 7'b0000001; 
            4'd1: seg = 7'b1001111; 
            4'd2: seg = 7'b0010010; 
            4'd3: seg = 7'b0000110; 
            4'd4: seg = 7'b1001100; 
            4'd5: seg = 7'b0100100; 
            4'd6: seg = 7'b0100000; 
            4'd7: seg = 7'b0001111; 
            4'd8: seg = 7'b0000000; 
            4'd9: seg = 7'b0000100; 
            default: seg = 7'b1111111;
        endcase
    end

endmodule
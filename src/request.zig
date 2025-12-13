const std = @import("std");
const Stream = std.net.Stream;

pub fn read_request(conn: Stream, buffer: []u8) !void {
    var recv_buffer: [1024]u8 = undefined;
    var reader = conn.reader(&recv_buffer);
    var start_index: usize = 0;
    for (0..5) |_| {
        const len = try read_next_line(&reader, buffer, start_index);
        start_index += len;
    }
}

fn read_next_line(reader: *std.net.Stream.Reader, buffer: []u8, start_index: usize) !usize {
    const next_line = try reader.file_reader.interface.takeDelimiterInclusive('\n');
    @memcpy(buffer[start_index..(start_index + next_line.len)], next_line[0..]);
    return next_line.len;
}

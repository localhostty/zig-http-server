const std = @import("std");
const Map = std.static_string_map.StaticStringMap;
const Stream = std.net.Stream;
pub const Method = enum {
    GET,
    pub fn init(text: []const u8) !Method {
        return MethodMap.get(text).?;
    }
    pub fn is_supported(m: []const u8) bool {
        const method = MethodMap.get(m);
        if (method) |_| {
            return true;
        }
        return false;
    }
};
const MethodMap = Map(Method).initComptime(.{.{ "GET", Method.GET }});
const Request = struct {
    method: Method,
    uri: []const u8,
    version: []const u8,

    pub fn init(method: Method, uri: []const u8, version: []const u8) Request {
        return Request{ .method = method, .version = version, .uri = uri };
    }
};

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

pub fn parse_request(text: []u8) Request {
    const line_index = std.mem.indexOfScalar(u8, text, '\n') orelse text.len;
    var iterator = std.mem.splitScalar(u8, text[0..line_index], ' ');
    const method = try Method.init(iterator.next().?);
    const uri = iterator.next().?;
    const version = iterator.next().?;
    const request = Request.init(method, uri, version);
    return request;
}

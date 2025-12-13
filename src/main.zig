const std = @import("std");
const Server = @import("server.zig").Server;
const Request = @import("request.zig");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const server = try Server.init();
    var listening = try server.listen();
    const connection = try listening.accept();
    defer connection.stream.close();

    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(connection.stream, request_buffer[0..]);

    std.debug.print("{s}\n", .{request_buffer});
}

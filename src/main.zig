const std = @import("std");
const Server = @import("server.zig").Server;
const Request = @import("request.zig");
const Response = @import("response.zig");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const server = try Server.init();
    var listening = try server.listen();
    while (true) {
        const connection = try listening.accept();
        defer connection.stream.close();
        var request_buffer: [1000]u8 = undefined;
        @memset(request_buffer[0..], 0);
        try Request.read_request(connection.stream, request_buffer[0..]);
        const req = Request.parse_request(request_buffer[0..]);
        std.debug.print("METHOD: {any}\n", .{req.method});
        std.debug.print("URI: {s}\n", .{req.uri});
        std.debug.print("VERSION: {s}\n", .{req.version});
        if (req.method == Request.Method.GET) {
            if (std.mem.eql(u8, req.uri, "/")) {
                try Response.send_200(connection.stream);
            } else {
                try Response.send_404(connection.stream);
            }
        }

        std.debug.print("{s}\n", .{request_buffer});
    }
}

const std = @import("std");
const posix = std.posix;

pub const Server = struct {
    socket: posix.socket_t,
    host: []const u8,
    port: u16,
    addr: std.net.Address,

    pub fn init() !Server {
        const host: []const u8 = "127.0.0.1";
        const port: u16 = 7870;
        const addr = try std.net.Address.resolveIp(host, port);
        const socket = try posix.socket(addr.any.family, posix.SOCK.STREAM | posix.SOCK.NONBLOCK, posix.IPPROTO.TCP);

        return .{ .host = host, .port = port, .addr = addr, .socket = socket };
    }

    pub fn listen(self: Server) !std.net.Server {
        std.debug.print("Server Addr: {s}:{any}\n", .{ self.host, self.port });
        return try self.addr.listen(.{});
    }
};

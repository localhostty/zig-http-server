const std = @import("std");
const Stream = std.net.Stream;

pub fn send_200(conn: Stream) !void {
    const message = ("HTTP/1.1 200 OK\nContent-Length: 48" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>Hello, World!</h1></body></html>");
    var writer = conn.writer(&.{}).file_writer;
    _ = try writer.interface.write(message);
}

pub fn send_404(conn: Stream) !void {
    const message = ("HTTP/1.1 404 Not Found\nContent-Length: 50" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>File not found!</h1></body></html>");
    var writer = conn.writer(&.{}).file_writer;
    _ = try writer.interface.write(message);
}

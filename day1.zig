const std = @import("std");
const fmt = std.fmt;
const sort = std.sort;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var file = std.fs.cwd().openFile("inputs/1s.txt", .{}) catch unreachable;
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var currentCal: u32 = 0;

    var top3 = [3]u32{0,0,0};  
    const sortIntAsc = std.sort.asc(u32);

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var trimmedLine = std.mem.trimRight(u8, line[0..line.len], "\r\n");

        if (trimmedLine.len == 0) {
            currentCal = 0;
            continue;
        }
        const cal = fmt.parseInt(u32, trimmedLine, 10) catch |err| {
            try stdout.print("Parsing error? {} in {s}\n", .{err, trimmedLine});
            return;
        };
        currentCal += cal;
        if (currentCal > top3[0]) {
            top3[0] = currentCal;
            sort.sort(u32, &top3, {}, sortIntAsc);
        }
    }

    try stdout.print("maxcal: {d} {d} {d}\n", .{top3[0], top3[1], top3[2]});
}

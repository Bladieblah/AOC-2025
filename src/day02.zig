const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var p1: usize = 0;
    var p2: usize = 0;

    var sbuf: [64]u8 = undefined;
    var ranges = util.tokenizeSca(u8, data, ',');

    while (ranges.next()) |range| {
        var it = util.tokenizeSca(u8, range, '-');
        const start = util.parse_uint(it.next().?);
        const end = util.parse_uint(it.next().?);

        for (start..end + 1) |i| {
            const s = util.to_string(sbuf[0..], i);

            for (2..20) |parts| {
                if (@mod(s.len, parts) != 0) continue;
                const length = s.len / parts;
                var valid = true;

                for (1..parts) |j| {
                    if (!util.eql(u8, s[0..length], s[length * j .. length * (j + 1)])) {
                        valid = false;
                        break;
                    }
                }

                if (valid) {
                    p2 += i;
                    if (parts == 2) {
                        p1 += i;
                    }
                    break;
                }
            }
        }
    }

    util.print("({d}, {d})\n", .{ p1, p2 });
}

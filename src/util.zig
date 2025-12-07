const std = @import("std");

pub const List = std.ArrayList;
pub const Map = std.AutoHashMap;
pub const StrMap = std.StringHashMap;
pub const BitSet = std.DynamicBitSet;
pub const Str = []const u8;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

// Add utility functions here

// Useful stdlib functions
pub const tokenizeAny = std.mem.tokenizeAny;
pub const tokenizeSeq = std.mem.tokenizeSequence;
pub const tokenizeSca = std.mem.tokenizeScalar;
pub const splitAny = std.mem.splitAny;
pub const splitSeq = std.mem.splitSequence;
pub const splitSca = std.mem.splitScalar;
pub const indexOf = std.mem.indexOfScalar;
pub const indexOfAny = std.mem.indexOfAny;
pub const indexOfStr = std.mem.indexOfPosLinear;
pub const lastIndexOf = std.mem.lastIndexOfScalar;
pub const lastIndexOfAny = std.mem.lastIndexOfAny;
pub const lastIndexOfStr = std.mem.lastIndexOfLinear;
pub const trim = std.mem.trim;
pub const sliceMin = std.mem.min;
pub const sliceMax = std.mem.max;

pub const parseInt = std.fmt.parseInt;
pub const parseFloat = std.fmt.parseFloat;

pub const print = std.debug.print;
pub const assert = std.debug.assert;

pub const sort = std.sort.block;
pub const asc = std.sort.asc;
pub const desc = std.sort.desc;

pub const eql = std.mem.eql;

pub fn parse_int(val: []const u8) i32 {
    return parseInt(i32, val, 10) catch unreachable;
}

pub fn parse_uint(val: []const u8) u64 {
    return parseInt(u64, val, 10) catch unreachable;
}

pub fn parse_usize(val: []const u8) usize {
    const trimmed = std.mem.trim(u8, val, " ");
    return parseInt(usize, trimmed, 10) catch unreachable;
}

pub fn to_string(buf: []u8, val: anytype) []u8 {
    return std.fmt.bufPrint(buf, "{}", .{val}) catch unreachable;
}

pub fn printGrid(grid: anytype) void {
    for (grid) |row| {
        for (row) |v|
            std.debug.print("{} ", .{v});
        std.debug.print("\n", .{});
    }
}

pub fn add(A: anytype, B: @TypeOf(A)) @TypeOf(A) {
    var C: @TypeOf(A) = undefined;
    for (A, 0..) |v, i|
        C[i] = v + B[i];
    return C;
}

pub fn sum(xs: []const usize) usize {
    var r: usize = 0;
    for (xs) |v| r += v;
    return r;
}

pub fn product(xs: []const usize) usize {
    var r: usize = 1;
    for (xs) |v| r *= v;
    return r;
}

pub fn swapPointers(A: anytype, B: @TypeOf(A)) void {
    const tmp: @TypeOf(A.*) = A.*;
    A.* = B.*;
    B.* = tmp;
}

pub fn printTime(ns: i128) void {
    if (ns >= 10_000_000_000)
        print("{d} s\n", .{@divTrunc(ns, 1_000_000_000)})
    else if (ns >= 10_000_000)
        print("{d} ms\n", .{@divTrunc(ns, 1_000_000)})
    else if (ns >= 10_000)
        print("{d} µs\n", .{@divTrunc(ns, 1_000)})
    else
        print("{d} ns\n", .{ns});
}

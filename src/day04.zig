const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

const GRID_SIZE = 137;
const GRID_PADDED = GRID_SIZE + 2;
const Grid = [GRID_PADDED][GRID_PADDED]u8;

fn nbs(x: usize, y: usize) [8][2]usize {
    return .{
        .{ x - 1, y - 1 },
        .{ x - 1, y },
        .{ x - 1, y + 1 },
        .{ x, y + 1 },
        .{ x + 1, y + 1 },
        .{ x + 1, y },
        .{ x + 1, y - 1 },
        .{ x, y - 1 },
    };
}

fn moveRolls(grid1: *Grid, grid2: *Grid) usize {
    var removed: usize = 0;

    for (1..GRID_SIZE + 1) |row| {
        for (1..GRID_SIZE + 1) |col| {
            grid2[row][col] = 0;
            if (grid1[row][col] == 0) continue;

            var nbCount: u8 = 0;
            for (nbs(row, col)) |pair| {
                const x, const y = pair;
                nbCount += grid1[x][y];
            }
            if (nbCount < 4) {
                removed += 1;
            } else {
                grid2[row][col] = 1;
            }
        }
    }

    return removed;
}

fn run() !void {
    var p1: usize = 0;
    var p2: usize = 0;

    var grid1: Grid = .{.{0} ** GRID_PADDED} ** GRID_PADDED;
    var grid2: Grid = .{.{0} ** GRID_PADDED} ** GRID_PADDED;
    var lines = util.tokenizeSca(u8, data, '\n');

    var row: usize = 1;
    while (lines.next()) |line| : (row += 1) {
        for (line, 1..) |c, col| {
            if (c == '@') {
                grid1[row][col] = 1;
            }
        }
    }

    var removed = moveRolls(&grid1, &grid2);
    p1 = removed;
    p2 = removed;

    while (removed > 0) {
        util.swapPointers(&grid1, &grid2);
        removed = moveRolls(&grid1, &grid2);
        p2 += removed;
    }

    util.print("({d}, {d})\n", .{ p1, p2 });
}

pub fn main() !void {
    const start = std.time.nanoTimestamp();
    try run();
    const end = std.time.nanoTimestamp();
    util.printTime(end - start);
}

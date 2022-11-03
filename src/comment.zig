const std = @import("std");
const Source = @import("./Source.zig");
const testing = std.testing;

pub fn skip(src: *Source) !void {
    while (true) {
        try src.skipSpacesAndLineBreaks();
        if (src.current()) |c| {
            if (c != '#') return;
        }
        try gotoNextLine(src);
    }
}

fn gotoNextLine(src: *Source) !void {
    var looking_for_eol = true;
    while (try src.next()) |n| {
        if (looking_for_eol) {
            if (n == '\n') {
                looking_for_eol = false;
            }
        } else {
            return;
        }
    }
}

test "skip" {
    var src = Source.init(
        \\  # comment # abc  
        \\    
        \\    # comment
        \\  a
    );
    try skip(&src);
    try testing.expect(src.current().? == 'a');
}
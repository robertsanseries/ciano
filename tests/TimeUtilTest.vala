/*
 * Copyright (c) 2026 Robert San <robertsanseries@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

using Ciano.Utils;

void assert_seconds (string? duration, int expected) {
    int actual = TimeUtil.duration_in_seconds (duration);

    if (actual != expected) {
        Test.message ("duration_in_seconds (\"%s\")", duration ?? "(null)");
    }

    assert_cmpint (actual, CompareOperator.EQ, expected);
}

int main (string[] args) {
    Test.init (ref args);

    Test.add_func ("/time-util/documented-example", () => {
        assert_seconds ("00:01:14.00", 74);
    });

    Test.add_func ("/time-util/zero", () => {
        assert_seconds ("00:00:00", 0);
        assert_seconds ("00:00:00.000", 0);
        assert_seconds ("00:00:00.000000", 0);
    });

    Test.add_func ("/time-util/each-unit", () => {
        assert_seconds ("00:00:01", 1);
        assert_seconds ("00:00:59", 59);
        assert_seconds ("00:01:00", 60);
        assert_seconds ("00:59:00", 3540);
        assert_seconds ("01:00:00", 3600);
        assert_seconds ("10:00:00", 36000);
    });

    Test.add_func ("/time-util/combined", () => {
        assert_seconds ("01:02:03", 3723);
        assert_seconds ("10:20:30", 37230);
        assert_seconds ("00:01:32.28", 92);
        assert_seconds ("99:59:59", 359999);
    });

    Test.add_func ("/time-util/fraction-is-truncated-not-rounded", () => {
        assert_seconds ("00:00:01.999", 1);
        assert_seconds ("00:00:01.500000", 1);
        assert_seconds ("00:00:01.001", 1);
    });

    Test.add_func ("/time-util/ffmpeg-out-time-format", () => {
        // Format emitted by "-progress pipe:2" as out_time=
        assert_seconds ("00:00:01.551550", 1);
        assert_seconds ("00:03:25.123456", 205);
    });

    Test.add_func ("/time-util/single-digit-fields", () => {
        assert_seconds ("1:2:3", 3723);
        assert_seconds ("0:0:5", 5);
    });

    Test.add_func ("/time-util/fields-are-not-normalized", () => {
        // Values above 59 are simply added, no validation happens
        assert_seconds ("00:61:00", 3660);
        assert_seconds ("00:00:75", 75);
    });

    Test.add_func ("/time-util/extra-fields-are-ignored", () => {
        assert_seconds ("00:00:05:10", 5);
    });

    Test.add_func ("/time-util/null-and-blank", () => {
        assert_seconds (null, 0);
        assert_seconds ("", 0);
        assert_seconds (" ", 0);
        assert_seconds ("\t\n", 0);
    });

    Test.add_func ("/time-util/not-available", () => {
        assert_seconds ("N/A", 0);
        assert_seconds ("  N/A  ", 0);
        assert_seconds ("00:N/A:00", 0);
    });

    Test.add_func ("/time-util/too-few-fields", () => {
        assert_seconds ("00:01", 0);
        assert_seconds ("74", 0);
        assert_seconds ("74.5", 0);
        assert_seconds (":", 0);
    });

    Test.add_func ("/time-util/non-numeric", () => {
        assert_seconds ("garbage", 0);
        assert_seconds ("a:b:c", 0);
        assert_seconds ("::", 0);
    });

    Test.add_func ("/time-util/partially-numeric", () => {
        // int.parse () stops at the first invalid character
        assert_seconds ("00:01:xx", 60);
        assert_seconds ("xx:01:05", 65);
    });

    Test.add_func ("/time-util/negative-start-time", () => {
        // FFmpeg may print a slightly negative out_time at the start of a conversion
        assert_seconds ("-00:00:00.023", 0);
    });

    return Test.run ();
}

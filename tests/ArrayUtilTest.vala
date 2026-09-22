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
using Ciano.Tests;

GenericArray<string> make_array (string[] values) {
    var array = new GenericArray<string> ();

    foreach (string value in values) {
        array.add (value);
    }

    return array;
}

int main (string[] args) {
    Test.init (ref args);

    Test.add_func ("/array-util/join/both-empty", () => {
        var result = ArrayUtil.join_generic_string_arrays (make_array ({}), make_array ({}));
        assert_nonnull (result);
        assert_cmpuint (result.length, CompareOperator.EQ, 0);
    });

    Test.add_func ("/array-util/join/first-empty", () => {
        var result = ArrayUtil.join_generic_string_arrays (make_array ({}), make_array ({ "a", "b" }));
        TestUtil.assert_strv_equal ((string[]) result.data, { "a", "b" });
    });

    Test.add_func ("/array-util/join/second-empty", () => {
        var result = ArrayUtil.join_generic_string_arrays (make_array ({ "a", "b" }), make_array ({}));
        TestUtil.assert_strv_equal ((string[]) result.data, { "a", "b" });
    });

    Test.add_func ("/array-util/join/preserves-order", () => {
        var result = ArrayUtil.join_generic_string_arrays (
                make_array ({ "MP4", "AVI", "MKV" }),
                make_array ({ "MP3", "WAV" })
        );
        TestUtil.assert_strv_equal ((string[]) result.data, { "MP4", "AVI", "MKV", "MP3", "WAV" });
    });

    Test.add_func ("/array-util/join/keeps-duplicates", () => {
        var result = ArrayUtil.join_generic_string_arrays (make_array ({ "a", "b" }), make_array ({ "b", "a" }));
        TestUtil.assert_strv_equal ((string[]) result.data, { "a", "b", "b", "a" });
    });

    Test.add_func ("/array-util/join/keeps-empty-strings", () => {
        var result = ArrayUtil.join_generic_string_arrays (make_array ({ "" }), make_array ({ "", "x" }));
        TestUtil.assert_strv_equal ((string[]) result.data, { "", "", "x" });
    });

    Test.add_func ("/array-util/join/same-array-twice", () => {
        var array = make_array ({ "x", "y" });
        var result = ArrayUtil.join_generic_string_arrays (array, array);
        TestUtil.assert_strv_equal ((string[]) result.data, { "x", "y", "x", "y" });
        assert_cmpuint (array.length, CompareOperator.EQ, 2);
    });

    Test.add_func ("/array-util/join/does-not-modify-inputs", () => {
        var first = make_array ({ "a" });
        var second = make_array ({ "b", "c" });

        ArrayUtil.join_generic_string_arrays (first, second);

        TestUtil.assert_strv_equal ((string[]) first.data, { "a" });
        TestUtil.assert_strv_equal ((string[]) second.data, { "b", "c" });
    });

    Test.add_func ("/array-util/join/returns-new-instance", () => {
        var first = make_array ({ "a" });
        var second = make_array ({ "b" });
        var result = ArrayUtil.join_generic_string_arrays (first, second);

        assert_true (result != first);
        assert_true (result != second);

        // Changing the result must not affect the inputs
        result.add ("z");
        assert_cmpuint (first.length, CompareOperator.EQ, 1);
        assert_cmpuint (second.length, CompareOperator.EQ, 1);
    });

    Test.add_func ("/array-util/join/large-arrays", () => {
        var first = new GenericArray<string> ();
        var second = new GenericArray<string> ();

        for (int i = 0; i < 1000; i++) {
            first.add ("a%d".printf (i));
            second.add ("b%d".printf (i));
        }

        var result = ArrayUtil.join_generic_string_arrays (first, second);

        assert_cmpuint (result.length, CompareOperator.EQ, 2000);
        assert_cmpstr (result.get (0), CompareOperator.EQ, "a0");
        assert_cmpstr (result.get (999), CompareOperator.EQ, "a999");
        assert_cmpstr (result.get (1000), CompareOperator.EQ, "b0");
        assert_cmpstr (result.get (1999), CompareOperator.EQ, "b999");
    });

    return Test.run ();
}

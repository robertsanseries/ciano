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

int main (string[] args) {
    Test.init (ref args);

    Test.add_func ("/string-util/constants", () => {
        assert_cmpstr (StringUtil.SPACE, CompareOperator.EQ, " ");
        assert_cmpstr (StringUtil.EMPTY, CompareOperator.EQ, "");
        assert_cmpstr (StringUtil.BREAK_LINE, CompareOperator.EQ, "\n");
        assert_cmpint (StringUtil.EMPTY.length, CompareOperator.EQ, 0);
    });

    Test.add_func ("/string-util/is-empty/null", () => {
        assert_true (StringUtil.is_empty (null));
    });

    Test.add_func ("/string-util/is-empty/empty", () => {
        assert_true (StringUtil.is_empty (""));
        assert_true (StringUtil.is_empty (StringUtil.EMPTY));
    });

    Test.add_func ("/string-util/is-empty/whitespace-is-not-empty", () => {
        assert_false (StringUtil.is_empty (" "));
        assert_false (StringUtil.is_empty ("\t"));
        assert_false (StringUtil.is_empty ("\n"));
        assert_false (StringUtil.is_empty ("   "));
    });

    Test.add_func ("/string-util/is-empty/text", () => {
        assert_false (StringUtil.is_empty ("test"));
        assert_false (StringUtil.is_empty ("a"));
        assert_false (StringUtil.is_empty (" a "));
        assert_false (StringUtil.is_empty ("ção"));
    });

    Test.add_func ("/string-util/is-not-empty", () => {
        assert_false (StringUtil.is_not_empty (null));
        assert_false (StringUtil.is_not_empty (""));
        assert_true (StringUtil.is_not_empty (" "));
        assert_true (StringUtil.is_not_empty ("test"));
    });

    Test.add_func ("/string-util/is-not-empty/is-negation-of-is-empty", () => {
        string?[] values = { null, "", " ", "\t\n", "x", " x ", "ção" };

        foreach (string? value in values) {
            assert_true (StringUtil.is_not_empty (value) == !StringUtil.is_empty (value));
        }
    });

    Test.add_func ("/string-util/is-blank/null-and-empty", () => {
        assert_true (StringUtil.is_blank (null));
        assert_true (StringUtil.is_blank (""));
    });

    Test.add_func ("/string-util/is-blank/whitespace-only", () => {
        assert_true (StringUtil.is_blank (" "));
        assert_true (StringUtil.is_blank ("     "));
        assert_true (StringUtil.is_blank ("\t"));
        assert_true (StringUtil.is_blank ("\n"));
        assert_true (StringUtil.is_blank ("\r\n"));
        assert_true (StringUtil.is_blank (" \t \n "));
    });

    Test.add_func ("/string-util/is-blank/text", () => {
        assert_false (StringUtil.is_blank ("test"));
        assert_false (StringUtil.is_blank (" test "));
        assert_false (StringUtil.is_blank ("\ttest\n"));
        assert_false (StringUtil.is_blank ("."));
        assert_false (StringUtil.is_blank ("0"));
        assert_false (StringUtil.is_blank ("ção"));
    });

    Test.add_func ("/string-util/is-not-blank/is-negation-of-is-blank", () => {
        string?[] values = { null, "", " ", "\t\n", "x", " x ", "ção" };

        foreach (string? value in values) {
            assert_true (StringUtil.is_not_blank (value) == !StringUtil.is_blank (value));
        }
    });

    Test.add_func ("/string-util/is-blank/does-not-modify-input", () => {
        string value = "  padded  ";
        StringUtil.is_blank (value);
        assert_cmpstr (value, CompareOperator.EQ, "  padded  ");
    });

    return Test.run ();
}

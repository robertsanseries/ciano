/*
 * Copyright (c) 2017 Robert San <robertsanseries@gmail.com>
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

namespace Ciano.Utils {

    /**
     * The StringUtil class provides helper methods for string manipulation 
     * and validation, handling null inputs gracefully.
     *
     * @since 0.1.0
     */
    public class StringUtil {

        /**
         * A single space character constant.
         */
        public const string SPACE = " ";

        /**
         * An empty string constant.
         */
        public const string EMPTY = "";

        /**
         * A newline character constant.
         */
        public const string BREAK_LINE = "\n";

        /**
         * Checks if a string is null or has a length of zero.
         *
         * Examples:
         * {{{
         * StringUtil.is_empty (null)   = true
         * StringUtil.is_empty ("")     = true
         * StringUtil.is_empty (" ")    = false
         * StringUtil.is_empty ("test") = false
         * }}}
         *
         * @param value The string to check.
         * @return true if the string is empty or null, false otherwise.
         */
        public static bool is_empty (string? value) {
            return value == null || value.length == 0;
        }

        /**
         * Checks if a string is neither null nor empty.
         *
         * @param value The string to check.
         * @return true if the string has content, false if it is null or empty.
         */
        public static bool is_not_empty (string? value) {
            return !is_empty (value);
        }

        /**
         * Checks if a string is null, empty, or contains only whitespace characters.
         *
         * Examples:
         * {{{
         * StringUtil.is_blank (null)   = true
         * StringUtil.is_blank ("")     = true
         * StringUtil.is_blank (" ")    = true
         * StringUtil.is_blank ("test") = false
         * }}}
         *
         * @param value The string to check.
         * @return true if the string is null, empty, or whitespace only.
         */
        public static bool is_blank (string? value) {
            if (is_empty (value)) {
                return true;
            }

            // Use GLib's strip() to check if the string contains only spaces
            return value.strip ().length == 0;
        }

        /**
         * Checks if a string contains at least one non-whitespace character.
         *
         * @param value The string to check.
         * @return true if the string is not blank, false otherwise.
         */
        public static bool is_not_blank (string? value) {
            return !is_blank (value);
        }
    }
}

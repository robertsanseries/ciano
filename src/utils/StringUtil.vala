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
* Boston, MA 02110-1301 USACiano
*/

namespace Ciano.Utils {

    /**
     * The {@code StringUtil} class defines certain words related to
     * string handling.
     *
     * {@code StringUtil} handles {@code null} input strings quietly.
     * That is to say that a {@code null} input will return {@code null}.
     * Where a {@code boolean} or {@code int} is being returned
     * details vary by method.
     *
     * @since 0.1.0
     */
    public class StringUtil {

        /**
         * A space character.
         *
         * Exemple:
         * > StringUtil.SPACE
         */
        public const string SPACE = " ";

        /**
         * A empty string.
         * 
         * Exemple:
         * > StringUtil.EMPTY
         */
        public const string EMPTY = "";

        /**
         * Break line.
         * 
         * Exemple:
         * > StringUtil.BREAK_LINE
         */
        public const string BREAK_LINE = "\n";

        /**
         * Checks if a string is empty ("") or null.
         *
         * Exemple:
         * > StringUtil.is_empty(null)       = true
         * > StringUtil.is_empty("")         = true
         * > StringUtil.is_empty(" ")        = false
         * > StringUtil.is_empty("test")     = false
         * > StringUtil.is_empty("  test  ") = false
         * 
         * @param  {@code string} value - the string to check, not may be null
         * @return {@code bool} true - if the string is empty or null
         */
        public static bool is_empty (string? value) {
            return value == null || value.length == 0;
        }

        /**
         * Checks if a string is not empty ("") and not null.
         *
         * Exemple:
         * > StringUtil.is_not_empty(null)       = false
         * > StringUtil.is_not_empty("")         = false
         * > StringUtil.is_not_empty(" ")        = true
         * > StringUtil.is_not_empty("test")     = true
         * > StringUtil.is_not_empty("  test  ") = true
         *
         * @param  {@code string} value - the string to check, may be null
         * @return {@code bool} true -if the string is not empty and not null
         */
        public static bool is_not_empty (string? value) {
            return !is_empty (value);
        }

        /**
         * Checks if a string is empty (""), null or with whitespace.
         * 
         * Exemple:
         * > StringUtil.is_blank(null)       = true
         * > StringUtil.is_blank("")         = true
         * > StringUtil.is_blank(" ")        = true
         * > StringUtil.is_blank("test")     = false
         * > StringUtil.is_blank("  test  ") = false
         *
         * @param  {@code string} value - the string to check, may be null
         * @return {@code bool} - true if the string is null, empty or whitespace only
         */
        public static bool is_blank (string? value) {
            if (value == null || value.length == 0) {
                return true;
            }

            for (int i = 0; i < value.length; i++) {
                if (value[i] != ' ') {
                    return false;
                }
            }

            return true;
        }

        /**
         * Checks if a string is not empty (""), not null or has no whitespace.
         * 
         * Exemple:
         * > StringUtil.is_not_blank(null)       = false
         * > StringUtil.is_not_blank("")         = false
         * > StringUtil.is_not_blank(" ")        = false
         * > StringUtil.is_not_blank("test")     = true
         * > StringUtil.is_not_blank("  test  ") = true
         *
         * @param  {@code string} value - the string to check, may be null
         * @return {@code bool} - true if the string is not empty and not null and not whitespace only
         */
        public static bool is_not_blank (string? value) {
            return !is_blank (value);
        }
    }
}

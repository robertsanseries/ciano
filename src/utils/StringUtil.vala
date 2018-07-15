/*
* Copyright (c) 2017-2018 Robert San <robertsanseries@gmail.com>
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

    public class StringUtil {

        public const string EMPTY = "";
        public const string BREAK_LINE = "\n";

        public static bool is_empty (string? value) {
            return value == null || value.length == 0;
        }

        public static bool is_not_empty (string? value) {
            return !is_empty (value);
        }

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

        public static bool is_not_blank (string? value) {
            return !is_blank (value);
        }
    }
}

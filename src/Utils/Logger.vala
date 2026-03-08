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
     * The Logger class provides static methods for outputting formatted 
     * debug and error messages to the console with ANSI color support.
     *
     * @since 0.1.0
     */
    public class Logger {

        /**
         * Determines if debug-level messages should be displayed.
         */
        public static bool debug_mode = false;

        /**
         * Prints an informational message to the standard output.
         * Uses green color for the timestamp.
         * Always visible regardless of debug_mode.
         *
         * @param message The informational message string.
         */
        public static void info (string message) {
            var now = new DateTime.now_local ();
            print (
                    "\033[1;32m[%s]\033[0m [INFO] %s\n",
                    now.format ("%H:%M:%S"),
                    message
            );
        }

        /**
         * Prints a formatted debug message to the standard output if DEBUG_MODE is enabled.
         * Uses blue color for the timestamp.
         *
         * @param format The printf-style format string.
         * @param ... Variable arguments for the format string.
         */
        public static void debug (string format, ...) {
            if (debug_mode) {
                var now = new DateTime.now_local ();
                var list = va_list ();
                string message = format.vprintf (list);

                print (
                        "\033[1;34m[%s]\033[0m [DEBUG] %s\n",
                        now.format ("%H:%M:%S"),
                        message
                );
            }
        }

        /**
         * Prints an error message to the standard error output.
         * Uses red color for the timestamp.
         *
         * @param message The error message string.
         */
        public static void error (string message) {
            var now = new DateTime.now_local ();
            printerr (
                    "\033[1;31m[%s]\033[0m [ERROR] %s\n",
                    now.format ("%H:%M:%S"),
                    message
            );
        }
    }
}

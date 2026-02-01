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

namespace Ciano.Utils {

    public class Logger {

        public static bool DEBUG_MODE = false;

        public static void debug (string format, ...) {
            if (DEBUG_MODE) {
                var now = new DateTime.now_local ();
                var list = va_list ();
                string message = format.vprintf (list);
                
                print ("\033[1;34m[%s]\033[0m [DEBUG] %s\n", now.format ("%H:%M:%S"), message);
            }
        }

        public static void error (string message) {
            var now = new DateTime.now_local ();
            printerr ("\033[1;31m[%s]\033[0m [ERROR] %s\n", 
                      now.format ("%H:%M:%S"), 
                      message);
        }
    }
}

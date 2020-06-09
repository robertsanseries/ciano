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
* 
*/

namespace Ciano.Utils {

    /**
     * The class {@code TimeUtil} handles time-related data.
     *
     * @since 0.1.0
     */
    public class TimeUtil {
     
        /**
         * Responsible for getting the value of in string duration in 
         * the format "00:00:00:00.00" and returning the duration in seconds.
         *
         * Exemple:
         * > TimeUtil.duration_in_seconds("00:01:14:36.00")  = 74
         * 
         * @param  {@code string} duration
         * @return {@code int}
         */
        public static int duration_in_seconds (string duration) {
            string[] str = duration.split (".");
            string[] time = str[0].split (":");

            var hours = int.parse (time[0]);
            var mins = int.parse (time[1]);
            var secs = int.parse (time[2]);
            
            return secs + (hours * 3600) + (mins * 60);
        }
    }
}
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
* Boston, MA 02110-1301 USA
*/

namespace Ciano.Utils {

    public class ArrayUtil {

        public static GenericArray join_generic_string_arrays (GenericArray<string> array1, GenericArray<string> array2) {
            var new_array = new GenericArray<string> ();

           array1.foreach ((str) => {
                new_array.add (str);
            });

            array2.foreach ((str) => {
                new_array.add (str);
            });

            return new_array;
        }
    }
}
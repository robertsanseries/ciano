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
     * The {@code ArrayUtil} class is responsible for managing arrays.
     *
     * @since 0.1.5
     */
    public class ArrayUtil {

        /**
         * Join generic string arrays.
         *
         * Exemple:
         * > ArrayUtil.join_generic_string_arrays(new GenericArray<string>, new GenericArray<string>)
         * 
         * @param   {@code GenericArray<string>} array1
         * @param   {@code GenericArray<string>} array2
         * @return  {@code GenericArray} 
         */
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
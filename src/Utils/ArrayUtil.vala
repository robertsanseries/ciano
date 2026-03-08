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
     * The ArrayUtil class provides utility methods for managing and 
     * manipulating arrays and generic collections.
     *
     * @since 0.1.5
     */
    public class ArrayUtil {

        /**
         * Concatenates two generic string arrays into a single new generic array.
         *
         * Example:
         * {{{
         * var combined = ArrayUtil.join_generic_string_arrays (array1, array2);
         * }}}
         *
         * @param array1 The first generic string array.
         * @param array2 The second generic string array to append.
         * @return A new GenericArray containing elements from both input arrays.
         */
        public static GenericArray<string> join_generic_string_arrays (
            GenericArray<string> array1,
            GenericArray<string> array2
        ) {
            var new_array = new GenericArray<string> ();

            // Add elements from the first array
            for (int i = 0; i < array1.length; i++) {
                new_array.add (array1.get (i));
            }

            // Add elements from the second array
            for (int i = 0; i < array2.length; i++) {
                new_array.add (array2.get (i));
            }

            return new_array;
        }
    }
}

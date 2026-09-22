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

namespace Ciano.Tests {

    [CCode (cname = "CIANO_PROJECT_NAME")]
    public extern const string PROJECT_NAME;

    [CCode (cname = "CIANO_PROJECT_VERSION")]
    public extern const string PROJECT_VERSION;

    /**
     * Shared helpers for the unit tests.
     */
    public class TestUtil {

        /**
         * Asserts that two string arrays have the same elements in the same order,
         * printing both arrays when they differ.
         */
        public static void assert_strv_equal (string[] actual, string[] expected) {
            if (!strv_equal (actual, expected)) {
                Test.message ("expected: [%s]", string.joinv (", ", expected));
                Test.message ("actual:   [%s]", string.joinv (", ", actual));
            }

            assert_cmpint (actual.length, CompareOperator.EQ, expected.length);

            for (int i = 0; i < expected.length; i++) {
                assert_cmpstr (actual[i], CompareOperator.EQ, expected[i]);
            }
        }

        /**
         * Returns true if the array contains the given value.
         */
        public static bool contains (string[] array, string value) {
            foreach (string item in array) {
                if (item == value) {
                    return true;
                }
            }

            return false;
        }

        /**
         * Returns the index of the value in the array, or -1 when absent.
         */
        public static int index_of (string[] array, string value) {
            for (int i = 0; i < array.length; i++) {
                if (array[i] == value) {
                    return i;
                }
            }

            return -1;
        }

        /**
         * Marks the current test as incomplete (reported by TAP as a to-do) instead of failing
         * when a known bug is still present. Once the bug is fixed the test passes.
         *
         * @param correct Whether the code behaved correctly.
         * @param description Description of the known bug.
         */
        public static void known_bug (bool correct, string description) {
            if (!correct) {
                Test.incomplete ("known bug: " + description);
            }
        }

        /**
         * Creates a fresh temporary directory for a test.
         */
        public static string make_tmp_dir () {
            try {
                return DirUtils.make_tmp ("ciano-test-XXXXXX");
            } catch (Error e) {
                error ("Failed to create temporary directory: %s", e.message);
            }
        }

        /**
         * Recursively removes a directory created by make_tmp_dir.
         */
        public static void remove_tree (string path) {
            var file = File.new_for_path (path);

            try {
                if (file.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS) == FileType.DIRECTORY) {
                    var enumerator = file.enumerate_children (
                            FileAttribute.STANDARD_NAME, FileQueryInfoFlags.NOFOLLOW_SYMLINKS
                    );

                    FileInfo? info;
                    while ((info = enumerator.next_file ()) != null) {
                        remove_tree (Path.build_filename (path, info.get_name ()));
                    }
                }

                file.delete ();
            } catch (Error e) {
                // Best effort cleanup
            }
        }

        /**
         * Reads a whole text file.
         */
        public static string read_file (string path) {
            try {
                string contents;
                FileUtils.get_contents (path, out contents);
                return contents;
            } catch (Error e) {
                error ("Failed to read %s: %s", path, e.message);
            }
        }

        private static bool strv_equal (string[] a, string[] b) {
            if (a.length != b.length) {
                return false;
            }

            for (int i = 0; i < a.length; i++) {
                if (a[i] != b[i]) {
                    return false;
                }
            }

            return true;
        }
    }
}

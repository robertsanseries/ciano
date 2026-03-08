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
     * The FileUtil class provides utility methods for file and directory handling,
     * including creation, deletion, and launching system handlers.
     *
     * @since 0.1.0
     */
    public class FileUtil {

        /**
         * Opens a directory in the system's default file manager. 
         * Creates the directory and its parents if they do not exist.
         *
         * @param path The absolute path to the folder.
         */
        public static void open_folder_file_app (string path) {
            try {
                var directory = File.new_for_path (path);

                if (!directory.query_exists ()) {
                    directory.make_directory_with_parents ();
                }

                AppInfo.launch_default_for_uri (directory.get_uri (), null);
            } catch (Error e) {
                GLib.critical ("Failed to open folder: %s", e.message);
            }
        }

        /**
         * Creates a new file and writes an array of strings into it.
         * Ensures the target directory exists before creation.
         *
         * @param dir The target directory path.
         * @param name_file The name of the file to be created.
         * @param words An array of strings to write into the file.
         */
        public static void create_file (string dir, string name_file, string[] words) {
            try {
                var directory = File.new_for_path (dir);

                if (!directory.query_exists ()) {
                    directory.make_directory_with_parents ();
                }

                var file = File.new_for_path (dir + "/" + name_file);

                // Use StringBuilder for efficient string concatenation
                var builder = new StringBuilder ();
                foreach (string word in words) {
                    builder.append (StringUtil.SPACE);
                    builder.append (word);
                }

                if (!file.query_exists ()) {
                    var file_stream = file.create (FileCreateFlags.NONE);
                    var data_stream = new DataOutputStream (file_stream);
                    data_stream.put_string (builder.str);
                }
            } catch (Error e) {
                critical ("Failed to create file: %s", e.message);
            }
        }

        /**
         * Deletes a file from the specified directory if it exists.
         *
         * @param dir The directory containing the file.
         * @param name_file The name of the file to delete.
         */
        public static void delete_file (string dir, string name_file) {
            try {
                var file = File.new_for_path (dir + "/" + name_file);

                if (file.query_exists ()) {
                    file.delete ();
                }
            } catch (Error e) {
                critical ("Failed to delete file: %s", e.message);
            }
        }

        /**
         * Extracts the file extension from a given URI or path.
         *
         * @param uri The file path or URI string.
         * @return The extension string (without the dot) or an empty string if none found.
         */
        public static string get_file_extension_name (string uri) {
            int index = uri.last_index_of (".");

            if (index == -1) {
                return StringUtil.EMPTY;
            }
            return uri.substring (index + 1);
        }
    }
}

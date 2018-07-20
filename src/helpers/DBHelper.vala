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

using Ciano.Utils;

namespace Ciano.Helpers {

    public class DBHelper {

        public static string get_sqlite_provider () {
            return "SQLite";
        }

        public static File get_sqlite_db_dir () {
            return File.new_for_path (
            	Path.build_path (
            		Path.DIR_SEPARATOR_S, 
            		Environment.get_user_data_dir (), 
            		"ciano"
            	)
            );
        }

        public static string get_sqlite_hostname () {
            return "DB_DIR=%s;DB_NAME=%s".printf (get_sqlite_db_dir ().get_path (), "ciano");            
        }

        public static File get_sqlite_file_db (File sqlite_database_dir) {
            return sqlite_database_dir.get_child ("ciano.db");
        }

        public static bool exist_sqlite_db () {
            return get_sqlite_file_db ().query_exists ();
        }

        public static bool generate_sqlite_db_dir () {
            return get_sqlite_db_dir ().make_directory_with_parents ();
        }

        public static void generate_sqlite_file_db () {
            get_sqlite_file_db ().create (FileCreateFlags.PRIVATE);
        }
    }
}
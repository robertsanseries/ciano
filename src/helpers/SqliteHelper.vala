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

    public class SqliteHelper {

        public static string get_provider () {
            return "SQLite";
        }

        public static File get_database_dir () {
            return File.new_for_path (
                Path.build_path (
                    Path.DIR_SEPARATOR_S, 
                    Environment.get_user_data_dir (), 
                    "ciano"
                )
            );
        }

        public static string get_hostname () {
            return "DB_DIR=%s;DB_NAME=%s".printf (get_database_dir ().get_path (), "ciano");            
        }

        public static File get_database_file (File database_dir) {
            return database_dir.get_child ("ciano.db");
        }

        public static bool exist_database () {
            return get_database_file (get_database_dir ()).query_exists ();
        }

        public static bool generate_database_dir () {
            if(!get_database_dir().query_exists ()) {
                try {
                    return get_database_dir ().make_directory_with_parents ();        
                } catch (Error e) {
                    GLib.error (e.message);
                }
            }

            return true;
        }

        public static void generate_database_file () {
            try {
                get_database_file (get_database_dir ()).create (FileCreateFlags.PRIVATE);
            } catch (Error e) {
                GLib.error (e.message);   
            }
        }
    }
}
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

namespace Ciano.Models.DB {

    public class ConnectionFactory {

        public static Gda.Connection? get_connection () {
        	string provider     = "SQLite";
        	string data_dir     = Environment.get_user_data_dir ();
            string dir_path     = Path.build_path (Path.DIR_SEPARATOR_S, data_dir, "ciano");
            string database_dir = File.new_for_path (dir_path);
            string hostname     = "DB_DIR=%s;DB_NAME=%s".printf (database_dir.get_path (), "ciano");

        	try {
                return Gda.Connection.open_from_string (
                    provider,
                    hostname,
                    null,
                    Gda.ConnectionOptions.NONE
                );
            } catch (Error e) {
                GLib.error (e.message);
            }
            
            return null;
        }

        public static void close_connection (Gda.Connection? connection) {
        	try {
        		if (connection != null) {
        			connection.close();	
        		}
        	} catch (Error e) {
                GLib.error (e.message);
            }
        }
	}
}
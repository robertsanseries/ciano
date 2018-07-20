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

    public class Schema {

        private Gda.Connection connection;

        public Schema () {
            try {
                File sqlite_db_dir = DBHelper.get_sqlite_db_dir ();
                
                if (!DBHelper.exist_sqlite_db ()) {
                    DBHelper.generate_sqlite_db_dir ();
                    DBHelper.generate_sqlite_file_db ();
                    this.generate_table_arquive ();
                }
            } catch (Error e) {
                if (err is IOError.EXISTS == false) {
                    error (err.message);
                } else {
                    critical (e.message);    
                }
            }
        }

        private void generate_table_arquive () throws Error requires (this.connection.is_opened()) {
            Error e = null;
            var operation = Gda.ServerOperation.prepare_create_table (
                connection, "arquive", e,
                "id",         typeof (int),    Gda.ServerOperationCreateTableFlag.PKEY_AUTOINC_FLAG,
                "name",       typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                "url",        typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                "progress",   typeof (double), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                "percentage", typeof (int),    Gda.ServerOperationCreateTableFlag.NOTHING_FLAG
            );

            if (e != null) {
                critical (e.message);
            } else {
                try {
                    operation.perform_create_table ();
                } catch (Error e) {
                    GLib.message (e.message);
                }
            }
        }
    }
}
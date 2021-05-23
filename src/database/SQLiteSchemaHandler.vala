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

using Ciano.Helpers;

namespace Ciano.Database {

    public class SQLiteSchemaHandler {

        public static void init_loader () {
            if (!SqliteHelper.exist_database ()) {
                SqliteHelper.generate_database_dir ();
                SqliteHelper.generate_database_file ();
                create_table_arquive ();
            }
        }

        public static void create_table_arquive () {
            try {
                Gda.Connection? connection = ConnectionFactory.get_connection ();
                
                if (connection != null) {
                    Error e = null;
                    var operation = Gda.ServerOperation.prepare_create_table (
                        connection, "arquive", e,
                        "id",         typeof (int),    Gda.ServerOperationCreateTableFlag.PKEY_AUTOINC_FLAG,
                        "name",       typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                        "directory",  typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                        "uri",        typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                        "duration",   typeof (double), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                        "progress",   typeof (double), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                        "size",       typeof (long),   Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                        "percentage", typeof (int),    Gda.ServerOperationCreateTableFlag.NOTHING_FLAG
                    );

                    if (e != null) {
                        critical (e.message);
                    } else {
                        if(!operation.perform_create_table ()){
                            critical ("Erro ao cria a tabela arquive");
                        }
                    }

                    //connection.close ();   
                }
            } catch (Error e) {
                GLib.message (e.message);
            }
        }
    }
}
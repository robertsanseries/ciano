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

using Ciano.Database;
using Ciano.Models.Objects;

namespace Ciano.Models.DAO {

    public class ArchiveDAOImpl : ArchiveDAO {

        public ArchiveDAOImpl () {
        }

        public bool insert (Archive user){
            /*try {
                var builder = new Gda.SqlBuilder (Gda.SqlStatementType.INSERT);
                builder.set_table (NAME_TABLE);

                var name_val = Value (typeof (string));
                name_val.set_string (download.name);

                var url_val = Value (typeof (string));
                url_val.set_string (download.url);

                var progress_val = Value (typeof (double));
                progress_val.set_double (download.progress);

                var percentage_val = Value (typeof (int));
                percentage_val.set_int (download.percentage);

                builder.add_field_value_as_gvalue ("name", name_val);
                builder.add_field_value_as_gvalue ("url", url_val);
                builder.add_field_value_as_gvalue ("progress", progress_val);
                builder.add_field_value_as_gvalue ("percentage", percentage_val);

                Gda.Set inserted_row; // Variable to get the data of the inserted record
                var statement  = builder.get_statement ();

                this.database.get_connection().statement_execute_non_select (statement, null , out inserted_row);
                download.id = inserted_row.get_holder_value("+0").get_int(); // Get inserted record id
            } catch (Error e) {
                critical (e.message);
            }*/

            return true;
        }

        public Archive find (int id){
            stdout.printf("find");

            return new Archive ();
        }

        public GenericArray<Archive> selectAll (){
            /*this.downloads = new Gee.TreeSet<Download> ();

            try {
                var builder = new Gda.SqlBuilder (Gda.SqlStatementType.SELECT);
                builder.select_add_target (NAME_TABLE, null);
                builder.select_add_field ("*", null, null);

                var statement = builder.get_statement ();
                var data_model = this.database.get_connection().statement_execute_select (statement, null);

                for (int i = 0; i < data_model.get_n_rows (); i++) {
                    var item = mount_object_downoad(data_model, i);
                    this.downloads.add (item);
                }
            } catch (Error e) {
                critical (e.message);
            }*/

            return new GenericArray<Archive> ();;
        }

        public bool update (Archive user){
            /*try {
                var builder = new Gda.SqlBuilder (Gda.SqlStatementType.UPDATE);
                builder.set_table (NAME_TABLE);

                var name_val = Value (typeof (string));
                name_val.set_string (download.name);

                var url_val = Value (typeof (string));
                url_val.set_string (download.url);

                builder.add_field_value_as_gvalue ("name", name_val);
                builder.add_field_value_as_gvalue ("url", url_val);

                var where = builder.add_cond(
                    Gda.SqlOperatorType.EQ,
                    builder.add_field_id("id", NAME_TABLE),
                    builder.add_expr_value( null, download.id ),
                    0
                );

                builder.set_where( where );

                var statement = builder.get_statement ();
                this.database.get_connection().statement_execute_non_select (statement, null, null);
            } catch (Error e) {
                critical (e.message);
            }*/

            return true;
        }

        public bool delete (int id){
            /*try {
                var builder = new Gda.SqlBuilder (Gda.SqlStatementType.DELETE);
                builder.set_table (NAME_TABLE);

                var where = builder.add_cond(
                    Gda.SqlOperatorType.EQ,
                    builder.add_field_id("id", NAME_TABLE),
                    builder.add_expr_value( null, id),
                    0
                );

                builder.set_where( where );

                var statement = builder.get_statement ();
                this.database.get_connection().statement_execute_non_select (statement, null, null);
            } catch (Error e) {
                critical (e.message);
            }*/

            return true;
        }

        /*private Download mount_object_downoad(Gda.DataModel data_model , int row) {
            try {
                var id          = data_model.get_value_at (data_model.get_column_index ("id"),          row).get_int    ();
                var name        = data_model.get_value_at (data_model.get_column_index ("name"),        row).get_string ();
                var url         = data_model.get_value_at (data_model.get_column_index ("url"),         row).get_string ();
                var progress    = data_model.get_value_at (data_model.get_column_index ("progress"),    row).get_double ();
                var percentage  = data_model.get_value_at (data_model.get_column_index ("percentage"),  row).get_int    ();
                
                var download = new Download (id, name, url, progress, percentage);
                
                return download;

            } catch (Error e) {
                critical (e.message);
            }
            
            var download = new Download (null, StringUtil.EMPTY, StringUtil.EMPTY, 1, 100);
            return download;
        }*/
    }
}
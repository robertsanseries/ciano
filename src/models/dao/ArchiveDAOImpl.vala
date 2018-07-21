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

using Ciano.Models.DB;
using Ciano.Models.Objects;

namespace Ciano.Models.DAO {

    public class ArchiveDAOImpl : ArchiveDAO {

        public ArchiveDAOImpl () {
        }

        public bool insert (Archive user){
            stdout.printf("insert");

            return true;
        }

        public Archive find (int id){
            stdout.printf("find");

            return new Archive ("", "", "", 0, 0, 0, 0);
        }

        public GenericArray<Archive> selectAll (){
            stdout.printf("selectAll");

            return new GenericArray<Archive> ();;
        }

        public bool update (Archive user){
            stdout.printf("update");

            return true;
        }

        public bool delete (int id){
            stdout.printf("delete");

            return true;
        }
    }
}
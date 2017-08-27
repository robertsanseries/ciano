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

using Ciano.Enums;

namespace Ciano.Objects {

    public class ItemConversion {

        public int    id                { public get; public set; }
        public string name              { public get; public set; }
        public string directory         { public get; public set; }
        public string convert_to        { public get; public set; }
        public string time              { public get; public set; }
        public string size              { public get; public set; }
        public string bitrate           { public get; public set; }
        public double progress          { public get; public set; }
        public TypeItemEnum type_item   { public get; public set; }

        public ItemConversion (
            int id, 
            string name, 
            string directory, 
            string? convert_to, 
            string? time, 
            string? size, 
            string? bitrate, 
            double? progress, 
            TypeItemEnum type_item
        ) {            
            this.id = id;
            this.name = name;
            this.directory = directory;
            this.type_item = type_item;
            
            if (convert_to != null) {
                this.convert_to = convert_to;
            }

            if (time != null) {
                this.time = time;    
            }

            if (size != null) {
                this.size = size;    
            }

            if (bitrate != null) {
                this.bitrate = bitrate;    
            }            

            if (progress != null) {
                this.progress = progress;    
            }
        }
    }
}
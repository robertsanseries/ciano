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

    public class FormatsHelper {

        public static string[] get_supported_types () {
            GLib.GenericArray<string> formats = new GLib.GenericArray<string> ();
            
            formats = ArrayUtil.join_generic_string_arrays (
                get_supported_videos (),
                get_supported_musics ()
            );

            formats = ArrayUtil.join_generic_string_arrays (
                formats,
                get_supported_images ()
            );

            return formats.data;
        }

        public static GLib.GenericArray<string> get_supported_videos () {
            GLib.GenericArray<string> formats_videos = new GLib.GenericArray<string> ();
            formats_videos.add("MP4");
            formats_videos.add("3GP");
            formats_videos.add("MPG");
            formats_videos.add("AVI");
            formats_videos.add("WMV");
            formats_videos.add("FLV");
            formats_videos.add("SWF");
            formats_videos.add("MOV");
            formats_videos.add("MKV");
            formats_videos.add("VOB");
            formats_videos.add("OGV");
            formats_videos.add("WEBM");            

            return formats_videos;
        }

        public static GLib.GenericArray<string> get_supported_musics () {
            GLib.GenericArray<string> formats_musics = new GLib.GenericArray<string> ();
            formats_musics.add("MP3");
            formats_musics.add("WMA");
            formats_musics.add("AMR");
            formats_musics.add("OGG");
            formats_musics.add("AAC");
            formats_musics.add("MMF");
            formats_musics.add("M4A");
            formats_musics.add("WAV");
            formats_musics.add("FLAC");
            formats_musics.add("AIFF");
            
            return formats_musics;
        }

        public static GLib.GenericArray<string> get_supported_images () {
            GLib.GenericArray<string> formats_images = new GLib.GenericArray<string> ();
            formats_images.add("JPG");
            formats_images.add("BMP");
            formats_images.add("PNG");
            formats_images.add("TIF");
            formats_images.add("ICO");
            formats_images.add("GIF");
            formats_images.add("TGA");
            
            return formats_images;
        }
    }
}
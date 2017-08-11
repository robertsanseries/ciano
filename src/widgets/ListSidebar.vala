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

namespace Ciano.Widgets {

    /**
     * @descrition 
     * 
     * @author  Robert San <robertsanseries@gmail.com>
     * @type    Gtk.Grid
     */
    public class ListSidebar : Widgets.SourceList {

        /**
         * @signals
         */
        public signal void on_preferences_button_clicked ();

        /**
         * @variables
         */
        public Gtk.Button preferences;
        private SourceList.ExpandableItem type_list;       

        /**
         * @construct
         */
        public ListSidebar () {
        	this.type_list = new SourceList.ExpandableItem ("Convert file to");
        	this.type_list.selectable = false;
			this.type_list.expand_all ();

        	mount_video_list ();
        	mount_music_list ();
        	mount_image_list ();

        	this.root.add (this.type_list);
        }

        public void mount_video_list () {
			var video_list = new SourceList.ExpandableItem ("Video");
			video_list.icon = new GLib.ThemedIcon ("folder-videos");
			video_list.selectable = false;
			video_list.expand_all ();

			var mp4_item = new SourceList.Item ("MP4");
			var 3gp_item = new SourceList.Item ("3GP");
			var mpg_item = new SourceList.Item ("MPG");
			var avi_item = new SourceList.Item ("AVI");
			var wmv_item = new SourceList.Item ("WMV");
			var flv_item = new SourceList.Item ("FLV");
			var swf_item = new SourceList.Item ("SWF");

			video_list.add (mp4_item);
			video_list.add (3gp_item);
			video_list.add (mpg_item);
			video_list.add (avi_item);
			video_list.add (wmv_item);
			video_list.add (flv_item);
			video_list.add (swf_item);

			this.type_list.add (video_list);
        }

        public void mount_music_list () {
			var music_list = new SourceList.ExpandableItem ("Music");
			music_list.icon = new GLib.ThemedIcon ("folder-music");
			music_list.selectable = false;

			var mp3_item = new SourceList.Item ("MP3");
			var wma_item = new SourceList.Item ("WMA");
			var amr_item = new SourceList.Item ("AMR");
			var ogg_item = new SourceList.Item ("OGG");
			var acc_item = new SourceList.Item ("AAC");
			var wav_item = new SourceList.Item ("WAV");

			music_list.add (mp3_item);
			music_list.add (wma_item);
			music_list.add (amr_item);
			music_list.add (ogg_item);
			music_list.add (acc_item);
			music_list.add (wav_item);

	        this.type_list.add (music_list);
        }

        public void mount_image_list () {
			var image_list = new SourceList.ExpandableItem ("Image");
			image_list.icon = new GLib.ThemedIcon ("folder-pictures");
			image_list.selectable = false;

			var jpg_item = new SourceList.Item ("JPG");
			var bmp_item = new SourceList.Item ("BMP");
			var png_item = new SourceList.Item ("PNG");
			var tif_item = new SourceList.Item ("TIF");
			var ico_item = new SourceList.Item ("ICO");
			var gif_item = new SourceList.Item ("GIF");
			var tga_item = new SourceList.Item ("TGA");

			image_list.add (jpg_item);
			image_list.add (bmp_item);
			image_list.add (png_item);
			image_list.add (tif_item);
			image_list.add (ico_item);
			image_list.add (gif_item);
			image_list.add (tga_item);

			this.type_list.add (image_list);
        }
    }
}
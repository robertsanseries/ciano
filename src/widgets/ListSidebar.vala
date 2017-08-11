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
using Ciano.Config;

namespace Ciano.Widgets {

    /**
     * @descrition 
     * 
     * @author  Robert San <robertsanseries@gmail.com>
     * @type    Gtk.Grid
     */
    public class ListSidebar : SourceList {

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
        	this.type_list = new SourceList.ExpandableItem (Properties.TEXT_CONVERT_FILE_TO);
        	this.type_list.selectable = false;
			this.type_list.expand_all ();

        	mount_video_list ();
        	mount_music_list ();
        	mount_image_list ();

        	this.root.add (this.type_list);
        }

        public void mount_video_list () {
			var video_list = new SourceList.ExpandableItem (Properties.TEXT_VIDEO);
			video_list.icon = new GLib.ThemedIcon ("folder-videos");
			video_list.selectable = false;
			video_list.expand_all ();

			var mp4_item = new SourceList.Item (Properties.TEXT_MP4);
			var 3gp_item = new SourceList.Item (Properties.TEXT_3GP);
			var mpg_item = new SourceList.Item (Properties.TEXT_MPG);
			var avi_item = new SourceList.Item (Properties.TEXT_AVI);
			var wmv_item = new SourceList.Item (Properties.TEXT_WMV);
			var flv_item = new SourceList.Item (Properties.TEXT_FLV);
			var swf_item = new SourceList.Item (Properties.TEXT_SWF);

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
			var music_list = new SourceList.ExpandableItem (Properties.TEXT_MUSIC);
			music_list.icon = new GLib.ThemedIcon ("folder-music");
			music_list.selectable = false;

			var mp3_item = new SourceList.Item (Properties.TEXT_MP3);
			var wma_item = new SourceList.Item (Properties.TEXT_WMA);
			var amr_item = new SourceList.Item (Properties.TEXT_AMR);
			var ogg_item = new SourceList.Item (Properties.TEXT_OGG);
			var acc_item = new SourceList.Item (Properties.TEXT_AAC);
			var wav_item = new SourceList.Item (Properties.TEXT_WAV);

			music_list.add (mp3_item);
			music_list.add (wma_item);
			music_list.add (amr_item);
			music_list.add (ogg_item);
			music_list.add (acc_item);
			music_list.add (wav_item);

	        this.type_list.add (music_list);
        }

        public void mount_image_list () {
			var image_list = new SourceList.ExpandableItem (Properties.TEXT_IMAGE);
			image_list.icon = new GLib.ThemedIcon ("folder-pictures");
			image_list.selectable = false;

			var jpg_item = new SourceList.Item (Properties.TEXT_JPG);
			var bmp_item = new SourceList.Item (Properties.TEXT_BMP);
			var png_item = new SourceList.Item (Properties.TEXT_PNG);
			var tif_item = new SourceList.Item (Properties.TEXT_TIF);
			var ico_item = new SourceList.Item (Properties.TEXT_ICO);
			var gif_item = new SourceList.Item (Properties.TEXT_GIF);
			var tga_item = new SourceList.Item (Properties.TEXT_TGA);

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
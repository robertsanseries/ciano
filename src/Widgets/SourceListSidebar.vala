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

using Ciano.Configs;

namespace Ciano.Widgets {

   /**
     * The {@code SourceListSidebar} class is responsible for assembling the list with
     * the types of items that are supported for conversion.
     *
     * @see Ciano.Widgets.SourceList
     * @since 0.1.0
     */
    public class SourceListSidebar : SourceList {

        private SourceList.ExpandableItem type_list;
        public Gtk.Button                 preferences;
        
        /**
         * Constructs a new {@code DialogConvertFile} object responsible for mount sidebar structure.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Widgets.SourceList.ExpandableItem
         * @see mount_video_list
         * @see mount_music_list
         * @see mount_image_list
         */
        public SourceListSidebar () {
            this.type_list = new SourceList.ExpandableItem (Properties.TEXT_CONVERT_FILE_TO);
            this.type_list.selectable = false;
            this.type_list.expand_all ();

            mount_video_list ();
            mount_music_list ();
            mount_image_list ();

            this.root.add (this.type_list);
        }

        /**
         * Creates the Videos section with the types supported in the application.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Configs.Constants
         * @see Ciano.Widgets.SourceList.ExpandableItem
         * @see Ciano.Widgets.SourceList.Item
         */
        public void mount_video_list () {
            var video_list = new SourceList.ExpandableItem (Properties.TEXT_VIDEO);
            video_list.icon = new GLib.ThemedIcon ("folder-videos");
            video_list.selectable = false;
            video_list.expand_all ();

            var mp4_item = new SourceList.Item (Constants.TEXT_MP4);
            var mpg_item = new SourceList.Item (Constants.TEXT_MPG);
            var avi_item = new SourceList.Item (Constants.TEXT_AVI);
            var wmv_item = new SourceList.Item (Constants.TEXT_WMV);
            var flv_item = new SourceList.Item (Constants.TEXT_FLV);
            var mkv_item = new SourceList.Item (Constants.TEXT_MKV);
            var 3gp_item = new SourceList.Item (Constants.TEXT_3GP);
            var mov_item = new SourceList.Item (Constants.TEXT_MOV);
            var vob_item = new SourceList.Item (Constants.TEXT_VOB);
            var ogv_item = new SourceList.Item (Constants.TEXT_OGV);
            var webm_item = new SourceList.Item (Constants.TEXT_WEBM);

            video_list.add (mp4_item);
            video_list.add (mpg_item);
            video_list.add (avi_item);
            video_list.add (wmv_item);
            video_list.add (flv_item);
            video_list.add (mkv_item);
            video_list.add (3gp_item);
            video_list.add (mov_item);
            video_list.add (vob_item);
            video_list.add (ogv_item);
            video_list.add (webm_item);

            this.type_list.add (video_list);
        }

        /**
         * Creates the Music's section with the types supported in the application.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Configs.Constants
         * @see Ciano.Widgets.SourceList.ExpandableItem
         * @see Ciano.Widgets.SourceList.Item
         */
        public void mount_music_list () {
            var music_list = new SourceList.ExpandableItem (Properties.TEXT_MUSIC);
            music_list.icon = new GLib.ThemedIcon ("folder-music");
            music_list.selectable = false;

            var mp3_item = new SourceList.Item (Constants.TEXT_MP3);
            var wma_item = new SourceList.Item (Constants.TEXT_WMA);
            var ogg_item = new SourceList.Item (Constants.TEXT_OGG);
            var wav_item = new SourceList.Item (Constants.TEXT_WAV);
            var aac_item = new SourceList.Item (Constants.TEXT_AAC);
            var flac_item = new SourceList.Item (Constants.TEXT_FLAC);
            var aiff_item = new SourceList.Item (Constants.TEXT_AIFF);            
            var mmf_item = new SourceList.Item (Constants.TEXT_MMF);
            var m4a_item = new SourceList.Item (Constants.TEXT_M4A);
            var opus_item = new SourceList.Item (Constants.TEXT_OPUS);

            music_list.add (mp3_item);
            music_list.add (wma_item);
            music_list.add (ogg_item);
            music_list.add (wav_item);
            music_list.add (aac_item);
            music_list.add (flac_item);
            music_list.add (aiff_item);
            music_list.add (mmf_item);
            music_list.add (m4a_item);
            music_list.add (opus_item);

            this.type_list.add (music_list);
        }

        /**
         * Creates the Pictures section with the types supported in the application.
         *
         * @see Ciano.Configs.Properties
         * @see Ciano.Configs.Constants
         * @see Ciano.Widgets.SourceList.ExpandableItem
         * @see Ciano.Widgets.SourceList.Item
         */
        public void mount_image_list () {
            var image_list = new SourceList.ExpandableItem (Properties.TEXT_IMAGE);
            image_list.icon = new GLib.ThemedIcon ("folder-pictures");
            image_list.selectable = false;

            var jpg_item = new SourceList.Item (Constants.TEXT_JPG);
            var bmp_item = new SourceList.Item (Constants.TEXT_BMP);
            var png_item = new SourceList.Item (Constants.TEXT_PNG);
            var tif_item = new SourceList.Item (Constants.TEXT_TIF);
            var gif_item = new SourceList.Item (Constants.TEXT_GIF);
            var tga_item = new SourceList.Item (Constants.TEXT_TGA);
            var webp_item = new SourceList.Item (Constants.TEXT_WEBP);

            image_list.add (jpg_item);
            image_list.add (bmp_item);
            image_list.add (png_item);
            image_list.add (tif_item);
            image_list.add (gif_item);
            image_list.add (tga_item);
            image_list.add (webp_item);

            this.type_list.add (image_list);
        }
    }
}

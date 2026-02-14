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

        private SourceItem type_list;
        public Gtk.Button preferences;
        
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
            var root_item = new SourceItem ("Root", null);
            base (root_item);

            this.type_list = new SourceItem (Properties.TEXT_CONVERT_FILE_TO, null);
            this.type_list.selectable = false;

            mount_video_list ();
            mount_music_list ();
            mount_image_list ();

            this.root_item.append_child (this.type_list);
            
            this.initialize_model(); 
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
            var video_list = new SourceItem (Properties.TEXT_VIDEO, Constants.FOLDER_VIDEO_SYMBOLIC);
            video_list.selectable = false;

            video_list.append_child (new SourceItem (Constants.TEXT_MP4, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_MPG, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_AVI, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_WMV, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_FLV, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_MKV, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_3GP, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_MOV, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_VOB, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_OGV, Constants.MEDIA_VIDEO_SYMBOLIC));
            video_list.append_child (new SourceItem (Constants.TEXT_WEBM, Constants.MEDIA_VIDEO_SYMBOLIC));

            this.type_list.append_child (video_list);
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
            var music_list = new SourceItem (Properties.TEXT_MUSIC, Constants.FOLDER_MUSIC_SYMBOLIC);
            music_list.selectable = false;

            music_list.append_child (new SourceItem (Constants.TEXT_MP3, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_WMA, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_OGG, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_WAV, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_AAC, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_FLAC, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_AIFF, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_MMF, Constants.AUDIO_GENERIC_SYMBOLIC));
            music_list.append_child (new SourceItem (Constants.TEXT_M4A, Constants.AUDIO_GENERIC_SYMBOLIC));

            this.type_list.append_child (music_list);
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
            var image_list = new SourceItem (Properties.TEXT_IMAGE, Constants.FOLDER_PICTURES_SYMBOLIC);
            image_list.selectable = false;

            image_list.append_child (new SourceItem (Constants.TEXT_JPG, Constants.IMAGE_GENERIC_SYMBOLIC));
            image_list.append_child (new SourceItem (Constants.TEXT_BMP, Constants.IMAGE_GENERIC_SYMBOLIC));
            image_list.append_child (new SourceItem (Constants.TEXT_PNG, Constants.IMAGE_GENERIC_SYMBOLIC));
            image_list.append_child (new SourceItem (Constants.TEXT_TIF, Constants.IMAGE_GENERIC_SYMBOLIC));
            image_list.append_child (new SourceItem (Constants.TEXT_GIF, Constants.IMAGE_GENERIC_SYMBOLIC));
            image_list.append_child (new SourceItem (Constants.TEXT_TGA, Constants.IMAGE_GENERIC_SYMBOLIC));

            this.type_list.append_child (image_list);
        }
    }
}

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
     * SourceListSidebar is responsible for assembling the navigation sidebar
     * containing all supported conversion formats grouped by media type.
     *
     * @see Ciano.Widgets.SourceList
     * @since 0.1.0
     */
    public class SourceListSidebar : SourceList {

        /**
         * Constructs a new SourceListSidebar.
         * Initializes the root hierarchy and populates the lists for video, music, and images.
         */
        public SourceListSidebar () {
            var root = new SourceItem ("Root", null);
            base (root);

            // Create the main container for formats
            // var format_group = new SourceItem (Properties.TEXT_CONVERT_FILE_TO, null);
            // format_group.selectable = false;

            this.mount_video_list (root);
            this.mount_music_list (root);
            this.mount_image_list (root);

            // this.root_item.append_child (format_group);

            this.initialize_model ();
        }

        /**
         * Populates the video conversion formats list.
         * @param parent The parent SourceItem to attach the video list to.
         */
        private void mount_video_list (SourceItem parent) {
            var video_list = new SourceItem (Properties.TEXT_VIDEO, Constants.ICON_FOLDER_VIDEO);
            video_list.selectable = false;

            video_list.append_child (new SourceItem (Constants.TEXT_MP4, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_MPG, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_AVI, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_WMV, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_FLV, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_SWF, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_MKV, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_3GP, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_MOV, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_VOB, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_OGV, Constants.ICON_MEDIA_VIDEO));
            video_list.append_child (new SourceItem (Constants.TEXT_WEBM, Constants.ICON_MEDIA_VIDEO));

            parent.append_child (video_list);
        }

        /**
         * Populates the music conversion formats list.
         * @param parent The parent SourceItem to attach the music list to.
         */
        private void mount_music_list (SourceItem parent) {
            var music_list = new SourceItem (Properties.TEXT_MUSIC, Constants.ICON_FOLDER_MUSIC);
            music_list.selectable = false;

            music_list.append_child (new SourceItem (Constants.TEXT_MP3, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_WMA, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_OGG, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_WAV, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_AAC, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_FLAC, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_AIFF, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_MMF, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_M4A, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_AMR, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_OPUS, Constants.ICON_AUDIO_GENERIC));
            music_list.append_child (new SourceItem (Constants.TEXT_AT9, Constants.ICON_AUDIO_GENERIC));

            parent.append_child (music_list);
        }

        /**
         * Populates the image conversion formats list.
         * @param parent The parent SourceItem to attach the image list to.
         */
        private void mount_image_list (SourceItem parent) {
            var image_list = new SourceItem (Properties.TEXT_IMAGE, Constants.ICON_FOLDER_PICTURES);
            image_list.selectable = false;

            image_list.append_child (new SourceItem (Constants.TEXT_JPG, Constants.ICON_IMAGE_GENERIC));
            image_list.append_child (new SourceItem (Constants.TEXT_BMP, Constants.ICON_IMAGE_GENERIC));
            image_list.append_child (new SourceItem (Constants.TEXT_PNG, Constants.ICON_IMAGE_GENERIC));
            image_list.append_child (new SourceItem (Constants.TEXT_TIF, Constants.ICON_IMAGE_GENERIC));
            image_list.append_child (new SourceItem (Constants.TEXT_GIF, Constants.ICON_IMAGE_GENERIC));
            image_list.append_child (new SourceItem (Constants.TEXT_TGA, Constants.ICON_IMAGE_GENERIC));
            image_list.append_child (new SourceItem (Constants.TEXT_ICO, Constants.ICON_IMAGE_GENERIC));

            parent.append_child (image_list);
        }
    }
}

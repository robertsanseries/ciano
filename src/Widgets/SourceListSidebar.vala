/*
 * Copyright (c) 2017, 2026 Robert San <robertsanseries@gmail.com>
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
using Ciano.Utils;

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
            var video_list = new SourceItem (_("Video"), Constants.ICON_FOLDER_VIDEO);
            video_list.selectable = false;

            foreach (string format in FormatUtil.get_video_targets ()) {
                video_list.append_child (new SourceItem (format, Constants.ICON_MEDIA_VIDEO));
            }

            parent.append_child (video_list);
        }

        /**
         * Populates the music conversion formats list.
         * @param parent The parent SourceItem to attach the music list to.
         */
        private void mount_music_list (SourceItem parent) {
            var music_list = new SourceItem (_("Music"), Constants.ICON_FOLDER_MUSIC);
            music_list.selectable = false;

            foreach (string format in FormatUtil.get_audio_targets ()) {
                music_list.append_child (new SourceItem (format, Constants.ICON_AUDIO_GENERIC));
            }

            parent.append_child (music_list);
        }

        /**
         * Populates the image conversion formats list.
         * @param parent The parent SourceItem to attach the image list to.
         */
        private void mount_image_list (SourceItem parent) {
            var image_list = new SourceItem (_("Image"), Constants.ICON_FOLDER_PICTURES);
            image_list.selectable = false;

            foreach (string format in FormatUtil.get_image_targets ()) {
                image_list.append_child (new SourceItem (format, Constants.ICON_IMAGE_GENERIC));
            }

            parent.append_child (image_list);
        }
    }
}

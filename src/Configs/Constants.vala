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

namespace Ciano.Configs {

    /**
     * The Constants class defines immutable global values used throughout 
     * the application, such as IDs, URLs, and file format strings.
     *
     * @since 0.1.0
     */
    public class Constants {

        // Application Metadata
        public abstract const string PROGRAME_NAME = "Ciano";
        public abstract const string ID = "com.github.robertsanseries.ciano";
        public abstract const string VERSION = "0.2.5";
        public abstract const string APP_ICON = "com.github.robertsanseries.ciano";

        // Project URLs
        public abstract const string AUTHOR_URL = "https://github.com/robertsanseries";
        public abstract const string BUG_URL = "https://github.com/robertsanseries/ciano/issues";
        public abstract const string HELP_URL = "https://github.com/robertsanseries/ciano/issues";
        public abstract const string TRANSLATE_URL = "https://github.com/robertsanseries/ciano/wiki/Translate";
        public abstract const string LICENSE_URL = "https://www.gnu.org/licenses/gpl-3.0.html";

        // System Paths and View IDs
        public abstract const string DIRECTORY_CIANO = "/Ciano";
        public abstract const string WELCOME_VIEW = "welcome-view";
        public abstract const string LIST_BOX_VIEW = "list-box-view";

        // Video Formats
        public abstract const string TEXT_MP4 = "MP4";
        public abstract const string TEXT_3GP = "3GP";
        public abstract const string TEXT_MPG = "MPG";
        public abstract const string TEXT_AVI = "AVI";
        public abstract const string TEXT_WMV = "WMV";
        public abstract const string TEXT_FLV = "FLV";
        public abstract const string TEXT_SWF = "SWF";
        public abstract const string TEXT_MOV = "MOV";
        public abstract const string TEXT_MKV = "MKV";
        public abstract const string TEXT_VOB = "VOB";
        public abstract const string TEXT_OGV = "OGV";
        public abstract const string TEXT_WEBM = "WEBM";

        // Audio Formats
        public abstract const string TEXT_MP3 = "MP3";
        public abstract const string TEXT_WMA = "WMA";
        public abstract const string TEXT_AMR = "AMR";
        public abstract const string TEXT_OGG = "OGG";
        public abstract const string TEXT_AAC = "AAC";
        public abstract const string TEXT_MMF = "MMF";
        public abstract const string TEXT_M4A = "M4A";
        public abstract const string TEXT_WAV = "WAV";
        public abstract const string TEXT_FLAC = "FLAC";
        public abstract const string TEXT_AIFF = "AIFF";
        public abstract const string TEXT_OPUS = "OPUS";
        public abstract const string TEXT_AT9 = "AT9";
        public abstract const string TEXT_SHN = "SHN";

        // Image Formats
        public abstract const string TEXT_JPG = "JPG";
        public abstract const string TEXT_BMP = "BMP";
        public abstract const string TEXT_PNG = "PNG";
        public abstract const string TEXT_TIF = "TIF";
        public abstract const string TEXT_ICO = "ICO";
        public abstract const string TEXT_GIF = "GIF";
        public abstract const string TEXT_TGA = "TGA";

        // System Icon Names
        public abstract const string ICON_FOLDER_VIDEO = "folder-videos";
        public abstract const string ICON_MEDIA_VIDEO = "media-video";
        public abstract const string ICON_FOLDER_MUSIC = "folder-music";
        public abstract const string ICON_AUDIO_GENERIC = "audio-x-generic";
        public abstract const string ICON_FOLDER_PICTURES = "folder-pictures";
        public abstract const string ICON_IMAGE_GENERIC = "image-x-generic";
    }
}

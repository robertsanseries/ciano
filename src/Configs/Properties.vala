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
     * The Properties class contains all translatable strings used in the application.
     * Centralizing these strings facilitates localization (gettext support).
     *
     * @since 0.1.0
     */
    public class Properties {

        // widgets/DialogAbout.vala
        public abstract const string TEXT_ABOUT = _("About");
        // widgets/DialogAbout.vala
        public abstract const string TEXT_HELP = _("Help");
        // widgets/DialogAbout.vala
        public abstract const string TEXT_SUGGEST_TRANSLATIONS = _("Suggest Translations");
        // widgets/DialogAbout.vala
        public abstract const string TEXT_REPORT_PROBLEM = _("Report a Problem");
        // widgets/DialogAbout.vala
        public abstract const string TEXT_APP_DESCRIPTION = _("A multimedia file converter focused on simplicity.");
        // widgets/DialogAbout.vala
        public abstract const string TEXT_FOR_ABOUT_LICENSE = _("This program is published under the terms of the GNU General Public License; it comes with ABSOLUTELY NO WARRANTY; for details, visit: "); // vala-lint: disable=line-length

        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_CONVERT_FILE = _("Convert File");
        // widgets/DialogConvertFile.vala
        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_CONVERT_FILE_TO = _("Convert to");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_ADD_ITEMS_TO_CONVERSION = _("Add items to conversion:");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_ADD_FILE = _("Add file");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_DELETE = _("Delete");
        // widgets/DialogConvertFile.vala
        // widgets/RowConversion.vala
        public abstract const string TEXT_CANCEL = _("Cancel");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_NAME = _("Name");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_DIRECTORY = _("Directory");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_START_CONVERSION = _("Start conversion");

        // widgets/DialogPreferences.vala
        // widgets/HeaderBarMainContent.vala
        public abstract const string TEXT_PREFERENCES = _("Preferences");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_OUTPUT_FOLDER = _("Output folder:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_OUTPUT_SOURCE_FILE_FOLDER = _("Files origin:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_SELECT_OUTPUT_FOLDER = _("Select the output folder:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_NOTIFY = _("Notifications:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_COMPLETE_NOTIFY = _("Notify about completed action:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_ERRO_NOTIFY = _("Notify about an error:");
        // widgets/DialogPreferences.vala
        // widgets/DialogAbout.vala
        public abstract const string TEXT_CLOSE = _("Close");

        // widgets/PopoverSettings.vala
        public abstract const string TEXT_FOLLOW_SYSTEM_APPEARANCE = _("Follow system appearance");

        // widgets/HeaderBarMainContent.vala
        public abstract const string TEXT_OPEN_OUTPUT_FOLDER = _("Open output folder");
        // widgets/HeaderBarMainContent.vala
        public abstract const string TEXT_SETTINGS = _("Settings");

        // widgets/ListConversion.vala
        public abstract const string TEXT_EMPTY_CONVERTING_LIST = _("Empty conversion list");
        // widgets/ListConversion.vala
        public abstract const string TEXT_SELECT_OPTION_TO_CONVERT = _(
                "Select an option from the side menu to which you want to \n convert your file"
        );

        // widgets/RowConversion.vala
        public abstract const string TEXT_STARTING = _("Starting…");
        // widgets/RowConversion.vala
        public abstract const string TEXT_CANCEL_CONVERSION = _("Cancel conversion");
        // widgets/RowConversion.vala
        public abstract const string TEXT_REMOVE = _("Remove");
        // widgets/RowConversion.vala
        public abstract const string TEXT_REMOVE_ITEM_FROM_LIST = _("Remove item from list");

        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_VIDEO = _("Video");
        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_MUSIC = _("Music");
        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_IMAGE = _("Image");

        // controllers/ConverterController.vala
        public abstract const string TEXT_SELECT_FILE = _("Select file");
        // controllers/ConverterController.vala
        public abstract const string TEXT_SUCESS_IN_CONVERSION = _("Conversion completed");
        // controllers/ConverterController.vala
        public abstract const string TEXT_CANCEL_IN_CONVERSION = _("Conversion canceled");
        // controllers/ConverterController.vala
        public abstract const string TEXT_ERROR_IN_CONVERSION = _("Error in conversion");

        // controllers/ConverterController.vala (FFmpeg parsing)
        public abstract const string MSG_ERROR_CODECS = _("Error: Experimental codecs are not enabled");
        // controllers/ConverterController.vala (FFmpeg parsing)
        public abstract const string MSG_ERROR_INVALID_INPUT_DATA = _(
                "Error: Invalid data found when processing input"
        );
        // controllers/ConverterController.vala (FFmpeg parsing)
        public abstract const string MSG_ERROR_NO_SUCH_FILE_DIRECTORY = _("Error: No such file or directory");
        // controllers/ConverterController.vala (FFmpeg parsing)
        public abstract const string MSG_ERROR_INVALID_ARGUMENT = _("Error: Invalid argument");
    }
}

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
     * The {@code Properties} class is responsible for defining all 
     * the texts that are displayed in the application and must be translated.
     *
     * @since 0.1.0
     */
    public class Properties {
        
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_CONVERT_FILE                  = _("Convert File");
        // widgets/DialogConvertFile.vala // widgets/SourceListSidebar.vala
        public abstract const string TEXT_CONVERT_FILE_TO               = _("Convert file to");
        // widgets/DialogConvertFile.vala
        public abstract const string NAME                               = _("Name");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_ADD_ITEMS_TO_CONVERSION       = _("Add items to conversion:");
        // widgets/DialogConvertFile.vala
        public abstract const string DIRECTORY                          = _("Directory");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_ADD_FILE                      = _("Add file");
        // widgets/DialogConvertFile.vala
        public abstract const string TEXT_DELETE                        = _("Delete");
        // widgets/DialogConvertFile.vala // widgets/RowConversion.vala // controller/ConverterController.vala
        public abstract const string TEXT_CANCEL                        = _("Cancel");
        // widgets/DialogConvertFile.vala 
        public abstract const string TEXT_START_CONVERSION              = _("Start conversion");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_OUTPUT_FOLDER                 = _("Output folder:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_OUTPUT_SOURCE_FILE_FOLDER     = _("Files origin:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_SELECT_OUTPUT_FOLDER          = _("Select the output folder:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_NOTIFY                        = _("Notifications:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_COMPLETE_NOTIFY               = _("Notify about completed action:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_ERRO_NOTIFY                   = _("Notify about an error:");
        // widgets/DialogPreferences.vala
        public abstract const string TEXT_CLOSE                         = _("Close");
        // widgets/HeaderBar.vala
        public abstract const string TEXT_OPEN_OUTPUT_FOLDER            = _("Open output folder");
        // widgets/HeaderBar.vala
        public abstract const string TEXT_SETTINGS                      = _("Settings");
        // widgets/HeaderBar.vala //widgets/DialogPreferences.vala
        public abstract const string TEXT_PREFERENCES                   = _("Preferences"); 
        // widgets/ListConversion.vala
        public abstract const string TEXT_EMPTY_CONVERTING_LIST         = _("Empty conversion list");
        // widgets/ListConversion.vala
        public abstract const string TEXT_SELECT_OPTION_TO_CONVERT      = _("Select an option from the side menu to which you want to \n convert your file");
        // widgets/RowConversion.vala
        public abstract const string TEXT_STARTING                      = _("Starting...");
        // widgets/RowConversion.vala
        public abstract const string TEXT_CANCEL_CONVERSION             = _("Cancel conversion");
        // widgets/RowConversion.vala
        public abstract const string TEXT_REMOVE                        = _("Remove");
        // widgets/RowConversion.vala
        public abstract const string TEXT_REMOVE_ITEM_FROM_LIST         = _("Remove item from list");
        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_VIDEO                         = _("Video");
        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_MUSIC                         = _("Music");
        // widgets/SourceListSidebar.vala
        public abstract const string TEXT_IMAGE                         = _("Image");
        // controllers/ConverterController.vala
        public abstract const string TEXT_SELECT_FILE                   = _("Select file");
        // controllers/ConverterController.vala
        public abstract const string TEXT_ADD                           = _("Add");
        // controllers/ConverterController.vala
        public abstract const string TEXT_SUCESS_IN_CONVERSION          = _("Conversion completed");
        // controllers/ConverterController.vala
        public abstract const string TEXT_CANCEL_IN_CONVERSION          = _("Conversion canceled");
        // controllers/ConverterController.vala
        public abstract const string TEXT_ERROR_IN_CONVERSION           = _("Error in conversion");
        // controllers/ConverterController.vala
        public abstract const string TEXT_PERCENTAGE                    = _("percentage: ");
        // controllers/ConverterController.vala
        public abstract const string TEXT_SIZE_CUSTOM                   = _(" - size: ");
        // controllers/ConverterController.vala
        public abstract const string TEXT_TIME_CUSTOM                   = _(" - time: ");
        // controllers/ConverterController.vala
        public abstract const string TEXT_BITRATE_CUSTOM                = _(" - bitrate: ");
        // controllers/ConverterController.vala
        public abstract const string MSG_ERROR_CODECS                   = _("Error: Experimental codecs are not enabled");
        // controllers/ConverterController.vala
        public abstract const string MSG_ERROR_INVALID_INPUT_DATA       = _("Error: Invalid data found when processing input");
        // controllers/ConverterController.vala
        public abstract const string MSG_ERROR_NO_SUCH_FILE_DIRECTORY   = _("Error: No such file or directory");
        // controllers/ConverterController.vala
        public abstract const string MSG_ERROR_INVALID_ARGUMENT         = _("Error: Invalid argument");      
    }
}

# Sources without GTK dependencies. They are also compiled into a static
# library used by the unit tests (see tests/meson.build).
core_sources = files(
    'Configs/Constants.vala',

    'Enums/ColumnEnum.vala',
    'Enums/TypeItemEnum.vala',

    'Objects/ConversionProgress.vala',
    'Objects/FileItem.vala',
    'Objects/ItemConversion.vala',

    'Services/Settings.vala',

    'Utils/ArrayUtil.vala',
    'Utils/FFmpegUtil.vala',
    'Utils/FileUtil.vala',
    'Utils/FormatUtil.vala',
    'Utils/Logger.vala',
    'Utils/StringUtil.vala',
    'Utils/TimeUtil.vala'
)

sources = core_sources + files(
    'Application.vala',
    'Main.vala',
    'Window.vala',

    'Controllers/ConverterController.vala',

    'Utils/WidgetUtil.vala',

    'Views/ConverterView.vala',

    'Widgets/DialogAbout.vala',
    'Widgets/DialogConvertFile.vala',
    'Widgets/DialogPreferences.vala',
    'Widgets/HeaderBarMainContent.vala',
    'Widgets/HeaderBarSidebar.vala',
    'Widgets/ListConversion.vala',
    'Widgets/PopoverSettings.vala',
    'Widgets/RowConversion.vala',
    'Widgets/SourceItem.vala',
    'Widgets/SourceList.vala',
    'Widgets/SourceListSidebar.vala'
)

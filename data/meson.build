# Install app icons in all required sizes for both LoDPI and HiDPI (SVG)
icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    # LoDPI
    install_data (
        join_paths ('assets', 'images', 'icons', i + '.svg'),
        install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps'),
        rename: meson.project_name () + '.svg'
    )
    # HiDPI (@2x)
    install_data (
        join_paths ('assets', 'images', 'icons', i + '.svg'),
        install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps'),
        rename: meson.project_name () + '.svg'
    )
endforeach

# Translate and install the .desktop file so the Applications Menu will see it
i18n.merge_file (
    input: meson.project_name () + '.desktop.in',
    output: meson.project_name () + '.desktop',
    po_dir: join_paths (meson.project_source_root (), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'applications')
)

# Translate and install the .metainfo.xml file so AppCenter will see it
i18n.merge_file (
    input: meson.project_name () + '.metainfo.xml.in',
    output: meson.project_name () + '.metainfo.xml',
    po_dir: join_paths (meson.project_source_root (), 'po', 'extra'),
    type: 'xml',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'metainfo')
)

# Install GSettings schema so app preferences are persisted
install_data (
    meson.project_name () + '.gschema.xml',
    install_dir: join_paths (get_option ('datadir'), 'glib-2.0', 'schemas')
)

# Project name, programming language and version
project (
    'com.github.robertsanseries.ciano',
    'vala', 'c',
    version: '0.2.5',
    license: 'GPL-3.0',
    meson_version: '>= 0.56.0'
)

# Translation module
i18n = import ('i18n')

# GNOME module
gnome = import('gnome')

# Project arguments
add_project_arguments (
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()),
    '-Wno-discarded-qualifiers',
    '-Wno-unused-variable',
    '-Wno-unused-but-set-variable',
    '-Wno-incompatible-pointer-types',
    '-Wno-unused-function',
    language: 'c'
)

# Compiling resources
asresources = gnome.compile_resources (
    'as-resources',
    join_paths ('data', meson.project_name ()) + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Configuring data
conf_data = configuration_data ()
conf_data.set_quoted ('GETTEXT_PACKAGE', meson.project_name ())
configure_file (
    output: 'config.h',
    configuration: conf_data
)

config_h_dir = include_directories ('.')

c_args = [
  '-include', 'config.h',
  '-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE',
]

# Listing dependencies
dependencies = [
    dependency ('glib-2.0', version: '>=2.50', include_type: 'system'),
    dependency ('gtk4', version: '>=4.1', include_type: 'system'),
    dependency ('granite-7',  version: '>=7.7.0', include_type: 'system'),
    dependency ('gobject-2.0', version: '>=2.50', include_type: 'system'),
    dependency ('libadwaita-1', version: '>= 1.0.0', include_type: 'system')
]

ffmpeg = find_program('ffmpeg', required: true)

subdir ('src')

# Defining executable
executable (
    meson.project_name (),
    sources,
    asresources,
    c_args: c_args,
    dependencies: dependencies,
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')

Name:           com.github.robertsanseries.ciano
Version:        0.2.5
Release:        1%{?dist}
Summary:        A multimedia file converter

License:        GPL-3.0-only
URL:            https://robertsanseries.github.io/ciano/
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  meson >= 0.56.0
BuildRequires:  ninja-build
BuildRequires:  vala
BuildRequires:  gcc
BuildRequires:  gettext
BuildRequires:  desktop-file-utils
BuildRequires:  libappstream-glib
BuildRequires:  pkgconfig(glib-2.0) >= 2.50
BuildRequires:  pkgconfig(gobject-2.0) >= 2.50
BuildRequires:  pkgconfig(gio-2.0) >= 2.66
BuildRequires:  pkgconfig(gtk4) >= 4.1
BuildRequires:  pkgconfig(granite-7) >= 7.6.0
BuildRequires:  pkgconfig(gee-0.8)

# Codec libraries needed at runtime via ffmpeg
# video codecs — cobre MP4, AVI, MKV, MOV, FLV, 3GP, SWF, WMV
Requires:       ffmpeg
Requires:       x264-libs
Requires:       x265-libs
# audio codecs — cobre MP3, OGG, AAC, FLAC, WAV, WMA, AMR, M4A, AIFF
Requires:       lame-libs
Requires:       libvorbis
Requires:       opus
Requires:       libvpx
Requires:       libtheora
Requires:       gtk4
Requires:       granite-7 >= 7.6.0

%description
The easiest way to convert your multimedia files to the most popular formats.
Supports video, audio and image conversion.

Supports the conversion of:
 - Video: MP4, MPG, AVI, WMV, FLV, MKV, 3GP, MOV, VOB, OGV, WEBM
 - Audio: MP3, WMA, OGG, WAV, AAC, FLAC, AIFF, MMF, M4A
 - Images: JPG, BMP, PNG, TIF, GIF, TGA

%prep
%autosetup -n %{name}-%{version}

%build
%meson
%meson_build

%install
%meson_install

%check
desktop-file-validate %{buildroot}%{_datadir}/applications/com.github.robertsanseries.ciano.desktop
appstream-util validate-relax --nonet %{buildroot}%{_datadir}/metainfo/com.github.robertsanseries.ciano.metainfo.xml

%files
%license LICENSE
%doc README.md AUTHORS
%{_bindir}/com.github.robertsanseries.ciano
%{_datadir}/applications/com.github.robertsanseries.ciano.desktop
%{_datadir}/metainfo/com.github.robertsanseries.ciano.metainfo.xml
%{_datadir}/glib-2.0/schemas/com.github.robertsanseries.ciano.gschema.xml
%{_datadir}/icons/hicolor/*/apps/com.github.robertsanseries.ciano.svg
%{_datadir}/locale/*/LC_MESSAGES/com.github.robertsanseries.ciano.mo

%post
/usr/bin/glib-compile-schemas %{_datadir}/glib-2.0/schemas &> /dev/null || :
/usr/bin/gtk-update-icon-cache --force %{_datadir}/icons/hicolor &> /dev/null || :
/usr/bin/update-desktop-database &> /dev/null || :

%postun
/usr/bin/glib-compile-schemas %{_datadir}/glib-2.0/schemas &> /dev/null || :
/usr/bin/gtk-update-icon-cache --force %{_datadir}/icons/hicolor &> /dev/null || :
/usr/bin/update-desktop-database &> /dev/null || :

%changelog
* Sun Mar 02 2026 Robert San <robertsanseries@gmail.com> - 0.2.5-1
- GTK4 migration and UI redesign
- Updated build system and dependencies
- Visual fixes and improvements

<div align="center">
    <h1>
        <img width="64" height="64" src="https://github.com/robertsanseries/ciano/blob/master/data/images/com.github.robertsanseries.ciano.png" alt="Icon">Ciano</h1>
  <h3 align="center">A multimedia file converter focused on simplicity.</h3>
</div>

<p align="center">
    <img src="https://github.com/robertsanseries/ciano/blob/master/data/images/screenshot.png" alt="Screenshot">
</p>

<div class="center">
  <h1 align="center"> Informations </h1>
</div>


### Description

Convert videos, music and pictures with the best possible experience.

### Links

- [Website](https://robertsanseries.github.io/ciano)
- [Report a problem](https://github.com/robertsanseries/ciano/issues)

### Installation

#### Hit the button to get Ciano!

On elementary OS?

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.robertsanseries.ciano)

On debian, ubuntu and derivatives

[![Get the .Deb](https://robertsanseries.github.io/ciano/img/badge.svg)](https://github.com/robertsanseries/ciano/releases/download/0.1.4/com.github.robertsanseries.ciano_0.1.4_amd64.deb)

#### Hit the link to get Ciano!

- [Get the Flatpak](https://flathub.org/repo/appstream/com.github.robertsanseries.ciano.flatpakref)

- [Get the Source Code](https://github.com/robertsanseries/ciano/archive/master.zip)

### Installation from the source code

#### Application Dependencies 
These dependencies must be present before building
 - `meson (>=0.40)`
 - `valac (>=0.16)`
 - `debhelper (>= 9)`
 - `libgranite-dev`
 - `libgtk-3-dev`
 - `ffmpeg`
 - `imagemMagick`
 
 #### Building

```
git clone https://github.com/robertsanseries/ciano.git && cd ciano
meson build && cd build
meson configure -Dprefix=/usr
ninja
```

#### Installation & executing
```
sudo ninja install
com.github.robertsanseries.ciano
```

#### Uninstalling

```
sudo ninja uninstall
```

### Contributing

#### Donations
 - If you like Ciano and you want to support its development, consider donating via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=S698J2TUEMT3C).

 - Brasil: Se você gosta de Ciano e quer apoiar seu desenvolvimento, considere doar via [PayPal Brasil](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FJ2EVELMCFPU6)

#### Development
To help, access the links below:

- [Guide on Code Style](https://github.com/robertsanseries/ciano/wiki/Guide-on-code-style)

- [Proposing Design Changes](https://github.com/robertsanseries/ciano/wiki/Proposing-Design-Changes)

- [Reporting Bugs](https://github.com/robertsanseries/ciano/wiki/Reporting-Bugs)

- [How to Translate Ciano](https://github.com/robertsanseries/ciano/wiki/Translate)

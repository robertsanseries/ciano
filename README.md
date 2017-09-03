<div>
  <p align="center"> :construction: App under development!</p>
  <h1 align="center">Ciano</h1>
  <h3 align="center">A simple multimedia file converter. Built from the ground up for the elementary OS.</h3>
  <p align="center">Helping in those things you do everyday on your computer!</p>
</div>

<br/>

<p align="center">
   <a href="https://github.com/robertsanseries/ciano/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/License-GPL--3.0-blue.svg">
   </a>
</p>

<p align="center">
    <img width="700" height="500" src="https://github.com/robertsanseries/ciano/blob/master/data/images/screenshot.png" alt="Screenshot"> <br>
  <a href="https://github.com/robertsanseries/ciano/issues/new"> Report a problem! </a>
</p>

### Installation

App under development!

### Dependencies
These dependencies must be present before building
 - `meson (>=0.40)`
 - `valac (>=0.16)`
 - `libgda-5.0`
 - `libgranite`
 - `libgtk-3`
 - `sqlite3`
 - `ffmpeg`
 - `imagemMagick`
 
 ### Building

```
git clone https://github.com/robertsanseries/ciano.git && cd ciano
meson build && cd build
mesonconf -Dprefix=/usr
ninja
sudo ninja install
com.github.robertsanseries.ciano
```

### Deconstruct

```
sudo ninja uninstall
```

### Test and Development

```
gdb
com.github.robertsanseries.ciano
```

### Contributing

To help, access the links below to guide you through your process to send pull request:

- [Reporting Bugs](https://github.com/robertsanseries/ciano/wiki/Reporting-Bugs)

- [Guide on Code Style](https://github.com/robertsanseries/ciano/wiki/Guide-on-code-style)



### License

This project is licensed under the GPL3 License - see the [LICENSE](LICENSE.md) file for details.

<div align="center">
  <span align="center"> <img width="80" height="95" class="center" src="https://github.com/robertsanseries/ciano/blob/master/data/images/com.github.robertsanseries.ciano.png" alt="Icon"></span>
  <h1 align="center">Ciano</h1>
  <h3 align="center">A simple multimedia file converter. Built from the ground up for the elementary OS.</h3>
  <a href="https://robertsanseries.github.io/ciano"> <p align="center">Visit our website for more information and download</p></a>
</div>

<br/>


<p align="center">
    <img src="https://github.com/robertsanseries/ciano/blob/master/data/images/screenshot.png" alt="Screenshot"> <br>
  <a href="https://github.com/robertsanseries/ciano/issues/new"> Report a problem! </a>
</p>

<div class="center">
  
<h1 align="center"> Additional Information </h1>
</div>

### Contributing

To help, access the links below:

- [Guide on Code Style](https://github.com/robertsanseries/ciano/wiki/Guide-on-code-style)

- [Proposing Design Changes](https://github.com/robertsanseries/ciano/wiki/Proposing-Design-Changes)

- [Reporting Bugs](https://github.com/robertsanseries/ciano/wiki/Reporting-Bugs)

- [Translate](https://github.com/robertsanseries/ciano/wiki/Translate)


### Application Dependencies 
These dependencies must be present before building
 - `meson (>=0.40)`
 - `valac (>=0.16)`
 - `debhelper (>= 9)`
 - `libgranite-dev`
 - `libgtk-3-dev`
 - `ffmpeg`
 - `imagemMagick`
 
 ### Building

```
git clone https://github.com/robertsanseries/ciano.git && cd ciano
meson build && cd build
meson configure -Dprefix=/usr
ninja
```

### Installation & executing
```
sudo ninja install
com.github.robertsanseries.ciano
```

### Uninstalling

```
sudo ninja uninstall
```

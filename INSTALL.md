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
<div align="center">
    <h1>instantDEB</h1>
    <p>Convert pacman packages to debian packages</p>
    <img width="300" height="300" src="https://media.githubusercontent.com/media/instantOS/instantLOGO/master/png/debian.png">
</div>
---------

A tool to convert pacman packages to debian packages. 
Run this on the debian system you want to convert for, NOT on an arch based system. 
You can also use PKGBUILD files on debian based systems using this. 
This enables partial support for the AUR. 
Please keep in mind that it is not entirely accurate and in very early stages of development. 

## Usage

convert filename.pkg.tar.xz to filename.deb
```ideb filename.pkg.tar.xz```

build a PKGBUILD and put out a deb file
```ideb build```

## What does NOT work?
It is pretty obvious what this does when it works, it makes archy stuff work on debian. 
So what does and will not work?

### Dependency management
Packages are named different on arch and debian, 
so trying to install packages listed in an arch package would not work.  

### Arch specific library packages
There are packages that symlink libraries or even download binariy libraries. 
Those are out of control of this project and might or may not work. 

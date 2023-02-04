# Multipass mariadb VM
This project help to create an instance of mariadb (with phpmyadmin) in a multipass vm

## Prerequisites
### Ubuntu 22.04
### Install canonical multipass from snap

`
sudo snap install multipass
`

## Install VM
### Set parameters:
```
cp env.dist env
```
### Edit env parameters
```
nano env
```
### Install
```
./install.sh
```
### Uninstall
```
./uninstall.sh
```

## Example
![immagine](https://user-images.githubusercontent.com/7722346/213928353-1929eb63-a595-407d-9457-3b40758fc4e1.png)

![immagine](https://user-images.githubusercontent.com/7722346/213929514-7ea2866e-d16f-4661-bb71-84ae3a1a4e2c.png)

![immagine](https://user-images.githubusercontent.com/7722346/214121126-e701e447-e950-4d53-8263-3aff3d5a9a33.png)

## Demo video
[![Watch demo](http://img.youtube.com/vi/41uKJ8WciSI/0.jpg)](http://www.youtube.com/watch?v=41uKJ8WciSI "Demo video")

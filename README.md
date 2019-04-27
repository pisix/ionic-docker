[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://tldrlegal.com/license/mit-license#summary) [![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/marcoturi/ionic) [![](https://images.microbadger.com/badges/image/marcoturi/ionic.svg)](https://microbadger.com/images/marcoturi/ionic "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/marcoturi/ionic.svg)](https://microbadger.com/images/marcoturi/ionic "Get your own version badge on microbadger.com")

# Ionic-docker
A ionic 4 image to be used with Gitlab CI
ps: if you want to build for another ionic version just IONIC_VERSION variable in docker file

### Inspired by:
- https://github.com/marcoturi/ionic-docker

### Features
- Node
- Npm or Yarn
- Ionic
- Cordova
- Fastlane
- Android sdk and build tools
- Ios and build tools
- Ready to run Google Chrome Headless for e2e tests
- Ruby
- Scss-lint support

##Usage

```
docker run -ti --rm -p 8100:8100 -p 35729:35729 pisix/ionic
```
If you have your own ionic sources, you can launch it with:

```
docker run -ti --rm -p 8100:8100 -p 35729:35729 -v /path/to/your/ionic-project/:/myApp:rw pisix/ionic
```

### Automation
With this alias:

```
alias ionic="docker run -ti --rm -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/.gradle:/root/.gradle -v \$PWD:/myApp:rw marcoturi/ionic ionic"
```

> Due to a bug in ionic, if you want to use ionic serve, you have to use --net host option :

```
alias ionic="docker run -ti --rm --net host --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/.gradle:/root/.gradle -v \$PWD:/myApp:rw pisix/ionic ionic"
```

> Know you need gradle for android, I suggest to mount ~/.gradle into /root/.gradle to avoid downloading the whole planet again and again

you can follow the [ionic tutorial](http://ionicframework.com/getting-started/) (except for the ios part...) without having to install ionic nor cordova nor nodejs on your computer.

```bash
ionic start myApp tabs
cd myApp
ionic serve
# If you didn't used --net host, be sure to chose the ip address, not localhost, or you would not be able to use it
```
open http://localhost:8100 and everything works.

### Android tests
You can test on your android device, just make sure that debugging is enabled.

```bash
cd myApp
ionic cordova platform add android
ionic cordova build android
ionic cordova run android
```

### Ios tests
You can test on your ios device, just make sure that debugging is enabled.

```bash
cd myApp
ionic cordova platform add ios
ionic cordova build ios
ionic cordova run ios
```

### FAQ
* The application is not installed on my android device
    * Try `docker run -ti --rm -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v \$PWD:/myApp:rw pisix/ionic adb devices` your device should appear
* The adb devices show nothing whereas I can see it when I do `adb devices` on my computer
    * You can't have adb inside and outside docker at the same time, be sure to `adb kill-server` on your computer before using this image

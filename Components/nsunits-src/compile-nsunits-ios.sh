#!/bin/sh
set -e

if [ "$1" = "" ]; then
  echo Usage: compile-nsunits-ios.sh iPhoneAll\|NoiPhoneAll
  exit 1
fi

if (! [ "$1" = iPhoneAll ]) && (! [ "$1" = NoiPhoneAll ]); then
  echo "Invalid parameter: $1"
  exit 1
fi

outroot="/Developer/ObjectivePascal/$1"
iosunits=~/Tools/iOS_8_0-master

i386iphonesim=$outroot/i386-iphonesim
armdarwin=$outroot/arm-darwin
x8664iphonesim=$outroot/x86_64-iphonesim
aarch64darwin=$outroot/aarch64-darwin

if [ ! -d "$i386iphonesim" ]; then
  echo "Can't find $i386iphonesim"
  exit 1
fi
if [ ! -d "$armdarwin" ]; then
  echo "Can't find $armdarwin"
  exit 1
fi
if [ ! -d "$x8664iphonesim" ]; then
  echo "Can't find $x8664iphonesim"
  exit 1
fi
if [ ! -d "$aarch64darwin" ]; then
  echo "Can't find $aarch64darwin"
  exit 1
fi

if [ ! -d "$iosunits" ]; then
  echo "Can't find $iosunits"
  exit 1
fi

ppc386i=/usr/local/bin/ppc386-3.0.3
ppcarm=/usr/local/bin/ppcarm
ppcx64i=/usr/local/bin/ppcx64-3.0.3
ppca64=/usr/local/bin/ppca64

if [ "$1" = iPhoneAll ]; then
  switches="-CirotR -gltw -Mdelphi -B -dIPHONEALL -Fu$iosunits"
else
  switches="-CirotR -gltw -Mdelphi -B -dNoiPhoneAll -Fu$iosunits"
fi

devbindir=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.Platform/Developer/usr/bin

$ppc386i -Tiphonesim $switches -FU$i386iphonesim NSHelpers.pas
$ppc386i -Tiphonesim $switches -FU$i386iphonesim NSFormat.pas
$ppc386i -Tiphonesim $switches -FU$i386iphonesim ns_url_request.pas
$ppc386i -Tiphonesim $switches -FU$i386iphonesim NSMisc.pas

$ppcarm -Cparmv7 -Cfvfpv3 $switches -FU$armdarwin -FD$devbindir NSHelpers.pas
$ppcarm -Cparmv7 -Cfvfpv3 $switches -FU$armdarwin -FD$devbindir NSFormat.pas
$ppcarm -Cparmv7 -Cfvfpv3 $switches -FU$armdarwin -FD$devbindir ns_url_request.pas
$ppcarm -Cparmv7 -Cfvfpv3 $switches -FU$armdarwin -FD$devbindir NSMisc.pas

$ppcx64i -Tiphonesim $switches -FU$x8664iphonesim NSHelpers.pas
$ppcx64i -Tiphonesim $switches -FU$x8664iphonesim NSFormat.pas
$ppcx64i -Tiphonesim $switches -FU$x8664iphonesim ns_url_request.pas
$ppcx64i -Tiphonesim $switches -FU$x8664iphonesim NSMisc.pas

$ppca64 $switches -FU$aarch64darwin -FD$devbindir NSHelpers.pas
$ppca64 $switches -FU$aarch64darwin -FD$devbindir NSFormat.pas
$ppca64 $switches -FU$aarch64darwin -FD$devbindir ns_url_request.pas
$ppca64 $switches -FU$aarch64darwin -FD$devbindir NSMisc.pas

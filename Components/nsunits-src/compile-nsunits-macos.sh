#!/bin/sh
set -e

if [ "$1" = "" ]; then
  echo Usage: compile-nsunits-macos.sh CocoaAll\|NoCocoaAll
  exit 1
fi

if (! [ "$1" = CocoaAll ]) && (! [ "$1" = NoCocoaAll ]); then
  echo "Invalid parameter: $1"
  exit 1
fi

outroot="/Developer/ObjectivePascal/$1"
macosunits=~/Tools/MacOS_10_10-master

i386darwin=$outroot/i386-darwin
x86_64darwin=$outroot/x86_64-darwin

if [ ! -d "$i386darwin" ]; then
  echo "Can't find $i386darwin"
  exit 1
fi
if [ ! -d "$x86_64darwin" ]; then
  echo "Can't find $x86_64darwin"
  exit 1
fi

ppc386=/usr/local/bin/ppc386
ppcx64=/usr/local/bin/ppcx64

if [ "$1" = CocoaAll ]; then
  switches="-CirotR -gltw -Mdelphi"
else
  if [ ! -d "$macosunits" ]; then
    echo "Can't find $macosunits"
    exit 1
  fi
  switches="-CirotR -gltw -Mdelphi -B -dNoCocoaAll -Fu$macosunits"
fi

$ppc386 $switches -FU$i386darwin NSHelpers.pas
$ppc386 $switches -FU$i386darwin NSFormat.pas
$ppc386 $switches -FU$i386darwin ns_url_request.pas
$ppc386 $switches -FU$i386darwin NSMisc.pas
$ppc386 $switches -FU$i386darwin CocoaHelpers.pas

$ppcx64 $switches -FU$x86_64darwin NSHelpers.pas
$ppcx64 $switches -FU$x86_64darwin NSFormat.pas
$ppcx64 $switches -FU$x86_64darwin ns_url_request.pas
$ppcx64 $switches -FU$x86_64darwin NSMisc.pas
$ppcx64 $switches -FU$x86_64darwin CocoaHelpers.pas

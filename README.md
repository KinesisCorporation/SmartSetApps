# SmartSetApps

[![Build](https://github.com/KinesisCorporation/SmartSetApps/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/KinesisCorporation/SmartSetApps/actions/workflows/build.yml)

This repository is for SmartSet apps used for Kinesis Corporation keyboards and foot pedals.
All apps are build using Lazarus IDE (pascal programming language): https://www.lazarus-ide.org/.
These apps currently support Windows 32-bit and MacOS 32-bit/64-bit.

You can get compiled versions of the Apps and detailed installation and usage instructions on these websites:
* Savant Elite, Advantage2, Freestyle Pro: https://kinesis-ergo.com/support/#support-for-my-device
* Freestyle Edge RGB, Freestyle Edge: https://gaming.kinesis-ergo.com/support/

SmartSet Apps are designed as a lightweight GUI to read and write to the simple .txt configuration files stored on virtual flash drive (aka the "v-Drive") of each (programmable) Kinesis and Kinesis Gaming keyboard and foot pedal. At present, each device has its own unique version of the SmartSet App which reflects unique drive names, folder structures, programming syntax, firmware features, and App functionality.

Windows and/or Mac Apps are pre-loaded on to most devices and were originally intended to be run directly from the v-Drive for maximum convenience and portability. New versions of the SmartSet App are designed to run from the "desktop" with the v-Drive simply "connected" to your PC. 

## Getting started
Install the latest version of Lazarus IDE for your computer.  Windows 32-bit version and Mac 64-bit for Catalina/Big Sur. Go to the lazarus-ide website: https://www.lazarus-ide.org/
### Windows
You must download the 32-bit version of the IDE for Windows, download and run the setup.
NOTE: keep default settings for all installation steps.

### Mac
Do all these steps on your Mac computer.
* You must install Xcode first (found in App store).
* Install Command Line Tools from terminal with this command: xcode-select --install
* Install HomeBrew on your system.
* For brew installation on ARM processors run this command:
	arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
* For brew installation on x86 processors run this command:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
* To install a package on ARM processors run this command:
	arch -x86_64 brew install <package>
* To install a package on x86 processors run this command:
	brew install wget
* Go to the lazarus-ide website: https://www.lazarus-ide.org/
* Click on the download link to download the latest version of Lazarus.
* Download all files (fpc-src-..., lazarus-..., fpc-...)
* Install all 3 packages in order: fpc, fpc-src, lazarus), you will need to go to security in settings to allow installation. 
  NOTE: keep default settings for all installation steps.
* Install additional software suggested by the OS.
* **NOT REQUIRED**: Install UPX compression utility (https://brewinstall.org/install-upx-on-mac-with-brew/):
  * Run this command in Terminal: 
  * **ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null**
  * Then run this command when it’s done: **brew install upx**
  
*If you have any issues please look at this documentation: https://wiki.freepascal.org/Installing_Lazarus_on_macOS*

### Configuration for Mac
* (Catalina Only) Click on Tools -> Options -> Debugger, select LLDB debugger (with fpdebug) (Beta).  
	Path should be: /Library/Developer/CommandLineTools/usr/bin/lldb
* If you receive a "Can't find unit Interfaces used by Project1" error on trying to compile a blank form, check the following settings in Lazarus (should be set by default):
* (Catalina Only) Tools -> Options -> Environment Options
  * Lazarus directory: /Developer/lazarus
  * Compiler path: /usr/local/bin/fpc
  * FPC Source: /usr/local/share/fpcsrc (note: don’t change on Catalina)
* (Catalina Only) Tool -> Configure Lazarus:
  * LCL widget type: cocoa
  * Target CPU: x86_64
  * Save Settings / Build
  
*See Known issues section if you have issues with your installation.*

## Installation

### Source folders
Here is a description of what each folder contains.
* Common: contain common code shared amongst all apps.
* Components: third-party and custom components used in apps, some third party components have been modified / fixed.
* SmartSetAdv2: Advantage2 keyboard app.
* SmartSetFSEdgePro: Freestyle Pro and Freestyle Edge app (same app customized depending on keyboard version).
* SmartSetRGB: (Deprecated) Freestyle Edge RGB app.
* SmartSetTKO: (Deprecated) TKO RGB app.
* SmartSetMaster: All-in-one app for Kinesis Gaming apps
* SmartSetSavantElite: Savant Elite foot pedal app.
* Utilities: some utilities used for the apps.

### Install third party packages
Install all the following 3rd party controls (no need to rebuild after each install, only after the last one):
* \Components\bgrabitmap-master\bgrabitmap\bgrabitmappack.lpk (just compile it).
* \Components\bgracontrols-master\bgracontrols.lpk
* \Components\ecc_0-9-6-10_16-06-15\EC_Controls\eccontrols.lpk
* \Components\TGIFViewer-master\TGIFViewer-master\package\gifviewer_pkg.lpk
* \Components\HSButton0.9\HSButton\installpkg.lpk
* \Components\mbColorLib-2.2.1\mbColorLib\mbcolorliblaz.lpk
* \Components\mdsliderbarslaz-2\package\mdsliderbarslaz.lpk
* \Components\richmemo\ide\richmemo_design.lpk
* \Components\ueControls_v6.0\uecontrols.lpk
* \Components\CreoSource\creosource.lpk

### Configure project
Note for MacOS: If third party components are not shown when you start Lazarus, see this thread: https://forum.lazarus.freepascal.org/index.php?topic=47711.0
You might have to give Read/Write priviledges in /Library/Lazarus
* Open Terminal
* Go to root, then run cd Library THEN cd Lazarus
* Run this: sudo chown -R $(whoami)
* Go back one folde: cd ..
* Then run this: chmod -R +rw Lazarus 
* Start lazarus app
If that doesn't work try starting Lazarus from /Library/Lazarus, startlazarus shortcut.


Configure the following settings for each project depending on what OS you are working on. Windows and Mac OSX are supported, Linux might work with some tweaks to source code.
* Open project options (Project | Project Options…).
* Under Compiler Options, select Paths.
  * In Target file name at the end between round brackets ( ) enter the following:
    * For Mac OSX: Mac
    * For Windows: PC
	* E.g.: SmartSet App-Freestyle (PC)
* Under Compiler Options, select Config and Target.
* Target CPU family:
  * For Mac OSX: select x86_64.
  * For Windows: select i386.
* Additions and Overrides:
  * For Mac OSX: IDE Macro select cocoa.
  * For Windows: IDE Macro select nothing.
* Debugger popup: Enable Dwarf with sets.

## Known issues
List of known issues, settings that work with Mac Lazarus.
* When building project, you get Error while linking
  * Solution: reinstall fpc and fpc-src. 
* Mac when compiling you get error Error: Internal error 200609171.
  * Solution: disable this option Project->Project Options->Generate info for the debugger.
* In Tools->Options that "Compiler Executable" is set to "/usr/local/bin/fpc" to get 64 bit apps.
* Lazarus 2.0.8 on Mac OSX error: cocoascrollers.pas(53,15) Error: There is no method in an ancestor class to be overridden: "setDocumentView(id);"
  * See solution here: https://wiki.freepascal.org/Installing_Lazarus_on_macOS, scroll down to Installing Lazarus 2.0.8 with FPC 3.2.0 for macOS 10.11+
* Lazarus 2.0.12 on Mac OSX (cocoa): issue with RichMemo GetTextLength.  You need to edit the following file: /Applications/Lazarus/lcl/interfaces/cocoa/cocoawscommon.pas, and change GetTextLength procedure as follows (note you might need to have Read/Write access to edit) : 
class function TCocoaWSWinControl.GetTextLen(const AWinControl: TWinControl; var ALength: Integer): Boolean;
var
  obj: NSObject;
  s: NSString;
begin
  Result := AWinControl.HandleAllocated;
  if not Result then
    Exit;

  obj := NSObject(AWinControl.Handle);

  if obj.isKindOfClass_(NSControl) then
    s := NSControl(obj).stringValue
  else          // DRB, not all (Lazarus) controls are (Apple) NSControls.
     // Note that TListBox is also a NSScrollView but still does not work here.
     if obj.isKindOfClass_(NSScrollView) and        // maybe 'NSView' is better ??
        (AWinControl.classnameis('TMemo') or AWinControl.ClassNameIs('TRichMemo')) then
            S := NSTextView(NSScrollView(AWinControl.Handle).documentView).string_
     else exit(False);

  if Assigned(s) then
    ALength := s.length
  else begin
    ALength := 0;
    Result := False;
  end;
end; 

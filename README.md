# SmartSetApps
This repository is for SmartSet apps used for Kinesis Corporation keyboards and foot pedals.
All apps are build using Lazarus IDE (pascal programming language): https://www.lazarus-ide.org/.
These apps currently support Windows 32-bit and MacOS 32-bit/64-bit.

You can get compiled versions on these websites:
* Savant Elite, Advantage2, Freestyle Pro: https://kinesis-ergo.com/support/#support-for-my-device
* Freestyle Edge RGB, Freestyle Edge: https://gaming.kinesis-ergo.com/support/

## Getting started
Install the latest version of Lazarus IDE for your computer.  Windows 32-bit version and Mac 64-bit for Catalina. Go to the lazarus-ide website: https://www.lazarus-ide.org/
### Windows
You must download the 32-bit version of the IDE for Windows, download and run the setup.
NOTE: keep default settings for all installation steps.

### Mac
To install on Catalina:
https://sourceforge.net/projects/lazarus/files/Lazarus%20macOS%20x86-64/

Do all these steps on your Mac computer.
* You must install Xcode first (found in App store).
* Go to the lazarus-ide website: https://www.lazarus-ide.org/
  To install on Catalina: https://sourceforge.net/projects/lazarus/files/Lazarus%20macOS%20x86-64/
* Click on the download link to download the latest version of Lazarus.
* Download all files (fpc-src-..., lazarus-..., fpc-...)
* Install all 3 packages in order: fpc, fpc-src, lazarus), you will need to go to security in settings to allow installation. 
  NOTE: keep default settings for all installation steps.
* Install additional software suggested by the OS.
* Install UPX compression utility (https://brewinstall.org/install-upx-on-mac-with-brew/):
  * Run this command in Terminal: 
  * **ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null**
  * Then run this command when it’s done: **brew install upx**
  
*If you have any issues please look at this documentation: https://wiki.freepascal.org/Installing_Lazarus_on_macOS*

### Configuration for Mac
* Click on Tools -> Options -> Debugger, select LLDB debugger (with fpdebug) (Beta).  Path should be: /Library/Developer/CommandLineTools/usr/bin/lldb
* If you receive a "Can't find unit Interfaces used by Project1" error on trying to compile a blank form, check the following settings in Lazarus (should be set by default):
* Tools -> Options -> Environment Options
  * Lazarus directory: /Developer/lazarus
  * Compiler path: /usr/local/bin/fpc
  * FPC Source: /usr/local/share/fpcsrc (note: don’t change on Catalina)
* Tool -> Configure Lazarus:
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
* SmartSetRGB: Freestyle Edge RGB app.
* SmartSetSavantElite: Savant Elite foot pedal app.
* Utilities: some utilities used for the apps.

### Install third party packages
Install all the following 3rd party controls:
* \Components\bgrabitmap-master\bgrabitmap\bgrabitmappack.lpk (just compile it).
* \Components\bgracontrols-master\bgracontrols.lpk
* \Components\ecc_0-9-6-10_16-06-15\EC_Controls\eccontrols.lpk
* \Components\TGIFViewer-master\TGIFViewer-master\package\gifviewer_pkg.lpk
* \Components\HSButton0.9\HSButton\installpkg.lpk
* \Components\mbColorLib-2.2.1\mbColorLib\mbcolorliblaz.lpk
* \Components\mdsliderbarslaz-2\package\mdsliderbarslaz.lpk
* \Components\richmemo\richmemopackage.lpk
* \Components\ueControls_v6.0\uecontrols.lpk
* \Components\CreoSource\creosource.lpk

### Configure project
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

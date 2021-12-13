#### Platform-specific settings

ifeq ($(OS),Windows_NT)
	exe = ".exe"
	platform = i386-win32
	lazflags = --cpu=i386 --widgetset=win32
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
		platform = x86_64-linux
		lazflags = --widgetset=gtk2
    endif
    ifeq ($(UNAME_S),Darwin)
		platform = x86_64-darwin
		lazflags = --widgetset=cocoa --lazarusdir=/Applications/Lazarus
    endif
endif

lazbuild = lazbuild $(lazflags)


#### Libraries

creosource = Components/CreoSource/lib/$(platform)/creosource.compiled
eccontrols = Components/ecc_0-9-6-10_16-06-15/EC_Controls/lib/$(platform)/eccontrols.compiled
installpkg = Components/HSButton0.9/HSButton/lib/$(platform)/installpkg.compiled
bgrabitmappack = Components/bgrabitmap-master/bgrabitmap/lib/$(platform)/3.0.4/BGRABitmapPack.compiled
richmemopackage = Components/richmemo/lib/$(platform)/richmemopackage.compiled
uecontrols = Components/ueControls_v6.0/lib/$(platform)/uEControls.compiled
gifviewer = Components/TGIFViewer-master/TGIFViewer-master/package/lib/$(platform)/gifviewer_pkg.compiled
bgracontrols = Components/bgracontrols-master/lib/$(platform)/3.0.4/bgracontrols.compiled
mbcolorliblaz = Components/mbColorLib-2.2.1/mbColorLib/lib/$(platform)/mbColorLibLaz.compiled


#### Apps

# GNU Make doesn't handle spaces or parens in filenames very well,
# so it's difficult to reference the built executables.
# Instead, just using phony targets for now and accepting that they will
# often be unnecessarily rebuilt. Can the exectuables be renamed?

# smartset_fsedge := 'SmartSetFSEdgePro/SmartSet\ App-Freestyle\ \(PC\)'$(exe)
# smartset_rgb := 'SmartSetRGB/SmartSet\ App-Freestyle\ \(Mac\)'$(exe)
# smartset_adv2 := 'SmartSetAdv2/SmartSet\ App\ \(PC\)'$(exe)
# smartset_savant_elite := 'SmartSetSavantElite/SE2\ SmartSet\ App\ \(Mac\)'$(exe)

.PHONY: all smartset_adv2 smartset_fsedge smartset_rgb smartset_savant_elite smartset_master_office smartset tko

all: smartset_master smartset_master_office

smartset_fsedge = smartset_fsedge
smartset_rgb = smartset_rgb
smartset_adv2 = smartset_adv2
smartset_savant_elite = smartset_savant_elite
smartset_master = smartset_master
smartset_master_office = smartset_master_office
smartset_tko = smartset_tko


#### Rules

$(smartset_fsedge): $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetFSEdgePro/SmartSetFSEdge.lpi

$(smartset_rgb): $(bgracontrols) $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(gifviewer) $(mbcolorliblaz) $(uecontrols)
	$(lazbuild) SmartSetRGB/SmartSetFSEdge.lpi

$(smartset_adv2): $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetAdv2/SmartSetKeyboard.lpi

$(smartset_savant_elite): $(bgracontrols) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetSavantElite/SE2ConfigAppWin.lpi

$(smartset_master): $(mbcolorliblaz) $(gifviewer) $(eccontrols) $(uecontrols) $(richmemopackage) $(creosource) $(installpkg)
	$(lazbuild) SmartSetMaster/SmartSetMaster.lpi

$(smartset_master_office): $(mbcolorliblaz) $(gifviewer) $(eccontrols) $(uecontrols) $(richmemopackage) $(creosource) $(installpkg)
	$(lazbuild) SmartSetMasterOffice/SmartSetMasterOffice.lpi

$(smartset_tko): $(eccontrols) $(mbcolorliblaz) $(uecontrols) $(gifviewer) $(richmemopackage) $(creosource) $(installpkg)
	$(lazbuild) SmartSetTKO/SmartSetTKO.lpi

$(uecontrols): $(bgrabitmappack)
	$(lazbuild) Components/ueControls_v6.0/uecontrols.lpk

$(richmemopackage):
	$(lazbuild) Components/richmemo/richmemopackage.lpk

$(gifviewer):
	$(lazbuild) Components/TGIFViewer-master/TGIFViewer-master/package/gifviewer_pkg.lpk

$(bgracontrols): $(bgrabitmappack)
	$(lazbuild) Components/bgracontrols-master/bgracontrols.lpk

$(bgrabitmappack):
	$(lazbuild) Components/bgrabitmap-master/bgrabitmap/bgrabitmappack.lpk

$(mbcolorliblaz): $(bgrabitmappack)
	$(lazbuild) Components/mbColorLib-2.2.1/mbColorLib/mbcolorliblaz.lpk

$(creosource) : $(bgrabitmappack) $(bgracontrols)
	$(lazbuild) Components/CreoSource/creosource.lpk

$(eccontrols):
	$(lazbuild) Components/ecc_0-9-6-10_16-06-15/EC_Controls/eccontrols.lpk

$(installpkg):
	$(lazbuild) Components/HSButton0.9/HSButton/installpkg.lpk

clean:
	rm -rf \
		Components/richmemo/lib/* \
		Components/ecc_0-9-6-10_16-06-15/EC_Controls/lib/* \
		Components/mbColorLib-2.2.1/mbColorLib/lib/* \
		Components/TGIFViewer-master/TGIFViewer-master/package/lib/* \
		Components/CreoSource/lib/* \
		Components/HSButton0.9/HSButton/lib/* \
		Components/bgrabitmap-master/bgrabitmap/lib/* \
		Components/bgracontrols-master/lib/* \
		Components/ueControls_v6.0/lib/* \
		SmartSetAdv2/lib \
		SmartSetFSEdgePro/lib \
		SmartSetMaster/lib \
		SmartSetSavantElite/lib \
		"SmartSetAdv2/Adv2 SmartSet App (Mac)" \
		"SmartSetFSEdgePro/SmartSet App-Freestyle (PC)" \
		"SmartSetMaster/SmartSetMaster (PC)" \
		"SmartSetSavantElite/SE2 SmartSet App (Mac)"

################################################
# Compiler Installation
################################################

DEB_LAZARUS = "https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.0.12/lazarus-project_2.0.12-0_amd64.deb/download"
DEB_FPC_LAZ = "https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.0.12/fpc-laz_3.2.0-1_amd64.deb/download"
DEB_FPC_SRC = "https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.0.12/fpc-src_3.2.0-1_amd64.deb/download"

# Lazarus 2.1+ causes build errors related to GTK and richmemo:
# https://wiki.freepascal.org/RichMemo#2.1.0_.28trunk.2Flater.29

# DEB_LAZARUS = "https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.2RC2/lazarus-project_2.2.0RC2-0_amd64.deb/download"
# DEB_FPC_LAZ = "https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.2RC2/fpc-laz_3.2.2-210709_amd64.deb/download"
# DEB_FPC_SRC = "https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%202.2RC2/fpc-src_3.2.2-210709_amd64.deb/download"


install-lazarus-linux:
	DEBIAN_FRONTEND=noninteractive apt-get install -y libgtk2.0-dev
	wget $(DEB_LAZARUS) -O lazarus-project.deb
	wget $(DEB_FPC_LAZ) -O fpc-laz.deb
	wget $(DEB_FPC_SRC) -O fpc-src.deb
	dpkg -i fpc-laz.deb
	dpkg -i fpc-src.deb
	dpkg -i lazarus-project.deb

DMG_FPC = "https://sourceforge.net/projects/lazarus/files/Lazarus%20macOS%20x86-64/Lazarus%202.2.0/fpc-3.2.2.intelarm64-macosx.dmg/download"
DMG_FPC_PKG = "fpc-3.2.2.intelarm64-macosx/fpc-3.2.2-intelarm64-macosx.mpkg/Contents/Packages/fpc-3.2.2-intelarm64-macosx.pkg"
DMG_LAZARUS = "https://sourceforge.net/projects/lazarus/files/Lazarus%20macOS%20x86-64/Lazarus%202.2.0/Lazarus-2.2.0-0-x86_64-macosx.pkg/download"

install-lazarus-mac:
	wget $(DMG_FPC) -q -O fpc.dmg
	7z x fpc.dmg
	sudo installer -pkg $(DMG_FPC_PKG) -target /
	wget $(DMG_LAZARUS) -q -O lazarus.pkg
	sudo installer -pkg lazarus.pkg -target /


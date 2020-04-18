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
		lazflags = --widgetset=cocoa
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

.PHONY: all smartset_adv2 smartset_fsedge smartset_rgb smartset_savant_elite

all: smartset_fsedge smartset_rgb smartset_adv2 smartset_savant_elite

smartset_fsedge = smartset_fsedge
smartset_rgb = smartset_rgb
smartset_adv2 = smartset_adv2
smartset_savant_elite = smartset_savant_elite


#### Rules

$(smartset_fsedge): $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetFSEdgePro/SmartSetFSEdge.lpi

$(smartset_rgb): $(bgracontrols) $(creosource) $(eccontrols) $(gifviewer) $(mbcolorliblaz) $(uecontrols)
	$(lazbuild) SmartSetRGB/SmartSetFSEdge.lpi

$(smartset_adv2): $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetAdv2/SmartSetKeyboard.lpi

$(smartset_savant_elite): $(bgracontrols) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetSavantElite/SE2ConfigAppWin.lpi

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

$(mbcolorliblaz):
	$(lazbuild) Components/mbColorLib-2.2.1/mbColorLib/mbcolorliblaz.lpk

$(creosource) : $(bgrabitmappack)
	$(lazbuild) Components/CreoSource/creosource.lpk

$(eccontrols):
	$(lazbuild) Components/ecc_0-9-6-10_16-06-15/EC_Controls/eccontrols.lpk

$(installpkg):
	$(lazbuild) Components/HSButton0.9/HSButton/installpkg.lpk

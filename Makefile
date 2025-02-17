#### Platform-specific settings

ifeq ($(OS),Windows_NT)
	exe = ".exe"
	platform = x86_64-win64
	lazflags = --widgetset=win32
else
	UNAME_S := $(shell uname -s)
	exe = ""
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

#### SmartSet Apps

# GNU Make doesn't handle spaces or parens in filenames very well,
# so it's difficult to reference the built executables.
# Instead, just using phony targets for now and accepting that they will
# often be unnecessarily rebuilt. Can the executables be renamed?

# smartset_fsedge := 'SmartSetFSEdgePro/SmartSet\ App-Freestyle\ \(PC\)'$(exe)
# smartset_rgb := 'SmartSetRGB/SmartSet\ App-Freestyle\ \(Mac\)'$(exe)
# smartset_adv2 := 'SmartSetAdv2/SmartSet\ App\ \(PC\)'$(exe)
# smartset_savant_elite := 'SmartSetSavantElite/SE2\ SmartSet\ App\ \(Mac\)'$(exe)

.PHONY: all smartset_adv2 smartset_fsedge smartset_master smartset_master_office smartset_rgb smartset_savant_elite smartset_tko

# all: smartset_master smartset_master_office
all: smartset_master smartset_master_office smartset_rgb smartset_tko

# TODO: 3 of the apps cannot currently build and thus are not included in the
#       "all" target:

# smartset_adv2
# .../SmartSetApps/SmartSetAdv2/u_form_main_adv2.pas(486,6) Fatal: (10022) Can't find unit u_form_dashboard used by u_form_main_adv2

# smartset_fsedge
# .../SmartSetApps/SmartSetFSEdgePro/u_form_main_fs.pas(575,6) Fatal: (10022) Can't find unit u_form_dashboard used by u_form_main_fs

# smartset_savant_elite
# .../SmartSetApps/Common/userdialog.pas(9,22) Fatal: (10022) Can't find unit LineObj used by UserDialog

smartset_adv2 = smartset_adv2
smartset_fsedge = smartset_fsedge
smartset_master = smartset_master
smartset_master_office = smartset_master_office
smartset_rgb = smartset_rgb
smartset_savant_elite = smartset_savant_elite
smartset_tko = smartset_tko

#### Rules

$(smartset_adv2): $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetAdv2/SmartSetKeyboard.lpi

$(smartset_fsedge): $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetFSEdgePro/SmartSetFSEdge.lpi

$(smartset_master): $(mbcolorliblaz) $(gifviewer) $(eccontrols) $(uecontrols) $(richmemopackage) $(creosource) $(installpkg)
	$(lazbuild) SmartSetMaster/SmartSetMaster.lpi

$(smartset_master_office): $(mbcolorliblaz) $(gifviewer) $(eccontrols) $(uecontrols) $(richmemopackage) $(creosource) $(installpkg)
	$(lazbuild) SmartSetMasterOffice/SmartSetMasterOffice.lpi

$(smartset_rgb): $(bgracontrols) $(creosource) $(eccontrols) $(installpkg) $(richmemopackage) $(gifviewer) $(mbcolorliblaz) $(uecontrols)
	$(lazbuild) SmartSetRGB/SmartSetFSEdge.lpi

$(smartset_savant_elite): $(bgracontrols) $(richmemopackage) $(uecontrols)
	$(lazbuild) SmartSetSavantElite/SE2ConfigAppWin.lpi

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
		Components/richmemo/lib \
		Components/ecc_0-9-6-10_16-06-15/EC_Controls/lib \
		Components/mbColorLib-2.2.1/mbColorLib/lib \
		Components/TGIFViewer-master/TGIFViewer-master/package/lib \
		Components/CreoSource/lib \
		Components/HSButton0.9/HSButton/lib \
		Components/bgrabitmap-master/bgrabitmap/lib \
		Components/bgracontrols-master/lib \
		Components/ueControls_v6.0/lib \
		SmartSetAdv2/lib \
		SmartSetFSEdgePro/lib \
		SmartSetMaster/lib \
		SmartSetMasterOffice/lib \
		SmartSetRGB/lib \
		SmartSetSavantElite/lib \
		SmartSetTKO/lib \
		SmartSetAdv2/SmartSetKeyboard.res \
		SmartSetFSEdgePro/SmartSetFSEdge.res \
		SmartSetMaster/SmartSetMaster.res \
		SmartSetMasterOffice/SmartSetMasterOffice.res \
		SmartSetRGB/SmartSetFSEdge.res \
		SmartSetSavantElite/SE2ConfigAppWin.res \
		SmartSetTKO/SmartSetTKO.res \
		"SmartSetAdv2/Adv2 SmartSet App (PC)" \
		"SmartSetFSEdgePro/SmartSet App-Freestyle (PC)" \
		"SmartSetMaster/SmartSetMaster (PC)" \
		"SmartSetMaster/SmartSetMaster (MAC)" \
		"SmartSetMaster/SmartSetMaster (LINUX)" \
		"SmartSetMasterOffice/SmartSetMasterErgo (PC)" \
		"SmartSetMasterOffice/SmartSetMasterErgo (MAC)" \
		"SmartSetMasterOffice/SmartSetMasterErgo (LINUX)" \
		"SmartSetRGB/SmartSet App-Freestyle (PC)" \
		"SmartSetSavantElite/SE2 SmartSet App (PC)" \
		"SmartSetTKO/SmartSetTKO" \
		SmartSetRGB/trace.log \

version:
	$(lazbuild) --version

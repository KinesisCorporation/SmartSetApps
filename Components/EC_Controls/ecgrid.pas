{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)

  Copyright (C) 2016-2020 Vojtěch Čihák, Czech Republic

  This library is free software; you can redistribute it and/or modify it under the terms of the
  GNU Library General Public License as published by the Free Software Foundation; either version
  2 of the License, or (at your option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you permission to link this
  library with independent modules to produce an executable, regardless of the license terms of
  these independent modules,and to copy and distribute the resulting executable under terms of
  your choice, provided that you also meet, for each linked independent module, the terms and
  conditions of the license of that module. An independent module is a module which is not derived
  from or based on this library. If you modify this library, you may extend this exception to your
  version of the library, but you are not obligated to do so. If you do not wish to do so, delete
  this exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
  the GNU Library General Public License for more details.

  You should have received a copy of the GNU Library General Public License along with this
  library; if not, write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.

**************************************************************************************************}

unit ECGrid;
{$mode objfpc}{$H+}

//{$DEFINE DBGGRID}  {don't remove, just comment}

{ ThemeServices.DrawText to BMP.Canvas is slower than to Canvas, strings are not clipped (Qt4 issue 32560) }

interface

uses
  Classes, SysUtils, Controls, StdCtrls, Clipbrd, CustomTimer, Forms, Graphics, ImgList, LazFileUtils,
  Laz2_DOM, Laz2_XMLRead, Laz2_XMLWrite, LCLIntf, {$IFDEF DBGGRID} LCLProc, {$ENDIF} LCLType,
  LMessages, Math, Menus, Messages, Themes, Types, ECTypes;

type
  {$PACKENUM 2}
  {$PACKSET 2}
  TCFlag = (ecfEnlarged,             { column is enlarged }
            ecfRedrawData,           { redraw data area of column bitmap }
            ecfRedrawHeader,         { redraw header of of column bitmap }
            ecfRedrawTitle);         { redraw title of of column bitmap }
  TCFlags = set of TCFlag;
  TCOption = (ecoCellToHint,         { content of data cells is shown as a Hint }
              ecoEnlargePixels,      { False = [%], True = [px] }
              ecoReadOnly,           { column is ReadOnly (never shows editor) }
              ecoSizing,             { column Width can be resized }
              ecoSorting,            { column header has up/down arrow and pushed look when clicked }
              ecoVisible);           { column is Visible }
  TCOptions = set of TCOption;
  TPositions = set of TObjectPos;
  {$PACKSET DEFAULT}
  TGFlag = (egfCalcBoundCols,
            egfCalcBoundRows,
            egfCalcColors,
            egfCalcColsLeft,
            egfCalcFixedCellIndent,
            egfCalcOrderVisi,
            egfClearSelection,       { multiselection ranges will be cleared }
            egfCorrectEditorPosX,    { make correction of Editor Left and Width after h-scroll etc. }
            egfCorrectEditorPosY,    { make correction of Editor Top and Height after change RowHeight etc. }
            egfFirstRowFullyVisi,    { first non-fixed row is fully visible }
            egfHiSelectionInitial,   { high(Selection) is initial; i.e. cell is focused but not selected }
            egfLastRowFullyVisi,     { last non-fixed row is fully visible }
            egfLockCursor,           { locks cursor on internal changes (moving/sizing Columns) }
            egfLockHint,             { locks hint on internal changes (title/column/general hint) }
            egfMoveEditor,           { editor needs to be moved after egfCalcColsLeft }
            egfMoving,               { some column is moved, threshold was exceeded }
            egfMultiSelection,       { more than one cell is selected }
            egfRangeSelects,         { MultiSelect is not [emsNone, emsMultiCell] }
            egfRedrawData,           { redraw data area }
            egfRedrawFixedCols,      { redraw fixed columns except their headers }
            egfRedrawFixedHeader,    { redraw headers of fixed columns }
            egfRedrawFixedRows,      { redraw fixed rows except headers of fixed columns }
            egfRedrawFocusedCell,    { redraw focused cell, for egoAlwaysShowEditor Option and others }
            egfResizeBMPs,           { resize bitmaps }
            egfRightToLeft,          { for less calls of IsRightToLeft }
            egfSelectCol,            { force DoSelection (after deleting Column) }
            egfSizing,               { some column is being sized }
            egfUpdateRAHeight,       { update RequiredAreaHeight }
            egfUpdateRAWidth,        { update RequiredAreaWidth }
            egfWasEnabled);          { IsEnabled changed from previous Paint }
  TGFlags = set of TGFlag;
  TGOption = (egoAlwaysShowEditor,   { Editor is shown always }
              egoAutoEnlargeColumns, { one or all columns are enlarged to fill empty space }
              egoColMoving,          { columns can be moved }
              egoColSizing,          { columns can be resized }
              egoDottedGrid,         { grid line is dotted }
              egoEnlargeAlways,      { column is enlarged even if editor is not opened }
              egoHeaderPushedLook,   { header has pushed look when clicked }
              egoHilightCol,         { data cells of column are highlighted }
              egoHilightColHeader,   { column header is highlighted }
              egoHilightRow,         { data cells of row are hilighted }
              egoHilightRowHeader,   { row header is hilighted }
              egoHorizontalLines,    { show horizontal lines of grid }
              egoReadOnly,           { grid is ReadOnly }
              egoScrollKeepVisible,  { selection remains visible while scrolling (scrollbars/mouse wheel) }
              egoSortArrow,          { sorting arrow in title is visible }
              egoTabs,               { tab goes through cells instead of through controls }
              egoThumbTracking,      { scrollbars scrolls grid immediately }
              egoUseOrder,           { OrderedCols defined; excfOrder for Load/SaveColumnsToXML avail. }
              egoVerticalLines,      { show vertical lines of grid }
              egoWheelScrollsGrid);  { mouse wheel scrolls the grid, selection stays (i.e. it scrolls away) }
  TGOptions = set of TGOption;
  TCaptureStart = (ecsNone, ecsAll, ecsFixedCols, ecsFixedRows, ecsDataCells);  { where mouse capture starts }
  TFocusedCell = (efcHilighted, efcFrame, efcBoth);
  TGridStyle = (egsFlat, egsPanel, egsStandard, egsFinePanelA, egsFinePanelB, egsFinePanelC, egsThemed);
  TMultiSelect = (emsNone, emsSingleCol, emsSingleColRange, emsSingleRow, emsSingleRowRange,
                  emsSingleRange, emsMultiCol, emsMultiRow, emsMultiRange, emsMultiCell);
  TSelectionMode = (esmNative, esmDontSelect, esmSelect);  { depends on Selection pos. and egoAlwaysShowEditor }
  TXMLColFlag = (excfOrder, excfVisible, excfWidth);
  TXMLColFlags = set of TXMLColFlag;

  TECGColumn = class;

  { events }
  TDrawDataCell = procedure (Sender: TObject; ACanvas: TCanvas; ACol, ARow: Integer; var AHandled: Boolean) of object;
  TGetDataCellText = procedure (AColumn: TECGColumn; ADataRow: Integer; out AText: string) of object;
  TGetDataRowCount = procedure (Sender: TObject; var ADataRowCount: Integer) of object;
  TGetHeaderText = procedure (Sender: TObject; ACol, ARow: Integer; out AText: string) of object;
  TSelectEditor = procedure (Sender: TObject; ACol, ADataRow: Integer; var AEditor: TControl; AKey: Word = 0) of object;
  TSelection = procedure (Sender: TObject; ACol, ARow: Integer) of object;

const
  cDefAlignment = taLeftJustify;

type
  { TECGTitleFontOptions }
  TECGTitleFontOptions = class(TFontOptions)
  published
    property FontColor default clBtnText;
    property FontStyles default [fsBold];
  end;

  { TECGColTitle }
  TECGColTitle = class(TPersistent)
  private
    FAlignment: TAlignment;
    FFontOptions: TECGTitleFontOptions;
    FHint: TTranslateString;
    FImageIndex: SmallInt;
    FPopupMenu: TPopupMenu;
    FTag: PtrInt;
    FText: TCaption;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetImageIndex(AValue: SmallInt);
    procedure SetText(AValue: TCaption);
  protected const
    cDefFontStyles = [fsBold];
  protected
    Column: TECGColumn;
    procedure RedrawHeader;
    procedure RedrawTitle;
  public
    Data: TObject;
    constructor Create(AColumn: TECGColumn);
    destructor Destroy; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default cDefAlignment;
    property FontOptions: TECGTitleFontOptions read FFontOptions write FFontOptions;
    property Hint: TTranslateString read FHint write FHint;
    property ImageIndex: SmallInt read FImageIndex write SetImageIndex default -1;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Tag: PtrInt read FTag write FTag default 0;
    property Text: TCaption read FText write SetText;
  end;

  TCustomECGrid = class;

  { TECGColumn }
  TECGColumn = class(TCollectionItem)
  private
    FAlignment: TAlignment;
    FColor: TColor;
    FColorTint: SmallInt;
    FEnlargeWidth: SmallInt;
    FFontOptions: TFontOptions;
    FHint: TTranslateString;
    FLeft: Integer;
    FMaxWidth: SmallInt;
    FMinWidth: SmallInt;
    FOnGetDataCellText: TGetDataCellText;
    FOptions: TCOptions;
    FOrder: Integer;
    FPopupMenu: TPopupMenu;
    FTag: PtrInt;
    FTitle: TECGColTitle;
    FWidth: SmallInt;
    function GetCells(ADataRow: Integer): string;
    function GetRight: Integer;
    function GetWidth: SmallInt;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetColor(AValue: TColor);
    procedure SetColorTint(AValue: SmallInt);
    procedure SetMaxWidth(AValue: SmallInt);
    procedure SetMinWidth(AValue: SmallInt);
    procedure SetOptions(AValue: TCOptions);
    procedure SetWidth(AValue: SmallInt);
  protected const
    cDefColWidth = 80;
    cDefFontStyles = [];
    cDefOptions = [ecoVisible];
    cDefText = 'Column';
  protected
    Flags: TCFlags;
    function GetDisplayName: string; override;
    procedure RecalcRedraw;
    procedure Redraw(AFlags: TCFlags);
    procedure RedrawColumnData;
    procedure SetIndex(Value: Integer); override;
  public
    Data: TObject;
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    function IsReadOnly: Boolean;
    property Cells[ADataRow: Integer]: string read GetCells;
    property Right: Integer read GetRight;
    property Order: Integer read FOrder;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default cDefAlignment;
    property Color: TColor read FColor write SetColor default clDefault;
    property ColorTint: SmallInt read FColorTint write SetColorTint default 0;         { [%] }
    property EnlargeWidth: SmallInt read FEnlargeWidth write FEnlargeWidth default 0;  { [%] or [px] }
    property FontOptions: TFontOptions read FFontOptions write FFontOptions;
    property Hint: TTranslateString read FHint write FHint;
    property Left: Integer read FLeft;
    property MaxWidth: SmallInt read FMaxWidth write SetMaxWidth default -1;
    property MinWidth: SmallInt read FMinWidth write SetMinWidth default -1;
    property Options: TCOptions read FOptions write SetOptions default cDefOptions;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Tag: PtrInt read FTag write FTag default 0;
    property Title: TECGColTitle read FTitle write FTitle;
    property Width: SmallInt read GetWidth write SetWidth default cDefColWidth;
    property OnGetDataCellText: TGetDataCellText read FOnGetDataCellText write FOnGetDataCellText;
  end;

  { TECGColumns }
  TECGColumns = class(TCollection)
  private
    function GetItems(Index: Integer): TECGColumn;
    procedure SetItems(Index: Integer; AValue: TECGColumn);
  protected
    FECGrid: TCustomECGrid;
    function GetOwner: TPersistent; override;
    procedure Notify({%H-}Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(AGrid: TCustomECGrid; AItemClass: TCollectionItemClass);
    function Add: TECGColumn;
    procedure EndUpdate; override;
    property Items[Index: Integer]: TECGColumn read GetItems write SetItems; default;
  end;

  { TCustomECGrid }
  TCustomECGrid = class(TBaseScrollControl)
  private
    FAlternateColor: TColor;
    FAlternateTint: SmallInt;
    FCol: Integer;
    FColumns: TECGColumns;
    FEditorMode: Boolean;
    FFixedCols: SmallInt;
    FFixedRowHeight: SmallInt;
    FFixedRows: SmallInt;
    FFocusedCell: TFocusedCell;
    FGridLineColor: TColor;
    FGridLineWidth: SmallInt;
    FImages: TCustomImageList;
    FMultiSelect: TMultiSelect;
    FOnDrawDataCell: TDrawDataCell;
    FOnGetDataRowCount: TGetDataRowCount;
    FOnGetHeaderText: TGetHeaderText;
    FOnHeaderClick: TSelection;
    FOnSelectEditor: TSelectEditor;
    FOnSelection: TSelection;
    FOptions: TGOptions;
    FRow: Integer;
    FRowHeight: SmallInt;
    FSizableCol: Integer;
    FSortAscendent: Boolean;
    FSortIndex: Integer;
    FStyle: TGridStyle;
    function GetCells(ACol, ARow: Integer): string;
    function GetCellsOrd(ACol, ARow: Integer): string;
    function GetColCount: Integer;
    function GetColOrd(ACol: Integer): Integer;
    function GetDataCellsOrd(ACol, ADataRow: Integer): string;
    function GetDataRow: Integer;
    function GetRowCount: Integer;
    procedure SetAlternateColor(AValue: TColor);
    procedure SetAlternateTint(AValue: SmallInt);
    procedure SetCol(AValue: Integer);
    procedure SetDataRow(AValue: Integer);
    procedure SetEditorMode(AValue: Boolean);
    procedure SetFixedCols(AValue: SmallInt);
    procedure SetFixedRowHeight(AValue: SmallInt);
    procedure SetFixedRows(AValue: SmallInt);
    procedure SetFocusedCell(AValue: TFocusedCell);
    procedure SetGridLineColor(AValue: TColor);
    procedure SetGridLineWidth(AValue: SmallInt);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetMultiSelect(AValue: TMultiSelect);
    procedure SetOptions(AValue: TGOptions);
    procedure SetRow(AValue: Integer);
    procedure SetRowHeight(AValue: SmallInt);
    procedure SetSizableCol(AValue: Integer);
    procedure SetSortAscendent(AValue: Boolean);
    procedure SetSortIndex(AValue: Integer);
    procedure SetStyle(AValue: TGridStyle);
  protected const
    cBaseFlags = DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_CALCRECT;
    cDefFocusedCell = efcHilighted;
    cDefGridLineWidth = 1;
    cDefMultiSelect = emsNone;
    cDefOptions = [egoHorizontalLines, egoThumbTracking, egoUseOrder, egoVerticalLines];
    cDefRowHeight = 20;
    cDefFixedRowHeight = cDefRowHeight+2;
    cDefStyle = egsPanel;
    cFlagsAlign: array[TAlignment, Boolean] of Cardinal = ((DT_LEFT, DT_RIGHT or DT_RTLREADING),
                  (DT_RIGHT, DT_LEFT or DT_RTLREADING), (DT_CENTER, DT_CENTER or DT_RTLREADING));
    cHorFlags = [egfCalcBoundCols, egfCalcColsLeft, egfCalcOrderVisi, egfUpdateRAWidth];
    cIndent = 3;
    cMergeHilight: Single = 0.9;
    cOutOfBounds: array[Boolean] of SmallInt = (-1, -2);  { -1 = Top/Left; -2 = Bottom/Right }
    cRedrawColumn = [ecfRedrawData, ecfRedrawHeader, ecfRedrawTitle];
    cRedrawGrid = [egfRedrawFixedHeader, egfRedrawFixedRows, egfRedrawFixedCols, egfRedrawData];
    cSelectionExpand = 4;
    cTimerInterval = 125;
    cHorScrollResetSel = [emsSingleCol, emsSingleColRange, emsSingleRowRange, emsSingleRange, emsMultiCol, emsMultiRange];
    cVertScrollResetSel = [emsSingleColRange, emsSingleRow, emsSingleRowRange, emsSingleRange, emsMultiRow, emsMultiRange];
    cWheelSelectEd: array[Boolean] of TSelectionMode = (esmDontSelect, esmNative);
    cFalse = 'false';
    cTrue = 'true';
    cRoot: DOMString = 'CONFIG';
    cColumn: DOMString = 'Column';
    cCount: DOMString = 'count';
    cOrder: DOMString = 'order';
    cVisible: DOMString = 'visible';
    cWidth: DOMString = 'width';
    cXMLColFlagsAll = [excfOrder, excfVisible, excfWidth];
  protected type
    TBkgndColors = array[Boolean, Boolean] of TColor;  { Color/AltColor, Hilighted }
    TPointDiff = record
      X, Y, PrevX, PrevY: Integer;
    end;
    TPaintFlag = (pfColHasDataEvent,  { column has OnGetDataCellText event }
                  pfEnabled,          { grid is enabled }
                  pfEditorMode,       { Editor visible }
                  pfFocusedCell,      { focused cell }
                  pfHilightCol,       { whole column is highlighted }
                  pfHilightRow,       { whole row is hilighted }
                  pfRightToLeft,      { right to left mode }
                  pfSelectedCell,     { selected cell }
                  pfSelectedCol);     { column with focused cell }
    TPaintFlags = set of TPaintFlag;
    TSelectionRange = record
      FromCell: TPoint;
      ToCell: TPoint;
      Positive: Boolean;
    end;
  protected
    class var Timer: TCustomTimer;
    class constructor CreateTimer;
    class destructor DestroyTimer;
  protected
    AutoEnlargeRatio: Single;
    BkgndColors: array[Boolean, Boolean, Boolean] of TColor;  { alternate, hilighted, enabled }
    BkSelColors: array[Boolean, Boolean, Boolean] of TColor;  { multiselect, focused, enabled }
    BMPHead, BMPFixedRows, BMPFixedCols, BMPData: TBitmap;
    CaptureStart: TCaptureStart;
    CommonPaintFlags: TPaintFlags;
    DataAreaRows: SmallInt;
    DefCursor: TCursor;
    DefHint: string;
    Details: TThemedElementDetails;
    EditorDeltaRect: TRect;
    FEditor: TControl;
    FirstVisiCell, LastVisiCell: TPointDiff;  { first/last (partially) visible column and row }
    FixedCellIndent: SmallInt;
    FixedColsWidth: Integer;
    FixedRowsHeight: SmallInt;
    FixedVisiCols: SmallInt;
    Flags: TGFlags;
    FRowCountHelp: SmallInt;
    FocusFramePen, GridLinePen: TPen;
    MouseDragScrollPos: TPositions;
    MovableCol: Integer;
    MoveEditorX: SmallInt;
    PrevClientAreaLeft, PrevClientAreaTop: Integer;
    PrevClientSize: TSize;
    HoveredCol, HoveredRow: Integer;
    PrevMouseDragScrollPos: TPositions;
    PrevSel: TPoint;
    PushedCol, PushedRow: Integer;
    ScrollIncX: SmallInt;
    Selection: array of TSelectionRange;
    SelectionHigh: SmallInt;
    SizeEdColXPos, SizeEdColWidth, SizeInitX: Integer;
    OrderedCols, VisiCols: array of Integer;
    procedure BeforeDragStart; override;
    procedure CalcBackgroundColors;
    procedure CalcBoundColumns;
    procedure CalcBoundRows;
    procedure CalcColumnsLeft;
    procedure CalcOrderAndVisiColumns;
    function CellRectBMPData(ACol, ADataRow: Integer; APFlags: TPaintFlags): TRect;
    procedure CellRectLeftRight(ACol: Integer; out ALeft, ARight: Integer);
    procedure ChangeCursor(ASizing: Boolean);
    procedure ChangeHighSelection(AFromX, AFromY, AToX, AToY: Integer);
    procedure ChangeHint(ACol, ARow: Integer);
    procedure CMBiDiModeChanged(var Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var {%H-}Message: TLMessage); message CM_COLORCHANGED;
    procedure CMEnter(var Message: TLMessage); message CM_ENTER;
    procedure CMExit(var Message: TLMessage); message CM_EXIT;
    procedure CorrectEditorPosX;
    procedure CorrectEditorPosY;
    procedure CreateHandle; override;
    procedure DoChanges;
    procedure DoColIndexChanged(ANew, APrevious: Integer);
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DoDeletion(AIndex, AOrder: Integer);
    procedure DoEnlargement(AEnlargeCol, AShrinkBackCol: Integer);
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoSelectEditor(ACol: Integer; AFocus: Boolean = True; AKey: Word = 0);
    procedure DoSelection(ACol, ARow: Integer; ASelectEditor: TSelectionMode = esmNative;
                AForceFocus: Boolean = True; AResetSelection: Boolean = False);
    procedure DoUpdated; override;
    function DoUTF8KeyPress(var UTF8Key: TUTF8Char): boolean; override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure DrawColumnGridLines(APFlags: TPaintFlags; AFixedCol: Boolean);
    procedure DrawDataCell(ACol, ARow: Integer);
    procedure DrawDataCellContent(ACol, ARow: Integer; APFlags: TPaintFlags; const ABkgndColors: TBkgndColors; ADrawGLandFF: Boolean);
    procedure DrawDataCellGridLines(APFlags: TPaintFlags);
    procedure DrawDataColumn(ACol: Integer);
    procedure DrawDataColVertScrolled(ACol, ARowShift: Integer);
    procedure DrawFixedCell(ACol, ARow: Integer);
    procedure DrawFixedCellBkgnd(ACanvas: TCanvas; const ARect: TRect; APushed: Boolean; APFlags: TPaintFlags);
    procedure DrawFixedCellContent(ACol, ARow: Integer; ARect: TRect; APFlags: TPaintFlags);
    procedure DrawFixedColumn(ACol, AFirstRow, ALastRow: Integer);
    procedure DrawFixedColsVertScrolled(ARowShift: Integer);
    procedure DrawFlatCellGridLines(ACanvas: TCanvas; AFixedCol, AHeader: Boolean; APFlags: TPaintFlags);
    procedure DrawFocusFrame(ARect: TRect; APFlags: TPaintFlags);
    procedure DrawGridHorScrolled(ACliAreaLeftShift: Integer);
    procedure DrawHeaderCell(ACol, ARow: Integer);
    procedure DrawHeaderCellContent(ACanvas: TCanvas; ACol, ARow: Integer; ARect: TRect; APFlags: TPaintFlags);
    function GetColumnBkgndColors(ACol: Integer; APFlags: TPaintFlags): TBkgndColors;
    function GetDataPaintFlags(ACol: Integer): TPaintFlags;
    class function GetControlClassDefaultSize: TSize; override;
    function GetIncrementX: Integer; override;
    function GetIncrementY: Integer; override;
    function GetPageSizeX: Integer; override;
    function GetPageSizeY: Integer; override;
    function GetVisiColIndex(ACol: Integer): Integer;
    procedure GoToRowRelative(ARows: Integer; AShift: TShiftState; AForceFocus: Boolean = True;
                AResetSelection: Boolean = True);
    procedure GoToVisiColAbsolute(ACol: Integer; AShift: TShiftState);
    procedure GoToVisiColRelative(AColumns: Integer; AShift: TShiftState);
    procedure InitEditor(AUTF8Char: TUTF8Char);
    procedure InitializeWnd; override;
    procedure JoinToSelection(AFromCol, AFromRow, AToCol, AToRow: Integer;
                AReset: Boolean = True; APositive: Boolean = True; AInitial: Boolean = False);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure ManageSelectionLength(ANewLength: SmallInt);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PrepareEditorDeltaRect(AX, AY: Boolean);
    procedure Redraw(AGFlags: TGFlags);
    procedure ResizeBMPs;
    procedure SetBorderStyle(NewStyle: TBorderStyle); override;
    procedure SetCursor(Value: TCursor); override;
    procedure SetHint(const Value: TTranslateString); override;
    procedure TimerOnTimer(Sender: TObject);
    procedure UpdateColumnData(ACol: Integer);
    procedure UpdateRequiredAreaHeight; override;
    procedure UpdateRequiredAreaWidth; override;
    procedure WMHScroll(var Msg: TWMScroll); message WM_HSCROLL;
    procedure WMSize(var Message: TLMSize); message LM_SIZE;
    procedure WMVScroll(var Msg: TWMScroll); message WM_VSCROLL;
    property SizableCol: Integer read FSizableCol write SetSizableCol;
  public
    Data: TObject;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddToSelection(AFromX, AFromY, AToX, AToY: Integer);
    procedure BeginUpdate; override;
    function CellRect(ACol, ARow: Integer): TRect;
    function CellRectEditor(ACol, ADataRow: Integer): TRect;
    procedure ClearSelection;
    procedure CopyToClipboard;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure EndUpdate; override;
    function GetNextVisiCol(ACol: Integer): Integer;
    function GetPreviousVisiCol(ACol: Integer): Integer;
    function IsCellFullyVisible(ACol, ARow: Integer): Boolean;
    function IsCellVisible(ACol, ARow: Integer): Boolean;
    function IsColFullyVisible(ACol: Integer): Boolean;
    function IsColSelected(ACol: Integer): Boolean;
    function IsColVisible(ACol: Integer): Boolean;
    function IsInSelection(ACol, ARow: Integer): Boolean;
    function IsRowFullyVisible(ARow: Integer): Boolean;
    function IsRowSelected(ARow: Integer): Boolean;
    function IsRowVisible(ARow: Integer): Boolean;
    function IsSelected(ACol, ARow: Integer): Boolean;
    procedure LoadColumnsFromXML(AColumnsNode: TDOMNode; AXMLFlags: TXMLColFlags = cXMLColFlagsAll); overload;
    procedure LoadColumnsFromXML(AFileName: string; AColumnsNode: DOMString;
                AXMLFlags: TXMLColFlags = cXMLColFlagsAll); overload;
    function MakeCellFullyVisible(ACol, ARow: Integer; AForce: Boolean): Boolean;
    procedure MouseToCell(AX, AY: Integer; out ACol, ARow: Integer);
    procedure RemoveFromSelection(AFromX, AFromY, AToX, AToY: Integer);
    procedure SaveColumnsToXML(AXMLDoc: TXMLDocument; AColumnsNode: TDOMNode;
                AXMLFlags: TXMLColFlags = cXMLColFlagsAll); overload;
    procedure SaveColumnsToXML(AFileName: string; AColumnsNode: DOMString;
                AXMLFlags: TXMLColFlags = cXMLColFlagsAll); overload;
    procedure SaveToCSVFile(AFileName: string; ADelimiter: Char = ',';
                AHeaders: Boolean = True; AVisibleColsOnly: Boolean = False);
    procedure SelectCell(ACol, ARow: Integer; ASelectEditor: TSelectionMode;
                AForceFocus: Boolean = False; AResetRow: Boolean = False);
    procedure SetFocus; override;
    procedure UpdateCell(ACol, ARow: Integer);
    procedure UpdateColumn(ACol: Integer; AHeader: Boolean = False; AData: Boolean = True);
    procedure UpdateData;
    procedure UpdateDataCell(ACol, ADataRow: Integer);
    procedure UpdateRow(ARow: Integer; AFixedCols: Boolean = False; AData: Boolean = True);
    procedure UpdateRowCount; deprecated;
    property AlternateColor: TColor read FAlternateColor write SetAlternateColor default clDefault;
    property AlternateTint: SmallInt read FAlternateTint write SetAlternateTint default 0;  { [%] }
    property Cells[ACol, ARow: Integer]: string read GetCells;
    property CellsOrd[ACol, ARow: Integer]: string read GetCellsOrd;
    property Col: Integer read FCol write SetCol;
    property ColCount: Integer read GetColCount;
    property ColOrd[ACol: Integer]: Integer read GetColOrd;
    property Columns: TECGColumns read FColumns write FColumns;
    property DataCellsOrd[ACol, ARow: Integer]: string read GetDataCellsOrd;
    property DataRow: Integer read GetDataRow write SetDataRow;
    property Editor: TControl read FEditor;
    property EditorMode: Boolean read FEditorMode write SetEditorMode;
    property FixedCols: SmallInt read FFixedCols write SetFixedCols default 0;
    property FixedRowHeight: SmallInt read FFixedRowHeight write SetFixedRowHeight default cDefFixedRowHeight;
    property FixedRows: SmallInt read FFixedRows write SetFixedRows default 1;
    property FocusedCell: TFocusedCell read FFocusedCell write SetFocusedCell default cDefFocusedCell;
    property GridLineColor: TColor read FGridLineColor write SetGridLineColor default clDefault;
    property GridLineWidth: SmallInt read FGridLineWidth write SetGridLineWidth default cDefGridLineWidth;
    property Images: TCustomImageList read FImages write SetImages;
    property MultiSelect: TMultiSelect read FMultiSelect write SetMultiSelect default cDefMultiSelect;
    property Options: TGOptions read FOptions write SetOptions default cDefOptions;
    property OnDrawDataCell: TDrawDataCell read FOnDrawDataCell write FOnDrawDataCell;
    property OnGetDataRowCount: TGetDataRowCount read FOnGetDataRowCount write FOnGetDataRowCount;
    property OnGetHeaderText: TGetHeaderText read FOnGetHeaderText write FOnGetHeaderText;
    property OnHeaderClick: TSelection read FOnHeaderClick write FOnHeaderClick;
    property OnSelectEditor: TSelectEditor read FOnSelectEditor write FOnSelectEditor;
    property OnSelection: TSelection read FOnSelection write FOnSelection;
    property Row: Integer read FRow write SetRow;
    property RowCount: Integer read GetRowCount;
    property RowHeight: SmallInt read FRowHeight write SetRowHeight default cDefRowHeight;
    property SortAscendent: Boolean read FSortAscendent write SetSortAscendent;
    property SortIndex: Integer read FSortIndex write SetSortIndex;
    property Style: TGridStyle read FStyle write SetStyle default cDefStyle;
  end;

  { TECGrid }
  TECGrid = class(TCustomECGrid)
  published
    property Align;
    property AlternateColor;
    property AlternateTint;
    property Anchors;
    property BiDiMode;
    property BorderSpacing;
    property BorderStyle default bsSingle;
    property ColCount;
    property Color default clWindow;
    property Columns;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedCols;
    property FixedRowHeight;
    property FixedRows;
    property FocusedCell;
    property Font;
    property GridLineColor;
    property GridLineWidth;
    property Images;
    property MultiSelect;
    property Options;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RowCount;
    property RowHeight;
    property ScrollBars;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDrawDataCell;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetDataRowCount;
    property OnGetHeaderText;
    property OnHeaderClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnSelectEditor;
    property OnSelection;
    property OnStartDrag;
    property OnUTF8KeyPress;
  end;

implementation

{ TECGColTitle }

constructor TECGColTitle.Create(AColumn: TECGColumn);
begin
  Column:=AColumn;
  FFontOptions:=TECGTitleFontOptions.Create(TECGColumns(Column.Collection).FECGrid);
  with FFontOptions do
    begin
      FontColor:=clBtnText;
      FontStyles:=cDefFontStyles;
      OnRecalcRedraw:=@RedrawHeader;
      OnRedraw:=@RedrawHeader;
    end;
  FImageIndex:=-1;
  if not (csLoading in TECGColumns(AColumn.Collection).FECGrid.ComponentState)
    then FText:=TECGColumn.cDefText+intToStr(Column.ID);
end;

destructor TECGColTitle.Destroy;
begin
  FreeAndNil(FFontOptions);
  inherited Destroy;
end;

procedure TECGColTitle.RedrawHeader;
begin
  include(Column.Flags, ecfRedrawHeader);
  TECGColumns(Column.Collection).FECGrid.InvalidateNonUpdated;
end;

procedure TECGColTitle.RedrawTitle;
begin
  include(Column.Flags, ecfRedrawTitle);
  TECGColumns(Column.Collection).FECGrid.InvalidateNonUpdated;
end;

{ TECGColTitle.Setters }

procedure TECGColTitle.SetAlignment(AValue: TAlignment);
begin
  if FAlignment=AValue then exit;
  FAlignment:=AValue;
  RedrawHeader;
end;

procedure TECGColTitle.SetImageIndex(AValue: SmallInt);
begin
  if FImageIndex=AValue then exit;
  FImageIndex:=AValue;
  if assigned(TECGColumns(Column.Collection).FECGrid.Images) then RedrawTitle;
end;

procedure TECGColTitle.SetText(AValue: TCaption);
begin
  if FText=AValue then exit;
  FText:=AValue;
  RedrawTitle;
end;

{ TECGColumn }

constructor TECGColumn.Create(ACollection: TCollection);
var aGrid: TCustomECGrid;
begin
  aGrid:=nil;
  if assigned(ACollection) then
    begin
      if assigned(TECGColumns(ACollection).FECGrid) then aGrid:=TECGColumns(ACollection).FECGrid;
      FOrder:=ACollection.Count;
    end;
  FColor:=clDefault;
  FMaxWidth:=-1;
  FMinWidth:=-1;
  FOptions:=cDefOptions;
  FWidth:=cDefColWidth;
  inherited Create(ACollection);
  FTitle:=TECGColTitle.Create(self);
  FFontOptions:=TFontOptions.Create(aGrid);
  with FFontOptions do
     begin
       FontStyles:=cDefFontStyles;
       OnRecalcRedraw:=@RedrawColumnData;
       OnRedraw:=@RedrawColumnData;
     end;
  Flags:=[ecfRedrawData, ecfRedrawHeader];
end;

destructor TECGColumn.Destroy;
var aColumns: TECGColumns;
begin
  FreeAndNil(FTitle);
  FreeAndNil(FFontOptions);
  aColumns:=TECGColumns(Collection);
  if aColumns.FECGrid.EditorMode then
    if aColumns.UpdateCount>0
      then aColumns.FECGrid.EditorMode:=False
      else if aColumns.FECGrid.Col>Index                                 { deleting one column }
             then aColumns.FECGrid.PrepareEditorDeltaRect(True, False);  { clear }
  inherited Destroy;
  if aColumns.UpdateCount=0 then aColumns.FECGrid.DoDeletion(Index, Order);
end;

function TECGColumn.GetDisplayName: string;
begin
  Result:=Title.Text;
  if Result='' then Result:=cDefText+intToStr(ID);
end;

procedure TECGColumn.RecalcRedraw;
begin
  Flags:=Flags+TECGrid.cRedrawColumn;
  TECGColumns(Collection).FECGrid.Redraw(TECGrid.cHorFlags+[egfRedrawData, egfRedrawFixedRows]);
end;

procedure TECGColumn.Redraw(AFlags: TCFlags);
begin
  Flags:=Flags+AFlags;
  TECGColumns(Collection).FECGrid.InvalidateNonUpdated;
end;

procedure TECGColumn.RedrawColumnData;
begin
  include(Flags, ecfRedrawData);
  TECGColumns(Collection).FECGrid.InvalidateNonUpdated;
end;

procedure TECGColumn.SetIndex(Value: Integer);
var aGFlags: TGFlags;
    aGrid: TCustomECGrid;
begin
  aGrid:=TECGColumns(Collection).FECGrid;
  aGFlags:=[egfCalcBoundCols, egfCalcColsLeft, egfCalcOrderVisi, egfRedrawData, egfRedrawFixedRows];
  if (Value<aGrid.FixedCols) or (Index<aGrid.FixedCols)
    then aGFlags:=aGFlags+[egfRedrawFixedCols, egfRedrawFixedHeader];
  aGrid.DoColIndexChanged(Value, Index);
  inherited SetIndex(Value);
  aGrid.Redraw(aGFlags);
end;

{ TECGColumn.G/Setters }

function TECGColumn.GetCells(ADataRow: Integer): string;
begin
  if assigned(OnGetDataCellText)
    then OnGetDataCellText(self, ADataRow, Result)
    else Result:='';
end;

function TECGColumn.GetRight: Integer;
begin
  Result:=Left+Width;
end;

function TECGColumn.GetWidth: SmallInt;
begin
  Result:=FWidth;
  if Math.SameValue(TECGColumns(Collection).FECGrid.AutoEnlargeRatio, 1.0) then
    begin
      if (ecfEnlarged in Flags) and (EnlargeWidth>=0) then
        if ecoEnlargePixels in Options
          then inc(Result, EnlargeWidth)                  { px }
          else inc(Result, EnlargeWidth*Result div 100);  { % }
    end else
      Result:=trunc(Result*TECGColumns(Collection).FECGrid.AutoEnlargeRatio);
end;

function TECGColumn.IsReadOnly: Boolean;
begin
  Result:=(ecoReadOnly in Options) or (egoReadOnly in TECGColumns(Collection).FECGrid.Options);
end;

procedure TECGColumn.SetAlignment(AValue: TAlignment);
begin
  if FAlignment=AValue then exit;
  FAlignment:=AValue;
  Redraw([ecfRedrawData]);
end;

procedure TECGColumn.SetColor(AValue: TColor);
begin
  if FColor=AValue then exit;
  FColor:=AValue;
  Redraw([ecfRedrawData]);
end;

procedure TECGColumn.SetColorTint(AValue: SmallInt);
begin
  AValue:=Math.EnsureRange(AValue, 0, 100);
  if FColorTint=AValue then exit;
  FColorTint:=AValue;
  Redraw([ecfRedrawData]);
end;

procedure TECGColumn.SetMaxWidth(AValue: SmallInt);
begin
  if FMaxWidth=AValue then exit;
  FMaxWidth:=AValue;
  if not (csLoading in TECGColumns(Collection).FECGrid.ComponentState) then
    if (AValue>=0) and (FWidth>AValue) then
      begin
        FWidth:=AValue;
        RecalcRedraw;
      end;
end;

procedure TECGColumn.SetMinWidth(AValue: SmallInt);
begin
  if FMinWidth=AValue then exit;
  FMinWidth:=AValue;
  if not (csLoading in TECGColumns(Collection).FECGrid.ComponentState) then
    if (AValue>=0) and (FWidth<AValue) then
      begin
        FWidth:=AValue;
        RecalcRedraw;
      end;
end;

procedure TECGColumn.SetOptions(AValue: TCOptions);
var aChangedOpts: TCOptions;
begin
  aChangedOpts:=(FOptions><AValue);
  if FOptions=AValue then exit;
  FOptions:=AValue;
  if ecoVisible in aChangedOpts then
    begin
      if Index<TECGColumns(Collection).FECGrid.FixedCols
        then include(TECGColumns(Collection).FECGrid.Flags, egfResizeBMPs);
      RecalcRedraw;
    end;
end;

procedure TECGColumn.SetWidth(AValue: SmallInt);
begin
  if AValue<0 then exit;
  if not (csLoading in TECGColumns(Collection).FECGrid.ComponentState) then
    if (MinWidth>=0) and (AValue<MinWidth)
      then AValue:=MinWidth
      else if (MaxWidth>=0) and (AValue>MaxWidth) then AValue:=MaxWidth;
  if FWidth=AValue then exit;
  FWidth:=AValue;
  RecalcRedraw;
end;

{ TECGColumns }

constructor TECGColumns.Create(AGrid: TCustomECGrid; AItemClass: TCollectionItemClass);
begin
  inherited Create(AItemClass);
  FECGrid:=AGrid;
end;

function TECGColumns.Add: TECGColumn;
begin
  Result:=TECGColumn(inherited Add);
end;

procedure TECGColumns.EndUpdate;
begin
  inherited EndUpdate;
  if UpdateCount=0 then
    with FECGrid do
      begin
        Flags:=Flags+cHorFlags;
        if Count=0 then
          begin  { after Clear; }
            FCol:=-1;
            EditorMode:=False;
            FSortIndex:=-1;
            exclude(Flags, egfRedrawFocusedCell);
          end;
        Redraw(cRedrawGrid+[egfCalcBoundRows, egfClearSelection, egfUpdateRAHeight]);
      end;
end;

function TECGColumns.GetOwner: TPersistent;
begin
  Result:=FECGrid;
end;

procedure TECGColumns.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  if UpdateCount=0 then
    begin
     { inherited Notify(Item, Action); }   { notify observers }
      case Action of
        cnAdded:
          with FECGrid do
            begin
              Flags:=Flags+cHorFlags;
              if Count=1 then Flags:=Flags+[egfCalcBoundRows, egfUpdateRAHeight];
              if egoAutoEnlargeColumns in Options then Flags:=Flags+cRedrawGrid;
              if UpdateCount=0 then  { ~3% faster than InvalidateNonUpdated; }
                begin
                  DoChanges;
                  Invalidate;
                end;
            end;
      end;
    end;
end;

{ TECGColumns.Setters }

function TECGColumns.GetItems(Index: Integer): TECGColumn;
begin
  Result:=TECGColumn(inherited Items[Index]);
end;

procedure TECGColumns.SetItems(Index: Integer; AValue: TECGColumn);
begin
  Items[Index].Assign(AValue);
end;

{ TCustomECGrid }

constructor TCustomECGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csOpaque, csClickEvents, csCaptureMouse, csParentBackground]+csMultiClicks
                            -[csParentBackground, csAcceptsControls, csNoFocus, csSetCaption];
  FAlternateColor:=clDefault;
  FCol:=-1;
  Columns:=TECGColumns.Create(self, TECGColumn);
  Columns.BeginUpdate;
  CommonPaintFlags:=[pfEnabled];
  FFixedRowHeight:=cDefFixedRowHeight;
  FFixedRows:=1;
  FixedRowsHeight:=FixedRows*cDefFixedRowHeight;
  FFocusedCell:=cDefFocusedCell;
  FGridLineColor:=clDefault;
  FGridLineWidth:=cDefGridLineWidth;
  FOptions:=cDefOptions;
  FRow:=-1;
  FRowHeight:=cDefRowHeight;
  FSortAscendent:=True;
  FSortIndex:=-1;
  FStyle:=cDefStyle;
  AutoEnlargeRatio:=1.0;
  BorderStyle:=bsSingle;
  Color:=clWindow;
  DefCursor:=Cursor;
  FocusFramePen:=TPen.Create;
  with FocusFramePen do
    begin
      Cosmetic:=False;
      EndCap:=pecFlat;
      JoinStyle:=pjsBevel;
      Style:=psSolid;
      Width:=2;
    end;
  GridLinePen:=TPen.Create;
  with GridLinePen do
    begin
      Cosmetic:=False;
      EndCap:=pecFlat;
      JoinStyle:=pjsBevel;
    end;
  HoveredCol:=-1;
  MovableCol:=-1;
  SizableCol:=-1;
  ParentColor:=False;
  SetLength(Selection, cSelectionExpand);
  SelectionHigh:=-1;
  TabStop:=True;
  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, cx, cy);
  BMPHead:=TBitmap.Create;
  BMPHead.Canvas.Clipping:=True;
  BMPFixedRows:=TBitmap.Create;
  BMPFixedRows.Canvas.Clipping:=True;
  BMPFixedCols:=TBitmap.Create;
  BMPFixedCols.Canvas.Clipping:=True;
  BMPData:=TBitmap.Create;
  BMPData.Canvas.Clipping:=True;
  Details:=ThemeServices.GetElementDetails(thHeaderItemNormal);
  Flags:=[egfCalcBoundCols, egfCalcBoundRows, egfCalcFixedCellIndent, egfCalcColors,
          egfCalcOrderVisi, egfResizeBMPs, egfUpdateRAHeight, egfUpdateRAWidth];
  PrevSel:=Point(-1, -1);
  PushedCol:=-1;
end;

destructor TCustomECGrid.Destroy;
begin
  exclude(FOptions, egoUseOrder);
  inc(UpdateCount);
  FEditorMode:=False;
  FreeAndNil(FColumns);
  FreeAndNil(BMPHead);
  FreeAndNil(BMPFixedRows);
  FreeAndNil(BMPFixedCols);
  FreeAndNil(BMPData);
  FreeAndNil(FocusFramePen);
  FreeAndNil(GridLinePen);
  inherited Destroy;
end;

class constructor TCustomECGrid.CreateTimer;
begin
  Timer:=TCustomTimer.Create(nil);
  Timer.Enabled:=False;
  Timer.Interval:=cTimerInterval;
end;

class destructor TCustomECGrid.DestroyTimer;
begin
  FreeAndNil(Timer);
end;

procedure TCustomECGrid.AddToSelection(AFromX, AFromY, AToX, AToY: Integer);
var aIndex: Integer;
begin
  if MultiSelect>emsNone then
    begin
      if not (MultiSelect in [emsSingleCol, emsSingleRow, emsSingleRange]) then
        begin
          aIndex:=SelectionHigh+1;
          if (egfHiSelectionInitial in Flags) and (aIndex>0) then dec(aIndex);
        end else
          aIndex:=0;
      ManageSelectionLength(aIndex+1);
      case MultiSelect of
        emsSingleCol, emsMultiCol:
          begin
            AFromY:=FixedRows;
            AToY:=RowCount-1;
          end;
        emsSingleRow, emsMultiRow:
          begin
            AFromX:=FixedCols;
            AToX:=Columns.Count-1;
          end;
      end;
      case MultiSelect of
        emsSingleCol: AToX:=AFromX;
        emsSingleRow: AToY:=AFromY;
      end;
      with Selection[aIndex] do
        begin
          FromCell.X:=AFromX;
          FromCell.Y:=AFromY;
          ToCell.X:=AToX;
          ToCell.Y:=AToY;
          Positive:=True;
        end;
      Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
      Redraw([egfRedrawData]);
    end;
end;

procedure TCustomECGrid.BeforeDragStart;
begin
  inherited BeforeDragStart;
  include(Flags, egfMoving);
end;

procedure TCustomECGrid.BeginUpdate;
begin
  ControlStyle:=ControlStyle+[csNoStdEvents];
  inherited BeginUpdate;
  EditorMode:=False;
end;

procedure TCustomECGrid.CalcBackgroundColors;
const cNotFocused: Single = 0.77;
var aColor: TColor;
    bAlt, bHilight: Boolean;
begin  { [alternate, hilight, enabled]; [multiselect, focused, enabled] }
  aColor:=GetColorResolvingDefault(Color, clWindow);
  BkgndColors[False, False, True]:=aColor;
  if AlternateColor=clDefault
    then BkgndColors[True, False, True]:=aColor
    else BkgndColors[True, False, True]:=GetMergedColor(AlternateColor, aColor, 0.01*AlternateTint);
  BkgndColors[False, True, True]:=GetMergedColor(aColor, clHighlight, cMergeHilight);
  BkgndColors[True, True, True]:=GetMergedColor(BkgndColors[True, False, True], clHighlight, cMergeHilight);
  for bAlt:=False to True do
    for bHilight:=False to True do
      BkgndColors[bAlt, bHilight, False]:=GetMonochromaticColor(BkgndColors[bAlt, bHilight, True]);
  BkSelColors[False, True, True]:=clHighlight;
  BkSelColors[False, False, True]:=GetMergedColor(clHighlight, aColor, cNotFocused);
  BkSelColors[False, False, False]:=GetMonochromaticColor(BkSelColors[False, False, True]);
  BkSelColors[True, True, True]:=GetSaturatedColor(GetMergedColor(clHighlight, aColor, 0.7), 0.75);
  BkSelColors[True, False, True]:=GetMergedColor(BkSelColors[True, True, True], aColor, cNotFocused);
  BkSelColors[True, False, False]:=GetMonochromaticColor(BkSelColors[True, False, True]);
  exclude(Flags, egfCalcColors);
end;

procedure TCustomECGrid.CalcBoundColumns;
var i, aClientAreaX, aCnt, aMax, aMin, aVisiCountM1: Integer;
begin
  aClientAreaX:=FixedColsWidth+ClientAreaLeft;
  aMin:=FixedVisiCols;
  aVisiCountM1:=high(VisiCols);
  if aVisiCountM1>=aMin then
    begin
      aMax:=aVisiCountM1;
      aCnt:=2;
      if aMax>0 then inc(aCnt, round(log2(aMax)));
      while aCnt>0 do
        begin
          i:=(aMax+aMin) div 2;
          if Columns[VisiCols[i]].Left<=aClientAreaX then
            begin
              aMin:=i;
              if Columns[VisiCols[i]].Right>aClientAreaX then break;
            end else
              aMax:=i;
          dec(aCnt);
        end;
      FirstVisiCell.X:=i;
      ScrollIncX:=Columns[VisiCols[i]].Width;
      aClientAreaX:=Math.min(FRequiredArea.X, ClientAreaLeft+ClientWidth);
      while (i<aVisiCountM1) and (Columns[VisiCols[i]].Right<aClientAreaX) do
        inc(i);
      LastVisiCell.X:=i;
    end else
    begin
      FirstVisiCell.X:=-2;
      LastVisiCell.X:=-3;
    end;
  exclude(Flags, egfCalcBoundCols);
end;

procedure TCustomECGrid.CalcBoundRows;
var aDataArea, aLastVisiRow, aRowHeight, aRowHelp: Integer;
begin
  Flags:=Flags-[egfCalcBoundRows, egfFirstRowFullyVisi, egfLastRowFullyVisi];
  aRowHeight:=RowHeight;
  FirstVisiCell.Y:=ClientAreaTop div aRowHeight +FixedRows;
  aRowHelp:=ClientAreaTop mod aRowHeight;
  if aRowHelp=0 then include(Flags, egfFirstRowFullyVisi);
  aDataArea:=ClientHeight-FixedRowsHeight+aRowHelp;
  aLastVisiRow:=aDataArea div aRowHeight;
  DataAreaRows:=aLastVisiRow;
  inc(aLastVisiRow, FirstVisiCell.Y);
  aRowHelp:=RowCount;
  if aLastVisiRow<aRowHelp then
    begin
      if (aDataArea mod aRowHeight)=0 then
        begin
          dec(aLastVisiRow);
          include(Flags, egfLastRowFullyVisi);
        end;
      LastVisiCell.Y:=aLastVisiRow;
    end else
    begin
      LastVisiCell.Y:=aRowHelp-1;
      include(Flags, egfLastRowFullyVisi);
    end;
end;

procedure TCustomECGrid.CalcColumnsLeft;
var i, aHelp, aPrevFixedColsWidth: Integer;
begin
  if egoAutoEnlargeColumns in Options then
    begin
      aHelp:=0;
      for i:=0 to high(VisiCols) do
        begin
          inc(aHelp, Columns[VisiCols[i]].FWidth);
          if aHelp>=ClientWidth then break;
        end;
      if InRangeCO(aHelp, 1, ClientWidth)
        then AutoEnlargeRatio:=ClientWidth/aHelp
        else AutoEnlargeRatio:=1.0;
    end;
  aHelp:=0;
  for i:=0 to high(VisiCols) do
    begin
      Columns[VisiCols[i]].FLeft:=aHelp;
      inc(aHelp, Columns[VisiCols[i]].Width);
    end;
  aHelp:=0;  { calc. visible fixed columns }
  for i:=0 to Math.min(FixedCols, Columns.Count)-1 do
    if ecoVisible in Columns[i].Options then inc(aHelp);
  FixedVisiCols:=aHelp;
  aPrevFixedColsWidth:=FixedColsWidth;
  if aHelp>0
    then FixedColsWidth:=Columns[VisiCols[aHelp-1]].Right
    else FixedColsWidth:=0;
  if FixedColsWidth<>aPrevFixedColsWidth then include(Flags, egfResizeBMPs);
  exclude(Flags, egfCalcColsLeft);
end;

procedure TCustomECGrid.CalcOrderAndVisiColumns;
var i, aCount, aVisibles: Integer;
begin
  aCount:=Columns.Count;
  aVisibles:=aCount;
  if egoUseOrder in Options then
    begin
      SetLength(OrderedCols, aCount);
      for i:=0 to aCount-1 do
        begin
          OrderedCols[Columns[i].Order]:=i;
          if not (ecoVisible in Columns[i].Options) then dec(aVisibles);
        end
    end else
    begin
      SetLength(OrderedCols, 0);
      for i:=0 to aCount-1 do
        if not (ecoVisible in Columns[i].Options) then dec(aVisibles);
    end;
  SetLength(VisiCols, aVisibles);
  aVisibles:=0;
  for i:=0 to aCount-1 do
    if ecoVisible in Columns[i].Options then
      begin
        VisiCols[aVisibles]:=i;
        inc(aVisibles);
      end;
  exclude(Flags, egfCalcOrderVisi);
end;

function TCustomECGrid.CellRect(ACol, ARow: Integer): TRect;
begin
  if ACol<Columns.Count then
    begin
      CellRectLeftRight(ACol, Result.Left, Result.Right);
      if ARow<FixedRows then
        begin
          Result.Top:=ARow*FixedRowHeight;
          Result.Bottom:=Result.Top+FixedRowHeight;
        end else
        begin
          Result.Top:=FixedRowsHeight+(ARow-FixedRows)*RowHeight-ClientAreaTop;
          Result.Bottom:=Result.Top+RowHeight;
        end;
    end;
end;

function TCustomECGrid.CellRectBMPData(ACol, ADataRow: Integer; APFlags: TPaintFlags): TRect;
var aRowHeight: SmallInt;
begin
  Result.Left:=Columns[ACol].Left-ClientAreaLeft-FixedColsWidth;
  if pfRightToLeft in APFlags then Result.Left:=BMPData.Width-Result.Left-Columns[ACol].Width;
  aRowHeight:=RowHeight;
  Result.Top:=(aDataRow-ClientAreaTop div aRowHeight)*aRowHeight;
  Result.Right:=Result.Left+Columns[ACol].Width;
  Result.Bottom:=Result.Top+aRowHeight;
end;

function TCustomECGrid.CellRectEditor(ACol, ADataRow: Integer): TRect;
begin
  if ACol<Columns.Count then
    begin
      CellRectLeftRight(ACol, Result.Left, Result.Right);
      Result.Top:=FixedRowsHeight+ADataRow*RowHeight-ClientAreaTop;
      Result.Bottom:=Result.Top+RowHeight;
      if (GridLineWidth and 1)=1 then
        begin
          if not (egfRightToLeft in Flags)
            then dec(Result.Right)
            else inc(Result.Left);
          dec(Result.Bottom);
        end;
    end;
end;

procedure TCustomECGrid.CellRectLeftRight(ACol: Integer; out ALeft, ARight: Integer);
begin
  if not (egfRightToLeft in Flags) then
    begin
      ALeft:=Columns[ACol].Left;
      if ACol>=FixedCols then dec(ALeft, ClientAreaLeft);
      ARight:=ALeft+Columns[ACol].Width;
    end else
    begin
      ARight:=ClientWidth-Columns[ACol].Left;
      if ACol>=FixedCols then inc(ARight, ClientAreaLeft);
      ALeft:=ARight-Columns[ACol].Width;
    end;
end;

procedure TCustomECGrid.ChangeCursor(ASizing: Boolean);
begin
  include(Flags, egfLockCursor);
  if not ASizing
    then Cursor:=DefCursor
    else Cursor:=crHSplit;
  exclude(Flags, egfLockCursor);
end;

procedure TCustomECGrid.ChangeHighSelection(AFromX, AFromY, AToX, AToY: Integer);
begin
  with Selection[SelectionHigh] do
    begin
      FromCell.X:=AFromX;
      FromCell.Y:=AFromY;
      ToCell.X:=AToX;
      ToCell.Y:=AToY;
    end;
  Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
end;

procedure TCustomECGrid.ChangeHint(ACol, ARow: Integer);
var aOldHint: string;
begin
  include(Flags, egfLockHint);
  aOldHint:=Hint;
  if (ACol>=0) and (ARow>=0)
    then if ecoCellToHint in Columns[ACol].Options
           then if ARow>=FixedRows
                  then Hint:=Columns[ACol].Cells[ARow-FixedRows]
                  else Hint:=Columns[ACol].Title.Hint
           else if (ARow<FixedRows) and (Columns[ACol].Title.Hint<>'')
                  then Hint:=Columns[ACol].Title.Hint
                  else if Columns[ACol].Hint<>''
                         then Hint:=Columns[ACol].Hint
                         else Hint:=DefHint
    else Hint:=DefHint;
  exclude(Flags, egfLockHint);
  if aOldHint<>Hint then
    begin
      Application.CancelHint;
      Application.ActivateHint(Mouse.CursorPos);
    end;
end;

procedure TCustomECGrid.ClearSelection;
begin
  if egfMultiSelection in Flags then Redraw([egfClearSelection, egfRedrawData]);
end;

procedure TCustomECGrid.CMBiDiModeChanged(var Message: TLMessage);
begin
  if not IsRightToLeft then
    begin
      exclude(Flags, egfRightToLeft);
      exclude(CommonPaintFlags, pfRightToLeft);
    end else
    begin
      include(Flags, egfRightToLeft);
      include(CommonPaintFlags, pfRightToLeft);
    end;
  Flags:=Flags+cRedrawGrid;
  inherited CMBidiModeChanged(Message);
end;

procedure TCustomECGrid.CMColorChanged(var Message: TLMessage);
begin
  Redraw([egfCalcColors, egfRedrawData]);
end;

procedure TCustomECGrid.CMEnter(var Message: TLMessage);
begin
  inherited CMEnter(Message);
  if (Editor is TWinControl) and TWinControl(Editor).CanFocus
    then TWinControl(Editor).SetFocus
    else if IsCellVisible(Col, Row) and not (egfMultiSelection in Flags) then include(Flags, egfRedrawFocusedCell);
  if egfMultiSelection in Flags then Redraw([egfRedrawData]);
end;

procedure TCustomECGrid.CMExit(var Message: TLMessage);
begin
  inherited CMExit(Message);
  if not (egoAlwaysShowEditor in Options) then
    if assigned(Editor) then
      begin
        EditorMode:=False;
        Invalidate;
      end else
        if IsCellVisible(Col, Row) and not (egfMultiSelection in Flags) then include(Flags, egfRedrawFocusedCell);
  if egfMultiSelection in Flags then Redraw([egfRedrawData]);
end;

procedure TCustomECGrid.CopyToClipboard;
var aMultiSelect: TMultiSelect;
    aRect: TRect;
    aStr: string;
    i, j: Integer;
begin
  aStr:='';
  aMultiSelect:=MultiSelect;
  if not (egfMultiSelection in Flags) then aMultiSelect:=emsNone;
  if aMultiSelect<>emsNone then
    begin
      aRect.TopLeft:=Selection[0].FromCell;
      aRect.BottomRight:=Selection[0].ToCell;
      NormalizeRectangle(aRect);
      j:=SelectionHigh;
      if egfHiSelectionInitial in Flags then dec(j);
      for i:=1 to j do
        begin
          aRect.Left:=Math.MinValue([aRect.Left, Selection[i].FromCell.X, Selection[i].ToCell.X]);
          aRect.Top:=Math.MinValue([aRect.Top, Selection[i].FromCell.Y, Selection[i].ToCell.Y]);
          aRect.Right:=Math.MaxValue([aRect.Right, Selection[i].FromCell.X, Selection[i].ToCell.X]);
          aRect.Bottom:=Math.MaxValue([aRect.Bottom, Selection[i].FromCell.Y, Selection[i].ToCell.Y]);
        end;
      dec(aRect.Top, FixedRows);
      dec(aRect.Bottom, FixedRows);
      case aMultiSelect of
        emsSingleCol, emsSingleColRange, emsSingleRow, emsSingleRowRange, emsSingleRange:
          for j:=aRect.Top to aRect.Bottom do
            begin
              for i:=aRect.Left to aRect.Right-1 do
                aStr:=aStr+Columns[i].Cells[j]+Char(VK_TAB);
              aStr:=aStr+Columns[aRect.Right].Cells[j];
              if j<aRect.Bottom then aStr:=aStr+LineEnding;
            end;
        emsMultiCol, emsMultiRow, emsMultiRange, emsMultiCell:
          for j:=aRect.Top to aRect.Bottom do
            begin
              for i:=aRect.Left to aRect.Right-1 do
                if IsInSelection(i, j+FixedRows)
                  then aStr:=aStr+Columns[i].Cells[j]+Char(VK_TAB)
                  else aStr:=aStr+Char(VK_TAB);
              if IsInSelection(aRect.Right, j+FixedRows) then aStr:=aStr+Columns[aRect.Right].Cells[j];
              if j<aRect.Bottom then aStr:=aStr+LineEnding;
            end;
        end;
    end else
    if (Row>=FixedRows) and (Col>=FixedCols) then aStr:=Columns[Col].Cells[Row-FixedRows];
  if aStr<>'' then Clipboard.AsText:=aStr;
end;

procedure TCustomECGrid.CorrectEditorPosX;
var aLeft, aRight: Integer;
    bCellFullyVisi: Boolean;
begin
  CellRectLeftRight(Col, aLeft, aRight);
  if not (egfRightToLeft in Flags)
    then bCellFullyVisi:=(aLeft>=FixedColsWidth) and (aRight<=ClientWidth)
    else bCellFullyVisi:=(aLeft>=0) and (aRight<=(ClientWidth-FixedColsWidth));
  Editor.Left:=aLeft+EditorDeltaRect.Left;
  Editor.Width:=aRight-aLeft+EditorDeltaRect.Right;
  if bCellFullyVisi
    then Editor.Visible:=True
    else if not (egoAlwaysShowEditor in Options)
           then EditorMode:=False
           else if Editor.Visible then
                  begin
                    include(Flags, egfRedrawFocusedCell);
                    Editor.Visible:=False;
                  end;
  exclude(Flags, egfCorrectEditorPosX);
end;

procedure TCustomECGrid.CorrectEditorPosY;
var aTop, aBottom: Integer;
begin
  aTop:=FixedRowsHeight+(Row-FixedRows)*RowHeight-ClientAreaTop;
  aBottom:=aTop+RowHeight;
  Editor.Top:=aTop+EditorDeltaRect.Top;
  Editor.Height:=aBottom-aTop+EditorDeltaRect.Bottom;
  if (aTop>=FixedRowsHeight) and (aBottom<=ClientHeight)
    then Editor.Visible:=True
    else if not (egoAlwaysShowEditor in Options)
           then EditorMode:=False
           else if Editor.Visible then
                  begin
                    include(Flags, egfRedrawFocusedCell);
                    Editor.Visible:=False;
                  end;
  exclude(Flags, egfCorrectEditorPosY);
end;

procedure TCustomECGrid.CreateHandle;
begin
  Flags:=Flags+cRedrawGrid;
  inherited CreateHandle;
end;

procedure TCustomECGrid.DoChanges;
var aColHelp, aRow: Integer;
    aGFlags: TGFlags;
    bUpdate, bValidCol, bValidRow: Boolean;
begin
  {$IFDEF DBGGRID} DebugLn('TCustomECGrid.DoChanges'); {$ENDIF}
  aGFlags:=Flags;
  if egfClearSelection in aGFlags then
    begin
      SelectionHigh:=-1;
      Flags:=Flags-[egfClearSelection, egfMultiSelection];
    end;
  bUpdate:=([egfUpdateRAHeight, egfUpdateRAWidth]*aGFlags<>[]);
  if egfCalcColors in Flags then CalcBackgroundColors;
  if egfCalcFixedCellIndent in aGFlags then
    begin
      FixedCellIndent:=cIndent;
      case Style of
        egsFlat: inc(FixedCellIndent, GridLineWidth div 2);
        egsFinePanelB, egsFinePanelC: inc(FixedCellIndent);
      end;
      exclude(Flags, egfCalcFixedCellIndent);
    end;
  if bUpdate then inc(UpdateCount);
  if egfUpdateRAHeight in aGFlags then UpdateRequiredAreaHeight;
  if egfCalcOrderVisi in aGFlags then CalcOrderAndVisiColumns;
  if egfCalcColsLeft in aGFlags then CalcColumnsLeft;
  if egfSelectCol in aGFlags then
    begin
      Flags:=Flags-[egfCorrectEditorPosX, egfSelectCol];
      aColHelp:=FCol;
      FCol:=-2;
      Col:=aColHelp;
    end;
  if egfMoveEditor in aGFlags then
    begin
      if IsColFullyVisible(Col) then
        begin
          aColHelp:=Columns[Col].Left-MoveEditorX;
          if egfRightToLeft in Flags then aColHelp:=-aColHelp;
          Editor.Left:=Editor.Left+aColHelp;
          MoveEditorX:=0;
        end else
          EditorMode:=False;
      exclude(Flags, egfMoveEditor);
    end;
  if egfUpdateRAWidth in aGFlags then UpdateRequiredAreaWidth;
  if bUpdate then UpdateScrollBars;
  if egfResizeBMPs in Flags then ResizeBMPs;
  if egfCalcBoundCols in aGFlags then CalcBoundColumns;
  if egfCalcBoundRows in aGFlags then CalcBoundRows;
  if egfCorrectEditorPosX in Flags then CorrectEditorPosX;
  if egfCorrectEditorPosY in Flags then CorrectEditorPosY;
  if bUpdate then
    begin
      aRow:=Row;
      bValidRow:=False;
      if RowCount>FixedRows then
        if aRow<FixedRows
          then aRow:=FixedRows
          else if aRow>=RowCount
                 then aRow:=RowCount-1
                 else bValidRow:=True;
      aColHelp:=Col;
      bValidCol:=False;
      if length(VisiCols)>FixedVisiCols then
        if aColHelp<VisiCols[FixedVisiCols]
          then aColHelp:=VisiCols[FixedVisiCols]
          else if aColHelp>VisiCols[high(VisiCols)]
                 then aColHelp:=VisiCols[high(VisiCols)]
                 else bValidCol:=True;
      if not (bValidCol and bValidRow) and (bValidRow or (aRow<>Row)) and (bValidCol or (aColHelp<>Col))
        then DoSelection(aColHelp, aRow, esmNative, False);
      dec(UpdateCount);
    end;
end;

procedure TCustomECGrid.DoColIndexChanged(ANew, APrevious: Integer);
var aCol: Integer;
begin
  aCol:=Col;
  if aCol>=0 then
    begin
      MoveEditorX:=Columns[aCol].Left;
      if APrevious=aCol
        then FCol:=ANew
        else if APrevious>aCol then
               begin
                 if ANew<=aCol then FCol:=aCol+1;
               end else
                 if ANew>=aCol then FCol:=aCol-1;
      if EditorMode then include(Flags, egfMoveEditor);
    end;
  aCol:=SortIndex;
  if aCol>=FixedCols then
    if APrevious=aCol
      then SortIndex:=ANew
      else if APrevious>aCol then
             begin
               if ANew<=aCol then SortIndex:=aCol+1;
             end else
               if ANew>=aCol then SortIndex:=aCol-1;
end;

procedure TCustomECGrid.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
begin
  if IsEnabled and (HoveredCol>=0) and (HoveredRow>=0) then
    begin
      if (HoveredRow<FixedRows) and assigned(Columns[HoveredCol].Title.PopupMenu) then
        begin
          Columns[HoveredCol].Title.PopupMenu.PopUp;
          Handled:=True;
        end else
          if assigned(Columns[HoveredCol].PopupMenu) then
            begin
              Columns[HoveredCol].PopupMenu.PopUp;
              Handled:=True;
            end;
    end;
  inherited DoContextPopup(MousePos, Handled);
end;

procedure TCustomECGrid.DoDeletion(AIndex, AOrder: Integer);
var i, aCol: Integer;
begin
  aCol:=FCol;
  if aCol=AIndex then
    begin
      if EditorMode then
        begin
          FCol:=-1;
          EditorMode:=False;
        end;
      i:=aCol-1;
      while (i>=0) and not (ecoVisible in Columns[i].Options) do
        dec(i);
      FCol:=i;
      include(Flags, egfSelectCol);
    end else
      if aCol>AIndex then FCol:=aCol-1;
  aCol:=SortIndex;
  if aCol=AIndex
    then FSortIndex:=-1
    else if aCol>AIndex then FSortIndex:=aCol-1;
  if egoUseOrder in Options then
    for i:=0 to Columns.Count-1 do
      if Columns[i].Order>AOrder then dec(Columns[i].FOrder);
  Flags:=Flags+cHorFlags+[egfClearSelection, egfRedrawData, egfRedrawFixedRows];
  if Columns.Count=0 then include(Flags, egfUpdateRAHeight);
  if UpdateCount=0 then  { ~3% faster than InvalidateNonUpdated; }
    begin
      DoChanges;
      Invalidate;
    end;
end;

procedure TCustomECGrid.DoEnlargement(AEnlargeCol, AShrinkBackCol: Integer);
var bEnlarge, bShrink: Boolean;
begin
  bShrink:=((AShrinkBackCol>=0) and (ecfEnlarged in Columns[AShrinkBackCol].Flags));
  bEnlarge:=((AEnlargeCol>=0) and (Columns[AEnlargeCol].EnlargeWidth<>0));
  if bShrink then exclude(Columns[AShrinkBackCol].Flags, ecfEnlarged);
  if bEnlarge then include(Columns[AEnlargeCol].Flags, ecfEnlarged);
  if bShrink or bEnlarge then
    Redraw([egfCalcBoundCols, egfCalcColsLeft, egfRedrawData, egfRedrawFixedRows, egfUpdateRAWidth]);
end;

function TCustomECGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var aNewRow, aSelectionPos: Integer;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
    begin
      exclude(Shift, ssShift);
      aNewRow:=Math.min(RowCount-1, Row+1);
      if not (egoWheelScrollsGrid in Options) xor (ssModifier in Shift) then
        begin
          exclude(Shift, ssModifier);
          GoToRowRelative(1, Shift, False, (MultiSelect in cVertScrollResetSel) and not IsInSelection(Col, aNewRow));
        end else
        begin
          aSelectionPos:=-1;
          if egoScrollKeepVisible in Options then
            begin
              if IsRowVisible(Row) then aSelectionPos:=Row-FirstVisiCell.Y;
              if (MultiSelect in cVertScrollResetSel) and not IsInSelection(Col, aNewRow) then ClearSelection;
            end;
          include(Flags, egfCalcBoundRows);
          if EditorMode then PrepareEditorDeltaRect(False, True);
          ClientAreaTop:=ClientAreaTop+RowHeight;
          if aSelectionPos>=0 then
            DoSelection(Col, FirstVisiCell.Y+aSelectionPos, cWheelSelectEd[egoAlwaysShowEditor in Options]);
        end;
      Result:=True;
    end;
end;

function TCustomECGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
var aNewRow, aSelectionPos: Integer;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
    begin
      exclude(Shift, ssShift);
      aNewRow:=Math.max(FixedRows, Row-1);
      if not (egoWheelScrollsGrid in Options) xor (ssModifier in Shift) then
        begin
          exclude(Shift, ssModifier);
          GoToRowRelative(-1, Shift, False, (MultiSelect in cVertScrollResetSel) and not IsInSelection(Col, aNewRow));
        end else
        begin
          aSelectionPos:=-1;
          if egoScrollKeepVisible in Options then
            begin
              if IsRowVisible(Row) then aSelectionPos:=Row-FirstVisiCell.Y;
              if (MultiSelect in cVertScrollResetSel) and not IsInSelection(Col, aNewRow) then ClearSelection;
            end;
          include(Flags, egfCalcBoundRows);
          if EditorMode then PrepareEditorDeltaRect(False, True);
          ClientAreaTop:=ClientAreaTop-RowHeight;
          if aSelectionPos>=0 then
            DoSelection(Col, FirstVisiCell.Y+aSelectionPos, cWheelSelectEd[egoAlwaysShowEditor in Options]);
        end;
      Result:=True;
    end;
end;

procedure TCustomECGrid.DoSelectEditor(ACol: Integer; AFocus: Boolean = True; AKey: Word = 0);
var aEditor: TControl;
    aRect: TRect;
begin
  if assigned(OnSelectEditor) then
    begin
      aEditor:=nil;
      if not (egoEnlargeAlways in Options) then DoEnlargement(ACol, -1);
      OnSelectEditor(self, ACol, Row-FixedRows, aEditor, AKey);
      if assigned(aEditor) then
        begin
          FEditor:=aEditor;
          FEditorMode:=True;
          if not assigned(aEditor.PopupMenu) then aEditor.PopupMenu:=PopupMenu;
          aEditor.Visible:=True;
          aEditor.Parent:=self;
          if not (aEditor is TWinControl) and not (egoAlwaysShowEditor in Options) then
            begin
              aRect:=CellRect(ACol, Row);
              InvalidateRect(Handle, @aRect, False);
            end;
          if AFocus and (aEditor is TWinControl) and TWinControl(aEditor).CanFocus then TWinControl(aEditor).SetFocus;
        end else
          if not (egoEnlargeAlways in Options) then DoEnlargement(-1, ACol);
    end;
end;

procedure TCustomECGrid.DoSelection(ACol, ARow: Integer; ASelectEditor: TSelectionMode;
            AForceFocus: Boolean = True; AResetSelection: Boolean = False);
var aPrevCol: Integer;
begin
  aPrevCol:=Col;
  if (ACol=aPrevCol) and (ARow=Row) then
    begin
      if not EditorMode and not (ASelectEditor=esmDontSelect) and (ARow<>-1)
        and not Columns[ACol].IsReadOnly and (UpdateCount=0) then
        begin
          DoSelectEditor(ACol, AForceFocus);
          if EditorMode then DrawDataCell(aPrevCol, ARow);
        end;
    end else
    begin
      if AResetSelection then JoinToSelection(ACol, ARow, ACol, ARow, True, True, True);
      AForceFocus:=(AForceFocus or ((EditorMode and (Editor is TWinControl) and TWinControl(Editor).Focused) or Focused));
      EditorMode:=False;
      FCol:=ACol;
      FRow:=ARow;
      if (egoAlwaysShowEditor in Options) and (egfCalcBoundRows in Flags) then CalcBoundRows;
      if (ACol<>aPrevCol) and (egoEnlargeAlways in Options) then DoEnlargement(ACol, aPrevCol);
      if UpdateCount=0 then
        begin
          if assigned(OnSelection) then OnSelection(self, ACol, ARow);
          if (ASelectEditor<>esmDontSelect) and not Columns[ACol].IsReadOnly then
            if ((ASelectEditor=esmSelect) or (egoAlwaysShowEditor in Options)) and assigned(OnSelectEditor) then
              begin
                DoEnlargement(ACol, -1);
                if ARow<>-1 then DoSelectEditor(ACol, AForceFocus);
              end;
          DoUpdated;
        end;
    end;
end;

procedure TCustomECGrid.DoUpdated;
begin
  if HandleAllocated then DoChanges;
  inherited DoUpdated;
end;

function TCustomECGrid.DoUTF8KeyPress(var UTF8Key: TUTF8Char): boolean;
begin
  Result:=inherited DoUTF8KeyPress(UTF8Key);
  if not Result and not EditorMode and not Columns[Col].IsReadOnly then
    begin
      MakeCellFullyVisible(Col, Row, False);
      DoSelectEditor(Col);
      if EditorMode then
        begin
          DrawDataCell(Col, Row);
          InitEditor(UTF8Key);
          UTF8Key:='';
        end;
      Result:=True;
    end;
end;

procedure TCustomECGrid.DragDrop(Source: TObject; X, Y: Integer);
begin
  inherited DragDrop(Source, X, Y);
  if HoveredCol>=0 then
    begin
      Columns[MovableCol].Index:=HoveredCol;
      exclude(Flags, egfMoving);
      InvalidateNonUpdated;
      MovableCol:=HoveredCol;
      ClearSelection;
      if (Editor is TWinControl) and TWinControl(Editor).CanFocus then TWinControl(Editor).SetFocus;
    end;
end;

procedure TCustomECGrid.DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var aHoveredCol, aHoveredRow: Integer;
begin
  inherited DragOver(Source, X, Y, State, Accept);
  MouseToCell(X, Y, aHoveredCol, aHoveredRow);
  HoveredCol:=aHoveredCol;
  Accept:=((aHoveredRow>=0) and (aHoveredCol>=FixedCols) and (aHoveredCol<>MovableCol));
end;

procedure TCustomECGrid.DrawColumnGridLines(APFlags: TPaintFlags; AFixedCol: Boolean);
var i, tl, br, aCorrection: SmallInt;
    aCanvas: TCanvas;
    aRect: TRect;
begin
  if AFixedCol
    then aCanvas:=BMPFixedCols.Canvas
    else aCanvas:=BMPData.Canvas;
  with aCanvas do
    begin
      Pen.Assign(GridLinePen);
      if AFixedCol
        then Pen.Color:=GetColorResolvingEnabled(clBtnText, pfEnabled in APFlags)
        else Pen.Color:=GetColorResolvingDefAndEnabled(GridLineColor, clBtnFace, pfEnabled in APFlags);
      Pen.Width:=GridLineWidth;
      Brush.Style:=bsClear;
      aRect:=ClipRect;
      if AFixedCol or (egoHorizontalLines in Options) then
        begin
          aCorrection:=GridLineWidth and 1;
          for i:=0 to aRect.Height div RowHeight do
            begin
              tl:=aRect.Top+i*RowHeight-aCorrection;
              Line(aRect.Left, tl, aRect.Right, tl);
            end;
        end;
      if AFixedCol or (egoVerticalLines in Options) then
        begin
          tl:=(GridLineWidth div 2)-1;
          br:=(GridLineWidth+1) div 2;
          Pen.Width:=1;
          if pfRightToLeft in APFlags then
            begin
              i:=tl;
              tl:=br-1;
              br:=i+1;
            end;
          for i:=0 to tl do
            Line(aRect.Left+i, aRect.Top, aRect.Left+i, aRect.Bottom);
          for i:=1 to br do
            Line(aRect.Right-i, aRect.Top, aRect.Right-i, aRect.Bottom);
        end;
      if AFixedCol and (GridLineWidth=1) then
        begin
          if (FixedRows=0) and (FirstVisiCell.Y=0) then Line(aRect.Left, 0, aRect.Right, 0);
          if not (pfRightToLeft in APFlags) then
            begin
              if aRect.Left=0 then Line(0, aRect.Top, 0, aRect.Bottom);
            end else
              if aRect.Right=BMPFixedCols.Width then Line(aRect.Right-1, aRect.Top, aRect.Right-1, aRect.Bottom);
        end;
    end;
end;

procedure TCustomECGrid.DrawDataCell(ACol, ARow: Integer);
var aBkgndColors: TBkgndColors;
    aPFlags: TPaintFlags;
begin
  aPFlags:=GetDataPaintFlags(ACol);
  if (pfSelectedCol in aPFlags) and (ARow=Row) then exclude(Flags, egfRedrawFocusedCell);
  aBkgndColors:=GetColumnBkgndColors(ACol, aPFlags);
  Columns[ACol].FontOptions.ApplyTo(BMPData.Canvas.Font, clWindowText);
  DrawDataCellContent(ACol, ARow, aPFlags, aBkgndColors, True);
end;

procedure TCustomECGrid.DrawDataCellContent(ACol, ARow: Integer; APFlags: TPaintFlags;
            const ABkgndColors: TBkgndColors; ADrawGLandFF: Boolean);
var aColor: TColor;
    aDataRow: Integer;
    aHandled: Boolean;
    aHelp: SmallInt;
    aRect: TRect;
    aText: string;
begin
  aDataRow:=ARow-FixedRows;
  aRect:=CellRectBMPData(ACol, aDataRow, APFlags);
  BMPData.Canvas.ClipRect:=aRect;
  if (pfSelectedCol in APFlags) and (ARow=Row) then include(APFlags, pfFocusedCell);
  if (egfMultiSelection in Flags) and (IsInSelection(ACol, ARow)) then include(APFlags, pfSelectedCell);
  if not (pfFocusedCell in APFlags) or (pfEditorMode in APFlags) then
    begin
      if not (pfSelectedCell in APFlags) then
        begin  { not focused nor selected }
          BMPData.Canvas.Brush.Color:=ABkgndColors[(aDataRow mod 2)>0,
            (pfHilightCol in APFlags) or ((pfHilightRow in APFlags) and (ARow=Row))];
        end else
        begin  { not focused, selected }
          BMPData.Canvas.Brush.Color:=BkSelColors[True, Focused, pfEnabled in APFlags];
        end;
    end else
    begin
      if pfSelectedCell in APFlags then
        begin  { focused and selected }
          BMPData.Canvas.Brush.Color:=BkSelColors[FFocusedCell=efcFrame, Focused, pfEnabled in APFlags];
        end else
        begin  { focused, not selected }
          if FFocusedCell=efcFrame
            then BMPData.Canvas.Brush.Color:=ABkgndColors[(aDataRow mod 2)>0,
                   (pfHilightCol in APFlags) or ((pfHilightRow in APFlags) and (ARow=Row))]
            else BMPData.Canvas.Brush.Color:=BkSelColors[False, Focused, pfEnabled in APFlags];
        end;
    end;
  BMPData.Canvas.Brush.Style:=bsSolid;
  BMPData.Canvas.FillRect(aRect);
  aHandled:=False;
  if assigned(OnDrawDataCell) then OnDrawDataCell(self, BMPData.Canvas, ACol, ARow, aHandled);
  if not aHandled and (pfColHasDataEvent in APFlags) then
    begin
      Columns[ACol].OnGetDataCellText(Columns[ACol], aDataRow, aText);
      if aText<>'' then
        begin
          aHelp:=cIndent+ GridLineWidth div 2;
          inc(aRect.Left, aHelp);
          dec(aRect.Right, aHelp);
          if (pfSelectedCell in APFlags) or ((pfFocusedCell in APFlags) and (FocusedCell<>efcFrame))
            then aColor:=clHighlightText
            else aColor:=GetColorResolvingDefault(Columns[ACol].FontOptions.FontColor, clWindowText);
          if not (pfEnabled in APFlags) then aColor:=GetMonochromaticColor(aColor);
          BMPData.Canvas.Font.Color:=aColor;
          ThemeServices.DrawText(BMPData.Canvas, ArBtnDetails[True, False], aText, aRect,
            cBaseFlags or cFlagsAlign[Columns[ACol].Alignment, pfRightToLeft in APFlags], 0);
        end;
    end;
  if ADrawGLandFF then
    if ([pfEditorMode, pfFocusedCell]*APFlags)=[pfFocusedCell] then
      begin
        if (FocusedCell=efcHilighted) or (GridLineWidth>4) then DrawDataCellGridLines(APFlags);  { 4 = 2*FocusFrame width }
        if FocusedCell<>efcHilighted then DrawFocusFrame(BMPData.Canvas.ClipRect, APFlags);
      end else
        if GridLineWidth>0 then DrawDataCellGridLines(APFlags);
end;

procedure TCustomECGrid.DrawDataCellGridLines(APFlags: TPaintFlags);
var i, tl, br: SmallInt;
    aRect: TRect;
begin
  with BMPData.Canvas do
    begin
      aRect:=BMPData.Canvas.ClipRect;
      Pen.Assign(GridLinePen);
      Pen.Color:=GetColorResolvingDefAndEnabled(GridLineColor, clBtnFace, pfEnabled in aPFlags);
      Pen.Width:=1;
      Brush.Style:=bsClear;
      tl:=(GridLineWidth div 2)-1;
      br:=(GridLineWidth+1) div 2;
      if egoHorizontalLines in Options then
        begin
          for i:=0 to tl do
            Line(aRect.Left, aRect.Top+i, aRect.Right, aRect.Top+i);
          for i:=1 to br do
            Line(aRect.Left, aRect.Bottom-i, aRect.Right, aRect.Bottom-i);
        end;
      if egoVerticalLines in Options then
        begin
          if pfRightToLeft in APFlags then
            begin
              i:=tl;
              tl:=br-1;
              br:=i+1;
            end;
          for i:=0 to tl do
            Line(aRect.Left+i, aRect.Top, aRect.Left+i, aRect.Bottom);
          for i:=1 to br do
            Line(aRect.Right-i, aRect.Top, aRect.Right-i, aRect.Bottom);
        end;
    end;
end;

procedure TCustomECGrid.DrawDataColumn(ACol: Integer);
var aBkgndColors: TBkgndColors;
    aPFlags: TPaintFlags;
    j: Integer;
begin
  aPFlags:=GetDataPaintFlags(ACol);
  if pfSelectedCol in aPFlags then exclude(Flags, egfRedrawFocusedCell);
  aBkgndColors:=GetColumnBkgndColors(ACol, aPFlags);
  Columns[ACol].FontOptions.ApplyTo(BMPData.Canvas.Font, clWindowText);
  for j:=FirstVisiCell.Y to Math.min(FirstVisiCell.Y+ BMPData.Height div RowHeight, RowCount)-1 do
    DrawDataCellContent(ACol, j, aPFlags, aBkgndColors, False);
  BMPData.Canvas.Pen.Color:=GetColorResolvingDefAndEnabled(GridLineColor, clBtnFace, pfEnabled in aPFlags);
  with BMPData.Canvas do  { ClipRect remains set from DrawDataCellContent(); }
    ClipRect:=Rect(ClipRect.Left, 0, ClipRect.Right, ClipRect.Bottom);
  if GridLineWidth>0 then DrawColumnGridLines(aPFlags, False);
  if (pfSelectedCol in aPFlags) and not EditorMode and (FocusedCell<>efcHilighted)
    then DrawFocusFrame(CellRectBMPData(ACol, Row-FixedRows, aPFlags), aPFlags);
  exclude(Columns[ACol].Flags, ecfRedrawData);
end;

procedure TCustomECGrid.DrawDataColVertScrolled(ACol, ARowShift: Integer);
var aCanvas: TCanvas;
    aRectA, aRectB: TRect;
    j, aFrom, aTo: Integer;
begin
  aCanvas:=BMPData.Canvas;
  aFrom:=Columns[ACol].Left-ClientAreaLeft-FixedColsWidth;
  aTo:=Columns[ACol].Width;
  if egfRightToLeft in Flags then aFrom:=aCanvas.Width-aFrom-aTo;
  aRectA:=Rect(Math.max(aFrom, 0), 0, Math.min(aFrom+aTo, aCanvas.Width), aCanvas.Height);
  aCanvas.ClipRect:=aRectA;
  aRectB:=aRectA;
  j:=abs(ARowShift*RowHeight);
  dec(aRectA.Bottom, j);
  inc(aRectB.Top, j);
  if ARowShift<0 then
    begin  { up }
      aCanvas.CopyRect(aRectB, aCanvas, aRectA);
      aFrom:=FirstVisiCell.Y;
      aTo:=aFrom-ARowShift-1;
    end else
    begin  { down }
      aCanvas.CopyRect(aRectA, aCanvas, aRectB);
      j:=aCanvas.Height div RowHeight;
      aTo:=Math.min(FirstVisiCell.Y+j, RowCount)-1;
      aFrom:=aTo-ARowShift+1;
      if (FirstVisiCell.PrevY+j)>aFrom then inc(aFrom);
    end;
  for j:=aFrom to aTo do
    DrawDataCell(ACol, j);
end;

procedure TCustomECGrid.DrawFixedCell(ACol, ARow: Integer);
var aPFlags: TPaintFlags;
    aRect: TRect;
begin
  if IsCellVisible(ACol, ARow) then
    begin
      aPFlags:=CommonPaintFlags;
      aRect.Left:=Columns[ACol].Left;
      if pfRightToLeft in aPFlags then aRect.Left:=BMPFixedCols.Width-aRect.Left-Columns[ACol].Width;
      aRect.Right:=aRect.Left+Columns[ACol].Width;
      aRect.Top:=(ARow-FixedRows- ClientAreaTop div RowHeight)*RowHeight;
      aRect.Bottom:=aRect.Top+RowHeight;
      BMPFixedCols.Canvas.ClipRect:=aRect;
      if (ARow=Row) and (egoHilightRowHeader in Options) then include(aPFlags, pfHilightRow);
      DrawFixedCellBkgnd(BMPFixedCols.Canvas, aRect, False, aPFlags);
      if assigned(Columns[ACol].OnGetDataCellText) then DrawFixedCellContent(ACol, ARow, aRect, aPFlags);
      if (Style=egsFlat) and (GridLineWidth>0) then DrawFlatCellGridLines(BMPFixedCols.Canvas, ACol<FixedCols, False, aPFlags);
    end;
end;

procedure TCustomECGrid.DrawFixedCellBkgnd(ACanvas: TCanvas; const ARect: TRect; APushed: Boolean; APFlags: TPaintFlags);
const cBevel: array[egsPanel..egsFinePanelC] of SmallInt = (1, 2, 2, 3, 4);
      cMergeHilightFixed: Single = 0.75;
var aColor: TColor;
begin
  aColor:=clBtnFace;
  if [pfHilightCol, pfHilightRow]*APFlags<>[] then aColor:=GetMergedColor(clBtnFace, clHighlight, cMergeHilightFixed);
  if Style=egsFlat then
    begin
      ACanvas.Brush.Color:=GetColorResolvingEnabled(aColor, pfEnabled in APFlags);
      ACanvas.Brush.Style:=bsSolid;
      ACanvas.FillRect(ARect);
    end else
      if not APushed then
        case Style of
          egsPanel, egsStandard:
            ACanvas.DrawPanelBackground(aRect, bvNone, bvRaised, cBevel[Style], aColor, pfEnabled in APFlags);
          egsFinePanelA, egsFinePanelB, egsFinePanelC: ACanvas.DrawFinePanelBkgnd
            (aRect, bvRaised, cBevel[Style], clDefault, clDefault, aColor, True, pfEnabled in APFlags);
          egsThemed: ThemeServices.DrawElement(ACanvas.Handle, Details, aRect);
        end else
        case Style of
          egsPanel..egsFinePanelC:
            ACanvas.DrawPanelBackground(aRect, bvNone, bvLowered, 0, 1, clDefault, clBtnShadow, aColor);
          egsThemed:
            ThemeServices.DrawElement(ACanvas.Handle, ThemeServices.GetElementDetails(thHeaderItemPressed), aRect);
        end;
end;

procedure TCustomECGrid.DrawFixedCellContent(ACol, ARow: Integer; ARect: TRect; APFlags: TPaintFlags);
var aText: string;
begin
  inc(ARect.Left, FixedCellIndent);
  dec(ARect.Right, FixedCellIndent);
  Columns[ACol].OnGetDataCellText(Columns[ACol], ARow-FixedRows, aText);
  if aText<>'' then
    ThemeServices.DrawText(BMPFixedCols.Canvas, ArBtnDetails[pfEnabled in APFlags, False], aText, ARect,
      cBaseFlags or cFlagsAlign[Columns[ACol].Alignment, pfRightToLeft in APFlags], 0);
end;

procedure TCustomECGrid.DrawFixedColumn(ACol, AFirstRow, ALastRow: Integer);
var aCanvas: TCanvas;
    aColumn: TECGColumn;
    aPFlags: TPaintFlags;
    aRect: TRect;
    j: Integer;
begin
  aColumn:=Columns[ACol];
  aRect.Left:=aColumn.Left;
  if egfRightToLeft in Flags then aRect.Left:=BMPFixedCols.Width-aRect.Left-aColumn.Width;
  aRect.Top:=(AFirstRow-FixedRows)*RowHeight-(ClientAreaTop div RowHeight)*RowHeight;
  aRect.Right:=aRect.Left+aColumn.Width;
  aRect.Bottom:=aRect.Top+(ALastRow-AFirstRow+1)*RowHeight;
  aCanvas:=BMPFixedCols.Canvas;
  aCanvas.ClipRect:=aRect;
  aPFlags:=CommonPaintFlags;
  if assigned(aColumn.OnGetDataCellText) then include(aPFlags, pfColHasDataEvent);
  aCanvas.Font.Assign(Font);
  aColumn.FontOptions.ApplyTo(aCanvas.Font, clBtnText);
  for j:=AFirstRow to ALastRow do
    begin
      aRect.Bottom:=aRect.Top+RowHeight;
      if (j=Row) and (egoHilightRowHeader in Options)
        then include(aPFlags, pfHilightRow)
        else exclude(aPFlags, pfHilightRow);
      DrawFixedCellBkgnd(aCanvas, aRect, False, aPFlags);
      if pfColHasDataEvent in aPFlags then DrawFixedCellContent(ACol, j, aRect, aPFlags);
      aRect.Top:=aRect.Bottom;
    end;
  if (Style=egsFlat) and (GridLineWidth>0) then DrawColumnGridLines(aPFlags, True);
end;

procedure TCustomECGrid.DrawFixedColsVertScrolled(ARowShift: Integer);
var aCanvas: TCanvas;
    aRectA, aRectB: TRect;
    k, aFrom, aTo: Integer;
begin
  aCanvas:=BMPFixedCols.Canvas;
  aRectA:=Rect(0, 0, aCanvas.Width, aCanvas.Height);
  aCanvas.ClipRect:=aRectA;
  aRectB:=aRectA;
  k:=abs(ARowShift*RowHeight);
  dec(aRectA.Bottom, k);
  inc(aRectB.Top, k);
  if ARowShift<0 then
    begin  { up }
      aCanvas.CopyRect(aRectB, aCanvas, aRectA);
      aFrom:=FirstVisiCell.Y;
      aTo:=aFrom-ARowShift-1;
    end else
    begin  { down }
      aCanvas.CopyRect(aRectA, aCanvas, aRectB);
      k:=aCanvas.Height div RowHeight;
      aTo:=Math.min(FirstVisiCell.Y+k, RowCount)-1;
      aFrom:=aTo-ARowShift+1;
      if (FirstVisiCell.PrevY+k)>aFrom then inc(aFrom);
    end;
  for k:=0 to FixedVisiCols-1 do
    DrawFixedColumn(VisiCols[k], aFrom, aTo);
end;

procedure TCustomECGrid.DrawFlatCellGridLines(ACanvas: TCanvas; AFixedCol, AHeader: Boolean; APFlags: TPaintFlags);
var i, tl, br, aCorrection, aRowHeight: Integer;
    aRect: TRect;
begin
  with ACanvas do
    begin
      if AHeader
        then aRowHeight:=FixedRowHeight
        else aRowHeight:=RowHeight;
      Pen.Assign(GridLinePen);
      Pen.Color:=GetColorResolvingEnabled(clBtnText, pfEnabled in APFlags);
      Pen.Width:=GridLineWidth;
      Brush.Style:=bsClear;
      aRect:=ClipRect;
      aCorrection:=(GridLineWidth and 1);
      for i:=0 to aRect.Height div aRowHeight do
        begin
          tl:=aRect.Top+i*aRowHeight-aCorrection;
          Line(aRect.Left, tl, aRect.Right, tl);
        end;
      tl:=(GridLineWidth div 2)-1;
      br:=(GridLineWidth+1) div 2;
      Pen.Width:=1;
      if pfRightToLeft in APFlags then
        begin
          i:=tl;
          tl:=br-1;
          br:=i+1;
        end;
      for i:=0 to tl do
        Line(aRect.Left+i, aRect.Top, aRect.Left+i, aRect.Bottom);
      for i:=1 to br do
        Line(aRect.Right-i, aRect.Top, aRect.Right-i, aRect.Bottom);
      if GridLineWidth=1 then
        begin
          if AHeader or ((FixedRows=0) and (ClientAreaTop=0)) then Line(aRect.Left, 0, aRect.Right, 0);
          if AFixedCol or (FirstVisiCell.X=0) then
            if not (pfRightToLeft in APFlags) then
              begin
                if aRect.Left=0 then Line(0, aRect.Top, 0, aRect.Bottom);
              end else
                if aRect.Right=ACanvas.Width then Line(aRect.Right-1, aRect.Top, aRect.Right-1, aRect.Bottom);
        end;
    end;
end;

procedure TCustomECGrid.DrawFocusFrame(ARect: TRect; APFlags: TPaintFlags);
begin
  BMPData.Canvas.Pen.Assign(FocusFramePen);
  BMPData.Canvas.Pen.Color:=GetColorResolvingEnabled(clWindowText, pfEnabled in APFlags);
  InflateRect(ARect, 0, -1);
  BMPData.Canvas.Line(aRect.Left, aRect.Top, aRect.Right, aRect.Top);
  BMPData.Canvas.Line(ARect.Left+1, ARect.Top, aRect.Left+1, aRect.Bottom);
  BMPData.Canvas.Line(aRect.Left, aRect.Bottom, ARect.Right, ARect.Bottom);
  BMPData.Canvas.Line(ARect.Right-1, aRect.Top, aRect.Right-1, aRect.Bottom);
end;

procedure TCustomECGrid.DrawGridHorScrolled(ACliAreaLeftShift: Integer);
var aRectA, aRectB: TRect;
    i, k: Integer;
begin
  BMPData.Canvas.ClipRect:=Rect(0, 0, BMPData.Width, BMPData.Height);
  BMPFixedRows.Canvas.ClipRect:=Rect(0, 0, BMPFixedRows.Width, BMPFixedRows.Height);
  i:=abs(ACliAreaLeftShift);
  k:=ord(egfRightToLeft in Flags);
  aRectA:=Rect(k*i, 0, BMPData.Width-(k xor 1)*i, BMPData.Height);
  aRectB:=Rect((k xor 1)*i, 0, BMPData.Width-k*i, aRectA.Bottom);
  if ACliAreaLeftShift<0
    then i:=Columns[VisiCols[FirstVisiCell.PrevX]].Left+ACliAreaLeftShift-FixedColsWidth
    else i:=Columns[VisiCols[LastVisiCell.PrevX]].Right+ACliAreaLeftShift-ClientWidth;
  k:=ord(i=ClientAreaLeft);
  if (FirstVisiCell.Y<=LastVisiCell.Y) and not (egfRedrawData in Flags) then
    if ACliAreaLeftShift<0 then
      begin
        BMPData.Canvas.CopyRect(aRectB, BMPData.Canvas, aRectA);
        for i:=FirstVisiCell.X to FirstVisiCell.PrevX-k do
          include(Columns[VisiCols[i]].Flags, ecfRedrawData);
      end else
      begin
        BMPData.Canvas.CopyRect(aRectA, BMPData.Canvas, aRectB);
        for i:=LastVisiCell.PrevX+k to LastVisiCell.X do
          include(Columns[VisiCols[i]].Flags, ecfRedrawData);
      end;
  if (FixedRows>0) and not (egfRedrawFixedRows in Flags) then
    begin
      aRectA.Bottom:=FixedRowsHeight;
      aRectB.Bottom:=aRectA.Bottom;
      if ACliAreaLeftShift<0 then
        begin
          BMPFixedRows.Canvas.CopyRect(aRectB, BMPFixedRows.Canvas, aRectA);
          for i:=FirstVisiCell.X to FirstVisiCell.PrevX-k do
            for k:=0 to FixedRows-1 do
              DrawHeaderCell(VisiCols[i], k);
        end else
        begin
          BMPFixedRows.Canvas.CopyRect(aRectA, BMPFixedRows.Canvas, aRectB);
          for i:=LastVisiCell.PrevX+k to LastVisiCell.X do
            for k:=0 to FixedRows-1 do
              DrawHeaderCell(VisiCols[i], k);
        end;
    end;
end;

procedure TCustomECGrid.DrawHeaderCell(ACol, ARow: Integer);
var aCanvas: TCanvas;
    aPFlags: TPaintFlags;
    aRect: TRect;
begin
  if IsColVisible(ACol) then
    begin
      aPFlags:=CommonPaintFlags;
      if (ACol=Col) and (egoHilightColHeader in Options) then include(aPFlags, pfHilightCol);
      aRect.Left:=Columns[ACol].Left;
      if ACol<FixedCols then
        begin
          aCanvas:=BMPHead.Canvas;
          if pfRightToLeft in aPFlags then aRect.Left:=BMPHead.Width-aRect.Left-Columns[ACol].Width;
        end else
        begin
          aCanvas:=BMPFixedRows.Canvas;
          dec(aRect.Left, ClientAreaLeft+FixedColsWidth);
          if pfRightToLeft in aPFlags then aRect.Left:=BMPFixedRows.Width-aRect.Left-Columns[ACol].Width;
        end;
      aRect.Right:=aRect.Left+Columns[ACol].Width;
      aRect.Top:=ARow*FixedRowHeight;
      aRect.Bottom:=aRect.Top+FixedRowHeight;
      aCanvas.ClipRect:=aRect;
      DrawFixedCellBkgnd(aCanvas, aRect, (PushedCol=ACol) and (PushedRow=ARow)
        and (egoHeaderPushedLook in Options), aPFlags);
      inc(aRect.Left, FixedCellIndent);
      dec(aRect.Right, FixedCellIndent);
      DrawHeaderCellContent(aCanvas, ACol, ARow, aRect, aPFlags);
      if (Style=egsFlat) and (GridLineWidth>0) then DrawFlatCellGridLines(aCanvas, ACol<FixedCols, True, aPFlags);
    end;
end;

procedure TCustomECGrid.DrawHeaderCellContent(ACanvas: TCanvas; ACol, ARow: Integer; ARect: TRect; APFlags: TPaintFlags);
const cGlyphIndent: SmallInt = 12;
      cSortArrows: array[Boolean] of TGlyphDesign = (egdSizeArrUp, egdSizeArrDown);
var aFlags: Cardinal;
    aText: string;
    y: Integer;
begin
  if ARow=0 then
    begin  { draw title images and assign text }
      aText:=Columns[ACol].Title.Text;
      if assigned(Images) and (Columns[ACol].Title.ImageIndex>=0) then
        begin
          y:=(ARect.Top+ARect.Bottom-Images.Height) div 2;
          if not (pfRightToLeft in APFlags) then
            begin
              ThemeServices.DrawIcon(ACanvas, ArBtnDetails[pfEnabled in APFlags, False], Point(ARect.Left, y),
                                     Images, Columns[ACol].Title.ImageIndex);
              inc(ARect.Left, Images.Width+cIndent);
            end else
            begin
              dec(ARect.Right, Images.Width);
              ThemeServices.DrawIcon(ACanvas, ArBtnDetails[pfEnabled in APFlags, False], Point(ARect.Right, y),
                                     Images, Columns[ACol].Title.ImageIndex);
              dec(ARect.Right, cIndent);
            end;
        end;
    end else
    begin
      aText:='';
      if assigned(OnGetHeaderText) then OnGetHeaderText(self, ACol, ARow, aText);
    end;
  if aText<>'' then
    begin  { draw text }
      aFlags:=cBaseFlags or cFlagsAlign[Columns[ACol].Title.Alignment, pfRightToLeft in APFlags];
      ACanvas.Font.Assign(Font);
      Columns[ACol].Title.FontOptions.ApplyTo(ACanvas.Font, clBtnText);
      ThemeServices.DrawText(ACanvas, ArBtnDetails[pfEnabled in APFlags, False], aText, ARect, aFlags, 0);
    end;
  if (ARow=0) and (ACol=SortIndex) and (egoSortArrow in Options) and (ecoSorting in Columns[ACol].Options) then
    begin  { draw sort arrow }
      if not (pfRightToLeft in APFlags)
        then ARect.Left:=ARect.Right-cGlyphIndent
        else ARect.Right:=ARect.Left+cGlyphIndent;
      ACanvas.DrawGlyph(ARect, clBtnText, cSortArrows[SortAscendent], caItemState[pfEnabled in APFlags]);
    end;
end;

procedure TCustomECGrid.EndUpdate;
begin
  inherited EndUpdate;
  ControlStyle:=ControlStyle-[csNoStdEvents];
end;

function TCustomECGrid.GetColumnBkgndColors(ACol: Integer; APFlags: TPaintFlags): TBkgndColors;
var bColor, bHighlighted: Boolean;
begin
  if Columns[ACol].Color=clDefault then
    begin
      for bColor:=False to True do
        Result[bColor, False]:=BkgndColors[bColor, False, pfEnabled in APFlags];
      if (pfHilightCol in APFlags) or (pfHilightRow in APFlags) then
        for bColor:=False to True do
          Result[bColor, True]:=BkgndColors[bColor, True, pfEnabled in APFlags];
    end else
    begin
      Result[False, False]:=GetMergedColor(Columns[ACol].Color, BkgndColors[False, False, pfEnabled in APFlags],
                              0.01*Columns[ACol].ColorTint);
      Result[True, False]:=GetMergedColor(GetColorResolvingDefault(AlternateColor, Color), Result[False, False],
                             0.01*AlternateTint);
      if (pfHilightCol in APFlags) or (egoHilightRow in Options) then
        for bColor:=False to True do
          Result[bColor, True]:=GetMergedColor(Result[bColor, False], clHighlight, cMergeHilight);
      if not (pfEnabled in APFlags) then
        for bColor:=False to True do
          for bHighlighted:=False to True do
            Result[bColor, bHighlighted]:=GetMonochromaticColor(Result[bColor, bHighlighted]);
    end;
end;

class function TCustomECGrid.GetControlClassDefaultSize: TSize;
begin
  Result:=Size(320, 160);
end;

function TCustomECGrid.GetDataPaintFlags(ACol: Integer): TPaintFlags;
begin
  Result:=CommonPaintFlags;
  if EditorMode and Editor.Visible then include(Result, pfEditorMode);
  if egoHilightRow in Options then include(Result, pfHilightRow);
  if assigned(Columns[ACol].OnGetDataCellText) then include(Result, pfColHasDataEvent);
  if ACol=Col then
    begin
      include(Result, pfSelectedCol);
      if egoHilightCol in Options then include(Result, pfHilightCol);
    end;
end;

function TCustomECGrid.GetIncrementX: Integer;
begin
  Result:=ScrollIncX;
end;

function TCustomECGrid.GetIncrementY: Integer;
begin
  Result:=RowHeight;
end;

function TCustomECGrid.GetNextVisiCol(ACol: Integer): Integer;
var i: Integer;
begin
  Result:=ACol;
  for i:=ACol+1 to Columns.Count-1 do
    if ecoVisible in Columns[i].Options then
      begin
        Result:=i;
        break;
      end;
end;

function TCustomECGrid.GetPageSizeX: Integer;
begin
  Result:=ClientWidth-FixedColsWidth;
end;

function TCustomECGrid.GetPageSizeY: Integer;
begin
  Result:=DataAreaRows*RowHeight;
end;

function TCustomECGrid.GetPreviousVisiCol(ACol: Integer): Integer;
var i: Integer;
begin
  Result:=ACol;
  for i:=ACol-1 downto FixedCols do
    if ecoVisible in Columns[i].Options then
      begin
        Result:=i;
        break;
      end;
end;

function TCustomECGrid.GetVisiColIndex(ACol: Integer): Integer;
var i, aCnt, aMax, aMin: Integer;
begin
  Result:=-1;
  aMin:=0;
  aMax:=high(VisiCols);
  aCnt:=2;
  if aMax>0 then inc(aCnt, round(log2(aMax)));
  while aCnt>0 do
    begin
      i:=(aMax+aMin) div 2;
      if VisiCols[i]<=ACol then
        begin
          aMin:=i;
          if VisiCols[i]=ACol then
            begin
              Result:=i;
              break;
            end;
          if (aMax-aMin)=1 then inc(aMin);
        end else
          aMax:=i;
      dec(aCnt);
    end;
end;

procedure TCustomECGrid.GoToRowRelative(ARows: Integer; AShift: TShiftState; AForceFocus: Boolean; AResetSelection: Boolean);
var aRow, aShowRow: Integer;
    bDoSelection: Boolean;
begin
  if not (ssModifier in AShift) then
    begin
      aRow:=Row;
      if ((ARows>0) and (aRow<(RowCount-1))) or ((ARows<0) and (aRow>FixedRows)) then
        begin
          inc(aRow, ARows);
          if ARows>0
            then aRow:=Math.min(aRow, RowCount-1)
            else aRow:=Math.max(aRow, FixedRows);
          aShowRow:=aRow;
          if (ssShift in AShift) and not (egfRangeSelects in Flags) then
            begin
              bDoSelection:=False;
              case MultiSelect of
                emsSingleCol:
                  begin
                    if not IsInSelection(Col, aRow) then
                      begin
                        JoinToSelection(Col, FixedRows, Col, RowCount-1);
                        UpdateColumnData(Col);
                      end;
                    DoSelection(Col, aRow);
                  end;
                emsSingleColRange:
                  begin
                    if SelectionHigh=0 then
                      begin
                        aShowRow:=Math.min(Math.max(FixedRows, Selection[0].ToCell.Y+ARows), RowCount-1);
                        Selection[0].ToCell.Y:=aShowRow;
                        Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
                      end else
                        JoinToSelection(Col, Row, Col, aRow);
                    UpdateColumnData(Col);
                  end;
                emsSingleRow:
                  begin
                    if SelectionHigh=0 then
                      begin
                        ChangeHighSelection(FixedCols, aRow, Columns.Count-1, aRow);
                        UpdateRow(Row);
                      end else
                        JoinToSelection(FixedCols, aRow, Columns.Count-1, aRow);
                    UpdateRow(aRow);
                    DoSelection(Col, aRow);
                  end;
                emsSingleRowRange:
                  begin
                    if SelectionHigh=0 then
                      begin
                        ChangeHighSelection(Selection[0].FromCell.X, aRow, Selection[0].ToCell.X, aRow);
                        UpdateRow(Row);
                        UpdateRow(aRow);
                      end;
                    DoSelection(Col, aRow);
                  end;
                emsSingleRange:
                  begin
                    if SelectionHigh=0 then
                      begin
                        aShowRow:=Math.min(Math.max(FixedRows, Selection[0].ToCell.Y+ARows), RowCount-1);
                        Selection[0].ToCell.Y:=aShowRow;
                        Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
                      end else
                        JoinToSelection(Col, Row, Col, aRow);
                    Redraw([egfRedrawData]);
                  end;
                emsMultiCol:
                    begin
                      if not IsInSelection(Col, aRow) then
                        begin
                          JoinToSelection(Col, FixedRows, Col, RowCount-1, False, True, False);
                          UpdateColumnData(Col);
                        end;
                      DoSelection(Col, aRow);
                    end;
                emsMultiRow:
                  begin
                    if SelectionHigh>=0 then
                      begin
                        aShowRow:=Math.min(Math.max(FixedRows, Selection[SelectionHigh].ToCell.Y+ARows), RowCount-1);
                        ChangeHighSelection(FixedCols, Selection[SelectionHigh].FromCell.Y, Columns.Count-1, aShowRow);
                      end else
                        JoinToSelection(FixedCols, Row, Columns.Count-1, aRow);
                    Redraw([egfRedrawData]);
                  end;
                emsMultiRange:
                  begin
                    if SelectionHigh>=0 then
                      begin
                        aShowRow:=Math.min(Math.max(FixedRows, Selection[SelectionHigh].ToCell.Y+ARows), RowCount-1);
                        Selection[SelectionHigh].ToCell.Y:=aShowRow;
                        Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
                      end else
                        JoinToSelection(Col, Row, Col, aRow, False, True, False);
                    Redraw([egfRedrawData]);
                  end;
              end;  {case}
            end else
            bDoSelection:=True;
          if not IsRowFullyVisible(aShowRow) then
            begin
              if aShowRow>=LastVisiCell.Y
                then ClientAreaTop:=(aShowRow-FixedRows-DataAreaRows+1)*RowHeight
                else ClientAreaTop:=(aShowRow-FixedRows)*RowHeight;
              Redraw([egfCalcBoundRows]);
            end;
          if bDoSelection then DoSelection(Col, aRow, esmNative, AForceFocus, AResetSelection);
        end;
    end else
    begin  { CTRL down }
      include(Flags, egfCalcBoundRows);
      if EditorMode then PrepareEditorDeltaRect(False, True);
      ClientAreaTop:=ClientAreaTop+ARows*RowHeight;
    end;
end;

procedure TCustomECGrid.GoToVisiColAbsolute(ACol: Integer; AShift: TShiftState);
var aShowCol: Integer;
    bDoSelection: Boolean;
begin
  if ACol<>Col then
    begin
      aShowCol:=ACol;
      if (ssShift in AShift) and not (egfRangeSelects in Flags) then
        begin
          bDoSelection:=False;
          case MultiSelect of
            emsSingleCol:
              begin
                if SelectionHigh=0 then
                  begin
                    ChangeHighSelection(ACol, FixedRows, ACol, RowCount-1);
                    UpdateColumnData(Col);
                  end else
                    JoinToSelection(ACol, FixedRows, ACol, RowCount-1);
                UpdateColumnData(ACol);
                DoSelection(ACol, Row);
              end;
            emsSingleColRange:
              begin
                if SelectionHigh=0 then
                  begin
                    ChangeHighSelection(ACol, Selection[0].FromCell.Y, ACol, Selection[0].ToCell.Y);
                    UpdateColumnData(Col);
                    UpdateColumnData(ACol);
                  end;
                DoSelection(ACol, Row);
              end;
            emsSingleRow:
              begin
                if not IsInSelection(ACol, Row) then
                  begin
                    JoinToSelection(FixedCols, Row, Columns.Count-1, Row);
                    UpdateRow(Row);
                  end;
                DoSelection(ACol, Row);
              end;
            emsSingleRowRange:
              begin
                if SelectionHigh=0 then
                  begin
                    aShowCol:=Math.min(Math.max(FixedCols, Selection[0].ToCell.X+(ACol-Col)), Columns.Count-1);
                    Selection[0].ToCell.X:=aShowCol;
                    Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
                  end else
                    JoinToSelection(Col, Row, ACol, Row);
                UpdateRow(Row);
              end;
            emsSingleRange:
              begin
                if SelectionHigh=0 then
                  begin
                    aShowCol:=Math.min(Math.max(FixedCols, Selection[0].ToCell.X+(ACol-Col)), Columns.Count-1);
                    Selection[0].ToCell.X:=aShowCol;
                    Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
                  end else
                    JoinToSelection(Col, Row, ACol, Row);
                Redraw([egfRedrawData]);
              end;
            emsMultiCol:
              begin
                if SelectionHigh>=0 then
                  begin
                    aShowCol:=Math.min(Math.max(FixedCols, Selection[SelectionHigh].ToCell.X+(ACol-Col)), Columns.Count-1);
                    ChangeHighSelection(Selection[SelectionHigh].FromCell.X, FixedRows, aShowCol, RowCount-1);
                  end else
                    JoinToSelection(Col, FixedRows, ACol, RowCount-1, False, True, False);
                Redraw([egfRedrawData]);
              end;
            emsMultiRow:
              begin
                if not IsInSelection(ACol, Row) then
                  begin
                    JoinToSelection(FixedCols, Row, Columns.Count-1, Row);
                    UpdateRow(Row);
                  end;
                DoSelection(ACol, Row);
              end;
            emsMultiRange:
              begin
                if SelectionHigh>=0 then
                  begin
                    aShowCol:=Math.min(Math.max(FixedCols, Selection[SelectionHigh].ToCell.X+(ACol-Col)), Columns.Count-1);
                    Selection[SelectionHigh].ToCell.X:=aShowCol;
                    Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
                  end else
                    JoinToSelection(Col, Row, ACol, Row, False, True, False);
                Redraw([egfRedrawData]);
              end;
          end;  {case}
        end else
          bDoSelection:=True;
      if not IsColFullyVisible(aShowCol) then
        begin
          if aShowCol>=VisiCols[LastVisiCell.X]  { if GetVisiColIndex(aShowCol)>=LastVisiCell.X }
            then ClientAreaLeft:=Columns[aShowCol].Right-ClientWidth
            else ClientAreaLeft:=Columns[aShowCol].Left-FixedColsWidth;
          Redraw([egfCalcBoundCols, egfUpdateRAWidth]);
        end;
      if bDoSelection then DoSelection(ACol, Row, esmNative, True, True);
    end;
end;

procedure TCustomECGrid.GoToVisiColRelative(AColumns: Integer; AShift: TShiftState);
var aVisiCol: Integer;
begin
  if not (ssModifier in AShift) then
    begin
      aVisiCol:=GetVisiColIndex(Col)+AColumns;
      if AColumns>0
        then aVisiCol:=Math.min(high(VisiCols), aVisiCol)
        else aVisiCol:=Math.max(FixedVisiCols, aVisiCol);
      GoToVisiColAbsolute(VisiCols[aVisiCol], AShift);
    end else
    begin
      Flags:=Flags+[egfCalcBoundCols, egfCalcColsLeft, egfUpdateRAWidth];
      if EditorMode then PrepareEditorDeltaRect(True, False);
      if AColumns>0
        then ClientAreaLeft:=ClientAreaLeft+AColumns*Columns[FirstVisiCell.X].Width   { to the right }
        else ClientAreaLeft:=ClientAreaLeft+AColumns*Columns[LastVisiCell.X].Width;   { to the left }
    end;
end;

procedure TCustomECGrid.InitEditor(AUTF8Char: TUTF8Char);
begin
  if Editor is TCustomEdit then
    begin
      if not TCustomEdit(Editor).ReadOnly then TCustomEdit(Editor).Text:=AUTF8Char;
    end else
      if Editor is TCustomComboBox then
        if TCustomComboBox(Editor).Style in [csDropDown, csSimple, csOwnerDrawEditableFixed, csOwnerDrawEditableVariable]
          then TCustomComboBox(Editor).Text:=AUTF8Char;
end;

procedure TCustomECGrid.InitializeWnd;
const cFormDesignerRowCount = 4;
begin
  inherited InitializeWnd;
  if csDesigning in ComponentState
    then FRowCountHelp:=cFormDesignerRowCount
    else FRowCountHelp:=0;
  PrevClientSize:=Size(ClientWidth, ClientHeight);
  Columns.EndUpdate;
  DoChanges;
end;

function TCustomECGrid.IsCellFullyVisible(ACol, ARow: Integer): Boolean;
begin
  Result:=(IsRowFullyVisible(ARow) and IsColFullyVisible(ACol));
end;

function TCustomECGrid.IsCellVisible(ACol, ARow: Integer): Boolean;
begin
  Result:=(IsRowVisible(ARow) and IsColVisible(ACol));
end;

function TCustomECGrid.IsColFullyVisible(ACol: Integer): Boolean;
begin
  Result:=(ACol>=0) and (ACol<Columns.Count) and (ecoVisible in Columns[ACol].Options);
  if Result then
    begin
      Result:=(Columns[ACol].Right<=(ClientAreaLeft+ClientWidth));
      if Result and (ACol>=FixedCols) then Result:=((Columns[ACol].Left-FixedColsWidth)>=ClientAreaLeft);
    end;
end;

function TCustomECGrid.IsColSelected(ACol: Integer): Boolean;
var i, aMax: Integer;
begin
  Result:=False;
  aMax:=SelectionHigh;
  if egfHiSelectionInitial in Flags then dec(aMax);
  for i:=0 to aMax do
    if Selection[i].Positive and IsInRange(ACol, Selection[i].FromCell.X, Selection[i].ToCell.X)
      and (abs(Selection[i].ToCell.Y-Selection[i].FromCell.Y)=(RowCount-1-FixedRows)) then
      begin
        Result:=True;
        break;
      end;
end;

function TCustomECGrid.IsColVisible(ACol: Integer): Boolean;
begin
  if ACol>=FixedCols
    then Result:=(length(VisiCols)>FixedCols) and (ACol>=VisiCols[FirstVisiCell.X]) and (ACol<=VisiCols[LastVisiCell.X])
    else Result:=(ACol>=0) and (ACol<Columns.Count) and (Columns[ACol].Left<ClientWidth);
  Result:=Result and (ecoVisible in Columns[ACol].Options);
end;

function TCustomECGrid.IsInSelection(ACol, ARow: Integer): Boolean;
var i, aMax: Integer;
begin
  Result:=False;
  aMax:=SelectionHigh;
  if egfHiSelectionInitial in Flags then dec(aMax);
  for i:=aMax downto 0 do
    with Selection[i] do
      if IsInRange(ACol, FromCell.X, ToCell.X) and IsInRange(ARow, FromCell.Y, ToCell.Y) then
        begin
          Result:=Positive;
          break;
        end;
end;

function TCustomECGrid.IsRowFullyVisible(ARow: Integer): Boolean;
var y: Integer;
begin
  if ARow<FixedRows
    then Result:=(ARow>=0) and (((ARow+1)*FixedRowHeight)<=ClientHeight)
    else
    begin
      y:=FirstVisiCell.Y;
      if not (egfFirstRowFullyVisi in Flags) then inc(y);
      Result:=(ARow>=y);
      if Result then
        begin
          y:=LastVisiCell.Y;
          if not (egfLastRowFullyVisi in Flags) then dec(y);
          Result:=(ARow<=y);
        end;
    end;
end;

function TCustomECGrid.IsRowSelected(ARow: Integer): Boolean;
var i, aMax: Integer;
begin
  Result:=False;
  aMax:=SelectionHigh;
  if egfHiSelectionInitial in Flags then dec(aMax);
  for i:=0 to aMax do
    if Selection[i].Positive and IsInRange(ARow, Selection[i].FromCell.Y, Selection[i].ToCell.Y)
      and (abs(Selection[i].ToCell.X-Selection[i].FromCell.X)=(Columns.Count-1-FixedCols)) then
      begin
        Result:=True;
        break;
      end;
end;

function TCustomECGrid.IsRowVisible(ARow: Integer): Boolean;
begin
  if ARow<FixedRows
    then Result:=(ARow>=0) and ((ARow*FixedRowHeight)<ClientHeight)
    else Result:=(ARow>=FirstVisiCell.Y) and (ARow<=LastVisiCell.Y);
end;

function TCustomECGrid.IsSelected(ACol, ARow: Integer): Boolean;
begin
  Result:=(IsInSelection(ACol, ARow) or ((ACol=Col) and (ARow=Row)));
end;

procedure TCustomECGrid.JoinToSelection(AFromCol, AFromRow, AToCol, AToRow: Integer;
            AReset: Boolean; APositive: Boolean; AInitial: Boolean);
var aIndex: Integer;
begin
  if AReset then
    begin
      if egfMultiSelection in Flags then
        begin
          case MultiSelect of
            emsSingleCol, emsSingleColRange:
              include(Columns[Selection[0].FromCell.X].Flags, ecfRedrawData);
            emsSingleRow, emsSingleRowRange:
              begin
                Selection[0].Positive:=False;
                UpdateRow(Selection[0].FromCell.Y);
              end;
            otherwise
              include(Flags, egfRedrawData);
          end;
          exclude(Flags, egfMultiSelection);
        end;
      aIndex:=0;
    end else
    begin
      aIndex:=SelectionHigh+1;
      if egfHiSelectionInitial in Flags then dec(aIndex);
    end;
  ManageSelectionLength(aIndex+1);
  with Selection[aIndex] do
    begin
      FromCell.X:=AFromCol;
      FromCell.Y:=AFromRow;
      ToCell.X:=AToCol;
      ToCell.Y:=AToRow;
      Positive:=APositive;
    end;
  if AInitial
    then include(Flags, egfHiSelectionInitial)
    else Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
end;

procedure TCustomECGrid.KeyDown(var Key: Word; Shift: TShiftState);
const cLeftRight: array[Boolean] of SmallInt = (-1, 1);

  procedure SelectEditor(AReset: Boolean = False);
  begin
    if not EditorMode and not Columns[Col].IsReadOnly and ((Shift*[ssModifier, ssAlt{$ifdef Darwin} {$else}, ssMeta {$endif}])=[]) then
      begin
        MakeCellFullyVisible(Col, Row, False);
        DoSelectEditor(Col, True, Key);
        if EditorMode then
          begin
            DrawDataCell(Col, Row);
            if AReset then InitEditor('');
          end;
      end;
  end;

begin
  inherited KeyDown(Key, Shift);
  if ((length(VisiCols)-FixedVisiCols)>0) and ((RowCount-FixedRows)>0) then
    begin
      case Key of
        VK_BACK:    SelectEditor(True);
        VK_TAB:     if egoTabs in Options then
                      begin
                        if not (ssShift in Shift) then
                          begin
                            if Col<VisiCols[high(VisiCols)]
                              then GoToVisiColRelative(1, Shift)
                              else if Row<(RowCount-1) then
                                     begin
                                       Col:=VisiCols[FixedVisiCols];
                                       GoToRowRelative(1, Shift);
                                     end;
                          end else
                          begin
                            if Col>VisiCols[FixedVisiCols]
                              then GoToVisiColRelative(-1, Shift)
                              else if Row>FixedRows then
                                     begin
                                       Col:=VisiCols[high(VisiCols)];
                                       GoToRowRelative(-1, Shift);
                                     end;
                          end;
                        Key:=0;
                      end;
        VK_RETURN:  SelectEditor;
        VK_ESCAPE:  begin
                      if EditorMode and not (egoAlwaysShowEditor in Options) then EditorMode:=False;
                      Key:=0;
                    end;
        VK_SPACE:   SelectEditor;
        VK_PRIOR:   GoToRowRelative(-DataAreaRows+1, Shift);
        VK_NEXT:    GoToRowRelative(DataAreaRows-1, Shift);
        VK_END:     if not (ssModifier in Shift)
                      then GoToVisiColAbsolute(VisiCols[high(VisiCols)], Shift)
                      else GoToRowRelative(RowCount-Row-1, Shift-[ssModifier]);
        VK_HOME:    if not (ssModifier in Shift)
                      then GoToVisiColAbsolute(VisiCols[FixedVisiCols], Shift)
                      else GoToRowRelative(-Row+FixedRows, Shift-[ssModifier]);
        VK_LEFT:    GoToVisiColRelative(cLeftRight[egfRightToLeft in Flags], Shift);
        VK_UP:      GoToRowRelative(-1, Shift);
        VK_RIGHT:   GoToVisiColRelative(cLeftRight[not (egfRightToLeft in Flags)], Shift);
        VK_DOWN:    GoToRowRelative(1, Shift);
        VK_INSERT:  SelectEditor;
        VK_DELETE:  SelectEditor(True);
        VK_C:       if ([ssShift, ssAlt, ssModifier]*Shift)=[ssModifier] then
                      begin
                        CopyToClipboard;
                        Key:=0;
                      end else
                      SelectEditor;
        VK_F2:      SelectEditor;
      end;  {case}
      if Key in [VK_PRIOR..VK_DOWN] then Key:=0;
    end;
end;

procedure TCustomECGrid.LoadColumnsFromXML(AFileName: string; AColumnsNode: DOMString; AXMLFlags: TXMLColFlags);
var aNode: TDOMNode;
    aXMLDoc: TXMLDocument;
begin
  aXMLDoc:=nil;
  if FileExistsUTF8(AFileName) then
    ReadXMLFile(aXMLDoc, AFileName, [xrfAllowSpecialCharsInAttributeValue]);
  if assigned(aXMLDoc) then
    try
      if assigned(aXMLDoc.DocumentElement) then
        begin
          if AColumnsNode='' then AColumnsNode:=Name+'_'+cColumn+'s';
          aNode:=aXMLDoc.DocumentElement.FindNode(AColumnsNode);
          if assigned(aNode) then LoadColumnsFromXML(aNode, AXMLFlags);
        end;
    finally
      aXMLDoc.Free;
    end;
end;

procedure TCustomECGrid.LoadColumnsFromXML(AColumnsNode: TDOMNode; AXMLFlags: TXMLColFlags);
var i, j, aCount, aOrder: Integer;
    aNode: TDOMNode;
begin
  BeginUpdate;
  try
    aCount:=Math.min(strToInt(TDOMElement(AColumnsNode).GetAttribute(cCount)), Columns.Count);
    if (egoUseOrder in Options) and (excfOrder in AXMLFlags) then
      begin
        aNode:=AColumnsNode.FirstChild;
        for i:=0 to aCount-1 do
          begin
            aOrder:=strToInt(TDOMElement(aNode).GetAttribute(cOrder));
            if Columns[i].Order<>aOrder then
              for j:=i+1 to aCount-1 do
                if Columns[j].Order=aOrder then
                  begin
                    Columns[j].Index:=i;
                    break;
                  end;
            aNode:=aNode.NextSibling;
          end;
      end;
    if excfVisible in AXMLFlags then
      begin
        aNode:=AColumnsNode.FirstChild;
        for i:=0 to aCount-1 do
          begin
            if not strToBool(TDOMElement(aNode).GetAttribute(cVisible))
              then Columns[i].Options:=Columns[i].Options-[ecoVisible]
              else Columns[i].Options:=Columns[i].Options+[ecoVisible];
             aNode:=aNode.NextSibling;
          end;
      end;
    if excfWidth in AXMLFlags then
      begin
        aNode:=AColumnsNode.FirstChild;
        for i:=0 to aCount-1 do
          begin
            Columns[i].Width:=strToInt(TDOMElement(aNode).GetAttribute(cWidth));
            aNode:=aNode.NextSibling;
          end;
      end;
  finally
    EndUpdate;
  end;
end;

function TCustomECGrid.MakeCellFullyVisible(ACol, ARow: Integer; AForce: Boolean): Boolean;
var aRequestedCol: Integer;
    bInvalidate, bScrolled: Boolean;
begin
  bInvalidate:=False;
  Result:=(Columns.Count>0);
  if Result then
    begin
      aRequestedCol:=aCol;
      ACol:=Math.EnsureRange(ACol, FixedCols, Columns.Count-1);
      AForce:=(AForce and (ACol=aRequestedCol));
      if AForce then
        begin
          Columns[ACol].Options:=Columns[ACol].Options+[ecoVisible];
          DoChanges;
          bInvalidate:=True;
          Result:=True;
        end else
        begin
          Result:=(ecoVisible in Columns[ACol].Options);
          bInvalidate:=False;
        end;
    end;
  if Result then
    begin
      if ARow>=FixedRows then
        begin
          bScrolled:=False;
          if (ARow<FirstVisiCell.Y) or ((ARow=FirstVisiCell.Y) and not (egfFirstRowFullyVisi in Flags)) then
            begin
              ClientAreaTop:=(ARow-FixedRows)*RowHeight;
              bScrolled:=True;
            end else
              if (ARow>LastVisiCell.Y) or ((ARow=LastVisiCell.Y) and not (egfLastRowFullyVisi in Flags)) then
                begin
                  ClientAreaTop:=(ARow-FixedRows+1)*RowHeight-ClientHeight+FixedRowsHeight;
                  bScrolled:=True;
                end;
          if bScrolled then
            begin
              Flags:=Flags+[egfCalcBoundRows, egfUpdateRAHeight];
              bInvalidate:=True;
            end;
        end;
      bScrolled:=False;
      if (ACol<VisiCols[FirstVisiCell.X]) or ((Columns[ACol].Left-FixedColsWidth)<ClientAreaLeft) then
        begin
          ClientAreaLeft:=Columns[ACol].Left-FixedColsWidth;
          bScrolled:=True;
        end else
          if (ACol>VisiCols[LastVisiCell.X]) or (Columns[ACol].Right>(ClientAreaLeft+ClientWidth)) then
            begin
              ClientAreaLeft:=Columns[ACol].Right-ClientWidth;
              bScrolled:=True;
            end;
      if bScrolled then
        begin
          Flags:=Flags+[egfCalcBoundCols, egfCalcColsLeft, egfUpdateRAWidth];
          bInvalidate:=True;
        end;
      if not IsColFullyVisible(ACol) then ClientAreaLeft:=Columns[ACol].Left-ClientWidth+FixedColsWidth;
      if bInvalidate then InvalidateNonUpdated;
    end;
end;

procedure TCustomECGrid.ManageSelectionLength(ANewLength: SmallInt);
var aOldLength: SmallInt;
begin
  aOldLength:=length(Selection);
  if ANewLength>aOldLength then SetLength(Selection, aOldLength+cSelectionExpand);
  SelectionHigh:=ANewLength-1;
end;

procedure TCustomECGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const cDragThreshold: SmallInt = 8;
      cSelect: array[Boolean] of TSelectionMode = (esmDontSelect, esmNative);

  procedure DataCellsClick;
  var bInSelection: Boolean;
  begin
    CaptureStart:=ecsDataCells;
    MakeCellFullyVisible(HoveredCol, HoveredRow, False);
    case MultiSelect of
      emsNone: DoSelection(HoveredCol, HoveredRow, esmNative, True, True);
      emsSingleCol:
        begin
          if ([ssModifier, ssShift]*Shift)<>[] then
            begin
              JoinToSelection(HoveredCol, FixedRows, HoveredCol, RowCount-1, True, True, False);
              UpdateColumnData(HoveredCol);
            end;
          DoSelection(HoveredCol, HoveredRow, esmNative, True, ([ssModifier, ssShift]*Shift)=[]);
        end;
      emsSingleColRange:
        if ssShift in Shift then
          begin
            if SelectionHigh>=0 then
              begin
                Selection[SelectionHigh].ToCell.Y:=HoveredRow;
                Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              end else
                JoinToSelection(Col, Row, Col, HoveredRow);
            Redraw([egfRedrawData]);
          end else
          begin
            JoinToSelection(HoveredCol, HoveredRow, HoveredCol, HoveredRow, True, True, True);
            DoSelection(HoveredCol, HoveredRow);
          end;
      emsSingleRow:
        begin
          if ([ssModifier, ssShift]*Shift)<>[] then
            begin
              JoinToSelection(FixedCols, HoveredRow, Columns.Count-1, HoveredRow);
              UpdateRow(HoveredRow);
            end;
          DoSelection(HoveredCol, HoveredRow, esmNative, True, ([ssModifier, ssShift]*Shift)=[]);
        end;
      emsSingleRowRange:
        if ssShift in Shift then
          begin
            if SelectionHigh>=0 then
              begin
                Selection[SelectionHigh].ToCell.X:=HoveredCol;
                Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              end else
                JoinToSelection(Col, Row, HoveredCol, Row);
            Redraw([egfRedrawData]);
          end else
          begin
            JoinToSelection(HoveredCol, HoveredRow, HoveredCol, HoveredRow, True, True, True);
            DoSelection(HoveredCol, HoveredRow);
          end;
      emsSingleRange:
        if ssShift in Shift then
          begin
            if SelectionHigh>=0 then
              begin
                Selection[SelectionHigh].ToCell:=Point(HoveredCol, HoveredRow);
                Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              end else
                JoinToSelection(Col, Row, HoveredCol, HoveredRow);
            Redraw([egfRedrawData]);
          end else
          begin
            JoinToSelection(HoveredCol, HoveredRow, HoveredCol, HoveredRow, True, True, True);
            DoSelection(HoveredCol, HoveredRow);
          end;
      emsMultiCol:
        if ssModifier in Shift then
          begin
            if not IsColSelected(HoveredCol) then
              JoinToSelection(HoveredCol, FixedRows, HoveredCol, RowCount-1, (egfHiSelectionInitial in Flags));
            Redraw([egfRedrawData]);
            DoSelection(HoveredCol, HoveredRow);
          end else
          begin
            if ssShift in Shift then
              begin
                if SelectionHigh>=0 then
                  begin
                    with Selection[SelectionHigh] do
                      begin
                        FromCell.Y:=FixedRows;
                        ToCell:=Point(HoveredCol, RowCount-1);
                        Positive:=True;
                      end;
                    exclude(Flags, egfHiSelectionInitial);
                    Redraw([egfRedrawData]);
                  end else
                    JoinToSelection(HoveredCol, FixedRows, HoveredCol, RowCount-1);
              end;
            DoSelection(HoveredCol, HoveredRow, esmNative, True, not (ssShift in Shift));
          end;
      emsMultiRow:
        if ssModifier in Shift then
          begin
            if not IsRowSelected(HoveredRow) then
              JoinToSelection(FixedCols, HoveredRow, Columns.Count-1, HoveredRow, (egfHiSelectionInitial in Flags));
            Redraw([egfRedrawData]);
            DoSelection(HoveredCol, HoveredRow);
          end else
          begin
            if ssShift in Shift then
              begin
                if SelectionHigh>=0 then
                  begin
                    with Selection[SelectionHigh] do
                      begin
                        FromCell.X:=FixedCols;
                        ToCell:=Point(Columns.Count-1, HoveredRow);
                        Positive:=True;
                      end;
                    exclude(Flags, egfHiSelectionInitial);
                    Redraw([egfRedrawData]);
                  end else
                    JoinToSelection(FixedCols, HoveredRow, Columns.Count-1, HoveredRow);
              end;
            DoSelection(HoveredCol, HoveredRow, esmNative, True, not (ssShift in Shift));
          end;
      emsMultiRange:
        if ssShift in Shift then
          begin
            if SelectionHigh>=0 then
              begin
                Selection[SelectionHigh].ToCell:=Point(HoveredCol, HoveredRow);
                Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              end else
                JoinToSelection(Col, Row, HoveredCol, HoveredRow);
            Redraw([egfRedrawData]);
          end else
          begin
            bInSelection:=IsInSelection(HoveredCol, HoveredRow);
            JoinToSelection(HoveredCol, HoveredRow, HoveredCol, HoveredRow,
              not (ssModifier in Shift), not bInSelection, not bInSelection);
            if not bInSelection or not (ssModifier in Shift) or ((HoveredCol=Col) and (HoveredRow=Row))
              then DoSelection(HoveredCol, HoveredRow)
              else UpdateCell(HoveredCol, HoveredRow);
          end;
      emsMultiCell:
        begin
          if ssModifier in Shift then
            begin
              if egfHiSelectionInitial in Flags then Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              if not IsInSelection(HoveredCol, HoveredRow) then
                JoinToSelection(HoveredCol, HoveredRow, HoveredCol, HoveredRow, False, True, False);
            end;
          DoSelection(HoveredCol, HoveredRow, esmNative, True, not (ssModifier in Shift));
        end;
    end;  {case}
  end;

  procedure FixedColumnsClick;
  begin
    CaptureStart:=ecsFixedCols;
    case MultiSelect of
      emsNone:
        DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options], True, True);
      emsSingleCol, emsMultiCol:
        DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options], True, [ssModifier, ssShift]*Shift=[]);
      emsSingleColRange:
        DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options], True, not (ssModifier in Shift));
      emsSingleRow, emsSingleRowRange:
        begin
          JoinToSelection(FixedCols, HoveredRow, Columns.Count-1, HoveredRow, True, True, False);
          Redraw([egfRedrawData]);
          DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options]);
        end;
      emsMultiRow:
        if (ssShift in Shift) and (SelectionHigh>=0) then
          begin
            Selection[SelectionHigh].ToCell.Y:=HoveredRow;
            Redraw([egfRedrawData]);
          end else
          begin
            if not IsRowSelected(HoveredRow) then
              JoinToSelection(FixedCols, HoveredRow, Columns.Count-1, HoveredRow,
                not (ssModifier in Shift) or (egfHiSelectionInitial in Flags));
            Redraw([egfRedrawData]);
            DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options]);
          end;
      emsSingleRange, emsMultiRange:
        begin
          if (ssShift in Shift) and (SelectionHigh>=0) then
            begin
              Selection[SelectionHigh].ToCell.Y:=HoveredRow;
              Redraw([egfRedrawData]);
            end else
            begin
              JoinToSelection(FixedCols, HoveredRow, Columns.Count-1, HoveredRow,
                not (ssModifier in Shift) or (MultiSelect=emsSingleRange), True, False);
              Redraw([egfRedrawData]);
            end;
          DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options]);
        end;
      emsMultiCell:
        begin
          if (ssModifier in Shift) and not IsInSelection(Col, HoveredRow)
            then JoinToSelection(Col, HoveredRow, Col, HoveredRow, False, True, False);
          DoSelection(Col, HoveredRow, cSelect[egoAlwaysShowEditor in Options], True, not (ssModifier in Shift));
        end;
    end;  {case}
  end;

  procedure FixedRowsClick;
  begin
    CaptureStart:=ecsFixedRows;
    case MultiSelect of
      emsNone:
        DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options], True, True);
      emsSingleCol, emsSingleColRange:
        begin
          JoinToSelection(HoveredCol, FixedRows, HoveredCol, RowCount-1);
          Redraw([egfRedrawData]);
          DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options]);
        end;
      emsSingleRow, emsMultiRow:
        DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options], True, [ssModifier, ssShift]*Shift=[]);
      emsSingleRowRange:
        DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options], True, not (ssModifier in Shift));
      emsMultiCol:
        if (ssShift in Shift) and (SelectionHigh>=0) then
          begin
            Selection[SelectionHigh].ToCell.X:=HoveredCol;
            Redraw([egfRedrawData]);
          end else
          begin
            if not IsColSelected(HoveredCol) then
              JoinToSelection(HoveredCol, FixedRows, HoveredCol, RowCount-1,
                not (ssModifier in Shift) or (egfHiSelectionInitial in Flags));
            Redraw([egfRedrawData]);
            DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options]);
          end;
      emsSingleRange, emsMultiRange:
        if (ssShift in Shift) and (SelectionHigh>=0) then
          begin
            Selection[SelectionHigh].ToCell.X:=HoveredCol;
            Redraw([egfRedrawData]);
          end else
          begin
            JoinToSelection(HoveredCol, FixedRows, HoveredCol, RowCount-1,
              not (ssModifier in Shift) or (MultiSelect=emsSingleRange), True, False);
            Redraw([egfRedrawData]);
            DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options]);
          end;
      emsMultiCell:
        begin
          if (ssModifier in Shift) and not IsInSelection(HoveredCol, Row)
            then JoinToSelection(HoveredCol, Row, HoveredCol, Row, False, True, False);
          DoSelection(HoveredCol, Row, cSelect[egoAlwaysShowEditor in Options], True, not (ssModifier in Shift));
        end;
    end;  {case}
  end;

begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button=mbLeft then
    begin
      if (SizableCol>=0) or ((HoveredCol>=0) and (HoveredRow>=0)) then
        begin
          if HoveredRow<FixedRows then
            begin  { fixed rows }
              if SizableCol>=0 then
                begin
                  MouseCapture:=True;
                  if egfRightToLeft in Flags then X:=-X;
                  SizeInitX:=Columns[SizableCol].FWidth-X;
                  if EditorMode then
                    begin
                      if not (egfRightToLeft in Flags)
                        then SizeEdColXPos:=Columns[Col].Left
                        else SizeEdColXPos:=Columns[Col].Right;
                      SizeEdColWidth:=Columns[Col].Width;
                      Editor.Visible:=False;
                    end;
                  include(Flags, egfSizing);
                end else
                begin
                  if HoveredCol<FixedCols then
                    begin  { select all }
                      CaptureStart:=ecsAll;
                      if MultiSelect in [emsSingleRange, emsMultiCol, emsMultiRow, emsMultiRange] then
                        begin
                          JoinToSelection(FixedCols, FixedRows, Columns.Count-1, RowCount-1, True, True, False);
                          Redraw([egfRedrawData]);
                        end;
                    end else  { fixed rows; Col moving has precedence over Col selection }
                      if (MovableCol>=0) and ([ssModifier, ssShift]*Shift=[])
                        then BeginDrag(False, cDragThreshold)
                        else FixedRowsClick;
                  PushedCol:=HoveredCol;
                  PushedRow:=HoveredRow;
                  if (egoHeaderPushedLook in Options) and (Style<>egsFlat) then
                    begin
                      DrawHeaderCell(PushedCol, PushedRow);
                      InvalidateNonUpdated;
                    end;
                end;
            end else
              if HoveredCol>=FixedCols
                then DataCellsClick      { data cells }
                else FixedColumnsClick;  { fixed cols }
        end;
    end;
  SetFocus;
end;

procedure TCustomECGrid.MouseLeave;
begin
  inherited MouseLeave;
  MovableCol:=-1;
  SizableCol:=-1;
end;

procedure TCustomECGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
const cSizeGrip: SmallInt = 6;

  procedure InitOutBoundsDragging;
  const cDragR2L: array[Boolean] of TPositions = ([eopLeft], [eopRight]);
  var aLeft, aRight: Integer;
      bR2L: Boolean;
  begin
    if CaptureStart in [ecsFixedCols, ecsDataCells] then
      begin
        if Y<=FixedRowsHeight
          then MouseDragScrollPos:=MouseDragScrollPos+[eopTop]-[eopBottom]
          else if Y>Height
                 then MouseDragScrollPos:=MouseDragScrollPos-[eopTop]+[eopBottom]
                 else MouseDragScrollPos:=MouseDragScrollPos-[eopTop, eopBottom];
      end;
    if CaptureStart in [ecsFixedRows, ecsDataCells] then
      begin
        bR2L:=(egfRightToLeft in Flags);
        if not bR2L then
          begin
            aLeft:=FixedColsWidth;
            aRight:=ClientWidth;
          end else
          begin
            aLeft:=0;
            aRight:=ClientWidth-FixedColsWidth;
          end;
        if X<aLeft
          then MouseDragScrollPos:=MouseDragScrollPos+cDragR2L[bR2L]-cDragR2L[not bR2L]
          else if X>=aRight
                 then MouseDragScrollPos:=MouseDragScrollPos-cDragR2L[bR2L]+cDragR2L[not bR2L]
                 else MouseDragScrollPos:=MouseDragScrollPos-[eopLeft, eopRight];
      end;
    if MouseDragScrollPos<>[] then
      begin
        Timer.OnStartTimer:=@TimerOnTimer;
        Timer.OnTimer:=@TimerOnTimer;
        Timer.Enabled:=True;
      end else
        Timer.Enabled:=False;
    if MouseDragScrollPos<>PrevMouseDragScrollPos then include(Flags, egfRedrawData);
    PrevMouseDragScrollPos:=MouseDragScrollPos;
  end;

var aCol, aRow: Integer;

  procedure FixedRowsMouseMove;
  var i: Integer;
  begin
    i:=SelectionHigh;
    if (i>=0) and (Selection[i].ToCell<>Point(aCol, aRow)) then
      case MultiSelect of
        emsSingleColRange:
          begin
            ChangeHighSelection(Col, FixedRows, Col, RowCount-1);
            UpdateColumnData(Col);
          end;
        emsSingleRowRange:
          if (i=0) and (Selection[i].ToCell.X<>aCol) then
            begin
              Selection[i].ToCell.X:=aCol;
              if not IsInSelection(Col, Row) then Selection[i].FromCell.X:=Col;
              Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              UpdateRow(Row);
            end;
        emsMultiCol:
          begin
            Selection[i].ToCell.X:=aCol;
            Redraw([egfRedrawData]);
          end;
        emsSingleRange, emsMultiRange:
          begin
            ChangeHighSelection(Col, FixedRows, aCol, RowCount-1);
            Redraw([egfRedrawData]);
          end;
      end;
  end;

  procedure DataRowsMouseMove;
  var i: Integer;
  begin
    i:=SelectionHigh;
    case MultiSelect of
      emsSingleCol:
        if (i=0) and ((Selection[i].FromCell.Y<>FixedRows) or (Selection[i].ToCell.Y<>(RowCount-1))) then
          begin
            ChangeHighSelection(Col, FixedRows, Col, RowCount-1);
            UpdateColumnData(Col);
          end;
      emsSingleColRange:
        if (i=0) and (Selection[i].ToCell.Y<>aRow) then
          begin
            Selection[i].ToCell.Y:=aRow;
            if not IsInSelection(Col, Row) then Selection[i].FromCell.Y:=Row;
            Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
            UpdateColumnData(Col);
          end;
      emsSingleRow:
        if (i=0) and ((Selection[i].FromCell.X<>FixedCols) or (Selection[i].ToCell.X<>(Columns.Count-1))) then
          begin
            ChangeHighSelection(FixedCols, Row, Columns.Count-1, Row);
            UpdateRow(Row);
          end;
      emsSingleRowRange:
        if (i=0) and (Selection[i].ToCell.X<>aCol) then
          begin
            if aCol>=FixedCols then
              begin
                Selection[i].ToCell.X:=aCol;
                if not IsInSelection(Col, Row) then Selection[i].FromCell.X:=Col;
                Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              end else
                ChangeHighSelection(FixedCols, Row, Columns.Count-1, Row);
            UpdateRow(Row);
          end;
      emsMultiCol:
        if (i>=0) and (Selection[i].ToCell<>Point(aCol, aRow)) and (aCol>=FixedCols) then
          begin
            ChangeHighSelection(Selection[i].FromCell.X, FixedRows, aCol, RowCount-1);
            Redraw([egfRedrawData]);
          end;
      emsMultiRow:
        if (i>=0) and (Selection[i].ToCell<>Point(aCol, aRow)) then
          begin
            ChangeHighSelection(FixedCols, Selection[i].FromCell.Y, Columns.Count-1, aRow);
            Redraw([egfRedrawData]);
          end;
      emsSingleRange, emsMultiRange:
        if (i>=0) and (Selection[i].ToCell<>Point(aCol, aRow)) then
          begin
            if aCol>=FixedCols then
              begin
                Selection[i].ToCell:=Point(aCol, aRow);
                if not IsInSelection(Col, Row) then Selection[i].FromCell:=Point(Col, Row);
                Flags:=Flags-[egfHiSelectionInitial]+[egfMultiSelection];
              end else
                ChangeHighSelection(FixedCols, Selection[i].FromCell.Y, Columns.Count-1, aRow);
            Redraw([egfRedrawData]);
          end;
    end;  {case}
  end;

var aSizeCol, aVisiColsM1: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  if [egfMoving, egfSizing]*Flags=[] then
    begin
      if (ssLeft in Shift) and (CaptureStart>=ecsFixedCols) and (egfRangeSelects in Flags)
        then InitOutBoundsDragging;
      if MouseDragScrollPos=[] then
        begin
          MouseToCell(X, Y, aCol, aRow);
          aSizeCol:=-1;
          if not (ssLeft in Shift) and InRangeCO(aRow, 0, FixedRows) then
            begin
              if egfRightToLeft in Flags then X:=ClientWidth-X;
              if ([egoAutoEnlargeColumns, egoColSizing]*Options)=[egoColSizing] then
                begin
                  inc(X, ClientAreaLeft);
                  if aCol>=0 then
                    begin
                      if X<(Columns[aCol].Left+cSizeGrip) then
                        begin
                          aSizeCol:=aCol;
                          repeat
                            dec(aSizeCol);
                          until (aSizeCol<0) or (ecoVisible in Columns[aSizeCol].Options);
                        end else
                          if X>(Columns[aCol].Right-cSizeGrip) then aSizeCol:=aCol;
                    end else
                    begin
                      aVisiColsM1:=high(VisiCols);
                      if (aVisiColsM1>=0) and Math.InRange(X-Columns[VisiCols[aVisiColsM1]].Right, 0, cSizeGrip)
                        then aSizeCol:=VisiCols[aVisiColsM1];
                    end;
                  if (aSizeCol>=0) and not (ecoSizing in Columns[aSizeCol].Options) then aSizeCol:=-1;
                  SizableCol:=aSizeCol;
                end;
            end;
          if (HoveredCol<>aCol) or (HoveredRow<>aRow) then
            begin
              if not (ssLeft in Shift) then
                begin
                  if ShowHint then ChangeHint(aCol, aRow);
                  if (egoColMoving in Options) and (aCol>=FixedCols)
                    then MovableCol:=aCol
                    else MovableCol:=-1;
                end else
                  if (aRow>=FixedRows) and (CaptureStart in [ecsFixedCols, ecsDataCells])
                    then DataRowsMouseMove
                    else if (aCol>=FixedCols) and (CaptureStart=ecsFixedRows)
                           then FixedRowsMouseMove;
              HoveredCol:=aCol;
              HoveredRow:=aRow;
            end;
        end;
    end else
    begin
      if egfSizing in Flags then
        begin
					if egfRightToLeft in Flags then X:=-X;
          Columns[SizableCol].Width:=X+SizeInitX;
        end;
    end;
end;

procedure TCustomECGrid.MouseToCell(AX, AY: Integer; out ACol, ARow: Integer);
var i, aCnt, aMax, aMin: Integer;
begin
  if AX<0
    then ACol:=cOutOfBounds[egfRightToLeft in Flags]
    else if AX<ClientWidth then
           begin
             ACol:=low(Integer);
             aMax:=LastVisiCell.X;
             if aMax>=0 then
               begin
                 if egfRightToLeft in Flags then AX:=ClientWidth-AX-1;
                 if AX>=FixedColsWidth then
                   begin
                     inc(AX, ClientAreaLeft);
                     if AX<Columns[VisiCols[aMax]].Right then
                       begin
                         aMin:=FirstVisiCell.X;
                         aCnt:=2;
                         if (aMax-aMin)>0 then inc(aCnt, round(log2(aMax-aMin)));
                         while aCnt>0 do
                           begin
                             i:=(aMax+aMin) div 2;
                             if Columns[VisiCols[i]].Left<=AX then
                               begin
                                 aMin:=i;
                                 ACol:=VisiCols[i];
                                 if AX<Columns[ACol].Right then break;
                                 if (aMax-aMin)=1 then inc(aMin);
                               end else
                                 aMax:=i;
                             dec(aCnt);
                           end;
                       end;
                   end else
                     for i:=0 to FixedVisiCols-1 do
                       if AX<Columns[VisiCols[i]].Right then
                         begin
                           ACol:=VisiCols[i];
                           break;
                         end;
               end;
           end else
             ACol:=cOutOfBounds[not (egfRightToLeft in Flags)];
  if AY<0
    then ARow:=cOutOfBounds[False]
    else if AY>=ClientHeight
           then ARow:=cOutOfBounds[True]
           else if AY>=FixedRowsHeight then
                  begin
                    if assigned(OnGetDataRowCount)
                      then OnGetDataRowCount(self, aCnt)
                      else aCnt:=0;
                    ARow:=FixedRows+Math.min((AY+ClientAreaTop-FixedRowsHeight) div RowHeight, aCnt-1);
                  end else
                    ARow:=AY div FixedRowHeight;
end;

procedure TCustomECGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aPushedCol: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button=mbLeft then
    begin
      if not (egfSizing in Flags) then
        begin
          aPushedCol:=PushedCol;
          if aPushedCol>=0 then
            begin
              if not (egfMoving in Flags) then
                begin
                  if (aPushedCol=HoveredCol) and (PushedRow=HoveredRow) then
                    begin
                      if ecoSorting in Columns[aPushedCol].Options then
                        if SortIndex=aPushedCol
                          then SortAscendent:=not SortAscendent
                          else SortIndex:=aPushedCol;
                      if assigned(OnHeaderClick) then OnHeaderClick(self, aPushedCol, PushedRow);
                    end;
                end else
                  exclude(Flags, egfMoving);
              PushedCol:=-1;
              if (egoHeaderPushedLook in Options) and (Style<>egsFlat) then
                begin
                  DrawHeaderCell(aPushedCol, PushedRow);
                  InvalidateNonUpdated;
                end;
            end;
          Timer.Enabled:=False;
          MouseDragScrollPos:=[];
          CaptureStart:=ecsNone;
        end else
        begin
          ChangeCursor(False);
          MouseCapture:=False;
          Flags:=Flags-[egfMoving, egfSizing];
          if EditorMode then
            if IsColFullyVisible(Col) then
              begin
                if not (egfRightToLeft in Flags)
                  then Editor.Left:=Editor.Left-SizeEdColXPos+Columns[Col].Left
                  else Editor.Left:=Editor.Left+SizeEdColXPos-Columns[Col].Right;
                Editor.Width:=Editor.Width-SizeEdColWidth+Columns[Col].Width;
                Editor.Visible:=True;
                if (Editor is TWinControl) and TWinControl(Editor).CanFocus then TWinControl(Editor).SetFocus;
              end else
                EditorMode:=False;
          FSizableCol:=-1;
        end;
    end;
end;

{$IFDEF DBGGRID} var PaintCnt: Integer; {$ENDIF}

procedure TCustomECGrid.Paint;
var i, j, k, aHeaderHeight, aRight, aShift: Integer;
    aRect: TRect;
    bHasDataRows, bSelChanged: Boolean;
    {$IFDEF DBGGRID} aTD: TDateTime; {$ENDIF}
begin
  inherited Paint;
  {$IFDEF DBGGRID} DebugLn('Paint Flags: ',
    boolToStr(egfRedrawFixedHeader in Flags, 'FH ', '-- '), boolToStr(egfRedrawFixedCols in Flags, 'FC ', '-- '),
    boolToStr(egfRedrawFixedRows in Flags, 'FR ', '-- '), boolToStr(egfRedrawData in Flags, 'DA ', '-- '));
  aTD:=Now; inc(PaintCnt); {$ENDIF}
  if (length(VisiCols)>0) and (UpdateCount=0) then
    if not (EditorMode and (Canvas.ClipRect.Left>=FixedColsWidth)) then
      begin
        aHeaderHeight:=FixedRowsHeight;
        if IsEnabled then
          begin
            if not (egfWasEnabled in Flags) then Flags:=Flags+cRedrawGrid;
            include(CommonPaintFlags, pfEnabled);
            include(Flags, egfWasEnabled);
          end else
          begin
            if egfWasEnabled in Flags then Flags:=Flags+cRedrawGrid;
            exclude(CommonPaintFlags, pfEnabled);
            exclude(Flags, egfWasEnabled);
          end;
        bHasDataRows:=(RowCount>FixedRows);
        aShift:=ClientAreaLeft-PrevClientAreaLeft;
        if abs(aShift)>=BMPData.Width then Flags:=Flags+[egfRedrawFixedRows, egfRedrawData];
        if abs(ClientAreaTop-PrevClientAreaTop)>=(ClientHeight-aHeaderHeight) then Flags:=Flags+[egfRedrawFixedCols, egfRedrawData];
        if egfRedrawData in Flags then
          for i:=FirstVisiCell.X to LastVisiCell.X do
            include(Columns[VisiCols[i]].Flags, ecfRedrawData);
        if egfRedrawFixedCols in Flags then
          for i:=0 to FixedVisiCols-1 do
            include(Columns[VisiCols[i]].Flags, ecfRedrawData);
        if egfRedrawFixedRows in Flags then
          for i:=FirstVisiCell.X to LastVisiCell.X do
            include(Columns[VisiCols[i]].Flags, ecfRedrawHeader);
        if egfRedrawFixedHeader in Flags then
          for i:=0 to FixedVisiCols-1 do
            include(Columns[VisiCols[i]].Flags, ecfRedrawHeader);
        if (egoHilightColHeader in Options) and (PrevSel.X<>Col) then
          begin
            include(Columns[Col].Flags, ecfRedrawHeader);
            include(Columns[PrevSel.X].Flags, ecfRedrawHeader);
          end;
        if (egoHilightRowHeader in Options) and (PrevSel.Y<>Row) then
          for i:=0 to FixedVisiCols-1 do
            if not (ecfRedrawData in Columns[i].Flags) then
              begin
                DrawFixedCell(i, PrevSel.Y);
                DrawFixedCell(i, Row);
              end;
        if (aShift<>0) and (abs(aShift)<BMPData.Width) then DrawGridHorScrolled(aShift);
        aShift:=FirstVisiCell.Y-FirstVisiCell.PrevY;
        if (aShift<>0) and bHasDataRows and not (egfRedrawFixedCols in Flags) then DrawFixedColsVertScrolled(aShift);
        for i:=0 to FixedVisiCols-1 do
          begin
            k:=VisiCols[i];
            if ecfRedrawHeader in Columns[k].Flags
              then for j:=0 to FixedRows-1 do
                     DrawHeaderCell(k, j)
              else if ecfRedrawTitle in Columns[k].Flags then DrawHeaderCell(k, 0);
            if bHasDataRows and (ecfRedrawData in Columns[k].Flags) then
              DrawFixedColumn(k, FirstVisiCell.Y, Math.min(FirstVisiCell.Y+BMPFixedCols.Height div RowHeight, RowCount-1));
            Columns[k].Flags:=Columns[k].Flags-cRedrawColumn;
          end;
        i:=PrevSel.X;
        if FirstVisiCell.X>0 then
          begin
            if (i>=VisiCols[FirstVisiCell.X]) and (i<=VisiCols[LastVisiCell.X]) then
              if egoHilightCol in Options then include(Columns[i].Flags, ecfRedrawData);
            i:=Col;
            if (i>=VisiCols[FirstVisiCell.X]) and (i<=VisiCols[LastVisiCell.X]) then
              if egoHilightCol in Options then include(Columns[i].Flags, ecfRedrawData);
          end;
        if FixedRows>0 then
          for i:=FirstVisiCell.X to LastVisiCell.X do
            if ecfRedrawHeader in Columns[VisiCols[i]].Flags
              then for j:=0 to FixedRows-1 do
                     DrawHeaderCell(VisiCols[i], j)
              else if ecfRedrawTitle in Columns[VisiCols[i]].Flags then DrawHeaderCell(VisiCols[i], 0);
        if bHasDataRows then
          begin
            bSelChanged:=((Col<>PrevSel.X) or (Row<>PrevSel.Y));
            for i:=FirstVisiCell.X to LastVisiCell.X do
              begin
                k:=VisiCols[i];
                if not (ecfRedrawData in Columns[k].Flags) then
                  begin
                    if aShift<>0 then DrawDataColVertScrolled(k, aShift);
                    if bSelChanged then
                      begin
                        if (k=PrevSel.X) or (egoHilightRow in Options) then DrawDataCell(k, PrevSel.Y);
                        if (k=Col) or (egoHilightRow in Options) then DrawDataCell(k, Row);
                      end;
                  end else
                    DrawDataColumn(k);
              end;
            if egfRedrawFocusedCell in Flags then DrawDataCell(Col, Row);
          end;
        for i:=FirstVisiCell.X to LastVisiCell.X do
          Columns[VisiCols[i]].Flags:=Columns[VisiCols[i]].Flags-cRedrawColumn;
        PrevSel:=Point(Col, Row);
        i:=FixedColsWidth;
        aRight:=Math.min(FRequiredArea.X, ClientWidth);
        if not (egfRightToLeft in Flags) then
          begin
            Canvas.Draw(0, 0, BMPHead);
            Canvas.CopyRect(Rect(i, 0, aRight, aHeaderHeight), BMPFixedRows.Canvas,
              Rect(0, 0, aRight-i, aHeaderHeight));
          end else
          begin
            Canvas.Draw(ClientWidth-i, 0, BMPHead);
            Canvas.CopyRect(Rect(ClientWidth-aRight, 0, ClientWidth-i, aHeaderHeight), BMPFixedRows.Canvas,
              Rect(BMPFixedRows.Width-aRight+i, 0, BMPFixedRows.Width, aHeaderHeight));
          end;
        k:=ClientAreaTop mod RowHeight;
        j:=Math.min(FRequiredArea.Y, ClientHeight);
        if not (egfRightToLeft in Flags) then
          begin
            Canvas.CopyRect(Rect(0, aHeaderHeight, i, j), BMPFixedCols.Canvas,
              Rect(0, k, i, j-aHeaderHeight+k));
            Canvas.CopyRect(Rect(i, aHeaderHeight, aRight, j), BMPData.Canvas,
              Rect(0, k, aRight-i, j-aHeaderHeight+k));
          end else
          begin
            Canvas.CopyRect(Rect(ClientWidth-i, aHeaderHeight, ClientWidth, j),
              BMPFixedCols.Canvas, Rect(0, k, i, j-aHeaderHeight+k));
            Canvas.CopyRect(Rect(ClientWidth-aRight, aHeaderHeight, ClientWidth-i, j), BMPData.Canvas,
              Rect(BMPData.Width-aRight+i, k, BMPData.Width, j-aHeaderHeight+k));
          end;
        Flags:=Flags-cRedrawGrid;
        FirstVisiCell.PrevX:=FirstVisiCell.X;
        LastVisiCell.PrevX:=LastVisiCell.X;
        FirstVisiCell.PrevY:=FirstVisiCell.Y;
        LastVisiCell.PrevY:=LastVisiCell.Y;
        PrevClientAreaLeft:=ClientAreaLeft;
        PrevClientAreaTop:=ClientAreaTop;
      end else
      begin
        aRect:=Canvas.ClipRect;
        i:=FixedColsWidth;
        dec(aRect.Left, i);
        dec(aRect.Right, i);
        j:=FixedRowHeight-(ClientAreaTop mod RowHeight);
        dec(aRect.Top, j);
        dec(aRect.Bottom, j);
        Canvas.CopyRect(Canvas.ClipRect, BMPData.Canvas, aRect);
      end;
  {$IFDEF DBGGRID} DebugLn('TCustomECGrid.Paint: ', intToStr(PaintCnt), 'x, ',
                     floatToStrF(24*3600*(Now-aTD), ffFixed, 0, 7)); {$ENDIF}
end;

procedure TCustomECGrid.PrepareEditorDeltaRect(AX, AY: Boolean);
var aCellRect: TRect;
begin
  aCellRect:=CellRect(Col, Row);
  if AX then
    begin
      EditorDeltaRect.Left:=Editor.Left-aCellRect.Left;
      EditorDeltaRect.Right:=Editor.Width-(aCellRect.Right-aCellRect.Left);
      include(Flags, egfCorrectEditorPosX);
    end;
  if AY then
    begin
      EditorDeltaRect.Top:=Editor.Top-aCellRect.Top;
      EditorDeltaRect.Bottom:=Editor.Height-(aCellRect.Bottom-aCellRect.Top);
      include(Flags, egfCorrectEditorPosY);
    end;
end;

procedure TCustomECGrid.Redraw(AGFlags: TGFlags);
begin
  Flags:=Flags+AGFlags;
  InvalidateNonUpdated;
end;

procedure TCustomECGrid.RemoveFromSelection(AFromX, AFromY, AToX, AToY: Integer);
begin
  if (MultiSelect=emsMultiRange) and (egfMultiSelection in Flags) then
    begin
      JoinToSelection(AFromX, AFromY, AToX, AToY, False, False);
      Redraw([egfRedrawData]);
    end;
end;

procedure TCustomECGrid.ResizeBMPs;
var aWidth, aHeight, aDataHeight, aDataWidth: Integer;
begin
  aWidth:=BMPHead.Width;  { header }
  aHeight:=BMPHead.Height;
  BMPHead.Width:=FixedColsWidth;
  BMPHead.Height:=FixedRowsHeight;
  if (aWidth<>BMPHead.Width) or (aHeight<>BMPHead.Height) then include(Flags, egfRedrawFixedHeader);
  aDataWidth:=ClientWidth-FixedColsWidth;
  aWidth:=BMPFixedRows.Width;  { fixed rows }
  aHeight:=BMPFixedRows.Height;
  BMPFixedRows.Width:=aDataWidth;
  BMPFixedRows.Height:=FixedRowsHeight;
  if (aWidth<>BMPFixedRows.Width) or (aHeight<>BMPFixedRows.Height) then include(Flags, egfRedrawFixedRows);
  aHeight:=ClientHeight-FixedRowsHeight;
  aDataHeight:=aHeight div RowHeight +1;
  if (aHeight mod RowHeight)>=2 then inc(aDataHeight);
  aDataHeight:=aDataHeight*RowHeight;
  aWidth:=BMPFixedCols.Width;  { fixed cols }
  aHeight:=BMPFixedCols.Height;
  BMPFixedCols.Width:=FixedColsWidth;
  BMPFixedCols.Height:=aDataHeight;
  if (aWidth<>BMPFixedCols.Width) or (aHeight<>BMPFixedCols.Height) then include(Flags, egfRedrawFixedCols);
  aWidth:=BMPData.Width;  { data area }
  aHeight:=BMPData.Height;
  BMPData.Width:=aDataWidth;
  BMPData.Height:=aDataHeight;
  if (aWidth<>BMPData.Width) or (aHeight<>BMPData.Height) then include(Flags, egfRedrawData);
  exclude(Flags, egfResizeBMPs);
end;

{ saves to a file, i.e. xml file contains columns-config in <CONFIG><AColumnsNode>... }
procedure TCustomECGrid.SaveColumnsToXML(AFileName: string; AColumnsNode: DOMString; AXMLFlags: TXMLColFlags);
var aNode: TDOMNode;
    aXMLDoc: TXMLDocument;
begin
  aXMLDoc:=nil;
  if FileExistsUTF8(AFileName) then
    ReadXMLFile(aXMLDoc, AFileName, [xrfAllowSpecialCharsInAttributeValue]);
  if not assigned(aXMLDoc) then aXMLDoc:=TXMLDocument.Create;
  try
    with aXMLDoc do
      begin
        if not assigned(DocumentElement) then
          begin
            aNode:=CreateElement(cRoot);
            AppendChild(aNode);
          end;
        if AColumnsNode='' then AColumnsNode:=Name+'_'+cColumn+'s';
        aNode:=DocumentElement.FindNode(AColumnsNode);
        if not assigned(aNode) then
          begin
            aNode:=CreateElement(AColumnsNode);
            DocumentElement.AppendChild(aNode);
          end;
        SaveColumnsToXML(aXMLDoc, aNode, AXMLFlags);
        WriteXMLFile(aXMLDoc, AFileName);
      end;
  finally
    aXMLDoc.Free;
  end;
end;

procedure TCustomECGrid.SaveColumnsToXML(AXMLDoc: TXMLDocument; AColumnsNode: TDOMNode; AXMLFlags: TXMLColFlags);
var aNode, aColumnNode: TDOMNode;
    i, aCount: Integer;
begin
  aColumnNode:=AColumnsNode.FirstChild;
  while assigned(aColumnNode) do  { delete old children }
    begin
      aNode:=aColumnNode;
      aColumnNode:=aColumnNode.NextSibling;
      aNode:=AColumnsNode.RemoveChild(aNode);
      aNode.Free;
    end;
  aCount:=Columns.Count;
  TDOMElement(AColumnsNode).SetAttribute(cCount, intToStr(aCount));
  for i:=0 to aCount-1 do  { create new children and fill them }
    begin
      aColumnNode:=AXMLDoc.CreateElement(cColumn+intToStr(i));
      AColumnsNode.AppendChild(aColumnNode);
      if excfOrder in AXMLFlags then
        TDOMElement(aColumnNode).SetAttribute(cOrder, intToStr(Columns[i].Order));
      if excfVisible in AXMLFlags then
        TDOMElement(aColumnNode).SetAttribute(cVisible, boolToStr(ecoVisible in Columns[i].Options, cTrue, cFalse));
      if excfWidth in AXMLFlags then
        TDOMElement(aColumnNode).SetAttribute(cWidth, intToStr(Columns[i].FWidth));
    end;
end;

procedure TCustomECGrid.SaveToCSVFile(AFileName: string; ADelimiter: Char = ',';
            AHeaders: Boolean = True; AVisibleColsOnly: Boolean = False);
var i, j, aFirstRow: Integer;
    aLine, aLines: TStringList;
begin
  if (RowCount>0) and (Columns.Count>0) then
    begin
      aLines:=TStringList.Create;
      aLine:=TStringList.Create;
      aLine.Delimiter:=ADelimiter;
      aLine.StrictDelimiter:=False;
      if AHeaders and (FixedRows>0)
        then aFirstRow:=0
        else aFirstRow:=FixedRows;
      try
        if AVisibleColsOnly then
          begin
            for i:=0 to high(VisiCols) do
              aLine.Add(Cells[VisiCols[i], aFirstRow]);
            aLines.Add(aLine.DelimitedText);
            for j:=aFirstRow+1 to RowCount-1 do
              begin
                for i:=0 to high(VisiCols) do
                  aLine[i]:=Cells[VisiCols[i], j];
                aLines.Add(aLine.DelimitedText);
              end;
          end else
          begin
            for i:=0 to Columns.Count-1 do
              aLine.Add(Cells[i, aFirstRow]);
            aLines.Add(aLine.DelimitedText);
            for j:=aFirstRow+1 to RowCount-1 do
              begin
                for i:=0 to Columns.Count-1 do
                  aLine[i]:=Cells[i, j];
                aLines.Add(aLine.DelimitedText);
              end;
          end;
        aLines.SaveToFile(AFileName);
      finally
        aLine.Free;
        aLines.Free;
      end;
    end;
end;

procedure TCustomECGrid.SelectCell(ACol, ARow: Integer; ASelectEditor: TSelectionMode;
            AForceFocus: Boolean; AResetRow: Boolean);
begin
  if AResetRow then FRow:=low(Integer);
  if (ACol>=FixedCols) and (ARow>=FixedRows) and (ACol<Columns.Count) and (ARow<RowCount) then
    if MakeCellFullyVisible(ACol, ARow, AForceFocus) then DoSelection(ACol, ARow, ASelectEditor, False);
end;

procedure TCustomECGrid.SetBorderStyle(NewStyle: TBorderStyle);
begin
  inherited SetBorderStyle(NewStyle);
  Redraw([egfCalcBoundCols, egfCalcBoundRows]);
end;

procedure TCustomECGrid.SetCursor(Value: TCursor);
begin
  inherited SetCursor(Value);
  if not (egfLockCursor in Flags) then DefCursor:=Value;
end;

procedure TCustomECGrid.SetFocus;
begin
  if (Editor is TWinControl) and TWinControl(Editor).CanFocus
    then TWinControl(Editor).SetFocus
    else inherited SetFocus;
end;

procedure TCustomECGrid.SetHint(const Value: TTranslateString);
begin
  inherited SetHint(Value);
  if not (egfLockHint in Flags) then DefHint:=Value;
end;

procedure TCustomECGrid.TimerOnTimer(Sender: TObject);
const cHorDragSelects = [emsSingleRowRange, emsSingleRange, emsMultiCol, emsMultiRange];
      cVertDragSelects = [emsSingleColRange, emsSingleRange, emsMultiRow, emsMultiRange];
var i, aCol, aHelp: Integer;
    aGFlags: TGFlags;
begin
  if EditorMode then PrepareEditorDeltaRect(([eopLeft, eopRight]*MouseDragScrollPos)<>[],
                                            ([eopTop, eopBottom]*MouseDragScrollPos)<>[]);
  aGFlags:=[];
  inc(UpdateCount);
  if eopLeft in MouseDragScrollPos then
    begin
      ClientAreaLeft:=ClientAreaLeft-3*RowHeight;
      include(aGFlags, egfCalcBoundCols);
      aCol:=VisiCols[FirstVisiCell.X];
      if (MultiSelect in cHorDragSelects) and (Selection[SelectionHigh].ToCell.X<>aCol) then
        begin
          aHelp:=Selection[SelectionHigh].ToCell.X;
          Selection[SelectionHigh].ToCell.X:=aCol;
          for i:=aCol to aHelp do
            include(Columns[i].Flags, ecfRedrawData);
        end;
    end else
      if eopRight in MouseDragScrollPos then
        begin
          ClientAreaLeft:=ClientAreaLeft+3*RowHeight;
          include(aGFlags, egfCalcBoundCols);
          aCol:=VisiCols[LastVisiCell.X];
          if (MultiSelect in cHorDragSelects) and (Selection[SelectionHigh].ToCell.X<>aCol) then
            begin
              aHelp:=Selection[SelectionHigh].ToCell.X;
              Selection[SelectionHigh].ToCell.X:=aCol;
              for i:=aHelp to aCol do
                include(Columns[i].Flags, ecfRedrawData);
            end;
        end;
  if eopTop in MouseDragScrollPos then
    begin
      if MultiSelect in cVertDragSelects then
        begin
          aHelp:=Selection[SelectionHigh].ToCell.Y;
          Selection[SelectionHigh].ToCell.Y:=FirstVisiCell.Y;
          for i:=FirstVisiCell.Y to aHelp do
            UpdateRow(i);
        end;
      ClientAreaTop:=ClientAreaTop-RowHeight;
      include(aGFlags, egfCalcBoundRows);
    end else
      if eopBottom in MouseDragScrollPos then
        begin
          if MultiSelect in cVertDragSelects then
            begin
              aHelp:=Selection[SelectionHigh].ToCell.Y;
              Selection[SelectionHigh].ToCell.Y:=LastVisiCell.Y;
              for i:=aHelp to LastVisiCell.Y do
                UpdateRow(i);
            end;
          ClientAreaTop:=ClientAreaTop+RowHeight;
          include(aGFlags, egfCalcBoundRows);
        end;
  dec(UpdateCount);
  if aGFlags<>[] then Redraw(aGFlags);
end;

procedure TCustomECGrid.UpdateCell(ACol, ARow: Integer);
begin
  if ACol<Columns.Count then
    begin
      DrawDataCell(ACol, ARow);
      InvalidateNonUpdated;
    end;
end;

procedure TCustomECGrid.UpdateColumn(ACol: Integer; AHeader: Boolean = False; AData: Boolean = True);
begin
  if ACol<Columns.Count then
    begin
      if AHeader then include(Columns[ACol].Flags, ecfRedrawHeader);
      if AData then include(Columns[ACol].Flags, ecfRedrawData);
      InvalidateNonUpdated;
    end;
end;

procedure TCustomECGrid.UpdateColumnData(ACol: Integer);
begin
  include(Columns[ACol].Flags, ecfRedrawData);
  InvalidateNonUpdated;
end;

procedure TCustomECGrid.UpdateData;
begin
  if RowCount<=Row then FRow:=-1;
  Redraw([egfCalcBoundRows, egfRedrawFixedCols, egfRedrawData, egfUpdateRAHeight]);
end;

procedure TCustomECGrid.UpdateDataCell(ACol, ADataRow: Integer);
begin
  if ACol<Columns.Count then
    begin
      DrawDataCell(ACol, ADataRow+FixedRows);
      InvalidateNonUpdated;
    end;
end;

procedure TCustomECGrid.UpdateRequiredAreaHeight;
begin
  if Columns.Count>0
    then FRequiredArea.Y:=FixedRowsHeight+(RowCount-FixedRows)*RowHeight
    else FRequiredArea.Y:=0;
  if (ClientAreaTop+ClientHeight)>FullAreaHeight then ClientAreaTop:=FRequiredArea.Y-ClientHeight;
  UpdateScrollInfoVert;
  exclude(Flags, egfUpdateRAHeight);
end;

procedure TCustomECGrid.UpdateRequiredAreaWidth;
begin
  if high(VisiCols)>=0
    then FRequiredArea.X:=Columns[VisiCols[high(VisiCols)]].Right
    else FRequiredArea.X:=0;
  if (ClientAreaLeft+ClientWidth)>FullAreaWidth then ClientAreaLeft:=FRequiredArea.X-ClientWidth;
  UpdateScrollInfoHor;
  exclude(Flags, egfUpdateRAWidth);
end;

procedure TCustomECGrid.UpdateRow(ARow: Integer; AFixedCols: Boolean = False; AData: Boolean = True);
var i: Integer;
begin
  if AFixedCols then
    for i:=0 to FixedVisiCols-1 do
      DrawFixedColumn(VisiCols[i], ARow, ARow);
  if AData then
    for i:=FirstVisiCell.X to LastVisiCell.X do
      DrawDataCell(VisiCols[i], ARow);
  InvalidateNonUpdated;
end;

procedure TCustomECGrid.UpdateRowCount;
begin
  UpdateData;
end;

procedure TCustomECGrid.WMHScroll(var Msg: TWMScroll);
var aClientAreaLeft, aEdLeft, aSelectionPos: Integer;
    bEdVisible: Boolean;
begin
   if (Msg.ScrollCode=SB_THUMBPOSITION) or (not (egoThumbTracking in Options) and not (Msg.ScrollCode in
     [SB_LINELEFT, SB_LINERIGHT, SB_PAGELEFT, SB_PAGERIGHT, SB_ENDSCROLL])) then exit;  { Exit! }
  include(Flags, egfCalcBoundCols);
  aClientAreaLeft:=-1;
  aSelectionPos:=-1;
  if egoScrollKeepVisible in Options then
    begin
      if IsColVisible(Col) then aSelectionPos:=Col-VisiCols[FirstVisiCell.X];
    end else
      if EditorMode then aClientAreaLeft:=ClientAreaLeft;
  inherited WMHScroll(Msg);
  if aSelectionPos>=0 then
    begin
      inc(aSelectionPos, VisiCols[FirstVisiCell.X]);
      if not IsColFullyVisible(aSelectionPos) then
        if Col<=VisiCols[FirstVisiCell.X]
          then aSelectionPos:=GetNextVisiCol(aSelectionPos)
          else if Col>=VisiCols[LastVisiCell.X] then aSelectionPos:=GetPreviousVisiCol(aSelectionPos);
      if Col<>aSelectionPos
        then DoSelection(aSelectionPos, Row, esmNative, False, not IsInSelection(aSelectionPos, Row))
        else if EditorMode then Editor.Left:=Columns[Col].Left-ClientAreaLeft;
    end else
      if aClientAreaLeft>=0 then
        begin
          dec(aClientAreaLeft, ClientAreaLeft);
          if aClientAreaLeft<>0 then
            begin
              aEdLeft:=Editor.Left;
              if not (egfRightToLeft in Flags) then
                begin
                  inc(aEdLeft, aClientAreaLeft);
                  Editor.Left:=aEdLeft;
                  bEdVisible:=((aEdLeft>=FixedColsWidth) and ((aEdLeft+Editor.Width)<=ClientWidth));
                end else
                begin
                  dec(aEdLeft, aClientAreaLeft);
                  Editor.Left:=aEdLeft;
                  bEdVisible:=((aEdLeft>=0) and ((aEdLeft+Editor.Width)<=(ClientWidth-FixedColsWidth)));
                end;
              if bEdVisible<>Editor.Visible then include(Flags, egfRedrawFocusedCell);
              Editor.Visible:=bEdVisible;  { False calls CMExit (for TWinControl only) }
              if (Editor is TWinControl) and TWinControl(Editor).CanFocus then TWinControl(Editor).SetFocus;
            end;
        end;
end;

procedure TCustomECGrid.WMSize(var Message: TLMSize);
begin
  inherited WMSize(Message);
  if PrevClientSize.cx<>ClientWidth then
    begin
      include(Flags, egfCalcBoundCols);
      if egoAutoEnlargeColumns in Options then Flags:=Flags+cHorFlags;
    end;
  if PrevClientSize.cy<>ClientHeight then include(Flags, egfCalcBoundRows);
  if [egfCalcBoundCols, egfCalcBoundRows]*Flags<>[] then
    begin
      Flags:=Flags+cRedrawGrid+[egfResizeBMPs];
      InvalidateNonUpdated;
      PrevClientSize:=Size(ClientWidth, ClientHeight);
    end;
end;

procedure TCustomECGrid.WMVScroll(var Msg: TWMScroll);
var aClientAreaTop, aEdTop, aSelectionPos: Integer;
    bEdVisible: Boolean;
begin
  if (Msg.ScrollCode=SB_THUMBPOSITION) or (not (egoThumbTracking in Options) and not (Msg.ScrollCode in
    [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN, SB_ENDSCROLL])) then exit;  { Exit! }
  include(Flags, egfCalcBoundRows);
  aClientAreaTop:=-1;
  aSelectionPos:=-1;
  if egoScrollKeepVisible in Options then
    begin
      if IsRowVisible(Row) then aSelectionPos:=Row-FirstVisiCell.Y;
    end else
      if EditorMode then aClientAreaTop:=ClientAreaTop;
  inherited WMVScroll(Msg);
  if aSelectionPos>=0 then
    begin
      inc(aSelectionPos, FirstVisiCell.Y);
      if not IsRowFullyVisible(aSelectionPos) then
        if Row<=FirstVisiCell.Y
          then inc(aSelectionPos)
          else if Row>=LastVisiCell.Y then dec(aSelectionPos);
      if Row<>aSelectionPos
        then DoSelection(Col, aSelectionPos, esmNative, False, not IsInSelection(Col, aSelectionPos))
        else if EditorMode then Editor.Top:=FixedRowsHeight+(Row-FixedRows)*RowHeight-ClientAreaTop;
    end else
      if aClientAreaTop>=0 then
        begin
          dec(aClientAreaTop, ClientAreaTop);
          if aClientAreaTop<>0 then
            begin
              aEdTop:=Editor.Top+aClientAreaTop;
              Editor.Top:=aEdTop;
              bEdVisible:=((aEdTop>=FixedRowsHeight) and ((aEdTop+Editor.Height)<=ClientHeight));
              if Editor.Visible<>bEdVisible then include(Flags, egfRedrawFocusedCell);
              Editor.Visible:=bEdVisible;  { False calls CMExit (for TWinControl only) }
              if (Editor is TWinControl) and TWinControl(Editor).CanFocus then TWinControl(Editor).SetFocus;
            end;
        end;
end;

{ TCustomECGrid.G/Setters }

function TCustomECGrid.GetCells(ACol, ARow: Integer): string;
begin
  if ARow>=FixedRows then
    begin
      if assigned(Columns[ACol].OnGetDataCellText)
        then Columns[ACol].OnGetDataCellText(Columns[ACol], ARow-FixedRows, Result)
        else Result:='';
    end else
      if ARow=0
          then Result:=Columns[ACol].Title.Text
          else if assigned(OnGetHeaderText)
                 then OnGetHeaderText(self, ACol, ARow, Result)
                 else Result:='';
end;

function TCustomECGrid.GetCellsOrd(ACol, ARow: Integer): string;
begin
  Result:=Cells[OrderedCols[ACol], ARow];
end;

function TCustomECGrid.GetColCount: Integer;
begin
  Result:=Columns.Count;
end;

function TCustomECGrid.GetColOrd(ACol: Integer): Integer;
begin
  Result:=OrderedCols[ACol];
end;

function TCustomECGrid.GetDataCellsOrd(ACol, ADataRow: Integer): string;
var aColumn: TECGColumn;
begin
  aColumn:=Columns[ACol];
  if assigned(aColumn.OnGetDataCellText)
    then aColumn.OnGetDataCellText(aColumn, ADataRow, Result)
    else Result:='';
end;

function TCustomECGrid.GetDataRow: Integer;
begin
  Result:=Row-FixedRows;
end;

function TCustomECGrid.GetRowCount: Integer;
begin
  Result:=FRowCountHelp;
  if assigned(OnGetDataRowCount) then OnGetDataRowCount(self, Result);
  inc(Result, FixedRows);
end;

procedure TCustomECGrid.SetAlternateColor(AValue: TColor);
begin
  if FAlternateColor=AValue then exit;
  FAlternateColor:=AValue;
  Redraw([egfCalcColors, egfRedrawData]);
end;

procedure TCustomECGrid.SetAlternateTint(AValue: SmallInt);
begin
  AValue:=Math.EnsureRange(AValue, 0, 100);
  if FAlternateTint=AValue then exit;
  FAlternateTint:=AValue;
  Redraw([egfCalcColors, egfRedrawData]);
end;

procedure TCustomECGrid.SetCol(AValue: Integer);
begin
  if FCol=AValue then exit;
  if AValue>=FixedCols then
    if MakeCellFullyVisible(AValue, Row, False)
      then DoSelection(AValue, Row, esmNative, False, True)
      else FCol:=AValue;
end;

procedure TCustomECGrid.SetDataRow(AValue: Integer);
begin
  Row:=AValue+FixedRows;
end;

procedure TCustomECGrid.SetEditorMode(AValue: Boolean);
var bFocused: Boolean;
begin
  if FEditorMode=AValue then exit;
  if not AValue then
    begin
      FEditorMode:=AValue;
      if assigned(Editor) then
        begin
          if Editor.PopupMenu=PopupMenu then Editor.PopupMenu:=nil;
          bFocused:=((Editor is TWinControl) and TWinControl(Editor).Focused);
          Editor.Visible:=False;
          FEditor:=nil;
          if bFocused and CanFocus then SetFocus;
          if not (egoEnlargeAlways in Options) then DoEnlargement(-1, Col);
          Flags:=Flags+[egfRedrawFocusedCell]-[egfCorrectEditorPosX, egfCorrectEditorPosY];
        end;
    end else
      if MakeCellFullyVisible(Col, Row, False) then DoSelection(Col, Row, esmSelect, False);
end;

procedure TCustomECGrid.SetFixedCols(AValue: SmallInt);
begin
  if AValue<0 then AValue:=0;
  if FFixedCols=AValue then exit;
  FFixedCols:=AValue;
  Redraw([egfCalcBoundCols, egfCalcColsLeft, egfClearSelection, egfResizeBMPs, egfUpdateRAWidth]+cRedrawGrid);
end;

procedure TCustomECGrid.SetFixedRowHeight(AValue: SmallInt);
begin
  if FFixedRowHeight=AValue then exit;
  if EditorMode then PrepareEditorDeltaRect(False, True);
  FFixedRowHeight:=AValue;
  FixedRowsHeight:=FixedRows*AValue;
  Redraw([egfCalcBoundRows, egfResizeBMPs, egfUpdateRAHeight]+cRedrawGrid);
end;

procedure TCustomECGrid.SetFixedRows(AValue: SmallInt);
begin
  if FFixedRows=AValue then exit;
  if Row>=FFixedRows then
    begin
      FRow:=FRow+AValue-FFixedRows;
      if EditorMode then
        begin
          PrepareEditorDeltaRect(False, True);
          inc(EditorDeltaRect.Top, (AValue-FFixedRows)*RowHeight);
        end;
    end;
  FFixedRows:=AValue;
  FixedRowsHeight:=AValue*FixedRowHeight;
  Redraw([egfCalcBoundRows, egfClearSelection, egfResizeBMPs, egfUpdateRAHeight]+cRedrawGrid);
end;

procedure TCustomECGrid.SetFocusedCell(AValue: TFocusedCell);
begin
  if FFocusedCell=AValue then exit;
  FFocusedCell:=AValue;
  UpdateCell(Col, Row);
end;

procedure TCustomECGrid.SetGridLineColor(AValue: TColor);
begin
  if FGridLineColor=AValue then exit;
  FGridLineColor:=AValue;
  Redraw([egfRedrawData]);
end;

procedure TCustomECGrid.SetGridLineWidth(AValue: SmallInt);
begin
  if FGridLineWidth=AValue then exit;
  FGridLineWidth:=AValue;
  if Style<>egsFlat
    then Redraw([egfRedrawData])
    else Redraw([egfCalcFixedCellIndent]+cRedrawGrid);
end;

procedure TCustomECGrid.SetImages(AValue: TCustomImageList);
begin
  if FImages=AValue then exit;
  FImages:=AValue;
  Redraw([egfRedrawFixedHeader, egfRedrawFixedRows]);
end;

procedure TCustomECGrid.SetMultiSelect(AValue: TMultiSelect);
begin
  if FMultiSelect=AValue then exit;
  FMultiSelect:=AValue;
  if AValue in [emsNone, emsMultiCell]
    then exclude(Flags, egfRangeSelects)
    else include(Flags, egfRangeSelects);
  if AValue<>emsMultiRange then ClearSelection;
end;

procedure TCustomECGrid.SetOptions(AValue: TGOptions);
const cInvOpts = [egoAutoEnlargeColumns, egoDottedGrid, egoHilightCol, egoHilightRow,
                  egoHorizontalLines, egoSortArrow, egoVerticalLines];
var aChangedOpts: TGOptions;
    aCol: Integer;
begin
  if FOptions=AValue then exit;
  aChangedOpts:=FOptions><AValue;
  FOptions:=AValue;
  aCol:=Col;
  if egoReadOnly in aChangedOpts then EditorMode:=False;
  if (egoEnlargeAlways in aChangedOpts) and (aCol>=0) then
    if egoEnlargeAlways in AValue
      then DoEnlargement(aCol, -1)
      else if not EditorMode then DoEnlargement(-1, aCol);
  if egoAlwaysShowEditor in aChangedOpts then
    if egoAlwaysShowEditor in AValue then
      begin
        if IsCellFullyVisible(aCol, Row) and not (egoReadOnly in AValue) and
          not (ecoReadOnly in Columns[aCol].Options) then DoSelection(ACol, Row, esmNative, False);
      end else
        if EditorMode and not ((Editor is TWinControl) and TWinControl(Editor).Focused) then EditorMode:=False;
  if egoHilightColHeader in aChangedOpts then Redraw([egfRedrawFixedRows]);
  if egoHilightRowHeader in aChangedOpts then Redraw([egfRedrawFixedCols]);
  if not (egoDottedGrid in AValue)
    then GridLinePen.Style:=psSolid
    else GridLinePen.Style:=psDot;
  if not (egoAutoEnlargeColumns in AValue) then AutoEnlargeRatio:=1.0;
  if egoAutoEnlargeColumns in aChangedOpts then
    begin
      EditorMode:=False;
      Redraw(cHorFlags);
    end;
  if aChangedOpts*cInvOpts<>[] then Redraw(cRedrawGrid);
end;

procedure TCustomECGrid.SetRow(AValue: Integer);
begin
  if FRow=AValue then exit;
  if (AValue>=FixedRows) and (AValue<RowCount) then
    if MakeCellFullyVisible(Col, AValue, False)
      then DoSelection(Col, AValue, esmNative, False, True)
      else FRow:=AValue;
end;

procedure TCustomECGrid.SetRowHeight(AValue: SmallInt);
begin
  if AValue<1 then AValue:=1;
  if FRowHeight=AValue then exit;
  if EditorMode then PrepareEditorDeltaRect(False, True);
  FRowHeight:=AValue;
  Redraw([egfCalcBoundRows, egfUpdateRAHeight, egfRedrawFixedCols, egfRedrawData, egfResizeBMPs]);
end;

procedure TCustomECGrid.SetSizableCol(AValue: Integer);
begin
  if FSizableCol=AValue then exit;
  FSizableCol:=AValue;
  ChangeCursor(AValue>=0)
end;

procedure TCustomECGrid.SetSortAscendent(AValue: Boolean);
begin
  if FSortAscendent=AValue then exit;
  FSortAscendent:=AValue;
  if (egoSortArrow in Options) and (Flags*[egfRedrawFixedHeader, egfRedrawFixedRows]=[]) then
    begin
      DrawHeaderCell(SortIndex, 0);
      InvalidateNonUpdated;
    end;
end;

procedure TCustomECGrid.SetSortIndex(AValue: Integer);
var aOldSortIndex: Integer;
begin
  aOldSortIndex:=FSortIndex;
  if aOldSortIndex=AValue then exit;
  FSortIndex:=AValue;
  FSortAscendent:=True;
  if (egoSortArrow in Options) and (Flags*[egfRedrawFixedHeader, egfRedrawFixedRows]=[]) then
    begin
      if InRangeCO(aOldSortIndex, 0, Columns.Count) then DrawHeaderCell(aOldSortIndex, 0);
      if InRangeCO(AValue, 0, Columns.Count) then DrawHeaderCell(AValue, 0);
      InvalidateNonUpdated;
    end;
end;

procedure TCustomECGrid.SetStyle(AValue: TGridStyle);
begin
  if FStyle=AValue then exit;
  FStyle:=AValue;
  Redraw([egfCalcFixedCellIndent, egfRedrawFixedCols, egfRedrawFixedHeader, egfRedrawFixedRows]);
end;

end.



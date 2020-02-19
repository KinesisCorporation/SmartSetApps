unit CocoaHelpers;

{
  Unit of handy routines for use with Cocoa.

  Author:    Phil Hess.
  Copyright: Copyright 2012 Phil Hess.
  License:   Modified LGPL. (see Free Pascal's rtl/COPYING.FPC). 
             This means you can link your code to this compiled unit (statically 
             in a standalone executable or dynamically in a library) without 
             releasing your code. Only changes to this unit need to be made 
             publicly available.

{$MODE Delphi}
{$modeswitch ObjectiveC1}

interface

uses
  SysUtils,
  CGBase,
{$IFDEF NoCocoaAll}
  Foundation,
  AppKit,
{$ELSE}
  CocoaAll,
{$ENDIF}
  NSHelpers;
  
procedure ErrorDlg(const ErrorMsg : string);

procedure DoErrorDlg(const ErrorMsg     : string;
                           ParentWindow : NSWindow);

procedure DoConfirmDlg(const ConfirmMsg   : string;
                             ParentWindow : NSWindow;
                             Delegate     : id;
                             Selector     : SEL);

procedure SetTableHeaderHeight(aTable          : NSTableView;
                               newHeight       : CGFloat;
                               backgroundColor : NSColor);

type
  CustomTableHeaderCell = objcclass(NSTableHeaderCell)
    function initTextCellWithCell(aCell : NSTableHeaderCell) : id; message 'initTextCellWithCell:';
    procedure drawWithFrame_inView(cellFrame: NSRect; controlView_: NSView); override;
    procedure highlight_withFrame_inView(flag: Boolean; cellFrame: NSRect; controlView_: NSView); override;
   end;


implementation

procedure ErrorDlg(const ErrorMsg : string);
 {Display error message modal dialog with OK button.}
var
  Alert : NSAlert;
begin
  Alert := NSAlert.alloc.init;
  Alert.setInformativeText(StrToNSStr(ErrorMsg));
  Alert.runModal;
  Alert.release;
end;


procedure DoErrorDlg(const ErrorMsg     : string;
                           ParentWindow : NSWindow);
 {Display error message dialog with OK button as modal sheet.}
var
  Alert : NSAlert;
begin
  Alert := NSAlert.alloc.init;
  Alert.setInformativeText(StrToNSStr(ErrorMSg));
  Alert.beginSheetModalForWindow_modalDelegate_didEndSelector_contextInfo
   (ParentWindow, nil, nil, nil);  //assume don't need alertDidEndSelector method
end;


procedure DoConfirmDlg(const ConfirmMsg   : string;
                             ParentWindow : NSWindow;
                             Delegate     : id;
                             Selector     : SEL);
 {Display confirm dialog with OK and Cancel buttons as modal sheet.}
var
  Alert : NSAlert;
begin
  Alert := NSAlert.alloc.init;
  Alert.setMessageText(NSSTR('Confirm'));
  Alert.setInformativeText(StrToNSStr(ConfirmMsg));
  Alert.setAlertStyle(NSInformationalAlertStyle);
  Alert.addButtonWithTitle(NSSTR('OK'));  {returnCode=NSAlertFirstButtonReturn}
  Alert.addButtonWithTitle(NSSTR('Cancel'));  {returnCode=NSAlertSecondButtonReturn}
  Alert.beginSheetModalForWindow_modalDelegate_didEndSelector_contextInfo
   (ParentWindow, Delegate, Selector, Alert);
end;


procedure SetTableHeaderHeight(aTable          : NSTableView;
                               newHeight       : CGFloat;
                               backgroundColor : NSColor);
var
  ColIdx : Integer;
  curCol : NSTableColumn;
begin
   {First increase height of table's header view}
  aTable.headerView.setFrameSize(
   NSMakeSize(aTable.headerView.frame.size.width, newHeight));

   {Now replace each column's header cell with a custom cell}
  for ColIdx := 0 to aTable.tableColumns.count-1 do
    begin
    curCol := NSTableColumn(aTable.tableColumns.objectAtIndex(ColIdx));
    curCol.setHeaderCell(CustomTableHeaderCell.alloc.initTextCellWithCell(
                          curCol.headerCell).autorelease);
    curCol.headerCell.setBackgroundColor(backgroundColor);
    curCol.headerCell.setDrawsBackground(True);
    end;

   {Finally, increase height of corner view to match header view}
  aTable.setCornerView(
   NSView.alloc.initWithFrame(
    NSMakeRect(aTable.cornerView.frame.origin.x,
               aTable.cornerView.frame.origin.y,
               aTable.cornerView.frame.size.width,
               aTable.headerView.frame.size.height)).autorelease);
end;  {SetTableHeaderHeight}


function CustomTableHeaderCell.initTextCellWithCell(aCell : NSTableHeaderCell) : id;
 {Initialize cell with specified cell's properties.}
begin
  Result := initTextCell(aCell.stringValue);
  NSTableHeaderCell(Result).setAlignment(aCell.alignment);
  NSTableHeaderCell(Result).setFont(aCell.font);
end;

procedure CustomTableHeaderCell.drawWithFrame_inView(cellFrame: NSRect; controlView_: NSView);
var
 borderFrame   : NSRect;
 interiorFrame : NSRect;
begin
  borderFrame := NSMakeRect(cellFrame.origin.x-1, cellFrame.origin.y,
                            cellFrame.size.width, cellFrame.size.height+1);
  interiorFrame := NSMakeRect(cellFrame.origin.x+1, cellFrame.origin.y+2,
                              cellFrame.size.width-3, cellFrame.size.height-2);
   {So entire cell is filled with background color}
  drawInteriorWithFrame_inView(cellFrame, controlView_);
  NSDrawGroove(borderFrame, borderFrame);
   {Use reduced frame so doesn't write over border}
  drawInteriorWithFrame_inView(interiorFrame, controlView_);
end;

procedure CustomTableHeaderCell.highlight_withFrame_inView(flag: Boolean; cellFrame: NSRect; controlView_: NSView);
begin
   {Highlighting (seleting column) reverts back to short header cell, 
     it appears, so just draw like unhighlighted cell.}
  drawWithFrame_inView(cellFrame, controlView_);
end;


end.

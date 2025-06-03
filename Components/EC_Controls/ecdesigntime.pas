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

unit ECDesignTime;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComponentEditors, Controls, GraphPropEdits, ImgList, LResources, Menus, PropEdits,
  typinfo, ECAccordion, ECBevel, ECCheckListBox, ECConfCurve, ECEditBtns, ECGrid, ECGroupCtrls, ECHeader,
  ECLightView, ECLink, ECImageMenu, ECProgressBar, ECRuler, ECScheme, ECSlider, ECSpinCtrls, ECSwitch,
  ECTabCtrl, ECTriangle;

type
  { TECGridEditor }
  TECGridEditor = class(TComponentEditor)
  protected
    procedure ShowColumnTabMenuItemClick(Sender: TObject);
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure PrepareItem(Index: Integer; const AnItem: TMenuItem); override;
  end;

  { TECTabCtrlEditor }
  TECTabCtrlEditor = class(TComponentEditor)
  protected
    procedure ShowTabMenuItemClick(Sender: TObject);
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure PrepareItem(Index: Integer; const AnItem: TMenuItem); override;
  end;

  { TECAccordionEditor }
  TECAccordionEditor = class(TComponentEditor)
  protected
    procedure ShowAccItemMenuItemClick(Sender: TObject);
  public
    procedure ExecuteVerb(Index: Integer); override;
    function FindUniqueName(const Name: string): string;
    function GetAccordion: TECAccordion;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure PrepareItem(Index: Integer; const AnItem: TMenuItem); override;
  end;

  { THookAccItemSelection }
  THookAccItemSelection = class
  protected
    procedure HookSelection(const ASelection: TPersistentSelectionList);
  end;

  { TECImageIndexPropEdit }
  TECImageIndexPropEdit = class(TImageIndexPropertyEditor)
  protected
    function GetImageList: TCustomImageList; override;
  end;

procedure Register;

implementation

var HookAccItemSelection: THookAccItemSelection;

resourcestring
  { TECGrid }
  rsEGAddC = 'Add Column';
  rsEGInsertC = 'Insert (leftmost)';
  rsEGDelColLm = 'Delete (leftmost)';
  rsEGDelColRm = 'Delete (rightmost)';
  rsEGClearCs = 'Clear Columns';
  rsEGShowC = 'Show Column';
  { TECTabCtrl }
  rsETCAddT = 'Add Tab';
  rsETCInsertT = 'Insert Tab';
  rsETCDeleteT = 'Delete Tab';
  rsETCMoveLeftT = 'Move Left';
  rsETCMoveRightT = 'Move Right';
  rsETCShowT = 'Show Tab';
  { TECAccordion }
  rsEAccAdd = 'Add Item';
  rsEAccInsert = 'Insert Item';
  rsEAccDelete = 'Delete Item';
  rsEAccPrevious = 'Previous Item';
  rsEAccNext = 'Next Item';
  rsEAccMoveUp = 'Move Up';
  rsEAccMoveDown = 'Move Down';
  rsEAccShow = 'Show Item';

{ TECGridEditor }

procedure TECGridEditor.ExecuteVerb(Index: Integer);
var aECG: TECGrid;
    aECGCol: TECGColumn;
    aHook: TPropertyEditorHook;
    i: Integer;
begin
  if Component is TECGrid
    then aECG:=TECGrid(Component)
    else exit;  { Exit! }
  aHook:=nil;
  if not GetHook(aHook) then exit;  { Exit! }
  case Index of
    0: begin
         aECGCol:=aECG.Columns.Add;
         aHook.PersistentAdded(aECGCol, True);
         aHook.SelectOnlyThis(aECGCol);
       end;
    1: begin
         aECGCol:=TECGColumn(aECG.Columns.Insert(0));
         aHook.PersistentAdded(aECGCol, True);
         aHook.SelectOnlyThis(aECGCol);
       end;
    2: begin
         aECGCol:=aECG.Columns[0];
         aHook.DeletePersistent(TPersistent(aECGCol));
       end;
    3: begin
         aECGCol:=aECG.Columns[aECG.ColCount-1];
         aHook.DeletePersistent(TPersistent(aECGCol));
       end;
    4: for i:=aECG.ColCount-1 downto 0 do
         begin
           aECGCol:=aECG.Columns[i];
           aHook.DeletePersistent(TPersistent(aECGCol));
         end;
  end;
end;

function TECGridEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result:=rsEGAddC;
    1: Result:=rsEGInsertC;
    2: Result:=rsEGDelColLm;
    3: Result:=rsEGDelColRm;
    4: Result:=rsEGClearCs;
    5: Result:=rsEGShowC;
  end;
end;

function TECGridEditor.GetVerbCount: Integer;
begin
  Result:=6;
end;

procedure TECGridEditor.PrepareItem(Index: Integer; const AnItem: TMenuItem);
var aECG: TECGrid;
    aMI: TMenuItem;
    i: Integer;
begin
  inherited PrepareItem(Index, AnItem);
  if Index>0 then
    begin
      aECG:=TECGrid(GetComponent);
      AnItem.Enabled:= (aECG.ColCount>0);
      if Index=5 then
        for i:=0 to aECG.ColCount-1 do
          begin
            aMI:=TMenuItem.Create(AnItem);
            aMI.Name:='ShowECCol'+intToStr(i);
            aMI.Caption:='Column'+intToStr(i)+': '+aECG.Columns[i].Title.Text;
            aMI.OnClick:=@ShowColumnTabMenuItemClick;
            AnItem.Add(aMI);
          end;
    end;
end;

procedure TECGridEditor.ShowColumnTabMenuItemClick(Sender: TObject);
var aCol: Integer;
    aECG: TECGrid;
    aHook: TPropertyEditorHook;
    aMI: TMenuItem;
begin
  aECG:=TECGrid(GetComponent);
  aMI:=TMenuItem(Sender);
  if aMI is TMenuItem then
    begin
      aCol:=aMI.MenuIndex;
      if (aCol>=0) or (aCol<aECG.ColCount) then
        begin
          aHook:=nil;
          if not GetHook(aHook) then exit;  { Exit! }
          aECG.Col:=aCol;
          aHook.SelectOnlyThis(aECG.Columns[aCol]);
        end;
    end;
end;

{ TECTabCtrlEditor }

procedure TECTabCtrlEditor.ExecuteVerb(Index: Integer);
var aECTC: TECTabCtrl;
    aECTab: TECTab;
    aHook: TPropertyEditorHook;
begin
  if Component is TECTabCtrl
    then aECTC:=TECTabCtrl(Component)
    else exit;  { Exit! }
  aHook:=nil;
  if not GetHook(aHook) then exit;  { Exit! }
  case Index of
    0: begin
         aECTab:=aECTC.AddTab(etaLast, True);
         aHook.PersistentAdded(aECTab, True);
         aHook.SelectOnlyThis(aECTab);
       end;
    1: begin
         aECTab:=aECTC.AddTab(etaBeside, True);
         aHook.PersistentAdded(aECTab, True);
         aHook.SelectOnlyThis(aECTab);
       end;
    2: begin
        aECTab:=aECTC.Tabs[aECTC.TabIndex];
        aHook.DeletePersistent(TPersistent(aECTab));
       end;
    3: aECTC.MovePrevious();
    4: aECTC.MoveNext();
  end;
end;

function TECTabCtrlEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result:=rsETCAddT;
    1: Result:=rsETCInsertT;
    2: Result:=rsETCDeleteT;
    3: Result:=rsETCMoveLeftT;
    4: Result:=rsETCMoveRightT;
    5: Result:=rsETCShowT;
  end;
end;

function TECTabCtrlEditor.GetVerbCount: Integer;
begin
  Result:=6;
end;

procedure TECTabCtrlEditor.PrepareItem(Index: Integer; const AnItem: TMenuItem);
var aECTC: TECTabCtrl;
    aMI: TMenuItem;
    i: Integer;
begin
  inherited PrepareItem(Index, AnItem);
  aECTC:=TECTabCtrl(GetComponent);
  case Index of
    1: AnItem.Enabled:=(aECTC.Tabs.Count>0);
    2: AnItem.Enabled:=(aECTC.TabIndex>=0);
    3: AnItem.Enabled:=(aECTC.TabIndex>0);
    4: AnItem.Enabled:=(aECTC.TabIndex<(aECTC.Tabs.Count-1));
    5: begin
         AnItem.Enabled:= (aECTC.Tabs.Count>0);
         for i:=0 to aECTC.Tabs.Count-1 do
           begin
             aMI:=TMenuItem.Create(AnItem);
             aMI.Name:='ShowECTab'+intToStr(i);
             aMI.Caption:='Tab'+intToStr(i)+': '+aECTC.Tabs[i].Text;
             aMI.OnClick:=@ShowTabMenuItemClick;
             AnItem.Add(aMI);
           end;
       end;
  end;
end;

procedure TECTabCtrlEditor.ShowTabMenuItemClick(Sender: TObject);
var aECTC: TECTabCtrl;
    aHook: TPropertyEditorHook;
    aMI: TMenuItem;
    aTabIndex: Integer;
begin
  aECTC:=TECTabCtrl(GetComponent);
  aMI:=TMenuItem(Sender);
  if aMI is TMenuItem then
    begin
      aTabIndex:=aMI.MenuIndex;
      if (aTabIndex>=0) or (aTabIndex<aECTC.Tabs.Count) then
        begin
          aHook:=nil;
          if not GetHook(aHook) then exit;  { Exit! }
          aECTC.MakeTabAvailable(aTabIndex, True);
          aHook.SelectOnlyThis(aECTC.Tabs[aTabIndex]);
        end;
    end;
end;

{ TECAccordionEditor }

procedure TECAccordionEditor.ExecuteVerb(Index: Integer);
var aAccItem: TAccordionItem;
    aHook: TPropertyEditorHook;

  procedure AddHelper;
  begin
    aAccItem.Name:=FindUniqueName('AccordionItem');
    aAccItem.Caption:=aAccItem.Name;
    aHook.PersistentAdded(aAccItem, True);
  end;

var aECAcc: TECAccordion;
begin
  aECAcc:=GetAccordion;
  aHook:=nil;
  if not GetHook(aHook) then exit;  { Exit! }
  case Index of
    0: begin
         aAccItem:=aECAcc.AddItem(aECAcc.Owner);
         AddHelper;
       end;
    1: begin
         aAccItem:=aECAcc.InsertItem(aECAcc.Owner, aECAcc.ItemIndex);
         AddHelper;
       end;
    2: begin
         aAccItem:=aECAcc.ActiveItem;
         aHook.PersistentDeleting(aAccItem);
         aECAcc.DeleteItem(aAccItem);
       end;
    3: aECAcc.FindPreviousItem;
    4: aECAcc.FindNextItem;
    5: aECAcc.MoveItemUp;
    6: aECAcc.MoveItemDown;
  end;
  Modified;
end;

function TECAccordionEditor.FindUniqueName(const Name: string): string;
var aFormDesigner: TComponentEditorDesigner;
begin
  aFormDesigner:=GetDesigner;
  Result:=aFormDesigner.UniqueName(Name);
end;

function TECAccordionEditor.GetAccordion: TECAccordion;
begin
  if Component is TECAccordion
    then Result:=TECAccordion(Component)
    else if Component is TAccordionItem
           then Result:=TECAccordion(TAccordionItem(Component).Accordion);
end;

function TECAccordionEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result:=rsEAccAdd;
    1: Result:=rsEAccInsert;
    2: Result:=rsEAccDelete;
    3: Result:=rsEAccPrevious;
    4: Result:=rsEAccNext;
    5: Result:=rsEAccMoveUp;
    6: Result:=rsEAccMoveDown;
    7: Result:=rsEAccShow;
  end;
end;

function TECAccordionEditor.GetVerbCount: Integer;
begin
  Result:=8;
end;

procedure TECAccordionEditor.PrepareItem(Index: Integer; const AnItem: TMenuItem);
var aECAcc: TECAccordion;
    aMI: TMenuItem;
    i: Integer;
begin
  inherited PrepareItem(Index, AnItem);
  aECAcc:=GetAccordion;
  case Index of
    1, 2: AnItem.Enabled:=(aECAcc.ItemIndex>=0);
    3, 5: AnItem.Enabled:=(aECAcc.ItemIndex>0);
    4, 6: AnItem.Enabled:=(aECAcc.ItemIndex<(aECAcc.Count-1));
    7: begin
         AnItem.Enabled:=(aECAcc.Count>0);
         for i:=0 to aECAcc.Count-1 do
           begin
             aMI:=TMenuItem.Create(AnItem);
             aMI.Name:='ShowAccItem'+intToStr(i);
             aMI.Caption:='Item'+intToStr(i)+': '+aECAcc.Items[i].Caption;
             aMI.OnClick:=@ShowAccItemMenuItemClick;
             AnItem.Add(aMI);
           end;
       end;
  end;
end;

procedure TECAccordionEditor.ShowAccItemMenuItemClick(Sender: TObject);
var aECAcc: TECAccordion;
    aHook: TPropertyEditorHook;
    aIndex: Integer;
    aMI: TMenuItem;
begin
  aECAcc:=GetAccordion;
  aMI:=TMenuItem(Sender);
  if aMI is TMenuItem then
    begin
      aIndex:=aMI.MenuIndex;
      if (aIndex>=0) or (aIndex<aECAcc.Count) then
        begin
          aHook:=nil;
          if not GetHook(aHook) then exit;  { Exit! }
          aECAcc.ItemIndex:=aIndex;
          aHook.SelectOnlyThis(aECAcc.Items[aIndex]);
        end;
    end;
end;

{ THookAccItemSelection }

procedure THookAccItemSelection.HookSelection(const ASelection: TPersistentSelectionList);
var aAccItem: TAccordionItem;
    i, aIndex: Integer;

  procedure SearchAccItemInclParents(APersistent: TPersistent);
  begin
    if APersistent is TControl
      then if APersistent is TAccordionItem
             then aAccItem:=TAccordionItem(APersistent)
             else SearchAccItemInclParents(TControl(APersistent).Parent)
      else aAccItem:=nil;
  end;

begin
  for i:=0 to ASelection.Count-1 do
    begin
      SearchAccItemInclParents(ASelection[i]);
      if assigned(aAccItem) then
        begin
          aIndex:=aAccItem.Index;
          if aIndex>=0 then
            begin
              aAccItem.Accordion.ItemIndex:=aIndex;
              break;
            end;
        end;
    end;
end;

{ TECImageIndexPropEdit }

function TECImageIndexPropEdit.GetImageList: TCustomImageList;
var aObj: TObject;
    aPersistent: TPersistent;
    aPropInfo: PPropInfo;
begin
  Result:=nil;
  aPersistent:=GetComponent(0);
  if aPersistent=nil then exit;  { Exit! }
  if (aPersistent is TCustomECSpeedBtn) or (aPersistent is TCustomECBitBtn) or (aPersistent is TBaseECSlider) then
    begin
      aPropInfo:=TypInfo.GetPropInfo(TComponent(aPersistent), 'Images');
      if aPropInfo=nil then exit;  { Exit! }
      aObj:=GetObjectProp(TComponent(aPersistent), aPropInfo);
      if aObj is TCustomImageList then Result:=TCustomImageList(aObj);
    end else
    if TObject(aPersistent) is TSingleSpinBtn then
      begin
        aPropInfo:=TypInfo.GetPropInfo(TSingleSpinBtn(TObject(aPersistent)).Parent, 'Images');
        if aPropInfo=nil then exit;  { Exit! }
        aObj:=GetObjectProp(TSingleSpinBtn(TObject(aPersistent)).Parent, aPropInfo);
        if aObj is TCustomImageList then Result:=TCustomImageList(aObj);
      end;
end;

procedure Register;
begin
  {$I ecbevel.lrs}
  {$I eclink.lrs}
  {$I ecimagemenu.lrs}
  {$I ecspinctrls.lrs}
  {$I eceditbtns.lrs}
  {$I echeader.lrs}
  {$I ecchecklistbox.lrs}
  {$I ecslider.lrs}
  {$I ecprogressbar.lrs}
  {$I ecruler.lrs}
  {$I ecgroupctrls.lrs}
  {$I ecaccordion.lrs}
  {$I ectriangle.lrs}
  {$I ecgrid.lrs}
  {$I eclightview.lrs}
  {$I ecconfcurve.lrs}
  {$I ecscheme.lrs}
  RegisterComponents('EC-C', [TECBevel, TECLink, TECImageMenu, TECSpinBtns, TECSpinEdit,
    TECSpinController, TECTimer, TECSwitch, TECSpeedBtn, TECBitBtn, TECEditBtn, TECColorBtn,
    TECComboBtn, TECColorCombo, TECHeader, TECCheckListBox, TECSlider, TECProgressBar,
    TECPositionBar, TECSpinPosition, TECRuler, TECRadioGroup, TECCheckGroup, TECTabCtrl,
    TECAccordion, TECTriangle, TECGrid, TECLightView, TECConfCurve, TECScheme]);
  RegisterPropertyEditor(TypeInfo(TCaption), TECSpeedBtn, 'Caption', TStringMultilinePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TCaption), TECBitBtn, 'Caption', TStringMultilinePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TCaption), TImageMenuItem, 'Description', TStringMultilinePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), TECLightView, 'TextData', TStringMultilinePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TSingleSpinBtn, 'ImageIndex', TECImageIndexPropEdit);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TBaseECSlider, 'ImageIndex', TECImageIndexPropEdit);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TECSpeedBtn, 'ImageIndex', TECImageIndexPropEdit);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TECSpeedBtn, 'ImageIndexChecked', TECImageIndexPropEdit);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TECBitBtn, 'ImageIndex', TECImageIndexPropEdit);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TECBitBtn, 'ImageIndexChecked', TECImageIndexPropEdit);
  RegisterComponentEditor(TECTabCtrl, TECTabCtrlEditor);
  RegisterNoIcon([TAccordionItem]);
  RegisterComponentEditor(TECAccordion, TECAccordionEditor);
  GlobalDesignHook.AddHandlerSetSelection(@HookAccItemSelection.HookSelection);
  RegisterComponentEditor(TAccordionItem, TECAccordionEditor);
  RegisterComponentEditor(TECGrid, TECGridEditor);
end;

initialization

  HookAccItemSelection:=THookAccItemSelection.Create;

finalization

  if assigned(HookAccItemSelection) then HookAccItemSelection.Free;

end.



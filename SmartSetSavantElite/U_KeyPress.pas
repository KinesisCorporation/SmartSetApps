unit U_KeyPress;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls, ComCtrls, FileUtil, u_const, u_key_service, u_keys;

type

  TMouseEvent = (meNone, meLeftClick, meMiddleClick, meRightClick);

  { TForm_KeyPress }

  TForm_KeyPress = class(TForm)
    pmuSpecial: TPopupMenu;
    miLeftMouseClick: TMenuItem;
    miRightMouseClick: TMenuItem;
    miMiddleMouseClick: TMenuItem;
    pcMain: TPageControl;
    tsMain: TTabSheet;
    tsConfig: TTabSheet;
    memoKeys: TMemo;
    rbSingle: TRadioButton;
    rbMultiple: TRadioButton;
    btnSpecial: TButton;
    btnLeftPedal: TButton;
    btnRightPedal: TButton;
    btnCenterPedal: TButton;
    pnlBot: TPanel;
    btnSave: TButton;
    lblCopyright: TLabel;
    btnClear: TButton;
    memoLeft: TMemo;
    memoCenter: TMemo;
    memoRight: TMemo;
    btnCancel: TButton;
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miHelp: TMenuItem;
    miExit: TMenuItem;
    miAbout: TMenuItem;
    miConfigGuide: TMenuItem;
    lblInfo: TLabel;
    lblInfo2: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memoKeysKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure memoKeysKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rbSingleClick(Sender: TObject);
    procedure rbMultipleClick(Sender: TObject);
    procedure btnSpecialClick(Sender: TObject);
    procedure miLeftMouseClickClick(Sender: TObject);
    procedure miRightMouseClickClick(Sender: TObject);
    procedure miMiddleMouseClickClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLeftPedalClick(Sender: TObject);
    procedure btnCenterPedalClick(Sender: TObject);
    procedure btnRightPedalClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
  private
    { Private declarations }
    pedalIdx: integer;
    filePath: string;
    keyService: TKeyService;
    procedure SetKeyPress(Key: Word; Shift: TShiftState; MouseEvent: TMouseEvent);
    procedure SetActiveTab(idx:integer);
    function SaveFile(keyIdx: integer; pedalText: string; isMacro: boolean): boolean;
    function LoadTextFromFile: boolean;
    function SetTextPedal(pedal: string; textPedal: string; isMacro: boolean): string;
    function GetTextPedal(pedalText: string): string;
    procedure SetConfig;
  public
    { Public declarations }
  end;

var
  Form_KeyPress: TForm_KeyPress;

implementation

{$R *.lfm}

const
   LEFT_PEDAL_IDX = 0;
   CENTER_PEDAL_IDX = 1;
   RIGHT_PEDAL_IDX = 2;
   LEFT_PEDAL_TEXT = 'lpedal';
   CENTER_PEDAL_TEXT = 'mpedal';
   RIGHT_PEDAL_TEXT = 'rpedal';
   fileName = 'pedals.txt';

procedure TForm_KeyPress.FormCreate(Sender: TObject);
var
   year, month, day: word;
begin
   DecodeDate(now, year, month, day);
   SetActiveTab(0);
   pedalIdx := -1;
   lblCopyright.Caption := 'Beta configuration tool.                              ' +
      'Copyright CreoSource Inc.  ' + IntToStr(year);
   memoLeft.Height := 60;
   memoCenter.Height := 60;
   memoRight.Height := 60;
   lblInfo.Color := self.Color;
   filePath := 'F:\active';//ExtractFilePath(Application.ExeName) + 'active';
   LoadTextFromFile;
   keyService := TKeyService.create;
end;

procedure TForm_KeyPress.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
   FreeAndNil(keyService);
end;

procedure TForm_KeyPress.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	SetKeyPress(Key, Shift, meNone);
end;

procedure TForm_KeyPress.memoKeysKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   SetKeyPress(Key, Shift, meNone);
end;

procedure TForm_KeyPress.memoKeysKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TForm_KeyPress.SetConfig;
var
   tempKey: TKey;
begin
   keyService.ConfigKeys.Add(tempKey.create(VK_ESCAPE, 'Escape', '[escape]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_PAUSE, 'Pause/break', '[pause]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_PRINT, 'Print Screen', '[prtscr]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_SCROLL, 'Scroll lock', '[scroll]'));

   keyService.ConfigKeys.Add(tempKey.create(VK_F1, 'F1', '[F1]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F2, 'F2', '[F2]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F3, 'F3', '[F3]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F4, 'F4', '[F4]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F5, 'F5', '[F5]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F6, 'F6', '[F6]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F7, 'F7', '[F7]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F8, 'F8', '[F8]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F9, 'F9', '[F9]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F10, 'F10', '[F10]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F11, 'F11', '[F11]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_F12, 'F12', '[F12]'));

   keyService.ConfigKeys.Add(tempKey.create(VK_0, '0', '[0]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_1, '1', '[1]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_2, '2', '[2]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_3, '3', '[3]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_4, '4', '[4]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_5, '5', '[5]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_6, '6', '[6]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_7, '7', '[7]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_8, '8', '[8]'));
   keyService.ConfigKeys.Add(tempKey.create(VK_9, '9', '[9]'));

   keyService.ConfigKeys.Add(tempKey.create(Ord('='), 'plus/equal', '[=]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('-'), 'hypen', '[hypen]'));

   keyService.ConfigKeys.Add(tempKey.create(Ord('a'), 'a', '[a]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('b'), 'b', '[b]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('c'), 'c', '[c]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('d'), 'd', '[d]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('e'), 'e', '[e]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('f'), 'f', '[f]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('g'), 'g', '[g]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('h'), 'h', '[h]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('i'), 'i', '[i]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('j'), 'j', '[j]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('k'), 'k', '[k]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('l'), 'l', '[l]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('m'), 'm', '[m]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('n'), 'n', '[n]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('o'), 'o', '[o]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('p'), 'p', '[p]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('q'), 'q', '[q]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('r'), 'r', '[r]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('s'), 's', '[s]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('t'), 't', '[t]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('u'), 'u', '[u]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('v'), 'v', '[v]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('w'), 'w', '[w]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('x'), 'x', '[x]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('y'), 'y', '[y]'));
   keyService.ConfigKeys.Add(tempKey.create(Ord('z'), 'z', '[z]'));
end;

procedure TForm_KeyPress.SetActiveTab(idx: integer);
var
   i:integer;
begin
   for i := 0 to pcMain.PageCount - 1 do
   begin
      pcMain.Pages[i].TabVisible := false;
   end;
   pcMain.ActivePageIndex  := idx;
end;

procedure TForm_KeyPress.rbSingleClick(Sender: TObject);
begin
	memoKeys.Text := '';
end;

procedure TForm_KeyPress.rbMultipleClick(Sender: TObject);
begin
	memoKeys.Text := '';
end;

procedure TForm_KeyPress.btnSpecialClick(Sender: TObject);
var
  pt : tPoint;
begin
   pt := Mouse.CursorPos;
	pmuSpecial.Popup(pt.x, pt.y);
end;

procedure TForm_KeyPress.miLeftMouseClickClick(Sender: TObject);
begin
	SetKeyPress(0, [], meLeftClick);
end;

procedure TForm_KeyPress.miMiddleMouseClickClick(Sender: TObject);
begin
	SetKeyPress(0, [], meMiddleClick);
end;

procedure TForm_KeyPress.miRightMouseClickClick(Sender: TObject);
begin
	SetKeyPress(0, [], meRightClick);
end;

procedure TForm_KeyPress.SetKeyPress(Key: Word; Shift: TShiftState;
  MouseEvent: TMouseEvent);
var
	value: string;
   aKey: TKey;
begin
	value := '';
   aKey := nil;
   if pcMain.ActivePageIndex <> 1 then
      exit;
      
	if MouseEvent <> meNone then
   begin
   	if MouseEvent = meLeftClick then
   		value := 'lmouse'
      else if MouseEvent = meMiddleClick then
      	value := 'mmouse'
      else if MouseEvent = meRightClick then
      	value := 'rmouse';
   end
   else
   begin
      {if key = VK_RETURN then
         value := 'enter'
      else if key = VK_ESCAPE then
         value := 'escape'
      else if key = VK_SPACE then
         value := 'space'
      else
         value := Chr(Key); }
      aKey := keyService.FindKeyConfig(Key);
   end;

   if aKey <> nil then
   begin
      showmessage(aKey.Name);
      if rbSingle.Checked then
      begin
         memoKeys.Text := aKey.Name ;
      end
      else
      begin
         if memoKeys.Text <> '' then
            memoKeys.Text := memoKeys.Text + '+';
         memoKeys.Text := memoKeys.Text + '{-' + aKey.Name + '}+{+' + aKey.Name + '}';
      end;
   end;
end;

procedure TForm_KeyPress.btnClearClick(Sender: TObject);
begin
   memoKeys.Text := '';
end;

procedure TForm_KeyPress.btnSaveClick(Sender: TObject);
begin
   case pedalIdx of
      LEFT_PEDAL_IDX: memoLeft.Text := memoKeys.Text;
      CENTER_PEDAL_IDX: memoCenter.Text := memoKeys.Text;
      RIGHT_PEDAL_IDX: memoRight.Text := memoKeys.Text;
   end;
   SaveFile(pedalIdx, memoKeys.Text, rbMultiple.Checked);
   SetActiveTab(0);
end;

procedure TForm_KeyPress.btnLeftPedalClick(Sender: TObject);
begin
   pedalIdx := LEFT_PEDAL_IDX;
   memoKeys.Text := memoLeft.Text;
   SetActiveTab(1);
end;

procedure TForm_KeyPress.btnCenterPedalClick(Sender: TObject);
begin
   pedalIdx := CENTER_PEDAL_IDX;
   memoKeys.Text := memoCenter.Text;
   SetActiveTab(1);
end;

procedure TForm_KeyPress.btnRightPedalClick(Sender: TObject);
begin
   pedalIdx := RIGHT_PEDAL_IDX;
   memoKeys.Text := memoRight.Text;
   SetActiveTab(1);
end;

procedure TForm_KeyPress.btnCancelClick(Sender: TObject);
begin
   SetActiveTab(0);
end;

procedure TForm_KeyPress.miExitClick(Sender: TObject);
begin
   Application.Terminate;
end;

function TForm_KeyPress.SetTextPedal(pedal: string; textPedal: string; isMacro: boolean): string;
begin
   if isMacro then
      result := '{' + pedal + '}' + '>' + textPedal
   else
      result := '[' + pedal + ']' + '>[' + textPedal + ']';
end;

function TForm_KeyPress.GetTextPedal(pedalText: string): string;
var
   iPos: integer;
begin
   result := '';
   if pedalText <> '' then
   begin
      iPos := pos('>', pedalText);
      if iPos > 0 then
      begin
         result := Copy(pedalText, iPos + 1, length(pedalText));
         if Copy(pedalText, 1, 1) = '[' then
            result := Copy(result, 2, Length(result) - 2);
      end;
   end;
end;

function TForm_KeyPress.SaveFile(keyIdx: integer; pedalText: string; isMacro: boolean): boolean;
var
  slFile: TStringList;
  i:integer;
  pedal: string;
begin
   result := false;
   pedal := '';
   isMacro := isMacro and (pedalText <> ''); //Un macro seulement si texte <> ''
   if (keyIdx >= 0) then
   begin
      if not DirectoryExistsUTF8(filePath) { *Converted from DirectoryExists* } then
         ForceDirectoriesUTF8(filePath); { *Converted from ForceDirectories* }
      slFile := TStringList.Create;
      try
         if (FileExistsUTF8(filePath + '\' + fileName) { *Converted from FileExists* }) or (FileGetAttrUTF8(filePath + '\' + fileName) { *Converted from FileGetAttr* } > 0) then
         begin
            slFile.LoadFromFile(filePath + '\' + fileName);
            for i := 0 to slFile.Count - 1 do
            begin
               case keyIdx of
                  LEFT_PEDAL_IDX:
                     if Copy(slFile.Strings[i], 2, LENGTH(LEFT_PEDAL_TEXT)) = LEFT_PEDAL_TEXT then
                        pedal := LEFT_PEDAL_TEXT;
                  CENTER_PEDAL_IDX:
                     if Copy(slFile.Strings[i], 2, LENGTH(CENTER_PEDAL_TEXT)) = CENTER_PEDAL_TEXT then
                        pedal := CENTER_PEDAL_TEXT;
                  RIGHT_PEDAL_IDX:
                     if Copy(slFile.Strings[i], 2, LENGTH(RIGHT_PEDAL_TEXT)) = RIGHT_PEDAL_TEXT then
                        pedal := RIGHT_PEDAL_TEXT;
               end;

               if pedal <> '' then
               begin
                  slFile.Strings[i] := SetTextPedal(pedal, pedalText, isMacro);
                  pedal := '';
               end;
            end;
         end
         else
         begin
            case keyIdx of
               LEFT_PEDAL_IDX:
               begin
                  slFile.Add(SetTextPedal(LEFT_PEDAL_TEXT, pedalText, isMacro));
                  slFile.Add('[' + CENTER_PEDAL_TEXT + ']>[mmouse]');
                  slFile.Add('[' + RIGHT_PEDAL_TEXT + ']>[rmouse]');
               end;
               CENTER_PEDAL_IDX:
               begin
                  slFile.Add('[' + LEFT_PEDAL_TEXT + ']>[lmouse]');
                  slFile.Add(SetTextPedal(CENTER_PEDAL_TEXT, pedalText, isMacro));
                  slFile.Add('[' + RIGHT_PEDAL_TEXT + ']>[rmouse]');
               end;
               RIGHT_PEDAL_IDX:
               begin
                  slFile.Add('[' + LEFT_PEDAL_TEXT + ']>[lmouse]');
                  slFile.Add('[' + CENTER_PEDAL_TEXT + ']>[mmouse]');
                  slFile.Add(SetTextPedal(RIGHT_PEDAL_TEXT, pedalText, isMacro));
               end;
            end;
         end;
         slFile.SaveToFile(filePath + '\' + fileName);
      finally
         FreeAndNil(slFile);
      end;
   end;
end;

function TForm_KeyPress.LoadTextFromFile: boolean;
var
  slFile: TStringList;
  i:integer;
begin
   if DirectoryExistsUTF8(filePath) { *Converted from DirectoryExists* } then
   if (FileExistsUTF8(filePath + '\' + fileName) { *Converted from FileExists* }) or (FileGetAttrUTF8(filePath + '\' + fileName) { *Converted from FileGetAttr* } > 0) then
   begin
      slFile := TStringList.Create;
      try
         slFile.LoadFromFile(filePath + '\' + fileName);
         for i := 0 to slFile.Count - 1 do
         begin
            if (Copy(slFile.Strings[i], 2, LENGTH(LEFT_PEDAL_TEXT)) = LEFT_PEDAL_TEXT) then
               memoLeft.Text := GetTextPedal(slFile.Strings[i])
            else if Copy(slFile.Strings[i], 2, LENGTH(CENTER_PEDAL_TEXT)) = CENTER_PEDAL_TEXT then
               memoCenter.Text := GetTextPedal(slFile.Strings[i])
            else if Copy(slFile.Strings[i], 2, LENGTH(RIGHT_PEDAL_TEXT)) = RIGHT_PEDAL_TEXT then
               memoRight.Text := GetTextPedal(slFile.Strings[i]);
         end;
      finally
         FreeAndNil(slFile);
      end;
   end;
end;

procedure TForm_KeyPress.miAboutClick(Sender: TObject);
begin
   ShowMessage('BETA USB Pedal Configuration tool for Savant Elite 2 devices' + #10#13 +
      'Copyright 2014 - CreoSource Inc.');
end;

end.

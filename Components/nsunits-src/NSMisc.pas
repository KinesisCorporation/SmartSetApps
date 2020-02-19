unit NSMisc;

{
  Misc. Foundation-based routines.

  Author:    Phil Hess.
  Copyright: Copyright 2012 Phil Hess.
  License:   Modified LGPL (see Free Pascal's rtl/COPYING.FPC).
             This means you can link your code to this compiled unit (statically 
             in a standalone executable or dynamically in a library) without 
             releasing your code. Only changes to this unit need to be made 
             publicly available.
}

{$mode delphi}
{$modeswitch objectivec1}

interface

uses
  SysUtils,
{$IF DEFINED(IPHONESIM) OR DEFINED(CPUARM) OR DEFINED(CPUAARCH64)}  //iOS
 {$IFDEF NoiPhoneAll}
  Foundation,
 {$ELSE}
  iPhoneAll,
 {$ENDIF}
{$ELSE}  //macOS
 {$IFDEF NoCocoaAll}
  Foundation,
 {$ELSE}
  CocoaAll,
 {$ENDIF}
{$ENDIF}
  NSHelpers;

function GetInfoPlistString(const KeyName : string) : string;

function GetInfoPlistUTF8String(const KeyName : string) : AnsiString;


function GetPrefString(const KeyName : string) : string;

function GetPrefUTF8String(const KeyName : string) : string;

procedure SetPrefString(const KeyName : string;
                        const Value   : string);

procedure SetPrefUTF8String(const KeyName : string;
                            const Value   : AnsiString);


function GetResourcesPath : string;

function GetDocumentsPath : string;


implementation

function GetInfoPlistString(const KeyName : string) : string;
 {Retrieve key's string value from app bundle's Info.plist file.
   String returned is encoded using NSStrToStr's default encoding.}
begin
  Result := NSStrToStr(NSBundle.mainBundle.objectForInfoDictionaryKey(
                        StrToNSStr(KeyName)));
end;


function GetInfoPlistUTF8String(const KeyName : string) : AnsiString;
 {Retrieve key's string value from app bundle's Info.plist file.
   String returned is encoded as UTF8.}
begin
  Result := NSBundle.mainBundle.objectForInfoDictionaryKey(StrToNSStr(KeyName)).
             UTF8String;
end;


function GetPrefString(const KeyName : string) : string;
 {Retrieve key's string value from preferences.
   String returned is encoded using NSStrToStr's default encoding.}
begin
  Result := NSStrToStr(NSUserDefaults.standardUserDefaults.stringForKey(
                        StrToNSStr(KeyName)));
end;


function GetPrefUTF8String(const KeyName : string) : AnsiString;
 {Retrieve key's string value from preferences.
   String returned is encoded as UTF8.}
begin
  Result := NSUserDefaults.standardUserDefaults.stringForKey(
             StrToNSStr(KeyName)).UTF8String;
end;


procedure SetPrefString(const KeyName : string;
                        const Value   : string);
 {Set key's string value in preferences.
   Value is assumed to be in StrToNSStr's default encoding.}
begin
  NSUserDefaults.standardUserDefaults.setObject_forKey(
   StrToNSStr(Value), StrToNSStr(KeyName));
end;


procedure SetPrefUTF8String(const KeyName : string;
                            const Value   : AnsiString);
 {Set key's string value in preferences.
   Value is assumed to be encoded in UTF8.}
begin
  NSUserDefaults.standardUserDefaults.setObject_forKey(
   Utf8StrToNSStr(Value), StrToNSStr(KeyName));
end;


function GetResourcesPath : string;
 {On OS X, returns path to Resources folder in app bundle;
   on iOS, returns path to app bundle.
  If called from console app, returns app executable's folder.}
begin
  Result := NSStrToStr(NSBundle.mainBundle.resourcePath);
end;


function GetDocumentsPath : string;
 {On OS X, returns path to user's Documents folder;
   on iOS, returns path to app's Documents folder.
  Can also use URLForDirectory_inDomain_appropriateForURL_create_error
   on OS X 10.6, iOS 4.0 and later.}
var
  paths : NSArray;
begin
  paths := NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, True);
  Result := NSStrToStr(paths.objectAtIndex(0));
end;


end.

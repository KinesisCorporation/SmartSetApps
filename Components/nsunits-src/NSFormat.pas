unit NSFormat;

{
  Foundation-based routine for populating a TFormatSettings record.

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
  Foundation;
 {$ELSE}
  iPhoneAll;
 {$ENDIF}
{$ELSE}  //macOS
 {$IFDEF NoCocoaAll}
  Foundation;
 {$ELSE}
  CocoaAll;
 {$ENDIF}
{$ENDIF}

procedure GetNSFormatSettings(var FmtSettings : TFormatSettings;
                                  LocaleId    : string = '');
 {
  Populate FmtSettings record using NSDateFormatter and NSNumberFormatter
   settings from user's preferences or a specified locale.

  If LocaleId is not passed or is a blank string, the user's preferences
   are used (these will be the same as the user locale's defaults if the
   user has not changed them).
   
  If LocaleId is specified, use that locale's default settings. Note that 
   LocaleId must be a valid locale identifier, which is a combination of 
   language and region designations (for example, en_US). More information 
   is here:
     http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/
      BPInternational/Articles/LanguageDesignations.html
      #//apple_ref/doc/uid/20002144-BBCEGGFF

  Examples of use:
    GetNSFormatSettings(DefaultFormatSettings);
     //Set the global SysUtils record based on user's preferences.
     //Note that the global FormatSettings record is declared absolute to 
     // DefaultFormatSettings, as are the deprecated global variables with
     // the same names as the TFormatSettings fields (ShortDataFormat, etc.).

    GetNSFormatSettings(MyFormatSettings, 'en_GB');
     //Set your own record based on English/Great Britain locale's settings.
     
    GetNSFormatSettings(MyFormatSettings, GetNSCurrentLocaleId);
     //Set your own record based on user locale's defaults.

  Tip: Compile with NSFORMAT_DEBUG defined to output to the console the strings
   returned by NSDateFormatter that are used as the basis for ShortDateFormat, 
   LongDatFormat, ShortTimeFormat and LongTimeFormat.

  Note: String fields in the FmtSettings record are set to the UTF8-encoded
   strings returned by TDateFormatter and TNumberFormatter. In many cases, 
   these strings will consist only of single-byte ASCII chars. However, some
   settings will contain multi-byte Unicode chars with some locales. For 
   example, the currency symbol returned in CurrencyString is often a Unicode 
   code point (for example, with UTF8 encoding, the British pound symbol is 
   two bytes, while the Euro symbol is three bytes). To properly display these 
   Unicode chars in a Cocoa or Cocoa Touch control, convert them to an NSString 
   using the NSHelpers unit's Utf8StrToNSStr function.

  Note: There does not appear to be any way to obtain the CurrencyFormat, 
   NegCurrFormat and CurrencyDecimals settings. If you need these settings
   in a Cocoa app, include the clocale unit somewhere in your code - the 
   clocale unit will initialize these fields in DefaultFormatSettings using 
   Unix function calls. Do not use the clocale unit in an iOS app since the 
   Unix functions do not return the expected values there. For more information, 
   see FPC's rtl/unix/clocale.pp and rtl/bsd/clocale.inc files. Note that the 
   locale's currency symbol _is_ available (see CurrencyString below).
 }


function GetNSCurrentLocaleId : string;

 {Convenience function for returning user's current locale ID.
   Pass this to GetNSFormatSettings to override user changes
   to locale's defaults.}


implementation

function UniToRtlDateFormat(const DateStr   : string;
                                  IsLongFmt : Boolean) : string;
 {Convert Unicode date format symbols to Pascal RTL date format
   symbols.
  Since ShortDateFormat should only contain d, m, y and separator
   chars, strip out other alphanumeric chars if IsLongFmt is False.
  A list of Unicode date format symbols is here:
   http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns}
var
  CharPos : Integer;
begin
  Result := '';
  for CharPos := 1 to Length(DateStr) do
    begin
    case DateStr[CharPos] of
      'y' : Result := Result + 'y';
      'M' : Result := Result + 'm';
      'd' : Result := Result + 'd';
    else if IsLongFmt or 
            (not (DateStr[CharPos] in ['A'..'Z','a'..'z','0'..'9'])) then
      Result := Result + DateStr[CharPos];
      end;
    end;

  Result := StringReplace(Result, 'mmmmm', 'mmm', []);
   {"Narrow" (single-char) month name not supported by Pascal RTL,
      so substitute month abbreviation}

  if not IsLongFmt then  {ShortDateFormat?}
    begin  {StrToDate can't handle alphabetic chars in dates}
    Result := StringReplace(Result, 'mmmm', 'mm', []);
    Result := StringReplace(Result, 'mmm', 'mm', []);
    end;

  if (Pos('yy', Result) = 0) and (Pos('y', Result) > 0) then
    Result := StringReplace(Result, 'y', 'yyyy', []);
     {A single y results in a year with as many digits as needed, but
       no equivalent in RTL, so substitute 4-digit year with assumption
       that normally working with current dates (4-digit years).}
  Result := Trim(Result);
end;


function UniToRtlTimeFormat(const TimeStr : string) : string;
 {Convert Unicode time format symbols to Pascal RTL time format
   symbols.
  A list of Unicode time format symbols is here:
   http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns}
var
  CharPos : Integer;
begin
  Result := '';
  for CharPos := 1 to Length(TimeStr) do
    begin
    case TimeStr[CharPos] of
      'h', 'H', 'k', 'K' : Result := Result + 'h';
      'm' : Result := Result + 'n';
      's' : Result := Result + 's';
      'S' : Result := Result + 'z';
      'a' : Result := Result + 'ampm';
    else if not (TimeStr[CharPos] in ['A','z','Z','v','V']) then
      Result := Result + TimeStr[CharPos];
      end;
    end;
  Result := Trim(Result);
end;


function GetSepChar(const FormatStr : string) : Char;
 {Look for the date or time separator character in the
   format string.}
var
  CharPos : Integer;
begin
  Result := ' ';
  for CharPos := 1 to Length(FormatStr) do
    begin  {Return first non-alphanumeric char in format string as separator}
    if not (FormatStr[CharPos] in ['A'..'Z','a'..'z','0'..'9']) then
      begin
      Result := FormatStr[CharPos];
      Exit;
      end;
    end;
end;


procedure GetNames(var RtlNames : array of string;
                       NSNames  : NSArray);
 {Copy NS names to RTL array.}
var
  NameIdx : Integer;
begin
  for NameIdx := 0 to High(RtlNames) do
    begin
    if NameIdx < NSNames.Count then
      RtlNames[NameIdx] := NSString(NSNames.objectAtIndex(NameIdx)).UTF8String;
    end;
end;


procedure GetNSFormatSettings(var FmtSettings : TFormatSettings;
                                  LocaleId    : string = '');

{$IFDEF NSFORMAT_DEBUG}
  procedure OutputSetting(const SettingName : string;
                          const NSSetting   : string;
                          const RtlSetting  : string);
  begin
    WriteLn(Format('%0:-27S%1:-20S%2:-20S', 
                   [SettingName, NSSetting, RtlSetting]));
  end;
{$ENDIF}

var
  dateFormatter   : NSDateFormatter;
  locale          : NSLocale;
  numberFormatter : NSNumberFormatter;
begin
  if (LocaleId <> '') and
     (not NSLocale.availableLocaleIdentifiers.containsObject(
          NSString.stringWithUTF8String(PChar(LocaleId)))) then
    LocaleId := '';  {Locale not available, so just ignore it}

  dateFormatter := NSDateFormatter.alloc.init;
  if LocaleId <> '' then
    begin
    locale := NSLocale.alloc.initWithLocaleIdentifier(
               NSString.stringWithUTF8String(PChar(LocaleId)));
    dateFormatter.setLocale(locale);
    end;

  dateFormatter.setDateStyle(NSDateFormatterShortStyle);
  FmtSettings.ShortDateFormat :=
   UniToRtlDateFormat(dateFormatter.dateFormat.UTF8String, False);
{$IFDEF NSFORMAT_DEBUG}
  OutputSetting('Setting name', 'NS setting', 'RTL setting');
  WriteLn;
  OutputSetting('ShortDateFormat', dateFormatter.dateFormat.UTF8String, 
                FmtSettings.ShortDateFormat);
{$ENDIF}
  dateFormatter.setDateStyle(NSDateFormatterLongStyle);
  FmtSettings.LongDateFormat :=
   UniToRtlDateFormat(dateFormatter.dateFormat.UTF8String, True);
  FmtSettings.DateSeparator := GetSepChar(FmtSettings.ShortDateFormat);
{$IFDEF NSFORMAT_DEBUG}
  OutputSetting('LongDateFormat', dateFormatter.dateFormat.UTF8String, 
                FmtSettings.LongDateFormat);
{$ENDIF}

  FmtSettings.TwoDigitYearCenturyWindow :=
   NSCalendar.currentCalendar.components_fromDate(
    NSYearCalendarUnit, NSDate.date).year -   
   NSCalendar.currentCalendar.components_fromDate(
    NSYearCalendarUnit, dateFormatter.twoDigitStartDate).year;

  GetNames(FmtSettings.ShortMonthNames, dateFormatter.shortMonthSymbols);
  GetNames(FmtSettings.LongMonthNames, dateFormatter.monthSymbols);
  GetNames(FmtSettings.ShortDayNames, dateFormatter.shortWeekdaySymbols);
  GetNames(FmtSettings.LongDayNames, dateFormatter.weekdaySymbols);

  dateFormatter.setDateStyle(NSDateFormatterNoStyle);
  dateFormatter.setTimeStyle(NSDateFormatterShortStyle);
  FmtSettings.ShortTimeFormat := 
   UniToRtlTimeFormat(dateFormatter.dateFormat.UTF8String);
{$IFDEF NSFORMAT_DEBUG}
  OutputSetting('ShortTimeFormat', dateFormatter.dateFormat.UTF8String, 
                FmtSettings.ShortTimeFormat);
{$ENDIF}
  dateFormatter.setTimeStyle(NSDateFormatterLongStyle);
  FmtSettings.LongTimeFormat := 
   UniToRtlTimeFormat(dateFormatter.dateFormat.UTF8String);
  FmtSettings.TimeSeparator := GetSepChar(FmtSettings.ShortTimeFormat);
{$IFDEF NSFORMAT_DEBUG}
  OutputSetting('LongTimeFormat', dateFormatter.dateFormat.UTF8String, 
                FmtSettings.LongTimeFormat);
{$ENDIF}

  FmtSettings.TimeAMString := dateFormatter.AMSymbol.UTF8String;
  FmtSettings.TimePMString := dateFormatter.PMSymbol.UTF8String;

  dateFormatter.release;

  numberFormatter := NSNumberFormatter.alloc.init;
  if LocaleId <> '' then
    begin
    numberFormatter.setLocale(locale);
    locale.release;
    end;
  FmtSettings.DecimalSeparator := 
   numberFormatter.decimalSeparator.UTF8String[0];
  FmtSettings.ThousandSeparator := 
   numberFormatter.groupingSeparator.UTF8String[0];
  FmtSettings.CurrencyString := numberFormatter.currencySymbol.UTF8String;
  numberFormatter.release;
end;  {GetNSFormatSettings}


function GetNSCurrentLocaleId : string;
begin
  Result := NSLocale.currentLocale.localeIdentifier.UTF8String;
end;


end.

program testnsfmt;

{
  Cocoa test program for NSFormat unit.
}

{$mode delphi}

uses SysUtils, NSFormat, clocale;  
 //comment out clocale to see uninitialized SysUtils defaults


procedure BeforeAfter(const SettingName : string;
                      const BeforeStr   : string;
                      const AfterStr    : string;
                      const ExampleStr  : string = '');
begin
  WriteLn(Format('%0:-27S%1:-20S%2:-20S%3:-20S', 
                 [SettingName, BeforeStr, AfterStr, ExampleStr]));
end;


var
  SaveFmtSettings : TFormatSettings;
  ExampleStr      : string;
begin

  SaveFmtSettings := DefaultFormatSettings;

  GetNSFormatSettings(DefaultFormatSettings);  //test user preferences
//  GetNSFormatSettings(DefaultFormatSettings, 'en_US');  //test English/U.S.
//  GetNSFormatSettings(DefaultFormatSettings, 'en_GB');  //test English/Britain
//  GetNSFormatSettings(DefaultFormatSettings, 'de_DE');  //test German/Germany
//  GetNSFormatSettings(DefaultFormatSettings, 'xx_XX');  //test invalid locale
//  GetNSFormatSettings(DefaultFormatSettings,  //test user's locale
//                      NSLocale.currentLocale.localeIdentifier.UTF8String);
  
  WriteLn;
  BeforeAfter('Setting name', 'clocale', 'NSFormat', 'Example');
  WriteLn;

  BeforeAfter('ShortDateFormat', SaveFmtSettings.ShortDateFormat, 
              ShortDateFormat, DateToStr(Now));  //DateToStr uses ShortDateFormat
  DateTimeToString(ExampleStr, 'dddddd', Now);  //use LongDateFormat
  BeforeAfter('LongDateFormat', SaveFmtSettings.LongDateFormat, 
              LongDateFormat, ExampleStr);
  BeforeAfter('DateSeparator', SaveFmtSettings.DateSeparator, 
              DateSeparator);
  BeforeAfter('TwoDigitYearCenturyWindow', 
              IntToStr(SaveFmtSettings.TwoDigitYearCenturyWindow),
              IntToStr(TwoDigitYearCenturyWindow));
  BeforeAfter('ShortMonthNames[1]', SaveFmtSettings.ShortMonthNames[1], 
              ShortMonthNames[1]);
  BeforeAfter('LongMonthNames[1]', SaveFmtSettings.LongMonthNames[1], 
              LongMonthNames[1]);
  BeforeAfter('ShortDayNames[1]', SaveFmtSettings.ShortDayNames[1], 
              ShortDayNames[1]);
  BeforeAfter('LongDayNames[1]', SaveFmtSettings.LongDayNames[1], 
              LongDayNames[1]);

  DateTimeToString(ExampleStr, 't', Now);  //use ShortTimeFormat
  BeforeAfter('ShortTimeFormat', SaveFmtSettings.ShortTimeFormat, 
              ShortTimeFormat, ExampleStr);
  BeforeAfter('LongTimeFormat', SaveFmtSettings.LongTimeFormat, 
              LongTimeFormat, TimeToStr(Now));  //TimeToStr uses LongTimeFormat
  BeforeAfter('TimeSeparator', SaveFmtSettings.TimeSeparator, TimeSeparator);
  BeforeAfter('TimeAMString', SaveFmtSettings.TimeAMString, TimeAMString);
  BeforeAfter('TimePMString', SaveFmtSettings.TimePMString, TimePMString);

  BeforeAfter('DecimalSeparator', SaveFmtSettings.DecimalSeparator, 
              DecimalSeparator);
  BeforeAfter('ThousandSeparator', SaveFmtSettings.ThousandSeparator, 
              ThousandSeparator);

  BeforeAfter('CurrencyString', SaveFmtSettings.CurrencyString, 
              CurrencyString);
  BeforeAfter('CurrencyFormat', IntToStr(CurrencyFormat), 
              IntToStr(CurrencyFormat));  //how to set w/o clocale?
  BeforeAfter('NegCurrFormat', IntToStr(NegCurrFormat), 
              IntToStr(NegCurrFormat));  //how to set w/o clocale?
  BeforeAfter('CurrencyDecimals', IntToStr(CurrencyDecimals), 
              IntToStr(CurrencyDecimals));  //how to set w/o locale?

  BeforeAfter('ListSeparator', SaveFmtSettings.ListSeparator, 
              ListSeparator);  //how to set?

end.

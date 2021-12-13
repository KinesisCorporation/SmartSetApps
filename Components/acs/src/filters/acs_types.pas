(*
Base types

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

unit acs_types;

interface

type

  // 32 bit
  TAcsBuffer32 = array[0..0] of Int32;
  PAcsBuffer32 = ^TAcsBuffer32;

  TAcsStereoSample32 = packed record
    Left: Int32;
    Right: Int32;
  end;

  TAcsStereoBuffer32 = array[0..0] of TAcsStereoSample32;
  PAcsStereoBuffer32 = ^TAcsStereoBuffer32;

  // 16 bit
  TAcsBuffer16 = array[0..0] of Int16;
  PAcsBuffer16 = ^TAcsBuffer16;

  TAcsStereoSample16 = packed record
    Left: Int16;
    Right: Int16;
  end;

  TAcsStereoBuffer16 = array[0..0] of TAcsStereoSample16;
  PAcsStereoBuffer16 = ^TAcsStereoBuffer16;

  // 8 bit
  TAcsBuffer8 = array[0..0] of Byte;
  PAcsBuffer8 = ^TAcsBuffer8;

  TAcsStereoSample8 = packed record
    Left: Byte;
    Right: Byte;
  end;

  TAcsStereoBuffer8 = array[0..0] of TAcsStereoSample8;
  PAcsStereoBuffer8 = ^TAcsStereoBuffer8;

  // complex
  TAcsComplex = packed record
    Re: Double;
    Im: Double;
  end;
  PAcsComplex = ^TAcsComplex;

  TAcsArrayOfComplex = array of TAcsComplex;
  //TAcsComplexArray = array[0..0] of TAcsComplex;
  //PAcsComplexArray = ^TAcsComplexArray;

  // double
  TAcsArrayOfDouble = array of Double;
  //PAcsArrayOfDouble = ^TAcsArrayOfDouble;

  TAcsStereoSampleD = record
    Left: Double;
    Right: Double;
  end;

  TAcsStereoBufferD = array[0..0] of TAcsStereoSampleD;
  PAcsStereoBufferD = ^TAcsStereoBufferD;

const

  Pi = 3.14159265359;
  TwoPi = 6.28318530718;
  HalfPi = 1.57079632679;

implementation

end.

{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

Unit gifviewer_pkg;

{$warn 5023 off : no warning about unused units}
Interface

uses
  uFastBitmap, uGIFViewer_Register, GifViewerStrConsts, LazarusPackageIntf;

Implementation

Procedure Register;
Begin
  RegisterUnit('uGIFViewer_Register', @uGIFViewer_Register.Register);
End;

Initialization
  RegisterPackage('gifviewer_pkg', @Register);
End.

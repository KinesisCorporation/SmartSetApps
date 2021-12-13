{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit laz_acs;

{$warn 5023 off : no warning about unused units}
interface

uses
  acs_reg, acs_properties, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('acs_reg', @acs_reg.Register);
end;

initialization
  RegisterPackage('laz_acs', @Register);
end.

{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit eccontrols;

{$warn 5023 off : no warning about unused units}
interface

uses
  ECTypes, ECScale, ECBevel, ECLink, ECImageMenu, ECSpinCtrls, ECSwitch, ECEditBtns, ECHeader, ECCheckListBox, 
  ECSlider, ECProgressBar, ECRuler, ECGroupCtrls, ECTabCtrl, ECAccordion, ECTriangle, ECGrid, ECConfCurve, ECScheme, 
  ECLightView, ECDesignTime, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ECDesignTime', @ECDesignTime.Register);
end;

initialization
  RegisterPackage('eccontrols', @Register);
end.

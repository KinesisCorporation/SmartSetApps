Unit uGIFViewer_Register;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, LResources, LazarusPackageIntf,
  LazIDEIntf, propedits, // Pour l'integration de l'éditeur de propriété dans l'EDI
  uGifViewer;

{ Enregistrement du composant et de l'editeur de propriété dans l'EDI }
Procedure Register;

Implementation

{%region=====[ Intégration EDI ]================================================}



Type
  TGIFViewerFileNamePropertyEditor = Class(TFileNamePropertyEditor)
  Public
    Function GetFilter: String; Override;
    Function GetInitialDirectory: String; Override;
  End;


Function TGIFViewerFileNamePropertyEditor.GetFilter: String;
Begin
  Result := 'Graphic Interchange Format |*.gif';
End;

Function TGIFViewerFileNamePropertyEditor.GetInitialDirectory: String;
Begin
  Result := ExtractFilePath(LazarusIDE.ActiveProject.ProjectInfoFile);
End;

Procedure Register;
Begin
  RegisterComponents('Beanz Extra', [TGIFViewer]);
  RegisterPropertyEditor(TypeInfo(String),
    TGIFViewer, 'FileName', TGIFViewerFileNamePropertyEditor);
End;

{%endregion%}
initialization
  {$I ..\Resources\gifviewer_icon.lrs}

End.


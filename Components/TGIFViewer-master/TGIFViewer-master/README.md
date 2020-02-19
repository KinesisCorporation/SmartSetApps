# TGIFViewer :eyes:
TGIFViewer  composant visuel pour l'affichage d'animations au fromat GIF (Graphic Interchange Format) avec Free Pascal et Lazarus 

###  Compatibilité : **Windows, Linux et MacOS**

## Capacités de TGIFViewer :
- Chargement depuis un stream, un fichier ou une resource (**fonctions LoadFromStream, LoadFromFile, LoadFromResource**)
- Extraction des images brute (**fonction DisplayRawFrame)
- Extraction des images pré-calculées de l'animation (**fonction DisplayFrame** )
- Affichage avec ou sans transparence (**Transparent**)
- Gestion silencieuse de certaines données mal encodées pour permette l'affichage des images sans perturber l'utilisateur
- Gestion des erreurs pour les fichiers mal compressé" (**OnLoadError**)
- Centrer (**Center**), redimensionnement (**Stretch**) l'affichage 
- Dimension du composant automatique en fonction de l'image (**AutoSize**)
- Evèment à la lecture, l'arrêt ou la mise en pause de l'animation (**OnStart, OnPause, OnStop**)
- Accès aux images et informations du GIF via la propiété **Frames.Items[x]**

:information_source: **Contient également 2 unités** :
- uFastBitmap : Classe pour la manipulation de bitmap 32 bit au format RGBA ou BGRA suivant l'OS
- BZApplicationTranslator : Classe d'aide à la traduction d'application basée sur un composant de [Gilles Vasseurs](https://www.developpez.net/forums/u600183/gvasseur58/)

:information_source: Vous pouvez télécharger [GIF-ImageTestSuite](https://github.com/jdelauney/GIF-ImageTestSuite) pour tester avec plusieurs GIF encodés différemment

## Installation :
1) Dans Lazarus allez dans le menu "Paquet" et sélectionnez "Ouvrir un fichier de paquet (".lpk") 
2) Sélectionnez **gifviewer_pkg.lpk** du dossier **Package**
3) Cliquez sur le bouton "Compiler"
4) Cliquez sur le bouton "Utiliser" puis "Installer"

Le composant **TGIFViewer** sera installé dans la section **Beanz Extra**

### Note :
L'application de démonstration **GifView** du dossier **Demos** ne nécessite pas l'installation du composant dans l'EDI pour fonctionner.
Elle est également multilanguage (Anglais/Français). Copier simplement le dossier languages dans le dossier de sortie de l'executable

## Licence : **MPL**
#### :copyright: 2018 J.Delauney (BeanzMaster)

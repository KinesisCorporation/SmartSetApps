Unit GifViewerStrConsts;

{$mode objfpc}{$H+}

Interface

ResourceString
  // Messages d'erreurs ou de notifications
  // Error or notification messages
  //uGifViewer
  rsScreenBadColorSize       = 'Nombre de couleur dans la palette globale invalide.';
  rsImageBadColorSize        = 'Nombre de couleur dans la palette locale invalide.';
  rsBadSignature             = 'Signature GIF invalide : %s';
  rsBadScreenSize            = 'Dimension de l''image Invalides : %dx%d';
  rsEmptyColorMap            = 'Erreur aucune palette de couleur disponible pour cette image !';
  rsEmptyImage               = 'L''Image est vide';
  rsUnknownVersion           = 'Version GIF inconnue';
  rsFileNotFound             = 'Le fichier %s est introuvable !';
  rsResourceNotFound         = 'Resource %s not found !';
  rsBufferOverFlow           = 'Image #%d : Le décodeur s''est arrêté pour empêcher un débordement de tampon';
  rsInvalidOutputBufferSize  = 'Image #%d : La taille du tampon de sortie est invalide ( Taille <= 0)';
  rsInvalidInputBufferSize   = 'Image #%d : La taille du tampon d''entrée est invalide ( Taille <= 0)';
  rsInvalidBufferSize        = 'Image #%d : La taille du tampon d''entrée et de sortie sont invalides ( Taille <= 0)';
  rsLZWInternalErrorOutputBufferOverflow = 'Dépassement du buffer de sortie dans le décodeur GIF LZW. Signaler ce bug. C''est un bug sérieux !';
  rsLZWInternalErrorInputBufferOverflow  = 'Dépassement du buffer d''entrée dans le décodeur GIF LZW. Signaler ce bug. C''est un bug sérieux !';
  rsLZWInvalidInput         = 'Image #%d : Le décodeur a rencontré une entrée invalide (données corrompues)';
  rsLZWOutputBufferTooSmall  = 'Image #%d : Le décodeur n''a pas pu décoder toutes les données car le tampon de sortie est trop petit';
  rsAllFrameCorrupted        = 'Toutes les images dans le GIF sont corrompue. Fichier GIF. Affichage impossible';
  //uFastBitmap
  rsBitmapCreateError = 'Erreur lors de la création du TBitmap';
  rsBitmapScanlineOutOfRange = 'Scanline : Indice hors limite';

Implementation

End.


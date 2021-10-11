object Form1: TForm1
  Left = 233
  Top = 130
  Width = 880
  Height = 649
  Caption = 'xxx'
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = Menu0
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object BOOK: TPageControl
    Left = 8
    Top = 104
    Width = 841
    Height = 481
    ActivePage = Page1
    TabOrder = 0
    object Page0: TTabSheet
      Caption = 'Page 0'
      object Memo1: TMemo
        Left = 16
        Top = 129
        Width = 441
        Height = 256
        Lines.Strings = (
          
            'Ce Tmemo n'#39'est la que pour vous permettre de voir immediatement ' +
            'l'#39'utilisation de la '
          'fonction "imprimer" du menu'
          ''
          
            '(vous pouvez l'#39'imprimer ! des le lancement de l'#39'application (vid' +
            'e) '
          ''
          
            'L'#39'editeur du module impression (RichEdit) est completement indep' +
            'endant du TMEMO : '
          
            'vous pouvez donc le modifier, le formater, cela ne modifie pas l' +
            'e TMEMO origine'
          
            'vous pouvez sauvegarder la mise en forme sous un nom quelconque ' +
            '(.rtf de '
          'preference)'
          ''
          
            'Le Memo est charge autrement par le premier clic sur un des ongl' +
            'ets : '
          
            'a titre indicatif bien sur, cette faculte peut etre supprimee si' +
            ' non necessaire a l'#39'application '
          'a developper'
          'la page ouverte correspondante devient le parent du Memo.'
          
            'il faut bien sur le charger par un string h au niveau de la proc' +
            'edure privee : '
          'procedure TForm1.BOOKChange(Sender: TObject);'
          ''
          
            'L'#39'option [ <<< ] du menu (en haut a gauche) permet de minimiser ' +
            'l'#39'application d'#39'une facon '
          'plus sympa que celle de windows !')
        TabOrder = 0
      end
    end
    object Page1: TTabSheet
      Tag = 1
      Caption = 'Page 1'
      ImageIndex = 1
      object Memo2: TMemo
        Left = 64
        Top = 24
        Width = 385
        Height = 297
        Lines.Strings = (
          
            'cette mini application (VIDE !) me permet a chaque nouveau proje' +
            't, de partir '
          'directement avec un fond standard comportant deja :'
          'en standard :'
          
            '- un module d'#39'impression des fichiers memo que pourra comporter ' +
            'la fiche'
          '- un dispositif de minimisation original'
          
            '- un TPageControl ave 3 TTabSheet (a modifier ou supprimer suiva' +
            'nt besoin)'
          
            '- une unite "utilitaire" SYSTUS.pas qui regroupe les differentes' +
            ' fonctions et '
          
            'procedures utilisables notamment pour la gestion de Tstringlist ' +
            'comme moyen '
          
            'de stockage de toutes les informations de l'#39'application a realis' +
            'er'
          ''
          
            'il suffit de copier les fichiers suivant dans un repertoire XXXX' +
            ' et de lancer le '
          'dpr avec Delphi'
          
            'Si vous souhaitez utiliser SYSTUS.pas dans d'#39'autres applications' +
            ', il est '
          'recommander de le mettre dans le repertoire c:\Program '
          
            'Files\Borland\Delphi7\Lib\ (suivant votre installation et versio' +
            'n de Delphi)')
        TabOrder = 0
      end
    end
    object Page2: TTabSheet
      Tag = 2
      Caption = 'Page 2'
      ImageIndex = 2
      object Memo3: TMemo
        Left = 184
        Top = 24
        Width = 585
        Height = 129
        Lines.Strings = (
          'Le module d'#39'impression n'#39'est pas de moi'
          
            'Je l'#39'utilise depuis des annees, en le bidouillant de temps a aut' +
            're'
          'Je ne connais plus son auteur que je remercie beaucoup'
          '')
        TabOrder = 0
      end
    end
  end
  object Menu0: TMainMenu
    Left = 272
    object Mini0: TMenuItem
      Caption = '[ <<< ]'
      OnClick = Mini0Click
    end
    object Imprimer1: TMenuItem
      Caption = 'Imprimer'
      OnClick = Imprimer1Click
    end
    object propos1: TMenuItem
      Caption = 'a propos'
      OnClick = propos1Click
    end
    object Quitter1: TMenuItem
      Caption = 'Quitter'
      OnClick = Quitter1Click
    end
  end
  object O1: TOpenDialog
    Left = 160
  end
  object S1: TSaveDialog
    Left = 192
  end
end

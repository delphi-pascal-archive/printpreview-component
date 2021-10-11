unit Unit1;

//============================================================================
{================================} interface {================================}
//============================================================================


{==================================} uses {===================================}

  Windows
  , Menus
  , Classes
  , Controls
  , StdCtrls    // pour Tbutton
  , dialogs
  //, Graphics     // pour utilisation "clgreen"
  , Forms
  , SysUtils
  , systus      // librairie personnelle
  , ExtCtrls
  , ComCtrls, TabNotBk

;

{==============================================================================}
{=================================} Const {===================================}
{==============================================================================}

///************************ standard ***************
Titre       = 'XXXXX';                  // à modifier
Version     = ' - 1.00.0';              // à modifier
VersionDate = '3 novembre 2012';        // à modifier


///************************ spécifique *************

// ....

{==============================================================================}
{===================================} type {===================================}
{==============================================================================}

  TForm1 = class(TForm)   // décor !
    Menu0: TMainMenu;
           Mini0:    TMenuItem;
           propos1:  TMenuItem;
           Quitter1: TMenuItem;
    O1: TOpenDialog;
    S1: TSaveDialog;
    Imprimer1: TMenuItem;
    BOOK: TPageControl;
    Page0: TTabSheet;
    Page1: TTabSheet;
    Page2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;        // changer le nom si nécessaire


  //********************************************************
  //**************** Procedures Standard *******************
  //********************************************************
    procedure QUITTER;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Quitter1Click(Sender: TObject);
    procedure propos1Click(Sender: TObject);
    procedure Mini0Click(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
  private
    procedure Imprimer(var M:Tmemo);
        { Déclarations privées }
  public
  end;

//============================================================================
{===================================} var {===================================}
//============================================================================

Form1 : TForm1;
//FIC   : string;       // nom fichier de base
//LX    : TstringList;  // Tlist de base : CHG(FIC,LX);
TeteG : string = 'Tete Gauche';    // vous pouvez (devez) modifier ces variables
TeteC : string = 'Tete Centre';    // en fonctions du document à imprimer avant
TeteD : string = 'Tete Droite';    // de lancer l'impression, donc par exemple au
Pied  : string = Titre + version;  // chargement du memo
// exemple
// procedure TForm1.ChargeMemoClient;
// begin
// TeteG := 'CR Réunion';
// TeteC := 'Rapport du 15 septembre 2012';
// TeteD := '';
// Pied  := FIC;   (nom du fichier source par exemple)

//----------------------- VAR Spécifiques :

// ....

//-----------------------------------------


//============================================================================
{=============================} implementation {=============================}
//============================================================================
uses umini, main;
{$R *.dfm}

///*****************************************************************************
///*********************************** STANDARD ********************************
///*****************************************************************************

//------------------------------------------------------------------------------
// function  DirParam:string;  voir Systus
function  DirAppli:string;
begin result := extractFilePath(application.ExeName) end;

//-------------------------------------------------------------------- à propos
procedure TForm1.propos1Click(Sender: TObject);
begin  msg3(Titre + version,VersionSystus,'RD ' + VersionDate); end;

//--------------------------------------------------------------------- QUITTER
procedure TForm1.Quitter1Click(Sender: TObject); begin QUITTER end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
    begin if nonoui('Sauvegarder') then application.Terminate else QUITTER end;
procedure TForm1.QUITTER;
begin
if BLOQ then exit; // on ne peut pas sortir en mode blocage
// FRE(LX);
application.Terminate
end;

//---------------------------------------------------------------------- CREATE
procedure TForm1.FormCreate(Sender: TObject);
begin
Form1.Menu  := Menu0;
FormStyle   := fsNormal;
BorderIcons := [biSystemMenu,biMinimize,biMaximize];
BorderStyle := bsSizeable;   // si taille ajustable
//INI(LX);
if paramcount>0
   then SetCurrentDIR(Dirparam)
   else SetCurrentDIR(DirAppli);
Caption := Titre +  version;
BOOK.Align := AlClient;
end;

//--------------------------------------------------------------------- MINIMIZE
procedure TForm1.Mini0Click(Sender: TObject); begin Fmini.mini end;


//-----------------------------------------------------------------  IMPRIMER
// attention : ne fonctionne que si un TMEMO est posé sur un des onglets
procedure TForm1.Imprimer1Click(Sender: TObject);
begin
case BOOK.TabIndex of
  0 : imprimer(Memo1);      // changer le nom du mémo si nécessaire
  1 : imprimer(Memo2);      // changer le nom du mémo si nécessaire
  2 : imprimer(Memo3);      // changer le nom du mémo si nécessaire
  // ....
  end;
end;
//------------------------
procedure TForm1.Imprimer(var M:Tmemo);
begin
FrmMain.creation;
FrmMain.Richedit1.lines := M.lines;
FrmMain.show;
end;


///*****************************************************************************
///********************************* SPECIFIQUE ********************************
///*****************************************************************************

// ....

end.

//==============================================================================
     Unit SYSTUS;  // compile de gestH et de ALIAS  ex SYSTUS9
//==============================================================================
    INTERFACE
//==============================================================================
{  version c:\program files\Borland\lib
historique :                                  chercher ## pour modifs en cours
  /1 : Compilation de
      -  AliasVersion = '/4'; (08/01/2010)
      -  Gest Hversion 4      (28/01/2010)
  /2 : ajouté MSG2 et MSG3
  /3 :  07/11/2010 : ajouté VIS et EFF pour Tlabel
  /4 :  30/11/2010 : Ajouté PosEx pour ceux qui n'ont pas Delphi 7
  /4a : 01/12/2010 : Modifié compatibilité versions antérieures à Delphi 7
  /4b : 07/12/2010 : Modifié SvgH se SYSTUS pour que les lignes du mémo ne
                     soient pas fragmentées lors de la sauvegarde :
                     ajouté memo.wordwrap:=false avant la SVG.
  / changement de nom  SYSTUS --> SYSTUS9
  /5  : 02/12/2010 : Ajout Séparateur ; modifiable
  /6  : 12/12/2010 : Ajout gestion TStringList
  /6a : 13/12/2010 : Ajouté INI(O) et FRE(O)
  /6b : 20/01/2011 : Ajout TriMaj(z))
  /7  : ajouté HGET, HPUT et HXOF
  /8  : ajouté module DBUG
  /9  : ajouté Vdate  , Retour à SYSTUS
  /10 : ajouté gestion BLOQ , Str0 , CodH,DcoH
  /11 : ajouté MOT et gestion DEBUG
  /12 : 20/07/11 : MàJ INI et FRE suite modif CIREC
  /13 : 28/07/11 : modifié SvgH et ChgH de TMemo pour non coupure des lignes
  /14 : 18/08/11 : modifié GestH avec possibilité multi séparateur
  /15 : modifié GestH c:= ';' par défaut  - Aouté function PosN
  /16 : remis Ksep pour que les anciennes applications fonctionnent !!
  /17 : modifié HTRF (T -> O) pour aller plus vite
  /18 : modif diverses, ajout nonnum,oknum ...
  /18b : modifié msg, msg2 et msg3
  /19  : Modifié VIS et EFF : unique avec TWinControl
  /20  : Ajouté NDATE
  }

uses StdCtrls,ExtCtrls,StrUtils,SysUtils,graphics,dialogs,classes,controls,DateUtils;

{=============================} const {=============================}

SystusVersion = '/19';
VersionSYSTUS = 'SYSTUS version ' + SystusVersion;
// couleurs
marron    = clmaroon;  // $000080;
rouge     = clRed;     // $0000ff;
orange    = $00a5ff;   // clOrange  
jaune     = clyellow;  // $00ffff;
olive     = clOlive;   // $008080;
pourpre   = clpurple;  // $800080;
violet    = clfuchsia; // $ff00ff;
vertclair = cllime;    // $00ff00;
lime      = cllime;    // $00ff00;
vert      = clgreen;   // $008000;
marine    = clnavy;    // $800000;
navy      = clnavy;    // $800000;
bleu      = clblue;    // $ff0000;
cyan      = claqua;    // $ffff00;
teal      = clteal;    // $808000;
noir      = clblack;   // $000000;
blanc     = clwhite;   // $ffffff;
gris      = clgray;    // $808080;
argent    = clsilver;  // $c0c0c0;

Gras         :TFontStyles = [fsbold];
Maigre       :TFontStyles = [];
Italique     :TFontStyles = [fsitalic];
GrasItalique :TFontStyles = [fsbold,fsitalic];

coma = ';';
days:array[1..7] of string= (
     'Dimanche',
     'Lundi',
     'Mardi',
     'Mercredi',
     'Jeudi',
     'Vendredi',
     'Samedi' );
rc = chr(10)+chr(13);     
KDEBUG = 'Debug.log';   // fichier à consulter après anomalie

{=============================} type {=============================}

str4  = string[4];
TXY = record
   x:integer;
   y:integer;
   end;

TABLO  = object
      LS  : TStringList;
      TAG : integer;
      FLG : boolean;
      TXT : string;
      dC  : integer;
      vC  : Variant;

      //------ commun ---------------
      procedure INI;
      procedure DEF(n:integer; v:variant);
      procedure FRE;
      procedure RAZ;
      procedure CHG(fic:string);
      procedure SVG(fic:string);
      function  QTE:integer;      		     // count
      function  DER:integer;      		     // count -1
      //------ standard ---------------
      function  LIG(L:integer):string;
      function  Text:string;                 	// LS.text;
      procedure ADD(z:string);
      procedure INS(L:integer; z:string);
      function  XOF(z:string; var N:integer):boolean;      	// indexof
      procedure ECR(L:integer; z:string);
      procedure DEL(L:integer);
      //------ GestH ---------------
      function  GET(L,C:integer):variant;	    // Récupère la valeur (L,C)
      procedure PUT(L,C:integer; v:variant);	// Ecrit le varaint dans la case (L,C)
      procedure INC(L,C:integer; v:integer=1);
      procedure DEC(L,C:integer; v:integer=1);
      //------ Hstring ---------------
      procedure ChgH(H:string);    	    // s dand LS
      function  SvgH:string;        		// result = LS
      procedure hADD(H:string);
      procedure hDEL(c:integer);
      procedure hECR(c:integer; H:string);
      function  hXOF(z:string; var L:integer; var C:integer):boolean;
      procedure ACQ(o:Tmemo);        overload;
      procedure ACQ(o:TListBox);     overload;
      procedure ACQ(o:TComboBox);    overload;
      procedure ACQ(o:TStringList);  overload;

      end;

TMultiImage = Object
     PAN  : Tpanel;
     IMG  : Timage;
     X    : integer;    // coordonée X du panel
     Y    : integer;    // coordonée Y du panel
     iMax : integer;    // Nombre de vues max dans l'image
     IX   : integer;    // index Vue courante
     procedure INI(z:string; xx,yy:integer; Pere:TWinControl);
     procedure CHG(z:string);
     procedure FRE;
     procedure VIS(n:integer);
     procedure EFF;
     end;


///=========================================================================================
///=========================================================================================

{=============================} var {=============================}

kSEP   : string;
BUG    : variant;
DBUG   : integer;
XBLOQX : boolean;
LDEBUG : TstringList;
FDEBUG : boolean=false;


//========================== Procédures et functions =================

{ADD}   // ajoute la chaine Z à liste/memo
{AFF}   //  remplace le caption/text par Z
{CHG}   // Charge liste/memo avec contenu du fichier fic
{ChgH}  // charge Liste/memo avec une chaine de type GestH
{DEL}   // supprime la ligne n
{DER}   // renvoie le dernier n° de ligne valide (count - 1)
{ECR}   // remplace la ligne n par la chaine Z
{EFF}   // Liste/memo/bouton/panel/edit = invisible
{FILTRE}// crée le "filter" : filtre(O,'Tous','*') -> 'Tous (*.*)|*.*'
{IDX}   // renvoie l'index courant (itemindex)
{INS}   // insère une ligne après la ligne l, avec chaine Z
{LIG}   // renvoie le texte de la ligne n
{NDX}   // Positionne l'index courant à n
{QTE}   // renvoie le nombre de lignes  (count)
{RAZ}   // clear Liste/mémo
{Style} // modifie le style de la fonte de l'objet
{SVG}   // Sauvegarde Liste/memo dans le fichier fic
{SvgH}  // renvoie le contenu de Liste/memo dans une chaine de type GestH
{Taille}// modifie la taille de la fonte de l'objet
{TXT}   // renvoie le texte de la ligne courante
{VIS}   // Liste/memo/bouton/panel/edit = visible, placé au dessus
{XOF}   // renvoie 1er n°ligne comportant chaine z
        // (endroit quelconque, majus/minus, si e=1 ou omis)
//  HPUT(O,l,c,V)  : ecrit V dans colonne c de la ligne l
// *HGET(O,l,c):V  : renvoi contenu de la colonne c de la ligne l
// *HXOFxy(O,v,L,C):boolean : retourne true et L,C si v existe

//------------------------------------------------------------------- TlistBox
procedure ADD(var O:TlistBox; z:string);        overload
Procedure CHG(var O:Tlistbox; fic:string);      overload
procedure ChgH(var O:Tlistbox; H:string);       overload
procedure DEF(var O:Tlistbox; X,Y,L,H:integer); overload  
procedure DEL(var O:Tlistbox;  l:integer);      overload
function  DER(var O:TlistBox):integer;          overload
procedure ECR(var O:TListBox; n:integer; z:string); overload
//Procedure EFF(var O:Tlistbox);                  overload   supprimé par #19
function  IDX(var O:TListBox):integer;          overload
procedure INS(var O:Tlistbox;  l:integer; z:string); overload
function  LIG(var O:TlistBox; n:integer):string;     overload
procedure NDX(var O:TlistBox; n:integer);      overload
function  QTE(var O:TlistBox):integer;         overload
Procedure RAZ(var O:Tlistbox);                 overload
procedure Style(var O:Tlistbox;  S:TFontStyles);  overload
Procedure SVG(var O:Tlistbox; fic:string);     overload
function  SvgH(var O:Tlistbox):string;         overload
procedure Taille(var O:Tlistbox;  n:integer);  overload
function  TXT(var O:TListBox):string;          overload
//Procedure VIS(var O:Tlistbox);                 overload    supprimé par #19
function  XOF(var O:TListBox; z:string; e:integer=1):integer; overload
function  HXOF(var O:TListBox; v:variant; var L:integer; var C:integer):boolean; overload
procedure HPUT(var O:TListBox; l,c:integer; V:variant); overload
function  HGET(var O:TListBox; l,c:integer):variant;     overload

//------------------------------------------------------------------- TcomboBox
procedure ADD(var O:TcomboBox; z:string);            overload
Procedure CHG(var O:TcomboBox; fic:string);          overload
procedure ChgH(var O:TcomboBox; H:string);           overload
procedure DEL(var O:Tcombobox; l:integer);           overload
function  DER(var O:TComboBox):integer;              overload
procedure ECR(var O:TComboBox; n:integer; z:string); overload
//Procedure EFF(var O:TcomboBox);                      overload  supprimé par #19
function  IDX(var O:TComboBox):integer;              overload
procedure INS(var O:Tcombobox; l:integer; z:string); overload
function  LIG(var O:TComboBox; n:integer):string;    overload
procedure NDX(var O:TComboBox; n:integer);           overload
function  QTE(var O:TComboBox):integer;              overload
Procedure RAZ(var O:TcomboBox);                      overload
procedure Style(var O:TCombobox; S:TFontStyles);     overload
Procedure SVG(var O:TcomboBox; fic:string);          overload
function  SvgH(var O:TcomboBox):string;              overload 
function  TXT(var O:TComboBox):string;               overload
//Procedure VIS(var O:TcomboBox);                      overload   supprimé par #19
procedure Taille(var O:TCombobox; n:integer);        overload
function  XOF(var O:TComboBox; z:string; e:integer=1):integer; overload
function  HXOF(var O:TCombobox; v:variant; var L:integer; var C:integer):boolean; overload
procedure HPUT(var O:TCombobox; l,c:integer; V:variant); overload
function  HGET(var O:TCombobox; l,c:integer):variant;    overload

//------------------------------------------------------------------- Tmemo
procedure ADD(var O:Tmemo; z:string);                overload
Procedure CHG(var O:Tmemo; fic:string);              overload
procedure ChgH(var O:Tmemo; H:string);               overload
procedure DEF(var O:Tmemo; X,Y,L,H:integer);         overload 
procedure DEL(var O:Tmemo;     l:integer);           overload
function  DER(var O:TMemo):integer;                  overload
procedure ECR(var O:TMemo; n:integer; z:string);     overload
//Procedure EFF(var O:Tmemo);                          overload   supprimé par #19
function  IDX(var O:Tmemo):integer;                  overload
procedure INS(var O:Tmemo;     l:integer; z:string); overload
function  LIG(var O:TMemo; n:integer):string;        overload
function  QTE(var O:TMemo):integer;                  overload
Procedure RAZ(var O:Tmemo);                          overload
procedure Style(var O:TMemo;     S:TFontStyles);     overload
Procedure SVG(var O:Tmemo; fic:string);              overload
function  SvgH(var O:Tmemo):string;                  overload
procedure Taille(var O:TMemo;     n:integer);        overload
function  TXT(var O:TMemo):string;                   overload
//Procedure VIS(var O:Tmemo);                          overload   supprimé par #19
function  XOF(var O:Tmemo; z:string; e:integer=1):integer; overload
function  HXOF(var O:TMemo; v:variant; var L:integer; var C:integer):boolean;  overload
procedure HPUT(var O:TMemo; l,c:integer; V:variant); overload
function  HGET(var O:TMemo; l,c:integer):variant;    overload

//-----------------------------------------------------------------  TstringList
procedure INI(var O:TstringList);
procedure ADD(var O:TstringList; z:string);            overload
Procedure CHG(var O:TstringList; fic:string);          overload
procedure ChgH(var O:TstringList; H:string);           overload
procedure DEL(var O:TstringList; l:integer);           overload
function  DER(var O:TstringList):integer;              overload
procedure ECR(var O:TstringList; n:integer; z:string); overload
procedure INS(var O:TstringList; l:integer; z:string); overload
function  LIG(var O:TstringList; n:integer):string;    overload
function  QTE(var O:TstringList):integer;              overload
Procedure RAZ(var O:TstringList);                      overload
Procedure SVG(var O:TstringList; fic:string);          overload
function  SvgH(var O:TstringList):string;              overload 
function  XOF(var O:TstringList; z:string; e:integer=1):integer; overload
procedure FRE(var O:TstringList);
function  HXOF(var O:TstringList; v:variant; var L:integer; var C:integer; ch:string=''):boolean; overload
procedure HPUT(var O:TstringList; l,c:integer; V:variant; ch:string=''); overload
function  HGET(var O:TstringList; l,c:integer; ch:string=''):variant;    overload

//--------- spécifique TstringList --------------------------------- TstringList
procedure HINI(var O:TstringList; l,c:integer; V:variant; ch:string='');

procedure HTRF(var O:TstringList; var T:TlistBox);    overload    // T --> O
procedure HTRF(var O:TstringList; var T:TCombobox);   overload
procedure HTRF(var O:TstringList; var T:TMemo);       overload
//----
procedure HACQ(var O:TstringList; var T:TlistBox);    overload
procedure HACQ(var O:TstringList; var T:TCombobox);   overload
procedure HACQ(var O:TstringList; var T:TMemo);       overload
//----
procedure HINC(var O:TstringList; l,c:integer; n:integer=1; ch:string='');
procedure HDEC(var O:TstringList; l,c:integer; n:integer=1; ch:string='');
function  HDER(var O:TstringList; n:integer=0; ch:string=''):integer; // num dernier champ ligne n
function  HTXT(var O:TstringList; c:integer; ch:string=''):string;
procedure HecrL(var O:TstringList; l:integer; h:string; ch:string='');
procedure HecrC(var O:TstringList; c:integer; h:string; ch:string='');
procedure HaddL(var O:TstringList; h:string; ch:string='');  // idem ADD + ajust
procedure HaddC(var O:TstringList; h:string; ch:string='');
procedure HinsL(var O:TstringList; l:integer; h:string; ch:string='');
procedure HinsC(var O:TstringList; c:integer; h:string; ch:string='');
procedure HDEL(var O:TstringList; c:integer; ch:string='');    // supprime colonne
//18
procedure HRAZc(var O:TstringList; c:integer; V:variant; l:integer=0; ch:string='');
function HxofC(var T:TstringList; G:variant; C:integer):integer;
function HxofL(var T:TstringList; G:variant; L:integer):integer;

//-------------------------------------------------------------------  Tedit
procedure ADD(var O:Tedit; z:string);            overload
procedure ECR(var O:TEdit; z:string);            overload
Procedure RAZ(var O:Tedit);                      overload
function  TXT(var O:TEdit):string;               overload
//Procedure EFF(var O:Tedit);                      overload    supprimé par #19
//Procedure VIS(var O:Tedit);                      overload    supprimé par #19
procedure Style(var O:Tedit;     S:TFontStyles); overload
procedure Taille(var O:Tedit;     n:integer);    overload
procedure AFF(var O:TEdit;   z:string);          overload

//------------------------------------------------------------------- Tbutton
Procedure RAZ(var O:Tbutton);                    overload
//Procedure EFF(var O:Tbutton);                    overload  supprimé par #19
//Procedure VIS(var O:Tbutton);                    overload  supprimé par #19
procedure Style(var O:TButton;   S:TFontStyles); overload
procedure Taille(var O:TButton;   n:integer);    overload
procedure AFF(var O:TButton; z:string);          overload

//-------------------------------------------------------------------  Tpanel
Procedure RAZ(var O:Tpanel);                     overload
//Procedure EFF(var O:Tpanel);                     overload   supprimé par #19
procedure Style(var O:TPanel;    S:TFontStyles); overload
procedure Taille(var O:TPanel;    n:integer);    overload
//Procedure VIS(var O:Tpanel);                     overload   supprimé par #19
procedure AFF(var O:TPanel;  z:string);          overload
procedure DEF(var O:TPanel; X,Y,L,H:integer);    overload  // setBound

//------------------------------------------------------------------- Tlabel
//Procedure EFF(var O:Tlabel);                  overload   supprimé par #19
//Procedure VIS(var O:Tlabel);                  overload   supprimé par #19
procedure Style(var O:Tlabel; S:TFontStyles); overload
procedure Taille(var O:Tlabel; n:integer);    overload
procedure AFF(var O:TLabel; z:string);        overload

//------------------------------------------------------------------- Timage
//Procedure VIS(var O:Timage);       overload            supprimé par #19
//Procedure EFF(var O:Timage);       overload            supprimé par #19
procedure RAZ(var O:Timage);       overload

//----------------------------------------------------------------  TopenDialog
procedure Filtre(var O:TopenDialog; Z:string; e:string); overload
procedure Filtre(var O:TsaveDialog; Z:string; e:string); overload

//-------------------------------------------------------------------
procedure IniCOMA;  
procedure IniSpace;
procedure InitH(c:string='');

//---------------------------------------  Gestion DEBUG
procedure InitDEBUG; 
procedure FreeDEBUG;
procedure DEBUG(n:integer;   a:string=''; b:string=''; c:string='';
                d:string=''; e:string='';  f:string='');

{==========  functions et procedures diverses ============================== }

function  OuiNon(Q:string):boolean; //renvoie true si répondu OUI à question Q
function  NonOui(Q:string):boolean; //renvoie true si répondu NON à question Q
Function  JustG(T:string; N:byte; c:char=#32):string;   //18
          // renvoie chaine T avec N carac justifiée à gauche
Function  JustD(T:string; N:byte; c:char=#32):string;   //18
          // renvoie chaine T avec N carac justifiée à droite
Function  JustC(T:string; N:byte; c:char=#32):string;   //18
          // renvoie chaine T avec N carac justifiée au centre
procedure Msg(t:variant);
procedure Msg2(t1,t2:variant);
procedure Msg3(t1,t2,t3:variant);
Function  Len(z:string):integer;           // lenght;
Function  Dup(c:string; n:integer):string;   // dupestring
Function  Int(z:string):integer;           // strtoint
Function  Str(n:integer):string;           // inttostr
function  Min(N1,N2:integer):integer;
function  Max(N1,N2:integer):integer;
procedure Lim(var N:integer; Nmin,Nmax:integer); //renvoie N limité Nmin et Nmax
function  Minus(z:string):string; // lowercase
function  Majus(z:string):string; // Uppercase
function  Extension(fic:string; ext:string):string;
function  Trimaj(z:string):string;
function  iif(b:boolean; A,G:string):string;    overload
function  iif(b:boolean; A,G:integer):integer;  overload
function  Vdate(d:TDateTime):string;
function  Wdate(d:TDateTime):string;
function  NDate(d:TDateTime):integer;
function  DateN(n:integer; d:TdateTime):TdateTime;
function  str0(v:integer; n:integer=1):string;  // str0(5,3) => '005'
function  PosN(ch:string; z:string; n:integer=0):integer;
procedure IncDATE(var D:TdateTime; n:integer=1);
procedure DecDATE(var D:TdateTime; n:integer=1);



function  NonNum(v:variant):boolean;   //17
function  OkNum(v:variant):boolean;    //18
//------------------------------------------------------------------------------
function  DirParam:string;


///===================================== GestH =================================
// le ; a été pris comme séparateur dans GestH afin d'être compatible avec les
// fichiers CSV d'excel  (il a juste fallu modifier les points virgule avant
// le stockage et les remettre au déstockage
function  ZV(Z:variant):variant;
procedure RAZH(var h:string);                 // h = ''
function  QTEH(h:string; c:string=''):integer;             // nbre de champs
function  DERH(h:string; c:string=''):integer;             // n° du dernier champ (QTEH-1)
procedure ADDH(var h:string; v:variant; c:string='');      // ajoute le champ v à la fin
procedure INSH(var h:string; v:variant; n:integer; c:string='');
          // insère v pos n  h=a;b;c;d  insh(h,9,1)-> a;9;b;c;d
procedure DELH(var h:string; n:integer; c:string='');
          // supprime champ n h=a;b;c;d   delh(h,1)-> a;c;d
procedure PUTH(var h:string; v:variant; n:integer; c:string='');
          // ecrit champ v à pos n h=a;b;c;d   ecrh(h,9,1)-> a;9;c;d
function  GETH(h:string; n:integer=0; c:string=''):variant;
          //h=a;b;c;d   geth(h,1)-> b
function Mot(h:string; n:integer=1):variant;
          //h='a b c d'   mot(h,2)-> b
function  XofH(h:string; v:variant; e:integer=1; c:string=''):integer;
          /// renvoie position colonne de V dans H
          /// h=a;b;c;d   XofH(h,'b')-> 1  XofH(h,'z')-> -1
          /// si e=1 ou omis : Majus ou Minus, sinon Test carac
procedure IncH(var h:string; n:integer; v:integer=1; c:string='');
procedure DecH(var h:string; n:integer; v:integer=1; c:string='');
function  ExtH(var h:string; n:integer=0; c:string=''):string;  // extrait champ n, maj H
function  CodH(h:string):string;    // 'A;B;C' ==> 'A¸B¸C'
function  DcoH(h:string):string;    // 'A¸B¸C' ==> 'A;B;C'


///*********************************************************************** màJ 4

//--------------------- Compatibilité PosEX avec versions inférieures à Delphi 7
{*******************************************************}
{                                                       }
{         Delphi Compiler Version                       }
{         By Cirec [www.DelphiFr.com]  2006             }
{                                                       }
{   Modifié par DUBOIS77 pour intégration dans SYSTUE   }
{*******************************************************}
{$IFDEF VER80}  {$DEFINE DELPHIex} {$ENDIF}  // D1 ++
{$IFDEF VER90}  {$DEFINE DELPHIex} {$ENDIF}  // D2 ++
{$IFDEF VER100} {$DEFINE DELPHIex} {$ENDIF}  // D3 ++
{$IFDEF VER120} {$DEFINE DELPHIex} {$ENDIF}  // D4 ++
{$IFDEF VER130} {$DEFINE DELPHIex} {$ENDIF}  // D5 ++
{$IFDEF VER140} {$DEFINE DELPHIex} {$ENDIF}  // D6 ++

{$IFDEF DELPHIex}
function PosEx(SubString:string; Source:string; StartFrom:integer=1): integer;
// code de DEFIS91 ( http://www.delphifr.com/auteur/DEFIS91/610651.aspx)
{$ENDIF}

//------------------------------------------------------ CHERCHE
function Cherche(var L:Tlistbox; V:variant; e:integer=-1; n:integer=0):integer;
  // renvoie numéro de ligne ou -1 si non trouvé
  // Majuscules Minuscules indifférentes
  // si e omis ou = -1: identique pos sur chaque ligne de la liste
  // si e=1 2 ... : Cherche dans champ e sur chaque ligne de liste (voir getH)
  // n = ligne de début de la recherche (0 par défaut)

///*********************************************************************** màJ 5


procedure ERREUR(z:string);
// affiche le message d'erreur z
// stoppe le programme si la variable global DBUG est mise  1

//erreur('x trop grand'); affiche :
//  BUG : init
//  x trop grand 
// 
// pour modifier le terme "init" , modifier la variable BUG :   BUG := 'Phase 1 débugage'
//*DEBUG(0,'ERREUR - BUG : ',BUG,Z);
//if DBUG=1 then Halt;



{-------------------------- Gestion BLOQ
Gestion Bloque Débloque les commandes de l'appli (boutons, listes, menus ..) pendant 
qu'une commande spécifique s'exécute :
Saisie d'un enregistrement : visu d'un panel qui sa faire par valider ou annuler
rien ne doit être possible pendant ce moment là
________________________________________________________________________________
Principe
Dans SYSTUS, une var globale : XBLOQX : boolean;
initialisée dans l'unit à false (pas de blocage) : XBLOQX := false;
Chaque procedure de l'appli qui doit être bloquée pendant la zone "BLOQ" doit commencer 
par : if BLOQ then exit;
L'initialisation de la zone BLOQ est faite avec la procédure : Bloque
le déverrouillage avec la procédure : Debloque
}

procedure Bloque;  
procedure Debloque; 
function  BLOQ:boolean;

// HDIM(Panel1,'10;10;100;100') est équivalent à Panel1.setbounds(10,10,100,100)
procedure HDIM(O:TwinControl; H:string);
// z := DIMH(Panel1) renvoie '10;10;100;100'
Function  DIMH(O:TwinControl):string;
// pratique pour sauvegarder la position d'objets dans une Tliste  :

// var L1 : tstringList;

// INI(L1);  // obligatoire pour créer la liste
// ADD(L1,DIMH(panel1));
// ADD(L1,DIMH(panel2));
// ADD(L1,DIMH(bouton1));
// SVG(L1,'positions.svg');
// FRE(L1);
//...
// on rappelle avec :
// 
// INI(L1);  
// CHG(L1,'positions.svg');
// HDIM(Panel1, LIG(L1,0));
// HDIM(Panel2, LIG(L1,1));
// HDIM(Bouton1, LIG(L1,2));
// FRE(L1);


// supprimé des modules précédent par #19  : une seule procedure pour tous les controles
procedure VIS(O:TwinControl);
procedure EFF(O:TwinControl);
// rappel : VIS(L1) est equivalent à L1.visible := true, (L1 = TlistBOX)
// rappel : EFF(M1) est equivalent à M1.visible := false, (L1 = TMemo)


//==============================================================================
      IMPLEMENTATION
//==============================================================================


///=============================================================================
{ TABLO =======================================================================}
///=============================================================================

procedure TABLO.INI;
   begin
   LS := TStringList.Create;
   TAG := 0;
   FLG := false;
   TXT := '';
   dC  := 0;
   vC  := 0;
   end;
procedure TABLO.DEF(n:integer; v:variant);
  begin
  INI;
  dC := n;
  vC := v;
  //f
  end;
procedure TABLO.ADD(z: string);   begin LS.Add(z) end;
procedure TABLO.CHG(fic: string); begin LS.LoadFromFile(fic); end;
procedure TABLO.DEL(L: integer);  begin LS.Delete(L); end;
function  TABLO.DER: integer;     begin result := LS.Count - 1; end;
procedure TABLO.FRE;              begin LS.Destroy; end;
function  TABLO.QTE: integer;     begin result := LS.Count; end;
procedure TABLO.RAZ;              begin LS.Clear; end;
procedure TABLO.SVG(fic: string); begin LS.SaveToFile(fic); end;
function  TABLO.Text: string;     begin result := LS.text; end;
procedure TABLO.ECR(L: integer; z: string);  begin LS.Strings[L] := z; end;
procedure TABLO.INS(L: integer; z: string);  begin LS.Insert(l,z); end;
function  TABLO.LIG(L: integer): string;     begin result := LS.Strings[L]; end;
function  TABLO.XOF(z: string; var N:integer):boolean;
  begin
  result :=  false;
  N := LS.IndexOf(z);
  if N<0 then exit;
  result :=  true;
  end;
//----------------------------------
function  TABLO.GET(L, C: integer): variant;
  var z:string;
  begin
  z := LIG(l);
  result := geth(z,C);
  end;
//----------------------------------
procedure TABLO.PUT(L, C: integer; v: variant);
  var z:string;
  begin
  z := LIG(L);
  puth(z,v,C);
  ECR(L,z); 
  end;
//----------------------------------
function TABLO.SvgH: string;
  var i:integer; H:string;  //w:boolean;
  begin
  result := '';
  if QTE=0 then exit;  // liste vide
  H := AnsiReplaceStr(LIG(0),#59,'¸'); // remplace les points virgule ligne 0
  result := H;
  if QTE=1 then exit;   // une seule ligne
  for i:=1 to DER do addH(H,AnsiReplaceStr(LIG(i),#59,'¸'));
  result := H;
  end;
//----------------------------------
procedure TABLO.ChgH(H:string);
  var i:integer;
  begin
  RAZ;
  if H='' then exit;   // vide par défaut
  for i:=0 to DerH(H) do ADD(AnsiReplaceStr(getH(H,i),'¸',#59));
  end;
//----------------------------------
procedure TABLO.hADD(H:string);
  //var i:integer;
  begin
  while  dC>DerH(H) do addH(H,vC);
  ADD(H);
  end;
//----------------------------------
procedure TABLO.INC(L,C:integer; v:integer=1);
  var  n:integer;
  begin
  n := GET(L,C) - v;
  PUT(L,C,n);
  end;
//----------------------------------
procedure TABLO.DEC(L,C:integer; v:integer=1);
  var  n:integer;
  begin
  n := GET(L,C) + v;
  PUT(L,C,n);
  end;
//----------------------------------
procedure TABLO.hDEL(c:integer);
  var i:integer; z:string;
  begin
  for i:=0 to DER do
    begin
      z := LIG(i);
      delH(z,c);
      ECR(i,z);
    end;
  end;
//----------------------------------
procedure TABLO.hECR(c:integer; H:string);
  var i:integer; z,v:string;
  begin
  for i:=0 to min(DerH(H),DER) do   // plus petite valeur prise en compte
    begin
      z := LIG(i);
      v := getH(z,i);
      PUT(i,c,v);
    end;
  end;
//----------------------------------
function  TABLO.hXOF(z:string; var L:integer; var C:integer):boolean;
  var i:integer; h:string;
  begin
  result := false;  L := -1;  C := -1; // pas trouvé par défaut
  z := majus(z);
  for i:= 0 to DER do
     begin
     h := majus(LIG(i));
     if pos(z,h)=0 then continue;
     L := i;
     C := xofH(z,H);
     result := true;
     exit;
     end;
  end;
//----------------------------------
procedure TABLO.ACQ(o:Tmemo);
  begin
  end;
//----------------------------------
procedure TABLO.ACQ(o:TListBox);
  begin
  end;
//----------------------------------
procedure TABLO.ACQ(o:TComboBox);
  begin
  end;
//----------------------------------
procedure TABLO.ACQ(o:TStringList);
  begin
  end;

///==========================================================================
///==========================================================================

//------------------------------------------------------------------------{*DER}
function DER(var O:TlistBox):integer;    begin result:=O.count-1       end;
function DER(var O:TComboBox):integer;   begin result:=O.Items.Count-1 end;
function DER(var O:TMemo):integer;       begin result:=O.lines.count-1 end;
function DER(var O:TstringList):integer; begin result:=O.Count-1 end;

//------------------------------------------------------------------------{*IDX}
function IDX(var O:TListBox):integer;      begin result:=O.ItemIndex end;
function IDX(var O:TComboBox):integer;     begin result:=O.ItemIndex end;
function IDX(var O:Tmemo):integer;
  var s,n,c,l:integer;
  begin
  n:=0; c := -1;  l:=O.lines.count;
  s := O.SelStart;
  while (n<s) and (c<l) do begin n := posN(#13,O.Text,n); inc(c) end;
  result:= c
  end;

//------------------------------------------------------------------------{*LIG}
function  LIG(var O:TlistBox; n:integer):string;
  begin
  if n<0 then erreur('LIG(oL,n) : n<0');
  if n>DER(O) then erreur('LIG(oL,n) : n>DER(oL)');
  result := O.Items[n];
  end;
function  LIG(var O:TComboBox; n:integer):string;
  begin
  if n<0 then erreur('LIG(oC,n) : n<0');
  if n>DER(O) then erreur('LIG(oC,n) : n>DER(oC)');
  result := O.Items[n];
  end;
function  LIG(var O:TMemo; n:integer):string;
  begin
  if n<0 then erreur('LIG(oM,n) : n<0');
  if n>DER(O) then erreur('LIG(oM,n) : n>DER(oM)');
  result := O.lines[n];
  end;
function  LIG(var O:TstringList; n:integer):string;
  begin
  if n<0 then erreur('LIG(oT,n) : n<0');
  if n>DER(O) then erreur('LIG(oT,n) : n>DER(oT)');
  result := O[n];
  end;

//------------------------------------------------------------------------{*QTE}
function QTE(var O:TlistBox):integer;    begin result:=O.count       end;
function QTE(var O:TComboBox):integer;   begin result:=O.items.count end;
function QTE(var O:TMemo):integer;       begin result:=O.lines.count end;
function QTE(var O:TstringList):integer; begin result:=O.count end;

//------------------------------------------------------------------------{*TXT}
function  TXT(var O:TListBox):string;
    begin
    result := '';
    if IDX(O)>-1 then result := LIG(O,IDX(O));
    end;
function  TXT(var O:TComboBox):string;
    begin
    result := '';
    if IDX(O)>-1 then result := LIG(O,IDX(O));
    end;
function  TXT(var O:TMemo):string;
    begin
    result := '';
    if IDX(O)>-1 then result := LIG(O,IDX(O));
    end;
function  TXT(var O:TEdit):string;
    begin
    result := O.Text;
    end;
//------------------------------------------------------------------------{*XOF}
function  XOF(var O:TListBox; z:string; e:integer=1):integer;
   var i:integer;
   begin
   if e<>1 then result := O.Items.IndexOf(z)
          else begin
               result := -1;
               z := uppercase(z);
               for i:=0 to DER(O) do
                   if pos(z,uppercase(LIG(O,i)))>0 then
                      begin
                      result := i;
                      exit
                      end;
               end;
   end;
function  XOF(var O:TComboBox; z:string; e:integer=1):integer;
   var i:integer;
   begin
   if e<>1 then result := O.Items.IndexOf(z)
          else begin
               result := -1;
               z := uppercase(z);
               for i:=0 to DER(O) do
                   if pos(z,uppercase(LIG(O,i)))>0 then
                      begin
                      result := i;
                      exit
                      end;
               end;
   end;
function  XOF(var O:TstringList; z:string; e:integer=1):integer;
   var i:integer;
   begin
   if e<>1 then result := O.IndexOf(z)
          else begin
               result := -1;
               z := uppercase(z);
               for i:=0 to DER(O) do
                   if pos(z,uppercase(LIG(O,i)))>0 then
                      begin
                      result := i;
                      exit
                      end;
               end;
   end;
function  XOF(var O:Tmemo; z:string; e:integer=1):integer;
   var i:integer; b:boolean;
   begin
   b := O.WordWrap;
   O.WordWrap := false;
   if e<>1 then result := O.lines.indexof(z)
          else begin
               result := -1;
               z := uppercase(z);
               for i:=0 to DER(O) do
                   if pos(z,uppercase(LIG(O,i)))>0 then
                      begin
                      result := i;
                      O.WordWrap := b;
                      exit
                      end;
               end;
   O.WordWrap := b;
   end;

//-------------------------------------------------------------------------{ADD}
procedure ADD(var O:TlistBox; z:string);    begin O.Items.Add(z) end;
procedure ADD(var O:Tmemo; z:string);       begin O.lines.add(z) end;
procedure ADD(var O:TcomboBox; z:string);   begin O.items.add(z) end;
procedure ADD(var O:TEdit; z:string);       begin O.text := O.Text + z end;
procedure ADD(var O:TstringList; z:string); begin O.add(z) end;

//-------------------------------------------------------------------------{CHG}
Procedure CHG(var O:Tlistbox; fic:string);
begin
if not FileExists(fic) then ERREUR('CHG(oL,fic): ' + fic + ' non trouvé');
O.items.LoadFromFile(fic);
end;
Procedure CHG(var O:Tmemo; fic:string);
begin
if not FileExists(fic) then ERREUR('CHG(oM,fic): ' + fic + ' non trouvé');
O.lines.LoadFromFile(fic);
end;
Procedure CHG(var O:TcomboBox; fic:string);
begin
if not FileExists(fic) then ERREUR('CHG(oC,fic): ' + fic + ' non trouvé');
O.items.LoadFromFile(fic);
end;
Procedure CHG(var O:TstringList; fic:string);
begin
if not FileExists(fic) then ERREUR('CHG(oT,fic): ' + fic + ' non trouvé');
O.LoadFromFile(fic);
end;
//-------------------------------------------------------------------------{ECR}
procedure ECR(var O:TListBox; n:integer; z:string);
  begin
  if n<0 then erreur('ECR(oL,n) : n<0');
  if n>DER(O) then erreur('ECR(oL,n) : n>DER(oL)');
  O.Items[n] := z;
  end;
procedure ECR(var O:TstringList; n:integer; z:string);
  begin
  if n<0 then erreur('ECR(oT,n) : n<0');
  if n>DER(O) then erreur('ECR(oT,n) : n>DER(oT)');
  O[n] := z;
  end;
procedure ECR(var O:TComboBox; n:integer; z:string);
  begin
  if n<0 then erreur('ECR(oC,n) : n<0');
  if n>DER(O) then erreur('ECR(oC,n) : n>DER(oC)');
  O.Items[n] := z;
  O.ItemIndex := n;
  end;
procedure ECR(var O:TMemo; n:integer; z:string);
  begin
  if n<0 then erreur('ECR(oM,n) : n<0');
  if n>DER(O) then erreur('ECR(oM,n) : n>DER(oM)');
  O.lines[n] := z;
  end;
procedure ECR(var O:TEdit; z:string);
  begin
  O.Text := z;
  end;

//-------------------------------------------------------------------------{NDX}
procedure NDX(var O:TlistBox; n:integer);
  begin
  if n>DER(O) then n := DER(O);
  O.ItemIndex :=n;
  O.TopIndex := n;
  end;
procedure NDX(var O:TComboBox; n:integer);
  begin
  if n>DER(O) then n := DER(O);
  O.ItemIndex :=n;
  end;

//-------------------------------------------------------------------------{RAZ}
Procedure RAZ(var O:Tlistbox);    begin O.clear       end;
Procedure RAZ(var O:Tmemo);       begin O.clear       end;
Procedure RAZ(var O:TcomboBox);   begin O.clear       end;
Procedure RAZ(var O:Tedit);       begin O.text:=''    end;
Procedure RAZ(var O:Tbutton);     begin O.caption:='' end;
Procedure RAZ(var O:Tpanel);      begin O.caption:='' end;
Procedure RAZ(var O:TstringList); begin O.clear       end;
procedure RAZ(var O:Timage);      begin O.Picture := nil; end;

//-------------------------------------------------------------------------{SVG}
Procedure SVG(var O:Tlistbox; fic:string);    begin O.items.SaveToFile(fic); end;
Procedure SVG(var O:Tmemo; fic:string);       begin O.lines.SaveToFile(fic); end;
Procedure SVG(var O:TcomboBox; fic:string);   begin O.items.SaveToFile(fic); end;
Procedure SVG(var O:TstringList; fic:string); begin O.SaveToFile(fic); end;

//------------------------------------------------------------------------{ChgH}
procedure ChgH(var O:Tlistbox; H:string);
  var i:integer;
  begin
  RAZ(O);
  if H='' then exit;   // vide par défaut
  for i:=0 to DerH(H) do ADD(O,AnsiReplaceStr(getH(H,i),'¸',#59));
  end;
procedure ChgH(var O:Tmemo; H:string);
  var i:integer;  w:boolean;
  begin
  RAZ(O);
  if H='' then exit;   // vide par défaut
  w := o.WordWrap;
  o.WordWrap := false;
  for i:=0 to DerH(H) do ADD(O,AnsiReplaceStr(getH(H,i),'¸',#59));
    // decoma(getH(H,i)));
  o.WordWrap := w;
  end;
procedure ChgH(var O:TcomboBox; H:string);
  var i:integer;
  begin
  RAZ(O);
  if H='' then exit;   // vide par défaut
  for i:=0 to DerH(H) do ADD(O,AnsiReplaceStr(getH(H,i),'¸',#59));
  NDX(O,0);
  end;
procedure ChgH(var O:TstringList; H:string);
  var i:integer;
  begin
  RAZ(O);
  if H='' then exit;   // vide par défaut
  for i:=0 to DerH(H) do ADD(O,AnsiReplaceStr(getH(H,i),'¸',#59));
  end;

//------------------------------------------------------------------------Style}
procedure Style(var O:Tlistbox;  S:TFontStyles); begin O.Font.Style := s; end;
procedure Style(var O:TCombobox; S:TFontStyles); begin O.Font.Style := s; end;
procedure Style(var O:TMemo;     S:TFontStyles); begin O.Font.Style := s; end;
procedure Style(var O:TPanel;    S:TFontStyles); begin O.Font.Style := s; end;
procedure Style(var O:TButton;   S:TFontStyles); begin O.Font.Style := s; end;
procedure Style(var O:Tedit;     S:TFontStyles); begin O.Font.Style := s; end;
procedure Style(var O:Tlabel;    S:TFontStyles); begin O.Font.Style := s; end;
//----------------------------------------------------------------------{Taille}
procedure Taille(var O:Tlistbox;  n:integer); begin O.Font.Size := n; end;
procedure Taille(var O:TCombobox; n:integer); begin O.Font.Size := n; end;
procedure Taille(var O:TMemo;     n:integer); begin O.Font.Size := n; end;
procedure Taille(var O:TPanel;    n:integer); begin O.Font.Size := n; end;
procedure Taille(var O:TButton;   n:integer); begin O.Font.Size := n; end;
procedure Taille(var O:Tedit;     n:integer); begin O.Font.Size := n; end;
procedure Taille(var O:Tlabel;    n:integer); begin O.Font.Size := n; end;

//-----------------------------------------------------------------------{*SvgH}
function SvgH(var O:Tlistbox):string;
  var i:integer; H:string;
  begin
  result := '';
  if QTE(O)=0 then exit;  // liste vide
  H := AnsiReplaceStr(LIG(O,0),#59,'¸'); // remplace les points virgule ligne 0
  result := H;  if QTE(O)=1 then exit;   // une seule ligne
  for i:=1 to DER(O) do addH(H,AnsiReplaceStr(LIG(O,i),#59,'¸'));
  result := H;
  end;
function SvgH(var O:TCombobox):string;
  var i:integer; H:string;
  begin
  result := '';
  if QTE(O)=0 then exit;  // liste vide
  H := AnsiReplaceStr(LIG(O,0),#59,'¸'); // remplace les points virgule ligne 0
  result := H;  if QTE(O)=1 then exit;   // une seule ligne
  for i:=1 to DER(O) do addH(H,AnsiReplaceStr(LIG(O,i),#59,'¸'));
  result := H;
  end;
function SvgH(var O:TstringList):string;
  var i:integer; H:string;
  begin
  result := '';
  if QTE(O)=0 then exit;  // liste vide
  H := AnsiReplaceStr(LIG(O,0),#59,'¸'); // remplace les points virgule ligne 0
  result := H;  if QTE(O)=1 then exit;   // une seule ligne
  for i:=1 to DER(O) do addH(H,AnsiReplaceStr(LIG(O,i),#59,'¸'));
  result := H;
  end;
function SvgH(var O:Tmemo):string;
  var i:integer; H:string;  w:boolean;
  begin
  result := '';
  if QTE(O)=0 then exit;  // liste vide
  H := AnsiReplaceStr(LIG(O,0),#59,'¸'); // remplace les points virgule ligne 0
  result := H;  if QTE(O)=1 then exit;   // une seule ligne
  w := o.WordWrap;
  o.WordWrap := false;
  for i:=1 to DER(O) do addH(H,AnsiReplaceStr(LIG(O,i),#59,'¸'));
  o.WordWrap := w;
  result := H;
  end;

//-------------------------------------------------------------------------{INS}
procedure INS(var O:Tlistbox;  l:integer; z:string); begin O.Items.Insert(l,z); end;
procedure INS(var O:TCombobox; l:integer; z:string); begin O.Items.Insert(l,z); end;
procedure INS(var O:Tmemo;     l:integer; z:string); begin O.Lines.Insert(l,z); end;
procedure INS(var O:TstringList; l:integer; z:string); begin O.Insert(l,z); end;

//-------------------------------------------------------------------------{DEL}
procedure DEL(var O:Tlistbox; l:integer);  begin O.Items.Delete(l); end;
procedure DEL(var O:TCombobox; l:integer); begin O.Items.Delete(l); end;
procedure DEL(var O:Tmemo; l:integer);     begin O.Lines.Delete(l); end;
procedure DEL(var O:TstringList; l:integer); begin O.Delete(l); end;


//-------------------------------------------------------------------------{AFF}
procedure AFF(var O:TPanel;  z:string); begin O.Caption := z; end;
procedure AFF(var O:TButton; z:string); begin O.Caption := z; end;
procedure AFF(var O:TLabel;  z:string); begin O.Caption := z; end;
procedure AFF(var O:TEdit;   z:string); begin O.text    := z; end;

//-----------------------------------------------------------------------{HXOF}
function  HXOF(var O:TCombobox; v:variant; var L:integer; var C:integer):boolean;
begin
result := false;  C := -1;
L := XOF(O,V);
if L=-1 then exit;
C := XOFH(LIG(O,L),V);
result := true;
end;

function  HXOF(var O:Tlistbox; v:variant; var L:integer; var C:integer):boolean;
begin
result := false;  C := -1;
L := XOF(O,V);
if L=-1 then exit;
C := XOFH(LIG(O,L),V);
result := true;
end;

function  HXOF(var O:TstringList; v:variant; var L:integer; var C:integer; ch:string=''):boolean;
begin
if ch='' then ch:=ksep;
result := false;  C := -1;
L := XOF(O,V);
if L=-1 then exit;
C := XOFH(LIG(O,L),V,1,ch);
result := true;
end;

function  HXOF(var O:Tmemo; v:variant; var L:integer; var C:integer):boolean;
var w:boolean;
begin
w := O.WordWrap;
O.WordWrap := false;
result := false;  C := -1;
L := XOF(O,V);
if L=-1 then
   begin
   O.WordWrap := w;
   exit;
   end;
C := XOFH(LIG(O,L),V);
result := true;
O.WordWrap := false;
end;


//----------------------------------- TxofC //18
function HxofC(var T:TstringList; G:variant; C:integer):integer;
// renvoie le n° ligne (L) de la colonne C si G trouvé, sinon -1
// use : n := HxofC(T,V,C);
begin
result := XofH(HTXT(T,C),G)
end;



//----------------------------------- TxofL //18
function HxofL(var T:TstringList; G:variant; L:integer):integer;
// renvoie le n° du champ (C) dans la ligne L si G trouvé, sinon -1
begin
result := XofH(LIG(T,L),G)
end;

//-----------------------------------------------------------------------{HPUT}
procedure HPUT(var O:TstringList; l,c:integer; V:variant; ch:string='');
var i,n:integer; z,h:string;
begin
if ch='' then ch:=ksep;
if QTE(O)=0 then   // si Liste O = vide, on l'a crée vide à LC
   begin           // permet une init rapide
   z := Dup(ch,c);
   for i:=0 to c do ADD(O,z);
   h := LIG(O,l);
   putH(h,V,c,ch);
   ECR(O,l,h);
   exit;
   end;
n := DER(O);  // nombre ligne max de O
if l>n then for i:=n+1 to c do ADD(O,z);
h := LIG(O,l);
putH(h,V,c,ch);
ECR(O,l,h);
end;

procedure HPUT(var O:TCombobox; l,c:integer; V:variant);
var i,n:integer; z,h:string;
begin
if QTE(O)=0 then   // si Liste O = vide, on l'a crée vide à LC
   begin           // permet une init rapide
   z := dup(coma,c);
   for i:=0 to c do ADD(O,z);
   h := LIG(O,l);
   putH(h,V,c);
   ECR(O,l,h);
   exit;
   end;
n := DER(O);  // nombre ligne max de O
if l>n then for i:=n+1 to c do ADD(O,z);
h := LIG(O,l);
putH(h,V,c);
ECR(O,l,h);
end;

procedure HPUT(var O:Tlistbox; l,c:integer; V:variant);
var i,n:integer; z,h:string;
begin
if QTE(O)=0 then   // si Liste O = vide, on l'a crée vide à LC
   begin           // permet une init rapide
   z := dup(coma,c);
   for i:=0 to c do ADD(O,z);
   h := LIG(O,l);
   putH(h,V,c);
   ECR(O,l,h);
   exit;
   end;
n := DER(O);  // nombre ligne max de O
if l>n then for i:=n+1 to c do ADD(O,z);
h := LIG(O,l);
putH(h,V,c);
ECR(O,l,h);
end;

procedure HPUT(var O:Tmemo; l,c:integer; V:variant);
var i,n:integer; z,h:string; w:boolean;
begin
w := O.WordWrap;
O.WordWrap := false;
if QTE(O)=0 then   // si Liste O = vide, on l'a crée vide à LC
   begin           // permet une init rapide
   z := dup(coma,c);
   for i:=0 to c do ADD(O,z);
   h := LIG(O,l);
   putH(h,V,c);
   ECR(O,l,h);
   O.WordWrap := w;
   exit;
   end;
n := DER(O);  // nombre ligne max de O
if l>n then for i:=n+1 to c do ADD(O,z);
h := LIG(O,l);
putH(h,V,c);
ECR(O,l,h);
O.WordWrap := w;
end;


//-----------------------------------------------------------------------{HGET}
function  HGET(var O:TstringList; l,c:integer; ch:string=''):variant;
var z:string;
begin
if ch='' then ch:=ksep;
result := 0;
if l>der(O) then l:=der(O);
z := LIG(O,l);
if c>DerH(z,ch) then c := DerH(z,ch);
result := geth(z,c,ch);
end;

function  HGET(var O:Tlistbox; l,c:integer):variant;
var z:string;
begin
result := 0;
if l>der(O) then exit;
z := LIG(O,l);
if c>DerH(z) then exit;
result := geth(z,c);
end;

function  HGET(var O:TCombobox; l,c:integer):variant;
var z:string;
begin
result := 0;
if l>der(O) then exit;
z := LIG(O,l);
if c>DerH(z) then exit;
result := geth(z,c);
end;

function  HGET(var O:Tmemo; l,c:integer):variant;
var z:string;  w:boolean;
begin
result := 0;
if l>der(O) then exit;
w := O.WordWrap;
O.WordWrap := false;
z := LIG(O,l);
if c<=DerH(z) then result := geth(z,c);
O.WordWrap := w;
end;


procedure Filtre(var O:TopenDialog; Z:string; e:string);
    begin O.Filter := Z + '(*.' + e + ')|*.' + e; end;
procedure Filtre(var O:TsaveDialog; Z:string; e:string);
    begin O.Filter := Z + '(*.' + e + ')|*.' + e; end;


{functions et procedures diverses}

{--------------------------------------}
procedure Msg(t:variant);
    var z:string;
    begin
    z := t;
    messageDLG(z,mtinformation,[mbOk],0)
    end;
procedure Msg2(t1,t2:variant);
    var z1,z2:string;
    begin
    z1 := t1;
    z2 := t2;
    messageDLG(z1+RC+z2,mtinformation,[mbOk],0)
    end;
procedure Msg3(t1,t2,t3:variant);
    var z1,z2,z3:string;
    begin
    z1 := t1;
    z2 := t2;
    z3 := t3;
    messageDLG(z1+RC+z2+RC+z3,mtinformation,[mbOk],0)
    end;

//------------------------------------------------------------------------------
function  OuiNon(Q:string):boolean;  //use Dialogs pour messageDLG
begin
result := (messageDLG(Q,mtinformation,[mbOk,mbNo],0)= 1)
end;
//------------------------------------------------------------------------------
function  NonOui(Q:string):boolean;  //use Dialogs pour messageDLG
begin
result := (messageDLG(Q,mtinformation,[mbOk,mbNo],0)<> 1)
end;
//------------------------------------------------------------------------------
Function  JustG(T:string; N:byte; c:char=#32):string;       //18
//use StrUtils pour Dupestring
begin result := copy(trim(T)+DupeString(c,N),1,N); End;
             //-----------//
Function  JustD(T:string; N:byte; c:char=#32):string;      //18
//use StrUtils pour Dupestring
Begin T := trim(T); result := copy(DupeString(c,N)+T,length(T)+1,N); End;
             //-----------//
Function  JustC(T:string; N:byte; c:char=#32):string;       //18
//use StrUtils pour Dupestring
var l:byte;
Begin
l := length(trim(T));
if l>N
   then result := copy(trim(T),1,N)
   else result := copy(dupestring(c,(N-l) div 2) + T + dupestring(c,N),1,N);
End;
//------------------------------------------------------------------------------
Function Len(z:string):integer;  begin result := length(z)       end;
Function Dup;                    begin result := dupestring(c,n) end;
function Str(n:integer):string;  begin result := inttostr(n)     end;
function Minus(z:string):string; begin result := lowercase(z)    end;
function Majus(z:string):string; begin result := uppercase(z)    end;
   
function  Min(N1,N2:integer):integer;
   begin if N1>N2 then result := N2 else result := N1 end;

function  Max(N1,N2:integer):integer;
   begin if N1<N2 then result := N2 else result := N1 end;

Function  Int(z:string):integer;
  var a,e:integer;
  begin val(z,a,e);
  if e>0 then a:= 0;
  result := a;
  end;
  
procedure Lim(var N:integer; Nmin,Nmax:integer); 
  begin N := min(Nmax,max(Nmin,N)) end;
  
{--------------------------------------}
function Extension(fic:string; ext:string):string;
begin
result := ChangeFileExt(fic,'.'+ext)
end;

{--------------------------------------}

function iif(b:boolean; A,G:string):string;
begin
if b then result := A else result := G;
end;

function iif(b:boolean; A,G:integer):integer;
begin
if b then result := A else result := G;
end;

{--------------------------------------}
function  str0(v:integer; n:integer=1):string;
var z:string ;
begin
z := inttostr(v);
while length(z)<n do z := '0' + z;
result := z;
end;

{--------------------------------------}
function  PosN(ch:string; z:string; n:integer=0):integer;
var x:integer;
begin
result := 0;
x :=  pos(ch,copy(z,n+1,len(z)));
if x>0 then result := x+n;
end;

//------------------------------------------------------------------------------
function  DirParam:string;       //18
begin result := extractFilePath(paramstr(1)) end;



///===================================== GestH =================================
function ZV(Z:variant):variant;
var i,e:integer;  d,d9:tdatetime;  w:string;
begin
val(z,i,e);
if e=0 then begin result := i; exit end;                          // integer
if (lowercase(z)='true')  then begin result := true; exit end;     // boolean
if (lowercase(z)='false') then begin result := false; exit end;    // boolean
d9 := encodedate(1945,12,31); w := z;
d := StrToDateDef(w,d9);
if d<>d9 then begin result := d ;exit end;
result := z;
end;

function VZ(v:variant):string;
begin
result := v;
end;

procedure RAZH(var h:string);            // h = ''
begin h := '';
end;

//---------------------------------------------------------------------   QTEH
function  QTEH(h:string; c:string=''):integer;    // nbre de champs
var q,n:integer;
begin
if c='' then c := Ksep;
q := 1;
n := pos(c,h);
while n>0 do
  begin
  inc(q);
  n := posN(c,h,n);
  end;
result := q
end;

//----------------------------------------------------------------------  DERH
function  DERH(h:string; c:string=''):integer;    // n° du dernier champ (QTEH-1)
begin
if c='' then c := Ksep;
result := QTEH(h,c)-1;
end;

//----------------------------------------------------------------------  ADDH
procedure ADDH(var h:string; v:variant; c:string=''); // ajoute le champ v à la fin
begin
if c='' then c := Ksep;
h := h + c + vz(v);
end;

//-----------------------------------------------------------------------  INSH
procedure INSH(var h:string; v:variant; n:integer; c:string='');
// ajoute champ v à pos n
///  h=a;b;c;d   insh(h,9,1)-> a;9;b;c;d
var q,n1,n2,x:integer;
begin
if c='' then c := Ksep;
q := derh(h,c);
if n>q then n:=q;
if q=0 then       // un seul champ
   begin
   h := vz(v) + c + h;            // x;a
   exit
   end;
x  := 0;
n1 := 0;
n2 := pos(c,h);
if n=0 then         // 1er champ
   begin
   h := vz(v) + c + h;   // a;b;c;d;e; -> x;a;b;c;d;e;
   exit
   end;
while n>x do begin
    inc(x);
    n1 := n2;
    n2 := posN(c,h,n1);
    end;
h := copy(h,1,n1) + vz(v) + c + copy(h,n1+1,length(h));
end;

//----------------------------------------------------------------------  DELH
procedure DELH(var h:string; n:integer; c:string=''); // supprime le champ n
  ///  h=a;b;c;d   delh(h,1)-> a;c;d
var q,n1,n2,x:integer;
begin
if c='' then c := Ksep;
q := derh(h,c);
if n>q then n:=q; 
if q=0 then       // un seul champ
   begin
   h := '';
   exit
   end;
x := 0;
n1 := 0;
n2 := pos(c,h);
if n=0 then         // 1er champ
   begin
   h := copy(h,n2-1,length(h));   // a;b;c;d;e; -> b;c;d;e;
   exit
   end;
while n>x do
    begin
    inc(x);
    n1 := n2;
    n2 := posN(c,h,n1);
    end;
if n=q
   then h := copy(h,1,n1-1)
   else h := copy(h,1,n1) + copy(h,n2+1,length(h));
end;

//----------------------------------------------------------------------  PUTH
procedure PUTH(var h:string; v:variant; n:integer; c:string=''); // ecrit champ v à pos n
  ///  h=a;b;c;d   ecrh(h,9,1)-> a;9;c;d
var q,n1,n2,x:integer;
begin
if c='' then c := Ksep;
q := derh(h,c);
if n>q then ERREUR('PUTH : n > derh(h)');
if q=0 then       // un seul champ
   begin
   h := vz(v);
   exit
   end;
x  := 0;
n1 := 0;
n2 := pos(c,h);
if n=0 then         // 1er champ
   begin
   h := vz(v) + copy(h,n2,length(h));   // v;x;x;x;x;
   exit
   end;
while n>x do begin
    inc(x);
    n1 := n2;
    n2 := posN(c,h,n1);
    end;
if n=q
   then h := copy(h,1,n1) + vz(v)
   else h := copy(h,1,n1) + vz(v) + copy(h,n2,length(h));
end;

//----------------------------------------------------------------------  GETH
function  GETH(h:string; n:integer=0; c:string=''):variant;
  ///  h=a;b;c;d   geth(h,1)-> b
var q,n1,n2,x:integer;
begin
if c='' then c := Ksep;
q := derh(h,c);
if n>q then ERREUR('GETH(var h:string n:integer) : n > derh(h)');
if q=0 then begin result := h; exit end;  // un seul champ
x := 0;
n1 := 0;
n2 := pos(c,h);
if n=0 then begin result := copy(h,1,n2-1); exit end;
while n>x do begin
    inc(x);
    n1 := n2;
    n2 := posN(c,h,n1);
    end;
if n=q
   then result := copy(h,n1+1,length(h))
   else result := copy(h,n1+1,n2-n1-1);
end;

//----------------------------------------------------------------------  Mot
function Mot(h:string; n:integer=1):variant;
// renvoie le champs n avec kSEP=espace  avec  n = 1 à QteH(h)
// Mot(H) renvoie le premier mot
// si n>nombre de mot  : renvoie le dernier;
// si n<1 renvoie le premier
var k:string;
begin
k := kSEP;                // Sauvegarde séparateur courant
kSEP := ' ';              // nouveau séparateur pour GestH
LIM(n,1,QteH(h));        // limite n au nombre de mots de h   voir pour lim
result := getH(h,n-1);   // mot 1 = champ 0
kSEP := k;               // restitue séparateur courant
end;


//----------------------------------------------------------------------  XofH
function  XofH(h:string; v:variant; e:integer=1; c:string=''):integer;
  /// renvoie position colonne de V dans H
  /// h=a;b;c;d   XofH(h,'b')-> 1  XofH(h,'z')-> -1
  /// si e=1 ou omis : Majus ou Minus, sinon Test carac
  var z:string; n,d:integer;
begin
if c='' then c := Ksep;
 z := vz(v);
 if e=1 then 
    begin
    H := uppercase(H);
    Z := uppercase(Z);
    end;
result := -1; // par défaut : pas trouvé
// x := -1;
n := -1; d := derh(H,c);
 while n<d do
   begin
   inc(n);
   if z=geth(H,n,c) then 
      begin
      result := n;
      n := d;
      end;
   end;
end;

//----------------------------------------------------------------------  NonNum
function  NonNum(v:variant):boolean;  //18
var z:string; x,e:integer;
begin
z := v;
system.Val(z,x,e);
result := (e<>0);
v := x;   // pour éviter <conseil> à la compil
end;

//----------------------------------------------------------------------  OkNum
function  OkNum(v:variant):boolean;  //18
var z:string; x,e:integer;
begin
z := v;
system.Val(z,x,e);
result := (e=0);
v := x;   // pour éviter <conseil> à la compil
end;


//----------------------------------------------------------------------  IncH
procedure IncH(var h:string; n:integer; v:integer=1; c:string='');
var x:integer; w:variant;
begin
if c='' then c := Ksep;
if (n<0) or (n>derH(h,c)) then ERREUR('IncH(h,n,v) : n hors limite');
w := geth(H,n,c);
if nonnum(w) then ERREUR('IncH(h,n,v) : contenu non num');
x := w + v;
puth(H,x,n,c);
end;
//----------------------------------------------------------------------  DecH
procedure DecH(var h:string; n:integer; v:integer=1; c:string='');
var x:integer; w:variant;
begin
if c='' then c := Ksep;
if (n<0) or (n>derH(h,c)) then ERREUR('IncH(h,n,v) : n hors limite');
w := geth(H,n,c);
if nonnum(w) then ERREUR('IncH(h,n,v) : contenu non num');
x := geth(H,n,c) - v;
puth(H,x,n,c);
end;

//----------------------------------------------------------------------  CodH
function  CodH(h:string):string;    // 'A;B;C' ==> 'A¸B¸C'
begin
result := AnsiReplaceStr(H,#59,'¸')
end;
//----------------------------------------------------------------------  DcoH
function  DcoH(h:string):string;    // 'A¸B¸C' ==> 'A;B;C'
begin
result := AnsiReplaceStr(H,'¸',#59)
end;

///************************************************************** màJ 4

{$IFDEF DELPHIex}
function PosEx(SubString:string; Source:string; StartFrom:integer=1):integer;
begin
  Result := Pos(SubString, Copy(Source, StartFrom, Length(Source)));
  if Result > 0 then Result := Result + StartFrom-1;
end;
{$ENDIF}

//-------------------------------------------------------------------- Cherche
function Cherche(var L:Tlistbox; V:variant; e:integer=-1; n:integer=0):integer;
var i:integer; Z,H:string;
begin
Z := uppercase(V);
for i:=n to DER(L) do
    begin
    result := i;
    H := uppercase(LIG(L,i));
    if e<>-1 then H := getH(H,e);
    if pos(Z,H)>0 then exit;        // trouvé
    end;
result := -1;   // pas trouvé !
end;

//************************************************************************* /5

procedure IniCOMA;   begin kSEP := ';' end;
procedure IniSpace;  begin kSEP := ' ' end;


//------------------------------------------------------------------- ExtH
function ExtH(var H:string; n:integer=0; c:string=''):string;  // extrait champ n, maj H
var W:string;   i:integer;
    function Mot1(var h9:string):string;
    var x:integer;
    begin
    x := pos(c,h9);
    if x=0
       then begin
            result := h9;
            h9 := '';
            end
       else begin
            result := trim(copy(h9,1,x-1));
            h9 := trim(copy(h9,x+1,len(h9)));
            end;
    end;
begin
if c='' then c := Ksep;
if (n<0) or (n>derH(h,c)) then ERREUR('ExtH(h,n) : n hors limite');
result := '';
if DerH(H,c)<n then exit;
if n=0 then   // on extrait le premier mot
       begin
       result := Mot1(H); // et on restitue H sans le premier mot
       exit
       end;
W := Mot1(H);     // premier mot 0 conservé d'office
if n>1 then for  i:=2 to n do AddH(W,Mot1(H),c);
result := Mot1(H);
if H<>''
   then H := W + c + H
   else H := W;
end;

//-----------------------------------------------------------------initH(c)
procedure InitH(c:string='');
begin
if c='' then c := kSEP;
kSEP := c
end;


//----------------------------------------------------------- DEF(O,X,Y,L,H)
procedure DEF(var O:TPanel; X,Y,L,H:integer);   // setBound
begin O.SetBounds(X,Y,L,H); end;
//***
procedure DEF(var O:Tlistbox; X,Y,L,H:integer); // setBound
begin O.SetBounds(X,Y,L,H); end;
//***
procedure DEF(var O:Tmemo; X,Y,L,H:integer);   // setBound
begin O.SetBounds(X,Y,L,H); end;

//==================================================================== Version 6

//------------------------------------------------------ Gestion TStringlist
//--------------------------------------- INI(O)
procedure INI(var O:TstringList);
begin
//MàJ de CIREC   20/07/11
//if Assigned(O) then O.Clear;
O := TstringList.Create;
end;
//--------------------------------------- FRE(O)
procedure FRE(var O:TstringList);
//MàJ de CIREC  20/07/11
begin
if Assigned(O) then
  begin
    O.Free;
    O := nil;
  end;
end;

//--------------------------------------- Trimaj
function  Trimaj(z:string):string;
begin
result := uppercase(trim(z));
end;

function  Vdate(d:TDateTime):string;
begin
result := days[DayOfWeek(D)] + ' ' + DateToStr(D);
end;

function  Wdate(d:TDateTime):string;
begin
result := days[DayOfWeek(D)] + ' ' + formatDateTime('dd mmmm yyyy',D);
end;

function  Ndate(d:TDateTime):integer;
begin
result := DayOfTheYear(D);
end;

function DateN(n:integer; d:TdateTime):TdateTime;
begin
result := EncodeDateDay(YearOf(d),n);
end;


procedure IncDATE(var D:TdateTime; n:integer=1);
begin
D := IncDay(D,1);
end;

procedure DecDATE(var D:TdateTime; n:integer=1);
begin
D := IncDay(D,-1);
end;


////============================================================================
//  Gestion de TstringList
///=============================================================================

//-------------------------------------------------------------------- ERREUR
procedure ERREUR(z:string);
begin
MSG2('BUG : ' + BUG,Z) ; DEBUG(0,'ERREUR - BUG : ',BUG,Z);
if DBUG=1 then Halt;
end;

//-------------------------------------------------------------------- HINI
procedure HINI(var O:TstringList; l,c:integer; V:variant; ch:string='');
var i:integer; z,w:string;
// l,c : 0 à DER
// V : valeur initiale
begin
if ch='' then ch:=ksep; // coma par défaut
RAZ(O);
w := v;   // conversion variant en string
z := w;   // champ 0 de la ligne
if c>0 then for i:=1 to c do AddH(z,w,ch);   // ajout champs 1 à c champ
for i:=0 to l do ADD(O,z);
end;

//----------------------------------------------------------------------- HTRF
procedure HTRF(var O:TstringList; var T:TlistBox);    begin T.items := O end;
procedure HTRF(var O:TstringList; var T:TComboBox);   begin T.items := O end;
procedure HTRF(var O:TstringList; var T:TMemo);       begin T.lines := O end;

procedure HACQ(var O:TstringList; var T:TlistBox);
var i:integer;
begin
RAZ(O);
for i:=0 to DER(T) do ADD(O,LIG(T,i));
end;
procedure HACQ(var O:TstringList; var T:TCombobox);
var i:integer;
begin
RAZ(O);
for i:=0 to DER(T) do ADD(O,LIG(T,i));
end;
procedure HACQ(var O:TstringList; var T:TMemo);
var i:integer;
begin
RAZ(O);
for i:=0 to DER(T) do ADD(O,LIG(T,i));
end;

//----------------------------------------------------------------------- HINC
procedure HINC(var O:TstringList; l,c:integer; n:integer=1; ch:string='');
var z:string; v:variant; x:integer;
begin
if ch='' then ch:=ksep;
if l>der(O)  then exit;      // ligne inexistante, on passe
z := LIG(O,l);
if c>DerH(z) then exit;      // c trop grand, on passe
v := HGET(O,l,c);            // contenu de [0](l,c) dans v
if nonNum(v) 
   then x := 0           // valeur non numérique
   else x := v + n;      // on incrémente
HPUT(O,L,C,x);           // on stocke dans O
end;

//----------------------------------------------------------------------- HDEC
procedure HDEC(var O:TstringList; l,c:integer; n:integer=1; ch:string='');
var z:string; v:variant; x:integer;
begin
if ch='' then ch:=ksep;
if l>der(O)  then exit;      // ligne inexistante, on passe
z := LIG(O,l);
if c>DerH(z) then exit;      // c trop grand, on passe
v := HGET(O,l,c);            // contenu de [0](l,c) dans v
if nonNum(v) 
   then x := 0           // valeur non numérique
   else x := v - n;      // on incrémente
HPUT(O,L,C,x);           // on stocke dans O
end;

//----------------------------------------------------------------------- HDER
function  HDER(var O:TstringList; n:integer=0; ch:string=''):integer; // num dernier champ ligne n
begin
if ch='' then ch:=ksep;
result := Derh(LIG(O,n),ch)
end;

//----------------------------------------------------------------------- HTXT
function  HTXT(var O:TstringList; c:integer; ch:string=''):string;
var i:integer; h:string;
begin
if ch='' then ch:=ksep;
h := Hget(O,0,c,ch);
if DER(O)>0 then for i:=1 to DER(O) do AddH(h,Hget(O,i,c,ch),ch);
result := h;
end;

//----------------------------------------------------------------------- HECRl
procedure HecrL(var O:TstringList; l:integer; h:string; ch:string='');
var n:integer;
begin
if ch='' then ch:=ksep;
if l>DER(O) then
   begin
   DEBUG(1516,'SYSTUS','Proc HecrL','param L > DER(O)');
   l := DER(O);        // dernière ligne par défaut
   end;
n := derH(LIG(O,0),ch);
while derH(h,ch)<n do addH(h,'*',ch);
while derH(h,ch)>n do delH(h,derH(h,ch),ch);
ECR(O,l,h);
end;

//----------------------------------------------------------------------- HECRc
procedure HecrC(var O:TstringList; c:integer; h:string; ch:string='');
var n,i:integer;
begin
if ch='' then ch:=ksep;
if c>HDER(O,0,ch) then
   begin
   DEBUG(1531,'SYSTUS','Proc HecrC','param c > HDER(O)');
   c := HDER(O,0,ch);   // dernier champ par défaut
   end;
n := der(O);
while derH(h,ch)<n do addH(h,'*',ch);
while derH(h,ch)>n do delH(h,derH(h,ch),ch);
for i:=0 to n do HPUT(O,i,c,getH(H,i,ch),ch);
end;

//----------------------------------------------------------------------- HADDl
procedure HaddL(var O:TstringList; h:string; ch:string='');  // idem ADD + ajust h
var n:integer;
begin
if ch='' then ch:=ksep;
n := derH(LIG(O,0),ch);  // nombre de champs ligne 0
while derH(h,ch)<n do addH(h,'*',ch);
while derH(h,ch)>n do delH(h,derH(h,ch),ch);
ADD(O,h);
end;

//----------------------------------------------------------------------- HADDc
procedure HaddC(var O:TstringList; h:string; ch:string='');
// Ajoute une colonne avec les champs contenu dans h ( 'xx;ss;dd;....;zz')
var n,i:integer;  z:string;
begin
if ch='' then ch:=ksep;
n := der(O);        // nombre de lignes = nb champs de <h>
while derH(h,ch)<n do addH(h,'*',ch);          // on équilibre les champs
while derH(h,ch)>n do delH(h,derH(h),ch);      // comme le premier
for i:=0 to n do
    begin
    z := LIG(O,i);
    addH(z,geth(h,i,ch),ch);
    ECR(O,i,z)
    end;
end;

//----------------------------------------------------------------------- HINSl
procedure HinsL(var O:TstringList; l:integer; h:string; ch:string='');
var n:integer;
begin
if ch='' then ch:=ksep;
n := derH(LIG(O,0),ch);  // nombre de champs ligne 0
while derH(h,ch)<n do addH(h,'*',ch);
while derH(h,ch)>n do delH(h,derH(h,ch),ch);
INS(O,l,h);
end;

//----------------------------------------------------------------------- HINSc
procedure HinsC(var O:TstringList; c:integer; h:string; ch:string='');
var n,i:integer;  z:string;
begin
if ch='' then ch:=ksep;
n := der(O);
while derH(h,ch)<n do addH(h,'*',ch);
while derH(h,ch)>n do delH(h,derH(h,ch),ch);
for i:=0 to n do
    begin
    z := LIG(O,i);
    insH(z,geth(h,i,ch),c,ch);
    ECR(O,i,z)
    end;
end;

//----------------------------------------------------------------------- HDEL
procedure HDEL(var O:TstringList; c:integer; ch:string='');    // supprime colonne
var i:integer;  z:string;
begin
for i:=0 to der(O) do
    begin
    z := LIG(O,i);
    delH(z,c,ch);
    ECR(O,i,z)
    end;
end;

//----------------------------------------------------------------------- HRAZc
procedure HRAZc(var O:TstringList; c:integer; V:variant; l:integer=0; ch:string='');
//18
//l := ligne de début
// initialise le champ <c> de chaque ligne avec <V> en commençant par la ligne <l>
var i:integer;
begin
if ch='' then ch:=ksep;
if l>DER(O) then l:=DER(O); // dernière ligne max, 0 par defaut
for i:=l to DER(O) do HPUT(O,i,c,V,ch);
end;

//---------------------------------------  Gestion BLOQ
procedure Bloque;   begin XBLOQX := true;   end;
procedure Debloque; begin XBLOQX := false;  end;
function  BLOQ;     begin result := XBLOQX; end;

//---------------------------------------  Gestion DEBUG
procedure InitDEBUG; 
begin
INI(LDEBUG);
if FileExists(KDEBUG) then CHG(LDEBUG,KDEBUG);
ADD(LDEBUG,'----------------');
ADD(LDEBUG,datetostr(DATE));
FDEBUG := True;      // gestion debug en cours
end;
//-------------------------
procedure FreeDEBUG;
begin
if FDEBUG then FRE(LDEBUG);
end;
//-------------------------
procedure DEBUG(n:integer;   a:string=''; b:string=''; c:string='';
                d:string=''; e:string='';  f:string='');
begin
if not FDEBUG then exit;   // pour procedure ERREUR
ADD(LDEBUG,format('ligne %0d : %1s %2s %0s %0s %0s',[n,a,b,c,d,e,f]));
SVG(LDEBUG,KDEBUG);
end;

procedure HDIM(O:TwinControl; H:string);
begin
if QteH(H)<>4 then Erreur('HDIM(Panel,H) - Pas assez de paramètres');
O.SetBounds(geth(H,0),geth(H,1),geth(H,2),geth(H,3));
end;


Function DIMH(O:TwinControl):string;
var z:string;
begin
z := STR(O.Left);
AddH(z,O.Top);
Addh(z,O.Width);
AddH(z,O.Height);
result := z;
end;


procedure VIS(O:TwinControl);
begin
O.Visible := true;
O.BringToFront;
end;


Procedure EFF(O:TwinControl);
begin O.visible:=false
end;


//--------------------------------------------
{ TMultiImage }

procedure TMultiImage.CHG(z: string);
begin
if FileExists(z) then
   begin
   IMG.Left := 0;
   IMG.Picture.LoadFromFile(z);
   PAN.Width  := IMG.Height;
   PAN.Height := IMG.Height;
   iMax :=  IMG.Width div PAN.Width - 1;
   IX := 0;
   PAN.Visible := true;
   end;
end;

procedure TMultiImage.FRE;
begin
IMG.Free;
PAN.Free;
end;

procedure TMultiImage.INI(z:string; xx, yy: integer; Pere:TWinControl);
begin
PAN := TPanel.Create(nil);
PAN.Parent := Pere;
IMG := Timage.Create(nil);
IMG.parent := PAN;
IMG.AutoSize := true;
IMG.Visible := true;
PAN.Visible := true;
X := xx;
Y := yy;
PAN.Left := X;
PAN.Top  := Y;
iMax := 0;  // image vide
IX := -1;   // aucune image pointée
CHG(z);
end;

procedure TMultiImage.VIS(n:integer);
begin
if n < 0 then exit;
if n > iMax then exit;
IMG.Left := n * (- PAN.Width);
IX := n;
Pan.Visible := true;
end ;

procedure TMultiImage.EFF;
begin
Pan.Visible := false;
end;


///*****************************************************************************
BEGIN
IniCOMA;          // par défaut ";"" utilisé
BUG := 'Init';
DBUG := 0;        // non arret du programme si erreur détectée
XBLOQX := false;  // non bloqué par défaut

//==============================================================================
             END.
//==============================================================================


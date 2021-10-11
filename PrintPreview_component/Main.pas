unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  RichEditPrintPreview, Spin, ActnList, ImgList, ToolWin, Menus, Buttons;

type
  TFrmMain = class(TForm)
    IlPreview: TImageList;
    AlPreview: TActionList;
    ActFirstPage: TAction;
    ActPreviousPage: TAction;
    ActNextPage: TAction;
    ActLastPage: TAction;
    ActZoomMinus: TAction;
    ActZoomPlus: TAction;
    ActWholePage: TAction;
    ActShowMargins: TAction;
    ActPrint: TAction;
    ActPageWidth: TAction;
    PrintDlg: TPrintDialog;
    PMnuZoom: TPopupMenu;
    MnuWholePage: TMenuItem;
    MnuPageWidth: TMenuItem;
    N1: TMenuItem;
    Mnu25percent: TMenuItem;
    Mnu50percent: TMenuItem;
    Mnu100percent: TMenuItem;
    Mnu200percent: TMenuItem;
    Mnu400percent: TMenuItem;
    OpenDlg: TOpenDialog;
    ActScalePage: TAction;
    Mnu75percent: TMenuItem;
    Mnu150percent: TMenuItem;
    Mnu125percent: TMenuItem;
    Mnu175percent: TMenuItem;
    Mnu300percent: TMenuItem;
    PgCtrlPreview: TPageControl;
    TShPreview: TTabSheet;
    TShConfig: TTabSheet;
    SbrPreview: TStatusBar;
    TBarNavigation: TToolBar;
    TBtnSpacer1: TToolButton;
    TBtnFirstPage: TToolButton;
    TBtnPreviousPage: TToolButton;
    TBtnNextPage: TToolButton;
    TBtnLastPage: TToolButton;
    TBtnSpacer2: TToolButton;
    TBtnZoomMinus: TToolButton;
    TBtnZoomPlus: TToolButton;
    TBtnWholePage: TToolButton;
    TBtnPageWidth: TToolButton;
    TBtnSpacer3: TToolButton;
    TBtnShowMargins: TToolButton;
    TBtnPrint: TToolButton;
    GbxMargins: TGroupBox;
    LblMarginTop: TLabel;
    LblBottomMargin: TLabel;
    EdtTopMargin: TEdit;
    EdtBottomMargin: TEdit;
    LblLeftMargin: TLabel;
    EdtLeftMargin: TEdit;
    EdtRightMargin: TEdit;
    LblRightMargin: TLabel;
    EdtHeaderHeight: TEdit;
    LblHeaderMargin: TLabel;
    LblFooterMargin: TLabel;
    EdtFooterHeight: TEdit;
    RgpUnit: TRadioGroup;
    FontDlg: TFontDialog;
    GbxHeader: TGroupBox;
    LblHeaderLeft: TLabel;
    EdtHeaderLeft: TEdit;
    LblHeaderCenter: TLabel;
    Edt: TEdit;
    EdtHeaderRight: TEdit;
    LblHeaderRight: TLabel;
    SbtnHeaderFont: TSpeedButton;
    GbxFooter: TGroupBox;
    LblFooterLeft: TLabel;
    LblFooterCenter: TLabel;
    LblFooterRight: TLabel;
    SBtnFooterFont: TSpeedButton;
    EdtFooterLeft: TEdit;
    EdtFooterCenter: TEdit;
    EdtFooterRight: TEdit;
    TBtnSpacer4: TToolButton;
    TBarZoom: TTrackBar;
    TabSheet1: TTabSheet;
    RichEdit1: TRichEdit;
    ToolBar2: TToolBar;
    tbtnOpen: TToolButton;
    tbtnSave: TToolButton;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    tbtnCut: TToolButton;
    tbtnCopy: TToolButton;
    tbtnPaste: TToolButton;
    tbtnUndo: TToolButton;
    ToolButton21: TToolButton;
    tbtnBold: TToolButton;
    tbtnItalic: TToolButton;
    ToolButton13: TToolButton;
    ToolButton3: TToolButton;
    ComboFont: TComboBox;
    ColorBox1: TColorBox;
    Images: TImageList;
    SaveDlg: TSaveDialog;
    ToolButton1: TToolButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    // form
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    // action
    procedure ActFirstPageExecute(Sender: TObject);
    procedure ActPreviousPageExecute(Sender: TObject);
    procedure ActNextPageExecute(Sender: TObject);
    procedure ActLastPageExecute(Sender: TObject);
    procedure ActZoomMinusExecute(Sender: TObject);
    procedure ActZoomPlusExecute(Sender: TObject);
    procedure ActWholePageExecute(Sender: TObject);
    procedure ActPageWidthExecute(Sender: TObject);
    procedure ActScalePageExecute(Sender: TObject);
    procedure ActShowMarginsExecute(Sender: TObject);
    procedure ActPrintExecute(Sender: TObject);
    // event
    procedure BtnLoadFileClick(Sender: TObject);
    procedure BtnBuildClick(Sender: TObject);
    procedure PgCtrlPreviewChange(Sender: TObject);
    procedure RgpUnitClick(Sender: TObject);
    procedure EdtTopMarginExit(Sender: TObject);
    procedure EdtLeftMarginExit(Sender: TObject);
    procedure EdtRightMarginExit(Sender: TObject);
    procedure EdtBottomMarginExit(Sender: TObject);
    procedure EdtHeaderHeightExit(Sender: TObject);
    procedure EdtFooterHeightExit(Sender: TObject);
    procedure SbtnHeaderFontClick(Sender: TObject);
    procedure SBtnFooterFontClick(Sender: TObject);
    procedure TBarZoomChange(Sender: TObject);
    procedure PreviewScaleChange(Sender: TObject; Scale: single);
    procedure Printing(Sender: TObject; Page: integer);
    procedure Charger1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure tbtnOpenClick(Sender: TObject);
    procedure tbtnSaveClick(Sender: TObject);
    procedure tbtnBoldClick(Sender: TObject);
    procedure tbtnItalicClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ComboFontChange(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure tbtnCutClick(Sender: TObject);
    procedure tbtnCopyClick(Sender: TObject);
    procedure tbtnPasteClick(Sender: TObject);
    procedure tbtnUndoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

  private
    { Déclarations privées }
    RichEditPrintPreview: TRichEditPrintPreview;
    UpdatingTrackBarZoom: boolean;

    procedure UpdatePreviewUI;
    procedure UpdateEdtMargins;
    procedure UpdateEdtHeaderFooter;

  public
    procedure Creation;
    procedure PrintRichedit;
    procedure Preview;
  end;

var
  FrmMain: TFrmMain;

implementation

uses richedit, unit1;

{$R *.dfm}


{------------------------------------------------------------------------------}
{ Form                                                                         }
{------------------------------------------------------------------------------}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
creation;
end;
procedure TFrmMain.Creation;
begin
  RichEditPrintPreview:= TRichEditPrintPreview.Create(nil);
  with RichEditPrintPreview do
  begin
    Parent:= TShPreview;
    Align:= alClient;
    RichEdit:= RichEdit1;
    ShowMargin:= true;
    MarginInMM:= false;
    TopMargin:= 0.2;
    BottomMargin:= 0.2;
    LeftMargin:= 0.6;
    RightMargin:= 0.1;
    HeaderHeight:= 0.2;
    FooterHeight:= 0.2;
    SetHeaderText(TeteG, Edt.text, TeteD);
    SetFooterText('Imprimé le : [D]/[M]/[Y]', 'Page [PAGE]/[PAGES]','xx');
  end;
  ComboFont.Items := Screen.Fonts;
  ComboFont.ItemIndex := ComboFont.Items.IndexOf (RichEdit1.Font.Name);
  ActShowMargins.Checked:= RichEditPrintPreview.ShowMargin;
  PgCtrlPreview.ActivePageIndex:= 0;
  UpdatingTrackBarZoom:= false;
  PgCtrlPreview.TabIndex := 2;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.FormShow(Sender: TObject);
begin
  RichEditPrintPreview.OnScaleChange:= PreviewScaleChange;
  RichEditPrintPreview.OnPrint:= Printing;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RichEditPrintPreview.Free;
end;

{------------------------------------------------------------------------------}
{ Preview actions                                                              }
{------------------------------------------------------------------------------}

procedure TFrmMain.ActFirstPageExecute(Sender: TObject);
// Preview first page
begin
  RichEditPrintPreview.FirstPage;
  UpdatePreviewUI;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActPreviousPageExecute(Sender: TObject);
// Preview previous page
begin
  RichEditPrintPreview.PreviousPage;
  UpdatePreviewUI;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActNextPageExecute(Sender: TObject);
// Preview next page
begin
  RichEditPrintPreview.NextPage;
  UpdatePreviewUI;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActLastPageExecute(Sender: TObject);
// Preview last page
begin
  RichEditPrintPreview.LastPage;
  UpdatePreviewUI;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActZoomMinusExecute(Sender: TObject);
// Reduce zoom (zoom out)
begin
  RichEditPrintPreview.Scale:= RichEditPrintPreview.Scale / 2;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActZoomPlusExecute(Sender: TObject);
// Increase zoom (zoom in)
begin
  RichEditPrintPreview.Scale:= RichEditPrintPreview.Scale * 2;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActWholePageExecute(Sender: TObject);
// Change zoom to display whole page
begin
  RichEditPrintPreview.ScaleMode:= smWholePage;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActPageWidthExecute(Sender: TObject);
// Change zoom to display page width
begin
  RichEditPrintPreview.ScaleMode:= smPageWidth;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActScalePageExecute(Sender: TObject);
// Change zoom to selected scale
begin
  with Sender as TMenuItem do
  begin
    RichEditPrintPreview.ScaleMode:= smScaled;
    RichEditPrintPreview.Scale:= Tag / 100;
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.ActShowMarginsExecute(Sender: TObject);
// Show margins
begin
  ActShowMargins.Checked:= not ActShowMargins.Checked;
  RichEditPrintPreview.ShowMargin:= ActShowMargins.Checked;
end;

{------------------------------------------------------------------------------}
procedure TFrmMain.ActPrintExecute(Sender: TObject); begin PrintRichedit; end;
procedure TFrmMain.PrintRichedit;
var
  NbOfPages: integer;
  TmpRichEdit: TRichEdit;
begin
  with PrintDlg do
  begin
    // General
    Options:= [];
    PrintRange:= prAllPages;
    // If more then one page
    NbOfPages:= RichEditPrintPreview.NumberOfPages;
    if NbOfPages > 1 then
    begin
      Options:= Options + [poPageNums];
      FromPage:= 1;
      MinPage:= 1;
      ToPage:= NbOfPages;
      MaxPage:= ToPage;
    end;
    // If something is selected
    if RichEdit1.SelLength > 0 then
    begin
      Options:= Options + [poSelection];
      PrintRange:= prSelection;
    end;
  end;

  if PrintDlg.Execute then
  begin
    Screen.Cursor:= crHourGlass;
    RichEditPrintPreview.Reset;
    case PrintDlg.PrintRange of
      prAllPages  : RichEditPrintPreview.Print(1,-1);
      prSelection : begin
                      // Copy selected text
                      TmpRichEdit:= TRichEdit.Create(self);
                      TmpRichEdit.Parent:= Self;
                      TmpRichEdit.Visible:= false;
                      TmpRichEdit.Font.Assign(RichEdit1.Font);
                      TmpRichEdit.WordWrap:= RichEdit1.WordWrap;
                      TmpRichEdit.Lines.Add(RichEdit1.SelText);
                      // Print
                      RichEditPrintPreview.RichEdit:= TmpRichEdit;
                      RichEditPrintPreview.Reset;
                      RichEditPrintPreview.Print(1,-1);
                      // Get back
                      RichEditPrintPreview.RichEdit:= RichEdit1;
                      RichEditPrintPreview.Reset;
                      TmpRichEdit.Free;
                    end;
    else // prPageNums
      RichEditPrintPreview.Print(PrintDlg.FromPage,PrintDlg.ToPage);
    end;
    Screen.Cursor:= crDefault;
    SbrPreview.Panels[2].Text:= '';
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.BtnLoadFileClick(Sender: TObject);
begin
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.BtnBuildClick(Sender: TObject);
begin
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.PgCtrlPreviewChange(Sender: TObject); begin Preview end;
procedure TFrmMain.Preview;
begin
//if FIC = '*' then exit;
    EDT.Text := TeteD;
    RichEditPrintPreview.PrintTitle:= TeteC;
    RichEditPrintPreview.Reset;
    RichEditPrintPreview.Display;
    UpdatePreviewUI;
  if PgCtrlPreview.ActivePage = TShPreview then
  begin
    // Done before display preview
    with RichEditPrintPreview do
    begin
      SetHeaderText(TeteG,TeteC,TeteD);
      SetFooterText(EdtFooterLeft.Text,EdtFooterCenter.Text,Pied);
      Display;
    end;
  end
  else
  begin
    // Done before display config
    UpdateEdtMargins;
    UpdateEdtHeaderFooter;
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.RgpUnitClick(Sender: TObject);
begin
  RichEditPrintPreview.MarginInMM:= RgpUnit.ItemIndex = 0;
  UpdateEdtMargins;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.EdtHeaderHeightExit(Sender: TObject);
begin
  try
    RichEditPrintPreview.HeaderHeight:= StrToFloat(EdtHeaderHeight.Text);
  finally
    EdtHeaderHeight.Text:= FloatToStrF(RichEditPrintPreview.HeaderHeight, ffFixed, 10,3);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.EdtTopMarginExit(Sender: TObject);
begin
  try
    RichEditPrintPreview.TopMargin:= StrToFloat(EdtTopMargin.Text);
  finally
    EdtTopMargin.Text:= FloatToStrF(RichEditPrintPreview.TopMargin, ffFixed, 10,3);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.EdtLeftMarginExit(Sender: TObject);
begin
  try
    RichEditPrintPreview.LeftMargin:= StrToFloat(EdtLeftMargin.Text);
  finally
    EdtLeftMargin.Text:= FloatToStrF(RichEditPrintPreview.LeftMargin, ffFixed, 10,3);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.EdtRightMarginExit(Sender: TObject);
begin
  try
    RichEditPrintPreview.RightMargin:= StrToFloat(EdtRightMargin.Text);
  finally
    EdtRightMargin.Text:= FloatToStrF(RichEditPrintPreview.RightMargin, ffFixed, 10,3);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.EdtBottomMarginExit(Sender: TObject);
begin
  try
    RichEditPrintPreview.BottomMargin:= StrToFloat(EdtBottomMargin.Text);
  finally
    EdtBottomMargin.Text:= FloatToStrF(RichEditPrintPreview.BottomMargin, ffFixed, 10,3);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.EdtFooterHeightExit(Sender: TObject);
begin
  try
    RichEditPrintPreview.FooterHeight:= StrToFloat(EdtFooterHeight.Text);
  finally
    EdtFooterHeight.Text:= FloatToStrF(RichEditPrintPreview.FooterHeight, ffFixed, 10,3);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.SbtnHeaderFontClick(Sender: TObject);
begin
  FontDlg.Font.Assign(RichEditPrintPreview.HeaderFont);
  if FontDlg.Execute then
  begin
    RichEditPrintPreview.HeaderFont.Assign(FontDlg.Font);
    EdtHeaderLeft.Font.Assign(FontDlg.Font);
    Edt.Font.Assign(FontDlg.Font);
    EdtHeaderRight.Font.Assign(FontDlg.Font);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.SBtnFooterFontClick(Sender: TObject);
begin
  FontDlg.Font.Assign(RichEditPrintPreview.FooterFont);
  if FontDlg.Execute then
  begin
    RichEditPrintPreview.FooterFont.Assign(FontDlg.Font);
    EdtFooterLeft.Font.Assign(FontDlg.Font);
    EdtFooterCenter.Font.Assign(FontDlg.Font);
    EdtFooterRight.Font.Assign(FontDlg.Font);
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.TBarZoomChange(Sender: TObject);
var
  AValue: single;
begin
  if not UpdatingTrackBarZoom then
  begin
    AValue:= TBarZoom.Position / 100;
    RichEditPrintPreview.ScaleMode:= smScaled;
    RichEditPrintPreview.Scale:= AValue;
  end;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.PreviewScaleChange(Sender: TObject; Scale: single);
begin
  SbrPreview.Panels[1].Text:= 'Echelle ' + FloatToStrF(Scale,ffFixed, 10, 3);
  ActZoomMinus.Enabled:= Scale > RichEditPrintPreview.MinScale;
  ActZoomPlus.Enabled:= Scale < RichEditPrintPreview.MaxScale;
  UpdatingTrackBarZoom:= true;
  TBarZoom.Position:= round(Scale * 100);
  UpdatingTrackBarZoom:= false;
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.Printing(Sender: TObject; Page: integer);
begin
  SbrPreview.Panels[2].Text:= 'Impression page ' + IntToStr(Page);
end;

{------------------------------------------------------------------------------}
{ Private                                                                      }
{------------------------------------------------------------------------------}

procedure TFrmMain.UpdatePreviewUI;
begin
  TBarNavigation.Visible:= true;
  // Page
  ActFirstPage.Enabled:= RichEditPrintPreview.CurrentPage > 1;
  ActPreviousPage.Enabled:= ActFirstPage.Enabled;
  ActNextPage.Enabled:=
    RichEditPrintPreview.CurrentPage < RichEditPrintPreview.NumberOfPages;
  ActLastPage.Enabled:= ActNextPage.Enabled;
  SbrPreview.SimplePanel:= false;
  SbrPreview.Panels[0].Text:= 'Page ' + IntToStr(RichEditPrintPreview.CurrentPage)
    + ' sur ' + IntToStr(RichEditPrintPreview.NumberOfPages);
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.UpdateEdtMargins;
begin
  EdtHeaderHeight.Text:= FloatToStrF(RichEditPrintPreview.HeaderHeight, ffFixed, 10,3);
  EdtTopMargin.Text:= FloatToStrF(RichEditPrintPreview.TopMargin, ffFixed, 10,3);
  EdtLeftMargin.Text:= FloatToStrF(RichEditPrintPreview.LeftMargin, ffFixed, 10,3);
  EdtRightMargin.Text:= FloatToStrF(RichEditPrintPreview.RightMargin, ffFixed, 10,3);
  EdtBottomMargin.Text:= FloatToStrF(RichEditPrintPreview.BottomMargin, ffFixed, 10,3);
  EdtFooterHeight.Text:= FloatToStrF(RichEditPrintPreview.FooterHeight, ffFixed, 10,3);
end;

{------------------------------------------------------------------------------}

procedure TFrmMain.UpdateEdtHeaderFooter;
var
  ALeftText: string;
  ACenterText: string;
  ARightText: string;
begin
  // Header
  RichEditPrintPreview.GetHeaderText(ALeftText, ACenterText, ARightText);
  EdtHeaderLeft.Text:= ALeftText;
  Edt.Text:= ACenterText;
  EdtHeaderRight.Text:= ARightText;
  EdtHeaderLeft.Font.Assign(RichEditPrintPreview.HeaderFont);
  Edt.Font.Assign(RichEditPrintPreview.HeaderFont);
  EdtHeaderRight.Font.Assign(RichEditPrintPreview.HeaderFont);
  // Footer
  RichEditPrintPreview.GetFooterText(ALeftText, ACenterText, ARightText);
  EdtFooterLeft.Text:= ALeftText;
  EdtFooterCenter.Text:= ACenterText;
  EdtFooterRight.Text:= ARightText;
  EdtFooterLeft.Font.Assign(RichEditPrintPreview.FooterFont);
  EdtFooterCenter.Font.Assign(RichEditPrintPreview.FooterFont);
  EdtFooterRight.Font.Assign(RichEditPrintPreview.FooterFont);
end;


procedure TFrmMain.Charger1Click(Sender: TObject);
begin
  if OpenDlg.Execute then
  begin
    RichEdit1.Lines.Clear;
    RichEdit1.Lines.LoadFromFile(OpenDlg.FileName);
    RichEditPrintPreview.PrintTitle:= ExtractFilename(OpenDlg.FileName);
    RichEditPrintPreview.Reset;
    RichEditPrintPreview.Display;
    UpdatePreviewUI;
  end;
end;

procedure TFrmMain.Quitter1Click(Sender: TObject);
begin
application.terminate
end;

procedure TFrmMain.tbtnOpenClick(Sender: TObject);
var FIC:string;
begin
  if OpenDlg.Execute then
  begin
    FIC := ExtractFilename(OpenDlg.FileName);
    RichEdit1.Lines.Clear;
    RichEdit1.Lines.LoadFromFile(OpenDlg.FileName);
    RichEditPrintPreview.PrintTitle:= FIC;
    RichEditPrintPreview.Reset;
    RichEditPrintPreview.Display;
    UpdatePreviewUI;
  end;
end;

procedure TFrmMain.tbtnSaveClick(Sender: TObject);
var FIC:string;
begin
  if SaveDlg.Execute then
  begin
    FIC := ExtractFilename(SaveDlg.FileName);
    RichEdit1.Lines.saveToFile(SaveDlg.FileName);
  end;
end;

procedure TFrmMain.tbtnBoldClick(Sender: TObject);
begin
  with RichEdit1.SelAttributes do
    if fsBold in Style then
      Style := Style - [fsBold]
    else
      Style := Style + [fsBold];
end;

procedure TFrmMain.tbtnItalicClick(Sender: TObject);
begin
  with RichEdit1.SelAttributes do
    if fsItalic in Style then
      Style := Style - [fsItalic]
    else
      Style := Style + [fsItalic];
end;

procedure TFrmMain.ToolButton1Click(Sender: TObject);
begin
  RichEdit1.SelAttributes.Size :=
    RichEdit1.SelAttributes.Size + 2;
end;

procedure TFrmMain.ComboFontChange(Sender: TObject);
begin
  RichEdit1.SelAttributes.Name := ComboFont.Text;
end;

procedure TFrmMain.ColorBox1Change(Sender: TObject);
begin
  RichEdit1.SelAttributes.Color := ColorBox1.Selected;
end;

procedure TFrmMain.ToolButton2Click(Sender: TObject);
begin
richedit1.SelLength := 0;
//richedit1.SelectAll;
PgctrlPreview.ActivePageIndex := 0;
preview;
PrintRichedit;
PgctrlPreview.ActivePageIndex := 2;
richedit1.SelLength := 0;
end;

procedure TFrmMain.tbtnCutClick(Sender: TObject);
begin
  RichEdit1.CutToClipboard;
end;

procedure TFrmMain.tbtnCopyClick(Sender: TObject);
begin
  RichEdit1.CopyToClipboard;
end;

procedure TFrmMain.tbtnPasteClick(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TFrmMain.tbtnUndoClick(Sender: TObject);
begin
  RichEdit1.Undo;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
FrmMain.hide;
//FIC := '*';
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
if Fontdlg.Execute then
   begin
   richedit1.SelAttributes.Size := Fontdlg.font.Size;
   richedit1.SelAttributes.Color := Fontdlg.font.Color;
   richedit1.SelAttributes.Style := Fontdlg.font.Style;
   end;
end;

procedure TFrmMain.Button3Click(Sender: TObject);
begin
FrmMain.hide;
//FIC := '*';
end;

procedure TFrmMain.Button5Click(Sender: TObject);
begin
EDT.Text := TeteD;
end;

end.

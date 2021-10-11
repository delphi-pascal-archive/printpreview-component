unit RichEditPrintPreview;


interface

uses
  Windows, Controls, Classes, ComCtrls, RichEdit, Forms, Messages, Graphics,
  SysUtils, Printers;

const
  TwipsPerInch: integer = 1440; // in order to have device independant data

type
  TScaleMode = (smScaled, smPageWidth, smWholePage);

  TPrtCaps = record
    PrtHandle: HDC;             // printer handle
    XPixelsPerInch: integer;    // resolution in X axis in dot per inch
    YPixelsPerInch: integer;    // resolution in Y axis in dot per inch
    PageArea: TRect;            // page area (left, top, width, height) in twips
    PrintingArea: TRect;        // print area (left, top, width, height) twips
    Margins: TRect;             // printer minimal margins in twips
  end;

  THeaderFooter = record
    Header: boolean;            // is it a header or footer
    Height: integer;            // height in twips
    Font: TFont;                // font used for the text
    LeftText: string;           // text we want to put on the left
    CenterText: string;         // text we want to center
    RightText: string;          // text we want to put on the right
  end;

  TScaleEvent  = procedure (Sender: TObject; Scale: single) of object;
  TScaleModeEvent  = procedure (Sender: TObject; ScaleMode: TScaleMode) of object;
  TPrintEvent  = procedure (Sender: TObject; Page: integer) of object;

  TRichEditPrintPreview = class(TCustomControl)
  private
    FRichEdit: TRichEdit;        // richedit to render
    FMarginInMM: boolean;        // unit use to set or get margin (mm or inch)
    FShowMargin: boolean;        // display margins
    FUserMargins: TRect;         // user margins in twips
    FHeader: THeaderFooter;      // header contents
    FFooter: THeaderFooter;      // footer contents
    FPreviewDate: TDateTime;     // date time of preview

    FCurrentPage: integer;       // current page number
    FNumberOfPages: integer;     // number of pages
    FMinScale: single;           // minimum scale for preview
    FMaxScale: single;           // maximum scale for preview
    FScaleMode: TScaleMode;      // kind of scale mode used
    FScale: single;              // current scale used
    FVPageWidth: integer;        // virtual page width in pixels
    FVPageHeight: integer;       // virtual page height in pixels
    FVXOffset: integer;          // virtual X offset in pixels
    FVYOffset: integer;          // virtual Y offset in pixels
    FBorder: TRect;              // border in pixels to correct display limit
                                 // see ComputeScale and scroll procedures

    FPrinterCaps: TPrtCaps;      // printer capabilities
    FPrintableArea: TRect;       // printer printable area
    FPageList: TStringList;      // list of last char number for each page

    FPrintTitle: string;         // title used in printer queue
    FPreviewMetaFile: TMetaFile; // meta file for preview
    FPageMetaFile: TMetaFile;    // meta file of page

    FUpdatingPreview: boolean;   // is component updating preview

    FOnScaleChange: TScaleEvent; // scale change event
    FOnScaleModeChange: TScaleModeEvent; // scale mode change event
    FOnPrint: TPrintEvent;       // printing page event

    function MMToInch(AValue: single):single;
    function InchToMM(AValue: single):single;

    procedure SetTopMargin(AValue: single);
    function GetTopMargin: single;
    procedure SetBottomMargin(AValue: single);
    function GetBottomMargin: single;
    procedure SetLeftMargin(AValue: single);
    function GetLeftMargin: single;
    procedure SetRightMargin(AValue: single);
    function GetRightMargin: single;

    function GetHeaderHeight: single;
    procedure SetHeaderHeight(AValue: single);
    function GetHeaderFont: TFont;
    procedure SetHeaderFont(AFont: TFont);
    function GetFooterHeight: single;
    procedure SetFooterHeight(AValue: single);
    function GetFooterFont: TFont;
    procedure SetFooterFont(AFont: TFont);

    function ConvertText(AText: string; APage: integer): string;
    procedure DoHeaderFooter(AHeaderFooter: THeaderFooter; AHandle: HDC;
      APixelsPerInch: integer; APage: integer);
    procedure SetShowMargin(AValue: boolean);

    function IsPrinterAvailable: boolean;
    procedure GetPrinterCaps;
    procedure ComputeNumberOfPages;
    procedure BuildPageMetaFile(APageNumber: integer);
    procedure BuildPreviewMetaFile;
    procedure ComputeScale(AValue: single);

    procedure SetScaleMode(AScaleMode: TScaleMode);
    procedure SetScale(AValue: single);

    procedure DisplayScrollBars;
    procedure UpdateHorzScrollBar;
    procedure UpdateVertScrollBar;
    procedure HorzScrollTo(AValue: integer);
    procedure VertScrollTo(AValue: integer);
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMMouseActivate(var Msg: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RichEdit: TRichEdit read FRichEdit write FRichEdit;
    property Align default alClient;
    property Color default clAppWorkspace;
    property Visible default True;

    property MarginInMM: boolean read FMarginInMM write FMarginInMM;
    property ShowMargin: boolean read FShowMargin write SetShowMargin;
    property TopMargin: single read GetTopMargin write SetTopMargin;
    property BottomMargin: single read GetBottomMargin write SetBottomMargin;
    property LeftMargin: single read GetLeftMargin write SetLeftMargin;
    property RightMargin: single read GetRightMargin write SetRightMargin;

    property HeaderHeight: single read GetHeaderHeight write SetHeaderHeight;
    property HeaderFont: TFont read GetHeaderFont write SetHeaderFont;
    property FooterHeight: single read GetFooterHeight write SetFooterHeight;
    property FooterFont: TFont read GetFooterFont write SetFooterFont;

    property CurrentPage: integer read FCurrentPage;
    property NumberOfPages: integer read FNumberOfPages;

    property MinScale: single read FMinScale;
    property MaxScale: single read FMaxScale;
    property ScaleMode: TScaleMode read FScaleMode write SetScaleMode;
    property Scale: single read FScale write SetScale;

    property OnScaleChange: TScaleEvent read FOnScaleChange write FOnScaleChange;
    property OnScaleModeChange: TScaleModeEvent read FOnScaleModeChange
      write FOnScaleModeChange;
    property OnPrint: TPrintEvent read FOnPrint write FOnPrint;

    property PrintTitle: string read FPrintTitle write FPrintTitle;
    procedure GetHeaderText(var ALeftText, ACenterText, ARightText: string);
    procedure SetHeaderText(ALeftText, ACenterText, ARightText: string);
    procedure GetFooterText(var ALeftText, ACenterText, ARightText: string);
    procedure SetFooterText(ALeftText, ACenterText, ARightText: string);

    procedure Reset;
    procedure Display;
    procedure FirstPage;
    procedure PreviousPage;
    procedure NextPage;
    procedure LastPage;
    procedure GotoPage(APage: integer);

    procedure Print(FromPage, ToPage: integer);

  end;


implementation

uses Types;

{ TRichEditPrintPreview }

{------------------------------------------------------------------------------}
{ Private                                                                      }
{------------------------------------------------------------------------------}

function TRichEditPrintPreview.MMToInch(AValue: single): single;
// Convert millimeter into inch
begin
  result:= AValue / 25.4;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.InchToMM(AValue: single): single;
// Convert inch into millimeter
begin
  result:= AValue * 25.4;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetTopMargin(AValue: single);
// Set top margin with a minimum of printer margin
begin
  if FMarginInMM then AValue:= MMToInch(AValue);
  if (AValue < 0) then AValue:= 0;
  FUserMargins.Top:= Round(AValue * TwipsPerInch);
  if FUserMargins.Top < FPrinterCaps.Margins.Top then
    FUserMargins.Top:= FPrinterCaps.Margins.Top;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetTopMargin: single;
// Return the top margin in the proper unit
var
  AValue: single;
begin
  AValue:= FUserMargins.Top / TwipsPerInch;
  if FMarginInMM then result:= InchToMM(AValue)
                 else result:= AValue;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetBottomMargin(AValue: single);
// Set bottom margin with a minimum of printer margin
begin
  if FMarginInMM then AValue:= MMToInch(AValue);
  if (AValue < 0) then AValue:= 0;
  FUserMargins.Bottom:= Round(AValue * TwipsPerInch);
  if FUserMargins.Bottom < FPrinterCaps.Margins.Bottom then
    FUserMargins.Bottom:= FPrinterCaps.Margins.Bottom;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetBottomMargin: single;
// Return the bottom margin in the proper unit
var
  AValue: single;
begin
  AValue:= FUserMargins.Bottom / TwipsPerInch;
  if FMarginInMM then result:= InchToMM(AValue)
                 else result:= AValue;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetLeftMargin(AValue: single);
// Set left margin with a minimum of printer margin
begin
  if FMarginInMM then AValue:= MMToInch(AValue);
  if (AValue < 0) then AValue:= 0;
  FUserMargins.Left:= Round(AValue * TwipsPerInch);
  if FUserMargins.Left < FPrinterCaps.Margins.Left then
    FUserMargins.Left:= FPrinterCaps.Margins.Left;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetLeftMargin: single;
// Return the left margin in the proper unit
var
  AValue: single;
begin
  AValue:= FUserMargins.Left / TwipsPerInch;
  if FMarginInMM then result:= InchToMM(AValue)
                 else result:= AValue;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetRightMargin(AValue: single);
// Set right margin with a minimum of printer margin
begin
  if FMarginInMM then AValue:= MMToInch(AValue);
  if (AValue < 0) then AValue:= 0;
  FUserMargins.Right:= Round(AValue * TwipsPerInch);
  if FUserMargins.Right < FPrinterCaps.Margins.Right then
    FUserMargins.Right:= FPrinterCaps.Margins.Right;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetRightMargin: single;
// Return the right margin in the proper unit
var
  AValue: single;
begin
  AValue:= FUserMargins.Right / TwipsPerInch;
  if FMarginInMM then result:= InchToMM(AValue)
                 else result:= AValue;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetHeaderHeight: single;
// Return the header height in the proper unit
var
  AValue: single;
begin
  AValue:= FHeader.Height / TwipsPerInch;
  if FMarginInMM then result:= InchToMM(AValue)
                 else result:= AValue;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetHeaderHeight(AValue: single);
// Set header height
begin
  if FMarginInMM then AValue:= MMToInch(AValue);
  if (AValue < 0) then AValue:= 0;
  FHeader.Height:= Round(AValue * TwipsPerInch);
  if FHeader.Height < 0 then FHeader.Height:= 0;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetHeaderFont: TFont;
// Return font used for header
begin
  result:= FHeader.Font;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetHeaderFont(AFont: TFont);
// Set font used for header
begin
  FHeader.Font:= AFont;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetFooterHeight: single;
// Return the footer height in the proper unit
var
  AValue: single;
begin
  AValue:= FFooter.Height / TwipsPerInch;
  if FMarginInMM then result:= InchToMM(AValue)
                 else result:= AValue;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetFooterHeight(AValue: single);
// Set footer height
begin
  if FMarginInMM then AValue:= MMToInch(AValue);
  if (AValue < 0) then AValue:= 0;
  FFooter.Height:= Round(AValue * TwipsPerInch);
  if FFooter.Height < 0 then FFooter.Height:= 0;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.GetFooterFont: TFont;
// Return font used for footer
begin
  result:= FFooter.Font;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetFooterFont(AFont: TFont);
// Set font used for footer
begin
  FFooter.Font:= AFont;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.ConvertText(AText: string; APage: integer): string;
// Convert keywords in AText and return it
// [PAGE] = current page, [PAGES] = total number of pages
// [Y] = year , [M] = month, [D] = day,
// [h] = hours, [n] = minutes, [s] = secondes
var
  AYear: string;
  AMonth: string;
  ADay: string;
  AnHour: string;
  AMinutes: string;
  ASecondes: string;
begin
  // Title
  AText:= StringReplace(AText, '[TITLE]',FPrintTitle,[rfReplaceAll]);
  // Pages
  AText:= StringReplace(AText, '[PAGE]',IntToStr(APage),[rfReplaceAll]);
  AText:= StringReplace(AText, '[PAGES]',IntToStr(FNumberOfPages),[rfReplaceAll]);
  // Date and time
  AYear:= FormatDateTime('yyyy',FPreviewDate);
  AMonth:= FormatDateTime('mm',FPreviewDate);
  ADay:= FormatDateTime('dd',FPreviewDate);
  AnHour:= FormatDateTime('hh',FPreviewDate);
  AMinutes:= FormatDateTime('nn',FPreviewDate);
  ASecondes:= FormatDateTime('ss',FPreviewDate);
  AText:= StringReplace(AText, '[Y]',AYear,[rfReplaceAll]);
  AText:= StringReplace(AText, '[M]',AMonth,[rfReplaceAll]);
  AText:= StringReplace(AText, '[D]',ADay,[rfReplaceAll]);
  AText:= StringReplace(AText, '[h]',AnHour,[rfReplaceAll]);
  AText:= StringReplace(AText, '[n]',AMinutes,[rfReplaceAll]);
  AText:= StringReplace(AText, '[s]',ASecondes,[rfReplaceAll]);
  result:= AText;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.DoHeaderFooter(
  AHeaderFooter: THeaderFooter; AHandle: HDC; APixelsPerInch,
  APage: integer);
// Render header or footer
var
  ARect: TRect;
  DT: byte;
  AText: string;
begin
  with AHeaderFooter do
  begin
    if Header then
    begin
      DT:= DT_TOP;
      ARect.Left:= MulDiv(FPrintableArea.Left,APixelsPerInch,TwipsPerInch);
      ARect.Top:= MulDiv(FPrintableArea.Top - Height,APixelsPerInch,TwipsPerInch);
      ARect.Right:= MulDiv(FPrintableArea.Right,APixelsPerInch,TwipsPerInch);
      ARect.Bottom:= MulDiv(FPrintableArea.Top,APixelsPerInch,TwipsPerInch);
    end
    else
    begin
      DT:= DT_BOTTOM;
      ARect.Left:= MulDiv(FPrintableArea.Left,APixelsPerInch,TwipsPerInch);
      ARect.Top:= MulDiv(FPrintableArea.Bottom,APixelsPerInch,TwipsPerInch);
      ARect.Right:= MulDiv(FPrintableArea.Right,APixelsPerInch,TwipsPerInch);
      ARect.Bottom:= MulDiv(FPrintableArea.Bottom + Height,APixelsPerInch,TwipsPerInch);
    end;
    AText:= ConvertText(LeftText, APage);
    DrawText(AHandle,pchar(AText),length(AText),ARect,DT or DT_LEFT);
    AText:= ConvertText(CenterText, APage);
    DrawText(AHandle,pchar(AText),length(AText),ARect,DT or DT_CENTER);
    AText:= ConvertText(RightText, APage);
    DrawText(AHandle,pchar(AText),length(AText),ARect,DT or DT_RIGHT);
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetShowMargin(AValue: boolean);
// Set show margin status
begin
  FShowMargin:= AValue;
  Display;
end;

{------------------------------------------------------------------------------}

function TRichEditPrintPreview.IsPrinterAvailable: boolean;
// Return true if we can get access to the printer
begin
  try
    result:= Printer.Handle <> 0;
  except
    result:= false;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.GetPrinterCaps;
// Get the printer capabilities
// Full page area, printable area expressed in twips
var
  AValue: integer;
begin
  with FPrinterCaps do
  begin
    if IsPrinterAvailable then
    begin
      PrtHandle:= Printer.Handle;
      XPixelsPerInch:= GetDeviceCaps(PrtHandle, LOGPIXELSX);
      YPixelsPerInch:= GetDeviceCaps(PrtHandle, LOGPIXELSY);
      // Full page
      PageArea.Left:= 0;
      PageArea.Top:= 0;
      AValue:= GetDeviceCaps(PrtHandle, PHYSICALWIDTH);
      PageArea.Right:= MulDiv(AValue,TwipsPerInch,XPixelsPerInch);
      AValue:= GetDeviceCaps(PrtHandle, PHYSICALHEIGHT);
      PageArea.Bottom:= MulDiv(AValue,TwipsPerInch,YPixelsPerInch);
      // Printing area
      AValue:= GetDeviceCaps(PrtHandle, PHYSICALOFFSETX);
      PrintingArea.Left:= MulDiv(AValue,TwipsPerInch,XPixelsPerInch);
      AValue:= GetDeviceCaps(PrtHandle, PHYSICALOFFSETY);
      PrintingArea.Top:= MulDiv(AValue,TwipsPerInch,YPixelsPerInch);
      AValue:= GetDeviceCaps(PrtHandle, HORZRES);
      PrintingArea.Right:= MulDiv(AValue,TwipsPerInch,XPixelsPerInch);
      AValue:= GetDeviceCaps(PrtHandle, VERTRES);
      PrintingArea.Bottom:= MulDiv(AValue,TwipsPerInch,YPixelsPerInch);
      // Printer margins
      Margins.Left:= PrintingArea.Left;
      Margins.Top:= PrintingArea.Top;
      Margins.Right:= PageArea.Right - PrintingArea.Right - Margins.Left;
      Margins.Bottom:= PageArea.Bottom - PrintingArea.Bottom - Margins.Top;
    end
    else
    begin
      // Default values corresponding to Epson Stylus 800+ with A4 paper
      PrtHandle:= 0;
      XPixelsPerInch:= 360;
      YPixelsPerInch:= 360;
      PageArea.Left:= 0;
      PageArea.Top:= 0;
      PageArea.Right:= 11908;
      PageArea.Bottom:= 16832;
      PrintingArea.Left:= 172;
      PrintingArea.Top:= 172;
      PrintingArea.Right:= 11520;
      PrintingArea.Bottom:= 15856;
      Margins.Left:= 172;
      Margins.Right:= 216;
      Margins.Top:= 172;
      Margins.Bottom:= 737;
    end;
    // Adapt user margin if needed
    if FUserMargins.Top < FPrinterCaps.Margins.Top then
      FUserMargins.Top:= FPrinterCaps.Margins.Top;
    if FUserMargins.Bottom < FPrinterCaps.Margins.Bottom then
      FUserMargins.Bottom:= FPrinterCaps.Margins.Bottom;
    if FUserMargins.Right < FPrinterCaps.Margins.Right then
      FUserMargins.Right:= FPrinterCaps.Margins.Right;
    if FUserMargins.Left < FPrinterCaps.Margins.Left then
      FUserMargins.Left:= FPrinterCaps.Margins.Left;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.ComputeNumberOfPages;
// Compute the number of page to print for current printer
var
  AHDC: HDC;
  ALastChar: integer;
  ARange: TFormatRange;
  RichEditLastChar: integer;
begin
  if FRichEdit <> nil then
  begin
    FPageList.Clear;
    // Compute real printable area
    GetPrinterCaps;
    // Select rendering DC
    AHDC:= FPrinterCaps.PrtHandle;
    // Compute user printing area
    FPrintableArea.Left:= FUserMargins.Left;
    FPrintableArea.Top:= FUserMargins.Top + FHeader.Height;
    FPrintableArea.Right:= FPrinterCaps.PageArea.Right
      - FUserMargins.Right;
    FPrintableArea.Bottom:= FPrinterCaps.PageArea.Bottom
      - FUserMargins.Bottom - FFooter.Height;

    // Formatting range initialization
    FillChar(ARange,SizeOf(TFormatRange),0);
    ARange.hdc:= AHDC;
    ARange.hdcTarget:= ARange.hdc;
    SaveDC(ARange.hdc);
    ARange.rc:= FPrintableArea;
    ARange.rcPage:= FPrinterCaps.PageArea;
    ARange.chrg.cpMax:= -1;
    // Clear formatting buffer
    SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 0, 0);
    // Initialize other variables
    RichEditLastChar:= FRichEdit.GetTextLen;
    ALastChar:= 0;
    // Get all pages
    while (ALastChar <> -1) and (ALastChar < RichEditLastChar) do
    begin
      ARange.chrg.cpMin:= ALastChar;
      ALastChar:=
        SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 0, Longint(@ARange));
      FPageList.Add(IntToStr(ALastChar));
    end;
    // Restore rendering DC if needed
    RestoreDC(ARange.hdc, - 1);
    // Clear formatting buffer
    SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 0, 0);
    FNumberOfPages:= FPageList.Count;
  end
  else
    FNumberOfPages:= 0;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.BuildPageMetaFile(APageNumber: integer);
// Build a metafile corresponding to the page to render
var
  MetaFileCanvas: TMetafileCanvas;
  AHDC: HDC;
  ARange: TFormatRange;
  APixelsPerInch: integer;
begin
  if APageNumber > 0 then
  begin
    // it seems that printer handle is not kept between pages
    if FPrinterCaps.PrtHandle <> 0 then FPrinterCaps.PrtHandle:= Printer.Handle;
    MetaFileCanvas:= TMetafileCanvas.Create(FPageMetaFile,FPrinterCaps.PrtHandle);
    MetaFileCanvas.CopyMode:= cmSrcCopy;
    APixelsPerInch:= FPrinterCaps.XPixelsPerInch;
    MetaFileCanvas.Font.PixelsPerInch:= APixelsPerInch;

    // Header
    if FHeader.Height > 0 then
    begin
      MetaFileCanvas.Font.Assign(FHeader.Font);
      DoHeaderFooter(FHeader,MetaFileCanvas.Handle,APixelsPerInch,APageNumber);
    end;

    // Footer
    if FFooter.Height > 0 then
    begin
      MetaFileCanvas.Font.Assign(FFooter.Font);
      DoHeaderFooter(FFooter,MetaFileCanvas.Handle,APixelsPerInch,APageNumber);
    end;

    // Formatting range initialization
    FillChar(ARange,SizeOf(TFormatRange),0);
    // Where did we print
    AHDC:= MetaFileCanvas.Handle;
    ARange.hdc:= AHDC;
    ARange.hdcTarget:= AHDC;
    SaveDC(ARange.hdc);
    ARange.rc:= FPrintableArea;
    ARange.rcPage:= FPrinterCaps.PageArea;
    if APageNumber = 1 then
      ARange.chrg.cpMin:= 0
    else
      ARange.chrg.cpMin:= StrToInt(FPageList[APageNumber-2]);
    ARange.chrg.cpMax:= StrToInt(FPageList[APageNumber-1]);
    SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 1, Longint(@ARange));
    RestoreDC(ARange.hdc, - 1);
    // Clear formatting buffer
    SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 0, 0);

    MetaFileCanvas.Free;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.BuildPreviewMetaFile;
// Build a metafile corresponding to tbe page to render for preview
var
  MetaFileCanvas: TMetafileCanvas;
  APixelsPerInch: integer;
  ARect: TRect;
  AValue: integer;
begin
  if FCurrentPage > 0 then
  begin
    MetaFileCanvas:= TMetafileCanvas.Create(FPreviewMetaFile,FPrinterCaps.PrtHandle);
    MetaFileCanvas.CopyMode:= cmSrcCopy;
    APixelsPerInch:= FPrinterCaps.XPixelsPerInch;
    MetaFileCanvas.Font.PixelsPerInch:= APixelsPerInch;
    // Draw paper
    ARect.Left:= 0;
    ARect.Top:= 0;
    ARect.Right:= MulDiv(FPrinterCaps.PageArea.Right,APixelsPerInch,TwipsPerInch);
    ARect.Bottom:= MulDiv(FPrinterCaps.PageArea.Bottom,APixelsPerInch,TwipsPerInch);
    with MetaFileCanvas do
    begin
      Brush.Color:= clWhite;
      Brush.Style:= bsSolid;
      FillRect(ARect);
    end;
    // Draw header, footer, richedit
    BuildPageMetaFile(FCurrentPage);
    MetaFileCanvas.Draw(0,0,FPageMetaFile);
    // Draw margins
    if FShowMargin then
    begin
      // Draw margins
      ARect.Left:= MulDiv(FPrintableArea.Left,APixelsPerInch,TwipsPerInch);
      ARect.Top:= MulDiv(FPrintableArea.Top - FHeader.Height,APixelsPerInch,TwipsPerInch);
      ARect.Right:= MulDiv(FPrintableArea.Right,APixelsPerInch,TwipsPerInch);
      ARect.Bottom:= MulDiv(FPrintableArea.Bottom + FFooter.Height,APixelsPerInch,TwipsPerInch);
      with MetaFileCanvas do
      begin
        Pen.Color:= clSilver;
        Pen.Style:= psDash;
        // Top
        MoveTo(0,ARect.Top);
        AValue:= MulDiv(FPrinterCaps.PageArea.Right,APixelsPerInch,TwipsPerInch);
        LineTo(AValue,ARect.Top);
        // Header
        if FHeader.Height > 0 then
        begin
          ARect.Top:= MulDiv(FPrintableArea.Top,APixelsPerInch,TwipsPerInch);
          MoveTo(0,ARect.Top);
          LineTo(AValue,ARect.Top);
        end;
        //Right
        MoveTo(ARect.Right,0);
        AValue:= MulDiv(FPrinterCaps.PageArea.Bottom,APixelsPerInch,TwipsPerInch);
        LineTo(ARect.Right,AValue);
        // Bottom
        AValue:= MulDiv(FPrinterCaps.PageArea.Right,APixelsPerInch,TwipsPerInch);
        MoveTo(AValue,ARect.Bottom);
        LineTo(0,ARect.Bottom);
        // Footer
        if FFooter.Height > 0 then
        begin
          ARect.Bottom:= MulDiv(FPrintableArea.Bottom,APixelsPerInch,TwipsPerInch);
          MoveTo(AValue,ARect.Bottom);
          LineTo(0,ARect.Bottom);
        end;
        // Left
        AValue:= MulDiv(FPrinterCaps.PageArea.Bottom,APixelsPerInch,TwipsPerInch);
        MoveTo(ARect.Left,AValue);
        LineTo(ARect.Left,0);
      end;
    end;

    MetaFileCanvas.Free;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.ComputeScale(AValue: single);
// Compute scale to adapt metafile in twips to screen display
var
  OldScale: single;
  XScale: single;
  YScale: single;
  DisplayWidth: integer;
  DisplayHeight: integer;
begin
  // Prevent circular reference
  FUpdatingPreview:= true;

  DisplayScrollBars;
  OldScale:= FScale;
  DisplayWidth:= round(0.96*ClientWidth);
  DisplayHeight:= round(0.96*ClientHeight);
  case FScaleMode of
    smPageWidth:
    begin
      FScale:= MulDiv(DisplayWidth,FPrinterCaps.XPixelsPerInch,Screen.PixelsPerInch) / FPreviewMetaFile.Width;
    end;
    smWholePage:
    begin
      XScale:= MulDiv(DisplayWidth,TwipsPerInch,Screen.PixelsPerInch) / FPrinterCaps.PrintingArea.Right;
      YScale:= MulDiv(DisplayHeight,TwipsPerInch,Screen.PixelsPerInch) / FPrinterCaps.PrintingArea.Bottom;
      if XScale < YScale then FScale:= XScale
                         else FScale:= YScale;
    end;
    else
    begin
      FScale:= AValue;
    end;
  end;

  // Virtual page
  FVPageWidth:= MulDiv(round(FPrinterCaps.PrintingArea.Right * FScale),
    Screen.PixelsPerInch, TwipsPerInch);
  FVPageHeight:= MulDiv(round(FPrinterCaps.PrintingArea.Bottom * FScale),
    Screen.PixelsPerInch, TwipsPerInch);
  // Diplaying offset
  if ((FScaleMode = smScaled) and (OldScale <> FScale)) then
  begin
    FVXOffset:= round((FVXOffset * FScale) / OldScale);
    FVYOffset:= round((FVYOffset * FScale) / OldScale);
  end
  else
  begin
    FVXOffset:= 0;
    FVYOffset:= 0;
  end;

  // Trick to compensate a mistake not already found
  // Without that, right and bottom part of the page cannot be viewed
  // Did not find why for now
  FBorder.Right:= round(27 * FScale);
  FBorder.Bottom:= round(69 * FScale);

  // Readjust postion if too much left or top shiffted
  if (FVPageWidth + FBorder.Right - FVXOffset) < DisplayWidth then
    FVXOffset:= FVPageWidth + FBorder.Right - DisplayWidth;
  if (FVPageHeight + FBorder.Bottom - FVYOffset) < DisplayHeight then
    FVYOffset:= FVPageHeight + FBorder.Bottom - DisplayHeight;

  // Center page if needed
  if FVPageWidth < DisplayWidth then
    FVXOffset:= -(DisplayWidth - FVPageWidth) div 2
  else
    if FVXOffset < 0 then FVXOffset:= 0;

  if FVPageHeight < DisplayHeight then
    FVYOffset:= -(DisplayHeight - FVPageHeight) div 2
  else
    if FVYOffset < 0 then FVYOffset:= 0;

  Invalidate;

  FUpdatingPreview:= false;
  if ((OldScale <> FScale) and assigned(FOnScaleChange)) then
   FOnScaleChange(self,FScale)
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetScaleMode(AScaleMode: TScaleMode);
// Set the scale mode and adapt scale for previewing
begin
  FScaleMode:= AScaleMode;
  ComputeScale(FScale);
  if assigned(FOnScaleModeChange) then FOnScaleModeChange(self,FScaleMode)
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetScale(AValue: single);
// Set the scale for previewing
begin
  if AValue < MinScale then AValue:= MinScale;
  if AValue > MaxScale then AValue:= MaxScale;
  FScaleMode:= smScaled;
  ComputeScale(AValue);
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.DisplayScrollBars;
// Display scrollbars
begin
  if FRichEdit <> nil then
  begin
    case FScaleMode of
      smWholePage:
      begin
        ShowScrollbar(Handle, SB_HORZ, False);
        ShowScrollbar(Handle, SB_VERT, False);
      end;
      smPageWidth:
      begin
        ShowScrollbar(Handle, SB_HORZ, False);
        ShowScrollbar(Handle, SB_VERT, True);
      end;
    else
      ShowScrollbar(Handle, SB_HORZ, True);
      ShowScrollbar(Handle, SB_VERT, True);
    end;
  end
  else
  begin
    ShowScrollbar(Handle, SB_HORZ, False);
    ShowScrollbar(Handle, SB_VERT, False);
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.UpdateHorzScrollBar;
// Update horizontal scrollbar position
var
  AScrollInfo: TScrollInfo;
  DisplayWidth: integer;
begin
  if FScaleMode = smScaled then
  begin
    DisplayWidth:= ClientWidth;
    FillChar(AScrollInfo, SizeOf(TScrollInfo), 0);
    AScrollInfo.cbSize := SizeOf(TScrollInfo);
    AScrollInfo.fMask:= SIF_ALL;
    AScrollInfo.nMin:= 1;
    AScrollInfo.nMax:= FVPageWidth + FBorder.Right;
    AScrollInfo.nPage:= DisplayWidth;
    AScrollInfo.nPos:= FVXOffset;
    SetScrollInfo(Handle, SB_HORZ, AScrollInfo, True);
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.UpdateVertScrollBar;
// Update vertical scrollbar position
var
  AScrollInfo: TScrollInfo;
  DisplayHeight: integer;
begin
  if FScaleMode in [smPageWidth, smScaled] then
  begin
    DisplayHeight:= ClientHeight;
    FillChar(AScrollInfo, SizeOf(TScrollInfo), 0);
    AScrollInfo.cbSize := SizeOf(TScrollInfo);
    AScrollInfo.fMask:= SIF_ALL;
    AScrollInfo.nMin:= 1;
    AScrollInfo.nMax:= FVPageHeight +  FBorder.Bottom;
    AScrollInfo.nPage:= DisplayHeight;
    AScrollInfo.nPos:= FVYOffset;
    SetScrollInfo(Handle, SB_VERT, AScrollInfo, True);
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.HorzScrollTo(AValue: integer);
// Scroll horizontaly to a virtual point
var
  DisplayWidth: integer;
begin
  DisplayWidth:= ClientWidth;
  if (AValue + DisplayWidth) > (FVPageWidth + FBorder.Right) then
     AValue:= (FVPageWidth + FBorder.Right)- DisplayWidth;
  if AValue < 0 then AValue:= 0;
  // Display only if changed
  if AValue <> FVXOffset then
  begin
    FVXOffset:= AValue;
    Invalidate;
  end
  else Beep;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.VertScrollTo(AValue: integer);
// Scroll verticaly to a virtual point
var
  DisplayHeight: integer;
begin
  DisplayHeight:= ClientHeight;
  if (AValue + DisplayHeight) > (FVPageHeight + FBorder.Bottom) then
     AValue:= (FVPageHeight + FBorder.Bottom) - DisplayHeight;
  if AValue < 0 then AValue:= 0;
  // Display only if changed
  if AValue <> FVYOffset then
  begin
    FVYOffset:= AValue;
    Invalidate;
  end
  else Beep;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.WMHScroll(var Msg: TWMHScroll);
// Do an horizontal scroll from scroll bar
var
  DisplayWidth: integer;
begin
  DisplayWidth:= ClientWidth;
  case Msg.ScrollCode of
    SB_LINELEFT: HorzScrollTo(FVXOffset - (DisplayWidth div 10));
    SB_LINERIGHT: HorzScrollTo(FVXOffset + (DisplayWidth div 10));
    SB_PAGELEFT: HorzScrollTo(FVXOffset - DisplayWidth);
    SB_PAGERIGHT: HorzScrollTo(FVXOffset + DisplayWidth);
    SB_THUMBTRACK: HorzScrollTo(Msg.Pos);
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.WMVScroll(var Msg: TWMVScroll);
// Do a vertical scroll from scroll bar
var
  DisplayHeight: integer;
begin
  DisplayHeight:= ClientHeight;
  case Msg.ScrollCode of
    SB_LINEUP: VertScrollTo(FVYOffset - (DisplayHeight div 10));
    SB_LINEDOWN: VertScrollTo(FVYOffset + (DisplayHeight div 10));
    SB_PAGEUP: VertScrollTo(FVYOffset - DisplayHeight);
    SB_PAGEDOWN: VertScrollTo(FVYOffset + DisplayHeight);
    SB_THUMBTRACK: VertScrollTo(Msg.Pos);
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.WMMouseActivate(var Msg: TWMMouseActivate);
// Bring focus to preview
begin
  SetFocus;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.WMMouseWheel(var Message: TWMMouseWheel);
// Do a mouse wheel scroll
var
  AValue: integer;
  DisplayHeight: integer;
begin
  AValue:= Message.WheelDelta;
  DisplayHeight:= ClientHeight;
  // Scroll only if partially visible
  if FVPageHeight > DisplayHeight then
  begin
    if AValue < 0 then VertScrollTo(FVYOffset + (DisplayHeight div 10))
                  else VertScrollTo(FVYOffset - (DisplayHeight div 10));
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.WMSize(var Msg: TWMSize);
// Update display when resized
begin
  if not FUpdatingPreview then ComputeScale(FScale);
end;

{------------------------------------------------------------------------------}
{ Protected                                                                    }
{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.Paint;
// Paint on canvas
var
  VirtualRect: TRect;
  ARect: TRect;
begin
  inherited;
  if (FRichEdit <> nil) and (Parent <> nil) then
  begin
    // Clean area
    with Canvas do
    begin
      Brush.Color:= clAppWorkSpace;
      Brush.Style:= bsSolid;
      FillRect(ClientRect);
    end;
    // Display richedit
    if FCurrentPage > 0 then
    begin
      with VirtualRect do
      begin
        Left:= -FVXOffset;
        Top:= -FVYOffset;
        Right:= FVPageWidth - FVXOffset; // a reduire pour voir les marges ??
        Bottom:= FVPageHeight - FVYOffset; // a reduire pour voir les marges ??
      end;
      ARect.Right:= FPreviewMetaFile.Width;
      ARect.Bottom:= FPreviewMetaFile.Height;
      Canvas.StretchDraw(VirtualRect,FPreviewMetaFile);
    end;
    // Update scrollbars
    UpdateHorzScrollBar;
    UpdateVertScrollBar;
  end;
end;

{------------------------------------------------------------------------------}
{ Public                                                                       }
{------------------------------------------------------------------------------}

constructor TRichEditPrintPreview.Create(AOwner: TComponent);
begin
  inherited;
  Width := 300;
  Height := 300;
  ParentColor := False;
  Color := clAppWorkspace;
  Visible := True;
  Align := alClient;
  DoubleBuffered:= true;
  TabStop:= true;
  Enabled:= true;
  // Margins
  FMarginInMM:= true;
  FShowMargin:= false;
  with FUserMargins do
  begin
    Top:= 283;    // 5 mm
    Bottom:= 283; // 5mm
    Left:= 851;   // 15 mm
    Right:= 0;    // 0 mm
  end;
  FPrintTitle:= '';
  // Header
  FHeader.Header:= true;
  FHeader.Height:= 0;
  FHeader.Font:= TFont.Create;
  FHeader.Font.Name:= 'Arial';
  FHeader.Font.Size:= 10;
  SetHeaderText('','','');
  // Footer
  FFooter.Header:= false;
  FFooter.Height:= 0;
  FFooter.Font:= TFont.Create;
  FFooter.Font.Name:= 'Arial';
  FFooter.Font.Size:= 10;
  SetFooterText('','','');
  // space between paper and display area
  with FBorder do
  begin
    Top:= 5;
    Bottom:= 5;
    Left:= 5;
    Right:= 5;
  end;

  FCurrentPage:= 0;
  FNumberOfPages:= 0;

  FMinScale:= 0.125;
  FMaxScale:= 16.0;
  FScaleMode:= smScaled;
  FScale:= 1.0;

  FPageList:= TStringList.Create;
  FPreviewMetaFile:= TMetafile.Create;
  FPageMetaFile:= TMetafile.Create;
  FUpdatingPreview:= false;

  GetPrinterCaps;
end;

{------------------------------------------------------------------------------}

destructor TRichEditPrintPreview.Destroy;
begin
  FHeader.Font.Free;
  FFooter.Font.Free;
  FPageMetaFile.Free;
  FPreviewMetaFile.Free;
  FPageList.Free;
  inherited;
end;

{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ Published                                                                    }
{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.GetHeaderText(var ALeftText, ACenterText,
  ARightText: string);
// Get the different text of header
begin
  with FHeader do
  begin
    ALeftText:= LeftText ;
    ACenterText:= CenterText;
    ARightText:= RightText;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetHeaderText(ALeftText, ACenterText,
  ARightText: string);
// Set the different text for header
begin
  with FHeader do
  begin
    LeftText:= ALeftText;
    CenterText:= ACenterText;
    RightText:= ARightText;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.GetFooterText(var ALeftText, ACenterText,
  ARightText: string);
// Get the different text of footer
begin
  with FFooter do
  begin
    ALeftText:= LeftText;
    ACenterText:= CenterText;
    ARightText:= RightText;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.SetFooterText(ALeftText, ACenterText,
  ARightText: string);
// Set the different text for footer
begin
  with FFooter do
  begin
    LeftText:= ALeftText;
    CenterText:= ACenterText;
    RightText:= ARightText;
  end;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.Reset;
// Reset print preview
begin
  FCurrentPage:= 1;
  FScaleMode:= smScaled;
  FScale:= 1.0;
  FPreviewDate:= Now;
  ComputeNumberOfPages;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.Display;
// Compute and display preview
begin
  ComputeNumberOfPages;
  BuildPreviewMetaFile;
  ComputeScale(FScale);
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.FirstPage;
// Go to first page and preview it
begin
  FCurrentPage:= 1;
  Display;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.PreviousPage;
// Go to previous page and preview it
begin
  if FCurrentPage > 1 then dec(FCurrentPage);
  Display;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.NextPage;
// Go to next page and preview it
begin
  if FCurrentPage < FNumberOfPages then inc(FCurrentPage);
  Display;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.LastPage;
// Go to last page and preview it
begin
  FCurrentPage:= FNumberOfPages;
  Display;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.GotoPage(APage: integer);
// Go to the specified page and preview it
begin
  if APage < 1 then APage:= 1;
  if APage > FNumberOfPages then APage:= FNumberOfPages;
  FCurrentPage:= APage;
  Display;
end;

{------------------------------------------------------------------------------}

procedure TRichEditPrintPreview.Print(FromPage, ToPage: integer);
// Print the specified range of pages
var
  PrintedPage: integer;
  ARect: TRect;
begin
  if IsPrinterAvailable and (FNumberOfPages > 0) then
  begin
    // compensate printer offset
    ARect.Left:= FPrinterCaps.PrintingArea.Left - FPrinterCaps.Margins.Left;
    ARect.Top:= FPrinterCaps.PrintingArea.Top  - FPrinterCaps.Margins.Top;
    ARect.Right:= FPrinterCaps.PrintingArea.Right;
    ARect.Bottom:= FPrinterCaps.PrintingArea.Bottom;
    // compensate Windows compensation of printer offset - sic -
    ARect.Left:= ARect.Left - FPrinterCaps.Margins.Left;
    ARect.Top:= ARect.Top  - FPrinterCaps.Margins.Top;
    ARect.Right:= ARect.Right - FPrinterCaps.Margins.Left;
    ARect.Bottom:= ARect.Bottom  - FPrinterCaps.Margins.Top;
    // convert to printer pixels
    ARect.Left:= MulDiv(ARect.Left,FPrinterCaps.XPixelsPerInch,TwipsPerInch);
    ARect.Top:= MulDiv(ARect.Top,FPrinterCaps.XPixelsPerInch,TwipsPerInch);
    ARect.Right:= MulDiv(ARect.Right,FPrinterCaps.XPixelsPerInch,TwipsPerInch);
    ARect.Bottom:= MulDiv(ARect.Bottom,FPrinterCaps.XPixelsPerInch,TwipsPerInch);
    // adjust page numbers
    if FromPage < 1 then FromPage:= 1;
    if FromPage > FNumberOfPages then FromPage:= FNumberOfPages;
    if ToPage = -1 then ToPage:= FNumberOfPages
                   else if ToPage < FromPage then ToPage:= FromPage;
    if ToPage > FNumberOfPages then ToPage:= FNumberOfPages;
    // print
    Printer.Title:= FPrintTitle;
    Printer.BeginDoc;
    for PrintedPage:= FromPage to ToPage do
    begin
      BuildPageMetaFile(PrintedPage);
      if PrintedPage > FromPage then Printer.NewPage;
      Printer.Canvas.StretchDraw(ARect,FPageMetaFile);
      if assigned(FOnPrint) then FOnPrint(self,PrintedPage)
    end;
    Printer.EndDoc;
  end;
end;

end.


// Downloaded from: https://lazplanet.blogspot.com

unit frm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, fphttpclient, fpjson, jsonparser, opensslsockets;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnMiniToTray: TButton;
    btnSetHint: TButton;
    btnShowBalloon: TButton;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    edtHint: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MyPopup: TPopupMenu;
    MyTray: TTrayIcon;
    procedure btnMiniToTrayClick(Sender: TObject);
    procedure btnSetHintClick(Sender: TObject);
    procedure btnShowBalloonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure MyTrayClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    function FPHTTPClientDownload(URL: string; SaveToFile: boolean=false;
      Filename: string=''): string;

  public

  end;

var
  Form1: TForm1;
  woeids: TStringList;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
  var
   listitemsjson:string;
   YY,MM,DD : Word;
   datestring: string;
   url : string;
   J: TJSONData;
begin
  
  // get JSON response
  listitemsjson := FPHTTPClientDownload(edit1.text);
  J := GetJSON(listitemsjson);

  // show the data
  Memo1.Clear;
  with J.Items[0] do begin
    Memo1.Lines.Add( 'Weather state: ' + FindPath('weather_state_name').AsString );
    Memo1.Lines.Add( 'Minimum Temp: ' + FloatToStrF( FindPath('min_temp').AsFloat, ffFixed, 8, 2 ) + '°C' );
    Memo1.Lines.Add( 'Maximum Temp: ' + FloatToStrF( FindPath('max_temp').AsFloat, ffFixed, 8, 2 ) + '°C' );
    Memo1.Lines.Add( 'Temp: ' + FloatToStrF( FindPath('the_temp').AsFloat, ffFixed, 8, 2 ) + '°C' );
    Memo1.Lines.Add( 'Wind speed: ' + FloatToStrF( FindPath('wind_speed').AsFloat, ffFixed, 8, 2 ) );
    Memo1.Lines.Add( 'Air pressure: ' + FloatToStrF( FindPath('air_pressure').AsFloat, ffFixed, 8, 2 ) );
  end;

   btnSetHint.Enabled:= True;
   btnShowBalloon.Enabled:= True;
   btnMiniToTray.Enabled :=true;

end;

procedure TForm1.btnSetHintClick(Sender: TObject);
begin
  MyTray.Hint := 'Istanbulda bugun hava nasil';
end;

procedure TForm1.btnMiniToTrayClick(Sender: TObject);
begin
   WindowState:=wsMinimized;
  Hide;
end;

procedure TForm1.btnShowBalloonClick(Sender: TObject);


begin



  MyTray.BalloonTitle := 'Weather of Istanbul is:';
  MyTray.BalloonHint := memo1.lines[0]+ LineEnding + memo1.lines[1]+ LineEnding + memo1.lines[2]+ LineEnding + memo1.lines[3]+ LineEnding + memo1.lines[4];
  MyTray.ShowBalloonHint;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  woeids := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  woeids.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
  var
  listitemsjson:string;
  YY,MM,DD : Word;
  datestring: string;
  url : string;
  J: TJSONData;
begin
  // prepare the date string for use on the URL
   //InitSSLinterface;
  DeCodeDate (Date,YY,MM,DD);
  datestring:=format ('%d/%d/%d',[yy,mm,dd]);


  url :=
                       'https://www.metaweather.com/api/location/2344116'

                       +'/'+datestring+'/';

  edit1.text := url;


end;

procedure TForm1.Label4Click(Sender: TObject);
begin

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
end;

procedure TForm1.MyTrayClick(Sender: TObject);
begin
  if WindowState = wsMinimized then begin
     WindowState:=wsNormal;
    Show;
  end  else begin
    WindowState:=wsMinimized;
  end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  if WindowState = wsMinimized then begin
    WindowState:=wsNormal;
    Show;
  end;
end;

function TForm1.FPHTTPClientDownload(URL: string; SaveToFile: boolean = false; Filename: string = ''): string;
begin
  Result := '';
  With TFPHttpClient.Create(Nil) do
  try
    try
      if SaveToFile then begin
        Get(URL, Filename);
        Result := Filename;
      end else begin
        Result := Get(URL);
      end;
    except
      on E: Exception do
        ShowMessage('Error: ' + E.Message);
    end;
  finally
    Free;
  end;
end;

end.


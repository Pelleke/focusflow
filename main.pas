unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ExtCtrls, db, ZConnection, ZDataset;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnAdd: TButton;
    Button2: TButton;
    con: TZConnection;
    DBGrid1: TDBGrid;
    ed: TEdit;
    src: TDatasource;
    qry: TZReadOnlyQuery;
    tmr: TTimer;
    procedure btnAddClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure conAfterConnect(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure AddTick(Distracted: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure HideForm;
    procedure tmrTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.conAfterConnect(Sender: TObject);
begin

end;

procedure TfrmMain.btnAddClick(Sender: TObject);
var
  q: TZQuery;
begin
  ed.Text := Trim(ed.Text);
  if Length(ed.Text) = 0 then exit;

  q := TZQuery.Create(nil);
  try
    q.Connection := con;
    q.SQL.Add('INSERT INTO task(description) VALUES (:desc)');
     q.ParamByName('desc').AsString:=ed.Text;
     ed.Text := '';
     q.ExecSQL;
     qry.Refresh;
     qry.Last;
     Self.AddTick(false);
     Self.HideForm
  finally
    q.Free;
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  Self.AddTick(True);
end;

procedure TfrmMain.DBGrid1CellClick(Column: TColumn);
begin
  Self.AddTick(False);
end;

procedure TfrmMain.AddTick(Distracted: boolean);
var
  q: TZQuery;
  i: integer;
begin
  q := TZQuery.Create(nil);
  try
    q.Connection := con;
    q.SQL.Add('INSERT INTO tick(task_id, timestamp, distracted) VALUES (' + IntToStr(qry.FieldValues['id']) + ', CURRENT_TIMESTAMP, ');
    if Distracted then q.SQL.Add('1)') else q.SQL.Add('0)');
    q.ExecSQL;
    i:=qry.RecNo;
    qry.Refresh;
    qry.RecNo:=i;
  finally
    q.Free;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := MessageDlg('Really close?','Are you sure you wish to exit FocusFlow?',mtConfirmation,mbYesNo,0,mbNo) = mrYes;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.Left:= Screen.Width - Self.Width - 40;
  Self.Top:= Screen.Height - Self.Height - 40;
end;

procedure TfrmMain.HideForm;
begin
  tmr.Enabled:=true;
  Self.Hide;
  Application.Minimize;
end;

procedure TfrmMain.tmrTimer(Sender: TObject);
begin
  Self.Show;
  Application.BringToFront;
end;

end.


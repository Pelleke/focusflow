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
    btnDistracted: TButton;
    con: TZConnection;
    DBGrid1: TDBGrid;
    ed: TEdit;
    src: TDatasource;
    qry: TZReadOnlyQuery;
    tmr: TTimer;
    procedure btnAddClick(Sender: TObject);
    procedure btnDistractedClick(Sender: TObject);
    procedure AddTick(Distracted: Boolean);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HideForm;
    procedure tmrTimer(Sender: TObject);
    procedure ApplicationDeactivate(Sender: TObject);
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

procedure TfrmMain.btnAddClick(Sender: TObject);
var
  q: TZQuery;
begin
  ed.Text := Trim(ed.Text);
  if Length(ed.Text) = 0 then Self.AddTick(false)
  else begin
  q := TZQuery.Create(nil);
    try
      q.Connection := con;
      q.SQL.Add('INSERT INTO task(description) VALUES (:desc)');
      q.ParamByName('desc').AsString:=ed.Text;
      q.ExecSQL;
      qry.Refresh;
      qry.Last;
      Self.AddTick(false);
    finally
      q.Free;
    end;
  end;
end;

procedure TfrmMain.btnDistractedClick(Sender: TObject);
begin
  Self.AddTick(True);
end;

procedure TfrmMain.AddTick(Distracted: boolean);
var
  q: TZQuery;
  i: integer;
begin
  q := TZQuery.Create(nil);
  try
    { Clear the edit box }
    ed.Text := '';

    { Send a SQL query to the server adding the tick for the currently selected task }
    q.Connection := con;
    q.SQL.Add('INSERT INTO tick(task_id, timestamp, distracted) VALUES (' + IntToStr(qry.FieldValues['id']) + ', CURRENT_TIMESTAMP, ');
    if Distracted then q.SQL.Add('1)') else q.SQL.Add('0)');
    q.ExecSQL;

    { Refresh the dataset }
    i:=qry.RecNo;
    qry.Refresh;
    qry.RecNo:=i;

    Self.HideForm;
  finally
    q.Free;
  end;
end;

procedure TfrmMain.DBGrid1DblClick(Sender: TObject);
begin
  Self.AddTick(False);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := MessageDlg('Really close?','Are you sure you wish to exit FocusFlow?',mtConfirmation,mbYesNo,0,mbNo) = mrYes;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  qry.Active:=true;
  Application.OnDeactivate:=@ApplicationDeactivate;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Self.Left:= Screen.Width - Self.Width - 40;
  Self.Top:= Screen.Height - Self.Height - 40;
  ed.SetFocus;
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
  tmr.Enabled:=false;
end;

procedure TfrmMain.ApplicationDeactivate(Sender: TObject);
begin
  if (tmr.Enabled = False) then Application.BringToFront;
end;

end.


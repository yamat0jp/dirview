unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.Layouts, FMX.ListBox, FMX.ListView, System.Actions,
  FMX.ActnList, FMX.Menus;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    About1: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure About1Execute(Sender: TObject);
  private
    { private éŒ¾ }
    current: string;
    cnt: integer;
    function checkroot(const dir: string): Boolean;
    procedure getfiles(const dir: string);
    procedure getdir(const dir: string);
    function getname: string;
  public
    { public éŒ¾ }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Unit2;
{$R *.Macintosh.fmx _MACOS}

procedure TForm1.About1Execute(Sender: TObject);
begin
  Form2.ShowModal;
end;

function TForm1.checkroot(const dir: string): Boolean;
var
  s: string;
begin
  s := getname;
  result := (Copy(dir, 1, Length(s)) = s) and (Length(s) > Length(dir));
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  s, t: string;
begin
  t := ComboBox1.Items[ComboBox1.ItemIndex];
  if (Length(t) < Length(Caption)) or (checkroot(t) = false) then
  begin
    s := getname;
    if (s <> '') and (ComboBox1.Items.IndexOf(s) = -1) then
      ComboBox1.Items.Add(s);
    getdir(t);
    getfiles(t);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  current := GetCurrentDir;
  ComboBox1.Items.Add(current);
  cnt := 5;
  getdir(current);
  getfiles(current);
end;

procedure TForm1.getdir(const dir: string);
var
  s: string;
  i: integer;
  tmp: TStringList;
begin
  ListBox1.Items.Clear;
  tmp := TStringList.Create;
  try
    tmp.Delimiter := '\';
    tmp.DelimitedText := dir;
    s := tmp[0];
    for i := 1 to tmp.Count - cnt - 2 do
      s := s + '\' + tmp[i];
    i := tmp.Count - cnt - 1;
    if i < 0 then
    begin
      i := 0;
      s := '';
    end;
    while i < tmp.Count do
    begin
      ListBox1.Items.Add(tmp[i]);
      inc(i);
    end;
    if ListBox1.Count > 1 then
      ListBox1.Items.Insert(ListBox1.Count - 1, '---------');
    Caption := s;
    current := dir;
  finally
    tmp.Free;
  end;
end;

procedure TForm1.getfiles(const dir: string);
var
  rec: TSearchRec;
  i, j: integer;
begin
  ListView1.Items.Clear;
  i := FindFirst(dir + '\*', faAnyFile, rec);
  j := 0;
  while i = 0 do
  begin
    if (rec.Name[1] <> '.')and(rec.Attr and faHidden = 0) then
    begin
      if rec.Attr and faDirectory > 0 then
      begin
        ListView1.Items.AddItem(j).Text := rec.Name;
        inc(j);
      end
      else
        ListView1.Items.Add.Text := rec.Name;
    end;
    i := FindNext(rec);
  end;
  FindClose(rec);
end;

function TForm1.getname: string;
var
  i: integer;
begin
  if ListBox1.ItemIndex = -1 then
  begin
    result := '';
    Exit;
  end;
  if (ListBox1.Items.Count > 0) and (ListBox1.Items[0] = 'C:') then
    result := ListBox1.Items[0]
  else
    result := Caption + '\' + ListBox1.Items[0];
  for i := 1 to ListBox1.ItemIndex do
    if Copy(ListBox1.Items[i], 1, 2) = '--' then
    begin
      if i < ListBox1.ItemIndex then
        result := result + '\' + ListBox1.Items[ListBox1.ItemIndex];
      break;
    end
    else
      result := result + '\' + ListBox1.Items[i];
end;

procedure TForm1.ListBox1Change(Sender: TObject);
begin
  if Copy(ListBox1.Items[ListBox1.ItemIndex], 1, 2) = '--' then
    ListView1.Items.Clear
  else
    getfiles(getname);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  s: string;
begin
  if ListBox1.Items[0] <> 'C:' then
  begin
    s := getname;
    if (s <> '')and( ComboBox1.Items.IndexOf(s) = -1) then
      ComboBox1.Items.Add(s);
    getdir(s);
    getfiles(s);
  end;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
var
  s: string;
begin
  s := getname + '\' + ListView1.Items[ListView1.ItemIndex].Text;
  if DirectoryExists(s) = true then
  begin
    getdir(s);
    getfiles(s);
    ListBox1.ItemIndex := ListBox1.Items.Count - 1;
  end;
end;

end.

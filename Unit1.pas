unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.Layouts, FMX.ListBox, FMX.ListView;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { private êÈåæ }
    current: string;
    procedure getfiles(const dir: string);
    procedure getdir;
    function getname: string;
  public
    { public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  current := GetCurrentDir;
  getdir;
  getfiles(current);
end;

procedure TForm1.getdir;
var
  s, t: string;
  i, j: Integer;
  rec: TSearchRec;
begin
  ListBox1.Items.Clear;
  if current = 'C:\' then
    s := current
  else
    s := current + '\';
  for i := 1 to 5 do
  begin
    s := ExtractFileDir(s);
    t := ExtractFileName(s);
    if (s = '') or (t = '') then
    begin
      ListBox1.Items.Insert(0, 'C:\');
      Caption := '';
      Exit;
    end;
    ListBox1.Items.Insert(0, t);
    if i = 1 then
      ListBox1.Items.Insert(0, '------');
  end;
  Caption := ExtractFileDir(s);
end;

procedure TForm1.getfiles(const dir: string);
var
  rec: TSearchRec;
  i, j: Integer;
begin
  ListView1.Items.Clear;
  i := FindFirst(dir + '\*', faAnyFile, rec);
  j := 0;
  while i = 0 do
  begin
    if rec.Name[1] <> '.' then
    begin
      if rec.Attr = faDirectory then
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
  i: Integer;
begin
  if ListBox1.Items[0] = 'C:\' then
    result := 'C:'
  else
    result := Caption + '\' + ListBox1.Items[0];
  for i := 1 to ListBox1.ItemIndex do
  begin
    if Copy(ListBox1.Items[i], 1, 2) = '--' then
    begin
      if i < ListBox1.ItemIndex then
        result := result + '\' + ListBox1.Items[ListBox1.ItemIndex];
      break;
    end;
    result := result + '\' + ListBox1.Items[i];
  end;
end;

procedure TForm1.ListBox1Change(Sender: TObject);
begin
  if Copy(ListBox1.Items[ListBox1.ItemIndex],1,2) = '--' then
    ListView1.Items.Clear
  else
    getfiles(getname);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.Items[0] <> 'C:\' then
  begin
    current := getname;
    getdir;
    getfiles(current);
  end;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
var
  s: string;
begin
  s := getname + '\' + ListView1.Items[ListView1.ItemIndex].Text;
  if DirectoryExists(s) = true then
  begin
    current := s;
    getdir;
    getfiles(s);
    ListBox1.ItemIndex := ListBox1.Items.Count - 1;
  end;
end;

end.

unit frmMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, Buttons, ExtCtrls, ImgList,
  StdCtrls, XaudioPlayer, ExplBtn, MPGTools,
  mmSystem, Spin;

type
  TMainForm = class(TForm)
    pnlToolbar: TPanel;
    btnOpen: TSpeedButton;
    btnSave: TSpeedButton;
    btnNew: TSpeedButton;
    btnEndMark: TSpeedButton;
    btnAbout: TSpeedButton;
    pnlFiles: TPanel;
    btnAddSong: TSpeedButton;
    btnRemoveSong: TSpeedButton;
    btnMoveUp: TSpeedButton;
    btnMoveDown: TSpeedButton;
    btnRefreshList: TSpeedButton;
    btnAutoMode: TSpeedButton;
    btnSaver: TSpeedButton;
    pnlList: TPanel;
    ListView: TListView;
    imlList: TImageList;
    pnlSong: TPanel;
    pnlVolText: TPanel;
    pnlSongNumber: TPanel;
    AddSong: TOpenDialog;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    XP1: TXaudioPlayer;
    XP2: TXaudioPlayer;
    epEQ: TExplorerPopup;
    tbEQ1: TTrackBar;
    tbEQ2: TTrackBar;
    tbEQ3: TTrackBar;
    tbEQ4: TTrackBar;
    tbEQ5: TTrackBar;
    tbEQ6: TTrackBar;
    tbEQ7: TTrackBar;
    tbEQ8: TTrackBar;
    chbEqualizerActive: TCheckBox;
    btnReset: TButton;
    SystemTimer: TTimer;
    Bevel1: TBevel;
    StatusBar: TStatusBar;
    pnlPlayer: TPanel;
    btnPlay: TSpeedButton;
    btnPause: TSpeedButton;
    btnStop: TSpeedButton;
    Bevel2: TBevel;
    epSetup: TExplorerPopup;
    rgDrawMode: TRadioGroup;
    ebEQ: TSpeedButton;
    ebSetup: TSpeedButton;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    btnGoNearEnd: TSpeedButton;
    rgDisplay: TRadioGroup;
    btnRandomize: TSpeedButton;
    pnlSort: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    btnMove: TSpeedButton;
    dp1: TProgressBar;
    dp2: TProgressBar;
    dpSort: TProgressBar;
    procedure UpdateEqualizer;
    procedure SaveSettings();
    procedure LoadSettings();

    procedure FormCreate(Sender: TObject);
    procedure btnAddSongClick(Sender: TObject);
    procedure btnRefreshListClick(Sender: TObject);
    procedure btnRemoveSongClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnEndMarkClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnAutoModeClick(Sender: TObject);
    procedure SystemTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure XP1NotifyInputPosition(Sender: TXaudioPlayer; Offset,
      Range: Cardinal);
    procedure XP1NotifyInputTimecode(Sender: TXaudioPlayer; Hours, Minutes,
      Seconds, Fractions: Byte);
    procedure ebSetupClick(Sender: TObject);
    procedure ebEQClick(Sender: TObject);
    procedure ListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure XP1NotifyInputDuration(Sender: TXaudioPlayer;
      Duration: Cardinal);
    procedure XP2NotifyInputDuration(Sender: TXaudioPlayer;
      Duration: Cardinal);
    procedure XP2NotifyInputTimecode(Sender: TXaudioPlayer; Hours, Minutes,
      Seconds, Fractions: Byte);
    procedure XP2NotifyInputPosition(Sender: TXaudioPlayer; Offset,
      Range: Cardinal);
    procedure XP1NotifyPlayerState(Sender: TXaudioPlayer; State: Integer);
    procedure XP2NotifyPlayerState(Sender: TXaudioPlayer; State: Integer);
    procedure FormResize(Sender: TObject);
    procedure btnGoNearEndClick(Sender: TObject);
    procedure rgDisplayClick(Sender: TObject);
    procedure btnRandomizeClick(Sender: TObject);
    procedure btnSaverClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
  private
    XP1_State, XP2_State: Integer;
    XP1_Length_Hours, XP1_Length_Minutes, XP1_Length_Seconds, XP2_Length_Hours, XP2_Length_Minutes, XP2_Length_Seconds: Integer;
  public

  end;

var
  MainForm: TMainForm;
  ThePlayer: TXaudioPlayer;
  ProgramStart, CurrentSong, TickCount: Integer;
  AutoModeIsOn, ScreenSaverIsOn, IsProject: Boolean;
  MidnightTextBefore, MidnightTextAfter: String;

implementation

{$R *.DFM}

uses pasProcs, frmInfo, frmEndMarker, frmScreenS, frmAutoModeSettings,
  frmMove;

procedure TMainForm.FormCreate(Sender: TObject);
begin
        XP1.OutputModuleRegister('dsound_output_module_register@xa_dsound_output.dll');
        XP1.SetPlayerEnvironmentInteger('OUTPUT.DIRECTSOUND.WINDOW', MainForm.Handle);
        XP1.SetOutputName('/dev/dsound/0');
        XP2.OutputModuleRegister('dsound_output_module_register@xa_dsound_output.dll');
        XP2.SetPlayerEnvironmentInteger('OUTPUT.DIRECTSOUND.WINDOW', MainForm.Handle);
        XP2.SetOutputName('/dev/dsound/0');

        Files:=TStringList.Create;
        Comments:=TStringList.Create;
        GlobalEndMarker:=9;
        ThePlayer:=XP1;
        AutoModeIsOn:=False;
end;

procedure TMainForm.btnAddSongClick(Sender: TObject);
var
        a: Integer;
begin
        if AddSong.Execute then
        begin
                MainForm.ListView.Items.BeginUpdate;
                for a:=0 to AddSong.Files.Count-1 do
                begin
                        Files.Add(AddSong.Files.Strings[a]);
                end;
                RefreshFileList;
                MainForm.ListView.Items.EndUpdate;
        end;
end;

procedure TMainForm.btnRefreshListClick(Sender: TObject);
begin
        RefreshFileList;
end;

procedure TMainForm.btnRemoveSongClick(Sender: TObject);
var
        del: Integer;
begin
        if ListView.Selected=nil then exit;
        del:=Files.IndexOf(ListView.Selected.SubItems.Strings[2]);
        Files.Delete(del);
        RefreshFileList;
end;

procedure TMainForm.btnMoveUpClick(Sender: TObject);
var
        tmpF, tmpM, tmpS, tmpT: String;
        a: Integer;
begin
        if ListView.Selected=nil then exit;
        a:=ListView.Selected.Index;
        if a=0 then exit;
        tmpF:=ListView.Items[a].SubItems[0];
        tmpM:=ListView.Items[a].SubItems[1];
        tmpS:=ListView.Items[a].SubItems[2];
        tmpT:=ListView.Items[a].SubItems[3];
        ListView.Items[a].SubItems[0]:=ListView.Items[a-1].SubItems[0];
        ListView.Items[a].SubItems[1]:=ListView.Items[a-1].SubItems[1];
        ListView.Items[a].SubItems[2]:=ListView.Items[a-1].SubItems[2];
        ListView.Items[a].SubItems[3]:=ListView.Items[a-1].SubItems[3];
        ListView.Items[a-1].SubItems[0]:=tmpF;
        ListView.Items[a-1].SubItems[1]:=tmpM;
        ListView.Items[a-1].SubItems[2]:=tmpS;
        ListView.Items[a-1].SubItems[3]:=tmpT;
        UpdateListNumbers;
        Files.Exchange(a,a-1);
        ListView.Items[a-1].Selected:=True;
end;

procedure TMainForm.btnMoveDownClick(Sender: TObject);
var
        tmpF, tmpM, tmpS, tmpT: String;
        a: Integer;
begin
        if ListView.Selected=nil then exit;
        a:=ListView.Selected.Index;
        if a=ListView.Items.Count-1 then exit;
        tmpF:=ListView.Items[a].SubItems[0];
        tmpM:=ListView.Items[a].SubItems[1];
        tmpS:=ListView.Items[a].SubItems[2];
        tmpT:=ListView.Items[a].SubItems[3];
        ListView.Items[a].SubItems[0]:=ListView.Items[a+1].SubItems[0];
        ListView.Items[a].SubItems[1]:=ListView.Items[a+1].SubItems[1];
        ListView.Items[a].SubItems[2]:=ListView.Items[a+1].SubItems[2];
        ListView.Items[a].SubItems[3]:=ListView.Items[a+1].SubItems[3];
        ListView.Items[a+1].SubItems[0]:=tmpF;
        ListView.Items[a+1].SubItems[1]:=tmpM;
        ListView.Items[a+1].SubItems[2]:=tmpS;
        ListView.Items[a+1].SubItems[3]:=tmpT;
        UpdateListNumbers;
        Files.Exchange(a,a+1);
        ListView.Items[a+1].Selected:=True;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
var
        TempList, SaveFile: TStringList;
        mcount, a: Integer;
begin
        if ListView.Items.Count=0 then
        begin
                Application.MessageBox('Lista jest pusta! Nie zapisano ¿adnych plików...','Ostrze¿enie!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                exit;
        end;
        if ListView.Items.Count>1000 then
        begin
                Application.MessageBox('Ta wersja programu nie obs³uguje projektów wiêkszych ni¿ 1000 utworów! Zapisz projekt jako listê...','Ostrze¿enie!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                exit;
        end;
        Screen.Cursor:=crHourglass;
        if SaveDialog.Execute then
        begin
                if ExtractFileExt(SaveDialog.FileName)='.sml' then
                begin
                        SaveFile:=TStringList.Create;
                        SaveFile.Clear;
                        for a:=0 to ListView.Items.Count-1 do SaveFile.Add(ListView.Items[a].SubItems[2]);
                        SaveFile.SaveToFile(SaveDialog.FileName);
                        SaveFile.Free;
                        StatusBar.Panels[0].Text:='Lista utworów zosta³a zapisana do pliku.';
                        TickCount:=0;
                end;
                if ExtractFileExt(SaveDialog.FileName)='.smp' then
                begin
                        IsProject:=True;
                        TempList:=TStringList.Create;
                        TempList.Clear;
                        mcount:=ListView.Items.Count;
                        for a:=0 to mcount-1 do
                        begin
                                TempList.Values['Item'+IntToStr(a)+'FileName']:=Files.Strings[a];
                                TempList.Values['Item'+IntToStr(a)+'Comment']:=Comments.Strings[a];
                                TempList.Values['Item'+IntToStr(a)+'EndMarker']:=ListView.Items[a].SubItems[1];
                        end;
                        TempList.Values['ItemCount']:=IntToStr(mcount);
                        TempList.SaveToFile(SaveDialog.FileName);
                        TempList.Free;
                        StatusBar.Panels[0].Text:='Projekt zosta³ zapisany do pliku.';
                        TickCount:=0;
                end;
        end;
        Application.Title:=ExtractFileName(SaveDialog.FileName)+' - DJ''s Small Machine ME';
        MainForm.Caption:='DJ''s Small Machine ME - '+SaveDialog.FileName;
        Screen.Cursor:=crDefault;
end;

procedure TMainForm.btnNewClick(Sender: TObject);
begin
        if Application.MessageBox('Czy napewno utworzyæ now¹, pust¹ listê? Wszystkie niezapisane zmiany zostan¹ bezpowrotnie utracone!','Question',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=ID_YES then
        begin
                Files.Clear;
                RefreshFileList;
                Application.Title:='DJ''s Small Machine ME';
                MainForm.Caption:='DJ''s Small Machine ME';
                StatusBar.Panels[0].Text:='Utworzono now¹ listê.';
                TickCount:=0;
        end;
end;

procedure TMainForm.btnOpenClick(Sender: TObject);
var
        adder, nam: String;
        a, mcount, lcount: Integer;
        TempList: TStringList;
begin
        Screen.Cursor:=crHourglass;
        if not OpenDialog.Execute then
        begin
                Screen.Cursor:=crDefault;
                exit;
        end;
        nam:=OpenDialog.FileName;
        if ExtractFileExt(nam)='.sml' then
        begin
                IsProject:=False;
                Files.Clear;
                Files.LoadFromFile(nam);
                mcount:=Files.Count;
                if mcount=0 then
                begin
                        Screen.Cursor:=crDefault;
                        Application.MessageBox('Otwierana lista jest pusta! Nie dodano ¿adnych utworów...','Ostrze¿enie!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                        exit;
                end;
                RefreshFileList;
                lcount:=ListView.Items.Count;
                for a:=0 to lcount do Comments.Add('');
                if mcount<>lcount then adder:=', nie odnaleziono plików: '+IntToStr(mcount-lcount) else adder:='';
                StatusBar.Panels[0].Text:='Liczba utworów dodanych do listy: '+IntToStr(lcount)+' z '+IntToStr(mcount)+adder+'.';
                TickCount:=0;
        end;
        if ExtractFileExt(nam)='.smp' then
        begin
                IsProject:=True;
                TempList:=TStringList.Create;
                TempList.Clear;
                Files.Clear;
                Comments.Clear;
                TempList.LoadFromFile(nam);
                mcount:=StrToIntDef(TempList.Values['ItemCount'],0);
                if mcount=0 then
                begin
                        TempList.Free;
                        Application.MessageBox('Otwierany projekt jest pusty! Nie dodano ¿adnych utworów...','Ostrze¿enie!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                        Screen.Cursor:=crDefault;
                        exit;
                end;
                if mcount>1000 then
                begin
                        TempList.Free;
                        Application.MessageBox('Ta wersja programu nie obs³uguje projektów wiêkszych ni¿ 1000 utworów...','Ostrze¿enie!',MB_OK+MB_ICONWARNING+MB_DEFBUTTON1);
                        Screen.Cursor:=crDefault;
                        exit;
                end;
                for a:=0 to mcount do
                begin
                        Files.Add(TempList.Values['Item'+IntToStr(a)+'FileName']);
                        Comments.Add(TempList.Values['Item'+IntToStr(a)+'Comment']);
                        Times[a]:=StrToIntDef(TempList.Values['Item'+IntToStr(a)+'EndMarker'],GlobalEndMarker);
                end;
                RefreshFileList;
                lcount:=ListView.Items.Count;
                if mcount<>lcount then adder:=', nie odnaleziono plików: '+IntToStr(mcount-lcount) else adder:='';
                StatusBar.Panels[0].Text:='Liczba utworów dodanych do listy: '+IntToStr(lcount)+' z '+IntToStr(mcount)+adder+'.';
                TickCount:=0;
                TempList.Free;
        end;
        Application.Title:=ExtractFileName(nam)+' - DJ''s Small Machine ME';
        MainForm.Caption:='DJ''s Small Machine ME - '+nam;
        Screen.Cursor:=crDefault;
end;

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
        InfoForm.ShowModal
end;

procedure TMainForm.btnEndMarkClick(Sender: TObject);
var
        a: Integer;
begin
        if ListView.Items.Count=0 then
        begin
                Application.MessageBox('Nie mo¿na ustawiæ / modyfikowaæ przystanku czasowego, jeœli lista utworów jest pusta.','Information',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON2);
                exit;
        end;
        if ListView.Selected=nil then
        begin
                MarkerForm.rbSelected.Enabled:=False;
                MarkerForm.rbAll.Checked:=True;
                MarkerForm.eValue.Value:=GlobalEndMarker;
        end
        else
        begin
                MarkerForm.rbSelected.Enabled:=True;
                MarkerForm.rbSelected.Checked:=True;
                MarkerForm.eValue.Value:=StrToInt(ListView.Selected.SubItems[1]);
        end;
        MarkerForm.ShowModal;
        if MarkerForm.pnlOK.Caption='Cancel' then exit;
        if MarkerForm.rbAll.Checked=True then
        begin
                GlobalEndMarker:=MarkerForm.eValue.Value;
                for a:=0 to ListView.Items.Count-1 do Times[a]:=GlobalEndMarker;
                RefreshFileList;
        end
        else ListView.Selected.SubItems[1]:=IntToStr(MarkerForm.eValue.Value);

        StatusBar.Panels[0].Text:='Przystanek czasowy zosta³ zmodyfikowany.';
        TickCount:=0;
end;

procedure TMainForm.UpdateEqualizer;
var
  EQ: XA_EqualizerInfo;
begin
  if chbEqualizerActive.Checked then
    begin
      EQ.Left[ 0] := -tbEQ1.Position;
      EQ.Left[ 1] := -tbEQ2.Position;
      EQ.Left[ 2] := -tbEQ3.Position;
      EQ.Left[ 3] := -tbEQ3.Position;
      EQ.Left[ 4] := -tbEQ4.Position;
      EQ.Left[ 5] := -tbEQ4.Position;
      EQ.Left[ 6] := -tbEQ5.Position;
      EQ.Left[ 7] := -tbEQ5.Position;
      EQ.Left[ 8] := -tbEQ6.Position;
      EQ.Left[ 9] := -tbEQ6.Position;
      EQ.Left[10] := -tbEQ6.Position;
      EQ.Left[11] := -tbEQ6.Position;
      EQ.Left[12] := -tbEQ6.Position;
      EQ.Left[13] := -tbEQ6.Position;
      EQ.Left[14] := -tbEQ7.Position;
      EQ.Left[15] := -tbEQ7.Position;
      EQ.Left[16] := -tbEQ7.Position;
      EQ.Left[17] := -tbEQ7.Position;
      EQ.Left[18] := -tbEQ7.Position;
      EQ.Left[19] := -tbEQ7.Position;
      EQ.Left[20] := -tbEQ8.Position;
      EQ.Left[21] := -tbEQ8.Position;
      EQ.Left[22] := -tbEQ8.Position;
      EQ.Left[23] := -tbEQ8.Position;
      EQ.Left[24] := -tbEQ8.Position;
      EQ.Left[25] := -tbEQ8.Position;
      EQ.Left[26] := -tbEQ8.Position;
      EQ.Left[27] := -tbEQ8.Position;
      EQ.Left[28] := -tbEQ8.Position;
      EQ.Left[29] := -tbEQ8.Position;
      EQ.Left[30] := -tbEQ8.Position;
      EQ.Left[31] := -tbEQ8.Position;
      EQ.Right[ 0] := EQ.Left[ 0];
      EQ.Right[ 1] := EQ.Left[ 1];
      EQ.Right[ 2] := EQ.Left[ 2];
      EQ.Right[ 3] := EQ.Left[ 3];
      EQ.Right[ 4] := EQ.Left[ 4];
      EQ.Right[ 5] := EQ.Left[ 5];
      EQ.Right[ 6] := EQ.Left[ 6];
      EQ.Right[ 7] := EQ.Left[ 7];
      EQ.Right[ 8] := EQ.Left[ 8];
      EQ.Right[ 9] := EQ.Left[ 9];
      EQ.Right[10] := EQ.Left[10];
      EQ.Right[11] := EQ.Left[11];
      EQ.Right[12] := EQ.Left[12];
      EQ.Right[13] := EQ.Left[13];
      EQ.Right[14] := EQ.Left[14];
      EQ.Right[15] := EQ.Left[15];
      EQ.Right[16] := EQ.Left[16];
      EQ.Right[17] := EQ.Left[17];
      EQ.Right[18] := EQ.Left[18];
      EQ.Right[19] := EQ.Left[19];
      EQ.Right[20] := EQ.Left[20];
      EQ.Right[21] := EQ.Left[21];
      EQ.Right[22] := EQ.Left[22];
      EQ.Right[23] := EQ.Left[23];
      EQ.Right[24] := EQ.Left[24];
      EQ.Right[25] := EQ.Left[25];
      EQ.Right[26] := EQ.Left[26];
      EQ.Right[27] := EQ.Left[27];
      EQ.Right[28] := EQ.Left[28];
      EQ.Right[29] := EQ.Left[29];
      EQ.Right[30] := EQ.Left[30];
      EQ.Right[31] := EQ.Left[31];
      XP1.SetCodecEqualizer(@EQ);
      XP1.GetCodecEqualizer;
      XP2.SetCodecEqualizer(@EQ);
      XP2.GetCodecEqualizer;
    end
  else
  begin
        XP1.SetCodecEqualizer(nil);
        XP2.SetCodecEqualizer(nil);
  end;
end;

procedure TMainForm.TrackBarChange(Sender: TObject);
begin
        UpdateEqualizer;
end;

procedure TMainForm.btnResetClick(Sender: TObject);
begin
        tbEQ1.Position:=0;
        tbEQ2.Position:=0;
        tbEQ3.Position:=0;
        tbEQ4.Position:=0;
        tbEQ5.Position:=0;
        tbEQ6.Position:=0;
        tbEQ7.Position:=0;
        tbEQ8.Position:=0;
end;

procedure TMainForm.btnAutoModeClick(Sender: TObject);
var
        iMFResult, pos, tPos, tMax: Integer;
begin
        if ListView.Items.Count<2 then
        begin
                Application.MessageBox('Nie mo¿na przejœæ do trybu Auto, jeœli lista zawiera mniej ni¿ dwie pozycje.','Information',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON2);
                btnAutoMode.Down:=False;
                exit;
        end;
        
        if btnAutoMode.Down then
        begin
                pos:=ListView.Items.IndexOf(ListView.Selected);
                if pos=-1 then tPos:=1 else tPos:=pos+1;
                tMax:=ListView.Items.Count-1;

                AutoModeSettingsForm.rvspStartPosition.Value:=tPos;
                AutoModeSettingsForm.rvspStartPosition.MaxValue:=tMax;
                AutoModeSettingsForm.btnRandomSong.Tag:=tMax;
                AutoModeSettingsForm.btnActualSong.Tag:=tPos;

                iMFResult:=AutoModeSettingsForm.ShowModal;
                if iMFResult=mrCancel then
                begin
                        btnAutoMode.Down:=False;
                        AutoModeIsOn:=False;
                        exit;
                end;

                AutoModeIsOn:=True;
                btnStopClick(self);
                btnSaver.Enabled:=True;
                btnPlay.Enabled:=False;
                btnPause.Enabled:=False;
                btnStop.Enabled:=False;
                btnNew.Enabled:=False;
                btnOpen.Enabled:=False;
                btnSave.Enabled:=False;
                btnAddSong.Enabled:=False;
                btnRemoveSong.Enabled:=False;
                btnMoveUp.Enabled:=False;
                btnMoveDown.Enabled:=False;
                btnRefreshList.Enabled:=False;
                btnRandomize.Enabled:=False;
                //ListView.Enabled:=False;

                btnAutoMode.Hint:='Wy³¹cz tryb Auto';
                StatusBar.Panels[0].Text:='Tryb automatyczny w³¹czony.';
                StatusBar.Panels[1].Text:='Auto';
                TickCount:=0;

                //Uruchomienie trybu Auto
                CurrentSong:=Trunc(AutoModeSettingsForm.rvspStartPosition.Value)-1;
                ThePlayer:=XP1;
                SwitchLabels;
                PlaySong(CurrentSong,XP1,XP2,False);

                if AutoModeSettingsForm.chbRunSSAlso.Checked then btnSaverClick(self); 
        end
        else
        begin
                if Application.MessageBox('Wszystkie aktualnie odtwarzane utwory zostan¹ zatrzymane.'+chr(13)+'Czy napewno opuœciæ tryb Auto?','Pytanie...',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=ID_NO then
                begin
                        btnAutoMode.Down:=True;
                        AutoModeIsOn:=True;
                        exit;
                end;
                AutoModeIsOn:=False;
                btnSaver.Enabled:=False;
                btnPlay.Enabled:=True;
                btnPause.Enabled:=True;
                btnStop.Enabled:=True;
                btnNew.Enabled:=True;
                btnOpen.Enabled:=True;
                btnSave.Enabled:=True;
                btnAddSong.Enabled:=True;
                btnRemoveSong.Enabled:=True;
                btnMoveUp.Enabled:=True;
                btnMoveDown.Enabled:=True;
                btnRandomize.Enabled:=True;
                btnRefreshList.Enabled:=True;
                //ListView.Enabled:=True;

                XP1.Stop;
                XP1.InputClose;
                XP2.Stop;
                XP2.InputClose;

                btnAutoMode.Hint:='W³¹cz tryb Auto';
                StatusBar.Panels[0].Text:='Tryb automatyczny wy³¹czony.';
                StatusBar.Panels[1].Text:='Rêczny';
                TickCount:=0;
        end;
end;

procedure TMainForm.SystemTimerTimer(Sender: TObject);
var
        sMid, sNow: Integer;
        Hour, Min, Sec, MSec, Year, Month, Day: Word;
        cu, mu: TClockUnit;
begin
        //Ukrywanie komunikatu
        Inc(TickCount);
        if TickCount=5 then
        begin
                TickCount:=0;
                StatusBar.Panels[0].Text:='';
        end;

        //WskaŸnik pozycji
        if AutoModeIsOn then ListView.Selected:=ListView.Items[CurrentSong];

        //Zegar
        Inc(ProgramStart);

        if AutoModeSettingsForm.rgMidnightClockMode.ItemIndex=0 then
        begin
                MidnightTextBefore:='Do pó³nocy pozosta³o';
                MidnightTextAfter:='Od pó³nocy minê³o';
        end
        else
        begin
                DecodeDate(Now, Year, Month, Day);
                MidnightTextBefore:='Do koñca '+IntToStr(Year)+' roku pozosta³o';
                MidnightTextAfter:='Mamy '+IntToStr(Year)+' rok od';
        end;

        DecodeTime(Now, Hour, Min, Sec, MSec);
        sNow:=ClockUnitsToSeconds(Hour,Min,Sec);
        if Hour>=12 then
        begin
                sMid:=ClockUnitsToSeconds(23,59,59);
                mu:=SecondsToClockUnits(sNow-sMid);
                ScreenForm.lblMidnightCount.Caption:=Format('%.2d:%.2d:%.2d', [Abs(mu.Hours), Abs(mu.Minutes), Abs(mu.Seconds)]);
                ScreenForm.lblMidnightTitle.Caption:=MidnightTextBefore;
        end
        else
        begin
                sMid:=ClockUnitsToSeconds(00,00,00);
                mu:=SecondsToClockUnits(sNow-sMid);
                ScreenForm.lblMidnightCount.Caption:=Format('%.2d:%.2d:%.2d', [Abs(mu.Hours), Abs(mu.Minutes), Abs(mu.Seconds)]);
                ScreenForm.lblMidnightTitle.Caption:=MidnightTextAfter;
        end;

        cu:=SecondsToClockUnits(ProgramStart);
        ScreenForm.lblPartyCount.Caption:=Format('%.2d:%.2d:%.2d', [cu.Hours, cu.Minutes, cu.Seconds]);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
        LoadSettings();

        StatusBar.Panels[0].Text:='Witaj w programie!';
        StatusBar.Panels[1].Text:='Rêczny';
        StatusBar.Panels[2].Text:='Utworów: 0';
        StatusBar.Panels[3].Text:='Czas trwania: 00:00:00';

        TickCount:=0;
        ProgramStart:=0;
end;

procedure TMainForm.btnPlayClick(Sender: TObject);
begin
        if ListView.Selected=nil then
        begin
                Application.MessageBox('Najpierw wybierz na liœcie plik, który chcesz odtwarzaæ.','Informacja...',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON2);
                exit;
        end;

        PlaySong(ListView.Selected.Index,XP1,XP2,False);
end;

procedure TMainForm.btnPauseClick(Sender: TObject);
begin
        if XP1_State=XA_PLAYER_STATE_PLAYING then XP1.Pause;
        if XP1_State=XA_PLAYER_STATE_PAUSED then XP1.Play;
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
        ThePlayer.Stop;
        ThePlayer.InputClose;
        btnPause.Down:=False;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        XP1.Stop;
        XP1.InputClose;
        XP2.Stop;
        XP2.InputClose;
        SaveSettings();
end;

procedure TMainForm.XP1NotifyInputPosition(Sender: TXaudioPlayer; Offset,
  Range: Cardinal);
begin
        dp1.Position := Offset;
        dp1.Max := Range;
end;

procedure TMainForm.XP1NotifyInputTimecode(Sender: TXaudioPlayer; Hours, Minutes, Seconds, Fractions: Byte);
var
        sLength, sNow, dl: Integer;
        cu: TClockUnit;
begin
        if ThePlayer=XP1 then
        begin
                sLength:=ClockUnitsToSeconds(XP1_Length_Hours,XP1_Length_Minutes,XP1_Length_Seconds);
                sNow:=ClockUnitsToSeconds(Hours,Minutes,Seconds);
                                
                if CurrentSong=0 then dl:=StrToIntDef(MainForm.ListView.Items[CurrentSong].SubItems[1],GlobalEndMarker) else dl:=StrToIntDef(MainForm.ListView.Items[CurrentSong-1].SubItems[1],GlobalEndMarker);
                //if (sLength-sNow)=dl+7 then FadeLabel([ScreenForm.lbl2,ScreenForm.lbl4],True);
                if (sLength-sNow)=dl then PlaySong(CurrentSong+1,XP2,XP1,True);
        end;
end;

procedure TMainForm.ebSetupClick(Sender: TObject);
begin
        epSetup.Open(ebSetup);
end;

procedure TMainForm.ebEQClick(Sender: TObject);
begin
        epEQ.Open(ebEQ);
end;

procedure TMainForm.ListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if AutoModeIsOn then exit;
        if Key=VK_INSERT then btnAddSongClick(self);
        if Key=VK_DELETE then btnRemoveSongClick(self);
        if Key=VK_F5 then btnRefreshListClick(self);
        if Key=VK_F12 then btnRandomizeClick(self);
end;

procedure TMainForm.XP1NotifyInputDuration(Sender: TXaudioPlayer;
  Duration: Cardinal);
begin
        XP1_Length_Hours:=Duration div 3600;
        Duration:=Duration-3600*XP1_Length_Hours;
        XP1_Length_Minutes:=Duration div 60;
        Duration:=Duration-60*XP1_Length_Minutes;
        XP1_Length_Seconds:=Duration;
end;

procedure TMainForm.XP2NotifyInputDuration(Sender: TXaudioPlayer;
  Duration: Cardinal);
begin
        XP2_Length_Hours:=Duration div 3600;
        Duration:=Duration-3600*XP2_Length_Hours;
        XP2_Length_Minutes:=Duration div 60;
        Duration:=Duration-60*XP2_Length_Minutes;
        XP2_Length_Seconds:=Duration;
end;

procedure TMainForm.XP2NotifyInputTimecode(Sender: TXaudioPlayer; Hours, Minutes, Seconds, Fractions: Byte);
var
        sLength, sNow, dl: Integer;
        cu: TClockUnit;
begin
        if ThePlayer=XP2 then
        begin
                sLength:=ClockUnitsToSeconds(XP2_Length_Hours,XP2_Length_Minutes,XP2_Length_Seconds);
                sNow:=ClockUnitsToSeconds(Hours,Minutes,Seconds);

                if CurrentSong=0 then dl:=StrToIntDef(MainForm.ListView.Items[CurrentSong].SubItems[1],GlobalEndMarker) else dl:=StrToIntDef(MainForm.ListView.Items[CurrentSong-1].SubItems[1],GlobalEndMarker);
                //if (sLength-sNow)=dl+7 then FadeLabel([ScreenForm.lbl2,ScreenForm.lbl4],True);
                if (sLength-sNow)=dl then PlaySong(CurrentSong+1,XP1,XP2,True);
        end;
end;

procedure TMainForm.XP2NotifyInputPosition(Sender: TXaudioPlayer; Offset,
  Range: Cardinal);
begin
        dp2.Position := Offset;
        dp2.Max := Range;
end;

procedure TMainForm.XP1NotifyPlayerState(Sender: TXaudioPlayer;
  State: Integer);
begin
        XP1_State:=State;
        if XP1_State=XA_PLAYER_STATE_EOF then dp1.Position := 0;
        if XP1_State=XA_PLAYER_STATE_STOPPED then
        begin
                dp1.Position := 0;

                if XP1_State=XA_PLAYER_STATE_STOPPED then MainForm.pnlVolText.Caption:='Cisza...';
        end;
        if XP1_State=XA_PLAYER_STATE_PLAYING then
        begin
                MainForm.pnlVolText.Caption:='Granie...';
                pnlSongNumber.Caption:=IntToStr(CurrentSong+1);
        end;
end;

procedure TMainForm.XP2NotifyPlayerState(Sender: TXaudioPlayer;
  State: Integer);
begin
        XP2_State:=State;
        if XP2_State=XA_PLAYER_STATE_EOF then dp2.Position := 0;
        if XP2_State=XA_PLAYER_STATE_STOPPED then
        begin
                dp2.Position := 0;
                if XP2_State=XA_PLAYER_STATE_STOPPED then MainForm.pnlVolText.Caption:='Cisza...';
        end;
        if XP2_State=XA_PLAYER_STATE_PLAYING then
        begin
                MainForm.pnlVolText.Caption:='Granie...';
                pnlSongNumber.Caption:=IntToStr(CurrentSong+1);
        end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
        dp1.Width := Panel1.Left - dp1.Left - 4;
        dp2.Width := Panel1.Left - dp2.Left - 4;
end;

procedure TMainForm.btnGoNearEndClick(Sender: TObject);
begin
        ThePlayer.InputSeek(360,400);
end;

procedure TMainForm.rgDisplayClick(Sender: TObject);
begin
        RefreshFileList;
end;

procedure TMainForm.btnRandomizeClick(Sender: TObject);
var
        num, a, r1, r2: Integer;
begin
        if ListView.Items.Count<2 then
        begin
                Application.MessageBox('Nie mo¿na przeprowadziæ sortowania losowego, jeœli lista zawiera mniej ni¿ dwie pozycje.','Information',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON2);
                exit;
        end;
        num:=StrToIntDef(MyInputDialog('Podaj iloœæ iteracji...','Im wiêcej iteracji, tym d³u¿szy proces sortowania, ale tak¿e wiêkszy rozrzut losowy utworów.','1000',False),0);
        if num=0 then exit;
        Screen.Cursor:=crHourglass;
        Randomize;
        pnlSort.Show;

        dpSort.Max := num;
        
        for a:=1 to num do
        begin
                r1:=Random(Files.Count);
                r2:=Random(Files.Count);
                Files.Exchange(r1,r2);
                dpSort.Position := a;
                Application.ProcessMessages;
        end;
        pnlSort.Hide;
        RefreshFileList;
        Screen.Cursor:=crDefault;
end;

{procedure TMainForm.ExchangeItems(Item1, Item2: Integer);
var
        tmpF, tmpM, tmpS, tmpT: String;
        a: Integer;
begin
        tmpF:=ListView.Items[a].SubItems[0];
        tmpM:=ListView.Items[a].SubItems[1];
        tmpS:=ListView.Items[a].SubItems[2];
        ListView.Items[a].SubItems[0]:=ListView.Items[a-1].SubItems[0];
        ListView.Items[a].SubItems[1]:=ListView.Items[a-1].SubItems[1];
        ListView.Items[a].SubItems[2]:=ListView.Items[a-1].SubItems[2];
        ListView.Items[a-1].SubItems[0]:=tmpF;
        ListView.Items[a-1].SubItems[1]:=tmpM;
        ListView.Items[a-1].SubItems[2]:=tmpS;
        UpdateListNumbers;
        Files.Exchange(a,a-1);
        ListView.Items[a-1].Selected:=True;
end;}

procedure TMainForm.btnSaverClick(Sender: TObject);
begin
        Screen.Cursor:=crNone;
        ScreenSaverIsOn:=True;
        SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,0,nil,0);
        ScreenForm.Show;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
        Files.Free;
        Comments.Free;
end;

procedure TMainForm.SaveSettings();
var
        sFile: TStringList;
begin
        sFile:=TStringList.Create;

        sFile.Values['TimeShowing']:=IntToStr(rgDrawMode.ItemIndex);
        sFile.Values['TitleShowing']:=IntToStr(rgDisplay.ItemIndex);
        sFile.Values['PassThroughEffect']:=IntToStr(AutoModeSettingsForm.rgPassThrough.ItemIndex);
        sFile.Values['ClockMode']:=IntToStr(AutoModeSettingsForm.rgMidnightClockMode.ItemIndex);
        sFile.Values['ShowCurrentSong']:=IntToStr(Ord(AutoModeSettingsForm.chbShowCurrent.Checked));
        sFile.Values['ShowNextSong']:=IntToStr(Ord(AutoModeSettingsForm.chbShowNext.Checked));
        sFile.Values['ShowPartyClockSong']:=IntToStr(Ord(AutoModeSettingsForm.chbShowPartyClock.Checked));
        sFile.Values['ShowMidnightClockSong']:=IntToStr(Ord(AutoModeSettingsForm.chbShowMidnightClock.Checked));
        sFile.Values['AutostartScreenSaver']:=IntToStr(Ord(AutoModeSettingsForm.chbRunSSAlso.Checked));
        sFile.Values['EqualizerActive']:=IntToStr(Ord(chbEqualizerActive.Checked));
        sFile.Values['BackgroundColor']:=ColorToString(AutoModeSettingsForm.rccbBackground.ColorValue);
        sFile.Values['HeaderColor']:=ColorToString(AutoModeSettingsForm.rccbTitles.ColorValue);
        sFile.Values['TextColor']:=ColorToString(AutoModeSettingsForm.rccbTexts.ColorValue);
        sFile.Values['EQTrackBar1']:=IntToStr(tbEQ1.Position);
        sFile.Values['EQTrackBar2']:=IntToStr(tbEQ2.Position);
        sFile.Values['EQTrackBar3']:=IntToStr(tbEQ3.Position);
        sFile.Values['EQTrackBar4']:=IntToStr(tbEQ4.Position);
        sFile.Values['EQTrackBar5']:=IntToStr(tbEQ5.Position);
        sFile.Values['EQTrackBar6']:=IntToStr(tbEQ6.Position);
        sFile.Values['EQTrackBar7']:=IntToStr(tbEQ7.Position);
        sFile.Values['EQTrackBar8']:=IntToStr(tbEQ8.Position);

        sFile.SaveToFile(ExtractFilePath(Application.ExeName)+'settings.dat');
        sFile.Free;
end;

procedure TMainForm.LoadSettings();
var
        sFile: TStringList;
        sSettingsFile: String;
begin
        sSettingsFile:=ExtractFilePath(Application.ExeName)+'settings.dat';
        if FileExists(sSettingsFile) then
        begin
                sFile:=TStringList.Create;
                sFile.LoadFromFile(sSettingsFile);

                rgDrawMode.ItemIndex:=StrToIntDef(sFile.Values['TimeShowing'],0);
                rgDisplay.ItemIndex:=StrToIntDef(sFile.Values['TitleShowing'],0);
                AutoModeSettingsForm.rgPassThrough.ItemIndex:=StrToIntDef(sFile.Values['PassThroughEffect'],0);
                AutoModeSettingsForm.rgMidnightClockMode.ItemIndex:=StrToIntDef(sFile.Values['ClockMode'],0);
                chbEqualizerActive.Checked:=(StrToIntDef(sFile.Values['EqualizerActive'],0) = 1);
                AutoModeSettingsForm.chbShowCurrent.Checked:=(StrToIntDef(sFile.Values['ShowCurrentSong'],0) = 1);
                AutoModeSettingsForm.chbShowNext.Checked:=(StrToIntDef(sFile.Values['ShowNextSong'],0) = 1);
                AutoModeSettingsForm.chbShowPartyClock.Checked:=(StrToIntDef(sFile.Values['ShowPartyClockSong'],0) = 1);
                AutoModeSettingsForm.chbShowMidnightClock.Checked:=(StrToIntDef(sFile.Values['ShowMidnightClockSong'],0) = 1);
                AutoModeSettingsForm.chbRunSSAlso.Checked:=(StrToIntDef(sFile.Values['AutostartScreenSaver'],0) = 1);
                AutoModeSettingsForm.rccbBackground.ColorValue:=StringToColor(sFile.Values['BackgroundColor']);
                AutoModeSettingsForm.rccbTitles.ColorValue:=StringToColor(sFile.Values['HeaderColor']);
                AutoModeSettingsForm.rccbTexts.ColorValue:=StringToColor(sFile.Values['TextColor']);
                tbEQ1.Position:=StrToIntDef(sFile.Values['EQTrackBar1'],0);
                tbEQ2.Position:=StrToIntDef(sFile.Values['EQTrackBar2'],0);
                tbEQ3.Position:=StrToIntDef(sFile.Values['EQTrackBar3'],0);
                tbEQ4.Position:=StrToIntDef(sFile.Values['EQTrackBar4'],0);
                tbEQ5.Position:=StrToIntDef(sFile.Values['EQTrackBar5'],0);
                tbEQ6.Position:=StrToIntDef(sFile.Values['EQTrackBar6'],0);
                tbEQ7.Position:=StrToIntDef(sFile.Values['EQTrackBar7'],0);
                tbEQ8.Position:=StrToIntDef(sFile.Values['EQTrackBar8'],0);

                sFile.Free;
        end;
end;

procedure TMainForm.btnMoveClick(Sender: TObject);
{var
        tmpF, tmpM, tmpS, tmpT: String;
        a, newpos, pos, tPos, tMax, iMFResult: Integer;}
begin
        {if ListView.Selected=nil then exit;
        pos:=ListView.Selected.Index;
        if pos=ListView.Items.Count-1 then exit;

        if pos=-1 then tPos:=1 else tPos:=pos+1;
        tMax:=ListView.Items.Count-1;

        MoveForm.rvspPosition.MaxValue:=tMax;
        MoveForm.lblSongNum.Caption:=IntToStr(tPos);

        iMFResult:=MoveForm.ShowModal;
        if iMFResult=mrCancel then exit;
        if MoveForm.rvspPosition.Value=tPos then exit;

        newpos:=Trunc(MoveForm.rvspPosition.Value)-1;

        case MoveForm.gbMove.ItemIndex of
                0: btnMoveUpClick(self);
                1: btnMoveDownClick(self);
                3:
                begin
                        tmpF:=ListView.Items[pos].SubItems[0];
                        tmpM:=ListView.Items[pos].SubItems[1];
                        tmpS:=ListView.Items[pos].SubItems[2];
                        tmpT:=ListView.Items[pos].SubItems[3];
                        if newpos>pos then
                        begin
                                for a=pos to newpos-1 do
                                begin
                                        ListView.Items[a].SubItems[0]:=ListView.Items[a+1].SubItems[0];
                                        ListView.Items[a].SubItems[1]:=ListView.Items[a+1].SubItems[1];
                                        ListView.Items[a].SubItems[2]:=ListView.Items[a+1].SubItems[2];
                                        ListView.Items[a].SubItems[3]:=ListView.Items[a+1].SubItems[3];
                                end;
                        end
                        else
                        begin
                                for a=newpos+1 to pos do
                                begin
                                        ListView.Items[a].SubItems[0]:=ListView.Items[a+1].SubItems[0];
                                        ListView.Items[a].SubItems[1]:=ListView.Items[a+1].SubItems[1];
                                        ListView.Items[a].SubItems[2]:=ListView.Items[a+1].SubItems[2];
                                        ListView.Items[a].SubItems[3]:=ListView.Items[a+1].SubItems[3];
                                end;
                        end;
                        ListView.Items[newpos].SubItems[0]:=tmpF;
                        ListView.Items[newpos].SubItems[1]:=tmpM;
                        ListView.Items[newpos].SubItems[2]:=tmpS;
                        ListView.Items[newpos].SubItems[3]:=tmpT;
                        UpdateListNumbers;
                        Files.Exchange(pos,newpos);
                        ListView.Items[newpos].Selected:=True;
                end;
                2:
                begin
                        tmpF:=ListView.Items[newpos].SubItems[0];
                        tmpM:=ListView.Items[newpos].SubItems[1];
                        tmpS:=ListView.Items[newpos].SubItems[2];
                        tmpT:=ListView.Items[newpos].SubItems[3];
                        ListView.Items[newpos].SubItems[0]:=ListView.Items[pos].SubItems[0];
                        ListView.Items[newpos].SubItems[1]:=ListView.Items[pos].SubItems[1];
                        ListView.Items[newpos].SubItems[2]:=ListView.Items[pos].SubItems[2];
                        ListView.Items[newpos].SubItems[3]:=ListView.Items[pos].SubItems[3];
                        ListView.Items[pos].SubItems[0]:=tmpF;
                        ListView.Items[pos].SubItems[1]:=tmpM;
                        ListView.Items[pos].SubItems[2]:=tmpS;
                        ListView.Items[pos].SubItems[3]:=tmpT;
                        UpdateListNumbers;
                        Files.Exchange(pos,newpos);
                        ListView.Items[newpos].Selected:=True;
                end;
        end;}
end;

end.

unit pasProcs;

interface

uses
  Windows, SysUtils, Forms, Classes, Comctrls, XaudioPlayer,
  Dialogs, stdctrls, Graphics;

type
    TClockUnit = record
        Hours, Minutes, Seconds: Integer;
end;

   procedure RefreshFileList;
   procedure UpdateListNumbers;
   procedure PlaySong(SongNumber: Integer; OnThePlayer, OldPlayer: TXAudioPlayer; WithFadeIn: Boolean);
   procedure Delay(MSecs: Longint);
   procedure SwitchLabels();
   procedure CrossFadeVolume(FadeInPlayer, FadeOutPlayer: TXAudioPlayer; DelayValue: Integer);
   procedure FadeLabels(Labels: array of TLabel; Value: Integer);

   function ParseDate(Date: TDateTime): String;
   function ParseTime(input: String): String;
   function MyInputDialog(Caption, Text, Default: String; IsPassword: Boolean): String;
   function SecondsToClockUnits(Seconds: Integer): TClockUnit;
   function ClockUnitsToSeconds(Hours, Minutes, Seconds: Integer): Integer;
   function RemoveAmpersand(Text: String): String;

var
        Files, Comments: TStringList;
        Times: array [0..1000] of Integer;
        GlobalEndMarker: Integer;

implementation

uses frmMainForm, frmMyInputDialog, MPGTools, frmScreenS, frmAutoModeSettings;

function MyInputDialog(Caption, Text, Default: String; IsPassword: Boolean): String;
begin
        Result:='$#%CANCEL%#$';
        if IsPassword then InputDialogForm.eText.PasswordChar:='*' else InputDialogForm.eText.PasswordChar:=#0;
        InputDialogForm.Caption:=Caption;
        InputDialogForm.lText.Caption:=Text;
        InputDialogForm.eText.Text:=Default;
        if InputDialogForm.ShowModal=idCancel then exit;
        Result:=InputDialogForm.eText.Text;
end;

procedure RefreshFileList;
var
        lst: TListItem;
        a, b: Integer;
        mp3: TMPEGAudio;
        tSummary: TDateTime;
begin
        Screen.Cursor:=-11;
        MainForm.ListView.Items.BeginUpdate;
        MainForm.ListView.Items.Clear;
        mp3:=TMPEGAudio.Create;
        b:=0;
        for a:=0 to Files.Count-1 do
        begin
                if FileExists(Files.Strings[a]) then
                begin
                        lst:=MainForm.ListView.Items.Add;
                        lst.ImageIndex:=0;
                        Inc(b);
                        lst.Caption:=IntToStr(b)+'.';
                        mp3.FileName:=Files.Strings[a];
                        case MainForm.rgDisplay.ItemIndex of
                                0: lst.SubItems.Add(mp3.Artist+' - '+ mp3.Title);
                                1: lst.SubItems.Add(mp3.Artist+': "'+mp3.Title+'"');
                                2: lst.SubItems.Add('"'+mp3.Title+'" ('+mp3.Artist+')');
                                3: lst.SubItems.Add(mp3.Title+' by '+mp3.Artist);
                        end;
                        if IsProject then
                        begin
                                lst.SubItems.Add(IntToStr(Times[a]));
                        end
                        else
                        begin
                                lst.SubItems.Add(IntToStr(GlobalEndMarker));
                        end;
                        lst.SubItems.Add(Files.Strings[a]);
                        lst.SubItems.Add(Copy(TimeToStr(mp3.DurationTime),4,5));
                        tSummary:=tSummary+mp3.DurationTime;
                end;
        end;
        MainForm.ListView.Items.EndUpdate;
        mp3.Free;
        Files.Clear;
        for a:=0 to MainForm.ListView.Items.Count-1 do Files.Add(MainForm.ListView.Items[a].SubItems[2]);
        MainForm.StatusBar.Panels[2].Text:='Utworów: '+IntToStr(b);
        MainForm.StatusBar.Panels[3].Text:='Czas trwania: '+TimeToStr(tSummary);
        Screen.Cursor:=0;        
end;

function ParseTime(input: String): String;
begin
        Result:=Copy(input,1,5);
end;

function ParseDate(Date: TDateTime): String;
var
        data: String;
        a: Integer;
const
        months_org :array[1..12] of String = ('styczeñ','luty','marzec','kwiecieñ','maj','czerwiec','lipiec','sierpieñ','wrzesieñ','paŸdziernik','listopad','grudzieñ');
        months_my :array[1..12] of String = ('stycznia','lutego','marca','kwietnia','maja','czerwca','lipca','sierpnia','wrzeœnia','paŸdziernika','listopada','grudnia');
begin
        data:=FormatDateTime('dddddd',Date);
        for a:=1 to 12 do data:=StringReplace(data,months_org[a],months_my[a],[rfReplaceAll]);
        Result:=data+' r.';
end;

procedure PlaySong(SongNumber: Integer; OnThePlayer, OldPlayer: TXAudioPlayer; WithFadeIn: Boolean);
var
        del: Integer;
begin
        if SongNumber>MainForm.ListView.Items.Count-1 then
        begin
                Application.MessageBox('Osi¹gniêto koniec listy!'+chr(13)+'Wygaszacz ekranu i tryb Auto zosta³y wy³¹czone.','Informacja...',MB_OK+MB_ICONINFORMATION+MB_DEFBUTTON1);
                AutoModeIsOn:=False;
                MainForm.btnSaver.Enabled:=False;
                MainForm.btnPlay.Enabled:=True;
                MainForm.btnPause.Enabled:=True;
                MainForm.btnStop.Enabled:=True;
                MainForm.btnNew.Enabled:=True;
                MainForm.btnOpen.Enabled:=True;
                MainForm.btnSave.Enabled:=True;
                MainForm.btnAddSong.Enabled:=True;
                MainForm.btnRemoveSong.Enabled:=True;
                MainForm.btnMoveUp.Enabled:=True;
                MainForm.btnMoveDown.Enabled:=True;
                MainForm.btnRefreshList.Enabled:=True;
                MainForm.ListView.Enabled:=True;
                MainForm.btnAutoMode.Down:=False;
                MainForm.btnAutoMode.Hint:='Wy³¹cz tryb Auto';

                MainForm.StatusBar.Panels[0].Text:='Tryb automatyczny wy³¹czony.';
                MainForm.StatusBar.Panels[1].Text:='Rêczny';
                TickCount:=0;
                OldPlayer.Stop;
                OldPlayer.InputClose;

                if ScreenSaverIsOn then
                begin
                        Screen.Cursor:=0;
                        ScreenSaverIsOn:=False;
                        SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,1,nil,0);
                        ScreenForm.lbl2.Font.Color:=clLime;
                        ScreenForm.lbl4.Font.Color:=clLime;
                        ScreenForm.Hide;
                end;

                exit;
        end;

        if not FileExists(MainForm.ListView.Items[SongNumber].SubItems[2]) then
        begin
                Application.MessageBox(PChar(MainForm.ListView.Items[SongNumber].SubItems[2]+chr(13)+'Plik nie zosta³ odnaleziony !!!'),'B³¹d!',MB_OK+MB_ICONERROR+MB_DEFBUTTON1);
                exit;
        end;

        OnThePlayer.Stop;
        OnThePlayer.InputClose;
        OnThePlayer.InputOpen(MainForm.ListView.Items[SongNumber].SubItems[2]);
        OnThePlayer.Play;

        ThePlayer:=OnThePlayer;

        CurrentSong:=SongNumber;

        MainForm.StatusBar.Panels[0].Text:='Odtwarzanie utworu: '+MainForm.ListView.Items[SongNumber].SubItems[0];
        TickCount:=-5;

        if WithFadeIn=True then
        begin
                if SongNumber=0 then
                        del:=StrToIntDef(MainForm.ListView.Items[SongNumber].SubItems[1],GlobalEndMarker)*10
                else
                        del:=StrToIntDef(MainForm.ListView.Items[SongNumber-1].SubItems[1],GlobalEndMarker)*10;
                CrossFadeVolume(OnThePlayer,OldPlayer,del);
        end
        else
        begin
                OnThePlayer.SetOutputVolume(XaudioPlayer.XA_OUTPUT_VOLUME_IGNORE_FIELD, 100, XaudioPlayer.XA_OUTPUT_VOLUME_IGNORE_FIELD);
        end;

        //FadeLabel([ScreenForm.lbl2,ScreenForm.lbl4],False);
        MainForm.pnlVolText.Caption:='Granie...';
end;

procedure CrossFadeVolume(FadeInPlayer, FadeOutPlayer: TXAudioPlayer; DelayValue: Integer);
var
        vol, blink: Integer;
begin
        blink:=0;
        for vol:=0 to 100 do
        begin
                //Labels' fade
                if AutoModeSettingsForm.rgPassThrough.ItemIndex=0 then if vol <= 50 then FadeLabels([ScreenForm.lbl2,ScreenForm.lbl4],vol);
                if vol = 50 then SwitchLabels;
                if AutoModeSettingsForm.rgPassThrough.ItemIndex=0 then if vol > 50 then FadeLabels([ScreenForm.lbl2,ScreenForm.lbl4],Abs(vol-100));

                //Volume's fade
                FadeInPlayer.SetOutputVolume(XaudioPlayer.XA_OUTPUT_VOLUME_IGNORE_FIELD, vol, XaudioPlayer.XA_OUTPUT_VOLUME_IGNORE_FIELD);
                FadeOutPlayer.SetOutputVolume(XaudioPlayer.XA_OUTPUT_VOLUME_IGNORE_FIELD, 100-vol, XaudioPlayer.XA_OUTPUT_VOLUME_IGNORE_FIELD);
                Inc(blink);
                if blink=5 then MainForm.pnlVolText.Caption:='Przejœcie!';
                if blink=10 then
                begin
                        MainForm.pnlVolText.Caption:='';
                        blink:=0;
                end;
                Delay(DelayValue);
        end;
end;

procedure SwitchLabels();
var
        TheMP3: TMPEGAudio;
begin
        TheMP3:=TMPEGAudio.Create;
        TheMP3.FileName:=Files.Strings[CurrentSong];
        ScreenForm.lbl1.Caption:='Teraz gramy';
        ScreenForm.lbl2.Caption:=RemoveAmpersand(TheMP3.Artist+chr(13)+'"'+TheMP3.Title+'"');
        if CurrentSong=MainForm.ListView.Items.Count-1 then
        begin
                ScreenForm.lbl4.Caption:='Dalej nie ma ju¿ nic...';
                ScreenForm.lbl3.Caption:='Nastêpny kawa³ek';
        end
        else
        begin
                TheMP3.FileName:=Files.Strings[CurrentSong+1];
                ScreenForm.lbl3.Caption:='Nastêpny kawa³ek';
                ScreenForm.lbl4.Caption:=RemoveAmpersand(TheMP3.Artist+chr(13)+'"'+TheMP3.Title+'"');
        end;
        TheMP3.Free;
end;

procedure FadeLabels(Labels: array of TLabel; Value: Integer);
begin
        {for a:=Low(Labels) to High(Labels) do
        begin
                rS:=GetRValue(ColorToRGB(Labels[a].Font.Color));
                rE:=GetRValue(ColorToRGB(ScreenForm.Color));
                rC:=Trunc((rE-rS) div 50);
                gS:=GetGValue(ColorToRGB(Labels[a].Font.Color));
                gE:=GetGValue(ColorToRGB(ScreenForm.Color));
                gC:=Trunc((gE-gS) div 50);
                bS:=GetBValue(ColorToRGB(Labels[a].Font.Color));
                bE:=GetBValue(ColorToRGB(ScreenForm.Color));
                bC:=Trunc((bE-bS) div 50);
                Labels[a].Font.Color:=RGB(Value*rC,Value*gC,Value*bC);
        end;}
end;

procedure Delay(MSecs: Longint);
var
        FirstTickCount, Now: Longint;
begin
        FirstTickCount := GetTickCount;
        repeat
                Application.ProcessMessages;
                Now := GetTickCount;
        until (Now - FirstTickCount >= MSecs) or (Now < FirstTickCount);
end;

function SecondsToClockUnits(Seconds: Integer): TClockUnit;
begin
        Result.Hours:=Seconds div 3600;
        Seconds:=Seconds-3600*Result.Hours;
        Result.Minutes:=Seconds div 60;
        Seconds:=Seconds-60*Result.Minutes;
        Result.Seconds:=Seconds;
end;

function ClockUnitsToSeconds(Hours, Minutes, Seconds: Integer): Integer;
begin
        Result:=(Hours*3600)+(Minutes*60)+Seconds;
end;

procedure UpdateListNumbers;
var
        a: Integer;
begin
        MainForm.ListView.Items.BeginUpdate;
        for a:=0 to MainForm.ListView.Items.Count-1 do MainForm.ListView.Items[a].Caption:=IntToStr(a+1);
        MainForm.ListView.Items.EndUpdate;
end;

function RemoveAmpersand(Text: String): String;
var
        r,s: String;
        a: Integer;
begin
        r:=Text;
        s:=Text;
        for a:=1 to Length(s) do
        begin
                if s[a]='&' then r:=Copy(s,1,a)+Copy(s,a,Length(s));
        end;
        Result:=r;
end;

end.

require 'log_utils'

describe LogUtils do

  let(:extended_class) { Class.new { extend LogUtils } }

  describe "Read from file" do
    it "should raise error when file not found" do
      expect { extended_class.read_from_file("not_exist_file") }.to raise_error(Errno::ENOENT)
    end

    it "should not raise error when file exist" do
      expect { extended_class.read_from_file(extended_class.get_log_file_path) }.not_to raise_error
    end
  end

  describe "Game start" do
    it "should be true if the line is a starting line" do
      line = '0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'
      expect(extended_class.game_start?(line)).to be true
    end

    it "should be false if the line is not a starting line" do
      line = "3:32 ClientConnect: 2"
      expect(extended_class.game_start?(line)).to be false
    end
  end

  describe "Game over" do
    it "should be true if the line is an ending line" do
      line = " 20:37 ------------------------------------------------------------"
      expect(extended_class.game_over?(line)).to be true
    end

    it "should be false if the line is not an ending line" do
      line = "3:32 ClientConnect: 2"
      expect(extended_class.game_over?(line)).to be false
    end
  end

  describe "Player line" do
    it "should be true if the line contains player information" do
      line = '21:51 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      expect(extended_class.player_line?(line)).to be true
    end

    it "should be false if the line doesn't conatain player information" do
      line = "15:00 Exit: Timelimit hit."
      expect(extended_class.player_line?(line)).to be false
    end
  end

  describe "Get player name" do
    it "should parse the kill event successfully" do
      line = '21:51 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      player_name = extended_class.get_player_name(line)
      expect(player_name).to eq("Dono da Bola")
    end
  end

  describe "Kill event" do
    it "should be true if the line is an killing event" do
      line = "21:42 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT"
      expect(extended_class.kill_event?(line)).to be true

      line = "2:22 Kill: 3 2 10: Isgalamido killed Dono da Bola by MOD_RAILGUN"
      expect(extended_class.kill_event?(line)).to be true
    end

    it "should be false if the line is not an killing event" do
      line = "15:00 Exit: Timelimit hit."
      expect(extended_class.kill_event?(line)).to be false

      line = "21:42 Kill: 1022 2 22: "
      expect(extended_class.kill_event?(line)).to be false
    end
  end

  describe "Get kill info from kill event" do
    it "should parse the kill event successfully" do
      line = "21:42 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT"
      killer, killed, kill_reason = extended_class.get_kill_info_from_kill_event(line)
      expect(killer).to eq("<world>")
      expect(killed).to eq("Isgalamido")
      expect(kill_reason).to eq("MOD_TRIGGER_HURT")

      line = "2:22 Kill: 3 2 10: Isgalamido killed Dono da Bola by MOD_RAILGUN"
      killer, killed, kill_reason = extended_class.get_kill_info_from_kill_event(line)
      expect(killer).to eq("Isgalamido")
      expect(killed).to eq("Dono da Bola")
      expect(kill_reason).to eq("MOD_RAILGUN")
    end
  end
end
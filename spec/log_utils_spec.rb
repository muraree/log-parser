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
end
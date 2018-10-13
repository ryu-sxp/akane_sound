class Setup < Akane
  def self.prepare_config
    unless File.file?(@@pref_dir+"config.yaml")
      file = File.open("./akane_sound/config.yaml", "r")
      contents = file.read
      file.close
      contents.sub! 'FILE_PATH_BG', @@pref_dir+'akane_bg.png'
      contents.sub! 'FILE_PATH_FONT', @@pref_dir+'KosugiMaru-Regular.ttf'
      contents.sub! 'FILE_PATH_ROOT', Dir.home

      File.open(@@pref_dir+'config.yaml', 'w') { |file| file.write(contents) }
      @@config = YAML.load(File.open(@@pref_dir+'config.yaml'))
    else
      @@config = YAML.load(File.open(@@pref_dir+'config.yaml'))
    end
    @@config[:root_dir] += '/' unless @@config[:root_dir][-1] == '/'
  end

  def self.prepare_save_data
    unless File.file?(@@pref_dir+"save_data.yaml")
      file = File.open("./akane_sound/save_data.yaml", "r")
      contents = file.read
      file.close

      File.open(@@pref_dir+'save_data.yaml', 'w') do |file|
        file.write(contents)
      end
      @@save_data = YAML.load(File.open(@@pref_dir+'save_data.yaml'))
    else
      @@save_data = YAML.load(File.open(@@pref_dir+'save_data.yaml'))
    end
  end

  def self.prepare_binary_data(filename)
    unless File.file?(@@pref_dir+filename)
      Util.binary_copy(@@pref_dir, filename)
    end
  end
end

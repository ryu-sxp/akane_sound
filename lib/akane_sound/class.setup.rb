class Setup < AkaneSound
  def self.init(arg)
    @@pref_dir = SDL2.preference_path("ruby_app", "akane_sound")
    if arg == "debug"
      @@debug_flag = true
      File.delete(File.open(@@pref_dir+'config.yaml')) if File.exist?(@@pref_dir+'config.yaml')
      #File.delete(File.open(@@pref_dir+'save_data.yaml'))
    end
    str = (@@debug_flag) ? "cache_debug.yaml" : "cache.yaml"
    if File.exist?(File.join(@@pref_dir, str))
      @@cache = YAML.load(File.open(File.join(@@pref_dir, str)))
    end
    Setup::prepare_config
    Setup::prepare_save_data
    #Setup::prepare_binary_data('akane_bg.png')
    #Setup::prepare_binary_data('NotoSansCJKjp-Regular.otf')
    #Setup::prepare_binary_data('NotoSansCJKjp-Medium.otf')
    #Setup::prepare_binary_data('NotoSansCJKjp-Bold.otf')
  end

  def self.prepare_config
    unless File.file?(@@pref_dir+"config.yaml")
      file = File.open(File.join(__dir__, "../../data/config.yaml"), "r")
      contents = file.read
      file.close
      #contents.sub! 'FILE_PATH_BG', @@pref_dir+'akane_bg.png'
      contents.sub!('FILE_PATH_BACKGROUND',
                  File.join(__dir__, '../../data/akane_bg.png'))
      contents.sub!('FILE_PATH_FONT_BOLD',
                  File.join(__dir__, '../../data/NotoSansCJKjp-Bold.otf'))
      contents.sub!('FILE_PATH_FONT',
                  File.join(__dir__, '../../data/NotoSansCJKjp-Regular.otf'))
      contents.sub!('FILE_PATH_ROOT', Dir.home)

      File.open(@@pref_dir+'config.yaml', 'w') { |file| file.write(contents) }
      @@config = YAML.load(File.open(@@pref_dir+'config.yaml'))
    else
      @@config = YAML.load(File.open(@@pref_dir+'config.yaml'))
    end
    @@config[:root_dir] += '/' unless @@config[:root_dir][-1] == '/'
  end

  def self.prepare_save_data
    unless File.file?(@@pref_dir+"save_data.yaml")
      file = File.open(File.join(__dir__, "../../data/save_data.yaml"), "r")
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

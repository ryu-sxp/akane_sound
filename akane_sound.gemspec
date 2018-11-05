Gem::Specification.new do |s|
  s.name = 'akane_sound'
  s.version = '0.1.3'
  s.executables << "akane_sound"
  s.date = '2018-11-04'
  s.summary = 'audio player using sdl2'
  s.description = 'audio player using sdl2. see github link for details'
  s.authors = ["tohya ryu"]
  s.email = 'ryu@hirasaka.io'
  s.files = ["lib/akane_sound.rb", "lib/akane_sound/class.background.rb",
             "lib/akane_sound/class.element.rb",
             "lib/akane_sound/class.input.rb",
             "lib/akane_sound/class.section_dir.rb",
             "lib/akane_sound/class.section_playlist.rb",
             "lib/akane_sound/class.section_status.rb",
             "lib/akane_sound/class.setup.rb",
             "lib/akane_sound/class.sound.rb",
             "lib/akane_sound/class.upper_section_base.rb",
             "lib/akane_sound/class.view_base.rb",
             "lib/akane_sound/module.util.rb",
             "data/akane_bg.png",
             "data/config.yaml",
             "data/save_data.yaml",
             "data/NotoSansCJKjp-Bold.otf",
             "data/NotoSansCJKjp-Regular.otf"]
  s.homepage = 'https://github.com/ryu-sxp/akane_sound'
  s.license = 'GPL-3.0'
end

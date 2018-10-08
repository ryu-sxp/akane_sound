require "sdl2"
require "yaml"

class Input
  attr_accessor :up, :down, :quit
  def initialize
    @up = 0
    @down = 0
    @quit = 0
  end

  def handle_event(event)
    case event
    when SDL2::Event::Quit
      @quit += 1
    when SDL2::Event::KeyDown
      case event.sym
      when SDL2::Key::ESCAPE
        @quit += 1
      end
    end
  end
end


SDL2.init(SDL2::INIT_TIMER|SDL2::INIT_AUDIO|SDL2::INIT_VIDEO|SDL2::INIT_EVENTS)

rootdir = SDL2.preference_path("sxp", "akane_sound")
config = Hash.new
unless File.file?(rootdir+"config")
  config[:window_w] = 640
  config[:window_h] = 480
  config[:bg_img] = ""
  yaml = config.to_yaml

  File.open(rootdir+"config", 'w') { |file| file.write(yaml) }
else
  config = YAML.load(File.open(rootdir+"config"))
end

window = SDL2::Window.create("akane_sound", 0, 0, config[:window_w],
                             config[:window_h], 0);
inp = Input.new
loop do
  exit
  while event = SDL2::Event.poll
    inp.handle_event(event)
  end
  #window.update
  #window.draw
  if inp.quit >= 1
    exit
  end
end





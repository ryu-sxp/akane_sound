class Input
  attr_accessor :up, :down, :quit
  def initialize
    @up = 0
    @down = 0
    @quit = 0
    @accept = 0
    @toggle_shuffle = 0
    @toggle_repeat = 0
    @toggle_next = 0
  end

  def handle_event(event)
    case event
    when SDL2::Event::Quit
      @quit += 1
    when SDL2::Event::KeyDown
      if event.sym == SDL2::Key::ESCAPE
        @quit += 1
      else
        @quit = 0
      end
      if event.sym == SDL2::Key::RETURN
        @accept += 1
      else
        @accept = 0
      end
      if event.sym == SDL2::Key::SPACE
        @accept += 1
      else
        @accept = 0
      end
      if event.sym == SDL2::Key::J
        @down += 1
      else
        @down = 0
      end
      if event.sym == SDL2::Key::K
        @up += 1
      else
        @up = 0
      end
      if event.mod == SDL2::Key::Mod::SHIFT && event.sym == SDL2::Key::S
        @toggle_shuffle += 1        
        Util.p "toggle_shuffle"
      else
        @toggle_shuffle = 0        
      end
      if event.mod == SDL2::Key::Mod::SHIFT && event.sym == SDL2::Key::R
        @toggle_repeat += 1        
        Util.p "toggle_repeat"
      else
        @toggle_repeat = 0        
      end
      if event.mod == SDL2::Key::Mod::SHIFT && event.sym == SDL2::Key::N
        @toggle_next += 1        
        Util.p "toggle_next"
      else
        @toggle_next = 0        
      end
      if event.sym == SDL2::Key::AUDIOMUTE
        Util.p "lol"
      end
    end
  end
end

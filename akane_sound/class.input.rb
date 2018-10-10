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

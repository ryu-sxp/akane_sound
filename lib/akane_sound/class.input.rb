class Input < AkaneSound
  attr_accessor :up, :down, :pageup, :pagedown, :quit, :accept,
    :toggle_shuffle, :toggle_repeat, :toggle_next, :toggle_mute,
    :vol_up, :vol_down, :stop, :pause, :next, :refresh, :cmd, :any_key,
    :last, :first, :prev, :append, :append_r, :switch, :clear, :write
  def initialize
    @tmp_up, @up = 0
    @tmp_down, @down = 0
    @tmp_last, @last = 0
    @tmp_first, @first = 0
    @tmp_pageup, @pageup = 0
    @tmp_pagedown, @pagedown = 0
    @tmp_quit, @quit = 0
    @tmp_accept, @accept = 0
    @tmp_clear, @clear = 0
    @tmp_toggle_shuffle, @toggle_shuffle = 0
    @tmp_toggle_repeat, @toggle_repeat = 0
    @tmp_toggle_next, @toggle_next = 0
    @tmp_toggle_mute, @toggle_mute = 0
    @tmp_vol_up, @vol_up = 0
    @tmp_vol_down, @vol_down = 0
    @tmp_stop, @stop = 0
    @tmp_pause, @pause = 0
    @tmp_next, @next = 0
    @tmp_prev, @prev = 0
    @tmp_append, @append = 0
    @tmp_append_r, @append_r = 0
    @tmp_refresh, @refresh = 0
    @tmp_cmd, @cmd = 0
    @tmp_switch, @switch = 0
    @tmp_write, @write = 0
    @tmp_any_key, @any_key = 0
  end

  def handle_event(event)
    case event
    when SDL2::Event::Quit
      @quit = 1
    when SDL2::Event::KeyDown
      @tmp_any_key = 1
      if event.sym == SDL2::Key::TAB
        @tmp_switch = 1
      end
      if event.sym == SDL2::Key::ESCAPE
        @tmp_quit = 1
      end
      if event.sym == SDL2::Key::RETURN
        @tmp_accept = 1
      end
      if event.sym == SDL2::Key::SPACE
        @tmp_pause = 1
      end

      if event.sym == SDL2::Key::J
        @tmp_down = 1
      end
      if event.sym == SDL2::Key::K
        @tmp_up = 1
      end
      if event.sym == SDL2::Key::W
        @tmp_write = 1
      end

      if event.sym == SDL2::Key::PAGEDOWN
        @tmp_pagedown = 1
      end
      if event.sym == SDL2::Key::PAGEUP
        @tmp_pageup = 1
      end
      if event.sym == SDL2::Key::P
        @tmp_prev = 1
      end

      if event.sym == SDL2::Key::G
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_last = 1
        else
          @tmp_first = 1
        end
      end

      if event.sym == SDL2::Key::S
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_toggle_shuffle = 1        
        else
          @tmp_stop = 1
        end
      end

      if event.sym == SDL2::Key::N
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_toggle_next = 1        
        else
          @tmp_next = 1
        end
      end
      
      if event.sym == SDL2::Key::R
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_toggle_repeat = 1        
        else
          @tmp_refresh = 1
        end
      end

      if event.sym == SDL2::Key::A
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_append_r = 1        
        else
          @tmp_append = 1
        end
      end

      if event.sym == SDL2::Key::C
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_clear = 1
        end
      end

      if event.sym == SDL2::Key::PERIOD
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_vol_up = 1        
        end
      end
      if event.sym == SDL2::Key::VOLUMEUP
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_vol_up = 1        
        end
      end

      if event.sym == SDL2::Key::COMMA
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_vol_down = 1        
        end
      end

      if event.sym == SDL2::Key::SEMICOLON
        if event.mod.bit?(SDL2::Key::Mod::SHIFT)
          @tmp_cmd = 1        
        end
      end
    when SDL2::Event::KeyUp
      @tmp_any_key = 0
      if event.sym == SDL2::Key::TAB
        @tmp_switch = 0
      end
      if event.sym == SDL2::Key::ESCAPE
        @tmp_quit = 0
      end
      if event.sym == SDL2::Key::RETURN
        @tmp_accept = 0
      end
      if event.sym == SDL2::Key::SPACE
        @tmp_pause = 0
      end

      if event.sym == SDL2::Key::J
        @tmp_down = 0
      end
      if event.sym == SDL2::Key::K
        @tmp_up = 0
      end
      if event.sym == SDL2::Key::W
        @tmp_write = 0
      end

      if event.sym == SDL2::Key::PAGEDOWN 
        @tmp_pagedown = 0
      end
      if event.sym == SDL2::Key::P
        @tmp_prev = 0
      end
      if event.sym == SDL2::Key::PAGEUP
        @tmp_pageup = 0
      end

      if event.sym == SDL2::Key::G
        @tmp_last = 0
        @tmp_first = 0
      end

      if event.sym == SDL2::Key::S
        @tmp_toggle_shuffle = 0
        @tmp_stop = 0
      end

      if event.sym == SDL2::Key::N
        @tmp_toggle_next = 0
        @tmp_next = 0
      end
      
      if event.sym == SDL2::Key::R
        @tmp_toggle_repeat = 0
        @tmp_refresh = 0
      end

      if event.sym == SDL2::Key::A
        @tmp_append = 0
        @tmp_append_r = 0
      end

      if event.sym == SDL2::Key::C
        @tmp_clear = 0
      end

      if event.sym == SDL2::Key::PERIOD
        @tmp_vol_up = 0
      end
      if event.sym == SDL2::Key::VOLUMEUP
        @tmp_vol_up = 0
      end

      if event.sym == SDL2::Key::COMMA
        @tmp_vol_down = 0
      end

      if event.sym == SDL2::Key::SEMICOLON
        @tmp_cmd = 0
      end
    end
  end

  def set_state
    if @tmp_any_key == 1
      @any_key += 1
    else
      @any_key = 0
    end
    if @tmp_switch == 1
      @switch += 1
    else
      @switch = 0
    end
    if @tmp_quit == 1
      @quit += 1
    else
      @quit = 0
    end
    if @tmp_write == 1
      @write += 1
    else
      @write = 0
    end
    if @tmp_up == 1
      @up += 1
    else
      @up = 0
    end
    if @tmp_down == 1
      @down += 1
    else
      @down = 0
    end
    if @tmp_last == 1
      @last += 1
    else
      @last = 0
    end
    if @tmp_first == 1
      @first += 1
    else
      @first = 0
    end
    if @tmp_pageup == 1
      @pageup += 1
    else
      @pageup = 0
    end
    if @tmp_pagedown == 1
      @pagedown += 1
    else
      @pagedown = 0
    end
    if @tmp_accept == 1
      @accept += 1
    else
      @accept = 0
    end
    if @tmp_pause == 1
      @pause += 1
    else
      @pause = 0
    end
    if @tmp_stop == 1
      @stop += 1
    else
      @stop = 0
    end
    if @tmp_toggle_shuffle == 1
      @toggle_shuffle += 1
    else
      @toggle_shuffle = 0
    end
    if @tmp_toggle_repeat == 1
      @toggle_repeat += 1
    else
      @toggle_repeat = 0
    end
    if @tmp_toggle_next == 1
      @toggle_next += 1
    else
      @toggle_next = 0
    end
    if @tmp_toggle_mute == 1
      @toggle_mute += 1
    else
      @toggle_mute = 0
    end
    if @tmp_vol_up == 1
      @vol_up += 1
    else
      @vol_up = 0
    end
    if @tmp_vol_down == 1
      @vol_down += 1
    else
      @vol_down = 0
    end
    if @tmp_next == 1
      @next += 1
    else
      @next = 0
    end
    if @tmp_prev == 1
      @prev += 1
    else
      @prev = 0
    end
    if @tmp_append == 1
      @append += 1
    else
      @append = 0
    end
    if @tmp_clear == 1
      @clear += 1
    else
      @clear = 0
    end
    if @tmp_append_r == 1
      @append_r += 1
    else
      @append_r = 0
    end
    if @tmp_refresh == 1
      @refresh += 1
    else
      @refresh = 0
    end
    if @tmp_cmd == 1
      @cmd += 1
    else
      @cmd = 0
    end
  end

end

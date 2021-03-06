require "sdl2"
require "yaml"
require "akane_sound/module.util"

class Integer
  def bit?(mask)
    (self & mask) != 0
  end
end

class AkaneSound
  @@window     = nil
  @@win_w      = 0
  @@win_h      = 0
  @@renderer   = nil
  @@pref_dir   = nil
  @@screen     = nil
  @@sec_status = nil
  @@sec_dir = nil
  @@sec_pl = nil
  @@sound      = nil
  @@config     = Hash.new
  @@save_data  = Hash.new
  @@cache      = Hash.new
  @@alert_flag = false
  @@inp        = nil
  @@debug_flag = false
  @@font       = nil
  @@font_bold  = nil
  @@music      = nil
  @@cmd_flag   = false
  @@sleep_flag = false
  @@tstmp_now  = nil
  @@msg = nil
  @@msg_rect = nil
  def initialize
    SDL2.init(SDL2::INIT_TIMER|SDL2::INIT_AUDIO|SDL2::INIT_VIDEO|
              SDL2::INIT_EVENTS)
    SDL2::TTF.init
    SDL2::Mixer.init(SDL2::Mixer::INIT_FLAC|SDL2::Mixer::INIT_MODPLUG|
                     SDL2::Mixer::INIT_MP3|SDL2::Mixer::INIT_OGG)
    #SDL2::Mixer.open(44100, SDL2::Mixer::DEFAULT_FORMAT, 2, 512)
    #SDL2::Mixer.open(48000, SDL2::Mixer::DEFAULT_FORMAT, 2, 512)

    Setup::init(ARGV[0])

    @@window = SDL2::Window.create("akane_sound", SDL2::Window::POS_CENTERED,
                                   SDL2::Window::POS_CENTERED,
                                   @@config[:window_w], @@config[:window_h],
                                   SDL2::Window::Flags::RESIZABLE)
    @@win_w = @@window.size[0]
    @@win_h = @@window.size[1]

    @@renderer = @@window.create_renderer(-1, 0)
    @@screen = SDL2::Rect[0, 0, @@config[:window_w], @@config[:window_h]]
    @@font = SDL2::TTF.open(@@config[:font], @@config[:font_size])
    @@font_bold = SDL2::TTF.open(@@config[:font_big], @@config[:font_size])
    @frames = 0
    @fps = 30
    @tstmp_start = nil
    @tstmp_last_input = SDL2.get_ticks

  end

  def run(argv)
    bg = Background.new(@@config[:bg_img])
    @@inp = Input.new
    @@sound = Sound.new
    @@sec_status = SectionStatus.new(0, @@config[:window_h]-80,
                                     @@config[:window_w], 80,
                                     @@config[:view_bottom_bg_color])
    @@sec_dir = SectionDir.new(0, 0, @@config[:window_w]/2,
                             @@config[:window_h]-80,
                             @@config[:view_left_bg_color])
    @@sec_pl = SectionPlaylist.new(@@config[:window_w]/2, 0,
                                 @@config[:window_w]/2, @@config[:window_h]-80,
                                 @@config[:view_right_bg_color])
    loop do
      update_fps
      while event = SDL2::Event.poll
        @@inp.handle_event(event)
      end
      @@inp.set_state
      #update
      @tstmp_last_input = SDL2.get_ticks if @@inp.any_key >= 1
      if @@inp.quit >= 1
        save
        exit
      end
      unless @@sleep_flag
        if @@inp.switch == 1
          if @@sec_dir.focus_flag
            @@sec_dir.focus_flag = false
            @@sec_pl.focus_flag = true
          else
            @@sec_dir.focus_flag = true
            @@sec_pl.focus_flag = false
          end
          @@sec_dir.update_element_strings
          #@@sec_dir.set_page
          @@sec_dir.update_element_positions
          @@sec_pl.update_element_strings
          #@@sec_pl.set_page
          @@sec_pl.update_element_positions
        end
        if @@inp.clear == 1
          @@sec_pl.clear
        end
        if @@inp.write == 1
          write_playlist
        end
      end
      if @@window.size[0] != @@win_w || @@window.size[1] != @@win_h
        @@win_w = @@window.size[0]
        @@win_h = @@window.size[1]
        @@screen = SDL2::Rect[0, 0, @@win_w, @@win_h]
        bg.update
        @@sec_dir.update_size(0, 0, @@win_w/2, @@win_h-80)
        @@sec_pl.update_size(@@win_w/2, 0, @@win_w/2, @@win_h-80)
        @@sec_status.update_size(0, @@win_h-80, @@win_w, 80)
      else
        bg.update
      end
      @@sound.update
      unless @@sleep_flag
        @@sec_dir.update
        @@sec_pl.update
      end
      @@sec_status.update
      @@sleep_flag = false if @@inp.any_key >= 1
      sleep_check
      #draw
      @@renderer.viewport = nil
      bg.draw
      unless @@sleep_flag
        @@sec_dir.draw
        @@sec_pl.draw
      end
      @@sec_status.draw
      @@renderer.present
      #GC.start
      wait_fps
    end
  end

  def set_status(str)
    @@msg.destroy if @@msg
    @@msg = @@font.render_blended('> '+str, Util.to_col_ar(
      @@config[:text_color_status]))
    @@msg_rect = SDL2::Rect[0, 0, @@msg.w,
                                       @@msg.h]
  end

  private

  def save
    @@save_data[:volume] = @@sound.volume
    @@save_data[:cur_pl] = @@sec_pl.playlist
    File.open(@@pref_dir+'save_data.yaml', 'w') do |file|
      file.write(@@save_data.to_yaml)
    end
  end

  def write_playlist
    unless Dir.exist?(File.join(@@config[:root_dir], "akane_playlists"))
      Dir.mkdir(File.join(@@config[:root_dir], "akane_playlists"))
    end
    File.open(File.join(@@config[:root_dir], "akane_playlists",
              SDL2.get_ticks.to_s+'.apl.yaml'), 'w') do |file|
      file.write(@@sec_pl.playlist.to_yaml)
    end
  end

  def sleep_check
    @@tstmp_now = SDL2.get_ticks
    if @@config[:sleep_timer] > 0
      if (@@tstmp_now-@tstmp_last_input) >= @@config[:sleep_timer]*1000
        @@sleep_flag = true
      end
    end
  end

  def update_fps
    if @frames == 0
      @tstmp_start = SDL2.get_ticks
    end
    if @frames == @fps
      t = SDL2.get_ticks
      fps = 1000.to_f / ((t - @tstmp_start) / @fps.to_f)
      @frames = 0
      @tstmp_start = SDL2.get_ticks
    end
    @frames += 1
  end

  def wait_fps
    took_time = SDL2.get_ticks - @tstmp_start
    wait_time = @frames * 1000 / @fps - took_time
    if wait_time > 0
      SDL2.delay(wait_time)
    end
  end
end

require "akane_sound/class.sound"
require "akane_sound/class.element"
require "akane_sound/class.setup"
require "akane_sound/class.background"
require "akane_sound/class.input"
require "akane_sound/class.view_base"
require "akane_sound/class.upper_section_base"
require "akane_sound/class.section_dir"
require "akane_sound/class.section_playlist"
require "akane_sound/class.section_status"

class SectionStatus < ViewBase
  attr_accessor :msg, :msg_rect
  def initialize(x, y, w, h, col)
    @txt_color   = Util.to_col_ar(@@config[:text_color])
    @vol_rect
    @vol_texture
    @vol_text_rect
    @timer_passed_texture
    @timer_passed_rect
    @timer_total_texture
    @timer_total_rect
    @progress_bar_rect
    @shuffle_on = @@font_bold.render_blended('[SHUFFLE]', @txt_color)
    @shuffle_off = @@font.render_blended('[SHUFFLE]', @txt_color)
    @repeat_on = @@font_bold.render_blended('[REPEAT]', @txt_color)
    @repeat_off = @@font.render_blended('[REPEAT]', @txt_color)
    @next_on = @@font_bold.render_blended('[NEXT]', @txt_color)
    @next_off = @@font.render_blended('[NEXT]', @txt_color)
    super
    set_view
    set_status("Welcome to Akane")
    update_volume_rect
    update_volume_texture
    update_data
  end

  def update
    if @@inp.pause == 1
      @@sound.play_track
    end
    if @@inp.stop == 1
      @@sound.stop_track
    end
    if @@inp.vol_down == 1 || @@inp.vol_down >= 20
      @@sound.volume -= 1
      if @@inp.vol_down == 22
        @@inp.vol_down = 20
      end
      @@sound.volume = 0 if @@sound.volume < 0
      update_volume_rect
      update_volume_texture
      @@sound.set_vol
    end
    if @@inp.vol_up == 1 || @@inp.vol_up >= 20
      @@sound.volume += 1
      if @@inp.vol_up == 22
        @@inp.vol_up = 20
      end
      @@sound.volume = 128 if @@sound.volume > 128
      update_volume_rect
      update_volume_texture
      @@sound.set_vol
    end
    if @@inp.toggle_shuffle == 1
      @@sound.toggle_shuffle
    end
    if @@inp.toggle_repeat == 1
      @@sound.toggle_repeat
    end
    if @@inp.toggle_next == 1
      @@sound.toggle_next
    end
    if @@inp.next == 1
      @@sound.skip
    end
    update_timers
    update_progress_bar
    update_data
  end

  def update_size(x, y, w, h)
    super
    set_view
    update_volume_rect
    update_volume_texture
    update_progress_bar
    update_data
  end
  
  def draw
    super
    @@renderer.viewport = @view_base
    @@renderer.fill_rect(SDL2::Rect[0, 0, @view_base.w, @view_base.h])

    # draw status stuff
    @@renderer.viewport = @view
    @@renderer.copy(@@renderer.create_texture_from(@@msg), nil, @@msg_rect)
    # draw volume
    @@renderer.copy(@vol_texture, nil, @vol_text_rect)
    if @@sound.volume < 101
      @@renderer.draw_color = [@@config[:volume_bar_color][:red],
                               @@config[:volume_bar_color][:green],
                               @@config[:volume_bar_color][:blue],
                               @@config[:volume_bar_color][:alpha]]
    else
      @@renderer.draw_color = [@@config[:volume_bar_max_color][:red],
                               @@config[:volume_bar_max_color][:green],
                               @@config[:volume_bar_max_color][:blue],
                               @@config[:volume_bar_max_color][:alpha]]
    end
    @@renderer.fill_rect(@vol_rect)

    # draw timers
    @@renderer.copy(@timer_passed_texture, nil,
                      @timer_passed_rect)
    @@renderer.copy(@timer_total_texture, nil,
                      @timer_total_rect)
    # draw track info
    # sampling rate
    @@renderer.copy(@sampling_rate_texture, nil, @sampling_rate_rect)
    # bps
    @@renderer.copy(@bps_texture, nil, @bps_rect)
    # draw flags
    if @@sound.mode[:shuffle]
      @@renderer.copy(@@renderer.create_texture_from(@shuffle_on), nil,
                      SDL2::Rect[210, 18, @shuffle_on.w, @shuffle_on.h])
    else
      @@renderer.copy(@@renderer.create_texture_from(@shuffle_off), nil,
                      SDL2::Rect[210, 18, @shuffle_off.w, @shuffle_off.h])
    end
    if @@sound.mode[:repeat]
      @@renderer.copy(@@renderer.create_texture_from(@repeat_on), nil,
                      SDL2::Rect[210+@shuffle_on.w+2, 18,
                                 @repeat_on.w, @repeat_on.h])
    else
      @@renderer.copy(@@renderer.create_texture_from(@repeat_off), nil,
                      SDL2::Rect[210+@shuffle_on.w+2, 18,
                                 @repeat_off.w, @repeat_off.h])
    end
    if @@sound.mode[:next]
      @@renderer.copy(@@renderer.create_texture_from(@next_on), nil,
                      SDL2::Rect[210+@shuffle_on.w+2+@repeat_on.w+2, 18,
                                 @next_on.w, @next_on.h])
    else
      @@renderer.copy(@@renderer.create_texture_from(@next_off), nil,
                      SDL2::Rect[210+@shuffle_on.w+2+@repeat_on.w+2, 18,
                                 @next_off.w, @next_off.h])
    end

    # draw progess bar
    @@renderer.draw_color = [@@config[:prog_bar_color][:red],
                             @@config[:prog_bar_color][:green],
                             @@config[:prog_bar_color][:blue],
                             @@config[:prog_bar_color][:alpha]]
    @@renderer.fill_rect(@progress_bar_rect)
  end

  private

  def set_view
    @view = SDL2::Rect[@view_base.x+8,
                       @view_base.y+8,
                       @view_base.w-16,
                       @view_base.h-16]
  end

  def update_progress_bar
    @progress_bar_rect =
      SDL2::Rect[0, 36, @view.w * @@sound.progress / 100, 20]
  end

  def update_data
    if @@sound.state == "playing" || @@sound.state == "paused"
      track = @@sound.get_track
      str1 = "["+track[:sample]+"Hz]"
      str2 = "["+(track[:bps]/1000).to_s+" kbps]"
    else
      str1 = "[]"
      str2 = "[]"
    end
    sur = @@font.render_blended(str1, @txt_color)
    @sampling_rate_texture = @@renderer.create_texture_from(sur)
    @sampling_rate_rect = SDL2::Rect[84, 18, sur.w, sur.h]
    sur.destroy
    sur = @@font.render_blended(str2, @txt_color)
    @bps_texture = @@renderer.create_texture_from(sur)
    @bps_rect = SDL2::Rect[148, 18, sur.w, sur.h]
    sur.destroy
  end

  def update_timers
    if @@sound.state == "playing" || @@sound.state == "paused"
      str1 = "["+Util.ms_to_time_str(@@sound.tstmp_play_cur)+"]"
      track = @@sound.get_track
      str2 = "["+track[:pl_time]+"]"
    else
      str1 = "[]"
      str2 = "[]"
    end
    sur = @@font.render_blended(str1, @txt_color)
    @timer_passed_texture = @@renderer.create_texture_from(sur)
    @timer_passed_rect = SDL2::Rect[0, 18, sur.w, sur.h]
    sur.destroy
    sur = @@font.render_blended(str2, @txt_color)
    @timer_total_texture = @@renderer.create_texture_from(sur)
    @timer_total_rect = SDL2::Rect[42, 18, sur.w, sur.h]
    sur.destroy
  end

  def update_volume_texture
    int = @@sound.volume
    str = int.to_s
    str.prepend('0') if int < 100
    str.prepend('0') if int < 10
    str.prepend('Volume: ')
    str += "%"
    sur = @@font.render_blended(str, @txt_color)
    @vol_texture = @@renderer.create_texture_from(sur)
    @vol_text_rect = SDL2::Rect[@view.w-212, 18, sur.w, sur.h]
    sur.destroy
  end

  def update_volume_rect
    if @@msg_rect
      @vol_rect = SDL2::Rect[@view.w-128, 18, @@sound.volume, @@msg_rect.h]
    end
  end
end

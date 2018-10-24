class SectionStatus < ViewBase
  attr_accessor :msg, :msg_rect
  def initialize(x, y, w, h, col)
    @txt_color   = Util.to_col_ar(@@config[:text_color])
    @vol_rect
    @vol_texture
    @vol_text_rect
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
  end

  def update_size(x, y, w, h)
    super
    set_view
    update_volume_rect
    update_volume_texture
  end
  
  def draw
    super
    @@renderer.viewport = @view_base
    @@renderer.fill_rect(SDL2::Rect[0, 0, @view_base.w, @view_base.h])

    # draw status stuff
    @@renderer.viewport = @view
    @@renderer.copy(@@renderer.create_texture_from(@msg), nil, @msg_rect)
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
    # draw flags
    if @@sound.mode[:shuffle]
      @@renderer.copy(@@renderer.create_texture_from(@shuffle_on), nil,
                      SDL2::Rect[240, 18, @shuffle_on.w, @shuffle_on.h])
    else
      @@renderer.copy(@@renderer.create_texture_from(@shuffle_off), nil,
                      SDL2::Rect[240, 18, @shuffle_off.w, @shuffle_off.h])
    end
    if @@sound.mode[:repeat]
      @@renderer.copy(@@renderer.create_texture_from(@repeat_on), nil,
                      SDL2::Rect[240+@shuffle_on.w+4, 18,
                                 @repeat_on.w, @repeat_on.h])
    else
      @@renderer.copy(@@renderer.create_texture_from(@repeat_off), nil,
                      SDL2::Rect[240+@shuffle_on.w+4, 18,
                                 @repeat_off.w, @repeat_off.h])
    end
    if @@sound.mode[:next]
      @@renderer.copy(@@renderer.create_texture_from(@next_on), nil,
                      SDL2::Rect[240+@shuffle_on.w+4+@repeat_on.w+4, 18,
                                 @next_on.w, @next_on.h])
    else
      @@renderer.copy(@@renderer.create_texture_from(@next_off), nil,
                      SDL2::Rect[240+@shuffle_on.w+4+@repeat_on.w+4, 18,
                                 @next_off.w, @next_off.h])
    end
  end

  private

  def set_view
    @view = SDL2::Rect[@view_base.x+8,
                       @view_base.y+8,
                       @view_base.w-16,
                       @view_base.h-16]
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
    @vol_text_rect = SDL2::Rect[@view.w-212, 0, sur.w, sur.h]
    sur.destroy
  end

  def update_volume_rect
    if @msg_rect
      @vol_rect = SDL2::Rect[@view.w-128, 0, @@sound.volume, @msg_rect.h]
    end
  end
end

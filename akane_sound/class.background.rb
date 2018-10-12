class Background < Akane
  @sprite = nil
  @pos = nil
  def initialize(filepath)
    surface = SDL2::Surface.load(filepath)
    @sprite = @@renderer.create_texture_from(surface)
    surface.destroy
    case @@config[:bg_type]
    when 'normal'
      @pos = SDL2::Rect[0, 0, @sprite.w, @sprite.h]
    when 'none'
      @pos = nil
    when 'center'
      x = @@config[:window_w]/2-@sprite.w/2
      y = @@config[:window_h]/2-@sprite.h/2
      @pos = SDL2::Rect[x, y, @sprite.w, @sprite.h]
    when 'tile'
    when 'fit'
    when 'stretch'
      @pos = nil
    when 'scale'
    end
  end

  def update
    if @@config[:bg_type] == 'tile'
      @pos = Array.new
      x = y = 0
      while y < @@config[:window_h]
        while x < @@config[:window_w]
          @pos.push(SDL2::Rect[x, y, @sprite.w, @sprite.h])
          x += @sprite.w
        end
        y += @sprite.h
        x = 0
      end
    end
  end

  def draw
    unless @@config[:bg_type] == 'none'
      if @@config[:bg_type] == 'tile'
        @pos.each do |pos|
          @@renderer.copy(@sprite, nil, pos)
        end
      else
        @@renderer.copy(@sprite, nil, @pos)
      end
    end
    # overlay
    @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
    @@renderer.draw_color = [@@config[:bg_color][:red],
                             @@config[:bg_color][:green],
                             @@config[:bg_color][:blue],
                             @@config[:bg_color][:alpha]]
    @@renderer.fill_rect(@@screen)
  end
end


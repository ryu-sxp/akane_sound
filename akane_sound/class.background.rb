class Background < Akane
  @sprite = nil
  @pos = nil
  def initialize(filepath)
    surface = SDL2::Surface.load(filepath)
    @sprite = @@renderer.create_texture_from(surface)
    surface.destroy
    updt
  end

  def update
    updt
  end

  def draw
    unless @@config[:bg_type] == 'none'
      if @@config[:bg_type] == 'repeat'
        @pos.each do |pos|
          @@renderer.copy(@sprite, nil, pos)
        end
      else
        @@renderer.copy(@sprite, nil, @pos)
      end
    end
    # overlay
    unless @@sleep_flag
      @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
      @@renderer.draw_color = [@@config[:bg_color][:red],
                               @@config[:bg_color][:green],
                               @@config[:bg_color][:blue],
                               @@config[:bg_color][:alpha]]
      @@renderer.fill_rect(@@screen)
    end
  end

  private
  
  def updt
    case @@config[:bg_type]
    when 'normal'
      @pos = SDL2::Rect[0, 0, @sprite.w, @sprite.h]
    when 'none'
      @pos = nil
    when 'center'
      x = @@win_w/2-@sprite.w/2
      y = @@win_h/2-@sprite.h/2
      @pos = SDL2::Rect[x, y, @sprite.w, @sprite.h]
    when 'repeat'
      @pos = Array.new
      x = y = 0
      while y < @@win_h
        while x < @@win_w
          @pos.push(SDL2::Rect[x, y, @sprite.w, @sprite.h])
          x += @sprite.w
        end
        y += @sprite.h
        x = 0
      end
    when 'fit'
    when 'stretch'
      @pos = nil
    when 'scale'
    end
  end
end


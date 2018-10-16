class UpperSectionBase < ViewBase
  def initialize(x, y, w, h, col)
    super
    @view = nil
    @element_h = nil
    @offset = nil
    @max_elements = 0
    @element_h = (@@config[:font_size] * @@config[:line_height_mod]).to_i
    @offset = @element_h
    @max_elements = 0
    @view = SDL2::Rect[@view_base.x+@offset,
                       @view_base.y+@offset,
                       @view_base.w - @offset*2,
                       view_height]
  end

  def update
  end

  def update_size(x, y, w, h)
    super
    @view = SDL2::Rect[@view_base.x+@offset,
                       @view_base.y+@offset,
                       @view_base.w - @offset*2,
                       view_height]
  end

  def draw
    super
    @@renderer.viewport = @view_base
    @@renderer.fill_rect(SDL2::Rect[0,
                                    0,
                                    @view_base.w,
                                    @view_base.h])
    # draw border
    @@renderer.viewport = SDL2::Rect[@view.x-1,
                                     @view.y-1,
                                     @view.w+2,
                                     @view.h+2]
    @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
    @@renderer.draw_color = [@@config[:fg_color][:red],
                             @@config[:fg_color][:green],
                             @@config[:fg_color][:blue],
                             @@config[:fg_color][:alpha]]
    @@renderer.draw_rect(SDL2::Rect[0, 0, @view.w+2, @view.h+2])
    @@renderer.viewport = @view
    # draw item list
    i = 0
    @playlist.each do |item|
      unless item[:dir_flag]
        dur = @@font_bold.render_blended(item[:pl_time],
                                    Util.to_col_ar(
                                      @@config[:text_color]))
      end
      txt = @@font.render_blended(item[:filename],
                                  Util.to_col_ar(
                                    @@config[:text_color]))
      unless item[:dir_flag]
        #TODO if view - dur.w > txt.w then decrease txt.w by what's necessary
        sprite_w = txt.w
        sprite_h = txt.h
      else
        sprite_w = txt.w
        sprite_h = txt.h
      end
      @@renderer.copy(@@renderer.create_texture_from(txt),
                      SDL2::Rect[0, 0, sprite_w, sprite_h],
                      SDL2::Rect[4, 0+(i*@element_h)+(@element_h/2)-(sprite_h/2),
                            sprite_w,
                            sprite_h])
      txt.destroy
      i += 1
    end
  end

  private

  def view_height
    height = 0
    max_h = @view_base.h - @offset*2
    while height < max_h
      height += @element_h
      @max_elements += 1
    end
    return height
  end
end

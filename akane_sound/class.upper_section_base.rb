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
    @txt_color   = Util.to_col_ar(@@config[:text_color])
    @txt_col_dis = Util.to_col_ar(@@config[:text_color_disabled])
    @elements = Array.new

    update_elements
  end

  def update
  end

  def update_size(x, y, w, h)
    super
    @max_elements = 0
    @view = SDL2::Rect[@view_base.x+@offset,
                       @view_base.y+@offset,
                       @view_base.w - @offset*2,
                       view_height]
    update_elements
  end

  def update_elements
    @border = SDL2::Rect[@view.x-1, @view.y-1, @view.w+2, @view.h+2]
    i = 0
    txtcol = (@focus_flag) ? @txt_color : @txt_col_dis
    @elements.each { |e| e.destroy }
    @elements.clear
    @playlist.each do |item|
      el = Element.new
      unless item[:dir_flag]
        str = String.new
        unless item[:artist].empty?
          str = item[:artist]+' - '
        end
        unless item[:title].empty?
          str += item[:title]
        else
          str += item[:filename]
        end
        unless item[:album].empty?
          str += ' ('+item[:album]+')'
        end
        el.dur = @@font_bold.render_blended(item[:tag], txtcol)
      else
        str = item[:filename]
      end
      el.txt = @@font.render_blended(str, txtcol)
      unless item[:dir_flag]
        overshoot = ((@view.w-8)-el.dur.w-4)
        if el.txt.w >= overshoot
          sprite_w = el.txt.w-(el.txt.w-overshoot)
        else
          sprite_w = el.txt.w
        end
        sprite_h = el.txt.h
      else
        sprite_w = el.txt.w
        sprite_h = el.txt.h
      end
      y = 0+(i*@element_h)+(@element_h/2)-(sprite_h/2)
      el.txt_src = SDL2::Rect[0, 0, sprite_w, sprite_h]
      el.txt_dst = SDL2::Rect[4, y, sprite_w, sprite_h]
      unless item[:dir_flag]
        el.dur_dst = SDL2::Rect[(@view.w-el.dur.w)-4, y, el.dur.w, el.dur.h]
      end

      @elements.push(el)
      i += 1
    end
  end

  def draw
    super

    @@renderer.viewport = @view_base
    @@renderer.fill_rect(SDL2::Rect[0,
                                    0,
                                    @view_base.w,
                                    @view_base.h])
    # draw border
    @@renderer.viewport = @border
    @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
    @@renderer.draw_color = [@@config[:fg_color][:red],
                             @@config[:fg_color][:green],
                             @@config[:fg_color][:blue],
                             @@config[:fg_color][:alpha]]
    @@renderer.draw_rect(SDL2::Rect[0, 0, @border.w, @border.h])
    @@renderer.viewport = @view
    # draw item list
    @elements.each do |el|
      @@renderer.copy(@@renderer.create_texture_from(el.txt), el.txt_src,
                      el.txt_dst)
      if el.dur
        @@renderer.copy(@@renderer.create_texture_from(el.dur),
                        nil, el.dur_dst)
      end
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

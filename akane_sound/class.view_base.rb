class ViewBase < Akane
  @view = nil
  @col = nil
  def initialize(x, y, w, h, col)
    @view = SDL2::Rect[x, y, w, h]
    @col = col
  end

  def update
  end

  def draw
    @@renderer.viewport = @view
    @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
    @@renderer.draw_color = [@col[:red],
                             @col[:green],
                             @col[:blue],
                             @col[:alpha]]
    #TODO viewport?

  end
end


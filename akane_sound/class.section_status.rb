class SectionStatus < ViewBase
  attr_accessor :msg, :msg_rect
  def initialize(x, y, w, h, col)
    @msg
    @msg_rect
    super
    set_view
    set_status = "Welcome to Akane"
  end

  def update
  end

  def update_size(x, y, w, h)
    super
    set_view
  end
  
  def draw
    super
    @@renderer.viewport = @view_base
    @@renderer.fill_rect(SDL2::Rect[0, 0, @view_base.w, @view_base.h])

    # draw status stuff
    @@renderer.viewport = @view
    @@renderer.copy(@@renderer.create_texture_from(@msg), nil, @msg_rect)
  end

  private

  def set_view
    @view = SDL2::Rect[@view_base.x+8,
                       @view_base.y+8,
                       @view_base.w-16,
                       @view_base.h-16]
  end

end

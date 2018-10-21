class SectionPlaylist < UpperSectionBase
  def initialize(x, y, w, h, col)
    @focus_flag = @@save_data[:focus_right]
    @playlist = Array.new
    @pointer = @@save_data[:pointer_right]
    @page = @@save_data[:page_right]
    @offset_left = 4
    @offset_right = 8
    @title = "Playlist"
    super
  end

  def update
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end
end

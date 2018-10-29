class SectionPlaylist < UpperSectionBase
  attr_accessor :focus_flag
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
    super
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end

  def append(track, dir_flag, dir_stack)
    dir = dir_stack.join(nil)
    unless dir_flag
      track[:filename] = File.join(dir, track[:filename])
      @playlist.push(track)
    else
      ar = get_cache(File.join(dir, track[:filename]))
      ar = get_playlist(File.join(dir, track[:filename])) unless ar
      @playlist += ar
    end

    update_element_strings
    set_page
    update_element_positions
  end
end

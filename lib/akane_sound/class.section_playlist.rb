class SectionPlaylist < UpperSectionBase
  attr_accessor :focus_flag, :playlist
  def initialize(x, y, w, h, col)
    @focus_flag = @@save_data[:focus_right]
    unless @@save_data[:cur_pl]
      @playlist = Array.new
    else
      @playlist = @@save_data[:cur_pl]
      @@sound.set_tmp_playlist(@playlist, "right", "")
    end
    @pointer = @@save_data[:pointer_right]
    @page = @@save_data[:page_right]
    @offset_left = 4
    @offset_right = 8
    @title = "Playlist"
    super
  end

  def update
    super
    if @focus_flag
      if @@inp.accept == 1 && @playlist.length > 0
        @@sound.set_side("right")
        @@sound.stop_track
        @@sound.set_track(@pointer, true)
        @@sound.start_track
      end
    end
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end

  def append(track, dir_flag, dir_stack, recursive_flag)
    dir = dir_stack.join(nil)
    unless dir_flag
      track2 = track.clone
      track2[:filename] = File.join(dir, track[:filename])
      @playlist.push(track2)
    else
      #Util.p File.join(dir, track[:filename])
      ar = get_cache(File.join(dir, track[:filename]))
      ar = get_playlist(File.join(dir, track[:filename])) unless ar
      @playlist += ar
      if recursive_flag
        #dir_stack.push(track[:filename])
        stack_copy = Array.new(dir_stack)
        stack_copy.push(track[:filename])
        ar.each do |sel|
          if sel[:dir_flag] && sel[:filename] != "../"
            append(sel, true, stack_copy, true)
          end
        end
      end
    end
    @playlist = @playlist.select { |sel| !sel[:dir_flag] && !sel[:pl_flag]  }
    @@sound.set_tmp_playlist(@playlist, "right", dir)

    update_element_strings
    set_page
    update_element_positions
  end

  def set_playlist(fn)
    clear
    @playlist = YAML.load(File.open(fn))
    @@sound.set_tmp_playlist(@playlist, "right", "")
    update_element_strings
    set_page
    update_element_positions
  end

  def clear
    @playlist = Array.new
    if (@@sound.state == "playing" || @@sound.state == "paused") &&
        @@sound.side == "right"
      @@sound.stop_track
    end
    update_element_strings
    set_page
    update_element_positions
  end
end

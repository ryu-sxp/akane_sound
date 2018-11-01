class SectionDir < UpperSectionBase
  attr_accessor :focus_flag
  def initialize(x, y, w, h, col)
    @focus_flag = @@save_data[:focus_left]
    if @@debug_flag
      @dir = '/media/winhdd/music/'
      #@dir = '/media/winhdd/music/Unsorted/'
      #@dir = '/home/ryu/Music/Unsorted/'
      #@dir = @@config[:root_dir]
    else
      @dir = @@config[:root_dir]
    end
    @dir = @@save_data[:cur_dir] if @@save_data[:cur_dir]
    @dir_stack = Array.new
    @dir_stack.push @dir
    @dir_stack = @@save_data[:dir_stack] if @@save_data[:dir_stack]
    @tracks = 0
    @playlist = Array.new
    @playlist = set_playlist(@dir_stack.join(nil), false)
    @tracks_played = 0
    @playlist_state = nil
    @cache_flag = false
    @pointer = @@save_data[:pointer_left]
    @page = @@save_data[:page_left]
    @offset_left = 8
    @offset_right = 4
    @title = @dir
    super
  end

  def update
    super
    if @focus_flag
      if @@inp.refresh == 1
        @pointer = 0
        @playlist = set_playlist(@dir_stack.join(nil), true)
        update_element_strings
        set_page
        update_element_positions
      end
      if @@inp.accept == 1
        # play song :)
        if !@playlist[@pointer][:dir_flag] && !@playlist[@pointer][:pl_flag]
          @@sound.set_side("left")
          @@sound.stop_track
          @@sound.set_track(@pointer, true)
          @@sound.start_track
        end
        # switch directory
        if @playlist[@pointer][:dir_flag]
          if @playlist[@pointer][:filename] == '../'
            @dir_stack.pop
          else
            @dir_stack.push @playlist[@pointer][:filename]
          end
          @playlist = set_playlist(@dir_stack.join(nil), false)
          @pointer = 0
          @page = 1
          @title = @dir_stack.join(nil)
          @title = @@font.render_blended(@title, @txt_color)
          @title_rect =
            SDL2::Rect[8, @element_h/2-@title.h/2, @title.w, @title.h]
          update_element_strings
          set_page
          update_element_positions
        end
        # set playlist
        if @playlist[@pointer][:pl_flag]
        end
      end
      if @@inp.append == 1 || @@inp.append_r == 1
        if !@playlist[@pointer][:pl_flag]
          if @playlist[@pointer][:dir_flag]
            if @@inp.append_r == 1
              @@sec_pl.append(@playlist[@pointer], true, @dir_stack, true)
            else
              @@sec_pl.append(@playlist[@pointer], true, @dir_stack, false)
            end
          else
            @@sec_pl.append(@playlist[@pointer], false, @dir_stack, false)
          end
        end
      end
    end
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end

  #return: Array of Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir, refresh)
    set_status("Loading directory playlist from cache...")

    ar = get_cache(dir)
    if ar && !refresh
      set_status("Playlist loaded.")
    else
      ar = get_playlist(dir)
      set_status("Playlist set.")
    end
    @@sound.set_tmp_playlist(ar, "left", dir)
    


    #p ar.to_s if @@debug_flag
    return ar
  end

end

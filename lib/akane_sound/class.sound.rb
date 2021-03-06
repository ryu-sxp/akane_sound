class Sound < AkaneSound
  attr_accessor :volume, :track, :mode, :state, :tstmp_play_start,
    :tstmp_play_cur, :progress, :side
  def initialize
    @track = nil
    @track_data = nil
    @side = nil
    @pointer_left = nil
    @pointer_right = nil
    @state = "not playing"
    @tmp_playlist_left = nil
    @playlist_left = nil
    @playlist_left_bkp = nil
    @tmp_playlist_right = nil
    @progress = 0
    @playlist_right = nil
    @playlist_right_bkp = nil
    @tstmp_play_start = nil
    @tstmp_play_cur = nil
    @tstmp_pause_start = nil
    @total_pause = 0
    @volume = @@save_data[:volume]
    @play_dir = nil
    @play_dir_bkp = nil
    @tmp_dir = nil
    set_vol
    @mode = { next: @@save_data[:next], repeat: @@save_data[:repeat],
              shuffle: @@save_data[:shuffle] }
    @end = false
    @tracks_played = 0
  end

  def update
    now = SDL2.get_ticks
    case @state
    when "playing"
      @tstmp_play_cur = (now - @tstmp_play_start) - @total_pause
      @progress = Util.get_percentage(@tstmp_play_cur, @track_data[:duration])
      if @tstmp_play_cur >= @track_data[:duration]
        if @mode[:next]
          skip("next", 1)
        else
          if @mode[:repeat]
            case @side
            when "left"
              set_track(@pointer_left, false)
            when "right"
              set_track(@pointer_right, false)
            end
            start_track
          else
            stop_track
          end
        end
      end
    when "paused"
    when "not playing"
    when nil
    end
  end

  def skip(type, offset)
    stop_track
    return if @end
    case type
    when "next"

      # pointer correction
      case @side
      when "left"
        if @pointer_left+offset >= @playlist_left.length
          @end = true unless @mode[:repeat]
          @tracks_played = 0
          @pointer_left = 0
          offset = 0
        end
        unless @playlist_left[@pointer_left+offset][:index]
          skip("next", offset+1)
          return
        end
      when "right"
        if @pointer_right+offset >= @playlist_right.length
          @end = true unless @mode[:repeat]
          @tracks_played = 0
          @pointer_right = 0
          offset = 0
        end
        unless @playlist_right[@pointer_right+offset][:index]
          skip("next", offset+1)
          return
        end
      end

      # skip

      case @side
      when "left"
        set_track(@pointer_left+offset, false)
        @tracks_played += 1
        start_track
      when "right"
        set_track(@pointer_right+offset, false)
        @tracks_played += 1
        start_track
      end

    when "previous"
      
      # pointer correction
      case @side
      when "left"
        if @pointer_left-offset < 0
          @end = true unless @mode[:repeat]
          @pointer_left = @playlist_left.length-1
          offset = 0
        end
        unless @playlist_left[@pointer_left-offset][:index]
          skip("previous", offset+1)
          return
        end
      when "right"
        if @pointer_right-offset < 0
          @end = true unless @mode[:repeat]
          @pointer_right = @playlist_right.length-1
          offset = 0
        end
        unless @playlist_right[@pointer_right-offset][:index]
          skip("previous", offset+1)
          return
        end
      end

      return if @end

      # skip

      case @side
      when "left"
        set_track(@pointer_left-offset, false)
        start_track
      when "right"
        set_track(@pointer_right-offset, false)
        start_track
      end

    end
  end

  def set_track(pointer, setter)
    @end = false
    set_playlist(@side) if setter
    case @side
    when "left"
      if setter
        pointer = @playlist_left.index { |song| song[:index] == pointer }
      else
        pointer = @pointer_left if pointer >= @playlist_left.length
      end
      @pointer_left = pointer
      @track_data = @playlist_left[pointer]
      SDL2::Mixer.open(@track_data[:sample].to_i,
                       SDL2::Mixer::DEFAULT_FORMAT, 2, 512)
      set_vol
      @track = SDL2::Mixer::Music.load(@playlist_left[pointer][:path])
    when "right"
      if setter
        pointer = @playlist_right.index { |song| song[:index] == pointer }
      else
        pointer = @pointer_right if pointer >= @playlist_right.length
      end
      @pointer_right = pointer
      @track_data = @playlist_right[pointer]
      SDL2::Mixer.open(@track_data[:sample].to_i,
                       SDL2::Mixer::DEFAULT_FORMAT, 2, 512)
      set_vol
      @track = SDL2::Mixer::Music.load(@playlist_right[pointer][:path])
    end
    #todo restore_playlist if fails to load
  end

  def play_track
    if SDL2::Mixer::MusicChannel.play?
      if SDL2::Mixer::MusicChannel.pause?
        @total_pause += SDL2.get_ticks - @tstmp_pause_start
        @state = "playing"
        case @side
        when "left"
          set_status("[PLAY] #{@playlist_left[@pointer_left][:filename]}")
        when "right"
          set_status("[PLAY] #{@playlist_right[@pointer_right][:filename]}")
        end
        SDL2::Mixer::MusicChannel.resume
      else
        @tstmp_pause_start = SDL2.get_ticks
        @state = "paused"
        case @side
        when"left"
          set_status("[PAUSE] #{@playlist_left[@pointer_left][:filename]}")
        when "right"
          set_status("[PAUSE] #{@playlist_right[@pointer_right][:filename]}")
        end
        SDL2::Mixer::MusicChannel.pause
      end
    end
  end

  def stop_track
    if @track
      set_status("[]")
      SDL2::Mixer::MusicChannel.halt if SDL2::Mixer::MusicChannel.play?
      SDL2::Mixer.close
      @track = nil
      @track_data = nil
      @state = "not playing"
      @progress = 0
      case @side
      when "left"
        #@pointer_left = nil
      when "right"
        #@pointer_right = nil
      end

    end
  end

  def start_track
    @state = "playing"
    case @side
    when "left"
      set_status("[PLAY] #{@playlist_left[@pointer_left][:filename]}")
      @tstmp_play_start = SDL2.get_ticks
      @total_pause = 0
      SDL2::Mixer::MusicChannel.play(@track, 1)
    when "right"
      set_status("[PLAY] #{@playlist_right[@pointer_right][:filename]}")
      @tstmp_play_start = SDL2.get_ticks
      @total_pause = 0
      SDL2::Mixer::MusicChannel.play(@track, 1)
    end
  end

  def get_play_id(side)
    case side
    when "left"
      return @pointer_left
    when "right"
      return @pointer_right
    end
  end

  def get_track
    case @side
    when "left"
      return @playlist_left[@pointer_left]
    when "right"
      return @playlist_right[@pointer_right]
    end

  end

  def get_play_path(side)
    #return "" if side != @side
    if @state == "playing" || @state == "paused"
      case side
      when "left"
        if @side == "left"
          return @track_data[:path]
          #return @playlist_left[@pointer_left][:path]
        else
          return ""
        end
      when "right"
        if @side == "right"
          return @track_data[:filename]
          #return @playlist_right[@pointer_right][:filename]
        else
          return ""
        end
      end
    else
      return ""
    end
  end

  def set_side(side)
    @side = side
  end

  def toggle_shuffle
    if @mode[:shuffle]
      @mode[:shuffle] = false
      restore_playlist("left") if @playlist_left
      restore_playlist("right") if @playlist_right
    else
      @mode[:shuffle] = true
      @playlist_left.shuffle! if @playlist_left
      @playlist_right.shuffle! if @playlist_right
    end
  end

  def toggle_repeat
    if @mode[:repeat]
      @mode[:repeat] = false
    else
      @mode[:repeat] = true
    end
  end
  def toggle_next
    if @mode[:next]
      @mode[:next] = false
    else
      @mode[:next] = true
    end
  end

  def set_vol
    SDL2::Mixer::MusicChannel.volume = @volume
  end

  def set_tmp_playlist(pl, side, dir)
    case side
    when "left"
      i = 0
      pl = pl.map do |item|
        if !item[:dir_flag] && !item[:pl_flag]
          #item[:path] = File.join(dir, item[:filename])
          item[:index] = i
        else
          item[:index] = nil
        end
        i += 1
        item
      end
      @tmp_playlist_left = pl
      @tmp_dir = dir
    when "right"
      i = 0
      pl = pl.map do |item|
        item[:index] = i
        i += 1
        item
      end
      @tmp_playlist_right = pl
      @tmp_dir = dir
      set_playlist("right")
    end
  end

  private

  def set_playlist(side)
    case side
    when "left"
      @playlist_left = @tmp_playlist_left
      @playlist_left_bkp = Array.new(@playlist_left)
      
      @play_dir_bkp = @play_dir
      @play_dir = @tmp_dir
      if @mode[:shuffle]
        @playlist_left.shuffle!
      end
    when "right"
      @playlist_right = @tmp_playlist_right
      @playlist_right_bkp = Array.new(@playlist_right)
      if @mode[:shuffle]
        @playlist_right.shuffle!
      end
    end
  end

  def restore_playlist(side)
    case side
    when "left"
      @playlist_left = Array.new(@playlist_left_bkp)
      @play_dir = @play_dir_bkp
    when "right"
      @playlist_right = Array.new(@playlist_right_bkp)
    end
  end

end

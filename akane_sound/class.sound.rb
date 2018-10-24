class Sound < Akane
  attr_accessor :volume, :track, :mode, :state
  def initialize
    @track = nil
    @side = nil
    @pointer_left = nil
    @pointer_right = nil
    @state = "not playing"
    @tmp_playlist_left = nil
    @playlist_left = nil
    @playlist_left_bkp = nil
    @tmp_playlist_right = nil
    @playlist_right = nil
    @playlist_right_bkp = nil
    @tstmp_play_start = nil
    @volume = @@save_data[:volume]
    set_vol
    @mode = { next: @@save_data[:next], repeat: @@save_data[:repeat],
              shuffle: @@save_data[:shuffle] }
  end

  def set_track(pointer)
    set_playlist(@side)
    case @side
    when "left"
      @pointer_left = pointer
      @track = SDL2::Mixer::Music.load(@playlist_left[pointer][:path])
    when "right"
    end
    #todo restore_playlist if fails to load
  end

  def play_track
    if SDL2::Mixer::MusicChannel.play?
      if SDL2::Mixer::MusicChannel.pause?
        SDL2::Mixer::MusicChannel.resume
      else
        SDL2::Mixer::MusicChannel.pause
      end
    end
  end

  def stop_track
    if @track
      SDL2::Mixer::MusicChannel.halt if SDL2::Mixer::MusicChannel.play?
      @track = nil
      @state = "not playing"
      case @side
      when "left"
        @pointer_left = nil
      when "right"
        @pointer_right = nil
      end

    end
  end

  def start_track
    case @side
    when "left"
      set_status("Now playing #{@playlist_left[@pointer_left][:filename]}")
      set_status("Now playing")
      SDL2::Mixer::MusicChannel.play(@track, 1)
    when "right"
    end
  end

  def get_play_id(side)
    case side
    when "left"
    when "right"
    end
  end

  def set_side(side)
    @side = side
  end

  def toggle_shuffle
    if @mode[:shuffle]
      @mode[:shuffle] = false
    else
      @mode[:shuffle] = true
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
      pl = pl.map do |item|
        if !item[:dir_flag] && !item[:pl_flag]
          item[:path] = File.join(dir, item[:filename])
        end
        item
      end
      @tmp_playlist_left = pl
    when "right"
    end
  end

  private

  def set_playlist(side)
    case side
    when "left"
      @playlist_left_bkp = @playlist_left
      @playlist_left = @tmp_playlist_left
    when "right"
      @playlist_right_bkp = @playlist_right
      @playlist_right = @tmp_playlist_right
    end
  end

  def restore_playlist(side)
    case side
    when "left"
      @playlist_left = @playlist_left_bkp
    when "right"
      @playlist_right = @playlist_right_bkp
    end
  end

end

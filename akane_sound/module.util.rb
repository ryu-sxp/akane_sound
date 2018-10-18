module Util
  def Util.binary_copy(dst_dir, filename)
    file = File.open("./akane_sound/#{filename}", 'rb')
    contents = file.read
    file.close
    File.open(dst_dir+filename, 'wb') { |file| file.write(contents) }
  end
  def Util.p(str)
    if str.class == String
      SDL2::MessageBox.show_simple_box(SDL2::MessageBox::ERROR, "Alert",
                                       str, nil)
    end
  end
  def Util.to_col_ar(hash)
    ar = Array.new
    hash.each { |key, val| ar.push val }
    ar.pop 1
    ar
  end
  def Util.ms_to_time_str(ms)
    sec = ms.to_f/1000.0
    min = sec/60.0
    sec = ((min%60.0).round(2)*10).to_i
    if min < 10
      min = "0#{min.floor}"
    else
      min = min.floor
    end
    sec = '00' if sec == 100
    "#{min}:#{sec}"
  end
end

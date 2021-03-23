repl do

    def s
        return $game.s
    end

    def schedule_string start_at, string

        result = []
        string.each_char.with_index do |s, i|
            result << {s: s, i: start_at + i * 60} 
        end
        return result
    end
        puts schedule_string 60, "Scrolling text string"
  end
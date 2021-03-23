def schedule_string start_at, string
  string.each_char.with_index.map do |s, i|
    { s: s, i: start_at + i * 6 } 
  end
end

def string_to_render tick, schedule_def
  schedule_def.find_all { |d| d[:i] <= tick }
              .map { |d| d[:s] }
              .join("")
end 

def tick args
  args.state.dialog ||= []
  if args.inputs.mouse.click
    args.state.dialog = schedule_string args.state.tick_count, "this is a long string"
  end
  args.outputs.labels << [30, 30.from_top, string_to_render(args.state.tick_count, args.state.dialog)]
end
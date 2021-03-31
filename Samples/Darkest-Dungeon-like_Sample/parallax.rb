#handle scrolling the background 
def scrolling_background at, path, rate, y = 0
    [
        [   0 - at.*(rate) % 1440, y, 1440, 720, path],
        [1440 - at.*(rate) % 1440, y, 1440, 720, path]
    ]
end

#render the background with parallax
def render_background args
    args.outputs.sprites << [0, 0, 1280, 720, 'sprites/added/background03.png']

    scroll_point_at   = args.state.tick_count
    scroll_point_at ||= 0

    args.outputs.sprites << scrolling_background(scroll_point_at, 'sprites/added/parallax_back03.png',   0.30)
    args.outputs.sprites << scrolling_background(scroll_point_at, 'sprites/added/parallax_mid03.png', 0.50)
    #args.outputs.sprites << scrolling_background(scroll_point_at, 'sprites/added/parallax_front02.png',  1.00, -80)
end
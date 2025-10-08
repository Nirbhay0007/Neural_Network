using Mousetrap

# Game state
clicks = 0
game_active = false
label = Label("Click the button to start!")

function start_game()
    global clicks, game_active
    clicks = 0
    game_active = true
    label.text = "Go! Click as fast as you can!"
    @async begin
        sleep(10)
        game_active = false
        label.text = "Time's up! You clicked $clicks times."
    end
end

function on_click()
    global clicks
    if game_active
        clicks += 1
        label.text = "Clicks: $clicks"
    end
end

main() do app::Application
    window = Window(app, title="Click Challenge", width=300, height=200)
    button = Button("Start Game", on_clicked=start_game)
    clicker = Button("Click Me!", on_clicked=on_click)
    layout = Box(:v)
    push!(layout, label)
    push!(layout, button)
    push!(layout, clicker)
    set_child!(window, layout)
    present!(window)
end
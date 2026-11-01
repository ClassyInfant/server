Talk.vert_menu(player_id, bot_name, cfg, {
  options = {
    count = 40,
    prefix = "Red Option ",
    pad = 2,
    exit_text = "Exit",
    exit_id = "exit",
  },

  texts = {
    open_question = "Do you wanna check out the vertical menu?",
    intro_text    = "Pick whatever you like.",
    decline_open  = "No worries. Maybe next time.",

    confirm_format     = 'Are you sure you want "%s"?',
    post_select_format = 'You got "%s".',

    after_yes    = "Anything else?",
    after_no     = "All good?",
    exit_goodbye = "Thanks for stopping by!",
  },

  sfx    = "card_desc",
  layout = "prog_prompt",
  flow   = "prog_prompt",
})

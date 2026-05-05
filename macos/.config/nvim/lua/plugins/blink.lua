return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    completion = {
      trigger = {
        show_on_keyword = false,
        show_on_trigger_character = false,
        show_on_backspace_after_accept = false,
        show_on_backspace_after_insert_enter = false,
      },
      list = {
        selection = {
          preselect = false,
        },
      },
    },
  },
}

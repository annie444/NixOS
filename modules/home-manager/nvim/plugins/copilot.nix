{
  copilot-lua = {
    enable = true;
    suggestion.enabled = false;
    panel.enabled = false;
  };
  copilot-chat = {
    enable = true;
    settings = {
      answer_header = "## Copilot ";
      auto_follow_cursor = false;
      error_header = "## Error ";
      mappings = {
        close = {
          insert = "<C-c>";
          normal = "q";
        };
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.";
          insert = "<Tab>";
        };
      };
      prompts = {
        Explain = "Please explain how the following code works.";
        Review = "Please review the following code and provide suggestions for improvement.";
        Tests = "Please explain how the selected code works, then generate unit tests for it.";
      };
      question_header = "## User ";
      show_help = false;
    };
  };
}

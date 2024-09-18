{
  programs.nixvim.plugins.lspsaga = {
    enable = true;

    codeAction = {
      numShortcut = true;
      keys = {
        quit = ";";
        exec = "<CR>";
      };
    };

    scrollPreview = {
      scrollDown = "<C-f>";
      scrollUp = "<C-b>";
    };

    lightbulb = {
      enable = false;
      sign = true;
      signPriority = 40;
      virtualText = true;
    };

    rename.keys = {
      quit = ";";
      exec = "<CR>";
      select = "x";
    };

    finder.keys = {
      toggleOrOpen = [
        "o"
        "<CR>"
      ];
      vsplit = "s";
      split = "i";
      tabe = "t";
      quit = [
        ";"
        "<ESC>"
      ];
    };

    diagnostic = {
      jumpNumShortcut = true;
      showCodeAction = true;
      textHlFollow = false;
      borderFollow = true;
      keys = {
        execAction = "o";
        quit = ";";
      };
    };

    symbolInWinbar = {
      enable = false;
      separator = '' '';
      hideKeyword = true;
      showFile = true;
      folderLevel = 2;
    };

    definition.keys = {
      edit = "<C-c>o";
      vsplit = "<C-c>v";
      split = "<C-c>i";
      tabe = "<C-c>t";
      quit = ";";
      close = "<Esc>";
    };

    ui = {
      border = "rounded";
      expand = "";
      codeAction = "󱧣 ";
      kind = {};
    };

    outline = {
      winPosition = "right";
      winWidth = 30;
      detail = true;
      autoPreview = true;
      autoClose = true;
      keys = {
        jump = "o";
        quit = ";";
      };
    };

    callhierarchy = {
      layout = "float";
      keys = {
        edit = "e";
        vsplit = "s";
        split = "i";
        tabe = "t";
        quit = ";";
      };
    };
  };
}

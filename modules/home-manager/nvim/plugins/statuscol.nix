{
  programs.nixvim.plugins.statuscol = {
    enable = true;
    settings = {
      relculright = true;
      segments = [
        {
          text = [
            {
              __raw = ''require("statuscol.builtin").foldfunc'';
            }
            " "
          ];
          click = "v:lua.ScFa";
        }
        {
          text = [
            {
              __raw = ''require("statuscol.builtin").lnumfunc'';
            }
            " "
          ];
          click = "v:lua.ScLa";
        }
        {
          text = ["%s"];
          click = "v:lua.ScSa";
        }
      ];
    };
  };
}

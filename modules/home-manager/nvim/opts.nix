{
  programs.nixvim.opts = {
    backup = false;
    conceallevel = 2;
    fileencoding = "utf-8";
    hidden = true;
    ignorecase = true;
    mouse = "a";
    pumheight = 8;
    pumblend = 10;
    showmode = false;
    smartcase = true;
    smartindent = true;
    splitbelow = true;
    splitright = true;
    swapfile = true;
    timeoutlen = 500;
    undofile = true;
    updatetime = 100;
    writebackup = false;
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    cursorline = true;
    number = true;
    relativenumber = true;
    numberwidth = 4;
    signcolumn = "yes";
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    lazyredraw = false;
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = 99;
    foldmethod = "indent";
    fillchars = {
      eob = " ";
      fold = " ";
      foldopen = "";
      foldsep = " ";
      foldclose = "";
      lastline = " ";
    };
    foldcolumn = "1";
    ruler = false;
  };
}

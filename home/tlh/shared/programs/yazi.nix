{
  programs.yazi = {
    enable = true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        ratio = [1 5 2];
        sort_by = "alphabetical";
        linemode = "size";
        sort_dir_first = true;
        sort_reverse = false;
      };
    };
    theme = {
      icon = {
        rules = [];
      };
      status = {
        separator_open = "";
        separator_close = "";
      };
    };
  };
}

{...}: {
  programs = {
    bemenu = {
      enable = true;
      settings = {
        list = 6;
        center = true;
        width-factor = 0.3;
        border = 2;
        border-radius = 6;
        prompt = "";
        ignorecase = true;
        single-instance = true;
        wrap = true;
      };
    };

    mako = {
      enable = true;
      defaultTimeout = 20 * 1000;
      borderRadius = 6;
    };
  };
}

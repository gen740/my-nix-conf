{ fetchurl }: {
  c = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.24.1.tar.gz";
      hash = "sha256-Jd1Ls97HcHaaQH4PyAP0JM4CxJSlbOlf7cUlMW3Pm0g=";
    };
  };
  cpp = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-cpp/archive/v0.23.4.tar.gz";
      hash = "sha256-eixVr+MCj0EF8ldi6ljMFlN9H1odzZzKkEELPNXUYFE=";
    };
  };
  typescript = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-typescript/archive/v0.23.2.tar.gz";
      hash = "sha256-LEznEa6NEhijsviZGJKYFZ1nKHC1s03/XZN77S8+iYM=";
    };
    location = "typescript";
  };
  tsx = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-typescript/archive/v0.23.2.tar.gz";
      hash = "sha256-LEznEa6NEhijsviZGJKYFZ1nKHC1s03/XZN77S8+iYM=";
    };
    location = "tsx";
    language = "typescriptreact";
  };
  javascript = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-javascript/archive/v0.23.1.tar.gz";
      hash = "sha256-/FuPWkkabbM8pIVLBEuJNj/3YV9CkZd0Z/UsG5KgwDI=";
    };
  };
  python = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-python/archive/v0.23.6.tar.gz";
      hash = "sha256-YwoPRezNm2mmage/R9FWjpapyFWi8w4JIcivcSHor5Y=";
    };
  };
  json = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-json/archive/v0.24.8.tar.gz";
      hash = "sha256-rPboNiRX6Bnti2E/Ktmg4bYhp3VWwpbzq+pY94gKkhM=";
    };
  };
  css = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-css/archive/v0.23.2.tar.gz";
      hash = "sha256-XUQuiwTYx0NgMXL7AmZK4rQE8496hx2XzyyJwe7fglE=";
    };
  };
  html = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-html/archive/v0.23.2.tar.gz";
      hash = "sha256-IfpPLU3LiQ7xLQn0l5oAB4FPZ/HHKUqbF7AQignkXvc=";
    };
  };
  lua = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.4.0.tar.gz";
      hash = "sha256-sJd6ztSmO7dfJnJXh+BHuPX0oJJxLIQOpwcHZdQElVk=";
    };
  };
  vim = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v0.7.0.tar.gz";
      hash = "sha256-ROq8MRJ8T+rNoZ8qBaV4gnISj/VhzgEJOot6U6rcx7I=";
    };
  };
  vimdoc = {
    src = fetchurl {
      url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v4.0.0.tar.gz";
      hash = "sha256-gJZ5TA8JCy10t7/5RUisG+MoW5Kex0+Dm9mz/09Mags=";
    };
  };
  query = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.6.2.tar.gz";
      hash = "sha256-kGguEo0Ej78qKhftypR9tx4yb6Cz26QTbgQeCWU4tOs=";
    };
  };
  markdown = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.0.tar.gz";
      hash = "sha256-FMLJSMzw6bYG7sObCShsWd3fKDB4SfcbfOKx0e8Gk34=";
    };
    location = "tree-sitter-markdown";
  };
  markdown_inline = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.0.tar.gz";
      hash = "sha256-FMLJSMzw6bYG7sObCShsWd3fKDB4SfcbfOKx0e8Gk34=";
    };
    location = "tree-sitter-markdown-inline";
    language = "markdown_inline";
  };
}

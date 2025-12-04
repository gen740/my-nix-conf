{ fetchurl }:
{
  bash = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-bash/archive/v0.25.1.tar.gz";
      hash = "sha256-LnhadhIltsQzQQ75x7Y8+wpOg6NaGeDyrsFAtCwGtS0=";
    };
  };
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
  csv = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-csv/archive/v1.2.0.tar.gz";
      hash = "sha256-LQsDd9D3swXzBaEfUIehVt5T/eifQIYadVguCs94qzg=";
    };
    location = "csv";
  };
  tsv = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-csv/archive/v1.2.0.tar.gz";
      hash = "sha256-LQsDd9D3swXzBaEfUIehVt5T/eifQIYadVguCs94qzg=";
    };
    location = "tsv";
    language = "tsv";
  };
  diff = {
    src = fetchurl {
      url = "https://github.com/the-mikedavis/tree-sitter-diff/archive/v0.1.0.tar.gz";
      hash = "sha256-DQQUrIc8MxVLRY9NYv4JaqlmOS/0FpIKCMVinHZartM=";
    };
  };
  dockerfile = {
    src = fetchurl {
      url = "https://github.com/camdencheek/tree-sitter-dockerfile/archive/v0.2.0.tar.gz";
      hash = "sha256-jL31CDjMVehBqpWFoaCeW4xBRUrjDOCpOnvXGtsUCBg=";
    };
  };
  go = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-go/archive/v0.25.0.tar.gz";
      hash = "sha256-LcJBuXhyxTGV4BuGVCtBGjwaYgHZyUbHjVxgwGO7oe8=";
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
      url = "https://github.com/tree-sitter/tree-sitter-javascript/archive/v0.25.0.tar.gz";
      hash = "sha256-lxL8KD09wB2ZbSC2OSFDRF0Fhnp6rXb91yOCRGhCi4Y=";
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
      url = "https://github.com/tree-sitter/tree-sitter-css/archive/v0.25.0.tar.gz";
      hash = "sha256-A5ZTRNjAQ13FT7RbKBV4Qgu324uZ30005+dBBaJ0y3k=";
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
      url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.8.0.tar.gz";
      hash = "sha256-wrI7mlTP/MmZ3tSl05SdrzOL67eUXeziKfgyMy5uan0=";
    };
  };
  make = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-make/archive/v1.1.1.tar.gz";
      hash = "sha256-Ma/8oGBBYjz6X2pyjLPw8qjrf9AWB+GiaB6h8xg2chE=";
    };
  };
  markdown = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.1.tar.gz";
      hash = "sha256-rK/+WlS0iQ8aCCrWswm2ALeS6T/G7ikD0CIlfVsV4hY=";
    };
    location = "tree-sitter-markdown";
  };
  markdown_inline = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.1.tar.gz";
      hash = "sha256-rK/+WlS0iQ8aCCrWswm2ALeS6T/G7ikD0CIlfVsV4hY=";
    };
    location = "tree-sitter-markdown-inline";
    language = "markdown_inline";
  };
  python = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-python/archive/v0.25.0.tar.gz";
      hash = "sha256-RgmjZlpiDhF6z3lf8BuelliA+BdF8oehYzb0yobPJww=";
    };
  };
  objc = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-objc/archive/v3.0.2.tar.gz";
      hash = "sha256-GG0D7LmuQc3oXvvig9y+Z8J3//dmqUb379bVH+5yNw0=";
    };
  };
  ruby = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-ruby/archive/v0.23.1.tar.gz";
      hash = "sha256-5+SVd93B8t6OQtQjU7R34zjBW7uVslWOEj3cE9iHifA=";
    };
  };
  rust = {
    src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-rust/archive/v0.24.0.tar.gz";
      hash = "sha256-ecnrBa9OvM6MQHYPxlQF4CVeLVYnAjFLgTpd7BJzuaI=";
    };
  };
  tmux = {
    src = fetchurl {
      url = "https://github.com/Freed-Wu/tree-sitter-tmux/archive/0.0.4.tar.gz";
      hash = "sha256-clmaLr8iIZIY9+P2y+uOawfQUDyBmX2r5Hninfw7vYU=";
    };
  };
  toml = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/v0.7.0.tar.gz";
      hash = "sha256-fVKn1IhPMHqryHKGfGkITZRFbYr83GOwpzAxqLKQNtw=";
    };
  };
  typst = {
    src = fetchurl {
      url = "https://github.com/uben0/tree-sitter-typst/archive/v0.11.0.tar.gz";
      hash = "sha256-0ZW0IOLxQ8j1lcNH+7qI9kDf56IowEe3qi4zlOk4OcU=";
    };
  };
  vhdl = {
    src = fetchurl {
      url = "https://github.com/jpt13653903/tree-sitter-vhdl/archive/v1.3.1.tar.gz";
      hash = "sha256-ZdNl5Bj+INu1xZ8QEJVb2teJGXnIQKIarWLINvoe1Ik=";
    };
  };
  yaml = {
    src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-yaml/archive/v0.7.2.tar.gz";
      hash = "sha256-rq/1cxu4tmxwVMiu0zzV7epfTNKscWVPP2wrogc9j6w=";
    };
  };
}

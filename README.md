# pandoc.kak

[pandoc] integration for [kakoune]

**pandoc.kak** provides a simple mean to use [pandoc] to convert
documents written in markdown (e.g. [Pandoc's markdown variant]), LaTex,
HTML and other formats.

**pandoc.kak** provides a way to preview markdown documents as pdf using
[zathura].

**pandoc.kak** provides syntax highlighting for latex at this point (experimental).

## Installation

Add `pandoc.kak` to the plugin manager of your choise, put it into your
autoload or source it manually.

Then reload Kakoune config or restart Kakoune and run `:plug-install`.

### Using [andreyorst/plug.kak]

``` kak
plug "basbebe/pandoc.kak" %{
    # your config
}
```

Then reload Kakoune config or restart Kakoune and run `:plug-install`.

### Otherwise

``` kak
hook global WinSetOption filetype=(asciidoc|fountain|html|latex|markdown) %{
    require-module pandoc
}
```

## Usage

**pandoc.kak** provides the following commands:

-   `pandoc` -- Converts the current document with the pandoc options
    given as arguments. If no arguments are given, a pdf file will be
    produced.
-   `pandoc-preview` -- Creates a temporary pdf file next to the current
    buffer and opens it with zathura. Every time the document is saved,
    the preview is being updated. Takes pandoc options as arguments.
-   `pandoc-beautify` -- Beautifies the current buffer using Pandoc.
    Assumes buffer is markdown text.

Pandoc uses `pandoc-options` to let you specify custom pandoc options
for the current buffer (or globally). Those options will **always** be
applied.\
Example for an entry in `kakrc`:

``` kak
set-option global pandoc_options "-d default"
```

### Example config

``` kak
hook global WinSetOption filetype=(asciidoc|fountain|html|latex|markdown) %{
    require-module pandoc
    set-option global pandoc_options '-d default'
}
```

@@ Similar projects

-   [kakoune-livedown][]: Live preview markdown files as HTML in your
    browser

## Contributing

Pull requests are welcome.

## License

[The Unlicense]

------------------------------------------------------------------------

Inspired by [vim-pandoc]

  [pandoc]: https://pandoc.org/
  [kakoune]: https://kakoune.org/
  [Pandoc's markdown variant]: https://pandoc.org/MANUAL.html#pandocs-markdown
  [zathura]: https://pwmt.org/projects/zathura/
  [andreyorst/plug.kak]: https://github.com/andreyorst/plug.kak
  [kakoune-livedown]: https://github.com/Delapouite/kakoune-livedown
  [The Unlicense]: https://choosealicense.com/licenses/unlicense/
  [vim-pandoc]: https://github.com/vim-pandoc/vim-pandoc

# pandoc.kak

[pandoc][] integration for [kakoune][]

**pandoc.kak** provides a simple mean to use [pandoc][] to convert documents written in markdown (e.g. [Pandoc's markdown variant](https://pandoc.org/MANUAL.html#pandocs-markdown)), LaTex, HTML and other formats.

**pandoc.kak** provides a way to preview markdown documents as pdf using [zathura][].

**pandoc.kak** does **not** provide additional syntax highlighting for pandoc markdown.

[kakoune]: https://kakoune.org/
[pandoc]: https://pandoc.org/
[zathura]: https://pwmt.org/projects/zathura/

## Installation

The easiest way to install **pandoc.kak** is by using [plug.kak][].  
Add this to your `kakrc`:
```
plug "basbebe/pandoc.kak"
```
Then reload Kakoune config or restart Kakoune and run `:plug-install`.

[plug.kak]: https://github.com/robertmeta/plug.kak

## Usage

**pandoc.kak** provides the following commands:

* `pandoc-preview-enable` - Creates a temporary pdf file next to the current buffer and opens it with zathura. Every time the document is saved, the preview is being updated.
* `pandoc-preview-disable` - Closes the preview and removes the remporary pdf.
* `pandoc-convert` - Converts the current document to the file given as argument.

pandoc uses `pandoc-commands` to let you specify custom pandoc arguments for the current buffer (or globally).  
Example for an entry in `kakrc`:
```
set-option global pandoc_commands "-d default"
```

## Contributing

This is very much a work in progress and by no means a bug-free, fully functioning plugin with all features imaginable.
Contributions of any kind are welcome and appreciated.

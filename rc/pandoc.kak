declare-option -docstring "set default Pandoc options" str pandoc_options
declare-option -hidden str pandoc_preview_file
declare-option -hidden int pandoc_preview_pid

provide-module pandoc %{
    # convert with  pandoc
    define-command -docstring "pandoc [options]: convert current buffer file
    with pandoc if no options are given, outputs current file as pdf

    current options: %opt{pandoc_options}

    Example:
        pandoc -d defaultfile.yaml -o page.html

    (uses pandoc_options)" \
    pandoc -params .. %{
        evaluate-commands %sh{
            if [ -z "$1" ]; then
                params="-o ${kak_buffile%.*}.pdf"
            else
                params="$@"
            fi
            pandoc $kak_buffile $kak_opt_pandoc_options $params
        }
    }

    # pandoc preview
    define-command -docstring "activate Pandoc pdf Preview window
    (uses <pandoc_options>)" \
    pandoc-preview %{
        evaluate-commands %sh{
            # create preview file in tmp folder
            prevfile=$(mktemp -u -t pandoc_preview_"${kak_bufname%.*}".XXXXXX).pdf
            # convert with pandoc and open preview
            pandoc $kak_buffile $kak_opt_pandoc_options -o $prevfile && \
            printf "%s\n" "set-option buffer pandoc_preview_file $prevfile" && \
            printf "%s\n" "pandoc-preview-show"
        }

        # refresh preview on safe
        hook -group pandoc buffer BufWritePost .* %{
            evaluate-commands %sh{
                # check if preview is still open, refresh
                if kill -0 "$kak_opt_pandoc_preview_pid" ; then
                    pandoc $kak_buffile $kak_opt_pandoc_options -o $kak_opt_pandoc_preview_file
                else
                    printf "%s\n" "pandoc-preview-disable"
                fi
            }
        }

        # close preview window on buffer close
        hook -group pandoc buffer BufClose .* %{
            pandoc-kill-preview
        }
    }

    # show zathura window
    define-command -hidden \
    pandoc-preview-show %{
        set-option buffer pandoc_preview_pid %sh{
            kill -0 "$kak_opt_pandoc_preview_pid" || \
            [ -n "$kak_opt_pandoc_preview_pid" ] && \
            { zathura "$kak_opt_pandoc_preview_file" > /dev/null 2>&1 & }
            printf "%d\n" $!
        }
    }

    # remove everything related to preview
    define-command -hidden \
    pandoc-preview-disable %{
        remove-hooks buffer pandoc
        pandoc-kill-preview
        unset-option buffer pandoc_preview_file
        unset-option buffer pandoc_preview_pid
    }

    # kill preview window
    define-command -hidden \
    pandoc-kill-preview %{
        evaluate-commands %sh{
            kill -0 "$kak_opt_pandoc_preview_pid" && \
            kill "$kak_opt_pandoc_preview_pid"
            rm "$kak_opt_pandoc_preview_file"
        }
    }

    define-command -docstring "beautify current buffer using pandoc
    assumes markdown input" \
    pandoc-beautify %{
        exec -draft '%<|>pandoc -f markdown -t markdown -s -Vheader-includes=""<ret>'
    }
}

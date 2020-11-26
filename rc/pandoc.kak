declare-option -docstring "set default Pandoc options" str pandoc_options
declare-option -hidden str pandoc_preview_file
declare-option -hidden str pandoc_preview_pid

define-command -docstring "activate Pandoc pdf Preview window
(uses <pandoc_options>)" \
pandoc-preview %{
    evaluate-commands %sh{
        prevfile="${kak_buffile%.*}_pandoc_prev.pdf"
        printf "%s\n" "set-option buffer pandoc_preview_file ${prevfile}"
        printf "%s\n" "pandoc -o %opt{pandoc_preview_file}" &&
        printf "%s\n" "pandoc-preview-show"
    }

    hook -group pandoc buffer BufWritePost .* %{
        evaluate-commands %sh{
            kill -0 ${kak_opt_pandoc_preview_pid} && \
            printf "%s\n" "pandoc -o %opt{pandoc_preview_file}" || \
            printf "%s\n" "pandoc-preview-disable"
        }
    }

    hook -group pandoc buffer BufClose .* %{
        pandoc-kill-preview 
    }
}

define-command -hidden \
pandoc-preview-show %{
    evaluate-commands %sh{
        [ -n "${kak_opt_pandoc_preview_pid}" ] && \
        kill -0 ${kak_opt_pandoc_preview_pid} || \
        ( { zathura ${kak_opt_pandoc_preview_file} & } </dev/null >/dev/null 2>&1 ; \
        printf "%s\n" "set-option buffer pandoc_preview_pid ${!}" )
    }
}

define-command -hidden \
pandoc-preview-disable %{
    remove-hooks buffer pandoc
    pandoc-kill-preview
    unset-option buffer pandoc_preview_file
    unset-option buffer pandoc_preview_pid
}

define-command -hidden \
pandoc-kill-preview %{
    evaluate-commands %sh{
        kill -0 ${kak_opt_pandoc_preview_pid} && \
        kill $kak_opt_pandoc_preview_pid
        rm ${kak_opt_pandoc_preview_file}
    }
}

define-command -docstring "pandoc [<options>]: convert current file with pandoc
if no options are given, outputs current file as pdf

Example:
    pandoc -d defaultfile.yaml -o page.html
    
(uses <pandoc_options>" \
pandoc -params .. %{
    evaluate-commands %sh{
        if [ -z "$1" ]
            then
            options="-o ${kak_buffile%.*}.pdf"
        else
            options="${@}"
        fi
        pandoc ${kak_buffile} ${kak_opt_pandoc_options} ${options}
    }
}

define-command -docstring "beautify current buffer using pandoc
assumes markdown input" \
pandoc-beautify %{
    exec -draft '%<|>pandoc -f markdown -t markdown -s<ret>'
}

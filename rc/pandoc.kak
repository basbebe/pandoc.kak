declare-option -docstring "set Pandoc default file" str pandoc_commands ""
declare-option -hidden str pandoc_preview_file ""
declare-option -hidden str pandoc_preview_pid ""

define-command -docstring "activate Pandoc Preview window" \
pandoc-preview-enable %{
    evaluate-commands %sh{
        prevfile="${kak_buffile%.*}_pandoc_prev.pdf"
        printf "%s\n" "set-option buffer pandoc_preview_file ${prevfile}"
    }

    pandoc-convert %opt{pandoc_preview_file}
    pandoc-preview-show

    hook -group pandoc buffer BufWritePost .* %{
        pandoc-convert %opt{pandoc_preview_file}
        pandoc-preview-show
    }

    hook -group pandoc buffer BufClose .* %{
        pandoc-kill-preview 
    }
}

define-command -hidden \
pandoc-preview-show %{
    evaluate-commands %sh{
        kill -0 ${kak_opt_pandoc_preview_pid} || \
        ( { zathura ${kak_opt_pandoc_preview_file} & } </dev/null >/dev/null 2>&1 ; \
        printf "%s\n" "set-option buffer pandoc_preview_pid ${!}" )
    }
}

define-command -docstring "deactivate Pandoc Preview window" \
pandoc-preview-disable %{
    remove-hooks buffer pandoc
    pandoc-kill-preview
}

define-command -hidden \
pandoc-kill-preview %{
    evaluate-commands %sh{
        kill $kak_opt_pandoc_preview_pid
        rm ${kak_opt_pandoc_preview_file}
    }
}

define-command -docstring "convert current buffer with pandoc" \
pandoc-convert -params ..2 %{
    evaluate-commands %sh{
        if [ -z "$1" ]
            then
            outputfile="${kak_buffile%.*}.pdf"
        else
            outputfile="${1}"
        fi
        pandoc ${kak_buffile} ${kak_opt_pandoc_commands} ${2} -o ${outputfile}
    }
}

define-command -docstring "beautify pandoc markdown" \
pandoc-beautify %{
    exec -draft '%<|>pandoc -f markdown -t markdown -s<ret>'
}

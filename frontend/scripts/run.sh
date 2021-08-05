#!/bin/bash

# Change the value of options to whatever you want to use.
options=("serve" "proxy")

select_option() {
    # little helpers for terminal print control and key input
    ESC=

    cursor_blink_on() {
        printf '%s' "[?25h"
    }

    cursor_blink_off() {
        printf '%s' "[?25l"
    }

    cursor_to() {
        printf '%s' "[;1H"
    }

    print_option() {
        printf '   %s ' ""
    }

    print_selected() {
        printf '  %s' "[7m  [27m"
    }

    get_cursor_row() {
        IFS=';' read -sdR -p $'\E[6n' ROW COL
        printf '%s' 
    }

    key_input() {
        read -s -n3 key 2>/dev/null >&2
        if [[  = [A ]]; then
            echo up
        fi
        if [[  = [B ]]; then
            echo down
        fi
        if [[  = "" ]]; then
            echo enter
        fi
    }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do
        printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=
    local startrow=0

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to 0
            if [[  ==  ]]; then
                print_selected ""
            else
                print_option ""
            fi
            ((idx++))
        done

        # user key control
        case  in
        enter) break ;;
        up)
            ((selected--))
            if (( < 0)); then selected=-1; fi
            ;;
        down)
            ((selected++))
            if ((selected > 0)); then selected=0; fi
            ;;
        esac
    done

    # cursor position back to normal
    cursor_to 
    printf "\n"
    cursor_blink_on

    return ""
}

select_option ""
choice=127

index=
value=

case  in
serve)
    echo "Running with ng serve"
    ng serve --port 4200
    break
    ;;
proxy)
    echo "Running with proxy"
    node_modules/\@angular/cli/bin/ng serve --project frontend --proxy-config proxy.conf.json --base-href=/
    break
    ;;

esac

#!/bin/bash

#Crear carpeta y archivos bash para la creación de componentes de manera facil

function main() {
    createFolder
    filesContent
}

function createFolder() {
    mkdir scripts && touch class.sh common-components.sh componets.sh git-remove.sh guard.sh readMe.md run.sh services.sh
}

function filesContent() {
    cd scripts
    tee -a class.sh <<EOF
    #!/bin/bash
    while [ "$1" != "" ]; do
        npx ng g class "models/$1"
        shift
    done
EOF

    tee -a commom-components.sh <<EOF1
    #!/bin/bash
    while [ "$1" != "" ]; do
        npx ng g c "commom/components/$1"
        shift
    done
EOF1

    tee -a componets.sh <<EOF2
    #!/bin/bash
    while [ "$1" != "" ]; do
        npx ng g c "components/$1"
        shift
    done
EOF2

tee -a git-remove.sh <<EOF3
   #!/bin/bash
    rm -rf .git
EOF3

tee -a guard.sh << EOF4
#!/bin/bash
while [ "$1" != "" ]; do
    npx ng g guard "guards/$1"
    shift
done
EOF4

tee -a readMe.sh << EOF5
# Sripts for use in angular

This folder has different configuration files which facilitate the creation of a frontend project in Angular. The configuration files that are found are:

1. class.sh, create n class files.
2. common-components.sh, create n common-components files.
3. components.sh, create n component files to create the project.
4. git-remove.sh, remove the git folder that is automatically created with the ng new <folder>.
5. guard.sh, create n guard files.
6. run.sh, file to start the project, using a serve or the proxy configuration.
7. services.sh, creates n services files

to run use the command : `sh scripts/(file to use).sh`, it is important to use a console that recognizes linux commands.

## example of use

sh scripts/components.sh name_component1 name_component2 name_component3 ... name_component_n

# Sripts para usar en Angular

Esta carpeta tiene diferentes archivos de configuración que facilitan la creación de un proyecto frontend en Angular. Los archivos de configuración que se encuentran son:

1. class.sh, crea n archivos de clase.
2. common-components.sh, crea n archivos de common-components.
3. components.sh, crea n archivos de componentes para crear el proyecto.
4. git-remove.sh, eliminar la carpeta git que se crea automáticamente con el ng new <folder>.
5. guard.sh, crear n archivos de guardia.
6. run.sh, archivo para iniciar el proyecto, utilizando un servidor o la configuración del proxy.
7. services.sh, crea n archivos de servicios

para ejecutar usa el comando: `sh scripts/(archivo a usar).sh`, es importante usar una consola que reconozca los comandos de linux.

## ejemplo de uso

sh scripts/components.sh name_component1 name_component2 name_component3 ... name_component_n
EOF5

tee -a run.sh << EOF6
#!/bin/bash

# Change the value of options to whatever you want to use.
options=("serve" "proxy")

select_option() {
    # little helpers for terminal print control and key input
    ESC=$(printf '%b' "\033")

    cursor_blink_on() {
        printf '%s' "$ESC[?25h"
    }

    cursor_blink_off() {
        printf '%s' "$ESC[?25l"
    }

    cursor_to() {
        printf '%s' "$ESC[$1;${2:-1}H"
    }

    print_option() {
        printf '   %s ' "$1"
    }

    print_selected() {
        printf '  %s' "$ESC[7m $1 $ESC[27m"
    }

    get_cursor_row() {
        IFS=';' read -sdR -p $'\E[6n' ROW COL
        printf '%s' ${ROW#*[}
    }

    key_input() {
        read -s -n3 key 2>/dev/null >&2
        if [[ $key = $ESC[A ]]; then
            echo up
        fi
        if [[ $key = $ESC[B ]]; then
            echo down
        fi
        if [[ $key = "" ]]; then
            echo enter
        fi
    }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do
        printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=$(get_cursor_row)
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $((startrow + idx))
            if [[ $idx == $selected ]]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case $(key_input) in
        enter) break ;;
        up)
            ((selected--))
            if (($selected < 0)); then selected=$(($# - 1)); fi
            ;;
        down)
            ((selected++))
            if ((selected > $#)); then selected=0; fi
            ;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return "$selected"
}

select_option "${options[@]}"
choice=$?

index=$choice
value=${options[$choice]}

case $value in
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
EOF6

tee -a serve.sh << EOF7
#!/bin/bash
while [ "$1" != "" ]; do
    npx ng g s "services/$1"
    shift
done
EOF7
}

main
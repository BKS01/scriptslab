#!/bin/bash

# Инициализация игрового поля
ROWS=10
COLUMNS=10

# Проверка аргументов командной строки для изменения размеров игрового поля
if [[ $# -eq 1 ]]; then
    SIZE=$1
    if [[ $SIZE -ge 5 && $SIZE -le 32 ]]; then
        ROWS=$SIZE
        COLUMNS=$SIZE
    else
        echo "Ошибка: размер поля должен быть от 5х5 до 32х32."
        exit 1
    fi
fi

# Инициализация игрока и его начальных координат
PLAYER_SYMBOL="P"
player_row=$((ROWS / 2))
player_column=$((COLUMNS / 2))

# Инициализация объекта и его координат
OBJECT_SYMBOL="O"
object_row=0
object_column=0
object_count=0

# Функция для отображения игрового поля
print_board() {
    for ((row = 0; row < ROWS; row++)); do
        for ((column = 0; column < COLUMNS; column++)); do
            if [[ $row -eq $player_row && $column -eq $player_column ]]; then
                echo -n "$PLAYER_SYMBOL "
            elif [[ $row -eq $object_row && $column -eq $object_column ]]; then
                echo -n "$OBJECT_SYMBOL "
            else
                echo -n ". "
            fi
        done
        echo
    done
}

# Функция для обработки перемещения игрока
move_player() {
    local direction=$1

    case $direction in
        "up")
            if [[ $player_row -gt 0 ]]; then
                player_row=$((player_row - 1))
            fi
            ;;
        "down")
            if [[ $player_row -lt $((ROWS - 1)) ]]; then
                player_row=$((player_row + 1))
            fi
            ;;
        "left")
            if [[ $player_column -gt 0 ]]; then
                player_column=$((player_column - 1))
            fi
            ;;
        "right")
            if [[ $player_column -lt $((COLUMNS - 1)) ]]; then
                player_column=$((player_column + 1))
            fi
            ;;
        *)
            echo "Некорректное направление. Используйте 'up', 'down', 'left' или 'right'."
            return 1
            ;;
    esac
    return 0
}

# Функция для установки объекта на поле
place_object() {
    local direction=$1

    case $direction in
        "up")
            if [[ $object_row -gt 0 ]]; then
                object_row=$((object_row - 1))
            fi
            ;;
        "down")
            if [[ $object_row -lt $((ROWS - 1)) ]]; then
                object_row=$((object_row + 1))
            fi
            ;;
        "left")
            if [[ $object_column -gt 0 ]]; then
                object_column=$((object_column - 1))
            fi
            ;;
        "right")
            if [[ $object_column -lt $((COLUMNS - 1)) ]]; then
                object_column=$((object_column + 1))
            fi
            ;;
        *)
            echo "Некорректное направление. Используйте 'up', 'down', 'left' или 'right'."
            return 1
            ;;
    esac

    # Проверка наличия объекта на текущих координатах
    if [[ $object_row -eq $player_row && $object_column -eq $player_column ]]; then
        object_count=$((object_count + 1))
        generate_new_object
    fi

    return 0
}

# Функция для генерации нового объекта на поле
generate_new_object() {
    local empty_spots=()
    for ((row = 0; row < ROWS; row++)); do
        for ((column = 0; column < COLUMNS; column++)); do
            if [[ $row -ne $player_row || $column -ne $player_column ]]; then
                if [[ $row -ne $object_row || $column -ne $object_column ]]; then
                    empty_spots+=("$row,$column")
                fi
            fi
        done
    done

    if [[ ${#empty_spots[@]} -eq 0 ]]; then
        echo "Вы победили! Все объекты собраны."
        exit 0
    fi

    random_index=$((RANDOM % ${#empty_spots[@]}))
    IFS=',' read -r object_row object_column <<<"${empty_spots[$random_index]}"
}

# Основной игровой цикл
while true; do
    clear
    echo "=== Игра на Bash ==="
    echo "Двигайтесь по полю с помощью клавиш W(up), S(down), A(left), D(right)."
    echo "Установите объект с помощью клавиши F в направлении последнего движения."
    echo "Соберите объект, находясь на его клетке."
    echo "Игровое поле: ${ROWS}x${COLUMNS}"
    echo "Количество собранных объектов: $object_count"
    echo
    print_board
    read -rsn1 input
    case $input in
        "w")
            move_player "up"
            ;;
        "s")
            move_player "down"
            ;;
        "a")
            move_player "left"
            ;;
        "d")
            move_player "right"
            ;;
        "f")
            place_object "${last_direction:-"up"}"
            ;;
        "q")
            echo "Игра завершена."
            exit 0
            ;;
    esac
    last_direction="$input"
done


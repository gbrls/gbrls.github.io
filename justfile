# justfile

set shell := ["bash", "-cu"]

default: compile

compile:
    for file in $(find ./src -type f -name '*.typ'); do \
        echo "Compiling $file..."; \
        typst compile "$file" "${file%.typ}.html" --root ./src --format html --features html; \
    done

    mv ./src/*.html .

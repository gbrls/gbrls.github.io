# justfile

set shell := ["bash", "-cu"]

default: compile

compile:
    find ./src -type f -name '*.typ' | parallel -j "$(nproc)" ' echo "Compiling {}"; typst compile {} {.}.html --root ./src --format html --features html '
    mv ./src/*.html .

feed:
    typst compile ./src/feed.typ --root ./src --format html --features html
    python3 ./src/build_feed.py
    rm ./src/feed.html
    mv ./src/feed.rss .
    cp ./feed.rss ./index.xml


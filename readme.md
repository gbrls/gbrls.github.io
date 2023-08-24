# gbrls.github.io

This the repository for my personal website.

# Management

This website is build on static HTML, CSS and sprinkles of Javascript when disclaimed.

The CSS is build locally using Sass (is basically just syntatic sugar for CSS) and markdown files which get translated to HTML using Zola.

There are a few Markdown notes that are stored in this Git repository and will show up in the webpage (those are the old ones). All the new ones are taken from Dropbox and placed in the markdown input folder when I build it. This build process is managed by a few scripts which are run daily by a cronjob, at the end they replace what's under the `www` directory. This means that if something is wrong with the build script, the website won't be updated with the notes from Dropbox, but since it's all static HTML, it'll work out fine other than being not updated.

>&2 echo "Downloading dropbox data..."
cd /opt/Scripts
./dropbox.exs 1>&2
unzip data.zip 1>&2

>&2 echo "Cloning the blog..."
rm -rf /tmp/blog
git clone git@github.com:gbrls/gbrls.github.io.git /tmp/blog 1>&2


>&2 echo "Moving published pages..."
cd /tmp/blog
git checkout toadhacker
cd /opt/Scripts
/opt/Scripts/filter-frontmatter.py journal /tmp/blog/content 1>&2
rm -rf journal
rm data.zip

echo '---
title: logs
date: 2020-10-20
draft: false
---
```txt
' >> /tmp/blog/content/danger-zone/logs.md
cat /var/log/nginx/default.access.log | sed ':a;N;$!ba;s/\n/\n---\n/g' >> /tmp/blog/content/danger-zone/logs.md
echo '```' >> /tmp/blog/content/danger-zone/logs.md

>&2 echo "Bulding the website..."
cd /tmp/blog
echo 'Y' | zola build --base-url https:///blog.gbrls.space -o /var/www/blog 1>&2

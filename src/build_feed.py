
#!/usr/bin/env python3
import os, re, time
from datetime import datetime, timezone

IN = "./src/feed.html"
OUT = "./src/feed.rss"

def fmt_rfc2822(ts: float) -> str:
    return datetime.fromtimestamp(ts, timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %z")

# Read Typst-generated HTML
with open(IN, encoding="utf-8") as f:
    html = f.read()

# Extract <item> blocks
blocks = re.findall(r"<item>(.*?)</item>", html, re.DOTALL)

posts = []
for block in blocks:
    url_match = re.search(r"<h1>(.*?)</h1>", block)
    title_match = re.search(r"<title>(.*?)</title>", block)
    if not (url_match and title_match):
        continue

    url = url_match.group(1).strip()
    title = title_match.group(1).strip()

    # Determine file mod time (fallback = now)
    filename = "./src/" + os.path.basename(url.replace("html", "typ"))
    print(f"adding {filename}")
    ts = os.path.getmtime(filename) if os.path.exists(filename) else time.time()

    posts.append({
        "title": title,
        "url": url,
        "ts": ts,
        "pubDate": fmt_rfc2822(ts)
    })

# Sort newest first
posts.sort(key=lambda p: p["ts"], reverse=True)

rss_items = "\n".join(
    f"""  <item>
    <title>{p["title"]}</title>
    <link>{p["url"]}</link>
    <pubDate>{p["pubDate"]}</pubDate>
  </item>"""
    for p in posts
)

# Build RSS
rss = f"""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
  <title>0x4200.cafe</title>
  <link>https://0x4200.cafe/</link>
  <description>Latest posts from 0x4200.cafe</description>
  <lastBuildDate>{fmt_rfc2822(time.time())}</lastBuildDate>
{rss_items}
</channel>
</rss>
"""

# Write out
with open(OUT, "w", encoding="utf-8") as f:
    f.write(rss)

print(f"✅ Built {OUT} with {len(posts)} items (sorted newest first)")

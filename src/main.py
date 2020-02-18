import os, markdown2
from gists import get_posts_from_github

def write_file(filename, data):
    f = open(filename,'w')
    f.write(data)
    f.close()

def parse_template(raw, filename):
    data = {}

    data['filename']=filename
    data['path']='./{}.html'.format(filename)
    data['raw']=raw
    data['contents']=''

    header=True
    for line in raw.splitlines():
        if header and len(line)>0:
            if line[0]=='<':
                continue
            if line[0]=='-':
                header=False

            key,val='',''
            head=True
            for char in line:
                if char==':':
                    head=False
                    continue
                if head:
                    key+=char
                else:
                    val+=char
            data[key]=val
        elif not header:
            data['contents']+=line+'\n'

    return data

def render_template(data):
    print(data['contents'])

    rendered = markdown2.markdown(data['contents'])
    write_file(data['path'],
            basic_html_template().format(data['title'], rendered))

def render_all(index_path, contents_path):
    articles = []

    for r, d, f in os.walk(contents_path):
        for file in f:
            if '.md' in file:

                path = os.path.join(r,file)
                f = open(path, 'r')
                raw = f.read()
                filename = os.path.splitext(os.path.basename(path))[0]

                data = parse_template(raw, filename)
                articles.append(data)

    webfiles = get_posts_from_github('gbrls')
    for file in webfiles:
        data = parse_template(file['text'], file['filename'])
        articles.append(data)

    for article in articles:
        render_template(article)

    render_index(index_path, articles)

def render_index(filename, articles):
    body = ''

    # Rendering the list of articles
    body += '<ul class="post-list">'
    for article in articles:
        body += '<li><a href="{}">{}</a></li>'.format(article['path'], article['title'])
    body += '</ul>'

    write_file(filename, basic_html_template().format('',body))

def basic_html_template():
    return '''
    <!DOCTYPE HTML>
    <html>
        <head>
            <link rel="stylesheet" href="style.css">
            <link href="https://fonts.googleapis.com/css?family=Lacquer&display=swap" rel="stylesheet">

        </head>
        <body>
            <div class="header">
                <h3><a href="index.html">gbrls</a></h3>
                <p>overheated</p>
            </div>
            <div class="main">
                <h2>{}</h2>
                {}
            </div>
        </body>
    </html>
    '''

render_all('../index.html', '../contents/')
print(get_posts_from_github('gbrls'))

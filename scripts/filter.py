#!/usr/bin/env python3

# Usage ./filter.py source_dir dest_dir

import frontmatter, os, sys, pathlib

def files_in(dir):
    ans = []
    for path, _, files in os.walk(dir):
        for file in files:
            _, ext = os.path.splitext(file)
            if ext == '.md':
                ans.append(f'{path}/{file}')
    return ans

def fmatter(filepath):
    with open(filepath) as f:
        data = f.read()
        post = frontmatter.loads(data)
        return post

def can_publish(post, key):
    return key in post.to_dict() and (post[key] == True)

def path_in_website(post, filepath):
    if 'website_path' in post.to_dict():
        return post['website_path']
    else:
        (tail, head) = os.path.split(filepath)
        if len(tail) == 0:
            return f'blog/{head}'
        else:
            (_, category) = os.path.split(tail)
            return f'{category}/{head}'

def add_metadata_to_file(file):
    post = fmatter(file)
    can = can_publish(post, 'publish')

    path = path_in_website(post, file)

    mp = {}
    mp['published'] = can
    mp['fname'] = file

    (_, head) = os.path.split(file)
    mp['name'] = head

    if can:
        mp['path'] = path

    print(mp)

    return mp


def delete_unpublished(fmps):
    for fmp in fmps:
        if fmp['published'] == False:
            os.remove(fmp['fname'])

def move_published(fmps, dest):
    for fmp in fmps:
        if fmp['published'] == True:
            target = os.path.join(dest, fmp['path'])
            pathlib.Path(os.path.dirname(target)).mkdir(parents=True, exist_ok=True)
            os.rename(fmp['fname'], target)


source = '../content'
dest = '../content/'

if len(sys.argv) > 1:
    source = sys.argv[1]

if len(sys.argv) > 2:
    dest = sys.argv[2]

all_files = list(map(add_metadata_to_file, files_in(source)))

print(f'{len(all_files)} found in {source}')

move_published(all_files, dest)
delete_unpublished(all_files)

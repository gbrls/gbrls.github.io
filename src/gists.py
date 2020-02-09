#import http.client
#conn = http.client.HTTPSConnection('api.github.com')
#conn.request('GET', '/users/vituriano/gists')
#response = conn.getresponse()
#print('status: ({}), reason: ({}), body ({})'.format(response.status, response.reason, response.body))
#conn.close()

import requests, json

def get_posts_from_github(user):
    url = 'https://api.github.com/users/{}/gists'.format(user)
    r = requests.get(url)
    print('status code ({})'.format(r.status_code))

    data = json.loads(r.text)

    files = []

    for gists in data:
        if '[BLOG]' in gists['description']:
            for filename in gists['files']:
                file = {}
                if 'markdown' in gists['files'][filename]['type']:
                    url = gists['files'][filename]['raw_url']
                    file['text'] = requests.get(url).text
                    file['filename'] = filename
                    files.append(file)

    return files

#print(get_posts_from_github('gbrls'))

#url = 'https://api.github.com/users/{}/gists'.format('gbrls')
#r = requests.get(url)
#print('status code ({})'.format(r.status_code))

#data = json.loads(r.text)

#for gists in data:
    #if '[BLOG]' in gists['description']:
        #for filename in gists['files']:
            #if 'markdown' in gists['files'][filename]['type']:
                #url = gists['files'][filename]['raw_url']
                #print(requests.get(url).text)

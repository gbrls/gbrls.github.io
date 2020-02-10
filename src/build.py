import os

os.system('rm ../*.html')
os.system('python main.py')
os.system('mv *.html ..')
os.system('git add .')

c = input('commit? [y/n]')
if 'y' in c:
    os.system('''git commit -m "automated commit"''')
    os.system('git push origin master')

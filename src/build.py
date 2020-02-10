import os

os.system('rm *.html')
os.system('python main.py')
os.system('git add .')
os.system('''git commit -m "automated commit"''')
os.system('git push origin master')

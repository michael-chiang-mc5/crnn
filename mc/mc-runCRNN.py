import urllib
import subprocess
import requests, json
import csv
interface_url = "http://104.131.145.75/"

# run lua script that does crnn on all images
subprocess.check_output(['th', 'mc-lexiconFree.lua'])

# push results to interface
with open('output.txt', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
        elements = row[0].split('\t')
        pk = elements[0]
        method = elements[1] # should be  crnn-lexiconFree
        text = elements[2]
        notes = elements[3]
        payload = {'pk':pk, 'method':method, 'text':text, 'notes':notes, 'locale':'', 'score':0 }
        post_url = interface_url + "ImagePicker/postOCR/"
        r = requests.post(post_url, data={'json-str':json.dumps(payload)})
        print(r.text)

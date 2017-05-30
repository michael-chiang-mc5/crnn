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
        elements = row[0].split('\t')
        pk = elements[0]
        method = elements[1]
        text = elements[2]
        notes = elements[3]
        payload = {'pk':pk, 'method':method, 'text':text, 'notes':raw }
        post_url = interface_url + "ImagePicker/postOCR/"
        r = requests.post(post_url, data={'json-str':json.dumps(payload)})

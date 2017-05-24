import urllib
import subprocess
import requests, json


interface_url = "http://104.131.145.75/"
#interface_url = "http://127.0.0.1:8000/"
metadata = interface_url + "ImagePicker/listBoundingBoxMetadata/"
data = urllib.urlopen(metadata)

for line in data: # each line is pk, image_url
    line = line.decode("utf-8").split('\t')
    pk=line[0]
    image_url=line[1]
    image_save_path = "/home/ubuntu/crnn/mc/temp.jpg"
    urllib.urlretrieve(image_url, image_save_path)
    
    print "running on " + image_url
    
    result = subprocess.check_output(['th', 'mc-lexiconFree.lua'])
    #result="text1\traw\n"
    #
    pk = pk # silly
    method = 'crnn-lexiconFree'
    text = result.split('\t')[0]
    raw = result.split('\t')[1] # notes in POST
    # post to interface
    payload = {'pk':pk, 'method':method, 'text':text, 'notes':raw }
    post_url = interface_url + "ImagePicker/postOCR/"
    r = requests.post(post_url, data={'json-str':json.dumps(payload)})

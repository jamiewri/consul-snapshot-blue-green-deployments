from flask import Flask, render_template
import requests
import json
import os
import time
server = Flask(__name__)

@server.route("/")
def root():
  uri = os.environ['BACKEND_URI']


  try:
    r = requests.get(uri)
    data = r.json()
  except:
    data = {}
    data['platform'] = 'error'
    data['service'] = 'error'
    data['version'] = 0

  print(data)  

  return render_template('index.html', data=data)

if __name__ == '__main__':
  server.run(host='0.0.0.0', port=8080)


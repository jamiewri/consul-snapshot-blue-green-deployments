#from flask import Flask, render_template, request
#import requests
#import json
#import random
#import os
#import socket
#import sys

from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def root():
    json = {'service': 'payments', 'version': 2, 'platform': 'kubernetes'}
    return jsonify(json)

if __name__ == '__main__':
  app.run(host='0.0.0.0')


__version__ = '0.1.0'
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"


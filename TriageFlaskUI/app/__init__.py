from flask import Flask

app = Flask(__name__)

app.config['SECRET_KEY'] = "fj293u2f392uf2u39u93u2fgjoejkefw"
from app import routes
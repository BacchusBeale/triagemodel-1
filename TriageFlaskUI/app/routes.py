from app import app
from flask import render_template
from app.forms import TriageInputForm

@app.route('/')
@app.route('/index')
def index():
    form = TriageInputForm()
    return render_template('index.html', title='Triage Application', form=form)


from flask import Flask
from flask import render_template, request, redirect
from forms import TriageInputForm
import datamodel

app = Flask(__name__)
app.config["DEBUG"] = True
app.config['SECRET_KEY'] = "fj293u2f392uf2u39u93u2fgjoejkefw"


@app.route('/', methods=['GET', 'POST'])
@app.route('/index', methods=['GET', 'POST'])
def index():
    form = TriageInputForm()
    results = {"Results":0}

    if form.is_submitted():
        age = form.age.data
        gender = form.gender.data
        height = form.height.data
        weight = form.weight.data
        smoking = form.smoking.data
        pregnancy = form.pregnancy.data
        avpu = form.avpu.data
        gcs = form.gcs.data
        rr = form.rr.data
        pulse= form.pulse.data
        heartrate = form.heartrate.data
        o2sat = form.o2sat.data

        # gender: 0==Male, 1==Female
        male = 1
        female = 0
        if gender==1:
            male=0
            female=1

        
        out = datamodel.predictTriageCategory(age, male, female, 
                         height, weight,
                         smoking, pregnancy,
                         avpu, gcs, rr, pulse,
                         heartrate, o2sat)

        results["Results"] = out

    return render_template('index.html', title='Triage Application', form=form, output=results)


app.run(host="127.0.0.1", port=5000)
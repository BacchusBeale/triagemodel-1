from flask import Flask
from flask import render_template, request, redirect, url_for
from forms import TriageInputForm
from newestModels import Model1Form, Model2Form
from newestModels import Model1, Model2
import predictions

app = Flask(__name__)
app.config["DEBUG"] = True
app.config['SECRET_KEY'] = "fj293u2f392uf2u39u93u2fgjoejkefw"


@app.route('/', methods=['GET', 'POST'])
@app.route('/index', methods=['GET', 'POST'])
def index():
    form = TriageInputForm()
    results = None
    outputsize = 0

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
        if int(gender)==1:
            male=0
            female=1

        # convert smoking True=1, False=0
        smokingStatus = 0
        if smoking:
            smokingStatus = 1

        pregnancyStatus = 0
        if pregnancy:
            pregnancyStatus = 1
        
        # convert strings to int or float

        out = predictions.predictTriageCategory(age=age, 
        male=male, female=female, 
        height=height, weight=weight,
        smoking=smokingStatus, pregnancy=pregnancyStatus,
        avpu=int(avpu), gcs=gcs, rr=rr, pulse=pulse,
        heartrate=heartrate, o2sat=o2sat)

        results = out
        outputsize = len(results)

    return render_template('index.html', form=form, output=results, numitems=outputsize)

@app.route('/index2', methods=['GET', 'POST'])
def page2():
    form1 = Model1Form()
    form2 = Model2Form()
    output1 = None
    output2 = None

    errors = []

    if form1.is_submitted:
        output1 = None
        try:
            presentTxt = form1.presentingText.data
            chronic = form1.chronicHistory.data
            numChronic = int(chronic)

            model1 = Model1()
            if model1.loadModel():
                result1 = model1.getPredictions(presentintText=presentTxt,
                isChronic=numChronic)

                if result1 is not None:
                    output1=result1

        except BaseException as e1:
            errors.append(str(e1))
        

    if form2.is_submitted:
        output2 = None
        try:
            ageIn = int(form2.age.data)
            pregIn = int(form2.pregnancy.data)
            smokeIn = int(form2.smoking.data)
            avpuIn = int(form2.avpu.data)
            cardioIn = int(form2.cardiovascular.data)
            mhIn = int(form2.mentalHealth.data)
            toxIn = int(form2.toxicology.data)
            endoIn = int(form2.endocrine.data)
            neuroIn = int(form2.neurological.data)
            hrIn = int(form2.heartRateCritical.data)
            rrIn = int(form2.rrlow.data)
            bpIn = int(form2.bpcritical.data)
            ptIn = form2.presentingText.data

            model2 = Model2()
            if model2.loadModel():
                result2 = model2.getPredictions(
                    age=ageIn,
                    pregnancy=pregIn,
                    smoking=smokeIn,
                    avpu=avpuIn,
                    cardiovascular=cardioIn,
                    mentalHealth=mhIn,
                    toxicology=toxIn,
                    endocrine=endoIn,
                    neurological=neuroIn,
                    heartRateCritical=hrIn,
                    rrlow=rrIn,
                    bpcritical=bpIn,
                    presentingText=ptIn
                )

                if result2 is not None:
                    output2=result2

        except BaseException as e2:
            errors.append(str(e2))


    return render_template('index2.html', numerrs=len(errors), errorList=errors, form1=form1, form2=form2, out1=output1, out2=output2)

app.run(host="127.0.0.1", port=5000)
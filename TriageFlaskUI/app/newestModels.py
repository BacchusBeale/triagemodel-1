from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, RadioField
from wtforms import  IntegerField, FloatField, BooleanField, SubmitField, SelectField
from wtforms.validators import DataRequired
import random

# https://machinelearningmastery.com/save-load-machine-learning-models-python-scikit-learn/
# https://stackoverflow.com/questions/47416982/load-and-predict-new-data-sklearn
import joblib
import numpy as np
import xgboost
import pandas as pd

class Model1Form(FlaskForm):
    ChronicChoices = [(0,'Not Chronic'), (1,'Chronic')]

    presentingText = StringField('Presenting information')
    chronicHistory = SelectField('Patient history', choices=ChronicChoices)
    submitModel1 = SubmitField('Step 1 Submit')


class Model2Form(FlaskForm):
    AVPUChoices = [
        (0,"Alert"),(1,"Pain"),(2,"Unresponsive"),(3,"Verbal"),(4,"Touch")
    ]
    yesNo = [(0,"No"),(1,"Yes")]

    age = IntegerField('Age')
    pregnancy = SelectField('Pregnant?', choices=yesNo)
    smoking = SelectField('Smoker?', choices=yesNo)
    avpu = SelectField("AVPU", choices=AVPUChoices)
    cardiovascular = SelectField('Cardiovascular', choices=yesNo)
    mentalHealth = SelectField('Mental Health', choices=yesNo)
    toxicology = SelectField('Toxicology', choices=yesNo)
    endocrine = SelectField('Endocrine', choices=yesNo)

    heartRateCritical = SelectField('Heart rate critical?', choices=yesNo)
    rrlow = SelectField("Respiratory rate low?", choices=yesNo)
    bpcritical = SelectField('Blood pressure critical?', choices=yesNo)

    presentingText = SelectField('Presenting information')

    submitModel2 = SubmitField('Step 2 Submit')

class Model1:
    def __init__(self):
        self.loadedModel = None
        self.isLoaded = False

    def loadModel(self, modelPath='MODEL_1.pkl'):
        self.isLoaded=False
        try:
            self.loadedModel = joblib.load(modelPath)
            self.isLoaded=True
        except BaseException as e:
            print("Load model 1 error: {0}".format(e))
            self.isLoaded=False
        return self.isLoaded

    def getNumberOfChronicConditions(self, textInfo=""):
        rnd = random.randint(1,5)
        return rnd

    def getPredictions(self, presentintText="", isChronic=0):
        results=None
        if not self.isLoaded:
            return results
        try:
            numChronic = self.getNumberOfChronicConditions(textInfo=presentintText)

            inArray = np.array([[numChronic, isChronic]])

            pred = self.loadedModel.predict(inArray)
            row0 = pred[0,:]
            results = row0.tolist()

        except BaseException as e:
            print("Predict model 1 error: {0}".format(e))
        return results


class Model2:
    def __init__(self):
        self.loadedModel = None
        self.isLoaded = False

    def loadModel(self, modelPath='MODEL_2.pkl'):
        self.isLoaded=False
        try:
            self.loadedModel = joblib.load(modelPath)
            self.isLoaded=True
        except BaseException as e:
            print("Load model 2 error: {0}".format(e))
            self.isLoaded=False
        return self.isLoaded

    def getNumberOfChronicConditions(self, textInfo=""):
        rnd = random.randint(1,5)
        return rnd

    def getPredictions(self, age,
        pregnancy, smoking, avpu, cardiovascular,
        mentalHealth, toxicology, endocrine,
        heartRateCritical,rrlow,bpcritical,presentingText):

        results=None
        if not self.isLoaded:
            return results
        try:

            numChronic = self.getNumberOfChronicConditions(textInfo=presentingText)

            inArray = np.array([[age, pregnancy,smoking, avpu, cardiovascular,
            mentalHealth, toxicology, endocrine,
            heartRateCritical,rrlow,bpcritical,numChronic]])

            pred = self.loadedModel.predict(inArray)
            row0 = pred[0,:]
            results = row0.tolist()
        except BaseException as e:
            print("Predict model 2 error: {0}".format(e))
        return results

def testModel1():
    m1 = Model1()
    # modelPath depends on current working dir
    ok = m1.loadModel(modelPath='MODEL1.pkl')
    print("m1 loaded={0}".format(ok))
    if ok:
        print("model 1: {0}".format(m1.loadedModel))

        txt = "heart attack"
        chronic=1
        pred1 = m1.getPredictions(presentintText=txt, isChronic=chronic)
        print("pred1 = {0}".format(pred1))


def testModel2():
    m2 = Model2()
    # modelPath depends on current working dir
    ok = m2.loadModel(modelPath='MODEL2.pkl')
    print("m2 loaded={0}".format(ok))
    if ok:
        print("model 2: {0}".format(m2.loadedModel))

        pred2 = m2.getPredictions(age=3,
        pregnancy=0, smoking=1, avpu=2, cardiovascular=0,
        mentalHealth=1, toxicology=1, endocrine=0,
        heartRateCritical=0,rrlow=0,bpcritical=0,presentingText="high fever")

        print("pred2 = {0}".format(pred2))

# def runTests():
#     testModel1()
#     #testModel2()

# testing = True
# if testing:
#     runTests()


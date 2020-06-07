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
    neurological = SelectField('Neurological', choices=yesNo)
    heartRateCritical = SelectField('Heart rate critical?', choices=yesNo)
    rrlow = SelectField("Respiratory rate low?", choices=yesNo)
    bpcritical = SelectField('Blood pressure critical?', choices=yesNo)

    presentingText = StringField('Presenting information')

    submitModel2 = SubmitField('Step 2 Submit')

class Model1:
    def __init__(self):
        self.loadedModel = None
        self.isLoaded = False

    def loadModel(self, modelPath='MODEL1.pkl'):
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
            pipe1 = self.loadedModel
            d = {'TEXT':[presentintText], 'CHRONIC_HISTORY':[isChronic]}

            df1 = pd.DataFrame(data=d)
            print(df1)
            pipeout1 = pipe1.predict(df1)
            print(pipeout1)

            results = pipeout1

        except BaseException as e:
            print("Predict model 1 error: {0}".format(e))
        return results


class Model2:
    def __init__(self):
        self.loadedModel = None
        self.isLoaded = False

    def loadModel(self, modelPath='MODEL2.pkl'):
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
        mentalHealth, toxicology, endocrine, neurological,
        heartRateCritical,rrlow,bpcritical,presentingText):

        results=None
        if not self.isLoaded:
            return results
        try:
            pipe2 = self.loadedModel

            d2 = {'AGE':age,'PREGNANCY_STATUS':pregnancy,
            'AVPU':avpu, 'SMOKING_STATUS':smoking,
            'Cardiovascular':cardiovascular,
            'Mental_Health':mentalHealth,
            'Toxicology':toxicology,
            'Endocrine':endocrine,
            'Neurology':neurological,
            'HR_critical':bpcritical,
            'RR_LOW':rrlow,
            'BP_critical':bpcritical,
            'TEXT':presentingText
            }
           
            print(d2)
            index2 = range(len(d2))
            print(index2)
            df2 = pd.DataFrame(data=d2, index=index2)

            pipeout2 = pipe2.predict(df2)
            print(pipeout2)

            results = pipeout2
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
        mentalHealth=1, toxicology=1, endocrine=0,neurological=1,
        heartRateCritical=0,rrlow=0,bpcritical=0,presentingText="high fever")

        print("pred2 = {0}".format(pred2))

def runTests():
    #testModel1()
    testModel2()

runTests()


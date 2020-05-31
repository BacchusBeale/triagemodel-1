# https://www.pyimagesearch.com/2018/12/10/keras-save-and-load-your-deep-learning-models/
# https://www.tensorflow.org/guide/keras/save_and_serialize

from tensorflow import keras
import numpy as np

def loadSavedKerasModel(modelPath, showSummary=False):
    model = keras.models.load_model(filepath=modelPath)

    # if showSummary:
    #     summary = model.summary()
    #     print(summary)

    return model

def predictTriageCategory(age, male, female, 
                         height, weight,
                         smoking, pregnancy,
                         avpu, gcs, rr, pulse,
                         heartrate, o2sat):

    dataDict = {"Age":age,
    "Male":male,
    "Female":female,
    "Height":height,
    "Weight":weight,
    "Smoking": smoking,
    "Pregnancy":pregnancy,
    "AVPU":avpu,
    "GCS":gcs,
    "RR":rr,
    "Pulse":pulse,
    "HeartRate":heartrate,
    "O2Sat":o2sat}

    print(dataDict)

    categoryPrediction = []

    themodel = loadSavedKerasModel(modelPath="savedmodel", showSummary=True)
    print(themodel)

    inArray = np.array([[age,male,female,height,weight,smoking,pregnancy,
    avpu,gcs,rr,pulse,heartrate,o2sat]])
    result = themodel.predict(inArray)
    row0 = result[0,:]
    
    categoryPrediction = row0.tolist()
    return categoryPrediction

# def runTest():
#     # themodel = loadSavedKerasModel(modelPath="savedmodel", showSummary=True)
#     # print(themodel)

#     age = 12
#     gender = 1
#     height = 140
#     weight = 64
#     smoking = False
#     pregnancy = True
#     avpu = 1
#     gcs = 8
#     rr = 54
#     pulse= 77
#     heartrate = 74
#     o2sat = 99

#     # gender: 0==Male, 1==Female
#     male = 1
#     female = 0
#     if gender==1:
#         male=0
#         female=1

#     # convert smoking True=1, False=0
#     smokingStatus = 0
#     if smoking:
#         smokingStatus = 1

#     pregnancyStatus = 0
#     if pregnancy:
#         pregnancyStatus = 1
    
#     out = predictTriageCategory(age=age, 
#     male=male, female=female, 
#     height=height, weight=weight,
#     smoking=smokingStatus, pregnancy=pregnancyStatus,
#     avpu=avpu, gcs=gcs, rr=rr, pulse=pulse,
#     heartrate=heartrate, o2sat=o2sat)

#     print("category prediction: ", out)


# runTest()

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

    categoryPrediction = {"Prediction":5}

    return categoryPrediction
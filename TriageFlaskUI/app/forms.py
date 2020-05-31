from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, FloatField, BooleanField, SubmitField, SelectField
from wtforms.validators import DataRequired


class TriageInputForm(FlaskForm):
    GenderChoices = [(0,"Male"), (1,"Female")]
    AVPUChoices = [
        (0,"Alert"),(1,"Pain"),(2,"Unresponsive"),(3,"Verbal"),(4,"Touch")
    ]
    
    patientID = StringField("Patient ID")
    firstName = StringField('First name')
    lastName = StringField("Last name")
    age = IntegerField('Age', default=0)
    gender = SelectField("Gender", choices=GenderChoices, default=0)
    height = FloatField("Height", default=0)
    weight = FloatField("Weight", default=0)
    smoking = BooleanField("Smoking Status")
    pregnancy = BooleanField("Pregnancy Status")
    avpu = SelectField("AVPU", choices=AVPUChoices)

    gcs = FloatField("Glasgow Coma Scale", default=0)
    rr = FloatField("Respiratory Rate", default=0)
    pulse= FloatField("Pulse", default=0)
    heartrate = FloatField("Heart Rate", default=0)
    o2sat = FloatField("O2 Saturation", default=0)

    submit = SubmitField('Submit')
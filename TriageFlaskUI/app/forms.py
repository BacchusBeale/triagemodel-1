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
    age = IntegerField('Age', validators=[DataRequired()])
    gender = SelectField("Gender", choices=GenderChoices, validators=[DataRequired()])
    height = FloatField("Height", validators=[DataRequired()])
    weight = FloatField("Weight", validators=[DataRequired()])
    smoking = BooleanField("Smoking Status", validators=[DataRequired()])
    pregnancy = BooleanField("Pregnancy Status", validators=[DataRequired()])
    avpu = SelectField("AVPU", choices=AVPUChoices)

    gcs = FloatField("Glasgow Coma Scale", validators=[DataRequired()])
    rr = FloatField("Respiratory Rate", validators=[DataRequired()])
    pulse= FloatField("Pulse", validators=[DataRequired()])
    heartrate = FloatField("Heart Rate", validators=[DataRequired()])
    o2sat = FloatField("O2 Sarturation", validators=[DataRequired()])

    submit = SubmitField('Submit')
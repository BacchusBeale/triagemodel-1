from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField
from wtforms import  IntegerField, FloatField, BooleanField, SubmitField, SelectField
from wtforms.validators import DataRequired

class Model1Form(FlaskForm):
    ChronicChoices = [('Not Chronic', 0), ('Chronic', 1)]

    presentingText = StringField('Presenting information')
    chronicHistory = SelectField('Chronic history', choices=ChronicChoices)
    submitModel1 = SubmitField('Step 1 Submit')


class Model2Form(FlaskForm):
    AVPUChoices = [
        (0,"Alert"),(1,"Pain"),(2,"Unresponsive"),(3,"Verbal"),(4,"Touch")
    ]

    age = IntegerField('Age')
    pregnancy = BooleanField('Pregnant?')
    smoking = BooleanField('Smoker?')
    avpu = SelectField("AVPU", choices=AVPUChoices)
    cardiovascular = BooleanField('Cardiovascular')
    mentalHealth = BooleanField('Mental Health')
    toxicology = BooleanField('Toxicology')
    endocrine = BooleanField('Endocrine')

    heartRateCritical = BooleanField('Heart rate critical?')
    rrlow = BooleanField("Respiratory rate low?")
    bpcritical = BooleanField('Blood pressure critical?')

    presentingText = StringField('Presenting information')

    submitModel2 = SubmitField('Step 2 Submit')
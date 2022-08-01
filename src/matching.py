
#import your own module with vocabulary?

#Terms belonging to the same class/category/hierarchy are grouped in the same set.
#All terms are in lower case letters.
set1 = {'warfarin', 'anticoagulant', 'vitamin k antagonist', 'antithrombotic agent'}
set2 = {'dental procedure', 'dental surgical procedure', 'dental operation',
        'procedure on oral cavity', 'operation on oral cavity', 'operation on mouth'}
set3 = {'doac', 'direct acting anticoagulant', 'anticoagulant',
        'coagulation related substance', 'dabigatran', 'heparin'}
set4 = {'ckd', 'chronic kidney disease', 'chronic renal impairment', 'renal impairment',
        'chronic renal disease', 'chronic disease of genitourinary system'}
set5 = {'afib', 'af', 'atrial fibrilation', 'atrial arrhythmia', 'cardiac arrhythmia',
        'supraventricular arrhythmia', 'supraventricular tachycardia'}
set6 = {'cvd', 'cvs disease' 'cardiovascular disease', 'cardiovascular system disease',
        'disorder of cardiovascular system'}

#For testing purposes
set7 = {'a7', 'asept', 'aseven', '7a'}


def match_terms(clinical_term1, clinical_term2):
    """
    Determines if input terms clinical_term1 and clinical_term2 are equivalent by
    checking if they are both contained in the same hierarchy of terms,
    obtained from an ontology. Returns 1 if the terms match, 0 otherwise.
    Args:
        clinical_term: string describing the clinical action.
    """
    if clinical_term1 in set1 and clinical_term2 in set1:
        return 1
    elif clinical_term1 in set2 and clinical_term2 in set2:
        return 1
    elif clinical_term1 in set3 and clinical_term2 in set3:
        return 1
    elif clinical_term1 in set4 and clinical_term2 in set4:
        return 1
    elif clinical_term1 in set5 and clinical_term2 in set5:
        return 1
    elif clinical_term1 in set6 and clinical_term2 in set6:
        return 1
    elif clinical_term1 in set7 and clinical_term2 in set7:
        return 1
    else:
        return 0


#print(match_terms('doac', 'dabigatran'))

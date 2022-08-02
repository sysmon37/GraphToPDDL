
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

SYNONYM_SETS = [set1, set2, set3, set4, set5, set6]

def match_terms(term1, term2):
    """
    Determines if input terms clinical_term1 and clinical_term2 are equivalent by
    checking if they are both contained in the same hierarchy of terms,
    obtained from an ontology. Returns 1 if the terms match, 0 otherwise.
    Args:
        clinical_term: string describing the clinical action.
    """

    for s in SYNONYM_SETS:
        if term1 in s and term2 in s:
            return True
    return False

#print(match_terms('doac', 'dabigatran'))

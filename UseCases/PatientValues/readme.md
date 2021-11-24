# Patient values
This section is a guide to create a well formatted patien values file.

The patien values file is passed to the program as an argument (flag --).
- --p patient_value_file.json

## File format
The file must be a JSON file.

## Content
It is a dictionary where the keys are the 'dataItem' from the actionable graph (Dot file) and from the revision operators.

```
{
    "v1": 9,
    "v2": 6,
    "v3": 3,
    ...
}
```

Be careful, the program is case sensitive for these keys.

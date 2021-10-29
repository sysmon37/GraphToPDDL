import filecmp
import difflib
import pytest

# pytest test_problem_file.py

"""
Test Case Example
"""
def test_problem_file():
    f1 = 'problem.pddl' # Generated file from read_graph.py
    f2 = 'test-problem.pddl' # File to compare
    result = filecmp.cmp(f1, f2)
    # assert result == True
    if not result:
        text1 = open(f1).readlines()
        text2 = open(f2).readlines()
        buffer = ""
        for line in difflib.unified_diff(text1, text2):
            buffer += line
        
        # Show the content
        pytest.fail(buffer)
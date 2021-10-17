# Read an input dot file and create a graph
import argparse

import graphView.graphView as GV
import GraphComponent.graph as GC


parser = argparse.ArgumentParser(description='Read in dot file and attempt to create a graph.')
parser.add_argument('dotFile',
                    help='a dot file.')

args = parser.parse_args()
#print(args.dotFile) 


#UseCases\AGFigures\\testcase-5.dot
graphDot = GC.run(args.dotFile)
#graphDot.printDot()


GV.graphView(graphDot, "test")



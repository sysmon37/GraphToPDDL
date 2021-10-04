# import the necessary packages
#https://www.pyimagesearch.com/2016/02/08/opencv-shape-detection/
import cv2

class ShapeDetector:
	def __init__(self):
		pass
	def detect(self, c):
		# initialize the shape name and approximate the contour
		shape = "unidentified"
		epsilon = 0.01*cv2.arcLength(c, True)
		approx = cv2.approxPolyDP(c, epsilon, True)
		cv2.matchShapes

		#print(len(approx))
        # if the shape is a triangle, it will have 3 vertices
		if len(approx) == 3:
			shape = "triangle"
		# if the shape has 4 vertices, it is either a square or
		# a rectangle
		elif len(approx) == 4:
			# compute the bounding box of the contour and use the
			# bounding box to compute the aspect ratio
			(x, y, w, h) = cv2.boundingRect(approx)
			ar = w / float(h)

			# a square will have an aspect ratio that is approximately
			# equal to one, otherwise, the shape is a rectangle
			shape = "square" if ar >= 0.95 and ar <= 1.05 else "rectangle"
		# if the shape is a pentagon, it will have 5 vertices
		elif len(approx) == 6:
			(x, y, w, h) = cv2.boundingRect(approx)
			ar = w / float(h)

			if ar >= 1.80:
				shape = "trapeze"
			else:
				shape = "losange"

		elif len(approx) == 7:
			shape = "haxagone"

		# otherwise, we assume the shape is a circle
		else:
			(x, y, w, h) = cv2.boundingRect(approx)
			ar = w / float(h)
			#print(ar)
			#print(len(approx))
			if ar >= 1.05:
				shape = "ellipse"
			else:
				shape = "circle"
		# return the name of the shape
		return shape


import argparse
import imutils
import cv2
import numpy as np

# construct the argument parse and parse the arguments
#ap = argparse.ArgumentParser()
#ap.add_argument("-i", "--image", required=True,
#	help="path to the input image")
#args = vars(ap.parse_args())

# load the image and resize it to a smaller factor so that
# the shapes can be approximated better
image = cv2.imread("legend.png")#args["image"]
resized = imutils.resize(image, width=300) #imutils is a custom package based on opencv by Adrian of pyimagesearch
ratio = image.shape[0] / float(resized.shape[0]) #we keep track of the ratio of the old height to the new resized height

#convert white backgroud to black
b_low = np.array([250,250,250])
b_up = np.array([255,255,255])
mask = cv2.inRange(resized, b_low, b_up)
resized[mask>0] = (0,0,0)

#convert the resized image to grayscale, blur it slightly, and threshold it
gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY) #converts image to grayscale
blurred = cv2.GaussianBlur(gray, (5, 5), 0) #reduces high frequency noise by slightly blurring the image
thresh = cv2.threshold(blurred, 10, 255, cv2.THRESH_BINARY)[1] #thresholding it to reveal the shapes

#find contours in the thresholded image and initialize the shape detector
cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
	cv2.CHAIN_APPROX_SIMPLE)
cnts = imutils.grab_contours(cnts)
sd = ShapeDetector()

#loop over the contours
for c in cnts:
	M = cv2.moments(c)

	if M["m00"] > 0:

		cX = int((M["m10"] / M["m00"]) * ratio)
		cY = int((M["m01"] / M["m00"]) * ratio)
		shape = sd.detect(c)

		# multiply the contour (x, y)-coordinates by the resize ratio,
		# then draw the contours and the name of the shape on the image
		c = c.astype("float")
		c *= ratio
		c = c.astype("int")

		# draw border around the screen

		cv2.drawContours(image, [c], -1, (0, 0, 0), 3)

		cv2.putText(image, shape, (cX, cY), cv2.FONT_HERSHEY_SIMPLEX,
					0.5, (0, 0, 0), 2)

		resized = imutils.resize(image, width=600)
		cv2.imshow("RESULT", resized)
		cv2.waitKey(0)


cv2.imshow("Image", image)
cv2.waitKey(0)
cv2.destroyAllWindows()
def rotate_bound(image, angle):
	# grab the dimensions of the image and then determine the
	# center
	(h, w) = image.shape[:2]
	(cX, cY) = (w // 2, h // 2)

	# grab the rotation matrix (applying the negative of the
	# angle to rotate clockwise), then grab the sine and cosine
	# (i.e., the rotation components of the matrix)
	M = cv.getRotationMatrix2D((cX, cY), -angle, 1.0)
	cos = np.abs(M[0, 0])
	sin = np.abs(M[0, 1])

	# compute the new bounding dimensions of the image
	nW = int((h * sin) + (w * cos))
	nH = int((h * cos) + (w * sin))

	# adjust the rotation matrix to take into account translation
	M[0, 2] += (nW / 2) - cX
	M[1, 2] += (nH / 2) - cY

	# perform the actual rotation and return the image
	return cv.warpAffine(image, M, (nW, nH))
import  numpy as np
import cv2 as cv
from matplotlib import pyplot as plt
file_name = '6012.jpg'
img = cv.imread('6009.jpg')
# cv.imshow('原图', img)
shape = img.shape
high = shape[0]
width = shape[1]
img1 = cv.resize(img, (int(width/2), int(high/2)), cv.INTER_LINEAR)
im_gray = cv.cvtColor(img1, cv.COLOR_BGR2GRAY)
img = cv.adaptiveThreshold(im_gray, 255, cv.ADAPTIVE_THRESH_MEAN_C, cv.THRESH_BINARY_INV, 5, 10)
if high > width:
	img = rotate_bound(img, -90)

# 膨胀
el = cv.getStructuringElement(cv.MORPH_RECT, (5, 10))
img1 = cv.dilate(img, el)
plt.subplot(2, 1, 1)
plt.imshow(img)
plt.subplot(2, 1, 2)
plt.imshow(img1)
plt.show()

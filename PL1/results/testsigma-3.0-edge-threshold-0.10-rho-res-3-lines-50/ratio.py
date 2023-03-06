import numpy as np
import os
import re
from matplotlib import image

if __name__ == "__main__":
    ordered_list = []
    for file in os.listdir():
        if re.match(".*_04lines\.png", file):
            img_matrix = image.imread(file)
            ratio = img_matrix.shape[0] / img_matrix.shape[1]
            print(
                "aspect ratio of",
                file,
                "is",
                ratio
            )
            ordered_list.append((ratio, file))
    ordered_list.sort()
    print("ordered list is:")
    for ratio, file in ordered_list:
        print(file, '->',ratio)

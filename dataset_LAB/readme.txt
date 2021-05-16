Dataset Instruction

Collecting Time: Jan. 15th, 2020 (training data), Jan. 17th, 2020 (testing data)
Collecting Site: Laboratory 316, College of Computer Science, Inner Mongolia University, Hohhot, China
Area: about 81 square meters

File Description:
coordinate.txt --- The coordinates of all reference points, each line contains the number, the horizontal and vertical coordinates, the wdith and height of the grids, there are total 112 grids.
matlab_code --- This folder contains the codes that are used to construct and generate the fingerprint database.
data_original --- This folder contains the original collected training and testing data, 6 .m files are the codes used to rectify the data.
apconfig.txt --- The related information about 4 APs, including the MAC address, number and their locations.
deviceconfig.txt --- The related information of all device been used, including the model name and their MAC address.
testpoint.txt --- The coordinates of all testing points, each line contains the number and the horizontal and vertical coordinates.

Training data:
Two Mi6 devices are parallelly used to collect the training data.
There are total 24 testing points (Number 1-4-7-10-13-16-33-36-39...).
The data format is (timestamp,ap_mac,device_mac,grid_id,ap_id,channel_id,rss).
The data files with suffix "original" are the original collected data.
The data files with suffix "corrected" are the rectified data (ap_id is counting from 1).

Testing data:
There are 13 testing points deviding into two groups for collecting the testing data.
The first group (g1) contains 2 laptops.
The second group (g2) contains 3 mobile phones and 1 tablet.
The data format and the meaning of file suffix is the same as training data.
"mi1" and "mi2" denote the two Xiaomi M6 respectively, "sam" denotes the Sansung S9+, "dell" denotes the Dell Laptop, "mac" denotes the Macbook Pro laptop, iPad denotes the iPad Pro tablet.
# shapelet-based-event-detection
In this Thesis, a study is made to measure the impact of data sampling rate on the detection accuracy obtained through an event detection algorithm. Therefore, a machine learning based shapelet approach for electrical appliance use detection is implemented. The fast shapelet approach detects the occurrence of an event that is caused by switching on/off of an electrical appliance. A general architecture is introduced to evaluate the performance through feeding the algorithm with re-sampled data and comparing the obtained accuracy with the sampling rate. Different metrics are used to ensure a comprehensive evaluation; F1-score, confusion matrix, and classification accuracy.
# == How to run the code ==
1- copy the orig. data into TraningData folder. 

2- open the project by Matlab version R2018Ba

3- import the java dependency into the workspace by run the following: 

javaaddpath('\javaDependency\weka-3.7.0.jar');
javaaddpath('\javaDependency\utilities-50.jar');
javaaddpath('\javaDependency\utilities-30p.jar');


4- select the parameter of the SH.

5- run the main 


6 -shapelet tree and the classification results will be written in results.txt

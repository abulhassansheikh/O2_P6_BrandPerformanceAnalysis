
###Brand Pulse Dashboard
import pandas as pd
from dfply import *

PastYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/PastYearDataNew.csv", encoding='utf-8')	
CurrentYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/CurrentYearDataNew.csv", encoding='utf-8')	

SD = pd.concat([PastYearData, CurrentYearData])

SD[(SD['Order_Date']!="") & (SD['Supplier']=="Keystone")].groupby('attribute_set')

(SD >>
     group_by(X.attribute_set)>>
     summarize(Supplier = X.Supplier.mean))

SD >> select("Order_Date", "Order_Number") >> head(3)

SD.columns
SD["Supplier"]


###Brand Pulse Dashboard
import pandas as pd

PastYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/PastYearDataNew.csv", encoding='utf-8')	
CurrentYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/CurrentYearDataNew.csv", encoding='utf-8')	

SD = pd.concat([PastYearData, CurrentYearData])

SD.columns

SD[(SD['Order_Date']!="") & (SD['Supplier']=="Keystone")].groupby('attribute_set').count()

test = SD.groupby("attribute_set", as_index=False)['Order_Date'].agg({"count":"count"}).sort_values("count", ascending = False)

test.index


###Brand Pulse Dashboard
import pandas as pd


PastYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/PastYearDataNew.csv", encoding='utf-8')	
CurrentYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/CurrentYearDataNew.csv", encoding='utf-8')	

SD = pd.concat([PastYearData, CurrentYearData])

SD.columns
SD['Order_Date']

test = SD

test['Order_Date'] = pd.to_datetime(test['Order_Date'], format= "%Y-%m-%d")
test.dtypes

test[test['Order_Date'] > '2018-01-01'] 


FilterSD =    SD[(SD['Order_Date']!="") 
           #& (SD['Supplier']=="Keystone")
           ]

GroupedSD = (FilterSD.groupby("attribute_set", as_index=False)
                ['Order_Date'].
                agg({"count":"count"}).sort_values("count", ascending = False))


test['Year'] = round(test['Order_Date'].dt.year,0)
test['Month'] = test['Order_Date'].dt.month
df['Day'] = df['Date'].dt.day
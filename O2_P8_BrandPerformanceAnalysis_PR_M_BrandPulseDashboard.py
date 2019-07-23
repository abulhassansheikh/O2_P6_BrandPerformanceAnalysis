
###Brand Pulse Dashboard
import pandas as pd


PastYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/PastYearDataNew.csv", encoding='utf-8')	
CurrentYearData =pd.read_csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/CurrentYearDataNew.csv", encoding='utf-8')	

#Combine Past and recent years sales data
SD = pd.concat([PastYearData, CurrentYearData], ignore_index=True)

#Convert Order_Date string to date and extract relevant date values
SD['Order_Date'] = pd.to_datetime(SD['Order_Date'], format= "%d-%b-%y")
SD['OD_Year'] = SD['Order_Date'].dt.strftime('%Y')
SD['OD_MonthNum'] = SD['Order_Date'].dt.strftime('%m')
SD['OD_MonthLab'] = SD['Order_Date'].dt.strftime('%B')
SD['OD_MonthDay'] = SD['Order_Date'].dt.strftime('%d')
SD['OD_WeekDay'] = SD['Order_Date'].dt.strftime('%A')

#Filter out any blank orderdate values
FilterSD =    SD[(SD['Order_Date']!="")
           #& (SD['Supplier']=="Keystone")
           ]

#Group by Attribute set & year sold, then count number of sales
GroupedSD = (FilterSD.groupby(["attribute_set","OD_Year"], as_index=False)
                ['Order_Date'].
                agg({"count":"count"}).sort_values(["attribute_set","OD_Year"] , ascending = True))






























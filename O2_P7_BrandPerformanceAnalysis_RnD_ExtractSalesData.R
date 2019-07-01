

SalesDataExtract = function(){

library(dplyr)
library(tidyr)

##Pull Main Sheet Data
#Load the list of Main Sheet folder Names
MainFileName =read.csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/5_R_Brand_Reference_Files/Brands_Prefix.csv", header = TRUE)
Brand_Folder_List =data.frame(MainFileName %>% filter(Category.Brand.Name != "SalesData") %>% select(Brand_Folder_Name))

BPA_PooledMainData = data.frame()

for (i in 1:nrow(Brand_Folder_List)){
	BrandFolderLocation = paste("//192.168.2.32/GoogleDrive/Completed Magento Uploads (v 1.0)/",as.character(Brand_Folder_List[i,]), sep = "", collapse = NULL)
	setwd(BrandFolderLocation)
	message(BrandFolderLocation)
}

for (i in 1:nrow(Brand_Folder_List)){
	BrandFolderLocation = paste("//192.168.2.32/GoogleDrive/Completed Magento Uploads (v 1.0)/",as.character(Brand_Folder_List[i,]), sep = "", collapse = NULL)
	setwd(BrandFolderLocation)
	message(BrandFolderLocation)

	#Identify the Main--sheet and pull it
	x <- Sys.glob("main--*.csv")
	PulledMain=read.csv(x , header = TRUE)
	PulledMain = tbl_df(PulledMain)

	MainSubset <- PulledMain %>% filter(type=="simple") %>% select(internal_sku, delete, attribute_set, part_type_filter, series_parent, na_ca_shipping, ca_cost, ca_price)

	#Add Brand name and # of attribute sets to BrandAttributeSet df
	BPA_PooledMainData = rbind(BPA_PooledMainData ,MainSubset )
}

names(BPA_PooledMainData) = c("internal_sku", "delete", "attribute_set_MAIN", "part_type_filter", "series_parent", "na_ca_shipping", "ca_cost", "ca_price") 


#SkuAddDate =read.csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11. Brand_Performance_Analysis/Sku_Add_Date.csv", header = TRUE)
PtCategory =read.csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11. Brand_Performance_Analysis/PtCategory.csv", header = TRUE)
MERPexport =read.csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11. Brand_Performance_Analysis/merp.csv", header = TRUE) %>% select(internal_sku, price) %>% mutate(ActiveSku = 1) %>%rename(MERPprice = 2)
PastYearData =read.csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/PastYearData.csv", header = TRUE)	
CurrentYearData =read.csv("//192.168.2.32/Group/Data Team/Brand_Update_Location/11_Brand_Performance_Analysis/CurrentYearData.csv", header = TRUE)	

Pooled_BPA = data.frame(rbind(PastYearData,CurrentYearData) )

names(Pooled_BPA) = c( "Order_Date", "Completed_Date", "Order_Number", "Province", "Payment_Method",             
 				"Order_Bucket", "Order_Item_Id", "Order_Status", "Support_Bucket", "Is_Kit_Breakdown",         
 				"Is_Exchange", "Is_Special_Order", "attribute_set", "Last_Modified", "internal_sku",               
 				"Product_Description", "Reconciliation_Status", "Invoice_Date", "Qty_Ordered", "Gross_Retail_Price_CAD",   
 				"Price_Discount_CAD", "Net_Retail_Price_CAD", "Sales_Tax", "Net_Retail_Tax_CAD", "Total_Net_Price_CAD",      
 				"Product_Cost", "Product_Cost_CAD", "Product_Tax_Cost", "Product_Tax_Cost_CAD", "Shipping_Cost",              
 				"Shipping_Cost_CAD", "Shipping_Tax_Cost", "Shipping_Tax_Cost_CAD", "Total_Cost_CAD", "Date_Paid",                  
 				"Approval_Code", "Additional_Approval_Codes", "Gross_Profit", "Exchange_Rate", "Supplier",                   
 				"P_O", "Date_of_Purchase_Order", "Tracking_Number", "Date_of_Tracking_Number", "Refund_Date",                
 				"Refund_Price_CAD", "Refund_Tax_CAD", "Refund_Discount_CAD", "Total_Refunded_CAD", "RMA_Number",                 
 				"Credit_CAD", "Shipping_Credit_CAD", "Tax_Credit_CAD", "Return_Shipping_Fee", "Return_Shipping_Fee_Tax",    
 				"Return_Shipping_Cost", "Return_Shipping_Cost_Tax", "Return_Reimbursed_By_Vendor", "Vendor_Invoice_Number", 
				"Notes", "Reconcile_Y_N", "Override")

#Merge sku add date data
#Pooled_BPA =  merge(Pooled_BPA , SkuAddDate , by="internal_sku", all=TRUE)
Pooled_BPA =  merge(Pooled_BPA , MERPexport, by="internal_sku", all=TRUE)
Pooled_BPA =  merge(Pooled_BPA, BPA_PooledMainData, by=c("internal_sku"), all=TRUE)
Pooled_BPA =  merge(Pooled_BPA , PtCategory , by="part_type_filter", all=TRUE)

#Format the Date
Pooled_BPA$Order_Date 			= as.Date(Pooled_BPA$Order_Date, "%d-%b-%y")
Pooled_BPA$Completed_Date 		= as.Date(Pooled_BPA$Completed_Date, "%d-%b-%y")
Pooled_BPA$Refund_Date 			= as.Date(Pooled_BPA$Refund_Date, "%d-%b-%y")
Pooled_BPA$Reconciliation_Status 	= as.Date(Pooled_BPA$Reconciliation_Status, "%d-%b-%y")
Pooled_BPA$Date_of_Tracking_Number	= as.Date(Pooled_BPA$Date_of_Tracking_Number, "%d-%b-%y")
Pooled_BPA$Date_of_Purchase_Order 	= as.Date(Pooled_BPA$Date_of_Purchase_Order, "%d-%b-%y")
Pooled_BPA$Date_Paid 			= as.Date(Pooled_BPA$Date_Paid, "%m/%d/%Y")
Pooled_BPA$Invoice_Date 		= as.Date(Pooled_BPA$Invoice_Date , "%d-%b-%y")
#Pooled_BPA$add_date			= as.Date(Pooled_BPA$add_date, "%Y-%m-%d")



Pooled_BPA =  merge(PastYearData, CurrentYearData, by=c("Order.Date", "Completed.Date", "Order.Number", "Province", "Payment.Method", "Order.Bucket", "Order.Item.Id",               
						"Order.Status", "Support.Bucket", "Is.Kit.Breakdown", "Is.Exchange", "Is.Special.Order", "attribute_set", "Last.Modified",               
						"internal_sku", "Product.Description", "Reconciliation.Status", "Invoice.Date", "Qty.Ordered", "Gross.Retail.Price..CAD.", "Price.Discount..CAD.",       
						"Net.Retail.Price..CAD.", "Sales.Tax....", "Net.Retail.Tax..CAD.", "Total.Net.Price..CAD.", "Product.Cost", "Product.Cost..CAD.", "Product.Tax.Cost",            
						"Product.Tax.Cost..CAD.", "Shipping.Cost", "Shipping.Cost..CAD.", "Shipping.Tax.Cost", "Shipping.Tax.Cost..CAD.", "Total.Cost..CAD.", "Date.Paid",                   
						"Approval.Code", "Additional.Approval.Codes", "Gross.Profit", "Exchange.Rate", "Supplier", "P.O..", "Date.of.Purchase.Order", 
						"Tracking.Number", "Date.of.Tracking.Number", "Refund.Date", "Refund.Price..CAD.", "Refund.Tax..CAD.", "Refund.Discount..CAD.", "Total.Refunded..CAD.",      
						"RMA.Number", "Credit..CAD.", "Shipping.Credit..CAD.", "Tax.Credit..CAD.", "Return.Shipping.Fee", "Return.Shipping.Fee.Tax", "Return.Shipping.Cost",        
						"Return.Shipping.Cost.Tax", "Return.Reimbursed.By.Vendor", "Vendor.Invoice.Number", "Notes", "Reconcile..Y.N.", "Override"), all=TRUE)




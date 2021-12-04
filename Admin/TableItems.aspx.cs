using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Globalization;

public partial class AccountantGM_Void : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();
    String TableID;

    protected void Page_Load(object sender, EventArgs e)
    {
        TableID = Request.QueryString["TableID"];

        if (!Page.IsPostBack)
        {
            CheckUserSession();
            loadSelectedTable();
        }
    }

    protected void CheckUserSession()
    {
        try
        {
            String userType = Session["userType"].ToString();

            if (userType != "Admin")
            {
                Response.Redirect("../Login.aspx");
            }
        }
        catch (Exception)
        {

            Response.Redirect("../Login.aspx");
        }
    }

    // Action methods

    protected void DeleteRow(object sender, EventArgs e)
    {
        String Message;

        Button btn = (sender as Button);
        String item = btn.CommandArgument;
        String tableID = TableID;

        DataTable cashChk = dataAccess.seleccct("[Number]", "[FleetDB].[dbo].[DailyTables]", "[Id] = " + tableID + "and [Cashed] = 0").Tables[0];

        if (cashChk.Rows.Count == 0)
        {
            Message = "Table has already been cashed. Please uncash table first.";
        }
        else
        {
            String dataBaseTable = "[FleetDB].[dbo].[DailyTablesOrders]";
            String dataBaseTable2 = "[FleetDB].[dbo].[OrdersPort]";


            String filter = "[TableId]=" + tableID + " and [Item]=N'" + item + "'";
            String itemPorts = getItemPort(item) + "";

            //Check if more than one record
            DataTable dt = dataAccess.seleccct("[Id],[ItemQuantity]", dataBaseTable, filter).Tables[0];
            DataTable dt2 = dataAccess.seleccct("[Id],[ItemQuantity]", dataBaseTable2, filter + " order by [Id]").Tables[0];

            int orderPortID = int.Parse(dt2.Rows[0][0].ToString());

            if (dt.Rows.Count > 1)
            {

                if (dt.Rows[0][1].ToString() == "1")
                {
                    dataAccess.delete(dataBaseTable, filter + " and [Id]=" + dt.Rows[0][0].ToString());
                    for (int i = 0; i < itemPorts.Length; i++)
                    {
                        checkPortSubmissionForReturn((orderPortID + i) + "");

                        dataAccess.delete(dataBaseTable2, filter + " and [Id]=" + (orderPortID + i));
                    }
                }
                else
                {
                    int qun = int.Parse(dt.Rows[0][1].ToString());
                    int newQun = qun - 1;
                    dataAccess.Update(dataBaseTable, "[ItemQuantity]=" + newQun + ", [ItemTotal]=" + getNewTotal(newQun, item), filter + " and [Id]=" + dt.Rows[0][0].ToString());
                    for (int i = 0; i < itemPorts.Length; i++)
                    {
                        checkPortSubmissionForReturn((orderPortID + i) + "");

                        dataAccess.Update(dataBaseTable2, "[ItemQuantity]=" + newQun, filter + " and [Id]=" + (orderPortID + i));
                    }
                }
            }
            else
            {
                int qun = int.Parse(dt.Rows[0][1].ToString());
                if (qun == 1)
                {
                    for (int i = 0; i < itemPorts.Length; i++)
                    {
                        checkPortSubmissionForReturn((orderPortID + i) + "");
                    }

                    dataAccess.delete(dataBaseTable, filter);
                    dataAccess.delete(dataBaseTable2, filter);
                }
                else
                {
                    for (int i = 0; i < itemPorts.Length; i++)
                    {
                        checkPortSubmissionForReturn((orderPortID + i) + "");
                    }

                    int newQun = qun - 1;
                    dataAccess.Update(dataBaseTable, "[ItemQuantity]=" + newQun + ", [ItemTotal]=" + getNewTotal(newQun, item), filter);
                    dataAccess.Update(dataBaseTable2, "[ItemQuantity]=" + newQun, filter);
                }

            }
            updateTableTotal(tableID);

            Message = "تم الحذف بنجاح";

            dataAccess.insert("[FleetDB].[dbo].[VoidItems]", "[Item], [Date]", "N'" + item + "', cast(getdate() as date)");

            //Session["SITEPQ_ID"] = id;
            //Response.Redirect("secondpage.aspx?id="+id);
            //Response.Redirect(ck.http() + Request["HTTP_HOST"] + "/CST/Manage_site.aspx");
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + Message + "')", true);
        loadSelectedTable();
        return;
    }

    // Data load

    protected void loadSelectedTable()
    {
        String dataBaseTable = "[FleetDB].[dbo].[DailyTablesOrders]";
        String tableId = TableID;

        String cols = "SUM([ItemQuantity]) as 'Qty',[Item],SUM([ItemTotal]) as 'Total'";
        DataSet dbFetch = dataAccess.seleccct(cols, dataBaseTable, "[TableId]=" + tableId + " GROUP BY [TableId], [Item]");

        if (dbFetch.Tables[0].Rows.Count > 0)
        {
            tableViewRptr.DataSource = dbFetch.Tables[0];
            tableViewRptr.DataBind();
            //foreach (DataRow dr in dbFetch.Tables[0].Rows)
            //{
            //    Item temp = new Item();
            //    temp.Name = dr[0].ToString() + "X " + dr[1].ToString();
            //    temp.Price = dr[2].ToString();
            //    t.Add(temp);
            //}
        }
        else
        {
            tableViewRptr.DataSource = "";
            tableViewRptr.DataBind();
        }
    }

    public bool alreadySubmitted(String shiftID, String officer)
    {
        DataTable checkIFDT = dataAccess.seleccct("[Shift],[OfficerNum]", "[FleetDB].[dbo].[OfficerTables]", "[Shift]='" + shiftID + "' and [OfficerNum]='" + officer + "'").Tables[0];

        if (checkIFDT.Rows.Count > 0)
        {
            //Already Submited
            return true;
        }
        else
        {
            //Not Submited
            return false;
        }
    }

    public void loadOfficerShifts(String Officer)
    {
        DataSet ds2 = dataAccess.seleccct("[ShiftId], convert(varchar(10),CS.[Date],103) as 'Date'", "[FleetDB].[dbo].[BackupTablesOrders] as BO inner join [FleetDB].[dbo].[CashierShift] as CS on BO.ShiftId = CS.Id", "BO.[TableNumber]='" + Officer + "' Group By [ShiftId],CS.[Date]");
        //dateDrop.DataSource = ds2;
        //dateDrop.DataTextField = "Date";
        //dateDrop.DataValueField = "ShiftId";
        //dateDrop.DataBind();
        //dateDrop.Items.Insert(0, "اختار التاريخ");
    }

    protected void showTableForOfficer(DataSet ds)
    {

        DataTable dt = ds.Tables[0];
        DataTable showDT = dt.Copy();
        showDT.Columns.Add("ItemID");
        showDT.Columns.Add("Hosp");
        showDT.Columns.Add("Total");
        foreach (DataRow dr in dt.Rows)
        {
            String amount = dr["Amount"].ToString();
            String itemName = dr["item"].ToString();
            String itemID = getItemID(itemName);
            String itemCost = (double.Parse(amount) * getItemCost(itemID)) + "";

            int rowNum = dt.Rows.IndexOf(dr);
            showDT.Rows[rowNum]["ItemID"] = itemID;
            showDT.Rows[rowNum]["Hosp"] = "False";
            showDT.Rows[rowNum]["Total"] = itemCost;
        }
        //costViewRptr.DataSource = showDT;
    }

    // Helper methods

    public static string getNewTotal(int newQun, string item)
    {
        DataSet ds = dataAccess.seleccct("[Price]", "[FleetDB].[dbo].[Menu]", "[Name]=N'" + item + "'");
        if (ds.Tables.Count > 0)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                double price = double.Parse(ds.Tables[0].Rows[0][0].ToString());
                //Debug.WriteLine("price of item " + item + " is " + price);
                double newTotal = price * newQun;
                return to2DecimalPlaces(newTotal) + "";

            }
        }

        return 0 + "";
    }

    public static double to2DecimalPlaces(double num)
    {
        //return Math.Round(num, 2);
        return Math.Floor(num * Math.Pow(10, 2)) / Math.Pow(10, 2);
    }

    public static int getItemPort(String item)
    {
        int port = 1;

        try
        {
            String ports = dataAccess.seleccct("[Ports]", "[FleetDB].[dbo].[Menu]", "[Name]=N'" + item + "'").Tables[0].Rows[0][0].ToString();
            port = Int32.Parse(ports);
        }
        catch (Exception)
        {

            //throw;
        }

        return port;
    }

    protected String getItemID(String itemName)
    {
        DataTable dt = dataAccess.seleccct("[Id]", "[FleetDB].[dbo].[Menu]", "[Name]=N'" + itemName + "'").Tables[0];
        return dt.Rows[0][0].ToString();
    }

    protected double getItemCost(String itemID)
    {
        double indirectCost = 0;

        try
        {
            indirectCost = double.Parse(dataAccess.seleccct("[IndirectCost]", "[FleetDB].[dbo].[Menu]", "[Id]='" + itemID + "'").Tables[0].Rows[0][0].ToString());
        }
        catch (Exception exx) { }

        String columns = "ROW_NUMBER() OVER(ORDER BY C.Name ASC) AS RowNumber,C.[Name] As 'اسم المكون', R.[Quantity] As 'الكمية',C.[Type] as 'Type', C.[Subtype] As 'تجزئه',C.[LastPrice], P.[Name] as 'المنفذ' , R.[id] as 'RID'";
        String table = "[FleetDB].[dbo].[Recipe] as R inner join [FleetDB].[dbo].[Card] as C on R.CardID = C.id inner join [FleetDB].[dbo].[Port] as P on P.id = R.PortID";
        String condition = "R.[ItemID]=" + itemID;
        DataSet ds = dataAccess.seleccct(columns, table, condition);
        if (ds.Tables.Count > 0)
        {
            DataTable dt = ds.Tables[0];
            DataColumn col = new DataColumn("Cost");
            dt.Columns.Add(col);
            double costTotal = 0;
            foreach (DataRow dr in dt.Rows)
            {
                String Type = dr["Type"].ToString();
                String SubType = dr["تجزئه"].ToString();
                String AmountStr = dr["الكمية"].ToString();
                String LastPriceStr = dr["LastPrice"].ToString();

                try
                {
                    double amount = double.Parse(AmountStr);//200 gm
                    String QunStr = dataAccess.seleccct("[QunTypeToSubtype]", "[FleetDB].[dbo].[CardType]", "[Type]=N'" + Type + "' and [Subtype]=N'" + SubType + "'").Tables[0].Rows[0][0].ToString();
                    double qun = double.Parse(QunStr);//1000 gm

                    //GET Price then Divide by 1000 to get a single gm price then multiply that by 200
                    double lastPrice = double.Parse(LastPriceStr);
                    double finalPrice = (lastPrice / qun) * amount;
                    finalPrice = roundNum(finalPrice);
                    dr["Cost"] = finalPrice;
                    costTotal += finalPrice;
                }
                catch (Exception)
                {
                    dr["Cost"] = 0;
                }
            }

            return costTotal + indirectCost;
        }



        return 0;
    }

    public bool isValidForm()
    {

        foreach (RepeaterItem item in tableViewRptr.Items)
        {
            CheckBox taklfaChk = (CheckBox)item.FindControl("tklfa");
            CheckBox deyafa = (CheckBox)item.FindControl("deyafa");
            HtmlTableCell itemNameTC = (HtmlTableCell)item.FindControl("itemName");
            String name = itemNameTC.InnerHtml.Replace("\r\n", "").Replace("   ", "");

            if ((taklfaChk.Checked && deyafa.Checked) || (!taklfaChk.Checked && !deyafa.Checked))
            {
                String message = " من فضلك ادخل صحيحاً لمنتج : " + name;
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
                return false;
            }
        }
        return true;
    }

    public static String insertDBDateObj(object thedateCell)
    {
        try
        {
            String date = ((DateTime)(thedateCell)).ToString("d/M/yyyy h:m:ss tt");
            DateTime dt = DateTime.ParseExact(date, "d/M/yyyy h:m:ss tt", CultureInfo.InvariantCulture);
            return "'" + dt.ToString("yyyy-MM-dd HH:mm:ss") + "'";
        }
        catch (Exception)
        {
            return "'" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'";
        }

    }

    protected double roundNum(double amount)
    {
        return Math.Round(amount, 3);
    }

    public void updateTableTotal(String tableID)
    {
        DataTable dt = dataAccess.seleccct("SUM([ItemTotal])", "[FleetDB].[dbo].[DailyTablesOrders]", "[TableId]=" + tableID + " GROUP BY [TableId]").Tables[0];

        String subtotalSTR = "0";

        if (dt.Rows.Count == 0)
        {
            subtotalSTR = "0";
        }
        else
        {
            subtotalSTR = dt.Rows[0][0].ToString();
        }



        double subtotal = double.Parse(subtotalSTR);

        String dataBaseTable = "[FleetDB].[dbo].[DailyTables]";
        String cols = "[Tax],[Discount],[Total]";
        DataSet dbFetch = dataAccess.seleccct(cols, dataBaseTable, "[Id]=" + tableID);

        if (dbFetch.Tables[0].Rows.Count > 0)
        {
            DataRow theTable = dbFetch.Tables[0].Rows[0];
            int tax = int.Parse(theTable[0].ToString());
            int discount = int.Parse(theTable[1].ToString());

            double newSubTax = (tax * 0.01) * subtotal;

            double newSubDiscount = (discount * 0.01) * subtotal;

            double newTotal = subtotal + newSubTax;

            newTotal = newTotal - newSubDiscount;

            dataAccess.Update(dataBaseTable, "[Subtotal]=" + to2DecimalPlaces(subtotal) + ", [Subtax] = " + to2DecimalPlaces(newSubTax) + ", [Subdiscount] = " + to2DecimalPlaces(newSubDiscount) + ", [Total] = " + to2DecimalPlaces(newTotal), "[Id]=" + tableID);
        }
    }

    protected void checkPortSubmissionForReturn(String rowID)
    {
        DataTable ordersportID_DT = dataAccess.seleccct("[Port],[Item]", "[FleetDB].[dbo].[OrdersPort]", "[Id]='" + rowID + "' and [Done] is not null").Tables[0];

        if (ordersportID_DT.Rows.Count > 0)
        {
            String portID = ordersportID_DT.Rows[0][0].ToString();
            String itemName = ordersportID_DT.Rows[0][1].ToString();
            returnRecipeToPort(itemName, 1, portID);
        }
    }

    protected void returnRecipeToPort(String itemName, int Qun, String portID)
    {
        int itemId = int.Parse(dataAccess.seleccct("[Id]", "[FleetDB].[dbo].[Menu]", "[Name]=N'" + itemName + "'").Tables[0].Rows[0][0].ToString());
        DataTable itemRecepie = dataAccess.seleccct("[CardID],[Quantity],C.[Name] as 'Name'", "[FleetDB].[dbo].[Recipe] as R inner join [FleetDB].[dbo].[Card] as C on R.CardID =C.id", "[ItemID]='" + itemId + "' and [PortID]='" + portID + "'").Tables[0];
        foreach (DataRow dr in itemRecepie.Rows)
        {
            String theCardID = dr[0].ToString();
            double recepieQun = double.Parse(dr[1].ToString());
            String theCardName = dr[2].ToString();
            DataTable Stockdt = dataAccess.seleccct("[Stock]", "[FleetDB].[dbo].[PortsStore]", "[CardID]='" + theCardID + "' and [PortID]='" + portID + "'").Tables[0];
            if (Stockdt.Rows.Count > 0)
            {
                double stock = double.Parse(Stockdt.Rows[0][0].ToString());
                double newStock = stock + (recepieQun * Qun);
                dataAccess.Update("[FleetDB].[dbo].[PortsStore]", "[Stock]=" + newStock, "[CardID]='" + theCardID + "' and [PortID]='" + portID + "'");
            }
            else
            {
                dataAccess.insert("[FleetDB].[dbo].[PortsStore]", "[CardID],[Stock],[PortID]", "'" + theCardID + "','" + (recepieQun * Qun) + "','" + portID + "'");
            }
        }        
    }
}
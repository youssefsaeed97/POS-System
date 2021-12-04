using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Events_Falandara : System.Web.UI.Page
{
    public static ADO dataacess = new ADO();
    public static int fixedTax = 0;
    public String user = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            try
            {
                user = Session["userName"].ToString();
            } catch
            {
                user = "";
            }

            LoadDropDowns();
            Clear();
        }
    }

    protected void Submit(object sender, System.EventArgs e)
    {
        String validity = ValidityOfForm();

        if (validity != "True")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + validity + "')", true);

            ClearAll();

            TripDetails.Visible = false;

            return;
        }

        String tblTrips = "[FleetDB].[dbo].[FalandaraTrips]";
        String colTrips = "[DateTime]";
        String valTrips = "'" + txtDateTime.Text + "'";

        dataacess.insert(tblTrips, colTrips, valTrips);

        LoadDropDowns();
        ClearAll();
        TripDetails.Visible = false;
    }

    // action buttons

    protected void ViewSelectedTrip(object sender, System.EventArgs e)
    {
        LoadDecksDetails();

        TripDetails.Visible = true;
        reservationView.Visible = false;

        Clear();
    }

    protected void AddReservation(object sender, System.EventArgs e)
    {
        Button btn = (Button)sender;

        String deckNum;

        if (btn.ID == "btnPlusDeck1")
        {
            deckNum = "1";
        } else
        {
            deckNum = "2";
        }

        reservationDetails.Attributes["src"] = "FalandaraReservationDetails.aspx?edit=0&datetime=" + ddlDateTime.SelectedItem.ToString() + "&deck=" + deckNum + "&tableID=0&tripID=" + ddlDateTime.SelectedValue;

        TripDetails.Visible = false;
        reservationView.Visible = true;
        Clear();
    }

    protected void ViewReservation(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;

        String deckNum;

        if (ddl.ID == "ddlDeck1")
        {
            deckNum = "1";
        }
        else
        {
            deckNum = "2";
        }

        reservationDetails.Attributes["src"] = "FalandaraReservationDetails.aspx?edit=1&datetime=" + ddlDateTime.SelectedItem.ToString() + "&deck=" + deckNum + "&tableID=" + ddl.SelectedValue + "&tripID=" + ddlDateTime.SelectedValue;

        TripDetails.Visible = false;
        reservationView.Visible = true;
        Clear();
    }

    protected void CloseForm(object sender, System.EventArgs e)
    {
        LoadDecksDetails();

        TripDetails.Visible = true;
        reservationView.Visible = false;

        Clear();
    }
    
    //PENDING - subtract when submitted
    protected void SubmitTrip(object sender, System.EventArgs e)
    {
        DataTable tripNums = dataacess.seleccct("[Number]", "[FleetDB].[dbo].[DailyTables]", "[Number] BETWEEN 6001 AND 6010 ORDER BY [Number] DESC").Tables[0];

        int tripNum;

        if (tripNums.Rows.Count > 0)
        {
            tripNum = int.Parse(tripNums.Rows[0][0].ToString()) + 1;
        } else
        {
            tripNum = 6001;
        }

        addnewTable(tripNum, user);

        String colMT = "FTO.[TableID] as TableID, SUM(FTO.[Persons]) AS TotalMeals, M.[Name] AS Meal, M.[Price] as Price, FT.[DiscountPrcnt] as Discount";
        String tblMT = "[FleetDB].[dbo].[FalandaraTableOrders] AS FTO inner join [FleetDB].[dbo].[Menu] AS M ON FTO.[MealID] = M.[Id] inner join [FleetDB].[dbo].[FalandaraTables] AS FT on FT.[TableID] = FTO.[TableID]";
        String condMT = "FT.[TripID] = " + ddlDateTime.SelectedValue + " GROUP BY M.[Name], M.[Price], FTO.[TableID], FT.[DiscountPrcnt]";

        DataTable dtTotals = dataacess.seleccct(colMT, tblMT, condMT).Tables[0];

        foreach (DataRow dr in dtTotals.Rows)
        {
            int itemQun = int.Parse(dr["TotalMeals"].ToString());

            String itemName = dr["Meal"].ToString();

            double itemPrice = double.Parse(dr["Price"].ToString());

            double dscnt = double.Parse(dr["Discount"].ToString());

            // used to send the proper amount

            //double total = itemQun * itemPrice;

            //double totalPrice = total - ((dscnt/100)*total);

            // sending the total amount of falandara as 0 for the sake of accounting issues

            double totalPrice = 0;

            addItemTable(itemQun, tripNum, itemName, totalPrice);
        }

        submitTable(tripNum);

        dataacess.Update("[FleetDB].[dbo].[FalandaraTrips]", "[Submit] = 'True'", "[TripID] = " + ddlDateTime.SelectedValue);

        LoadDropDowns();

        TripDetails.Visible = false;
    }

    protected void PrintTrip(object sender, System.EventArgs e)
    {
        Response.Write("<script>window.open ('FalandaraSituation.aspx?datetime=" + ddlDateTime.SelectedItem.ToString() + "&tripID=" + ddlDateTime.SelectedValue + "','_blank');</script>");

        LoadDropDowns();

        TripDetails.Visible = false;
    }

    protected void DeleteTrip(object sender, System.EventArgs e)
    {
        List<String> tblIDs = new List<string>();

        String tripID = ddlDateTime.SelectedValue;

        String message = "Table deleted successfully";

        String tblTrips = "[FleetDB].[dbo].[FalandaraTrips]";
        String tblTables = "[FleetDB].[dbo].[FalandaraTables]";
        String tblOrders = "[FleetDB].[dbo].[FalandaraTableOrders]";

        DataTable dt = dataacess.seleccct("[TableID]", tblTables, "[TripID] = " + tripID).Tables[0];

        foreach (DataRow dr in dt.Rows)
        {
            tblIDs.Add(dr[0].ToString());
        }

        if (tblIDs.Count != 0)
        {
            String sqlTblIDs = string.Join(",", tblIDs);

            dataacess.delete(tblOrders, "[TableID] IN (" + sqlTblIDs + ")");

            dataacess.delete(tblTables, "[TripID]=" + tripID);
        }

        dataacess.delete(tblTrips, "[TripID]=" + tripID);
        
        LoadDropDowns();

        TripDetails.Visible = false;

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    // load details

    public void LoadDecksDetails()
    {
        DataTable deck1Details =  dataacess.seleccct("FT.[TableID] as tableID, FT.[Persons] as Persons, FC.[Name] as name", "[FleetDB].[dbo].[FalandaraTables] as FT inner join [FleetDB].[dbo].[FalandaraClients] as FC on FT.[ClientID] = FC.[ClientID]", "FT.[TripID] = " + ddlDateTime.SelectedValue + "and FT.[Deck] = 1").Tables[0];

        ddlDeck1.DataSource = deck1Details;
        ddlDeck1.DataTextField = "name";
        ddlDeck1.DataValueField = "tableID";
        ddlDeck1.DataBind();
        ddlDeck1.Items.Insert(0, "Select:");
        ddlDeck1.Items[0].Selected = true;
        ddlDeck1.Items[0].Attributes["disabled"] = "disabled";

        DataTable deck2Details = dataacess.seleccct("FT.[TableID] as tableID, FT.[Persons] as Persons, FC.[Name] as name", "[FleetDB].[dbo].[FalandaraTables] as FT inner join [FleetDB].[dbo].[FalandaraClients] as FC on FT.[ClientID] = FC.[ClientID]", "FT.[TripID] = " + ddlDateTime.SelectedValue + "and FT.[Deck] = 2").Tables[0];

        ddlDeck2.DataSource = deck2Details;
        ddlDeck2.DataTextField = "name";
        ddlDeck2.DataValueField = "tableID";
        ddlDeck2.DataBind();
        ddlDeck2.Items.Insert(0, "Select:");
        ddlDeck2.Items[0].Selected = true;
        ddlDeck2.Items[0].Attributes["disabled"] = "disabled";

        String tbls1 = deck1Details.Rows.Count.ToString();
        String prsns1 = deck1Details.Compute("Sum(Persons)", string.Empty).ToString();
        if (prsns1 == "") { prsns1 = "0"; }

        String tbls2 = deck2Details.Rows.Count.ToString();
        String prsns2 = deck2Details.Compute("Sum(Persons)", string.Empty).ToString();
        if (prsns2 == "") { prsns2 = "0"; }

        String tbls = (int.Parse(tbls1) + int.Parse(tbls2)).ToString();
        String prsns = (int.Parse(prsns1) + int.Parse(prsns2)).ToString();

        lblTbls1.Text = "Tables: " + tbls1;
        lblPrsns1.Text = "/ Persons: " + prsns1;

        lblTbls2.Text = "Tables: " + tbls2;
        lblPrsns2.Text = "/ Persons: " + prsns2;

        lblTbls.Text = "Tables: " + tbls;
        lblPrsns.Text = "/ Persons: " + prsns; ;
    }

    public void LoadDropDowns()
    {
        DataTable trips = dataacess.seleccct("[TripID], [DateTime]", "[FleetDB].[dbo].[FalandaraTrips]", "[Submit] = 'False' ORDER BY [DateTime] ASC").Tables[0];

        ddlDateTime.DataSource = trips;
        ddlDateTime.DataTextField = "DateTime";
        ddlDateTime.DataValueField = "TripID";
        ddlDateTime.DataBind();
        ddlDateTime.Items.Insert(0, "Select:");
        ddlDateTime.Items[0].Selected = true;
        ddlDateTime.Items[0].Attributes["disabled"] = "disabled";
    }

    // supplementary functions

    public void Clear()
    {
        txtDateTime.Text = "";

        ddlDateTime.Items[0].Attributes["disabled"] = "disabled";
    }

    public void ClearAll ()
    {
        txtDateTime.Text = "";

        ddlDateTime.SelectedItem.Selected = false;

        ddlDateTime.Items[0].Selected = true;

        ddlDateTime.Items[0].Attributes["disabled"] = "disabled";
    }

    public string ValidityOfForm()
    {
        CultureInfo culture = new CultureInfo("en-US");

        

        if (txtDateTime.Text == "")
        {
            return "Please select a timestamp.";
        } else
        {
            try
            {
                DateTime tempDate = Convert.ToDateTime(txtDateTime.Text, culture);

                if (tempDate <= DateTime.Now)
                {
                    return "Please select an upcoming timestamp.";

                } else
                {
                    DataTable trip =  dataacess.seleccct("[TripID]", "[FleetDB].[dbo].[FalandaraTrips]", "[DateTime] = '" + tempDate + "'").Tables[0];

                    if (trip.Rows.Count == 0)
                    {
                        return "True";

                    } else
                    {
                        return "Trip already exists.";
                    }
                }
            }
            catch (Exception)
            {
                return "Please select a valid timestamp.";
            }
        }
    }

    // recipe deduction functions

    public static void addnewTable(int number, string userName)
    {
        String user = userName;
        
        String dataBaseTable = "[FleetDB].[dbo].[DailyTables]";
        String tableId = getOpenTableId(number) + "";
        String condition = "[Number] = " + number + " and [Id]=" + tableId;
        DataSet dbFetch = dataacess.seleccct(dataBaseTable, condition);

        if (dbFetch.Tables.Count > 0)
        {
            if (dbFetch.Tables[0].Rows.Count > 0)
            {
                //Table already exists
                return;
            }
        }

        try
        {
            dataacess.insert(dataBaseTable, number + ", " + "0," + fixedTax + ",0,0,0,0, '" + user + "', CURRENT_TIMESTAMP,0,null,null");
            condition = "[Number]=" + number + " and [Cashed]=0";
            String tableID = dataacess.seleccct("[TableID]", dataBaseTable, condition).Tables[0].Rows[0][0].ToString();


        }
        catch (Exception)
        {
            Console.Write("Failed To Insert Table ");
            //throw;
        }
    }

    public static void addItemTable(int qun, int number, String item, double itemTotal)
    {
        String dataBaseTable = "[FleetDB].[dbo].[DailyTablesOrders]";
        int tableID = getOpenTableId(number);
        int ports = getItemPort(item);
        String cols = "[TableNumber],[TableId],[Item],[ItemQuantity],[ItemTotal],[Port],[Pickup],[Submit]";
        String values = number + "," + tableID + ",N'" + item + "'," + qun + "," + itemTotal + "," + ports + ",null,0";
        dataacess.insert(dataBaseTable, cols, values);
        updateTableTotal(tableID);


        String dataBaseTable2 = "[FleetDB].[dbo].[OrdersPort]";
        String cols2 = "[TableNumber],[TableId],[Item],[ItemQuantity],[Port],[Submit],[SubmitTime],[Working],[Done],[Waiter],[DoneShow]";
        if (ports > 9)
        {
            String portsStr = ports + "";

            foreach (Char c in portsStr)
            {
                String values2 = number + "," + tableID + ",N'" + item + "'," + qun + "," + c + ",0,null,null,null,null,null";
                dataacess.insert(dataBaseTable2, cols2, values2);
            }
        }
        else
        {
            String values2 = number + "," + tableID + ",N'" + item + "'," + qun + "," + ports + ",0,null,null,null,null,null";
            dataacess.insert(dataBaseTable2, cols2, values2);
        }
    }

    public static void submitTable(int number)
    {
        String dataBaseTable = "[FleetDB].[dbo].[DailyTablesOrders]";
        int tableID = getOpenTableId(number);
        dataacess.Update(dataBaseTable, "[Submit]=1", "[TableId]=" + tableID);
        dataacess.Update("[FleetDB].[dbo].[OrdersPort]", "[Submit]=1, [SubmitTime]=CURRENT_TIMESTAMP", "[TableId]=" + tableID + " and [Submit]=0");
    }

    public static int getOpenTableId(int tableNumber)
    {
        int id = 0;

        try
        {
            String tableId = dataacess.seleccct("[Id]", "[FleetDB].[dbo].[DailyTables]", "[Number]=" + tableNumber + " and [Cashed]=0").Tables[0].Rows[0][0].ToString();
            id = Int32.Parse(tableId);
        }
        catch (Exception)
        {
            
            //throw;
        }

        return id;
    }

    public static void updateTableTotal(int tableID)
    {
        DataTable dt = dataacess.seleccct("SUM([ItemTotal])", "[FleetDB].[dbo].[DailyTablesOrders]", "[TableId]=" + tableID + " GROUP BY [TableId]").Tables[0];

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
        DataSet dbFetch = dataacess.seleccct(cols, dataBaseTable, "[Id]=" + tableID);

        if (dbFetch.Tables[0].Rows.Count > 0)
        {
            DataRow theTable = dbFetch.Tables[0].Rows[0];
            int tax = int.Parse(theTable[0].ToString());
            int discount = int.Parse(theTable[1].ToString());

            double newSubTax = (tax * 0.01) * subtotal;

            double newSubDiscount = (discount * 0.01) * subtotal;

            double newTotal = subtotal + newSubTax;

            newTotal = newTotal - newSubDiscount;

            dataacess.Update(dataBaseTable, "[Subtotal]=" + to2DecimalPlaces(subtotal) + ", [Subtax] = " + to2DecimalPlaces(newSubTax) + ", [Subdiscount] = " + to2DecimalPlaces(newSubDiscount) + ", [Total] = " + to2DecimalPlaces(newTotal), "[Id]=" + tableID);
        }
    }

    public static int getItemPort(String item)
    {
        int port = 1;

        try
        {
            String ports = dataacess.seleccct("[Ports]", "[FleetDB].[dbo].[Menu]", "[Name]=N'" + item + "'").Tables[0].Rows[0][0].ToString();
            port = Int32.Parse(ports);
        }
        catch (Exception)
        {

            //throw;
        }

        return port;
    }

    public static double to2DecimalPlaces(double num)
    {
        //return Math.Round(num, 2);
        return Math.Floor(num * Math.Pow(10, 2)) / Math.Pow(10, 2);
    }

}
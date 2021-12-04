using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Events_FalandaraReservationDetails : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        //CheckUserSession();

        if (!Page.IsPostBack)
        {
            LoadChecks();

            String edit = Request.QueryString["edit"];

            if (edit == "0")
            {
                btnSubmit.Attributes["enabled"] = "enabled";
                btnUpdate.Attributes["disabled"] = "disabled";
                btnDelete.Attributes["disabled"] = "disabled";

            } else if (edit == "1")
            {
                ViewToEdit();
                btnSubmit.Attributes["disabled"] = "disabled";
                btnUpdate.Attributes["enabled"] = "enabled";
                btnDelete.Attributes["enabled"] = "enabled";
            }
        }
    }

    protected void CheckUserSession()
    {
        try
        {
            String userType = Session["userType"].ToString();

            if (userType != "Events")
            {
                Response.Redirect("../Login.aspx");
            }
        }
        catch (Exception)
        {

            Response.Redirect("../Login.aspx");
        }
    }

    public void LoadChecks()
    {
        DataSet meals = dataAccess.seleccct("[Id] as MealID, [Name] as Meal, [Price]", "[FleetDB].[dbo].[Menu]", "[GroupId] = 2002");

        rptrMeals.DataSource = meals;
        rptrMeals.DataBind();
    }

    // Action methods

    protected void SubmitTable(object sender, System.EventArgs e)
    {
        String validityOfForm = IsValidForm();

        String message;
        String msg = "";

        if (validityOfForm != "Valid")
        {
            message = validityOfForm;

        }
        else
        {
            String tblClients = "[FleetDB].[dbo].[FalandaraClients]";
            String tblTables = "[FleetDB].[dbo].[FalandaraTables]";
            String tblOrders = "[FleetDB].[dbo].[FalandaraTableOrders]";

            String colClients = "[Rank],[Name],[PhoneNumber],[Email]";
            String colTables = "[TripID],[Deck],[Date],[Persons],[TotalPrice],[Deposit],[ClientID],[DiscountPrcnt]";
            String colOrders = "[TableID],[Persons],[MealID],[Comment]";

            DataTable clientChk = dataAccess.seleccct("*", tblClients, "[Rank] = N'" + inputRank.Text + "' and [Name] = N'" + inputName.Text + "' and [PhoneNumber] = '" + inputPhoneNumber.Text + "'").Tables[0];

            int clientID;

            if (inputID.Text == "" && clientChk.Rows.Count == 0)
            {
                String valClients = "N'" + inputRank.Text + "',N'" + inputName.Text + "','" + inputPhoneNumber.Text + "','" + inputEmail.Text + "'";

                dataAccess.insert(tblClients, colClients, valClients);

                clientID = int.Parse(dataAccess.seleccct("SELECT TOP 1 [ClientID] FROM [FleetDB].[dbo].[FalandaraClients] ORDER BY [ClientID] DESC", 1).Tables[0].Rows[0]["ClientID"].ToString());

            }
            else
            {
                if (inputID.Text == "")
                {
                    msg = " (Hint: Client was already a member with [history = " + clientChk.Rows[0]["History"] + " ]).";

                    clientID = int.Parse(clientChk.Rows[0]["ClientID"].ToString());
                }
                else
                {
                    clientID = int.Parse(inputID.Text.ToString());
                }

                String clientSet = "[Rank] = N'" + inputRank.Text + "',[Name] = N'" + inputName.Text + "', [PhoneNumber] = '" + inputPhoneNumber.Text + "'";

                if (inputEmail.Text != "")
                {
                    clientSet += ", [Email] = '" + inputEmail.Text + "'";
                }

                int tblCount = dataAccess.seleccct("[TableID]", tblTables, "[TripID]=" + hdnTripID.Value + " and [ClientID]=" + clientID).Tables[0].Rows.Count;

                if (tblCount == 0)
                {
                    clientSet += ", [History] = [History] + 1";
                }

                dataAccess.Update(tblClients, clientSet, "[ClientID] = " + clientID);
            }

            message = "Table submitted successfully for client ID " + clientID.ToString() + msg;

            String valTables = hdnTripID.Value + "," + hdnDeck.Value + ",CAST( GETDATE() AS Date )," + hdnTotalPersons.Value + "," + hdnTotal.Value + ",'" + inputDeposit.Text + "'," + clientID + "," + hdnDiscount.Value;

            dataAccess.insert(tblTables, colTables, valTables);

            var rptr = (FindControl("rptrMeals") as Repeater);

            int tableID = int.Parse(dataAccess.seleccct("SELECT TOP 1 [TableID] FROM [FleetDB].[dbo].[FalandaraTables] ORDER BY [TableID] DESC", 1).Tables[0].Rows[0]["TableID"].ToString());

            foreach (RepeaterItem item in rptr.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    if ((item.FindControl("rptrCheckMeals") as CheckBox).Checked)
                    {
                        String orderQnt = ((HtmlInputText)item.FindControl("rptrQuantityMeals")).Value;
                        String mealID = (item.FindControl("rptrhdnNumMeals") as HiddenField).Value;
                        String comment = ((HtmlInputText)item.FindControl("rptrCommentMeals")).Value;

                        if (comment == "") { comment = "."; }

                        String valOrders = tableID + "," + orderQnt + "," + mealID + ",N'" + comment + "'";

                        dataAccess.insert(tblOrders, colOrders, valOrders);
                    }
                }
            }

            ClearAll();
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    public void ViewToEdit()
    {

        DataRow table;

        String tableID = Request.QueryString["tableID"];

        DataTable tbltable = dataAccess.seleccct("[TableID],[TripID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]", "[FleetDB].[dbo].[FalandaraTables]", "[TableID]=" + tableID).Tables[0];

        if (tbltable.Rows.Count == 0)
        {
            return;
        }

        table = tbltable.Rows[0];

        String clientID = table["ClientID"].ToString();

        DataRow client = dataAccess.seleccct("*", "[FleetDB].[dbo].[FalandaraClients]", "[ClientID]=" + clientID).Tables[0].Rows[0];

        inputID.Text = clientID;
        inputPhoneChk.Text = client["PhoneNumber"].ToString();
        inputRank.Text = client["Rank"].ToString();
        inputName.Text = client["Name"].ToString();
        inputPhoneNumber.Text = client["PhoneNumber"].ToString();
        inputEmail.Text = client["Email"].ToString();
        staticHistory.Text = client["History"].ToString();
        staticTotal.Text = table["TotalPrice"].ToString();
        staticTotalPersons.Text = table["Persons"].ToString();
        inputDeposit.Text = table["Deposit"].ToString();
        staticRemainingBalance.Text = (double.Parse(table["TotalPrice"].ToString()) - double.Parse(table["Deposit"].ToString())).ToString();

        var rptr = (FindControl("rptrMeals") as Repeater);

        DataTable orders = dataAccess.seleccct("*", "[FleetDB].[dbo].[FalandaraTableOrders]", "[TableID]=" + table["TableID"].ToString()).Tables[0];

        List<String> mealIDs = new List<string>();

        foreach (DataRow dr in orders.Rows)
        {
            mealIDs.Add(dr["MealID"].ToString());
        }

        foreach (RepeaterItem item in rptr.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                String mealID = (item.FindControl("rptrhdnNumMeals") as HiddenField).Value;

                if (mealIDs.Contains(mealID))
                {
                    (item.FindControl("rptrCheckMeals") as CheckBox).Checked = true;
                    ((HtmlInputText)item.FindControl("rptrQuantityMeals")).Value = orders.Select("[MealID]=" + mealID)[0]["Persons"].ToString();
                    ((HtmlInputText)item.FindControl("rptrCommentMeals")).Value = orders.Select("[MealID]=" + mealID)[0]["Comment"].ToString();
                }
            }
        }

        btnSubmit.Attributes["disabled"] = "true";
        inputID.Attributes["ReadOnly"] = "true";
        inputPhoneChk.Attributes["ReadOnly"] = "true";

    }

    protected void UpdateTable(object sender, System.EventArgs e)
    {
        DataTable tbltable;
        DataRow table;

        tbltable = dataAccess.seleccct("[TableID],[TripID],[Persons],[TotalPrice],[Deposit],[ClientID],[DiscountPrcnt]", "[FleetDB].[dbo].[FalandaraTables]", "[TableID]=" + hdnTableID.Value).Tables[0];

        if (tbltable.Rows.Count == 0)
        {
            return;
        }

        table = tbltable.Rows[0];

        String validityOfForm = IsValidForm();

        String message;

        if (validityOfForm != "Valid")
        {
            message = validityOfForm;
        }
        else
        {
            message = "Table updated successfully";

            String tableID = tbltable.Rows[0]["TableID"].ToString();

            String clientID = tbltable.Rows[0]["ClientID"].ToString();

            String tblClients = "[FleetDB].[dbo].[FalandaraClients]";
            String tblTables = "[FleetDB].[dbo].[FalandaraTables]";
            String tblOrders = "[FleetDB].[dbo].[FalandaraTableOrders]";

            String setClient = "[Rank] = N'" + inputRank.Text + "',[Name] = N'" + inputName.Text + "', [PhoneNumber] = '" + inputPhoneNumber.Text + "', [Email] = '" + inputEmail.Text + "'";
            String setTables = "[Date]=CAST( GETDATE() AS Date ),[Persons]=" + hdnTotalPersons.Value + ",[TotalPrice]=" + hdnTotal.Value + ",[Deposit]=" + inputDeposit.Text + ",[DiscountPrcnt]=" + hdnDiscount.Value;
            String colOrders = "[TableID],[Persons],[MealID],[Comment]";

            dataAccess.Update(tblClients, setClient, "[ClientID] = " + clientID);
            dataAccess.Update(tblTables, setTables, "[TableID]=" + tableID);

            dataAccess.delete(tblOrders, "[TableID]=" + tableID);

            var rptr = (FindControl("rptrMeals") as Repeater);

            foreach (RepeaterItem item in rptr.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    if ((item.FindControl("rptrCheckMeals") as CheckBox).Checked)
                    {
                        String orderQnt = ((HtmlInputText)item.FindControl("rptrQuantityMeals")).Value;
                        String mealID = (item.FindControl("rptrhdnNumMeals") as HiddenField).Value;
                        String comment = ((HtmlInputText)item.FindControl("rptrCommentMeals")).Value;

                        if (comment == "") { comment = "."; }

                        String valOrders = tableID + "," + orderQnt + "," + mealID + ",N'" + comment + "'";

                        dataAccess.insert(tblOrders, colOrders, valOrders);
                    }
                }
            }

            ClearAll();

            btnSubmit.Attributes["disabled"] = "true";
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    protected void DeleteTable(object sender, System.EventArgs e)
    {
        String message = "Table deleted successfully";

        DataTable tbltable;
        DataRow table;

        tbltable = dataAccess.seleccct("[TableID],[TripID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID],[DiscountPrcnt]", "[FleetDB].[dbo].[FalandaraTables]", "[TableID]=" + hdnTableID.Value).Tables[0];

        if (tbltable.Rows.Count == 0)
        {
            return;
        }

        table = tbltable.Rows[0];

        String tableID = tbltable.Rows[0]["TableID"].ToString();
        String tripID = tbltable.Rows[0]["TripID"].ToString();
        String clientID = tbltable.Rows[0]["ClientID"].ToString();

        String tblTables = "[FleetDB].[dbo].[FalandaraTables]";
        String tblOrders = "[FleetDB].[dbo].[FalandaraTableOrders]";

        int tblCount = dataAccess.seleccct("[TableID]", tblTables, "[TripID]=" + tripID + " and [ClientID]=" + clientID).Tables[0].Rows.Count;

        if (tblCount == 1)
        {
            String tblClients = "[FleetDB].[dbo].[FalandaraClients]";

            String setClient = "[History] = [History] - 1";

            dataAccess.Update(tblClients, setClient, "[ClientID] = " + clientID);
        }

        dataAccess.delete(tblTables, "[TableID]=" + tableID);
        dataAccess.delete(tblOrders, "[TableID]=" + tableID);

        ClearAll();

        btnSubmit.Attributes["disabled"] = "true";

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    protected void ReviewClient(object sender, System.EventArgs e)
    {
        DataTable clientInfo = dataAccess.seleccct("[ClientID], [Rank] ,[Name], [PhoneNumber], [Email], [History]", "[FleetDB].[dbo].[FalandaraClients]", "[ClientID] = '" + inputID.Text + "' or [PhoneNumber] = '" + inputPhoneChk.Text + "'").Tables[0];

        String message;

        if (clientInfo.Rows.Count != 0)
        {
            inputID.Text = clientInfo.Rows[0]["ClientID"].ToString();
            inputPhoneChk.Text = clientInfo.Rows[0]["PhoneNumber"].ToString();
            inputRank.Text = clientInfo.Rows[0]["Rank"].ToString();
            inputName.Text = clientInfo.Rows[0]["Name"].ToString();
            inputPhoneNumber.Text = clientInfo.Rows[0]["PhoneNumber"].ToString();
            inputEmail.Text = clientInfo.Rows[0]["Email"].ToString();
            staticHistory.Text = clientInfo.Rows[0]["History"].ToString();

            inputID.Attributes["ReadOnly"] = "true";
            inputPhoneChk.Attributes["ReadOnly"] = "true";

        }
        else
        {
            inputID.Text = "";
            inputPhoneChk.Text = "";

            message = "Client not found.";

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
        }
    }

    // Helper methods

    public void ClearAll()
    {
        inputID.Text = "";
        inputPhoneChk.Text = "";
        inputRank.Text = "";
        inputName.Text = "";
        inputPhoneNumber.Text = "";
        inputEmail.Text = "";
        staticDeck.Text = "";
        staticTotalPersons.Text = "0";
        staticTotal.Text = "0";
        inputDeposit.Text = "0";
        inputDiscount.Text = "0";
        staticRemainingBalance.Text = "0";

        var rptr = (FindControl("rptrMeals") as Repeater);

        foreach (RepeaterItem item in rptr.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                (item.FindControl("rptrCheckMeals") as CheckBox).Checked = false;
                ((HtmlInputText)item.FindControl("rptrQuantityMeals")).Value = "0";
                ((HtmlInputText)item.FindControl("rptrCommentMeals")).Value = ".";
            }
        }

        btnUpdate.Attributes["disabled"] = "true";
        btnDelete.Attributes["disabled"] = "true";
    }

    public String IsValidForm()
    {
        // Form validation

        if (!IsNotEmpty(inputName.Text))
        {
            return "Please enter a name.";
        }
        if (!IsDouble(inputPhoneNumber.Text))
        {
            return "Please enter a valid phone number.";
        }
        if (!IsInt(hdnTotalPersons.Value))
        {
            return "Please enter a valid number of guests.";
        }
        if (!IsPrcnt(hdnDiscount.Value))
        {
            return "Please enter a valid discount percentage.";
        }

        var rptr = (FindControl("rptrMeals") as Repeater);

        int chkd = 0;

        foreach (RepeaterItem item in rptr.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                if ((item.FindControl("rptrCheckMeals") as CheckBox).Checked)
                {
                    chkd += 1;

                    var numOfMeals = ((HtmlInputText)item.FindControl("rptrQuantityMeals")).Value;

                    if (!IsInt(numOfMeals))
                    {
                        return "Please enter a valid number of meals.";
                    }
                }
            }
        }

        if (chkd == 0) { return "Please choose preferred meals"; }

        if (chkd != int.Parse(hdnNumOfChks.Value)) { return "Please uncheck unused meals."; }

        return "Valid";
    }

    public bool IsNotEmpty(String x)
    {
        if (String.IsNullOrEmpty(x) || String.IsNullOrWhiteSpace(x))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public bool IsDouble(String x)
    {
        double y;

        if (Double.TryParse(x, out y))
        {
            if (double.Parse(x) > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    public bool IsInt64(String x)
    {
        Int64 y;

        if (Int64.TryParse(x, out y))
        {
            if (double.Parse(x) > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    public bool IsInt(String x)
    {
        int y;

        if (int.TryParse(x, out y))
        {
            if (int.Parse(x) > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    public bool IsPrcnt(String x)
    {
        int y;

        if (int.TryParse(x, out y))
        {
            if (int.Parse(x) >= 0 && int.Parse(x) <= 100)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }
}
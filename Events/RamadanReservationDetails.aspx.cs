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

public partial class Events_RamadanReservationDetails : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        CheckUserSession();

        if (!Page.IsPostBack)
        {
            LoadChecks();
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
        String venue = Request.QueryString["venue"];

        String IftarType;
        String SuhoorType;

        if (venue == "Falandara")
        {
            IftarType = "IftarFalandara";
            SuhoorType = "SuhoorFalandara";
        } else
        {
            IftarType = "Iftar";
            SuhoorType = "Suhoor";

            DataSet extra = dataAccess.seleccct("[MealID], [Meal], [Price]", "[FleetDB].[dbo].[RamadanMeals]", "[Type] = 'Extra'");

            rptrExtra.DataSource = extra;
            rptrExtra.DataBind();
        }

        DataSet iftar = dataAccess.seleccct("[MealID], [Meal], [Price]", "[FleetDB].[dbo].[RamadanMeals]", "[Type] = '" + IftarType + "'");

        rptrIftar.DataSource = iftar;
        rptrIftar.DataBind();

        DataSet suhoor = dataAccess.seleccct("[MealID], [Meal], [Price]", "[FleetDB].[dbo].[RamadanMeals]", "[Type] = '" + SuhoorType + "'");

        rptrSuhoor.DataSource = suhoor;
        rptrSuhoor.DataBind();

        
    }

    // Action methods

    protected void SubmitTable(object sender, System.EventArgs e)
    {
        String validityOfForm = IsValidForm();

        String message;
        String msg = "";

        DataTable tbltable = dataAccess.seleccct("[TableID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableNumber]=" + hdnTableNumber.Value + "and [Type]='" + hdnType.Value + "' and [RamadanDay]=" + hdnRamadan.Value).Tables[0];

        if (tbltable.Rows.Count != 0 && hdnVenue.Value != "Falandara")
        {
            message = "Table is already reserved";

            btnSubmit.Attributes["disabled"] = "true";

            ClearAll();

        } else if (validityOfForm != "Valid")
        {
            message = validityOfForm;

        } else
        {
            String type = hdnType.Value.ToString();

            String tblClients = "[FleetDB].[dbo].[RamadanClients]";
            String tblTables = "[FleetDB].[dbo].[RamadanTables]";
            String tblOrders = "[FleetDB].[dbo].[RamadanTableOrders]";

            String colClients = "[Name],[PhoneNumber],[Email]";
            String colTables = "[TableNumber],[Type],[Venue],[RamadanDay],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]";
            String colOrders = "[TableID],[Persons],[MealID],[Comment]";

            DataTable clientChk = dataAccess.seleccct("*", tblClients, "[Name] = N'" + inputName.Text + "' and [PhoneNumber] = '" + inputPhoneNumber.Text + "'").Tables[0];

            int clientID;

            if (inputID.Text == "" && clientChk.Rows.Count == 0)
            {
                String valClients = "N'" + inputName.Text + "','" + inputPhoneNumber.Text + "','" + inputEmail.Text + "'";

                dataAccess.insert(tblClients, colClients, valClients);

                clientID = int.Parse(dataAccess.seleccct("SELECT TOP 1 [ClientID] FROM [FleetDB].[dbo].[RamadanClients] ORDER BY [ClientID] DESC", 1).Tables[0].Rows[0]["ClientID"].ToString());
            
            } else
            {
                if (inputID.Text == "")
                {
                    msg = " (Hint: Client was already a member with [history = " + clientChk.Rows[0]["History"] + " ]).";

                    clientID = int.Parse(clientChk.Rows[0]["ClientID"].ToString());
                } else
                {
                    clientID = int.Parse(inputID.Text.ToString());
                }

                String clientSet = "[Name] = N'" + inputName.Text + "', [PhoneNumber] = '" + inputPhoneNumber.Text + "'";

                if (inputEmail.Text != "")
                {
                    clientSet += ", [Email] = '" + inputEmail.Text + "'";
                }

                int tblCount = dataAccess.seleccct("[TableID]", tblTables, "[RamadanDay]=" + hdnRamadan.Value + "and [Type]='" + hdnType.Value + "' and [ClientID]=" + clientID).Tables[0].Rows.Count;

                if (tblCount == 0)
                {
                    clientSet += ", [History] = [History] + 1";
                }

                dataAccess.Update(tblClients, clientSet, "[ClientID] = " + clientID);
            }

            message = "Table submitted successfully for client ID " + clientID.ToString() + msg;

            String valTables = hdnTableNumber.Value + ",'" + hdnType.Value + "','" + hdnVenue.Value + "'," + hdnRamadan.Value + ",CAST( GETDATE() AS Date )," + hdnTotalPersons.Value + "," + hdnTotal.Value + ",'" + inputDeposit.Text + "'," + clientID;

            dataAccess.insert(tblTables, colTables, valTables);

            var rptr = (FindControl("rptr" + type) as Repeater);

            int tableID = int.Parse(dataAccess.seleccct("SELECT TOP 1 [TableID] FROM [FleetDB].[dbo].[RamadanTables] ORDER BY [TableID] DESC", 1).Tables[0].Rows[0]["TableID"].ToString());

            foreach (RepeaterItem item in rptr.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    if ((item.FindControl("rptrCheck" + type) as CheckBox).Checked)
                    {
                        String orderQnt = ((HtmlInputText)item.FindControl("rptrQuantity" + type)).Value;
                        String mealID = (item.FindControl("rptrhdnNum" + type) as HiddenField).Value;
                        String comment = ((HtmlInputText)item.FindControl("rptrComment" + type)).Value;

                        if (comment == "") { comment = "."; }

                        String valOrders = tableID + "," + orderQnt + "," + mealID + ",N'" + comment + "'";

                        dataAccess.insert(tblOrders, colOrders, valOrders);
                    }
                }
            }

            if (type == "Iftar")
            {
                var rptrExtra = (FindControl("rptrExtra") as Repeater);

                foreach (RepeaterItem item in rptrExtra.Items)
                {
                    if ((item.FindControl("rptrCheckExtra") as CheckBox).Checked)
                    {
                        String orderQnt = ((HtmlInputText)item.FindControl("rptrQuantityExtra")).Value;
                        String mealID = (item.FindControl("rptrhdnNumExtra") as HiddenField).Value;
                        String comment = ((HtmlInputText)item.FindControl("rptrCommentExtra")).Value;

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

    protected void ViewToEdit(object sender, System.EventArgs e)
    {

        if (hdnTableNumber.Value == "") { return; }

        DataRow table;

        if (hdnVenue.Value == "Falandara")
        {
            var x = hdnTableID.Value;
            DataTable tbltable = dataAccess.seleccct("[TableID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableID]=" + hdnTableID.Value).Tables[0];

            if (tbltable.Rows.Count == 0)
            {
                return;
            }

            table = tbltable.Rows[0];

        } else
        {
            DataTable tbltable = dataAccess.seleccct("[TableID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableNumber]=" + hdnTableNumber.Value + "and [Type]='" + hdnType.Value + "' and [RamadanDay]=" + hdnRamadan.Value).Tables[0];

            if (tbltable.Rows.Count == 0)
            {
                return;
            }

            table = tbltable.Rows[0];
        }

        String clientID = table["ClientID"].ToString();

        DataRow client = dataAccess.seleccct("*", "[FleetDB].[dbo].[RamadanClients]", "[ClientID]=" + clientID).Tables[0].Rows[0];

        inputID.Text = clientID;
        inputPhoneChk.Text = client["PhoneNumber"].ToString();
        inputName.Text = client["Name"].ToString();
        inputPhoneNumber.Text = client["PhoneNumber"].ToString();
        inputEmail.Text = client["Email"].ToString();
        staticHistory.Text = client["History"].ToString();
        staticTotal.Text = table["TotalPrice"].ToString();
        staticTotalPersons.Text = table["Persons"].ToString();
        inputDeposit.Text = table["Deposit"].ToString();
        staticRemainingBalance.Text = (double.Parse(table["TotalPrice"].ToString()) - double.Parse(table["Deposit"].ToString())).ToString();

        String type = hdnType.Value.ToString();

        var rptr = (FindControl("rptr" + type) as Repeater);

        DataTable orders = dataAccess.seleccct("*", "[FleetDB].[dbo].[RamadanTableOrders]", "[TableID]=" + table["TableID"].ToString()).Tables[0];

        List<String> mealIDs = new List<string>();

        foreach (DataRow dr in orders.Rows)
        {
            mealIDs.Add(dr["MealID"].ToString());
        }

        foreach (RepeaterItem item in rptr.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                String mealID = (item.FindControl("rptrhdnNum" + type) as HiddenField).Value;

                if (mealIDs.Contains(mealID))
                {
                    (item.FindControl("rptrCheck" + type) as CheckBox).Checked = true;
                    ((HtmlInputText)item.FindControl("rptrQuantity" + type)).Value = orders.Select("[MealID]=" + mealID)[0]["Persons"].ToString();
                    ((HtmlInputText)item.FindControl("rptrComment" + type)).Value = orders.Select("[MealID]=" + mealID)[0]["Comment"].ToString();
                }
            }
        }

        if (type == "Iftar")
        {
            var rptrExtra = (FindControl("rptrExtra") as Repeater);

            foreach (RepeaterItem item in rptrExtra.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    String mealID = (item.FindControl("rptrhdnNumExtra") as HiddenField).Value;

                    if (mealIDs.Contains(mealID))
                    {
                        (item.FindControl("rptrCheckExtra") as CheckBox).Checked = true;
                        ((HtmlInputText)item.FindControl("rptrQuantityExtra")).Value = orders.Select("[MealID]=" + mealID)[0]["Persons"].ToString();
                        ((HtmlInputText)item.FindControl("rptrCommentExtra")).Value = orders.Select("[MealID]=" + mealID)[0]["Comment"].ToString();
                    }
                }
            }
        }

        btnSubmit.Attributes["disabled"] = "true";
        btnEdit.Attributes["disabled"] = "true";
        inputID.Attributes["ReadOnly"] = "true";
        inputPhoneChk.Attributes["ReadOnly"] = "true";

    }

    protected void UpdateTable(object sender, System.EventArgs e)
    {
        DataTable tbltable;
        DataRow table;

        if (hdnVenue.Value == "Falandara")
        {
            tbltable = dataAccess.seleccct("[TableID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableID]=" + hdnTableID.Value).Tables[0];

            if (tbltable.Rows.Count == 0)
            {
                return;
            }

            table = tbltable.Rows[0];

        }
        else
        {
            tbltable = dataAccess.seleccct("[TableID], [ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableNumber]=" + hdnTableNumber.Value + "and [Type]='" + hdnType.Value + "' and [RamadanDay]=" + hdnRamadan.Value).Tables[0];

            if (tbltable.Rows.Count == 0)
            {
                return;
            }
        }

        

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

            String type = hdnType.Value.ToString();

            String tblClients = "[FleetDB].[dbo].[RamadanClients]";
            String tblTables = "[FleetDB].[dbo].[RamadanTables]";
            String tblOrders = "[FleetDB].[dbo].[RamadanTableOrders]";

            String setClient = "[Name] = N'" + inputName.Text + "', [PhoneNumber] = '" + inputPhoneNumber.Text + "', [Email] = '" + inputEmail.Text + "'";
            String setTables = "[Date]=CAST( GETDATE() AS Date ),[Persons]=" + hdnTotalPersons.Value + ",[TotalPrice]=" + hdnTotal.Value + ",[Deposit]=" + inputDeposit.Text;
            String colOrders = "[TableID],[Persons],[MealID],[Comment]";

            String valTables = "CAST( GETDATE() AS Date )," + hdnTotalPersons.Value + "," + hdnTotal.Value + "," + inputDeposit.Text;

            dataAccess.Update(tblClients, setClient, "[ClientID] = " + clientID);
            dataAccess.Update(tblTables, setTables, "[TableID]=" + tableID);

            dataAccess.delete(tblOrders, "[TableID]=" + tableID);

            var rptr = (FindControl("rptr" + type) as Repeater);

            foreach (RepeaterItem item in rptr.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    if ((item.FindControl("rptrCheck" + type) as CheckBox).Checked)
                    {
                        String orderQnt = ((HtmlInputText)item.FindControl("rptrQuantity" + type)).Value;
                        String mealID = (item.FindControl("rptrhdnNum" + type) as HiddenField).Value;
                        String comment = ((HtmlInputText)item.FindControl("rptrComment" + type)).Value;

                        if (comment == "") { comment = "."; }

                        String valOrders = tableID + "," + orderQnt + "," + mealID + ",N'" + comment + "'";

                        dataAccess.insert(tblOrders, colOrders, valOrders);
                    }
                }
            }

            if (type == "Iftar")
            {
                var rptrExtra = (FindControl("rptrExtra") as Repeater);

                foreach (RepeaterItem item in rptrExtra.Items)
                {
                    if ((item.FindControl("rptrCheckExtra") as CheckBox).Checked)
                    {
                        String orderQnt = ((HtmlInputText)item.FindControl("rptrQuantityExtra")).Value;
                        String mealID = (item.FindControl("rptrhdnNumExtra") as HiddenField).Value;
                        String comment = ((HtmlInputText)item.FindControl("rptrCommentExtra")).Value;

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

    protected void DeleteTable(object sender, System.EventArgs e)
    {
        String message = "Table deleted successfully";

        DataTable tbltable;
        DataRow table;

        if (hdnVenue.Value == "Falandara")
        {
            tbltable = dataAccess.seleccct("[TableID],[Date],[Persons],[TotalPrice],[Deposit],[ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableID]=" + hdnTableID.Value).Tables[0];

            if (tbltable.Rows.Count == 0)
            {
                return;
            }

            table = tbltable.Rows[0];

        }
        else
        {
            tbltable = dataAccess.seleccct("[TableID], [ClientID]", "[FleetDB].[dbo].[RamadanTables]", "[TableNumber]=" + hdnTableNumber.Value + "and [Type]='" + hdnType.Value + "' and [RamadanDay]=" + hdnRamadan.Value).Tables[0];

            if (tbltable.Rows.Count == 0)
            {
                return;
            }
        }

        String tableID = tbltable.Rows[0]["TableID"].ToString();
        String clientID = tbltable.Rows[0]["ClientID"].ToString();

        String type = hdnType.Value.ToString();

        String tblTables = "[FleetDB].[dbo].[RamadanTables]";
        String tblOrders = "[FleetDB].[dbo].[RamadanTableOrders]";

        int tblCount = dataAccess.seleccct("[TableID]", tblTables, "[RamadanDay]=" + hdnRamadan.Value + "and [Type]='" + hdnType.Value + "' and [ClientID]=" + clientID).Tables[0].Rows.Count;

        if (tblCount == 1)
        {
            String tblClients = "[FleetDB].[dbo].[RamadanClients]";

            String setClient = "[History] = [History] - 1";

            dataAccess.Update(tblClients, setClient, "[ClientID] = " + clientID);
        }

        dataAccess.delete(tblTables, "[TableID]=" + tableID);
        dataAccess.delete(tblOrders, "[TableID]=" + tableID);

        ClearAll();

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    protected void ReviewClient(object sender, System.EventArgs e)
    {
        DataTable clientInfo = dataAccess.seleccct("[ClientID], [Name], [PhoneNumber], [Email], [History]", "[FleetDB].[dbo].[RamadanClients]", "[ClientID] = '" + inputID.Text + "' or [PhoneNumber] = '" + inputPhoneChk.Text + "'").Tables[0];

        String message;

        if (clientInfo.Rows.Count != 0)
        {
            inputID.Text = clientInfo.Rows[0]["ClientID"].ToString();
            inputPhoneChk.Text = clientInfo.Rows[0]["PhoneNumber"].ToString();
            inputName.Text = clientInfo.Rows[0]["Name"].ToString();
            inputPhoneNumber.Text = clientInfo.Rows[0]["PhoneNumber"].ToString();
            inputEmail.Text = clientInfo.Rows[0]["Email"].ToString();
            staticHistory.Text = clientInfo.Rows[0]["History"].ToString();

            inputID.Attributes["ReadOnly"] = "true";
            inputPhoneChk.Attributes["ReadOnly"] = "true";

        } else
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
        inputName.Text = "";
        inputPhoneNumber.Text = "";
        inputEmail.Text = "";
        staticTableNumber.Text = "";
        staticType.Text = "";
        staticVenue.Text = "";
        staticRamadan.Text = "";
        staticTotalPersons.Text = "0";
        staticTotal.Text = "0";
        inputDeposit.Text = "0";
        staticRemainingBalance.Text = "0";

        String type = hdnType.Value.ToString();

        var rptr = (FindControl("rptr" + type) as Repeater);

        foreach (RepeaterItem item in rptr.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                (item.FindControl("rptrCheck" + type) as CheckBox).Checked = false;
                ((HtmlInputText)item.FindControl("rptrQuantity" + type)).Value = "0";
                ((HtmlInputText)item.FindControl("rptrComment" + type)).Value = ".";
            }
        }

        if (type == "Iftar")
        {
            var rptrExtra = (FindControl("rptrExtra") as Repeater);

            foreach (RepeaterItem item in rptrExtra.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    (item.FindControl("rptrCheckExtra") as CheckBox).Checked = false;
                    ((HtmlInputText)item.FindControl("rptrQuantityExtra")).Value = "0";
                    ((HtmlInputText)item.FindControl("rptrCommentExtra")).Value = ".";
                }
            }
        }

        btnSubmit.Attributes["disabled"] = "true";
        btnEdit.Attributes["disabled"] = "true";
        btnUpdate.Attributes["disabled"] = "true";
        btnDelete.Attributes["disabled"] = "true";
    }

    public String IsValidForm()
    {

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

        String type = hdnType.Value.ToString();

        var rptr = (FindControl("rptr" + type) as Repeater);

        int chkd = 0;

        foreach (RepeaterItem item in rptr.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                if ((item.FindControl("rptrCheck" + type) as CheckBox).Checked)
                {
                    chkd += 1;

                    var numOfMeals = ((HtmlInputText)item.FindControl("rptrQuantity" + type)).Value;

                    if (!IsInt(numOfMeals))
                    {
                        return "Please enter a valid number of meals.";
                    }
                }
            }
        }

        if (chkd == 0) { return "Please choose preferred meals"; }

        if (chkd != int.Parse(hdnNumOfChks.Value)) { return "Please uncheck unused meals."; }

        if (type == "Iftar")
        {
            int chkdExtra = 0;
            var rptrExtra = (FindControl("rptrExtra") as Repeater);

            foreach (RepeaterItem item in rptrExtra.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    if ((item.FindControl("rptrCheckExtra") as CheckBox).Checked)
                    {
                        chkdExtra += 1;

                        var numOfMeals = ((HtmlInputText)item.FindControl("rptrQuantityExtra")).Value;

                        if (!IsInt(numOfMeals))
                        {
                            return "Please enter a valid number of extras.";
                        }
                    }
                }
            }

            if (chkdExtra != int.Parse(hdnNumOfChksExtra.Value)) { return "Please uncheck unused meals."; }
        }

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
            } else
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
}
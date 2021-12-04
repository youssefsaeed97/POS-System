using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_DailyTables : System.Web.UI.Page
{

    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            CheckUserSession();
            LoadDailyTables();
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

    public void LoadDailyTables()
    {
        DataTable dt = dataAccess.seleccct("[Id], [ReceiptNo], [Number], [Cashed], CONVERT(varchar(15), CAST(CreatedDate as time), 100) [Time], [CreatedBy]", "[FleetDB].[dbo].[DailyTables]", "1=1").Tables[0];
        rptrTables.DataSource = dt;
        rptrTables.DataBind();
    }

    // Action methods
    
    protected void SelectTable(object sender, EventArgs e)
    {
        Button btn = (sender as Button);
        string id = btn.CommandArgument;

        Response.Redirect("./TableItems.aspx?TableID=" + id);
    }

    protected void UnCashTable(object sender, EventArgs e)
    {
        Button btn = (sender as Button);
        string id = btn.CommandArgument;
        string message;

        //Check if the same TableNumber exists in the current tables FIRST

        String tableNum = dataAccess.seleccct("[Number]", "[FleetDB].[dbo].[DailyTables]", "[Id] = " + id).Tables[0].Rows[0][0].ToString();

        DataTable tableChk = dataAccess.seleccct("[Id]", "[FleetDB].[dbo].[DailyTables]", "[Number] = " + tableNum + "and [Cashed] = 0").Tables[0];

        if (tableChk.Rows.Count > 0)
        {
            message = "Table is already busy. Please cash existing table first.";

        } else
        {
            message = "Table marked un-cashed successfuly.";

            dataAccess.Update("[FleetDB].[dbo].[DailyTables]", "[Cashed] = 0, [ClosedDate] = null", "[Id] = " + id);
        }

        LoadDailyTables();

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    //protected void DeleteTable(object sender, EventArgs e)
    //{
    //    Button btn = (sender as Button);
    //    string id = btn.CommandArgument;
    //    string message = "Table deleted successfuly.";

    //    dataAccess.delete("[FleetDB].[dbo].[DailyTables]", "[Id] = " + id);


    //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    //}
}
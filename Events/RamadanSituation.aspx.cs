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

public partial class Events_RamadanSituation : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        CheckUserSession();

        if (!Page.IsPostBack)
        {
            
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

    protected void LoadRptrs (object sender, System.EventArgs e)
    {

        String columns = "ROW_NUMBER() OVER(ORDER BY RT.[TableNumber] ASC) AS RowNumber, [TableID], [TableNumber], [Venue], [Persons] as TotalPersons, [Deposit], [Name]";
        String tableX = "[FleetDB].[dbo].[RamadanTables] as RT inner join [FleetDB].[dbo].[RamadanClients] as RC on RT.[ClientID] = RC.[ClientID]";
        String conditionX = "[RamadanDay] = " + hdnRamadan.Value + "and [Type] = '" + hdnType.Value + "' and [Venue] != 'Falandara' ORDER BY [TableNumber] ASC";

        DataSet ds = dataAccess.seleccct(columns, tableX, conditionX);

        totalGuests.InnerText = ds.Tables[0].Compute("Sum(TotalPersons)", string.Empty).ToString();

        Repeater rptrSituation = (Repeater)FindControl("rptrSituation");

        if (ds.Tables.Count > 0)
        {
            rptrSituation.DataSource = ds.Tables[0];
        }
        else
        {
            rptrSituation.DataSource = "";
        }
        rptrSituation.DataBind();

        foreach (RepeaterItem item in rptrSituation.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                // FIX NEXT LINE
                String tableID = (item.FindControl("tableID") as HiddenField).Value;

                String columns1 = "[Persons]";
                String columns2 = "[Meal]";
                String columns3 = "[Comment]";
                String table = "[FleetDB].[dbo].[RamadanTableOrders] as RTO inner join [FleetDB].[dbo].[RamadanMeals] as RM on RTO.[MealID] = RM.[MealID]";
                String condition = "[TableID] = " + tableID;

                DataSet ds1 = dataAccess.seleccct(columns1, table, condition);
                DataSet ds2 = dataAccess.seleccct(columns2, table, condition);
                DataSet ds3 = dataAccess.seleccct(columns3, table, condition);

                Repeater childRptrPersons = ((Repeater)item.FindControl("childRptrPersons"));

                if (ds1.Tables.Count > 0)
                {
                    childRptrPersons.DataSource = ds1.Tables[0];
                }
                else
                {
                    childRptrPersons.DataSource = "";
                }
                childRptrPersons.DataBind();

                Repeater childRptrMeal = ((Repeater)item.FindControl("childRptrMeal"));

                if (ds2.Tables.Count > 0)
                {
                    childRptrMeal.DataSource = ds2.Tables[0];
                }
                else
                {
                    childRptrMeal.DataSource = "";
                }
                childRptrMeal.DataBind();

                Repeater childRptrComment = ((Repeater)item.FindControl("childRptrComment"));

                if (ds2.Tables.Count > 0)
                {
                    childRptrComment.DataSource = ds3.Tables[0];
                }
                else
                {
                    childRptrComment.DataSource = "";
                }
                childRptrComment.DataBind();
            }
        }

        String colMT = "SUM(RTO.[Persons]) AS TotalMeals, RM.[Meal] AS Meal";
        String tblMT = "[FleetDB].[dbo].[RamadanTableOrders] AS RTO inner join [FleetDB].[dbo].[RamadanMeals] AS RM ON RTO.[MealID] = RM.[MealID] inner join [FleetDB].[dbo].[RamadanTables] AS RT on RT.[TableID] = RTO.[TableID]";
        String condMT = "RT.[RamadanDay] = " + hdnRamadan.Value + "and RT.[Type] = '" + hdnType.Value + "' and [Venue] != 'Falandara' GROUP BY [Meal]";

        DataSet dsTotals = dataAccess.seleccct(colMT, tblMT, condMT);

        Repeater rptrTotals = (Repeater)FindControl("rptrTotals");

        if (ds.Tables.Count > 0)
        {
            rptrTotals.DataSource = dsTotals.Tables[0];
        }
        else
        {
            rptrTotals.DataSource = "";
        }
        rptrTotals.DataBind();

        btnPrint.Style["display"] = "none";
        btnPrintFlndra.Style["display"] = "none";
        btnReport.Style["display"] = "none";

        ramadanDate.InnerHtml = hdnRamadan.Value + " Ramadan";
        date.InnerHtml = DateTime.Now.ToString();
        type.InnerHtml = hdnType.Value;
    }

    protected void LoadFlndra(object sender, System.EventArgs e)
    {

        String columns = "ROW_NUMBER() OVER(ORDER BY RT.[TableNumber] ASC) AS RowNumber, [TableID], [TableNumber], [Venue], [Persons] as TotalPersons, [Deposit], [Name]";
        String tableX = "[FleetDB].[dbo].[RamadanTables] as RT inner join [FleetDB].[dbo].[RamadanClients] as RC on RT.[ClientID] = RC.[ClientID]";
        String conditionX = "[RamadanDay] = " + hdnRamadan.Value + "and [Type] = '" + hdnType.Value + "' and [Venue] = 'Falandara' ORDER BY [TableNumber] ASC";

        DataSet ds = dataAccess.seleccct(columns, tableX, conditionX);

        totalGuests.InnerText = ds.Tables[0].Compute("Sum(TotalPersons)", string.Empty).ToString();

        Repeater rptrSituation = (Repeater)FindControl("rptrSituation");

        if (ds.Tables.Count > 0)
        {
            rptrSituation.DataSource = ds.Tables[0];
        }
        else
        {
            rptrSituation.DataSource = "";
        }
        rptrSituation.DataBind();

        foreach (RepeaterItem item in rptrSituation.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                // FIX NEXT LINE
                String tableID = (item.FindControl("tableID") as HiddenField).Value;

                String columns1 = "[Persons]";
                String columns2 = "[Meal]";
                String columns3 = "[Comment]";
                String table = "[FleetDB].[dbo].[RamadanTableOrders] as RTO inner join [FleetDB].[dbo].[RamadanMeals] as RM on RTO.[MealID] = RM.[MealID]";
                String condition = "[TableID] = " + tableID;

                DataSet ds1 = dataAccess.seleccct(columns1, table, condition);
                DataSet ds2 = dataAccess.seleccct(columns2, table, condition);
                DataSet ds3 = dataAccess.seleccct(columns3, table, condition);

                Repeater childRptrPersons = ((Repeater)item.FindControl("childRptrPersons"));

                if (ds1.Tables.Count > 0)
                {
                    childRptrPersons.DataSource = ds1.Tables[0];
                }
                else
                {
                    childRptrPersons.DataSource = "";
                }
                childRptrPersons.DataBind();

                Repeater childRptrMeal = ((Repeater)item.FindControl("childRptrMeal"));

                if (ds2.Tables.Count > 0)
                {
                    childRptrMeal.DataSource = ds2.Tables[0];
                }
                else
                {
                    childRptrMeal.DataSource = "";
                }
                childRptrMeal.DataBind();

                Repeater childRptrComment = ((Repeater)item.FindControl("childRptrComment"));

                if (ds2.Tables.Count > 0)
                {
                    childRptrComment.DataSource = ds3.Tables[0];
                }
                else
                {
                    childRptrComment.DataSource = "";
                }
                childRptrComment.DataBind();
            }
        }

        String colMT = "SUM(RTO.[Persons]) AS TotalMeals, RM.[Meal] AS Meal";
        String tblMT = "[FleetDB].[dbo].[RamadanTableOrders] AS RTO inner join [FleetDB].[dbo].[RamadanMeals] AS RM ON RTO.[MealID] = RM.[MealID] inner join [FleetDB].[dbo].[RamadanTables] AS RT on RT.[TableID] = RTO.[TableID]";
        String condMT = "RT.[RamadanDay] = " + hdnRamadan.Value + "and RT.[Type] = '" + hdnType.Value + "' and [Venue] = 'Falandara' GROUP BY [Meal]";

        DataSet dsTotals = dataAccess.seleccct(colMT, tblMT, condMT);

        Repeater rptrTotals = (Repeater)FindControl("rptrTotals");

        if (ds.Tables.Count > 0)
        {
            rptrTotals.DataSource = dsTotals.Tables[0];
        }
        else
        {
            rptrTotals.DataSource = "";
        }
        rptrTotals.DataBind();

        btnPrint.Style["display"] = "none";
        btnPrintFlndra.Style["display"] = "none";
        btnReport.Style["display"] = "none";

        ramadanDate.InnerHtml = hdnRamadan.Value + " Ramadan";
        date.InnerHtml = DateTime.Now.ToString();
        type.InnerHtml = hdnType.Value;
    }

    protected void LoadReport(object sender, System.EventArgs e)
    {

        String columns = "ROW_NUMBER() OVER(ORDER BY RT.[TableNumber] ASC) AS RowNumber, [TableID], [TableNumber], [Venue], [Persons] as TotalPersons, [TotalPrice], [Deposit], [Name], [PhoneNumber]";
        String tableX = "[FleetDB].[dbo].[RamadanTables] as RT inner join [FleetDB].[dbo].[RamadanClients] as RC on RT.[ClientID] = RC.[ClientID]";
        String conditionX = "[RamadanDay] = " + hdnRamadan.Value + "and [Type] = '" + hdnType.Value + "' ORDER BY [TableNumber] ASC";

        DataSet ds = dataAccess.seleccct(columns, tableX, conditionX);

        totalGuests.InnerText = ds.Tables[0].Compute("Sum(TotalPersons)", string.Empty).ToString();

        Repeater rptrReport = (Repeater)FindControl("rptrReport");

        if (ds.Tables.Count > 0)
        {
            rptrReport.DataSource = ds.Tables[0];
        }
        else
        {
            rptrReport.DataSource = "";
        }
        rptrReport.DataBind();

        foreach (RepeaterItem item in rptrReport.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                // FIX NEXT LINE
                String tableID = (item.FindControl("tableID") as HiddenField).Value;

                String columns1 = "[Persons]";
                String columns2 = "[Meal]";
                String columns3 = "[Comment]";
                String table = "[FleetDB].[dbo].[RamadanTableOrders] as RTO inner join [FleetDB].[dbo].[RamadanMeals] as RM on RTO.[MealID] = RM.[MealID]";
                String condition = "[TableID] = " + tableID;

                DataSet ds1 = dataAccess.seleccct(columns1, table, condition);
                DataSet ds2 = dataAccess.seleccct(columns2, table, condition);
                DataSet ds3 = dataAccess.seleccct(columns3, table, condition);

                Repeater childRptrPersonsR = ((Repeater)item.FindControl("childRptrPersonsR"));

                if (ds1.Tables.Count > 0)
                {
                    childRptrPersonsR.DataSource = ds1.Tables[0];
                }
                else
                {
                    childRptrPersonsR.DataSource = "";
                }
                childRptrPersonsR.DataBind();

                Repeater childRptrMealR = ((Repeater)item.FindControl("childRptrMealR"));

                if (ds2.Tables.Count > 0)
                {
                    childRptrMealR.DataSource = ds2.Tables[0];
                }
                else
                {
                    childRptrMealR.DataSource = "";
                }
                childRptrMealR.DataBind();

                Repeater childRptrCommentR = ((Repeater)item.FindControl("childRptrCommentR"));

                if (ds2.Tables.Count > 0)
                {
                    childRptrCommentR.DataSource = ds3.Tables[0];
                }
                else
                {
                    childRptrCommentR.DataSource = "";
                }
                childRptrCommentR.DataBind();
            }
        }

        btnPrint.Style["display"] = "none";
        btnPrintFlndra.Style["display"] = "none";
        btnReport.Style["display"] = "none";

        ramadanDate.InnerHtml = hdnRamadan.Value + " Ramadan";
        date.InnerHtml = DateTime.Now.ToString();
        type.InnerHtml = hdnType.Value;
    }
}
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

public partial class Events_FalandaraSituation : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            CheckUserSession();
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

    protected void LoadRptrs(object sender, System.EventArgs e)
    {

        String columns = "ROW_NUMBER() OVER(ORDER BY FT.[Deck] ASC) AS RowNumber, [TableID], [Deck], [Persons] as TotalPersons, [Deposit], [Rank], [Name]";
        String tableX = "[FleetDB].[dbo].[FalandaraTables] as FT inner join [FleetDB].[dbo].[FalandaraClients] as FC on FT.[ClientID] = FC.[ClientID]";
        String conditionX = "[TripID] = " + hdnTripID.Value + "ORDER BY [Deck] DESC";

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
                String columns2 = "M.[Name] as Meal";
                String columns3 = "[Comment]";
                String table = "[FleetDB].[dbo].[FalandaraTableOrders] as FTO inner join [FleetDB].[dbo].[Menu] as M on FTO.[MealID] = M.[Id]";
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

        String colMT = "SUM(FTO.[Persons]) AS TotalMeals, M.[Name] AS Meal";
        String tblMT = "[FleetDB].[dbo].[FalandaraTableOrders] AS FTO inner join [FleetDB].[dbo].[Menu] AS M ON FTO.[MealID] = M.[Id] inner join [FleetDB].[dbo].[FalandaraTables] AS FT on FT.[TableID] = FTO.[TableID]";
        String condMT = "FT.[TripID] = " + hdnTripID.Value + " GROUP BY M.[Name]";

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

        dateTime.InnerHtml = hdnDateTime.Value;
        btnReport.Style["display"] = "none";
    }

    protected void LoadReport(object sender, System.EventArgs e)
    {

        String columns = "ROW_NUMBER() OVER(ORDER BY FT.[Deck] ASC) AS RowNumber, [TableID], [Deck], [Persons] as TotalPersons, [TotalPrice], [DiscountPrcnt], [Deposit], ([TotalPrice] - (([DiscountPrcnt]/100.0)*[TotalPrice]) - [Deposit]) AS Balance, [Rank], [Name], [PhoneNumber]";
        String tableX = "[FleetDB].[dbo].[FalandaraTables] as FT inner join [FleetDB].[dbo].[FalandaraClients] as FC on FT.[ClientID] = FC.[ClientID]";
        String conditionX = "[TripID] = " + hdnTripID.Value + "ORDER BY [Deck] DESC";

        DataSet ds = dataAccess.seleccct(columns, tableX, conditionX);

        totalGuests.InnerText = ds.Tables[0].Compute("Sum(TotalPersons)", string.Empty).ToString();

        Repeater rptrSituation = (Repeater)FindControl("rptrReport");

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
                String columns2 = "M.[Name] as Meal";
                String columns3 = "[Comment]";
                String table = "[FleetDB].[dbo].[FalandaraTableOrders] as FTO inner join [FleetDB].[dbo].[Menu] as M on FTO.[MealID] = M.[Id]";
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

        btnPrint.Style["display"] = "none";
        btnReport.Style["display"] = "none";

        dateTime.InnerHtml = dataAccess.seleccct("[DateTime]", "[FleetDB].[dbo].[FalandaraTrips]", "[TripID] = " + hdnTripID.Value).Tables[0].Rows[0][0].ToString();
    }

}
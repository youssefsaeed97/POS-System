using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Events_RamadanReport : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();

    public class dailyInfo
    {
        public String Day { get; set; }
        public String NileView { get; set; }
        public String NileViewP { get; set; }
        public String Seafood { get; set; }
        public String SeafoodP { get; set; }
        public String Beta { get; set; }
        public String BetaP { get; set; }
        public String Garden { get; set; }
        public String GardenP { get; set; }
        public String OpenAir { get; set; }
        public String OpenAirP { get; set; }
        public String Grill { get; set; }
        public String GrillP { get; set; }
        public String InDoor { get; set; }
        public String InDoorP { get; set; }
        public int Divider { get; set; }
        public Double Total { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        CheckUserSession();
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

    // Action methods

    protected void ReportIftar(object sender, System.EventArgs e)
    {
        List<dailyInfo> dailyList = new List<dailyInfo>();

        for (int i = 1; i <= 30; i++)
        {
            String cmd = "SELECT ROW_NUMBER() OVER(ORDER BY RT.[Venue] ASC) AS RowNumber, SUM(RT.[Persons]) AS Total, RT.[Venue], RV.[Limit] " +
                "FROM [FleetDB].[dbo].[RamadanTables] AS RT inner join [FleetDB].[dbo].[RamadanVenues] AS RV on RT.[Venue] = RV.[Venue] " +
                "WHERE RT.[RamadanDay] = " + i + " and RT.[Type] = 'Iftar' GROUP BY RT.[Venue], RV.[Limit] ORDER BY RT.[Venue] ASC";

            DataTable dailySum = dataAccess.seleccct(cmd, 1).Tables[0];

            dailyInfo dailyInstance = new dailyInfo
            {
                Day = i.ToString(),
                Divider = 534,
                Total = 0
            };

            foreach (DataRow dr in dailySum.Rows)
            {

                switch (dr["Venue"].ToString())
                {
                    case "Beta":
                        dailyInstance.Beta = dr["Total"].ToString();
                        dailyInstance.BetaP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Beta);
                        break;
                    case "Garden":
                        dailyInstance.Garden = dr["Total"].ToString();
                        dailyInstance.GardenP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Garden);
                        break;
                    case "Grill":
                        dailyInstance.Grill = dr["Total"].ToString();
                        dailyInstance.GrillP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Grill);
                        break;
                    case "InDoor":
                        dailyInstance.InDoor = dr["Total"].ToString();
                        dailyInstance.InDoorP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.InDoor);
                        break;
                    case "NileView":
                        dailyInstance.NileView = dr["Total"].ToString();
                        dailyInstance.NileViewP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.NileView);
                        break;
                    case "OpenAir":
                        dailyInstance.OpenAir = dr["Total"].ToString();
                        dailyInstance.OpenAirP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.OpenAir);
                        break;
                    case "Seafood":
                        dailyInstance.Seafood = dr["Total"].ToString();
                        dailyInstance.SeafoodP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Seafood);
                        break;
                    default:
                        // code block
                        break;
                }
            }

            dailyInstance.Total = Math.Round((dailyInstance.Total / dailyInstance.Divider) * 100, 1);

            dailyList.Add(dailyInstance);
        }

        rptrDailyReport.DataSource = dailyList;
        rptrDailyReport.DataBind();
        rptrDailyReport.Visible = true;
    }

    protected void ReportSuhoor(object sender, System.EventArgs e)
    {
        List<dailyInfo> dailyList = new List<dailyInfo>();

        for (int i = 1; i <= 30; i++)
        {
            String cmd = "SELECT ROW_NUMBER() OVER(ORDER BY RT.[Venue] ASC) AS RowNumber, SUM(RT.[Persons]) AS Total, RT.[Venue], RV.[Limit] " +
                "FROM [FleetDB].[dbo].[RamadanTables] AS RT inner join [FleetDB].[dbo].[RamadanVenues] AS RV on RT.[Venue] = RV.[Venue] " +
                "WHERE RT.[RamadanDay] = " + i + " and RT.[Type] = 'Suhoor' GROUP BY RT.[Venue], RV.[Limit] ORDER BY RT.[Venue] ASC";

            DataTable dailySum = dataAccess.seleccct(cmd, 1).Tables[0];

            dailyInfo dailyInstance = new dailyInfo
            {
                Day = i.ToString(),
                Divider = 534,
                Total = 0
            };

            foreach (DataRow dr in dailySum.Rows)
            {

                switch (dr["Venue"].ToString())
                {
                    case "Beta":
                        dailyInstance.Beta = dr["Total"].ToString();
                        dailyInstance.BetaP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Beta);
                        break;
                    case "Garden":
                        dailyInstance.Garden = dr["Total"].ToString();
                        dailyInstance.GardenP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Garden);
                        break;
                    case "Grill":
                        dailyInstance.Grill = dr["Total"].ToString();
                        dailyInstance.GrillP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Grill);
                        break;
                    case "InDoor":
                        dailyInstance.InDoor = dr["Total"].ToString();
                        dailyInstance.InDoorP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.InDoor);
                        break;
                    case "NileView":
                        dailyInstance.NileView = dr["Total"].ToString();
                        dailyInstance.NileViewP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.NileView);
                        break;
                    case "OpenAir":
                        dailyInstance.OpenAir = dr["Total"].ToString();
                        dailyInstance.OpenAirP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.OpenAir);
                        break;
                    case "Seafood":
                        dailyInstance.Seafood = dr["Total"].ToString();
                        dailyInstance.SeafoodP = Math.Round((double.Parse(dr["Total"].ToString()) / double.Parse(dr["Limit"].ToString())) * 100, 1).ToString();
                        dailyInstance.Total += double.Parse(dailyInstance.Seafood);
                        break;
                    default:
                        // code block
                        break;
                }
            }

            dailyInstance.Total = Math.Round((dailyInstance.Total / dailyInstance.Divider) * 100, 1);

            dailyList.Add(dailyInstance);
        }

        rptrDailyReport.DataSource = dailyList;
        rptrDailyReport.DataBind();
        rptrDailyReport.Visible = true;
    }
}
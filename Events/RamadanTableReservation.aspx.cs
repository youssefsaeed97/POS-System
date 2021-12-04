using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Events_RamadanTableReservation : System.Web.UI.Page
{
    public static ADO dataacess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        //CheckUserSession();

        if (!Page.IsPostBack)
        {
            LoadDrops();
        } else
        {
            ddlRamadanDay.Items[0].Attributes["disabled"] = "disabled";
            ddlType.Items[0].Attributes["disabled"] = "disabled";
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

    public void LoadDrops()
    {
        var RamadanDays = Enumerable.Range(1, 30).ToList();
        ddlRamadanDay.DataSource = RamadanDays;
        ddlRamadanDay.DataBind();
        ddlRamadanDay.Items.Insert(0, "Ramadan Date");
        ddlRamadanDay.Items[0].Selected = true;
        ddlRamadanDay.Items[0].Attributes["disabled"] = "disabled";

        string[] types = new string[2] { "Iftar", "Suhoor"};
        ddlType.DataSource = types;
        ddlType.DataBind();
        ddlType.Items.Insert(0, "Type");
        ddlType.Items[0].Selected = true;
        ddlType.Items[0].Attributes["disabled"] = "disabled";

        ddlFlndra.Items.Insert(0, "Reservation:");
        ddlFlndra.Items[0].Selected = true;
        ddlFlndra.Items[0].Attributes["disabled"] = "disabled";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static String LoadView(int ramdDay, string type)
    {
        if (type == "null") { int.Parse(type); } //intentionally raise error

        List<String> mailBox = new List<String>();

        JavaScriptSerializer js = new JavaScriptSerializer();

        DataTable reservedTables = dataacess.seleccct("[TableNumber]", "[FleetDB].[dbo].[RamadanTables]", "[RamadanDay] = " + ramdDay + "and [Type] = '" + type +"'").Tables[0];

        foreach (DataRow dr in reservedTables.Rows)
        {
            String tableNum = dr[0].ToString();
            mailBox.Add(tableNum);
        }

        return js.Serialize(mailBox);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static String LoadFlndra(int ramdDay, string type)
    {
        List<List<String>> mailBox = new List<List<String>>();

        JavaScriptSerializer js = new JavaScriptSerializer();

        DataTable reservedTables = dataacess.seleccct("RT.[TableID], RC.[Name]", "[FleetDB].[dbo].[RamadanTables] as RT inner join [FleetDB].[dbo].[RamadanClients] as RC on RT.[ClientID] = RC.[ClientID]", "RT.[RamadanDay] = " + ramdDay + "and RT.[Type] = '" + type + "' and RT.[Venue] = 'Falandara'").Tables[0];

        foreach (DataRow dr in reservedTables.Rows)
        {
            String tableID = dr[0].ToString();
            String name = dr[1].ToString();

            var table = new List<String> { name, tableID };

            mailBox.Add(table);
        }

        return js.Serialize(mailBox);
    }

    protected void Redirect_Print(object sender, System.EventArgs e)
    {
        //Response.Redirect("Situation.aspx?ramDay=" + ddlRamadanDay.SelectedValue + "&type=" + ddlType.SelectedValue);
        Response.Write("<script>window.open ('RamadanSituation.aspx?ramDay=" + ddlRamadanDay.SelectedValue + "&type=" + ddlType.SelectedValue + "','_blank');</script>");
    }
}
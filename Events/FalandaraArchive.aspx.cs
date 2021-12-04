using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Events_FalandaraArchive : System.Web.UI.Page
{

    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        loadmaintable();
        //Console.WriteLine("OK");
        //System.Diagnostics.Debug.WriteLine("1");
    }

    public void loadmaintable()
    {
        DataTable dt = dataAccess.seleccct("[TripID], [DateTime]", "[FleetDB].[dbo].[FalandaraTrips]", "[Submit]=1 ORDER BY [DateTime] ASC").Tables[0];
        repeaterFleet.DataSource = dt;
        repeaterFleet.DataBind();
    }
    
    protected void btn_clk(object sender, EventArgs e)
    {
        Button btn = (sender as Button);
        string id = btn.CommandArgument;
        //Response.Redirect("./FalandaraSituation.aspx?datetime=0&tripID=" + id);
        Response.Write("<script>window.open ('./FalandaraSituation.aspx?datetime=0&tripID=" + id + "','_blank');</script>");

    }
}
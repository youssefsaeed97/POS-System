using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Content : System.Web.UI.Page
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

    protected void TruncateRmdnReservations(object sender, System.EventArgs e)
    {
        String message = "Reseravations has been deleted successfuly.";

        String cmd = "TRUNCATE TABLE [FleetDB].[dbo].[RamadanTableOrders];" +
                     "TRUNCATE TABLE [FleetDB].[dbo].[RamadanTables];";

        dataAccess.excute(cmd);

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    protected void BackupDatabase(object sender, System.EventArgs e)
    {
        String message = "Backup: Success.";

        String db = "FleetDB";
        String date = DateTime.Now.Date.ToString("dd-MM-yyyy");
        String file = db + "_" + date + ".bak";
        String directory = txtDirectory.Text;
        String cmd = "BACKUP DATABASE " + db + " TO DISK = '" + directory + file + "'";

        try
        {
            dataAccess.excute(cmd);
        }
        catch
        {
            message = "Backup: Fail.";
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

    protected void Fix(object sender, System.EventArgs e)
    {
        String message = "Fix: Success.";

        try
        {
            dataAccess.delete("[FleetDB].[dbo].[DailyTablesOrders]", "[tableID] = 1040401");
            dataAccess.delete("[FleetDB].[dbo].[OrdersPort]", "[tableID] = 1040401");
        }
        catch
        {
            message = "Fix: Fail.";
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);
    }

}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Events_Home : System.Web.UI.Page
{
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
}
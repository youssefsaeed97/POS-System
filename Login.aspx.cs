using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    private ADO dataAccess = new ADO();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try { Session.Clear(); }
            catch (Exception exx) { }
        }
    }

    protected void login_clk(object sender, System.EventArgs e)
    {
        String userName = username.Text;
        if (dataAccess.checkpasswordvalid(userName, password.Text))
        {
            String userType = getUserType(userName);
            Session["userType"] = userType;
            Session["userName"] = userName;

            if (userType == "Admin")
                Response.Redirect("Admin/Home.aspx");

            if (userType == "Cashier")
                Response.Redirect("Cashier/POS.aspx");

            if (userType == "Accountant")
                Response.Redirect("Accountant/Home.aspx");

            if (userType == "Store")
                Response.Redirect("Store/Home.aspx");

            if (userType == "Waiter")
                Response.Redirect("Cashier/Waiter.aspx");

            if (userType == "AccountantGM")
                Response.Redirect("AccountantGM/Home.aspx");

            if (userType == "HousingGM")
                Response.Redirect("HousingGM/Home.aspx");

            if (userType == "FoodNBeverageGM")
                Response.Redirect("FoodNBeverageGM/Home.aspx");

            if (userType == "GM")
                Response.Redirect("GM/Home.aspx");

            if (userType == "Events")
                Response.Redirect("Events/Home.aspx");
        }
    }

    protected String getUserType(String username)
    {
        return dataAccess.seleccct("[UserType]", "[FleetDB].[dbo].[Users]", "[Name]='" + username+"'").Tables[0].Rows[0][0].ToString();
    }

    protected void reset_clk(object sender, System.EventArgs e)
    {
        username.Text = "";
        password.Text = "";
    }

}
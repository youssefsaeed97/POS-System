using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Users : System.Web.UI.Page
{
    public static ADO dataAccess = new ADO();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            CheckUserSession();

            LoadDropDowns();

            LoadTable();
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

    // Data load

    public void LoadTable()
    {
        String columns = "ROW_NUMBER() OVER(ORDER BY [id] ASC) AS RowNumber, [Name], [UserType], [Active]";
        String table = "[FleetDB].[dbo].[Users]";
        String condition = "1=1";

        DataSet ds = dataAccess.seleccct(columns, table, condition);

        if (ds.Tables.Count > 0)
        {
            repeaterFleet.DataSource = ds.Tables[0];
        }
        else
        {
            repeaterFleet.DataSource = "";
        }

        repeaterFleet.DataBind();
    }

    public void LoadDropDowns()
    {
        DataTable userTypes = dataAccess.seleccct("[UserType]", "[FleetDB].[dbo].[Users]", "1=1 GROUP BY [UserType]").Tables[0];

        ddlType.DataSource = "";
        ddlType.DataBind();
        ddlType.Items.Insert(0, "Select Type:");
        ddlType.Items.Insert(1, "Admin");
        ddlType.Items.Insert(2, "GM");
        ddlType.Items.Insert(3, "HousingGM");
        ddlType.Items.Insert(4, "FoodNBeverageGM");
        ddlType.Items.Insert(5, "AccountantGM");
        ddlType.Items.Insert(6, "Accountant");
        ddlType.Items.Insert(7, "Store");
        ddlType.Items.Insert(8, "Events");
        ddlType.Items.Insert(9, "Cashier");
        ddlType.Items.Insert(10, "Waiter");
        ddlType.Items[0].Selected = true;
        ddlType.Items[0].Attributes["disabled"] = "disabled";

        DataTable currentUsers = dataAccess.seleccct("[id],[Name]", "[FleetDB].[dbo].[Users]", "1=1").Tables[0];

        ddlUsersEdit.DataSource = currentUsers;
        ddlUsersEdit.DataTextField = "Name";
        ddlUsersEdit.DataValueField = "id";
        ddlUsersEdit.DataBind();
        ddlUsersEdit.Items.Insert(0, "Select User:");
        ddlUsersEdit.Items[0].Selected = true;
        ddlUsersEdit.Items[0].Attributes["disabled"] = "disabled";
    }

    // Action methods

    protected void ViewToAdd(object sender, System.EventArgs e)
    {
        btnAddView.Attributes["class"] = "list-group-item list-group-item-action active";
        btnEditView.Attributes["class"] = "list-group-item list-group-item-action";
        contentDiv.Visible = true;
        selectUserDiv.Visible = false;
        addBtns.Visible = true;
        modifyBtns.Visible = false;
        ClearAll();
    }

    protected void ViewToEdit(object sender, System.EventArgs e)
    {
        btnAddView.Attributes["class"] = "list-group-item list-group-item-action";
        btnEditView.Attributes["class"] = "list-group-item list-group-item-action active";
        contentDiv.Visible = false;
        selectUserDiv.Visible = true;
        addBtns.Visible = false;
        modifyBtns.Visible = false;
        ClearAll();
    }

    protected void ViewUserToEdit(object sender, System.EventArgs e)
    {
        DataRow user = dataAccess.seleccct("[id], [Name], [UserType], [Active]", "[FleetDB].[dbo].[Users]", "[id] = '" + ddlUsersEdit.SelectedValue.ToString() + "'").Tables[0].Rows[0];

        txtUsername.Text = user["Name"].ToString();
        ddlType.SelectedValue = user["UserType"].ToString();

        if (user["Active"].ToString() == "True")
        {
            chkActive.Checked = true;
        }

        contentDiv.Visible = true;
        selectUserDiv.Visible = false;
        modifyBtns.Visible = true;
    }

    protected void AddCard(object sender, System.EventArgs e)
    {
        String message = ValidityOfForm();

        if (message != "Valid")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);

            return;

        } else
        {
            message = "User has been added successfuly.";
        }

        int active;
        
        if (chkActive.Checked == true)
        {
            active = 1;

        } else
        {
            active = 0;
        }

        dataAccess.excute("INSERT INTO [FleetDB].[dbo].[Users] VALUES ('" + txtUsername.Text +"',EncryptByPassPhrase('YYW', '" + txtPassword.Text + "' ),'" + ddlType.SelectedItem.ToString() + "'," + active + ")");

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);

        ClearAll();
    }

    protected void UpdateCard(object sender, System.EventArgs e)
    {
        String message = ValidityOfForm();

        if (message != "Valid")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);

            return;

        }
        else
        {
            message = "User has been updated successfuly.";
        }

        int active;

        if (chkActive.Checked == true)
        {
            active = 1;

        }
        else
        {
            active = 0;
        }

        dataAccess.Update("[FleetDB].[dbo].[Users]", "[Name]='" + txtUsername.Text + "',[UserType]='" + ddlType.SelectedItem.ToString() + "',[Active]=" + active, "[id] = " + ddlUsersEdit.SelectedValue.ToString());

        if (IsNotEmpty(txtPassword.Text))
        {
            dataAccess.excute("UPDATE [FleetDB].[dbo].[Users] SET [Password]=EncryptByPassPhrase('YYW', '" + txtPassword.Text + "' ) WHERE [id] = " + ddlUsersEdit.SelectedValue.ToString());
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);

        ClearAll();

        EditRedirect();
    }

    protected void DeleteCard(object sender, System.EventArgs e)
    {
        String message;

        //Next if condition does the job but, for some reason, the message is not prompted to the user.

        if (ddlType.Text == "Admin" && dataAccess.seleccct("[id]", "[FleetDB].[dbo].[Users]", "[UserType] = 'Admin'").Tables[0].Rows.Count == 1)
        {
            message = "This user cannot be deleted because it is currently the only 'Admin' type user.";

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);

            return;

        }
        
        message = "User has been removed successfuly.";

        dataAccess.delete("[FleetDB].[dbo].[Users]", "[id] = " + ddlUsersEdit.SelectedValue.ToString());

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + message + "')", true);

        ClearAll();

        EditRedirect();
    }

    // Helper methods

    public void ClearAll()
    {
        txtUsername.Text = "";
        txtPassword.Text = "";
        LoadDropDowns();
        chkActive.Checked = false;
        LoadTable();
    }

    public void EditRedirect()
    {
        btnAddView.Attributes["class"] = "list-group-item list-group-item-action";
        btnEditView.Attributes["class"] = "list-group-item list-group-item-action active";
        contentDiv.Visible = false;
        selectUserDiv.Visible = true;
        addBtns.Visible = false;
        modifyBtns.Visible = false;
    }

    public String ValidityOfForm()
    {

        if (!IsNotEmpty(txtUsername.Text))
        {
            return "Please enter a username.";
        }

        if (ddlType.SelectedIndex <= 0)
        {
            return "Please select the user type.";
        }

        if (addBtns.Visible)
        {
            // stripping string out of white space before checking
            if (dataAccess.seleccct("*", "[FleetDB].[dbo].[Users]", "REPLACE([Name], ' ', '')=N'" + txtUsername.Text.Replace(" ", "") + "'").Tables[0].Rows.Count > 0)
            {
                return "Username already exists.";
            }

            if (!IsNotEmpty(txtPassword.Text))
            {
                return "Please enter a password.";
            }
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
}
 using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Web.Configuration;
/// <summary>
/// Summary description for ADO
/// </summary>
public class ADO
{
	public ADO()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    // connection string needs to be altered depending on the data source PC/Server

    //My laptop connection string
    public String connectionString = @"Data Source=DESKTOP-40FBCE2\SQLEXPRESS;Initial Catalog=FleetDB;Integrated Security=True";

    //Server PC connection string
    //public String connectionString = @"Data Source=WIN-R9LAFNETQ4B\SQLEXPRESS;Initial Catalog=FleetDB;Integrated Security=True";

    //General connection string
    //public String connectionString = @"Data Source=.;Initial Catalog=FleetDB;Integrated Security=True";

    //Windows Server PC connection
    //public SqlConnection connectioString = new SqlConnection(@"Data Source=.;Initial Catalog=FleetDB;Integrated Security=True");

    //My Laptop connection
    //public SqlConnection connectioString = new SqlConnection(@"Data Source=DESKTOP-40FBCE2\SQLEXPRESS;Initial Catalog=FleetDB;Integrated Security=True");

    //My PC connection
    //public SqlConnection connectioString = new SqlConnection(@"Data Source=192.168.1.30,1433;Integrated Security=False;User ID=admin37;Password=Theadmin37;Connect Timeout=15;Encrypt=False;TrustServerCertificate=True;ApplicationIntent=ReadWrite;MultiSubnetFailover=False");

    public void excute(string command)
    {
        using (var connection = new SqlConnection(connectionString))
        {
            SqlCommand s = new SqlCommand(command, connection)
            {
                CommandTimeout = 100000
            };

            connection.Open(); // open it right before you execute something

            s.ExecuteNonQuery();
        }
    }

    public DataSet excute_DS(string command)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            SqlCommand s = new SqlCommand(command, connection)
            {
                CommandTimeout = 100000
            };

            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter(command, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }
        return Kds;
    }

    public DataSet seleccct(string tablename)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter("SELECT * FROM " + tablename, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }
        return Kds;
    }

    public DataSet seleccct(string tablename, string filter)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter("SELECT * FROM " + tablename + " WHERE " + filter, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }
        return Kds;
    }

    public DataSet seleccct(string selct_statment, int i)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter(selct_statment, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }
        return Kds;
    }

    public DataSet seleccct(string coloms, string tablename, string filter)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter("SELECT " + coloms + " FROM " + tablename + " WHERE " + filter, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }

        return Kds;
    }

    public DataSet seleccct(string coloms, string tablename, string filter, string sortcolom)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter("SELECT " + coloms + " FROM " + tablename + " WHERE " + filter + " order by " + sortcolom, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }

        return Kds;
    }

    public DataSet seleccctG(string coloms, string tablename, string filter, string Groupcol)
    {
        DataSet Kds;

        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open(); // open it right before you execute something

            SqlDataAdapter Kda = new System.Data.SqlClient.SqlDataAdapter("SELECT " + coloms + " FROM " + tablename + " WHERE " + filter + " Group by " + Groupcol, connection);
            Kda.SelectCommand.CommandTimeout = 1000000;
            Kds = new DataSet();
            Kda.Fill(Kds);
        }

        return Kds;
    }

    public void insert(string tabelname, string values)
    {
        values = "Insert Into " + tabelname + " Values ( " + values + " )";

        using (var connection = new SqlConnection(connectionString))
        {
            SqlCommand s = new SqlCommand(values, connection)
            {
                CommandTimeout = 100000
            };

            connection.Open(); // open it right before you execute something

            s.ExecuteNonQuery();
        }
    }

    public void insert(string tabelname, string coulums, string values)
    {
        string tab = tabelname;
        
        values = "Insert Into " + tabelname + " (" + coulums + ") Values ( " + values + " )";

        using (var connection = new SqlConnection(connectionString))
        {
            SqlCommand s = new SqlCommand(values, connection)
            {
                CommandTimeout = 100000
            };

            connection.Open(); // open it right before you execute something

            s.ExecuteNonQuery();
        }
    }

    public void Update(string tabelname, string ss, string cond)
    {
        ss = " Update " + tabelname + " set " + ss + " Where " + cond;

        using (var connection = new SqlConnection(connectionString))
        {
            SqlCommand s = new SqlCommand(ss, connection)
            {
                CommandTimeout = 100000
            };

            connection.Open(); // open it right before you execute something

            s.ExecuteNonQuery();
        }
    }

    public void delete(string tabelname, string filter)
    {
        filter = "delete from " + tabelname + " where " + filter;

        using (var connection = new SqlConnection(connectionString))
        {
            SqlCommand s = new SqlCommand(filter, connection)
            {
                CommandTimeout = 100000
            };

            connection.Open(); // open it right before you execute something

            s.ExecuteNonQuery();
        }
    }

    public bool checkpasswordvalid(String username, String password)
    {

        //Change Password Query of User with name 7amada and make password 123:--
        //UPDATE [FleetDB].[dbo].[Users] SET [Password]=EncryptByPassPhrase('YYW', '123' ) WHERE [Name]='7amada'

        //Insert User Query with name 7amda and password 7amada123 and type Cashier
        //INSERT INTO [FleetDB].[dbo].[Users] VALUES ('7amda',EncryptByPassPhrase('YYW', '7amada123' ),'Cashier',1)

        if (excute_DS("SELECT CONVERT(varchar(200),DecryptByPassPhrase('YYW',(SELECT TOP 1 [Password] FROM [FleetDB].[dbo].[Users] WHERE [Name]=N'" + username + "')))").Tables[0].Rows[0][0].ToString() == password)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
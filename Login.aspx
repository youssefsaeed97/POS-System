<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="./Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="./Style/Css/FleetStyle.css" rel="stylesheet" />
    <title>Fleet Club - Login</title>
    <style>
        html, body, .container-table {
            height: 100%;
        }

        .container-table {
            display: table;
        }

        .vertical-center-row {
            display: table-cell;
            vertical-align: middle;
        }

        .detailsFill {
            color:white;
            text-align: center;
            background-color: rgba(255, 255, 255, 0.1);
        }
    </style>
</head>

<body class="pageBackground">

    <div class="container container-table">
        <div class="row vertical-center-row">
            <div class="text-center col-sm-4 offset-sm-4">
                <form id="form1" runat="server">
                    <img src="./Style/Images/logoG.png" style="width: 70%; height: 70%;" />

                    <div class="text-center">

                        <h4 style="color: white;">Login</h4>
                        <asp:Label  id="labelTest" runat="server"></asp:Label>
                    </div>
                    <div class="row">

                        <asp:TextBox type="text" class="form-control detailsFill" runat="server" placeholder="Name" id="username" onfocus="this.placeholder = '' this.style=''" onblur="this.placeholder = 'Name'" />

                    </div>
                    <p></p>
                    <div class="row">

                        <asp:TextBox type="password" class="form-control detailsFill" runat="server" placeholder="Password" id="password" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Password'" />

                    </div>
                    <p></p>
                    <div class="row">
                        <asp:Button runat="server" text="Login" id="loginButton" class="btn btn-primary col-md-8"  onclick="login_clk"/>
                        <asp:Button runat="server" text="Reset" id="resetButton" class="btn btn-warning col-md-3 offset-md-1"  onclick="reset_clk"/>
                    </div>

                </form>
            </div>
        </div>
    </div>

</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Content.aspx.cs" Inherits="Admin_Content" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="../Style/Css/FleetStyle.css" rel="stylesheet" />
    <title>Fleet Club - Content</title>
    <style>
        div.tabItem:hover
        {
            background-color: gray;
            text-decoration: none;
        }
        
        div.tabItem
        {
            background-color: black;
            width: 100%;
            height: 100%;
        }
        
        a
        {
            color: white;
        }
        
        a:hover
        {
            text-decoration: none;
            color: white;
        }
        
        
        .custom-control-label::before ,.custom-control-label::after {
        right: 0 !important;
        }

        
        .col-sm-3
        {
            padding: 5px;
        }
        
        .fullsize
        {
            width: 100%;
            height: 100%;
        }
        
        img
        {
            max-width: 100%;
        }
        
        *
        {
            font-family: Arial;
        }
        
        form-control
        {
            text-align:center !important;
        }

    </style>
    <script type="text/javascript" src="../Scripts/Jquery-3.3.1/jquery-3.3.1.js"></script>
    <%--DataTables Scripts--%>
    <script type="text/javascript" src="../Scripts/datatables.min.js"></script>
    <script type="text/javascript" src="../Scripts/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="../Scripts/buttons.print.min.js"></script>
    <%--DataTables Styles--%>
    <link rel="stylesheet" type="text/css" href="../Scripts/datatables.min.css" />
    <link rel="stylesheet" type="text/css" href="../Scripts/buttons.dataTables.min.css" />
    <%--Dropdown Select--%>
    <script type="text/javascript" src="../Scripts/SearchableDrop/js/select2.js"></script>
    <script type="text/javascript" src="../Scripts/bootstrap.js"></script>
    <link href="../Scripts/SearchableDrop/css/select2.css" rel="stylesheet" />
    <script type="text/javascript">

        $(document).ready(function () {

           
        });

        function goBack() {
            window.history.back();
        }

    </script>
</head>
<body class="pageBackground" style="height: 100%!important">
    <form id="form1" runat="server">
        <%-------Top Menu-------%>
        <div class="navbar navbar-expand-lg navbar text-center col-sm-6 offset-sm-3">
            <div class="row" style="background-color: black; min-height: 5% !important; max-height: 10% !important">
                <div class="col-sm-2 pl-0">
                    <div class="thumbnail tabItem">
                        <a style="color: white" href="./Home.aspx">
                            <img src="../Style/Images/back.png" alt="Lights" style="max-width: 45%; max-height: 45%;
                                margin-top: 20%" />
                            <div class="caption">
                                <p>
                                    back</p>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4 offset-sm-2">
                    <div class="thumbnail">
                        <img src="../Style/Images/LogoFinal.png" alt="Lights" style="max-width: 60%; max-height: 60%" />
                    </div>
                </div>
                <div class="col-sm-2 offset-sm-2 pr-0">
                    <div class="thumbnail tabItem">
                        <a href="./Home.aspx">
                            <img src="../Style/Images/home.png" alt="Lights" style="max-width: 60%; max-height: 60%;
                                margin-top: 25%" />
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%-------End Of Top Menu-------%>
        <br />
        <div id="contentpage" runat="server" class="text-center row col-sm-8 offset-sm-2">
            <br />
            <div class="card" style="width: 100%!important">
                <asp:Label runat="server" class="card-header" ID="titleLabel" Style="background-color: Gray; font-size: 25px;">Content Control</asp:Label>
                <div class="card-body">
                    <br />
                    <div id="contentDiv" runat="server" visible="true">
                        <div class="row">
                            <div class="col-sm-2 text-left">
                                <asp:Label ID="lblRmdnReservations" runat="server" Text="Ramadan Reservations" Style="margin: auto; font-weight: bold; font-size: large;" ></asp:Label>
                            </div>
                            <div class="col-sm-10 text-left">
                                <asp:Button ID="btnResetRmdn" runat="server" Text="Reset" CssClass="btn btn-danger" style="width: 100px;" CommandArgument="" OnClientClick="return confirm('Are you sure you want to delete all Ramadan reservations?');" OnClick="TruncateRmdnReservations"/>
                                <asp:Label ID="lblRmdnWarning" runat="server" Text="(Deletes All Reservations Content Excluding Clients)" Style="margin-left: 10px;"></asp:Label>
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-sm-2 text-left">
                                <asp:Label ID="lblDatabase" runat="server" Text="Database" Style="margin: auto; font-weight: bold; font-size: large;" ></asp:Label>
                            </div>
                            <div class="col-sm-10 text-left">
                                <asp:Button ID="btnBackup" runat="server" Text="Backup" CssClass="btn btn-dark" style="width: 100px;" CommandArgument="" OnClientClick="return confirm('Are you sure you want to save a backup in the selected directory?');" OnClick="BackupDatabase"/>
                                <asp:TextBox ID="txtDirectory" runat="server" CssClass="form-control text-center text-muted align-middle" style="width: 250px; display: inline;" Text="C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\" ></asp:TextBox>
                                <asp:Label ID="lblBackupWarning" runat="server" Text="(Creates a backup of the current SQL database)" Style="margin-left: 10px;"></asp:Label>
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-sm-2 text-left">
                                <asp:Label ID="lblFix" runat="server" Text="Fix" Style="margin: auto; font-weight: bold; font-size: large;" ></asp:Label>
                            </div>
                            <div class="col-sm-10 text-left">
                                <asp:Button ID="btnFix" runat="server" Text="Fix" CssClass="btn btn-success" style="width: 100px;" CommandArgument="" OnClientClick="return confirm('Are you sure you want to proceed?');" OnClick="Fix"/>
                                <asp:Label ID="lblFixWarning" runat="server" Text="(Deletes All Undelivered/Error Items)" Style="margin-left: 10px;"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TableItems.aspx.cs" Inherits="AccountantGM_Void" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="../Style/Css/FleetStyle.css" rel="stylesheet" />
    <title>Fleet Club - Void Table</title>
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
    <script type="text/javascript">
        function goBack() {
            window.history.back();
        }
    </script>
    <%--J-QUERY--%>
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
            $("#tablesDD").select2({
                placeholder: "Choose Table",
                allowClear: true
            });

        });
    </script>
</head>
<body class="pageBackground" style="height: 100%!important">
    <div class="row" style="max-width: 100%;">
        <form id="Form1" class="text-center" runat="server">
        <asp:HiddenField runat="server" id="hdnTableID" />
        <%-------Top Menu-------%>
        <div class="navbar navbar-expand-lg navbar text-center col-sm-6 offset-sm-3">
            <div class="row" style="background-color: black; min-height: 5% !important; max-height: 10% !important">
                <div class="col-sm-2 pl-0">
                    <div class="thumbnail tabItem">
                        <a style="color: white" href="./DailyTables.aspx">
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
                <asp:Label runat="server" class="card-header" ID="Label1" Style="background-color: Gray;
                    font-size: 25px;">Table Items</asp:Label>
                <div class="card-body">
                <%--<asp:DropDownList runat="server" ID="tablesDD" Style="width: 50%;" AutoPostBack="true" OnSelectedIndexChanged="SelectTable"/>--%>
                <br />
                <br />
                <div id="ViewingContent" runat="server">
                    <div id="RepView" runat="server">
                    <asp:Repeater ID="tableViewRptr" runat="server">
                        <HeaderTemplate>
                            <table id="tableView" class="table table-striped text-center" width = "100%" role="grid">
                                <thead>
                                    <td></td>
                                    <td style="font-weight: bold; font-style: italic">
                                        الوجبة
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        الكمية
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        #
                                    </td>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr><td>
                                    <asp:Button Width="80%" class="btn btn-danger" ID="tbnTable" runat="server" Text="حذف" CommandArgument='<%#Eval("Item")%>' OnClientClick='<%#Eval("Item","return confirm(\" هل تريد حذف 1 {0}؟\")") %>'
                                        OnClick="DeleteRow" />
                                </td>
                                <td id="itemName" runat="server">
                                    <%# Eval("Item")%>
                                </td>
                                <td id="amountTD" runat="server">
                                    <%# Eval("Qty")%>
                                </td>
                                <td>
                                    #
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody> </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    </div>
                    </div>
                    <br />
                    <br />
                </div>
            </div>
        </div>
        </form>
        </div>
</body>
</html>


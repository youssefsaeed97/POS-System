<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Admin_Users" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="../Style/Css/FleetStyle.css" rel="stylesheet" />
    <title>Fleet Club - Users</title>
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

            $("#ddlUsersEdit").select2({
                placeholder: "Select User:",
                allowClear: true
            });

            $("#ddlType").select2({
                placeholder: "Select Type:",
                allowClear: true
            });

            $('#theTable').DataTable({
                dom: 'lBfrtip',
                buttons: [
            {
                extend: 'print',
                //autoPrint: false,
                title: '',
                //className: 'btn-dark',
                customize: function (win) {
                    $(win.document.body)
                        .css('font-size', '10pt')
                        .prepend(
                            `<br/>
                            <div class="thumbnail text-center">
                            <img src="http://10.0.0.94/Style/Images/LogoGrey.png" style="max-width: 10%; max-height: 10%;" />
                            </div>
                            <h1 class=\"text-center\">Current Users</h1>`
                        );

                    $(win.document.body).find('table')
                        .addClass('compact')
                        .css('font-size', 'inherit');
                }
            }
        ],

        "language": {
                    "sEmptyTable": "ليست هناك بيانات متاحة في الجدول",
                        "sLoadingRecords": "جارٍ التحميل...",
                        "sProcessing": "جارٍ التحميل...",
                        "sLengthMenu": "أظهر _MENU_ مدخلات",
                        "sZeroRecords": "لم يعثر على أية سجلات",
                        "sInfo": "إظهار _START_ إلى _END_ من أصل _TOTAL_ مدخل",
                        "sInfoEmpty": "يعرض 0 إلى 0 من أصل 0 سجل",
                        "sInfoFiltered": "(منتقاة من مجموع _MAX_ مُدخل)",
                        "sInfoPostFix": "",
                        "sSearch": "بحث:",
                        "sUrl": "",
                        "oPaginate": {
                            "sFirst": "الأول",
                            "sPrevious": "السابق",
                            "sNext": "التالي",
                            "sLast": "الأخير"
                        },
                        "oAria": {
                            "sSortAscending": ": تفعيل لترتيب العمود تصاعدياً",
                            "sSortDescending": ": تفعيل لترتيب العمود تنازلياً"
                        }
                    }
            });
        });

        function goBack() {
            window.history.back();
        }

    </script>
</head>
<body class="pageBackground" style="height: 100%!important">
    <form id="form1" class="text-center" runat="server">
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
                <asp:Label runat="server" class="card-header" ID="titleLabel" Style="background-color: Gray; font-size: 25px;">Users</asp:Label>
                <div class="card-body">
                    <div class="list-group list-group-horizontal" style="width: 100%">
                        <asp:Button id="btnAddView" runat="server" class="list-group-item list-group-item-action active" Text="Add User" OnClick="ViewToAdd"></asp:Button>
                        <asp:Button id="btnEditView" runat="server" class="list-group-item list-group-item-action" Text="Edit User" OnClick="ViewToEdit"></asp:Button>
                    </div>
                    <br />
                    <div id="selectUserDiv" class="text-center" runat="server" visible="false">
                        <asp:DropDownList runat="server" ID="ddlUsersEdit" Style="width: 50%;" AutoPostBack="true" OnSelectedIndexChanged="ViewUserToEdit"/>
                    </div>
                    <br />
                    <div id="contentDiv" runat="server" visible="true">
                        <%--Username--%>
                        <div class="row">
                            <div class="row col-sm-6">
                                <div class="col-sm-4">
                                    <asp:Label ID="lblUsername" runat="server" Text="Username:" class="form-text"></asp:Label>
                                </div>
                                <div class="col-sm-8 text-center">
                                    <asp:TextBox ID="txtUsername" runat="server" class="form-control text-center"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <br />
                        <%--Password--%>
                        <div class="row">
                            <div class="row col-sm-6">
                                <div class="col-sm-4">
                                    <asp:Label ID="lblPassword" runat="server" Text="Password:" class="form-text"></asp:Label>
                                </div>
                                <div class="col-sm-8 text-center">
                                    <asp:TextBox ID="txtPassword" runat="server" class="form-control text-center"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <br />
                        <%--Type--%>
                        <div class="row">
                            <div class="row col-sm-6">
                                <div class="col-sm-4">
                                    <asp:Label ID="lblType" runat="server" Text="Type:" class="form-text"></asp:Label>
                                </div>
                                <div class="col-sm-8 text-center">
                                    <asp:DropDownList ID="ddlType" runat="server" class="form-control text-center"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <br />
                        <%--Active--%>
                        <div class="row">
                            <div class="row col-sm-6">
                                <div class="offset-sm-4 col-sm-6 text-center">
                                    <asp:CheckBox ID="chkActive" runat="server" Text="Active" class="form-check" style="margin-left: -150px;"></asp:CheckBox>
                                </div>
                            </div>
                        </div>
                        <br />
                    </div>
                    <div class="row col-sm-6 align-content-center" id="addBtns" runat="server" visible="true">
                        <asp:Button ID="btnAddCard" class="btn btn-block btn-success" Text="Add" runat="server" style="width:100%" OnClick="AddCard"/>
                    </div>
                    <div class="row col-sm-6 offset-sm-3" id="modifyBtns" runat="server" visible="false">
                        <asp:Button ID="btnUpdateCard" class="btn btn-success" Text="Update" runat="server" style="width:50%" CommandArgument="" OnClientClick="return confirm('Are you sure you want to update this user?');" OnClick="UpdateCard"/>                        
                        <asp:Button ID="btnDeleteCard" class="btn btn-danger" Text="Delete" runat="server" style="width:50%" CommandArgument="" OnClientClick="return confirm('Are you sure you want to remove this user?');" OnClick="DeleteCard"/>
                    </div>
                    <br />
                </div>
            </div>
            <br />.<br />
            <div class="text-center" style="width:100%">
                <button class="btn btn-info" style="width:25%" type="button" data-toggle="collapse" data-target="#tableDiv" aria-expanded="false" aria-controls="tableDiv">View Users</button>
            </div>
            <br />.<br />
            <div class="card collapse" id="tableDiv" style="width: 100%!important">
                <asp:Label runat="server" class="card-header" ID="tableTitle" Style="background-color: Gray; font-size: 25px;">Current Users</asp:Label>
                <div id="tableView" class="card-body">
                    <asp:Repeater ID="repeaterFleet" runat="server">
                        <HeaderTemplate>
                            <table id="theTable" class="table table-striped text-center" style="width: 100%;" role="grid">
                                <thead>
                                    <td style="font-weight: bold; font-style: italic">
                                        #
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        Username
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        User Type
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        Active
                                    </td>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("RowNumber")%>
                                </td>
                                <td>
                                    <%# Eval("Name")%>
                                </td>
                                <td>
                                    <%# Eval("UserType")%>
                                </td>
                                <td>
                                    <%# Eval("Active")%>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody> </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

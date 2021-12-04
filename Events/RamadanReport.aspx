﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RamadanReport.aspx.cs" Inherits="Events_RamadanReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="../Style/Css/FleetStyle.css" rel="stylesheet" />
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
    <%--END--%>
    <title>Fleet Club - Ramadan Report</title>
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

        $(document).ready(function () {
            $('#theTable').DataTable({
                "order": [[15, "asc"]],
                dom: 'lBfrtip',
                buttons: [
                    {
                        extend: 'print',
                        autoPrint: false,
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
                            <h1 class=\"text-center\">نسبة الاشغال فى رمضان</h1>`
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

    </script>
</head>
<body class="pageBackground" style="height: 100%!important" >
    <form id="form1" runat="server">
        <%-------Top Menu GM-------%>
        <div class="navbar navbar-expand-lg navbar text-center col-sm-6 offset-sm-3">
            <div class="row" style="background-color: black; min-height: 5% !important; max-height: 10% !important">
                <div class="col-sm-2 pl-0">
                    <div class="thumbnail tabItem">
                        <a style="color: white" href="./Home.aspx">
                            <img src="../Style/Images/back.png" alt="Lights" style="max-width: 45%; max-height: 45%;
                                margin-top: 20%" />
                            <div class="caption">
                                <p>back</p>
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
        <div id="contentpage" runat="server" class="text-center row col-sm-10 offset-sm-1">
            <br />
            <div class="card" id="tableDiv" style="width: 100%!important" runat="server">
                    <asp:Label runat="server" class="card-header" ID="tableTitle" Style="background-color: Gray;font-size: 25px;">Ramadan Report</asp:Label>
                    <div class="card-body">
                    <div class="row">
                    <asp:Button ID="btnIftarReport" class="btn btn-dark col-lg-5" runat="server" Text="Iftar" OnClick="ReportIftar"/>
                    <asp:Button ID="btnSuhoorReport" Width="50%" class="btn btn-dark col-lg-5 offset-lg-2"  runat="server" Text="Suhoor" UseSubmitBehaviour = "false" OnClick="ReportSuhoor"/>
                    </div>
                    <div id="tableView" runat="server">
                    <asp:Repeater ID="rptrDailyReport" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table id="theTable" class="table table-striped table-bordered text-center" width = "100%" role="grid">
                                <thead>
                                    <td style="font-weight: bold; font-style: italic">
                                        اجمالى نسبة الاشغال
                                        <br />
                                        (%)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        الصاله المغلقه
                                        <br />
                                        (63)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        الشوايه
                                        <br />
                                        (60)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        الصاله المفتوحه
                                        <br />
                                        (75)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        الحديقه
                                        <br />
                                        (60)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        البيتا
                                        <br />
                                        (50)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        السمك
                                        <br />
                                        (66)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        %
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        النيل
                                        <br />
                                        (160)
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        #
                                    </td>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("Total")%>
                                </td>
                                <td>
                                    <%# Eval("InDoorP")%>
                                </td>
                                <td>
                                    <%# Eval("InDoor")%>
                                </td>
                                <td>
                                    <%# Eval("GrillP")%>
                                </td>
                                <td>
                                    <%# Eval("Grill")%>
                                </td>
                                <td>
                                    <%# Eval("OpenAirP")%>
                                </td>
                                <td>
                                    <%# Eval("OpenAir")%>
                                </td>
                                <td>
                                    <%# Eval("GardenP")%>
                                </td>
                                <td>
                                    <%# Eval("Garden")%>
                                </td>
                                <td>
                                    <%# Eval("BetaP")%>
                                </td>
                                <td>
                                    <%# Eval("Beta")%>
                                </td>
                                <td>
                                    <%# Eval("SeafoodP")%>
                                </td>
                                <td>
                                    <%# Eval("Seafood")%>
                                </td>
                                <td>
                                    <%# Eval("NileViewP")%>
                                </td>
                                <td>
                                    <%# Eval("NileView")%>
                                </td>
                                <td>
                                    <%# Eval("Day")%>
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
        </div>
    </form>
</body>
</html>

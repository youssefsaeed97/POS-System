<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FalandaraArchive.aspx.cs" EnableEventValidation="false" Inherits="Events_FalandaraArchive" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="../Style/Css/FleetStyle.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Scripts/datatables.min.css" />
    <script type="text/javascript" src="../Scripts/datatables.min.js"></script>

    <title>Fleet Club - El-Falandara Archive</title>
    <style>

        .center {
            display: block;
            margin: 40px auto;
            width: 50%;
        }

        div.tabItem:hover {
            background-color: gray;
            text-decoration: none;
        }

        div.tabItem {
            background-color: black;
            width: 100%;
            height: 100%;
        }

        a {
            color: white;
        }

            a:hover {
                text-decoration: none;
                color: white;
            }

        .col-sm-3 {
            padding: 5px;
        }

        .fullsize {
            width: 100%;
            height: 100%;
        }

        img {
            max-width: 100%;
        }

        .table-striped > tbody > tr:nth-child(2n+1) > td, .table-striped > tbody > tr:nth-child(2n+1) > th {
            background-color: gray;
            color:white;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#theTable').DataTable(
                {
                    "order": [[1, "asc"]],
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
            }
                );
        });
        function goBack() {
            window.history.back();
        }
    </script>
</head>
<body class="pageBackground" style="height: 100%!important">

    <div class="row" style="max-width: 100%;">
        <form id="Form1" class="text-center" runat="server">
            <%-------Top Menu-------%>
            <div class="navbar navbar-expand-lg navbar text-center col-sm-6 offset-sm-3">
                <div class="row" style="background-color: black; min-height: 5% !important; max-height: 10% !important">

                    <div class="col-sm-2 pl-0">
                        <div class="thumbnail tabItem">
                            <a style="color: white" href="./Home.aspx">
                                <img src="../Style/Images/back.png" alt="Lights" style="max-width: 45%; max-height: 45%; margin-top: 20%" />
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
                                <img src="../Style/Images/home.png" alt="Lights" style="max-width: 60%; max-height: 60%; margin-top: 25%" />
                            </a>
                        </div>
                    </div>

                </div>
            </div>
            <%-------End Of Top Menu-------%>
            <br />
            <div id="contentpage" runat="server" class="text-center row col-sm-6 offset-sm-3">

                <div class="card" style="width: 100%!important;">
                    <h3 class="card-header" style="color: black; background-color: white">تقارير الفلندره</h3>
                    <div class="card-content container" style="width: 100%!important">
                        <asp:Repeater ID="repeaterFleet" runat="server">
                            <HeaderTemplate>
                                <table id="theTable" class="table table-striped text-center" style="color: black; width: 100%!important" role="grid">
                                    <thead>
                                        <td style="width: 33%; font-weight: bold; font-style: italic"></td>
                                        <td style="width: 33%; font-weight: bold; font-style: italic">التاريخ</td>
                                        <td style="width: 33%; font-weight: bold; font-style: italic">رقم الفاتورة</td>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <asp:Button Width="80%" class="btn btn-dark" ID="tbnTable" runat="server" Text="عرض" CommandArgument='<%# Eval("TripID") %>' OnClick="btn_clk" /></td>
                                    <td><%# Eval("DateTime") %></td>
                                    <td><%# Eval("TripID") %></td>

                                </tr>

                            </ItemTemplate>
                            <FooterTemplate>
                                </tbody>
                                        </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>

                </div>
            </div>
        </form>
    </div>
</body>
</html>

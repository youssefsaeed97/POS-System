<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RamadanSituation.aspx.cs" Inherits="Events_RamadanSituation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%--bootstrap/jquery/popper--%>
    <link href="../Scripts/bootstrapv5.0/bootstrap.min.css" rel="stylesheet"/>
    <script type="text/javascript" src="../Scripts/jQuery-3.3.1/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../scripts/bootstrapv5.0/bootstrap.bundle.min.js" ></script>
    <%--DataTables Scripts--%>
    <script type="text/javascript" src="../Scripts/datatables.min.js"></script>
    <script type="text/javascript" src="../Scripts/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="../Scripts/buttons.print.min.js"></script>
    <%--DataTables Styles--%>
    <link rel="stylesheet" type="text/css" href="../Scripts/datatables.min.css" />
    <link rel="stylesheet" type="text/css" href="../Scripts/buttons.dataTables.min.css" />
    <title>Fleet Club - Ramadan Situation</title>
    <style>

        .center {
            display: block;
            margin: 40px auto;
            width: 50%;
        }

    </style>
    <script type="text/javascript">

        var ramDay = getParamValue('ramDay');
        var type = getParamValue('type');

        // debugging
        //var ramDay = 10;
        //var type = 'Iftar';

        $(document).ready(function () {
            $('#hdnRamadan').val(ramDay);
            $('#hdnType').val(type);
        })

        function getParamValue(paramName) {
            var url = window.location.search.substring(1); //get rid of "?" in querystring
            var qArray = url.split('&'); //get key-value pairs
            for (var i = 0; i < qArray.length; i++) {
                var pArr = qArray[i].split('='); //split key and value
                if (pArr[0] == paramName)
                    return pArr[1]; //return value
            }
        };

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdnRamadan" runat="server" />
        <asp:HiddenField ID="hdnType" runat="server"/>
        <br />
        <div style="text-align: left; margin-left: 50px;">
            <div runat="server" id="ramadanDate" style="display: inline;"></div>
            <div runat="server" id="date" style="display: inline; margin-left: 400px;"></div>
        </div>
        <div runat="server" id="type" style="margin-left: 50px;"></div>
        <div runat="server" id="totalGuests" style="margin-left: 50px;"></div>
        <img src="../Style/Images/LogoFinal.png" class="center" style="width: 140px; margin-bottom: 15px; margin-top: -10px;"/>
        <div class="center" style="text-align: center;">
            <asp:Button runat="server" ID="btnPrint" Class="center btn btn-primary" OnClick="LoadRptrs" Text="Print Hotel" style="display: inline;" />
            <asp:Button runat="server" ID="btnPrintFlndra" Class="center btn btn-primary" OnClick="LoadFlndra" Text="Print Falandara" style="display: inline;" />
            <asp:Button runat="server" ID="btnReport" Class="center btn btn-warning " OnClick="LoadReport" Text="Report" style="display: inline;" />
        </div>
        <div>
            <br />
            <asp:Repeater ID="rptrSituation" runat="server">
                <HeaderTemplate>
                    <table id="situation" class="table table-striped text-center">
                        <thead style="font-size: 14px;">
                            <td style="font-weight: bold; font-style: italic">
                                تعليق
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الوجبه
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                العدد
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                المدفوع
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الاشخاص
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                المكان
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الطاوله
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الاسم
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الفاتوره
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                #
                            </td>
                        </thead>
                        <tbody style="font-size: 14px;">
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Repeater ID="childRptrComment" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <%# Eval("Comment")%>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                                <td>
                                    <asp:Repeater ID="childRptrMeal" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <%# Eval("Meal")%>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                                <td>
                                    <asp:Repeater ID="childRptrPersons" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <%# Eval("Persons")%>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                                <td>
                                    <%# Eval("Deposit")%>
                                </td>
                                <td>
                                    <%# Eval("TotalPersons")%>
                                </td>
                                <td>
                                    <%# Eval("Venue")%>
                                </td>
                                <td>
                                    <%# Eval("TableNumber")%>
                                </td>
                                <td>
                                    <%# Eval("Name")%>
                                </td>
                                <td>
                                    <%# Eval("TableID")%>
                                    <asp:HiddenField runat="server" ID="tableID" Value='<%# Eval("TableID")%>' />
                                </td>
                                <td>
                                    <%# Eval("RowNumber")%>
                                </td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody> </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <div>
            <br />
            <asp:Repeater ID="rptrReport" runat="server">
                <HeaderTemplate>
                    <table id="report" class="table table-striped text-center">
                        <thead style="font-size: 14px;">
                            <td style="font-weight: bold; font-style: italic">
                                تعليق
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الوجبه
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                العدد
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                المدفوع
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الاجمالى
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الاشخاص
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                المكان
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الطاوله
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                التليفون
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الاسم
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الفاتوره
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                #
                            </td>
                        </thead>
                        <tbody style="font-size: 14px;">
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Repeater ID="childRptrCommentR" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <%# Eval("Comment")%>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                                <td>
                                    <asp:Repeater ID="childRptrMealR" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <%# Eval("Meal")%>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                                <td>
                                    <asp:Repeater ID="childRptrPersonsR" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <%# Eval("Persons")%>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </td>
                                <td>
                                    <%# Eval("Deposit")%>
                                </td>
                                <td>
                                    <%# Eval("TotalPrice")%>
                                </td>
                                <td>
                                    <%# Eval("TotalPersons")%>
                                </td>
                                <td>
                                    <%# Eval("Venue")%>
                                </td>
                                <td>
                                    <%# Eval("TableNumber")%>
                                </td>
                                <td>
                                    <%# Eval("PhoneNumber")%>
                                </td>
                                <td>
                                    <%# Eval("Name")%>
                                </td>
                                <td>
                                    <%# Eval("TableID")%>
                                    <asp:HiddenField runat="server" ID="tableID" Value='<%# Eval("TableID")%>' />
                                </td>
                                <td>
                                    <%# Eval("RowNumber")%>
                                </td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody> </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <div>
            <br />
            <hr style="height: 3px; width: 90%; text-align: center; margin-left: 5%; border: thin;" />
            <br />
            <asp:Repeater ID="rptrTotals" runat="server">
                <HeaderTemplate>
                    <table id="totals" class="table table-striped text-center">
                        <thead style="font-size: 14px;">
                            <td style="font-weight: bold; font-style: italic">
                                العدد
                            </td>
                            <td style="font-weight: bold; font-style: italic">
                                الوجبه
                            </td>
                        </thead>
                        <tbody style="font-size: 14px;">
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("TotalMeals")%>
                                </td>
                                <td>
                                    <%# Eval("Meal")%>
                                </td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody> </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>

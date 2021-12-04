<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Falandara.aspx.cs" Inherits="Events_Falandara" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <script type="text/javascript" src="../Scripts/jQuery-3.3.1/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../scripts/bootstrapv5.0/bootstrap.bundle.min.js" ></script>
    <%--start-date/time--%>
    <script type="text/javascript" src="../Scripts/js/popper.min.js"></script>
    <link href="../Scripts/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="../Scripts/js/moment.js"></script>
    <link href="../Style/Css/bootstrap-datetimepicker.css" rel="stylesheet" />
    <script type="text/javascript" src="../Scripts/js/bootstrap-datetimepicker.js"></script>
    <%--end-date/time--%>

    <title>Fleet Club - Falandara</title>

    <style>

        .myframe {
            margin: 40px auto;
            width: 1450px;
            height: 770px;
            background-color: wheat;
            border: outset;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: -6px 6px #999, -4px 4px #999, -2px 2px #999;
            
        }

        .center {
            display: block;
            margin: 40px auto;
            width: 50%;
        }

        body.pageBackground{
            height:100% !important;
            width: 99% !important;
            background-image:linear-gradient(to bottom right, #432 0%, #234 100%);
        }

        .lblheader {
            font-size: 30px;
            font-display: block;
            font-family: 'AR JULIAN';
            color: wheat;
        }

        .describe {
            font-size: 20px;
            font-display: fallback;
            font-family: Andalus;
            color: wheat
        }

        .container {
            background-color: lightgray;
            text-align: center;
            height: 35px;
            border: groove;
            font-size: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: black;
            font-family: 'AR JULIAN';
        }

    </style>

    <script type="text/javascript">

        $(function () {
            $('#txtDateTime').datetimepicker();
        });

    </script>

</head>
<body class="pageBackground">
    <form id="form1" runat="server">
        <div class="row">
            <div class="col-sm-1" style="margin-left: 22px;">
                <div class="thumbnail tabItem">
                    <a href="./Home.aspx">
                        <img src="../Style/Images/home.png" alt="Lights" style="max-width: 60%; max-height: 50%; margin-top: 20%" />
                    </a>
                </div>
            </div>
        </div>
        <div id="TripSelect">
            <img src="../Style/Images/LogoFinal.png" class="center" style="width: 140px"/>
            <h1 class="lblheader text-center" style="font-size: 45px;" >El-Falandara</h1>
            <div class="row">
                <div class="offset-sm-4 col-sm-4" >
                    <asp:TextBox runat="server" ID="txtDateTime" class="form-control text-center" />
                </div>
            </div>
            <asp:Button runat="server" ID="btnSubmit" Text="Submit" CssClass="btn btn-warning center" Width="200px" OnClick="Submit" />
            <asp:DropDownList runat="server" ID="ddlDateTime" CssClass="center form-control" style="text-align-last: center; width:400px;" AutoPostBack="true" OnSelectedIndexChanged="ViewSelectedTrip" />
        </div>
        <br />
        <div id="TripDetails" runat="server" class="text-center row col-sm-8 offset-sm-2" visible="false">
            <br />
            <div class="card" id="tableDiv" style="width: 100%!important" runat="server">
                <asp:Label runat="server" class="card-header lblheader" ID="tableTitle" Style="background-color: Gray; font-size: 25px;">Trip Details</asp:Label>
                <div style="align-content: center; margin-top: 5px;">
                    <asp:Label runat="server" class="lblheader" ID="lblTbls" style="font-size: 15px; color: dimgray; display: inline;"/>
                    <asp:Label runat="server" class="lblheader" ID="lblPrsns" style="font-size: 15px; color: dimgray; display: inline;"/>
                </div>
                <br />
                <div class="card-body">
                    <div class="row">
                        <asp:Label runat="server" ID="lblDeck2" Text="Deck 2" CssClass="offset-sm-5 col-sm-2" style="font-family: 'AR JULIAN'; font-size: 30px;"/>
                    </div>
                    <div style="align-content: center; margin-bottom: 30px;">
                        <asp:Label runat="server" ID="lblTbls2" style="font-family: 'AR JULIAN'; font-size: 15px; display: inline;"/>
                        <asp:Label runat="server" ID="lblPrsns2" style="font-family: 'AR JULIAN'; font-size: 15px; display: inline;"/>
                    </div>
                    <div class="row" style="align-content: center;" >
                        <asp:Button runat="server" ID="btnPlusDeck2" class="offset-sm-3 col-sm-2 btn btn-dark" style="display: inline; font-weight: bold; font-size:20px;" Text="+" OnClick="AddReservation" />
                        <asp:DropDownList runat="server" ID="ddlDeck2" CssClass="form-control col-sm-4" style="display: inline; margin-left: 10px; margin-top: 3px;" AutoPostBack="true" OnSelectedIndexChanged="ViewReservation" />
                    </div>
                    <div class="row" style="margin-top: 60px;">
                        <asp:Label runat="server" ID="lblDeck1" Text="Deck 1" CssClass="offset-sm-5 col-sm-2" style="font-family: 'AR JULIAN'; font-size: 30px;"/>
                    </div>
                    <div style="align-content: center; margin-bottom: 30px;">
                        <asp:Label runat="server" ID="lblTbls1" style="font-family: 'AR JULIAN'; font-size: 15px; display: inline;"/>
                        <asp:Label runat="server" ID="lblPrsns1" style="font-family: 'AR JULIAN'; font-size: 15px; display: inline;"/>
                    </div>
                    <div class="row" style="align-content: center;" >
                        <asp:Button runat="server" ID="btnPlusDeck1" class="offset-sm-3 col-sm-2 btn btn-dark" style="display: inline; font-weight: bold; font-size:20px;" Text="+" OnClick="AddReservation" />
                        <asp:DropDownList runat="server" ID="ddlDeck1" CssClass="form-control col-sm-4" style="display: inline; margin-left: 10px; margin-top: 3px;" AutoPostBack="true" OnSelectedIndexChanged="ViewReservation" />
                    </div>
                    <br />
                    <br />
                    <br />
                    <div class="row" style="align-content: center;" >
                        <asp:Button runat="server" ID="btnSubmitTrip" class="offset-sm-2 col-sm-2 btn btn-success" style="display: inline;" Text="Submit" CommandArgument="" OnClientClick="return confirm('Are you sure you want to submit this trip?');" OnClick="SubmitTrip" />
                        <asp:Button runat="server" ID="btnPrintTrip" class="offset-sm-1 col-sm-2 btn btn-secondary " style="display: inline;" Text="Print" OnClick="PrintTrip" />
                        <asp:Button runat="server" ID="btnDeleteTrip" class="offset-sm-1 col-sm-2 btn btn-danger" style="display: inline;" Text="Delete" CommandArgument="" OnClientClick="return confirm('Are you sure you want to delete this trip?');" OnClick="DeleteTrip" />
                    </div>
                </div>
            </div>
        </div>
        <div id="reservationView" runat="server" style="margin: auto" visible="false">
            <iframe runat="server" id="reservationDetails" src="FalandaraReservationDetails.aspx" class="myframe"></iframe>
            <asp:Button runat="server" ID="btnCloseForm" class="center btn btn-dark" style="width: 25%; border: groove;" Text="Close" OnClick="CloseForm" />
        </div>
        <br />
        <br />
    </form>
</body>
</html>

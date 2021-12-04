<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Events_Home" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../Style/Css/bootstrap.css" rel="stylesheet" />
    <link href="../Style/Css/FleetStyle.css" rel="stylesheet" />
    <title>Fleet Club - Events Home</title>
    <style>
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
    </style>
    <script type="text/javascript">
        function goBack() {
            window.history.back();
        }
    </script>
</head>

<body class="pageBackground" style="height: 100%!important">

    <div class="row" style="max-width: 100%;">
        <form runat="server" id="Form1" class="text-center" style="width:100%">
            <%-------Top Menu-------%>
            <div class="navbar navbar-expand-lg navbar text-center col-sm-6 offset-sm-3">
                <div class="row" style="background-color: black; min-height: 5% !important; max-height: 10% !important">

                    <div class="col-sm-2 pl-0">
                        <div class="thumbnail">
                            <a style="color: white" href="../Login.aspx">
                                <img src="../Style/Images/backBlack.png" alt="Lights" style="max-width: 45%; max-height: 45%; margin-top: 20%" />
                                <div class="caption">
                                <br />
                                    <p style="font-style:italic; text-decoration:underline">Logout</p>
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
                         <div class="thumbnail">
                        <a>
                            <img src="../Style/Images/backBlack.png" alt="Lights" style="max-width:60%; max-height:60%;  margin-top:25%"/>
                        </a>
                    </div>
                    </div>

                </div>
            </div>
            <%-------End Of Top Menu-------%>
            <br />
            <br />
            <br />
            <%--Page Content--%>
            <div class="text-center row col-sm-6 offset-sm-3" id="contentpage" runat="server">
                <div class="col-sm-4">
                    <div class="thumbnail  tabItem">
                        <a href="./RamadanTableReservation.aspx">
                            <img src="../Style/Images/ramadan.png" alt="Nature" style="width: 100%" />
                            <div class="caption">
                            <p>Ramadan Reservations</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="thumbnail  tabItem">
                        <a href="./Falandara.aspx">
                            <img src="../Style/Images/bbb.png" alt="Nature" style="width: 100%" />
                            <div class="caption">
                            <p>Falandara</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="thumbnail tabItem">
                        <a href="./FalandaraArchive.aspx">
                            <img src="../Style/Images/bbb.png" alt="Lights" style="width: 100%" />
                            <div class="caption">
                                <p>Falandara Archive</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            <br />
            <%--<div class="text-center row col-sm-6 offset-sm-3" id="Div1" runat="server">
                <div class="col-sm-4">
                    <div class="thumbnail tabItem">
                        <a href="./PortInventory.aspx">
                            <img src="../Style/Images/bbb.png" alt="Lights" style="width: 100%" />
                            <div class="caption">
                                <p>رصيد المنفذ</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="thumbnail tabItem">
                        <a href="./Inventory.aspx">
                            <img src="../Style/Images/bbb.png" alt="Fjords" style="width: 100%" />
                            <div class="caption">
                                <p>رصيد المخزن</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="thumbnail tabItem">
                        <a href="./CardTypes.aspx">
                            <img src="../Style/Images/Scale.png" alt="Fjords" style="width: 90%; margin-top:1%;" />
                            <div class="caption">
                            <p></p>
                                <p>اوزان اصناف المخزن</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            <br />
            <div class="text-center row col-sm-6 offset-sm-3" id="Div2" runat="server">
            <div class="col-sm-4">
                    <div class="thumbnail tabItem">
                        <a href="./Butcher.aspx">
                            <img src="../Style/Images/haen-meats-knives.png" alt="Lights" style="width: 100%" />
                            <div class="caption">
                                <p>الجزار</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="thumbnail  tabItem">
                        <a href="./OfficerTableCost.aspx">
                            <img src="../Style/Images/Clients.png" alt="Nature" style="width: 100%" />
                            <div class="caption">
                            <p>حساب الضيافة</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="thumbnail  tabItem">
                        <a href="./Void.aspx">
                            <img src="../Style/Images/Closed.png" alt="Nature" style="width: 100%" />
                            <div class="caption">
                            <p>Void</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            <br />
            <div class="text-center row col-sm-6 offset-sm-3">
            <div class="col-sm-4">
                    <div class="thumbnail tabItem">
                        <a href="./DayReport.aspx">
                            <img src="../Style/Images/contact.png" alt="Lights" style="width: 100%" />
                            <div class="caption">
                                <p>Daily Report</p>
                                <br />
                            </div>
                        </a>
                    </div>
                </div>
                </div>
            <br />--%>
            <%--End Of Page Content--%>
        </form>
    </div>
</body>
</html>

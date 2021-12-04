<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RamadanTableReservation.aspx.cs" Inherits="Events_RamadanTableReservation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Scripts/bootstrapv5.0/bootstrap.min.css" rel="stylesheet"/>
    <script type="text/javascript" src="../Scripts/jQuery-3.3.1/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../scripts/bootstrapv5.0/bootstrap.bundle.min.js" ></script>
    <%--<script type="text/javascript" src="../Scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="../Scripts/js/popper.min.js"></script>--%>
    
    <title>Fleet Club - Ramadan Table Reservations</title>
    
    <style>

        .myframe {
            margin: 40px auto;
            width: 1500px;
            height: 975px;
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
            color: wheat
        }

        .describe {
            font-size: 20px;
            font-display: fallback;
            font-family: Andalus;
            color: wheat
        }

        .container {
            padding: 5px;
            margin: 5px;
            background-color: lightgreen;
            text-align: center;
            height: 50px;
            border: outset;
            font-size: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: -3px 3px #999, -2px 2px green, -1px 1px green;
            color: darkslategrey;
        }

        .container:hover{
        cursor: pointer;
        color: white;
        background-color: darkslategrey;
        resize: both;
        transform: scale(1.04);
        }

        .container:active{
        border-bottom: 3px solid #999;
        top: 3px;
        }

        .full {
            padding: 5px;
            margin: 5px;
            background-color: firebrick;
            text-align: center;
            height: 50px;
            border: outset;
            font-size: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: -3px 3px #999, -2px 2px green, -1px 1px green;
            color: wheat;
        }

        .full:hover{
        cursor: pointer;
        color: white;
        background-color: darkred;
        resize: both;
        transform: scale(1.04);
        }

        .full:active{
        border-bottom: 3px solid #999;
        top: 3px;
        }

    </style>
    <script type="text/javascript">

        $(document).ready(function () {

            //might need to add LoadView fn

            $(".container, .full").on('click', function (event) {
                $('#ddls').css('display', 'none');
                $('#tablesView').css('display', 'none');
                $('#reservationView').css('display', 'block');
                $('#reservationDetails').attr('src', "RamadanReservationDetails.aspx?tableNum=" + event.target.id + "&ramDay=" + $("#ddlRamadanDay option:selected").text() + "&venue=" + $("#" + event.target.id).parent().attr('id') + "&type=" + $("#ddlType option:selected").text() + "&tableID=" + $("#ddlFlndra option:selected").val());
            });

            $("#ddlFlndra").change(function (event) {
                $('#ddls').css('display', 'none');
                $('#tablesView').css('display', 'none');
                $('#reservationView').css('display', 'block');
                $('#reservationDetails').attr('src', "RamadanReservationDetails.aspx?tableNum=" + event.target.id + "&ramDay=" + $("#ddlRamadanDay option:selected").text() + "&venue=" + $("#" + event.target.id).parent().attr('id') + "&type=" + $("#ddlType option:selected").text() + "&tableID=" + $("#ddlFlndra option:selected").val());
            });
        });

        function ShowTables() {

            $('#ddls').css('display', 'block');
            $('#tablesView').css('display', 'block');
            $('#reservationView').css('display', 'none');
        }

        function LoadView() {

            $.ajax({
                type: "POST",
                url: "RamadanTableReservation.aspx/LoadView",
                data: "{ramdDay:" + $('#ddlRamadanDay').val() + ", type:'" + $('#ddlType').val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function LoadViewT(data) {

                    $("#tablesView").css('display', 'block');
                    
                    $(".full").each(function () {
                        $('#' + this.id).toggleClass('full container');
                    });
                    
                    var obj = JSON.parse(data.d);
                    for (var key in obj) {
                        if (obj.hasOwnProperty(key)) {
                            var table = obj[key];
                            if (table != 0) {
                                $('#' + table + '.container').toggleClass("container full");
                            }
                        }
                    }

                    $("#btnPrint").css('display', 'inline');

                    LoadFlndra();
                },
                error: function LoadViewF() {

                    //alert("Failed to load view.");
                }
            });
        };

        function LoadFlndra() {
            $.ajax({
                type: "POST",
                url: "RamadanTableReservation.aspx/LoadFlndra",
                data: "{ramdDay:" + $('#ddlRamadanDay').val() + ", type:'" + $('#ddlType').val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function LoadFlndraT(data) {

                    ClearFlndraDDL();

                    data = JSON.parse(data.d)
                    $.each(data, function (index, itemData) {

                        var text = itemData[0];
                        var value = itemData[1];
                        AddToFlndraDDL(text, value);
                    });
                },
                error: function LoadFlndraF() {
                    alert("Failed to load Falandara list.")
                }
            });
        };

        function AddToFlndraDDL(text, value) {

            var ddl = document.getElementById("<%=ddlFlndra.ClientID %>");
            var option = document.createElement("OPTION");
            option.innerHTML = text;
            option.value = value;
            ddl.options.add(option);
            document.getElementById("ddlFlndra").options[0].disabled = true;
        };

        function ClearFlndraDDL(text, value) {

            var ddl = document.getElementById("<%=ddlFlndra.ClientID %>");
            var option = document.createElement("OPTION");
            ddl.options.length = 0;
            ddl.innerHTML = "";
            option.innerHTML = "Reservation:";
            option.value = "0";
            ddl.options.add(option);
            document.getElementById("ddlFlndra").options[0].disabled = true;
        };

    </script>
</head>
<body class="pageBackground">
    <form id="form1" runat="server">
        <br />
        <img src="../Style/Images/LogoFinal.png" class="center" style="width: 140px"/>
        <h1 class="lblheader text-center " style="font-size: 45px;" >Ramadan Nights</h1>
        <div id="ddls" class="center" style="text-align: center; display: block;">
            <asp:DropDownList class="form-select" style="width: 200px; display: inline;" runat="server" ID="ddlRamadanDay" AutoPostBack="false" onchange="LoadView();"></asp:DropDownList>
            <asp:DropDownList class="form-select" style="width: 200px; display: inline;" runat="server" ID="ddlType" AutoPostBack="false" onchange="LoadView();"></asp:DropDownList>
            <asp:Button runat="server" style="display: none; width: 100px; margin-bottom: 4px; margin-left: 20px;" class="btn btn-primary" ID="btnPrint" Text="Print" OnClick="Redirect_Print"/>
        </div>
        <div id="tablesView" style="display: none;">
            <br /><br />
        <div class="row">
            <div class="row offset-sm-1 col-sm-3">
                <div id="lblSeafood" class="lblheader">Seafood:</div>
                <div class="describe">30 - 36: 8 per Table</div>
                <div class="describe">37 - 41: 2 per Table</div>
            </div>
            <div class="row offset-sm-1 col-sm-7" >
                <div id="lblNileView" class="lblheader">Nile View:</div>
                <div class="describe">8/6 per Table</div>
                <div class="describe">1 - 15: first row</div>
                <div class="describe">16 - 23: second row</div>
            </div>
        </div>
        <div class="row">
            <div id="Seafood" class="row offset-sm-1 col-sm-3">
                <div id="30" class="container col-sm-2">30</div>
                <div id="31" class="container col-sm-2">31</div>
                <div id="32" class="container col-sm-2">32</div>
                <div id="33" class="container col-sm-2">33</div>
                <div id="34" class="container col-sm-2">34</div>
            </div>
            <div id="NileView" class="row offset-sm-1 col-sm-7" >
                <div id="1" class="container col-sm-1">1</div>
                <div id="2" class="container col-sm-2">2</div>
                <div id="3" class="container col-sm-1">3</div>
                <div id="4" class="container col-sm-2">4</div>
                <div id="5" class="container col-sm-1">5</div>
                <div id="6" class="container col-sm-2">6</div>
                <div id="7" class="container col-sm-1">7</div>
            </div>
        </div>
        <div class="row">
            <div id="Seafood" class="row offset-sm-1 col-sm-3">
                    <div id="35" class="container col-sm-2">35</div>
                    <div id="36" class="container col-sm-2">36</div>
            </div>
            <div id="NileView" class="row offset-sm-1 col-sm-7" >
                <div id="8" class="container col-sm-2">8</div>
                <div id="9" class="container col-sm-1">9</div>
                <div id="10" class="container col-sm-2">10</div>
                <div id="11" class="container col-sm-1">11</div>
                <div id="12" class="container col-sm-2">12</div>
                <div id="13" class="container col-sm-1">13</div>
            </div>
        </div>
        <div class="row">
            <div id="Seafood" class="row offset-sm-1 col-sm-3">
                <div id="37" class="container col-sm-2">37</div>
                <div id="38" class="container col-sm-2">38</div>
                <div id="39" class="container col-sm-2">39</div>
                <div id="40" class="container col-sm-2">40</div>
                <div id="41" class="container col-sm-2">41</div>
            </div>
            <div id="NileView" class="row offset-sm-1 col-sm-7" >
                <div id="14" class="container col-sm-2">14</div>
                <div id="15" class="container col-sm-1">15</div>
                <div id="16" class="container col-sm-2">16</div>
                <div id="17" class="container col-sm-1">17</div>
                <div id="18" class="container col-sm-2">18</div>
                <div id="19" class="container col-sm-1">19</div>
            </div>
        </div>
        <div class="row">
            <div class="row offset-sm-1 col-sm-3"></div>
            <div id="NileView" class="row offset-sm-1 col-sm-7" >
                <div id="20" class="container col-sm-2">20</div>
                <div id="21" class="container col-sm-1">21</div>
                <div id="22" class="container col-sm-2">22</div>
                <div id="23" class="container col-sm-1">23</div>
            </div>
        </div>
        <br /><br /><br />
        <div class="row">
            <div class="row offset-sm-1 col-sm-3">
                <div class="row">
                    <div id="lblOpenAir" class="lblheader">Open Air:</div>
                    <div class="describe">5 per Table</div>
                </div>
                <div id="OpenAir" class="row">
                    <div id="600" class="container col-sm-2">600</div>
                    <div id="601" class="container col-sm-2">601</div>
                    <div id="602" class="container col-sm-2">602</div>
                    <div id="603" class="container col-sm-2">603</div>
                </div>
                <div id="OpenAir" class="row">
                    <div id="604" class="container col-sm-2">604</div>
                    <div id="605" class="container col-sm-2">605</div>
                    <div id="606" class="container col-sm-2">606</div>
                    <div id="607" class="container col-sm-2">607</div>
                </div>
                <div id="OpenAir" class="row">
                    <div id="608" class="container col-sm-2">608</div>
                    <div id="609" class="container col-sm-2">609</div>
                    <div id="610" class="container col-sm-2">610</div>
                    <div id="611" class="container col-sm-2">611</div>
                </div>
                <div id="OpenAir" class="row">
                    <div id="612" class="container col-sm-2">612</div>
                    <div id="613" class="container col-sm-2">613</div>
                    <div id="614" class="container col-sm-2">614</div>
                </div>
            </div>
            <div class="row col-sm-4">
                <div class="row">
                    <div id="lblGarden" class="lblheader">Garden:</div>
                    <div class="describe">6 per Table</div>
                </div>
                <div id="Garden" class="row">
                    <div id="50" class="container col-sm-1">50</div>
                    <div id="51" class="container col-sm-1">51</div>
                    <div id="52" class="container col-sm-1">52</div>
                    <div id="53" class="container col-sm-1">53</div>
                    <div id="54" class="container col-sm-1">54</div>
                    <div id="55" class="container col-sm-1">55</div>
                    <div id="56" class="container col-sm-1">56</div>
                    <div id="57" class="container col-sm-1">57</div>
                </div>
                <div id="Garden" class="row">
                    <div id="58" class="container col-sm-1">58</div>
                    <div id="59" class="container col-sm-1">59</div>
                </div>
            </div>
            <div class="row col-sm-4">
                <div class="row">
                    <div id="lblBeta" class="lblheader">Beta:</div>
                    <div class="describe">70 - 76: 6 per Table</div>
                    <div class="describe">77 - 78: 8 per Table</div>
                </div>
                <div id="Beta" class="row">
                    <div id="70" class="container col-sm-1">70</div>
                    <div id="71" class="container col-sm-1">71</div>
                    <div id="72" class="container col-sm-1">72</div>
                    <div id="73" class="container col-sm-1">73</div>
                    <div id="74" class="container col-sm-1">74</div>
                    <div id="75" class="container col-sm-1">75</div>
                    <div id="76" class="container col-sm-1">76</div>
                </div>
                <div id="Beta" class="row">
                    <div id="77" class="container col-sm-1">77</div>
                    <div id="78" class="container col-sm-1">78</div>
                </div>
            </div>
        </div>
        <br /><br /><br />
        <div class="row">
            <div class="row offset-sm-1 col-sm-3">
                <div class="row">
                    <div id="lblFalandara" class="lblheader">Falandara:</div>
                    <div class="describe"> ... </div>
                </div>
                <div id="Falandara" class="row" style="align-content: center;">
                    <div id="0" class="container col-sm-3" style="height: 50px;" >Add</div>
                    <asp:DropDownList runat="server" ID="ddlFlndra" class="form-select col-sm-1" style="margin: auto; margin-left: 5px; display: inline; height: 40px; width: 250px;" />
                </div>
            </div>
            <div class="row col-sm-4">
                <div class="row">
                    <div id="lblInDoor" class="lblheader">In Door:</div>
                    <div class="describe">6/5 per Table</div>
                </div>
                <div id="InDoor" class="row">
                    <div id="501" class="container col-sm-3">501</div>
                    <div id="502" class="container col-sm-3">502</div>
                    <div id="503" class="container col-sm-3">503</div>
                </div>
                <div id="InDoor" class="row offset-sm-1">
                    <div id="504" class="container col-sm-2">504</div>
                    <div id="505" class="container col-sm-2">505</div>
                    <div id="506" class="container col-sm-2">506</div>
                </div>
                <div id="InDoor" class="row offset-sm-1">
                    <div id="507" class="container col-sm-2">507</div>
                    <div id="508" class="container col-sm-2">508</div>
                    <div id="509" class="container col-sm-2">509</div>
                </div>
                <div id="InDoor" class="row offset-sm-1">
                    <div id="510" class="container col-sm-2">510</div>
                    <div id="511" class="container col-sm-2">511</div>
                    <div id="512" class="container col-sm-2">512</div>
                </div>
            </div>
            <div class="row col-sm-4">
                <div class="row">
                    <div id="lblGrill" class="lblheader">Grill:</div>
                    <div class="describe">4 per Table</div>
                </div>
                <div id="Grill" class="row">
                        <div id="79" class="container col-sm-1">79</div>
                        <div id="80" class="container col-sm-1">80</div>
                        <div id="81" class="container col-sm-1">81</div>
                        <div id="82" class="container col-sm-1">82</div>
                        <div id="83" class="container col-sm-1">83</div>
                        <div id="84" class="container col-sm-1">84</div>
                        <div id="85" class="container col-sm-1">85</div>
                        <div id="86" class="container col-sm-1">86</div>
                    </div>
                    <div id="Grill" class="row">
                        <div id="87" class="container col-sm-1">87</div>
                        <div id="88" class="container col-sm-1">88</div>
                        <div id="89" class="container col-sm-1">89</div>
                        <div id="90" class="container col-sm-1">90</div>
                        <div id="91" class="container col-sm-1">91</div>
                        <div id="92" class="container col-sm-1">92</div>
                        <div id="93" class="container col-sm-1">93</div>
                    </div>
                </div>
        </div>
        </div>
        <br /><br /><br />
        <div id="reservationView" style="display: none; margin-left: 30px">
            <iframe id="reservationDetails" src="RamadanReservationDetails.aspx" class="myframe"></iframe>
            <asp:Button runat="server" ID="btnViewTables" class="center btn btn-dark" style="width: 25%; border: groove;" Text="Show Tables" OnClientClick="javascript: LoadView(); ShowTables(); return false;" />
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RamadanReservationDetails.aspx.cs" Inherits="Events_RamadanReservationDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%--start-bootstrap/jquery/popper--%>
    <link href="../Scripts/bootstrapv5.0/bootstrap.min.css" rel="stylesheet"/>
    <script type="text/javascript" src="../Scripts/jQuery-3.3.1/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../scripts/bootstrapv5.0/bootstrap.bundle.min.js" ></script>
    <%--end-bootstrap/jquery/popper--%>
    <title>Fleet Club - Ramadan Reservation Details</title>
    <style>

        .center {
            display: block;
            margin: 40px auto;
            width: 50%;
        }

        body {
            height: 100%;
            background-image:linear-gradient(to bottom right, wheat 0%, #875904 100%);
            width: 99%;
        }

        .col-form-label {
            font-size: 18px;
        }

        .rptrCheckIftar {}

        .rptrQuantityIftar {}

        .rptrCommentIftar {}

        .rptrCheckSuhoor {}

        .rptrQuantitySuhoor {}

        .rptrCommentSuhoor {}

        .rptrCheckExtra {}

        .rptrQuantityExtra {}

        .rptrCommentExtra {}

    </style>
    <script type="text/javascript">

        var tableNum = getParamValue('tableNum');
        //check next line for errors
        var ramDay = getParamValue('ramDay');
        //alert(ramDay)
        var venue = getParamValue('venue');
        var type = getParamValue('type');
        var tableID = getParamValue('tableID');

        $(document).ready(function () {

            try {

                $('#' + type).css('display', 'block');
                if (type == "Iftar") {
                    $('#Extra').css('display', 'block');
                };
                $('#staticVenue').val(venue);
                $('#staticTableNumber').val(tableNum);
                $('#staticRamadan').val(ramDay);
                $('#staticType').val(type);
                $('#hdnVenue').val(venue);
                $('#hdnTableNumber').val(tableNum);
                $('#hdnRamadan').val(ramDay);
                $('#hdnType').val(type);
                $('#hdnTableID').val(tableID);

            } catch {

                //not working / not an issue for now
                alert("Loaded individually.");
            }

            $(".rptrCheck" + type).change(function () {

                var ind = $(this).parent().parent().parent().children();
                var i = ind.index($(this).parent().parent());

                if (!this.children[0].checked) {
                    
                    CalculateTotal();
                    CalculateBalance();

                    $(".rptrQuantity" + type + ":eq(" + i + ")").val(Number("0"));
                    $(".rptrComment" + type + ":eq(" + i + ")").val(".");
                }

                $(".rptrQuantity" + type + ":eq(" + i + ")").prop('readonly', !this.children[0].checked);
                $(".rptrComment" + type + ":eq(" + i + ")").prop('readonly', !this.children[0].checked);

                
            });

            if (type == "Iftar") {

                $(".rptrCheckExtra").change(function () {

                    var ind = $(this).parent().parent().parent().children();
                    var i = ind.index($(this).parent().parent());

                    if (!this.children[0].checked) {

                        CalculateTotal();
                        CalculateBalance();

                        $(".rptrQuantityExtra:eq(" + i + ")").val(Number("0"));
                        $(".rptrCommentExtra:eq(" + i + ")").val(".");
                    }

                    $(".rptrQuantityExtra:eq(" + i + ")").prop('readonly', !this.children[0].checked);
                    $(".rptrCommentExtra:eq(" + i + ")").prop('readonly', !this.children[0].checked);


                });
            };
            
        });

        function getParamValue(paramName) {
            var url = window.location.search.substring(1); //get rid of "?" in querystring
            var qArray = url.split('&'); //get key-value pairs
            for (var i = 0; i < qArray.length; i++) {
                var pArr = qArray[i].split('='); //split key and value
                if (pArr[0] == paramName)
                    return pArr[1]; //return value
            }
        };

        function CalculateTotal() {

            var total = Number('0');
            var totalPersons = Number('0');
            var chkd = 0;

            var lstChecks = document.getElementsByClassName('rptrCheck' + type);
            var lstPrice = document.getElementsByClassName('rptrPrice' + type);
            var lstQuantity = document.getElementsByClassName('rptrQuantity' + type);

            $.each(lstQuantity, function (i, item) {

                if (lstChecks[i].children[0].checked) {
                    totalPersons += Number(lstQuantity[i].value);
                    total += Number(lstQuantity[i].value) * Number(lstPrice[i].textContent);
                    chkd += 1;
                }
            });

            if (type == 'Iftar') {

                var totalExtra = Number('0');
                var totalPersonsExtra = Number('0');
                var chkdExtra = 0;
                var lstChecksExtra = document.getElementsByClassName('rptrCheckExtra');
                var lstPriceExtra = document.getElementsByClassName('rptrPriceExtra');
                var lstQuantityExtra = document.getElementsByClassName('rptrQuantityExtra');

                $.each(lstQuantityExtra, function (i, item) {

                    if (lstChecksExtra[i].children[0].checked) {
                        totalPersonsExtra += Number(lstQuantityExtra[i].value);
                        totalExtra += Number(lstQuantityExtra[i].value) * Number(lstPriceExtra[i].textContent);
                        chkdExtra += 1;
                    }
                });

                total += totalExtra;
                $('#hdnNumOfChksExtra').val(chkdExtra);
            };

            $('#staticTotalPersons').val(totalPersons);
            $('#staticTotal').val(total);
            $('#hdnTotalPersons').val(totalPersons);
            $('#hdnTotal').val(total);
            $('#hdnNumOfChks').val(chkd);

            CalculateBalance();
        };

        function CalculateBalance() {

            var total = Number($('#staticTotal').val());

            var deposit = Number($('#inputDeposit').val());

            var balance = total - deposit;

            $('#staticRemainingBalance').val(balance);
            $('#hdnRemainingBalance').val(balance);
        };

    </script>
</head>
<body>
    <form id="form1" class="row" runat="server">
        <asp:HiddenField ID="hdnVenue" runat="server" />
        <asp:HiddenField ID="hdnTableNumber" runat="server" value="0"/>
        <asp:HiddenField ID="hdnRamadan" runat="server" value="0" />
        <asp:HiddenField ID="hdnType" runat="server" value="Type" />
        <asp:HiddenField ID="hdnTotal" runat="server" />
        <asp:HiddenField ID="hdnTotalPersons" runat="server" />
        <asp:HiddenField ID="hdnRemainingBalance" runat="server" />
        <asp:HiddenField ID="hdnNumOfChks" runat="server" />
        <asp:HiddenField ID="hdnNumOfChksExtra" runat="server" />
        <asp:HiddenField ID="hdnTableID" runat="server" />
        <br />
        <div class="row">
            <div class="offset-sm-5 col-sm-3" style="font-display: block; font-family: 'AR JULIAN'; font-size: 40px;" >Reservation Form</div>
        </div>
        <p style="page-break-after: always;">&nbsp;</p>
        <div class="col-sm-4" style="margin-left: 50px;">
            <div class="form-group row">
              <asp:Label runat="server" for="inputID" class="col-sm-1 col-form-label">ID</asp:Label>
              <div class="col-sm-3">
                <asp:TextBox runat="server" type="number" class="form-control" id="inputID" placeholder="0" AutoPostBack="true" OnTextChanged="ReviewClient" />
              </div>
              <asp:Label runat="server" for="inputPhoneChk" class="col-sm-2 col-form-label">Phone</asp:Label>
              <div class="col-sm-5">
                <asp:TextBox runat="server" type="number" class="form-control" id="inputPhoneChk" placeholder="0" AutoPostBack="true" OnTextChanged="ReviewClient" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="inputName" class="col-sm-4 col-form-label">Full Name *</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" id="inputName" placeholder="Adam McCartney" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="inputPhoneNumber" class="col-sm-4 col-form-label">Phone Number *</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" type="number" class="form-control" id="inputPhoneNumber" placeholder="01234567899" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="inputEmail" class="col-sm-4 col-form-label">Email</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" id="inputEmail" placeholder="email@example.com" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticHistory" class="col-sm-4 col-form-label">History</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" ReadOnly="true" id="staticHistory" value="0" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticVenue" class="col-sm-4 col-form-label">Venue</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" ReadOnly="true" id="staticVenue" value="Venue" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticTableNumber" class="col-sm-4 col-form-label">Table Number</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" type="number" class="form-control" ReadOnly="true" id="staticTableNumber" value="901" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticRamadan" class="col-sm-4 col-form-label">Ramadan Day</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" type="number" class="form-control" ReadOnly="true" id="staticRamadan" value="0" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticType" class="col-sm-4 col-form-label">Type</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" ReadOnly="true" id="staticType" value="Type" />
              </div>
            </div>
            <br />
        </div>
        <%--IN PROCESS--%>
        <div class="col-sm-5">
            <div class="form-group row">
                <div class="col-sm-11">
                    <%--<asp:CheckBoxList runat="server" id="chkMeals" style="font-size: 18px;" />--%>
                    <div id="Iftar" style="display: none;">
                    <asp:Repeater ID="rptrIftar" runat="server">
                        <HeaderTemplate>
                            <table class="table table-striped">
                                <thead class="text-center">
                                    <td style="font-weight: bold; font-style: italic">
                                        #
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblMeals" class="col-form-label" Text="Meals" />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblPrice" class="col-form-label" Text="Price" />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblNo" class="col-form-label" Text="No." />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblComments" class="col-form-label" Text="Comments" />
                                    </td>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Label ID="rptrNumIftar" style="font-size:18px;" runat="server" Text='<%#Eval("MealID")%>'/>
                                    <asp:HiddenField ID="rptrhdnNumIftar" runat="server" value='<%#Eval("MealID")%>'/>
                                </td>
                                <td>
                                    <asp:CheckBox ID="rptrCheckIftar" class="rptrCheckIftar" type="checkbox" style="font-size:16px;" runat="server" Text='<%#Eval("Meal")%>'/>
                                </td>
                                <td>
                                    <asp:Label ID="rptrPriceIftar" class="rptrPriceIftar" style="font-size:14px;" runat="server" Text='<%#Eval("Price")%>'/>
                                </td>
                                <td>
                                    <input id="rptrQuantityIftar" readonly="true" class="form-control rptrQuantityIftar" type="text" placeholder="0" style="width: 80px; font-size:15px; max-height: 22px;" runat="server" onchange="javascript: CalculateTotal();" />
                                </td>
                                <td>
                                    <input id="rptrCommentIftar" type="text" readonly="true" class="form-control rptrCommentIftar" style="font-size:15px; max-height: 22px;" runat="server" value="."/>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody></table>
                        </FooterTemplate>
                    </asp:Repeater>
                    </div>

                    <div id="Suhoor" style="display: none;">
                    <asp:Repeater ID="rptrSuhoor" runat="server">
                        <HeaderTemplate>
                            <table class="table table-striped">
                                <thead class="text-center">
                                    <td style="font-weight: bold; font-style: italic">
                                        #
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblMeals" class="col-form-label" Text="Meals" />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblPrice" class="col-form-label" Text="Price" />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblNo" class="col-form-label" Text="No." />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblComments" class="col-form-label" Text="Comments" />
                                    </td>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Label ID="rptrNumSuhoor" style="font-size:18px;" runat="server" Text='<%#Eval("MealID")%>'/>
                                    <asp:HiddenField ID="rptrhdnNumSuhoor" runat="server" value='<%#Eval("MealID")%>'/>
                                </td>
                                <td>
                                    <asp:CheckBox ID="rptrCheckSuhoor" class="rptrCheckSuhoor" type="checkbox" style="font-size:16px;" runat="server" Text='<%#Eval("Meal")%>'/>
                                </td>
                                <td>
                                    <asp:Label ID="rptrPriceSuhoor" class="rptrPriceSuhoor" style="font-size:14px;" runat="server" Text='<%#Eval("Price")%>'/>
                                </td>
                                <td>
                                    <input id="rptrQuantitySuhoor" type="text" readonly="true" class="form-control rptrQuantitySuhoor" placeholder="0" style="width: 80px; font-size:15px; max-height: 22px;" runat="server" onchange="javascript: CalculateTotal();"/>
                                </td>
                                <td>
                                    <input id="rptrCommentSuhoor" type="text" readonly="true" class="form-control rptrCommentSuhoor" style="font-size:15px; max-height: 22px;" runat="server" value="."/>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody></table>
                        </FooterTemplate>
                    </asp:Repeater>
                    </div>
                    <br />
                    <div id="Extra" style="display: none;">
                    <asp:Repeater ID="rptrExtra" runat="server">
                        <HeaderTemplate>
                            <table class="table table-striped">
                                <thead class="text-center">
                                    <td style="font-weight: bold; font-style: italic">
                                        #
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblMeals" class="col-form-label" Text="Extras" />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblPrice" class="col-form-label" Text="Price" />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblNo" class="col-form-label" Text="No." />
                                    </td>
                                    <td style="font-weight: bold; font-style: italic">
                                        <asp:Label runat="server" id="lblComments" class="col-form-label" Text="Comments" />
                                    </td>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Label ID="rptrNumExtra" style="font-size:18px;" runat="server" Text='<%#Eval("MealID")%>'/>
                                    <asp:HiddenField ID="rptrhdnNumExtra" runat="server" value='<%#Eval("MealID")%>'/>
                                </td>
                                <td>
                                    <asp:CheckBox ID="rptrCheckExtra" class="rptrCheckExtra" type="checkbox" style="font-size:16px;" runat="server" Text='<%#Eval("Meal")%>'/>
                                </td>
                                <td>
                                    <asp:Label ID="rptrPriceExtra" class="rptrPriceExtra" style="font-size:14px;" runat="server" Text='<%#Eval("Price")%>'/>
                                </td>
                                <td>
                                    <input id="rptrQuantityExtra" type="text" readonly="true" class="form-control rptrQuantityExtra" placeholder="0" style="width: 80px; font-size:15px; max-height: 22px;" runat="server" onchange="javascript: CalculateTotal();"/>
                                </td>
                                <td>
                                    <input id="rptrCommentExtra" type="text" readonly="true" class="form-control rptrCommentExtra" style="font-size:15px; max-height: 22px;" runat="server" value="."/>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody></table>
                        </FooterTemplate>
                    </asp:Repeater>
                    </div>
                </div>
            </div>
            <br />
            <%--start new row--%>
        </div>
        <div class="col-sm-2">
            <div class="form-group row">
              <asp:Label runat="server" for="staticTotalPersons" class="col-sm-3 col-form-label">Persons</asp:Label>
              <div class="col-sm-8">
                <asp:TextBox runat="server" style="margin-left: 20px;" type="number" step="any" placeholder="0" ReadOnly="true" class="form-control" id="staticTotalPersons" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticTotal" class="col-sm-3 col-form-label">Total</asp:Label>
              <div class="col-sm-8">
                <asp:TextBox runat="server" style="margin-left: 20px;" type="number" step="any" placeholder="0" ReadOnly="true" class="form-control" id="staticTotal" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="inputDeposit" class="col-sm-3 col-form-label">Deposit</asp:Label>
              <div class="col-sm-8">
                <asp:TextBox runat="server" style="margin-left: 20px;" type="number" step="any" placeholder="0" class="form-control" id="inputDeposit" OnChange="javascript: CalculateBalance();" />
              </div>
            </div>
            <br />
            <div class="form-group row">
              <asp:Label runat="server" for="staticRemainingBalance" class="col-sm-3 col-form-label">Balance</asp:Label>
              <div class="col-sm-8">
                <asp:TextBox runat="server" style="margin-left: 20px;" type="number" step="any" placeholder="0" ReadOnly="true" class="form-control" id="staticRemainingBalance" />
              </div>
            </div>
            <br />
        </div>
        <p style="page-break-after: always;">&nbsp;</p>
        <div class="form-group row">
            <asp:Button runat="server" ID="btnSubmit" class="offset-sm-1 col-sm-1 btn btn-dark" Text="Submit" OnClick="SubmitTable"/>
            <asp:Button runat="server" ID="btnEdit" class="offset-sm-2 col-sm-1 btn btn-dark" Text="Edit" OnClick="ViewToEdit"/>
            <asp:Button runat="server" ID="btnUpdate" class="offset-sm-2 col-sm-1 btn btn-dark" Text="Update" OnClick="UpdateTable"/>
            <asp:Button runat="server" ID="btnDelete" class="offset-sm-2 col-sm-1 btn btn-dark" Text="Delete" OnClick="DeleteTable"/>
        </div>
        <p style="page-break-after: always;">&nbsp;</p>
    </form>
</body>
</html>

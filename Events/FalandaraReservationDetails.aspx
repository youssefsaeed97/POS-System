<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FalandaraReservationDetails.aspx.cs" Inherits="Events_FalandaraReservationDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%--start-bootstrap/jquery/popper--%>
    <link href="../Scripts/bootstrapv5.0/bootstrap.min.css" rel="stylesheet"/>
    <script type="text/javascript" src="../Scripts/jQuery-3.3.1/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../scripts/bootstrapv5.0/bootstrap.bundle.min.js" ></script>
    <%--end-bootstrap/jquery/popper--%>
    <title>Fleet Club - Falandara Reservation Details</title>
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

        .rptrCheckMeals {}

        .rptrQuantityMeals {}

        .rptrCommentMeals {}

    </style>
    <script type="text/javascript">

        // next 4 lines still in process

        var edit = getParamValue('edit');
        var datetime = getParamValue('datetime').trim().replaceAll('%20', ' ');
        var deck = getParamValue('deck');
        var tableID = getParamValue('tableID');
        var tripID = getParamValue('tripID');

        $(document).ready(function () {

            try {

                $('#Meals').css('display', 'block');
                $('#staticDeck').val(deck);
                $('#hdnDateTime').val(datetime);
                $('#hdnDeck').val(deck);
                $('#hdnTableID').val(tableID);
                $('#hdnTripID').val(tripID);

            } catch {

                //not working / not an issue for now
                alert("Loaded individually.");
            }

            $(".rptrCheckMeals").change(function () {

                var ind = $(this).parent().parent().parent().children();
                var i = ind.index($(this).parent().parent());

                if (!this.children[0].checked) {
                    
                    CalculateTotal();
                    CalculateBalance();

                    $(".rptrQuantityMeals:eq(" + i + ")").val(Number("0"));
                    $(".rptrComment" + type + ":eq(" + i + ")").val(".");
                }

                $(".rptrQuantityMeals:eq(" + i + ")").prop('readonly', !this.children[0].checked);
                $(".rptrCommentMeals:eq(" + i + ")").prop('readonly', !this.children[0].checked);

                
            });
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

            var lstChecks = document.getElementsByClassName('rptrCheckMeals');
            var lstPrice = document.getElementsByClassName('rptrPriceMeals');
            var lstQuantity = document.getElementsByClassName('rptrQuantityMeals');

            $.each(lstQuantity, function (i, item) {

                if (lstChecks[i].children[0].checked) {
                    totalPersons += Number(lstQuantity[i].value);
                    total += Number(lstQuantity[i].value) * Number(lstPrice[i].textContent);
                    chkd += 1;
                }
            });

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

            var discount_prcnt = Number($('#inputDiscount').val());

            var balance = total - deposit - ((discount_prcnt / 100) * total);

            $('#hdnDiscount').val(discount_prcnt);
            $('#staticRemainingBalance').val(balance);
            $('#hdnRemainingBalance').val(balance);
        };

    </script>
</head>
<body>
    <form id="form1" class="row" runat="server">
        <asp:HiddenField ID="hdnTripID" runat="server" value="0" />
        <asp:HiddenField ID="hdnEdit" runat="server" value="0" />
        <asp:HiddenField ID="hdnDateTime" runat="server" value="0" />
        <asp:HiddenField ID="hdnDeck" runat="server" value="Deck" />
        <asp:HiddenField ID="hdnTotal" runat="server" />
        <asp:HiddenField ID="hdnTotalPersons" runat="server" />
        <asp:HiddenField ID="hdnRemainingBalance" runat="server" />
        <asp:HiddenField ID="hdnDiscount" runat="server" Value="0" />
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
              <asp:Label runat="server" for="inputRank" class="col-sm-4 col-form-label">Rank</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" id="inputRank" placeholder="Colonel" />
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
              <asp:Label runat="server" for="staticDeck" class="col-sm-4 col-form-label">Deck</asp:Label>
              <div class="col-sm-7">
                <asp:TextBox runat="server" class="form-control" ReadOnly="true" id="staticDeck" value="Deck" />
              </div>
            </div>
            <br />
        </div>
        <div class="col-sm-5">
            <div class="form-group row">
                <div class="col-sm-12">
                    <div id="Meals" style="display: none;">
                    <asp:Repeater ID="rptrMeals" runat="server">
                        <HeaderTemplate>
                            <table class="table table-striped">
                                <thead class="text-center">
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
                                <asp:HiddenField ID="rptrhdnNumMeals" runat="server" value='<%#Eval("MealID")%>'/>
                                <td>
                                    <asp:CheckBox ID="rptrCheckMeals" class="rptrCheckMeals" type="checkbox" style="font-size:16px;" runat="server" Text='<%#Eval("Meal")%>'/>
                                </td>
                                <td>
                                    <asp:Label ID="rptrPriceMeals" class="rptrPriceMeals" style="font-size:14px;" runat="server" Text='<%#Eval("Price")%>'/>
                                </td>
                                <td>
                                    <input id="rptrQuantityMeals" readonly="true" class="form-control rptrQuantityMeals" type="text" placeholder="0" style="width: 80px; font-size:15px; max-height: 22px;" runat="server" onchange="javascript: CalculateTotal();" />
                                </td>
                                <td>
                                    <input id="rptrCommentMeals" type="text" readonly="true" class="form-control rptrCommentMeals" style="font-size:15px; max-height: 22px;" runat="server" value="."/>
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
              <asp:Label runat="server" for="inputDiscount" class="col-sm-3 col-form-label">Discount%</asp:Label>
              <div class="col-sm-8">
                <asp:TextBox runat="server" style="margin-left: 20px;" type="number" step="any" placeholder="0" class="form-control" id="inputDiscount" OnChange="javascript: CalculateBalance();" />
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
        <div class="form-group row">
            <asp:Button runat="server" ID="btnSubmit" class="offset-sm-2 col-sm-2 btn btn-dark" Text="Submit" OnClick="SubmitTable"/>
            <asp:Button runat="server" ID="btnUpdate" class="offset-sm-1 col-sm-2 btn btn-dark" Text="Update" OnClick="UpdateTable"/>
            <asp:Button runat="server" ID="btnDelete" class="offset-sm-1 col-sm-2 btn btn-dark" Text="Delete" CommandArgument="" OnClientClick="return confirm('Are you sure you want to delete this table?');" OnClick="DeleteTable"/>
        </div>
        <p style="page-break-after: always;">&nbsp;</p>
    </form>
</body>
</html>

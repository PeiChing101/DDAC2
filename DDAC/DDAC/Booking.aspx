<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="DDAC.Booking" %>
<%@ Register Src="~/User_Control/GridViewPaging.ascx" TagName="GridViewPager" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
        .section_title {
            background-color: #D5D5FF;
        }

        input.underlined {
            border: 0;
            border-bottom: solid 1px #000;
            outline: none;
        }

        .messagealert {
            width: 100%;
            position: fixed;
            top: 0px;
            z-index: 100000;
            padding: 0;
            font-size: 15px;
        }

        .ui-dialog-titlebar-close {
            visibility: hidden;
        }

        .button_green {
            border: 1px solid #cacaca;
            -webkit-border-radius: 3px;
            -moz-border-radius: 3px;
            border-radius: 3px;
            font-size: 12pt;
            font-family: arial, helvetica, sans-serif;
            padding: 10px 10px 10px 10px;
            text-decoration: none;
            display: inline-block;
            text-shadow: -1px -1px 0 rgba(0,0,0,0.3);
            font-weight: bold;
            color: #FFFFFF;
            background-color: #72ed8e;
            background-image: -webkit-gradient(linear, left top, left bottom, from(#72ed8e), to(#6db273));
            background-image: -webkit-linear-gradient(top, #72ed8e, #6db273);
            background-image: -moz-linear-gradient(top, #72ed8e, #6db273);
            background-image: -ms-linear-gradient(top, #72ed8e, #6db273);
            background-image: -o-linear-gradient(top, #72ed8e, #6db273);
            background-image: linear-gradient(to bottom, #72ed8e, #6db273);
            filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#72ed8e, endColorstr=#6db273);
        }

            .button_green:hover {
                border: 1px solid #cacaca;
                background-color: #44d649;
                background-image: -webkit-gradient(linear, left top, left bottom, from(#44d649), to(#1f9334));
                background-image: -webkit-linear-gradient(top, #44d649, #1f9334);
                background-image: -moz-linear-gradient(top, #44d649, #1f9334);
                background-image: -ms-linear-gradient(top, #44d649, #1f9334);
                background-image: -o-linear-gradient(top, #44d649, #1f9334);
                background-image: linear-gradient(to bottom, #44d649, #1f9334);
                filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#44d649, endColorstr=#1f9334);
            }

        .button_grey {
            border: 1px solid #cacaca;
            -webkit-border-radius: 3px;
            -moz-border-radius: 3px;
            border-radius: 3px;
            font-size: 12pt;
            font-family: arial, helvetica, sans-serif;
            padding: 10px 10px 10px 10px;
            text-decoration: none;
            display: inline-block;
            text-shadow: -1px -1px 0 rgba(0,0,0,0.3);
            font-weight: bold;
            color: #FFFFFF;
            background-color: #ccd3cb;
            background-image: -webkit-gradient(linear, left top, left bottom, from(#ccd3cb), to(#cdcdcd));
            background-image: -webkit-linear-gradient(top, #ccd3cb, #cdcdcd);
            background-image: -moz-linear-gradient(top, #ccd3cb, #cdcdcd);
            background-image: -ms-linear-gradient(top, #ccd3cb, #cdcdcd);
            background-image: -o-linear-gradient(top, #ccd3cb, #cdcdcd);
            background-image: linear-gradient(to bottom, #ccd3cb, #cdcdcd);
            filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#ccd3cb, endColorstr=#cdcdcd);
        }

            .button_grey:hover {
                border: 1px solid #b3b3b3;
                background-color: #cdcdcd;
                background-image: -webkit-gradient(linear, left top, left bottom, from(#cdcdcd), to(#b3b3b3));
                background-image: -webkit-linear-gradient(top, #cdcdcd, #b3b3b3);
                background-image: -moz-linear-gradient(top, #cdcdcd, #b3b3b3);
                background-image: -ms-linear-gradient(top, #cdcdcd, #b3b3b3);
                background-image: -o-linear-gradient(top, #cdcdcd, #b3b3b3);
                background-image: linear-gradient(to bottom, #cdcdcd, #b3b3b3);
                filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#cdcdcd, endColorstr=#b3b3b3);
            }
    </style>
    <script type="text/javascript">
        function ShowMessage(message, messagetype) {
            var cssclass;
            switch (messagetype) {
                case 'Success':
                    cssclass = 'alert-success'
                    break;
                case 'Error':
                    cssclass = 'alert-danger'
                    break;
                case 'Warning':
                    cssclass = 'alert-warning'
                    break;
                default:
                    cssclass = 'alert-info'
            }
            $('#alert_container').append('<div id="alert_div" style="margin: 0 0.5%; -webkit-box-shadow: 3px 4px 6px #999;" class="alert ' + cssclass + ' fade in"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><strong>' + messagetype + '!</strong> <span>' + message + '</span></div>');
            $("#alert_container").fadeTo(3000, 500).slideUp(500, function () {
                $("#alert_container").hide();
            });
		} 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="messagealert" id="alert_container">
    </div>
	<asp:HiddenField runat="server" ID="hfContinue" />
	<div id="mainContainer" class="container">
		<div class="shadowBox">
			<div class="page-container">
				<div class="container">
					<div class="row-fluid">
						<div class="col-md-8 h2">
							<p>Flight Schedule</p>
						</div>						
					</div>
					<div class="row">
						<div class="col-lg-12">
							<asp:Table ID="tblFilter" runat="server" Width="100%" Style="margin: 20px 20px 20px 20px;">
								<asp:TableRow Height="35px">
									<asp:TableCell Width="20%">
                        <label class="control-label">Origin</label>
									</asp:TableCell>
									<asp:TableCell Width="1%">
                        :
									</asp:TableCell>
									<asp:TableCell>
										<div class="input-group col-lg-10">
											<asp:DropDownList ID="dOrigin" runat="server" CssClass="form-control">
												<asp:ListItem Text="--Please Select--" Value="" Selected="True"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Sultan Azlan Shah Airport" Value="Malaysia-Sultan Azlan Shah Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Senai International Airport" Value="Malaysia-Senai International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Sultan Ismail Petra Airport" Value="Malaysia-Sultan Ismail Petra Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Kota Kinabalu International Airport" Value="Malaysia-Kota Kinabalu International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Kuala Lumpur International Airport" Value="Malaysia-Kuala Lumpur International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Kuching International Airport" Value="Malaysia-Kuching International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Langkawi International Airport" Value="Malaysia-Langkawi International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Penang International Airport" Value="Malaysia-Penang International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Sultan Abdul Aziz Shah Airport" Value="Malaysia-Sultan Abdul Aziz Shah Airport"></asp:ListItem>
												<asp:ListItem Text="Singapore-Singapore Changi Airport" Value="Singapore-Singapore Changi Airport"></asp:ListItem>
												<asp:ListItem Text="Thailand-Suvarnabhumi Airport" Value="Thailand-Suvarnabhumi Airport"></asp:ListItem>
												<asp:ListItem Text="Vietnam-Da Nang International Airport" Value="Vietnam-Da Nang International Airport"></asp:ListItem>
												<asp:ListItem Text="Vietnam-Noi Bai International Airport" Value="Vietnam-Noi Bai International Airport"></asp:ListItem>
												<asp:ListItem Text="Vietnam-Tan Son Nhat International Airport" Value="Vietnam-Tan Son Nhat International Airport"></asp:ListItem>
												<asp:ListItem Text="England-Southend Airport" Value="England-Southend Airport"></asp:ListItem>
												<asp:ListItem Text="England-Norwich International Airport" Value="England-Norwich International Airport"></asp:ListItem>
												<asp:ListItem Text="England-Southampton Airport" Value="England-Southampton Airport"></asp:ListItem>
											</asp:DropDownList>
										</div>
									</asp:TableCell>
								</asp:TableRow>
								<asp:TableRow Height="35px">
									<asp:TableCell Width="20%">
                        <label class="control-label">Destination</label>
									</asp:TableCell>
									<asp:TableCell Width="1%">
                        :
									</asp:TableCell>
									<asp:TableCell>
										<div class="input-group col-lg-10">
											<asp:DropDownList ID="dDestination" runat="server" CssClass="form-control">
												<asp:ListItem Text="--Please Select--" Value="" Selected="True"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Sultan Azlan Shah Airport" Value="Malaysia-Sultan Azlan Shah Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Senai International Airport" Value="Malaysia-Senai International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Sultan Ismail Petra Airport" Value="Malaysia-Sultan Ismail Petra Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Kota Kinabalu International Airport" Value="Malaysia-Kota Kinabalu International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Kuala Lumpur International Airport" Value="Malaysia-Kuala Lumpur International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Kuching International Airport" Value="Malaysia-Kuching International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Langkawi International Airport" Value="Malaysia-Langkawi International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Penang International Airport" Value="Malaysia-Penang International Airport"></asp:ListItem>
												<asp:ListItem Text="Malaysia-Sultan Abdul Aziz Shah Airport" Value="Malaysia-Sultan Abdul Aziz Shah Airport"></asp:ListItem>
												<asp:ListItem Text="Singapore-Singapore Changi Airport" Value="Singapore-Singapore Changi Airport"></asp:ListItem>
												<asp:ListItem Text="Thailand-Suvarnabhumi Airport" Value="Thailand-Suvarnabhumi Airport"></asp:ListItem>
												<asp:ListItem Text="Vietnam-Da Nang International Airport" Value="Vietnam-Da Nang International Airport"></asp:ListItem>
												<asp:ListItem Text="Vietnam-Noi Bai International Airport" Value="Vietnam-Noi Bai International Airport"></asp:ListItem>
												<asp:ListItem Text="Vietnam-Tan Son Nhat International Airport" Value="Vietnam-Tan Son Nhat International Airport"></asp:ListItem>
												<asp:ListItem Text="England-Southend Airport" Value="England-Southend Airport"></asp:ListItem>
												<asp:ListItem Text="England-Norwich International Airport" Value="England-Norwich International Airport"></asp:ListItem>
												<asp:ListItem Text="England-Southampton Airport" Value="England-Southampton Airport"></asp:ListItem>
											</asp:DropDownList>
										</div>
									</asp:TableCell>
								</asp:TableRow>
								<asp:TableRow Height="60px">
									<%--<asp:TableCell Width="20%"></asp:TableCell>
                                    <asp:TableCell Width="1%"></asp:TableCell>--%>
									<asp:TableCell ColumnSpan="6">
										<asp:Button ID="btnSearch" runat="server" CssClass="btn btn-info" Width="90" Text="Search" OnClick="btnSearch_Click" />
									</asp:TableCell>
								</asp:TableRow>
							</asp:Table>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 ">
							<div class="table-responsive">
								<asp:GridView ID="gvBooking" runat="server" Width="100%" CssClass="table table-striped table-bordered table-hover" AutoGenerateColumns="False" DataKeyNames="pkId" EmptyDataText="There are no data records to display." OnRowCommand="gvBooking_RowCommand">
									<Columns>
										<asp:TemplateField HeaderText="">
											<ItemTemplate>
												<asp:LinkButton ID="btnSelect" runat="server" CommandName="SelectFlight" CommandArgument='<%#Eval("pkId")%>'>Select</asp:LinkButton>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:BoundField DataField="flightNo" HeaderText="Flight Number" ReadOnly="True" SortExpression="flightNo" />
										<asp:BoundField DataField="origin" HeaderText="Origin" ReadOnly="True" SortExpression="origin" />
										<asp:BoundField DataField="departDate" HeaderText="Depart Date" SortExpression="departDate" DataFormatString="{0:dd-MM-yyyy}" />
										<asp:BoundField DataField="destination" HeaderText="Destination" SortExpression="destination" HeaderStyle-CssClass="visible-lg" ItemStyle-CssClass="visible-lg" />
										<asp:BoundField DataField="arriveDate" HeaderText="Arrival Date" SortExpression="arriveDate" ItemStyle-CssClass="visible-lg" HeaderStyle-CssClass="visible-lg" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:dd-MM-yyyy}" />
										<asp:BoundField DataField="regPassenger" HeaderText="Registered Passenger" SortExpression="regPassenger" ItemStyle-CssClass="visible-lg" HeaderStyle-CssClass="visible-lg" ItemStyle-HorizontalAlign="Right" />
										<asp:BoundField DataField="totalPassenger" HeaderText="Total Passenger" SortExpression="totalPassenger" ItemStyle-CssClass="visible-lg" HeaderStyle-CssClass="visible-lg" ItemStyle-HorizontalAlign="Right" />
									</Columns>
									<HeaderStyle CssClass="headerClass" />
									<PagerTemplate>
									</PagerTemplate>
									<EmptyDataTemplate>
										No Booking is found.
									</EmptyDataTemplate>
								</asp:GridView>
								<uc:gridviewpager id="UCGridViewPaging" runat="server" />
								<div style="height: 70px;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap Modal Dialog -->
	<div class="modal fade" id="myModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<%--<asp:UpdatePanel ID="upModal" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
                <ContentTemplate>--%>
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<asp:Label ID="lblModalTitle" runat="server" Text="Booking"></asp:Label></h4>
				</div>
				<div class="modal-body form-horizontal">
					<asp:HiddenField ID="hfpkId" runat="server" />
					<asp:HiddenField ID="reg" runat="server" />
					<div class="form-group">
						<label class="control-label col-sm-3">Flight Number:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tflightNo" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group" runat="server">
						<label class="control-label col-sm-3">Origin:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="torigin" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Departure Date:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tdepartDate" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Departure Time:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tdepartTime" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group" runat="server">
						<label class="control-label col-sm-3">Destination:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tdestination" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>							
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Arrival Date:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tarriveDate" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Arrival Time:</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tarriveTime" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Ticket Price per person (RM):</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tprice" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Booking for (person):</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tbookingSeat" runat="server" CssClass="form-control" onChange="updatePrice(this)"></asp:TextBox>
							 <asp:Button runat="server" ID="btnCalc" CssClass="btn btn-info" Text="Calculate" OnClick="btnCalc_Click"></asp:Button>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-3">Total Price (RM):</label>
						<div class="col-sm-7">
							<asp:TextBox ID="tpayment" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<asp:Button runat="server" ID="btnCancelFlight" CssClass="btn btn-info" data-dismiss="modal" aria-hidden="true" Text="Cancel"></asp:Button>&nbsp;
                            <asp:Button runat="server" ID="btnSaveBooking" CssClass="btn btn-info" Text="Proceed to Payment" OnClick="btnSaveBooking_Click"></asp:Button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

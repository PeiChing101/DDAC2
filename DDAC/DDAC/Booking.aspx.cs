using DDAC.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DDAC
{
	public partial class Booking : System.Web.UI.Page
	{
		public string sortDirection = "ASC";
		public string sortField = "flightNo";
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				//PopulateData();
				btnSearch_Click(sender, e);
			}

			// Register new click event for grid view to handle User control events
			UCGridViewPaging.pagingClickArgs += new EventHandler(Paging_Click);
		}

		/// <summary>
		/// Handles the Click event of the Paging control.
		/// </summary>
		/// <param name="sender">The source of the event.</param>
		/// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
		private void Paging_Click(object sender, EventArgs e)
		{
			gvBooking.PageSize = Convert.ToInt32(((DropDownList)UCGridViewPaging.FindControl("PageRowSize")).SelectedValue);
			gvBooking.PageIndex = Convert.ToInt32(((TextBox)UCGridViewPaging.FindControl("SelectedPageNo")).Text) - 1;
			//Reload the Grid
			//PopulateData();
			btnSearch_Click(sender, e);
		}

		protected void btnSearch_Click(object sender, EventArgs e)
		{
			string Origin = null, Destination = null;

			if (dOrigin.Text.Trim().Length > 0)
				Origin = dOrigin.SelectedValue;
			if (dDestination.Text.Trim().Length > 0)
				Destination = dDestination.SelectedValue;

			PopulateData(Origin, Destination);
		}

		private void PopulateData(string Origin = null, string Destination = null)
		{
			DataTable dt = GetData(Origin, Destination);
			Session["TotalRows"] = dt.Rows.Count;
			dt.DefaultView.Sort = sortField + " " + sortDirection;
			Session["SortDirection"] = sortDirection;

			gvBooking.DataSource = dt;
			gvBooking.DataBind();

			if (IsPostBack)
			{
				UCGridViewPaging.GetPageDisplaySummary();
			}
		}

		private DataTable GetData(string Origin, string Destination)
		{
			if (dOrigin.Text.Trim().Length > 0)
			{
				Origin = dOrigin.SelectedValue;
			}
			if (dDestination.Text.Trim().Length > 0)
			{
				Destination = dDestination.SelectedValue;
			}

			string query = "SELECT * FROM [dbo].[flight] WHERE origin LIKE '%" + Origin + "%' AND destination LIKE '%" + Destination + "%' AND regPassenger<totalPassenger AND departDate>= '" + DateTime.Now + "'";

			string constr = ConfigurationManager.ConnectionStrings["Booking_System"].ConnectionString;
			using (SqlConnection con = new SqlConnection(constr))
			{
				DataTable dt = new DataTable();
				using (SqlCommand cmd2 = new SqlCommand(query))
				{
					using (SqlDataAdapter sda = new SqlDataAdapter())
					{
						cmd2.CommandType = CommandType.Text;
						cmd2.Connection = con;
						sda.SelectCommand = cmd2;
						sda.Fill(dt);
					}
				}
				return dt;
			}
		}

		protected void gvBooking_RowCommand(object sender, GridViewCommandEventArgs e)
		{
			if (e.CommandName == "SelectFlight")
			{
				tflightNo.ReadOnly = true;

				DataTable dt = GetData2(Convert.ToInt64(e.CommandArgument));
				if (dt.Rows.Count >= 1)
				{
					tflightNo.Text = dt.Rows[0]["flightNo"].ToString();					
					torigin.Text = dt.Rows[0]["origin"].ToString();
					tdepartDate.Text = dt.Rows[0]["departDate"].ToString();
					tdepartTime.Text = dt.Rows[0]["departTime"].ToString();
					tdestination.Text = dt.Rows[0]["destination"].ToString();
					tarriveDate.Text = dt.Rows[0]["arriveDate"].ToString();
					tarriveTime.Text = dt.Rows[0]["arriveTime"].ToString();
					tprice.Text = dt.Rows[0]["nominalPrice"].ToString();
					hfpkId.Value = dt.Rows[0]["pkId"].ToString();
					reg.Value = dt.Rows[0]["regPassenger"].ToString();

					tbookingSeat.Focus();
				}

				ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myModal", "$('#myModal').modal();", true);
			}
		}

		private DataTable GetData2(long pkId)
		{
			string query = "SELECT * FROM [dbo].[flight] WHERE pkId = " + pkId;
			string constr = ConfigurationManager.ConnectionStrings["Booking_System"].ConnectionString;
			using (SqlConnection con = new SqlConnection(constr))
			{
				DataTable dt = new DataTable();
				using (SqlCommand cmd = new SqlCommand(query))
				{
					using (SqlDataAdapter sda = new SqlDataAdapter())
					{
						cmd.CommandType = CommandType.Text;
						cmd.Connection = con;
						sda.SelectCommand = cmd;
						sda.Fill(dt);
					}
				}
				return dt;
			}
		}
		protected void btnCalc_Click(object sender, EventArgs e)
		{
			tpayment.Text = (Convert.ToDecimal(tbookingSeat.Text) * Convert.ToDecimal(tprice.Text)).ToString();
			ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myModal", "$('#myModal').modal();", true);
		}

		protected void btnSaveBooking_Click(object sender, EventArgs e)
		{
			userDetail u = null;
			if (Session["User"] != null)
			{
				u = (userDetail)Session["User"];
			}

			makeOrder _makeOrder = new makeOrder();

			string conStr = ConfigurationManager.ConnectionStrings["Booking_System"].ConnectionString;
			try
			{
				using (SqlConnection connection = new SqlConnection(conStr))
				{
					connection.Open();
					using (SqlCommand command =
						new SqlCommand(("INSERT INTO [dbo].[makeOrder] ([flightNo], [userID], [price], [payment], [origin], [departDate], [departTime], [destination], [arriveDate], [arriveTime], [bookingSeat], [createdBy], [createdDate], [paid])"
						+ "VALUES (@flightNo, @userID, @price, @payment, @origin, @departDate, @departTime, @destination, @arriveDate, @arriveTime, @bookingSeat, @createdBy, @createdDate, @paid);"), connection))
					{
						command.Parameters.AddWithValue("@flightNo", tflightNo.Text);
						command.Parameters.AddWithValue("@origin", torigin.Text);
						command.Parameters.AddWithValue("@departDate", Convert.ToDateTime(tdepartDate.Text));
						command.Parameters.AddWithValue("@departTime", tdepartTime.Text);
						command.Parameters.AddWithValue("@destination", tdestination.Text);
						command.Parameters.AddWithValue("@arriveDate", Convert.ToDateTime(tarriveDate.Text));
						command.Parameters.AddWithValue("@arriveTime", tarriveTime.Text);
						command.Parameters.AddWithValue("@price", Convert.ToDecimal(tprice.Text));
						command.Parameters.AddWithValue("@bookingSeat", Convert.ToInt32(tbookingSeat.Text));
						command.Parameters.AddWithValue("@payment", Convert.ToDecimal(tpayment.Text));
						command.Parameters.AddWithValue("@createdBy", u.firstname + " " + u.lastname);
						command.Parameters.AddWithValue("@createdDate", DateTime.Now);
						command.Parameters.AddWithValue("@paid", 1);
						command.Parameters.AddWithValue("@userID", Convert.ToInt64(u.userID));

						command.ExecuteNonQuery();

						connection.Close();

						//Send email
						try
						{
							MailMessage mail = new MailMessage();
							mail.To.Add(u.email);
							mail.From = new MailAddress("peiching101@gmail.com");
							mail.Subject = "Ukraine International Airlines: Booking";
							mail.Body = string.Format("Hi {0},<br /><br />Your flight booking to {1} at {2} has been created.<br /><br />Payment has been received.<br /><br />Thank You.<br /><br />Sincerely,<br/>Administrator Ukraine International Airlines", u.firstname + u.lastname, tdestination.Text, Convert.ToDateTime(tarriveDate.Text).ToString("dd/MM/yyyy"));

							mail.IsBodyHtml = true;
							SmtpClient smtp = new SmtpClient();
							smtp.Host = "smtp.gmail.com"; //Or Your SMTP Server Address
							smtp.Credentials = new System.Net.NetworkCredential
								 ("peiching101@gmail.com", "0192835408"); // ***use valid credentials***
							smtp.Port = 587;

							//Or your Smtp Email ID and Password
							smtp.EnableSsl = true;
							smtp.Send(mail);

							//ShowMessage("Please check your email for itenary", MessageType.Success);
						}
						catch (Exception ex)
						{
							ShowMessage("Exception in sendEmail:" + ex.Message, MessageType.Error);
						}

						updateFlight();
						btnSearch_Click(sender, e);
						ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myModal", "$('#myModal').modal('hide');", true);
						ShowMessage("Please check your email for itenary.", MessageType.Success);
					}
				}
			}
			catch (SqlException ex)
			{
				Console.WriteLine("Exited: " + ex.ToString());
				ShowMessage("Record saved failed. Please try again.", MessageType.Error);
			}
		}

		private void updateFlight()
		{
			int registered = Convert.ToInt32(reg.Value) + Convert.ToInt32(tbookingSeat.Text);
			string conStr2 = ConfigurationManager.ConnectionStrings["Booking_System"].ConnectionString;
			try
			{
				using (SqlConnection connection2 = new SqlConnection(conStr2))
				{
					connection2.Open();
					using (SqlCommand command2 =
						new SqlCommand(("UPDATE [dbo].[flight] SET [regPassenger] = @regPassenger "
						+ "WHERE [flightNo] = @flightNo"), connection2))
					{
						command2.Parameters.AddWithValue("@flightNo", tflightNo.Text);
						command2.Parameters.AddWithValue("@regPassenger", registered);

						command2.ExecuteNonQuery();

						connection2.Close();
					}
				}
			}
			catch (SqlException ex)
			{
				Console.WriteLine("Exited: " + ex.ToString());
				ShowMessage("Record saved failed. Please try again.", MessageType.Error);
			}
		}

		protected void ShowMessage(string Message, MessageType type)
		{
			ScriptManager.RegisterStartupScript(this, this.GetType(), System.Guid.NewGuid().ToString(), "ShowMessage('" + Message + "','" + type + "');", true);
		}		
	}
}
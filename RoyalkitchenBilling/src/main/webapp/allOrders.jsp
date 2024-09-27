<%@ page import="java.util.List"%>
<%@ page import="com.hibernate.Entity.OrderDetails"%>
<%@ page import="com.hibernate.Entity.OrderMenuDetails"%>
<%@ page import="com.hibernate.DAO.OrderDAO"%>
<%@ page import="com.hibernate.DAOImpl.OrderDAOImpl"%>

<%
// Initialize DAO and fetch orders
OrderDAO orderDAO = new OrderDAOImpl();
List<OrderDetails> orders = orderDAO.getAllOrders();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>All Orders</title>
<!-- Font Awesome CSS for icons -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
	rel="stylesheet">
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Custom Font -->
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap"
	rel="stylesheet">
<style>
body {
	font-family: 'Poppins', sans-serif;
	background-color: #f0f0f0; /* Same background color as menu.jsp */
}

.container {
	max-width: 1200px; /* Set a maximum width for the container */
	background-color: #ffffff; /* White background for content */
	border-radius: 8px; /* Rounded corners for content */
	padding: 20px; /* Add padding around content */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Subtle shadow */
}

.table-container {
	height: 550px; /* Set a default height for the table container */
	overflow-y: auto; /* Enable vertical scrolling */
}

a {
	text-decoration: none; /* Remove underline from links */
}

a.text-danger {
	color: #e66e6f; /* Color for back link */
}

button:focus, a:focus, input:focus, select:focus {
	box-shadow: none !important; /* Remove focus shadow */
}

input, select {
	border: solid 1px lightgray !important;
	/* Light gray border for inputs */
}
</style>
</head>
<body>
	<div
		class="d-flex align-items-center justify-content-center min-vh-100">
		<div class="container my-4">
			<div class="table-container mt-3 px-4">
				<a href="BillingServlet" class="text-danger">>> back</a>
				<table class="table table-striped table-hover table-light mt-4">
					<thead>
						<tr>
							<th>Order ID</th>
							<th>Customer Name</th>
							<th>Customer Email</th>
							<th>Paid Status</th>
							<th>Total Amount</th>
							<th>Bill</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (OrderDetails order : orders) {
							// Ensure collection is initialized if not using EAGER fetching
							double totalAmount = order.getOrderMenuDetails().stream().mapToDouble(OrderMenuDetails::getSubtotal).sum();
						%>
						<tr>
							<td class="py-3"><%=order.getOid()%></td>
							<td class="py-3"><%=order.getCustomerName()%></td>
							<td class="py-3"><%=order.getCustomerEmail()%></td>
							<td class="py-3"><%=order.getPaidStatus()%></td>
							<td class="py-3"><%=totalAmount%></td>
							<td style="vertical-align: middle;">
								<form action="ReceiptServlet" method="post"
									style="display: inline;">
									<input type="hidden" name="orderid" value="<%=order.getOid()%>">
									<button type="submit" class="btn btn-danger btn-sm">
										<i class="fas fa-external-link-alt"></i>
									</button>
								</form>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- Bootstrap JS & dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
</body>
</html>
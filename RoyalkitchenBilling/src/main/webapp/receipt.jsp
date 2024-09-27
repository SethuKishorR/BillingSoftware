<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.Entity.OrderDetails"%>
<%@ page import="com.hibernate.Entity.OrderMenuDetails"%>
<%@ page import="java.util.List"%>

<%
// Retrieve the order details from the request
OrderDetails order = (OrderDetails) request.getAttribute("order");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Receipt</title>
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
h2, h3 {
	color: #cb2c2c; /* Primary color */
}

h2 {
	font-weight: 600;
}

h3 {
	font-weight: 400;
	font-size: 1.3rem;
}

body {
	font-family: 'Poppins', sans-serif;
	background-color: #f0f0f0; /* Light gray background for the page */
}

.container {
	max-width: 1200px; /* Set a maximum width for the container */
}

.table-container {
	height: 250px; /* Set a default height for the table container */
	overflow-y: auto; /* Enable vertical scrolling */
}

.rounded-btn {
	border-radius: 50%; /* Makes the button circular */
	width: 40px; /* Set the width */
	height: 40px; /* Set the height */
	padding: 0; /* Remove padding to ensure the button is circular */
	display: flex;
	align-items: center;
	justify-content: center;
}

button:focus, a:focus, input:focus, select:focus {
	box-shadow: none !important;
}

input, select {
	border: solid 1px lightgray !important;
}
</style>
</head>
<body>
	<div
		class="d-flex align-items-center justify-content-center min-vh-100">
		<div class="container my-4 py-4 bg-white rounded shadow-sm px-5">
			<a href="allOrders.jsp" class="text-danger mt-3"
				style="text-decoration: none;">>> back</a>
			<h2 class="text-center mb-4">
				Receipt for Order #<%=order.getOid()%></h2>
			<h3 class="text-center mb-5">
				Thank you for your purchase,
				<%=order.getCustomerName()%>!
			</h3>

			<table class="table table-striped mt-3">
				<thead>
					<tr>
						<th style="width: 15%;">Order ID</th>
						<th style="width: 20%;">Customer Name</th>
						<th style="width: 25%;">Customer Email</th>
						<th style="width: 25%;">Paid Status</th>
						<th style="width: 15%;">Total Amount</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="vertical-align: middle;"><%=order.getOid()%></td>
						<td style="vertical-align: middle;"><%=order.getCustomerName()%></td>
						<td style="vertical-align: middle;"><%=order.getCustomerEmail()%></td>
						<td>
							<!-- Dropdown for Paid Status -->
							<form action="ReceiptServlet" method="post"
								style="display: inline;">
								<input type="hidden" name="orderid" value="<%=order.getOid()%>">
								<div class="form-group">
									<select id="paidStatusDropdown" name="paidStatus"
										class="form-select w-75" onchange="this.form.submit()">
										<!-- Options for updating status -->
										<option value="Paid"
											<%="Paid".equals(order.getPaidStatus()) ? "selected" : ""%>>Paid</option>
										<option value="Pending"
											<%="Pending".equals(order.getPaidStatus()) ? "selected" : ""%>>Pending</option>
									</select>
								</div>
							</form>
						</td>
						<td style="vertical-align: middle;">
							<%
							double totalAmount = order.getOrderMenuDetails().stream().mapToDouble(OrderMenuDetails::getSubtotal).sum();
							out.print(totalAmount);
							%>
						</td>
					</tr>
				</tbody>
			</table>
			<h3 class="mb-4 d-flex justify-content-between align-items-center"
				style="font-weight: 600;">
				Order Items
				<button type="button" id="sendEmailButton" class="btn btn-success">Paid</button>
			</h3>
			<form id="emailForm" style="display:none;">
			    <input type="hidden" name="customer_name" value="<%=order.getCustomerName()%>">
			    <input type="hidden" name="customer_email" value="<%=order.getCustomerEmail()%>">
			    <input type="hidden" name="order_id" value="<%=order.getOid()%>">
			    <input type="hidden" name="order_items" value="
			    <% 
			    for (OrderMenuDetails menu : order.getOrderMenuDetails()) { 
			        out.print(menu.getMenuName() + " (" + menu.getQuantity() + "), "); 
			    }
			    %>">
			    <input type="hidden" name="total_amount" value="<%=totalAmount%>">
			</form>

			<div class="table-container mt-3">
				<table class="table table-striped">
					<thead>
						<tr>
							<th style="width: 25%;">Menu Name</th>
							<th style="width: 25%;">Price</th>
							<th style="width: 25%;">Quantity</th>
							<th style="width: 25%;">Subtotal</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (OrderMenuDetails menu : order.getOrderMenuDetails()) {
						%>
						<tr>
							<td class="py-3" style="vertical-align: middle;"><%=menu.getMenuName()%></td>
							<td class="py-3" style="vertical-align: middle;"><%=menu.getPrice()%></td>
							<td class="py-3" style="vertical-align: middle;"><%=menu.getQuantity()%></td>
							<td class="py-3" style="vertical-align: middle;"><%=menu.getSubtotal()%></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- Add EmailJS and Script to Handle Button Click -->
	<script src="https://cdn.emailjs.com/dist/email.min.js"></script>
	<script>
	    (function(){
	        emailjs.init("WqV19NTItU4LAeMOT"); // Your Public Key
	    })();
	
	    document.getElementById('sendEmailButton').addEventListener('click', function(event) {
	        // Prevent default behavior
	        event.preventDefault();
	        
	        // Send the email using the hidden form data
	        emailjs.sendForm('service_fprd88b', 'template_jq8f25q', document.getElementById('emailForm'))
	            .then(function() {
	                alert('Bill sent successfully to ' + document.querySelector('input[name="customer_email"]').value);
	            }, function(error) {
	                alert('Failed to send bill. Please try again.');
	                console.error('Error:', error);
	            });
	    });
	</script>

	<!-- Bootstrap JS & dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
</body>
</html>
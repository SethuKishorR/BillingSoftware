<%@ page import="java.util.List, java.util.Map"%>
<%@ page import="com.hibernate.Entity.Menu"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Billing</title>
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
	background-color: #f0f0f0; /* Light gray background for the page */
}

.container {
	max-width: 1200px; /* Set a maximum width for the container */
}

.table-container {
	margin: 20px;
	height: 310px; /* Adjust based on screen size */
	overflow-y: auto;
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
		<div class="container my-4 py-4 bg-white rounded shadow-sm">
			<a href="MenuServlet" class="text-danger" style="text-decoration: none;">>>menu</a>&nbsp;
			<a href="allOrders.jsp" class="text-danger" style="text-decoration: none;">>>histories</a>
			<form action="BillingServlet" method="post" class="mt-4">
				<!-- Tabs for Menu Groups -->
				<ul class="nav nav-tabs" id="menuTabs" role="tablist">
					<%
					// Retrieve grouped menus from request
					Map<String, List<Menu>> groupedMenus = (Map<String, List<Menu>>) request.getAttribute("groupedMenus");
					if (groupedMenus != null && !groupedMenus.isEmpty()) {
						int index = 0;
						for (String groupName : groupedMenus.keySet()) {
					%>
					<li class="nav-item" role="presentation"><a
						class="nav-link <%=index == 0 ? "active" : ""%>"
						id="tab-<%=index%>" data-bs-toggle="tab" href="#group-<%=index%>"
						role="tab" aria-controls="group-<%=index%>"
						aria-selected="<%=index == 0 ? "true" : "false"%>"><%=groupName%></a>
					</li>
					<%
					index++;
					}
					}
					%>
				</ul>
				<div class="tab-content mt-3" id="menuTabsContent">
					<%
					// Generate content for each tab
					if (groupedMenus != null && !groupedMenus.isEmpty()) {
						int index = 0;
						for (String groupName : groupedMenus.keySet()) {
							List<Menu> menus = groupedMenus.get(groupName);
					%>
					<div class="tab-pane fade <%=index == 0 ? "show active" : ""%>"
						id="group-<%=index%>" role="tabpanel"
						aria-labelledby="tab-<%=index%>">
						<div class="table-container">
							<table class="table table-striped table-hover">
								<thead>
									<tr>
										<th style="width:25%;">Menu Name</th>
										<th style="width:25%;">Price</th>
										<th style="width:25%;">Quantity</th>
										<th style="width:25%;">Select</th>
									</tr>
								</thead>
								<tbody>
									<%
									if (menus != null && !menus.isEmpty()) {
										for (Menu menu : menus) {
									%>
									<tr>
										<td class="py-3" style="vertical-align: middle;"><%=menu.getMenuName()%></td>
										<td style="vertical-align: middle;"><%=menu.getPrice()%></td>
										<td style="vertical-align: middle;">
											<select name="quantities_<%=menu.getMid()%>" class="form-select w-25">
												<% for (int i = 1; i <= 5; i++) { %>
													<option value="<%=i%>"><%=i%></option>
												<% } %>
											</select>
										</td>
										<td style="vertical-align: middle;"><input
											type="checkbox" name="selectedMenus"
											value="<%=menu.getMid()%>"></td>
									</tr>
									<%
									}
									} else {
									%>
									<tr>
										<td colspan="3">No menus available.</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
					<%
					index++;
					}
					}
					%>
				</div>

				<!-- Customer Details -->
				<div class="mb-4 px-4">
					<div class="row">
						<div class="col-md-6 mb-3">
							<label for="customerName" class="form-label">Customer
								Name</label> <input type="text" class="form-control" id="customerName"
								name="customerName" required>
						</div>
						<div class="col-md-6 mb-3">
							<label for="customerEmail" class="form-label">Customer
								Email</label> <input type="email" class="form-control"
								id="customerEmail" name="customerEmail" required>
						</div>
					</div>
				</div>


				<div class="d-flex justify-content-end px-4">
					<button type="submit" class="btn btn-success">Submit Order</button>
				</div>
			</form>
		</div>
	</div>
	<!-- Bootstrap JS & dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
</body>
</html>
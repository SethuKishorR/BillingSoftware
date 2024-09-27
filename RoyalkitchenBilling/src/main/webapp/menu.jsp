<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map"%>
<%@ page import="com.hibernate.Entity.Menu"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Menu Management</title>
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
	height: 450px; /* Set a default height for the table container */
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
	border:solid 1px lightgray !important;
}
</style>
</head>
<body>
	<div
		class="d-flex align-items-center justify-content-center min-vh-100">
		<div class="container my-4 py-4 bg-white rounded shadow-sm">
		<a href="BillingServlet" class="text-danger" style="text-decoration: none;">>>back</a>
			<div class="d-flex justify-content-end mb-3">
				<button class="btn btn-info" data-bs-toggle="modal"
					data-bs-target="#menuModal">Add New Menu</button>
			</div>

			<%-- Retrieve grouped menus from request --%>
			<%
			Map<String, List<Menu>> groupedMenus = (Map<String, List<Menu>>) request.getAttribute("groupedMenus");
			%>

			<%-- Create Bootstrap tabs --%>
			<ul class="nav nav-tabs" id="menuTabs" role="tablist">
				<%-- Dynamically create tabs based on grouped menus --%>
				<%
				if (groupedMenus != null && !groupedMenus.isEmpty()) {
					int index = 0;
					for (String groupName : groupedMenus.keySet()) {
				%>
				<li class="nav-item" role="presentation"><a
					class="nav-link <%=index == 0 ? "active" : ""%>"
					id="tab-<%=index%>" data-bs-toggle="tab" href="#pane-<%=index%>"
					role="tab" aria-controls="pane-<%=index%>"
					aria-selected="<%=index == 0%>"><%=groupName%></a></li>
				<%
				index++;
				}
				}
				%>
			</ul>

			<div class="tab-content mt-3">
				<%-- Create tab content for each group --%>
				<%
				if (groupedMenus != null && !groupedMenus.isEmpty()) {
					int index = 0;
					for (Map.Entry<String, List<Menu>> groupEntry : groupedMenus.entrySet()) {
						String groupName = groupEntry.getKey();
						List<Menu> menus = groupEntry.getValue();
				%>
				<div class="tab-pane fade <%=index == 0 ? "show active" : ""%>"
					id="pane-<%=index%>" role="tabpanel"
					aria-labelledby="tab-<%=index%>">
					<div class="table-container px-4">
						<table class="table table-striped table-hover">
							<thead>
								<tr>
									<th style="width: 20%;">Menu ID</th>
									<th style="width: 20%;">Menu Name</th>
									<th style="width: 20%;">Price</th>
									<th style="width: 20%;">Update</th>
									<th style="width: 20%;">Delete</th>
								</tr>
							</thead>
							<tbody>
								<%-- Display menu items for each group --%>
								<%
								for (Menu menu : menus) {
								%>
								<tr>
									<td style="vertical-align: middle;"><%=menu.getMid()%></td>
									<td style="vertical-align: middle;"><%=menu.getMenuName()%></td>
									<td style="vertical-align: middle;"><%=menu.getPrice()%></td>
									<td style="vertical-align: middle;">
										<button class="btn btn-warning rounded-btn"
											data-bs-toggle="modal" data-bs-target="#menuModal"
											onclick="populateModal(<%=menu.getMid()%>, '<%=menu.getMenuName()%>', <%=menu.getPrice()%>, '<%=menu.getGroupName()%>')">
											<i class="fas fa-pencil-alt"></i>
										</button>
									</td>
									<td style="vertical-align: middle;"><a
										href="MenuServlet?action=delete&mid=<%=menu.getMid()%>"
										class="btn btn-danger rounded-btn"> <i
											class="fas fa-trash-alt"></i>
									</a></td>
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
		</div>
	</div>
	<!-- Bootstrap Modal for Add/Edit Menu -->
	<div class="modal fade" id="menuModal" tabindex="-1"
		aria-labelledby="menuModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="menuModalLabel">Add / Edit Menu</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="MenuServlet" method="post">
					<input type="hidden" id="action" name="action" value="insert" /> <input
						type="hidden" id="mid" name="mid" />
					<div class="modal-body">
						<div class="mb-3">
							<label for="menuName" class="form-label">Menu Name:</label> <input
								type="text" class="form-control" id="menuName" name="menuName"
								required>
						</div>
						<div class="mb-3">
							<label for="price" class="form-label">Price:</label> <input
								type="number" step="0.01" class="form-control" id="price"
								name="price" required>
						</div>
						<div class="mb-3">
							<label for="groupName" class="form-label">Group Name:</label> <select
								class="form-select" id="groupName" name="groupName" required>
								<option value="Snax">Snax</option>
								<option value="Drinks">Drinks</option>
								<option value="Meals">Meals</option>
								<option value="Ice Cream">Ice Cream</option>
								<option value="Sweets">Sweets</option>
							</select>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Cancel</button>
						<input type="submit" class="btn btn-primary" value="Save">
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS & dependencies -->
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>

	<!-- Script to populate modal for edit -->
	<script>
        function populateModal(mid, menuName, price, groupName) {
            document.getElementById('menuModalLabel').innerText = 'Edit Menu';
            document.getElementById('action').value = 'update';
            document.getElementById('mid').value = mid;
            document.getElementById('menuName').value = menuName;
            document.getElementById('price').value = price;
            document.getElementById('groupName').value = groupName;
        }

        // Reset modal for adding a new menu
        document.getElementById('menuModal').addEventListener('hidden.bs.modal', function () {
            document.getElementById('menuModalLabel').innerText = 'Add New Menu';
            document.getElementById('action').value = 'insert';
            document.getElementById('mid').value = '';
            document.getElementById('menuName').value = '';
            document.getElementById('price').value = '';
            document.getElementById('groupName').value = 'snax'; // default value
        });
    </script>
</body>
</html>

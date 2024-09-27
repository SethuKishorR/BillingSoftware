package com.hibernate.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hibernate.DAOImpl.MenuDAOImpl;
import com.hibernate.DAOImpl.OrderDAOImpl;
import com.hibernate.Entity.Menu;
import com.hibernate.Entity.OrderDetails;
import com.hibernate.Entity.OrderMenuDetails;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MenuDAOImpl menuDAO;
	private OrderDAOImpl orderDAO;

	public void init() {
		menuDAO = new MenuDAOImpl(); // Initialize MenuDAOImpl object
		orderDAO = new OrderDAOImpl(); // Initialize OrderDAOImpl object
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    // Fetch all menus from the database, ensuring menuList is never null
	    List<Menu> menuList = menuDAO.getAllMenus(); 

	    // Use a fallback to an empty list if menuList is null
	    if (menuList == null) {
	        menuList = new ArrayList<>();  // Fallback to an empty list
	    }

	    // Check if the menuList is not empty before grouping
	    if (!menuList.isEmpty()) {
	        // Group menus by groupName if menuList is not null and not empty
	        Map<String, List<Menu>> groupedMenus = menuList.stream()
	                .collect(Collectors.groupingBy(Menu::getGroupName)); 

	        // Set grouped menus in the request
	        request.setAttribute("groupedMenus", groupedMenus); 
	    } else {
	        // Handle case when menuList is empty
	        request.setAttribute("groupedMenus", Collections.emptyMap()); 
	    }

	    // Forward the request to billing.jsp
	    RequestDispatcher dispatcher = request.getRequestDispatcher("billing.jsp");
	    dispatcher.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String customerName = request.getParameter("customerName");
		String customerEmail = request.getParameter("customerEmail");
		String[] selectedMenuIds = request.getParameterValues("selectedMenus");

		if (selectedMenuIds == null || selectedMenuIds.length == 0) {
			request.setAttribute("errorMessage", "No menu items selected.");
			doGet(request, response); // Redisplay the billing page with an error message
			return;
		}

		// Fetch selected menu items
		List<Menu> selectedMenus = new ArrayList<>();
		for (String menuId : selectedMenuIds) {
			int id = Integer.parseInt(menuId);
			Menu menu = menuDAO.getMenuById(id); // Fetch menu details by ID
			selectedMenus.add(menu);
		}

		// Create OrderDetails (without OrderMenuDetails initially)
		OrderDetails orderDetails = new OrderDetails(
				customerName,
				customerEmail,
				"Pending" // Assuming the default paidStatus is "Pending"
				);

		// Create OrderMenuDetails and link them to OrderDetails
		List<OrderMenuDetails> orderMenuDetailsList = new ArrayList<>();
		double totalAmount = 0.0; // Calculate total amount

		for (String menuId : selectedMenuIds) {
			int id = Integer.parseInt(menuId);
			Menu menu = menuDAO.getMenuById(id);
			if (menu != null) {
				// Fetch quantity for the selected menu item
				String quantityParam = request.getParameter("quantities_" + id);
				int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : 1;

				OrderMenuDetails orderMenuDetails = new OrderMenuDetails(
						menu.getMenuName(),
						menu.getPrice(),
						quantity,
						menu.getPrice() * quantity // Subtotal
						);
				orderMenuDetails.setOrderDetails(orderDetails);
				orderMenuDetailsList.add(orderMenuDetails);
				totalAmount += menu.getPrice() * quantity;
			}
		}
		orderDetails.setOrderMenuDetails(orderMenuDetailsList); // Set the list of OrderMenuDetails to OrderDetails

		// Save the order to the database
		orderDAO.saveOrder(orderDetails);

		response.sendRedirect("allOrders.jsp"); // Redirect to a confirmation page
	}
}
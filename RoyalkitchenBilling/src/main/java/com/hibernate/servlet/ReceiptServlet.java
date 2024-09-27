package com.hibernate.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hibernate.DAO.OrderDAO;
import com.hibernate.DAOImpl.OrderDAOImpl;
import com.hibernate.Entity.OrderDetails;

@WebServlet("/ReceiptServlet")
public class ReceiptServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Retrieve the order ID from the request (as integer)
            String orderIdParam = request.getParameter("orderid");
            if (orderIdParam == null || orderIdParam.isEmpty()) {
                out.println("<p>Error: Order ID is required.</p>");
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);

            // Retrieve the paidStatus from the request
            String paidStatus = request.getParameter("paidStatus");

            // Initialize DAO and fetch the order details
            OrderDAO orderDAO = new OrderDAOImpl();
            OrderDetails order = orderDAO.getOrderById(orderId);

            if (order == null) {
                out.println("<p>Error: Order not found with ID " + orderId + "</p>");
                return;
            }

            // Update the paid status if provided
            if (paidStatus != null && !paidStatus.isEmpty()) {
                order.setPaidStatus(paidStatus);
                orderDAO.updateOrder(order);  // Persist the updated status to the database
                out.println("<p>Paid status updated to: " + paidStatus + "</p>");
            }

            // Set the order details as a request attribute for the JSP
            request.setAttribute("order", order);

            // Forward the request to the receipt JSP page for displaying the order
            request.getRequestDispatcher("/receipt.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            out.println("<p>Error: Invalid Order ID format. Please enter a valid integer.</p>");
        } catch (Exception e) {
            out.println("<p>Error: An unexpected error occurred. Details: " + e.getMessage() + "</p>");
        } finally {
            out.close();
        }
    }
}
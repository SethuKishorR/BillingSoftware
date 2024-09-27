package com.hibernate.servlet;

import java.io.IOException;
import java.util.ArrayList;
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
import com.hibernate.Entity.Menu;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAOImpl menuDAO;

    public void init() {
        menuDAO = new MenuDAOImpl(); // Initialize MenuDAOImpl object
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        service(request, response);  // Delegate to 'service' method for handling
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Default action: list all menus if no action is provided
        if (action == null || action.isEmpty()) {
            listMenu(request, response);
            return;
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "insert":
                insertMenu(request, response);
                break;
            case "delete":
                deleteMenu(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "update":
                updateMenu(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter.");
                break;
        }
    }

    private void listMenu(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Menu> listMenu = menuDAO.getAllMenus();  // Fetch menus from the database using DAO

        if (listMenu == null || listMenu.isEmpty()) {
            listMenu = new ArrayList<>();  // Empty list for safety
        }

        // Group menus by 'groupName', providing fallback for null values
        Map<String, List<Menu>> groupedMenus = listMenu.stream()
            .collect(Collectors.groupingBy(menu -> 
                menu.getGroupName() != null ? menu.getGroupName() : "Uncategorized"
            ));
        
        request.setAttribute("groupedMenus", groupedMenus);  // Set grouped menus in the request
        RequestDispatcher dispatcher = request.getRequestDispatcher("menu.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("menu-form.jsp").forward(request, response);
    }

    private void insertMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String menuName = request.getParameter("menuName");
        double price = Double.parseDouble(request.getParameter("price"));
        String groupName = request.getParameter("groupName"); // Handle groupName field

        Menu newMenu = new Menu(menuName, price, groupName);
        menuDAO.saveMenu(newMenu);
        response.sendRedirect("MenuServlet");  // Redirect after inserting
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int mid = Integer.parseInt(request.getParameter("mid"));
        Menu existingMenu = menuDAO.getMenuById(mid);  // Fetch menu by ID
        request.setAttribute("menu", existingMenu);  // Pass the existing menu to the form
        request.getRequestDispatcher("menu-form.jsp").forward(request, response);
    }

    private void updateMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int mid = Integer.parseInt(request.getParameter("mid"));
        String menuName = request.getParameter("menuName");
        double price = Double.parseDouble(request.getParameter("price"));
        String groupName = request.getParameter("groupName");  // Handle groupName field

        Menu menu = new Menu(mid, menuName, price, groupName);
        menuDAO.updateMenu(menu);
        response.sendRedirect("MenuServlet");  // Redirect after updating
    }

    private void deleteMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int mid = Integer.parseInt(request.getParameter("mid"));
        menuDAO.deleteMenu(mid);
        response.sendRedirect("MenuServlet");  // Redirect after deletion
    }
}
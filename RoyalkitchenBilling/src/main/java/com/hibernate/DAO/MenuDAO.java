package com.hibernate.DAO;

import java.util.List;
import com.hibernate.Entity.Menu;

public interface MenuDAO {
    void saveMenu(Menu menu);               // Create or save a new menu
    Menu getMenuById(int mid);              // Retrieve a menu by its ID
    void updateMenu(Menu menu);             // Update an existing menu
    void deleteMenu(int mid);               // Delete a menu by its ID
    List<Menu> getAllMenus();               // Retrieve all menus
}
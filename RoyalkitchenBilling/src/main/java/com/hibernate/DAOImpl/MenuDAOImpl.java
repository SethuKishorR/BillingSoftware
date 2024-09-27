package com.hibernate.DAOImpl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import com.hibernate.DAO.MenuDAO;
import com.hibernate.Entity.Menu;

public class MenuDAOImpl implements MenuDAO {

	private SessionFactory sessionFactory;

	// Constructor to establish Hibernate connection and initialize SessionFactory
	public MenuDAOImpl() {
		this.sessionFactory = new Configuration()
				.configure()  // This loads hibernate.cfg.xml
				.addAnnotatedClass(Menu.class)
				.buildSessionFactory();
	}

	@Override
	public void saveMenu(Menu menu) {
		// Open a new session
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		session.save(menu);
		transaction.commit();
		session.close();  // Always close the session
		System.out.println("Menu saved successfully!");
	}

	@Override
	public Menu getMenuById(int mid) {
		// Open a new session
		Session session = sessionFactory.openSession();
		Menu menu = session.get(Menu.class, mid);
		session.close();  // Always close the session
		return menu;
	}

	@Override
	public void updateMenu(Menu menu) {
		// Open a new session
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		session.update(menu);
		transaction.commit();
		session.close();  // Always close the session
		System.out.println("Menu updated successfully!");
	}

	@Override
	public void deleteMenu(int mid) {
		// Open a new session
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		Menu menu = session.get(Menu.class, mid);
		if (menu != null) {
			session.delete(menu);
		}
		transaction.commit();
		session.close();  // Always close the session
		System.out.println("Menu deleted successfully!");
	}

	@Override
	public List<Menu> getAllMenus() {
	    // Open a new session
	    Session session = sessionFactory.openSession();
	    
	    // Initialize listMenu as an empty list to avoid returning null
	    List<Menu> listMenu = new ArrayList<>(); 

	    try {
	        session.beginTransaction();
	        // Use HQL to fetch all menus
	        listMenu = session.createQuery("FROM Menu ORDER BY groupName", Menu.class).list(); // Assign result to listMenu
	        session.getTransaction().commit();
	    } catch (Exception e) {
	        e.printStackTrace();
	        if (session.getTransaction() != null) {
	            session.getTransaction().rollback();
	        }
	    } finally {
	        session.close();  // Always close the session
	    }

	    // Return listMenu, which is guaranteed to be non-null (it will be empty if an exception occurs)
	    return listMenu; 
	}

	// Close the SessionFactory when the application shuts down
	public void closeSessionFactory() {
		if (sessionFactory != null && !sessionFactory.isClosed()) {
			sessionFactory.close();
		}
	}
}
package com.hibernate.DAOImpl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import com.hibernate.DAO.OrderDAO;
import com.hibernate.Entity.OrderDetails;
import com.hibernate.Entity.OrderMenuDetails;

public class OrderDAOImpl implements OrderDAO {

    private static SessionFactory sessionFactory;
    static {
        try {
            sessionFactory = new Configuration()
                    .configure()  // Load hibernate.cfg.xml
                    .addAnnotatedClass(OrderDetails.class)
                    .addAnnotatedClass(OrderMenuDetails.class)
                    .buildSessionFactory();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Failed to initialize SessionFactory");
        }
    }

    @Override
    public void saveOrder(OrderDetails orderDetails) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.save(orderDetails);
            transaction.commit();
            System.out.println("Order saved successfully!");
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public OrderDetails getOrderById(int oid) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(OrderDetails.class, oid);
        }
    }

    @Override
    public void updateOrder(OrderDetails orderDetails) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.update(orderDetails);
            transaction.commit();
            System.out.println("Order updated successfully!");
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int oid) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            OrderDetails orderDetails = session.get(OrderDetails.class, oid);
            if (orderDetails != null) {
                session.delete(orderDetails);
            }
            transaction.commit();
            System.out.println("Order deleted successfully!");
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public List<OrderDetails> getAllOrders() {
        Session session = sessionFactory.openSession();
        List<OrderDetails> orders = session.createQuery("from OrderDetails", OrderDetails.class).getResultList();
        session.close();
        return orders;
    }
}
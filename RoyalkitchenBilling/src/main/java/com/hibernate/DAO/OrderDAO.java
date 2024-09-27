package com.hibernate.DAO;

import java.util.List;
import com.hibernate.Entity.OrderDetails;

public interface OrderDAO {
    void saveOrder(OrderDetails orderDetails);
    OrderDetails getOrderById(int oid);
    void updateOrder(OrderDetails orderDetails);
    void deleteOrder(int oid);
    List<OrderDetails> getAllOrders();
}
package com.hibernate.Entity;

import javax.persistence.*;

@Entity
@Table(name="orderMenuDetails")
public class OrderMenuDetails {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="omd")
	private int omd;
	@Column(name="menuName")
	private String menuName;
	@Column(name="price")
	private double price;
	@Column(name="quantity")
	private int quantity;
	@Column(name="subtotal")
	private double subtotal;
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="oid")
	private OrderDetails orderDetails;
	
	public OrderMenuDetails() {
		super();
	}

	public OrderMenuDetails(String menuName, double price, int quantity, double subtotal) {
		super();
		this.menuName = menuName;
		this.price = price;
		this.quantity = quantity;
		this.subtotal = subtotal;
	}

	public OrderMenuDetails(String menuName, double price, int quantity, double subtotal, OrderDetails orderDetails) {
		super();
		this.menuName = menuName;
		this.price = price;
		this.quantity = quantity;
		this.subtotal = subtotal;
		this.orderDetails = orderDetails;
	}

	public OrderMenuDetails(int omd, String menuName, double price, int quantity, double subtotal,
			OrderDetails orderDetails) {
		super();
		this.omd = omd;
		this.menuName = menuName;
		this.price = price;
		this.quantity = quantity;
		this.subtotal = subtotal;
		this.orderDetails = orderDetails;
	}

	public int getOmd() {
		return omd;
	}

	public void setOmd(int omd) {
		this.omd = omd;
	}

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(double subtotal) {
		this.subtotal = subtotal;
	}

	public OrderDetails getOrderDetails() {
		return orderDetails;
	}

	public void setOrderDetails(OrderDetails orderDetails) {
		this.orderDetails = orderDetails;
	}
}

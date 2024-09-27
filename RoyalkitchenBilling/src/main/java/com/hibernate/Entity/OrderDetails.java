package com.hibernate.Entity;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="orderDetails")
public class OrderDetails {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="oid")
	private int oid;
	@Column(name="customerName")
	private String customerName;
	@Column(name="customerEmail")
	private String customerEmail;
	@Column(name="paidStatus")
	private String paidStatus;
	@OneToMany(mappedBy = "orderDetails", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	private List<OrderMenuDetails> orderMenuDetails;
	
	public OrderDetails() {
		super();
	}

	public OrderDetails(String customerName, String customerEmail, String paidStatus) {
		super();
		this.customerName = customerName;
		this.customerEmail = customerEmail;
		this.paidStatus = paidStatus;
	}

	public OrderDetails(String customerName, String customerEmail, String paidStatus,
			List<OrderMenuDetails> orderMenuDetails) {
		super();
		this.customerName = customerName;
		this.customerEmail = customerEmail;
		this.paidStatus = paidStatus;
		this.orderMenuDetails = orderMenuDetails;
	}

	public OrderDetails(int oid, String customerName, String customerEmail, String paidStatus,
			List<OrderMenuDetails> orderMenuDetails) {
		super();
		this.oid = oid;
		this.customerName = customerName;
		this.customerEmail = customerEmail;
		this.paidStatus = paidStatus;
		this.orderMenuDetails = orderMenuDetails;
	}

	public int getOid() {
		return oid;
	}

	public void setOid(int oid) {
		this.oid = oid;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerEmail() {
		return customerEmail;
	}

	public void setCustomerEmail(String customerEmail) {
		this.customerEmail = customerEmail;
	}

	public String getPaidStatus() {
		return paidStatus;
	}

	public void setPaidStatus(String paidStatus) {
		this.paidStatus = paidStatus;
	}

	public List<OrderMenuDetails> getOrderMenuDetails() {
		return orderMenuDetails;
	}

	public void setOrderMenuDetails(List<OrderMenuDetails> orderMenuDetails) {
		this.orderMenuDetails = orderMenuDetails;
	}
}

package com.hibernate.Entity;

import javax.persistence.*;

@Entity
@Table(name="menu")
public class Menu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="mid")
    private int mid;

    @Column(name="menuName")
    private String menuName;

    @Column(name="price")
    private double price;
    
    @Column(name="groupName") // New field for grouping
    private String groupName;

    public Menu() {
        super();
    }

    public Menu(String menuName, double price, String groupName) {
        super();
        this.menuName = menuName;
        this.price = price;
        this.groupName = groupName;
    }

    public Menu(int mid, String menuName, double price, String groupName) {
        super();
        this.mid = mid;
        this.menuName = menuName;
        this.price = price;
        this.groupName = groupName;
    }

    public int getMid() {
        return mid;
    }

    public void setMid(int mid) {
        this.mid = mid;
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

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
}
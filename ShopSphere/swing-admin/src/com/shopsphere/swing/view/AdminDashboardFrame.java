package com.shopsphere.swing.view;

import com.shopsphere.swing.dao.SwingAdminDAO;
import com.shopsphere.swing.model.*;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

/**
 * Modern Swing Admin Dashboard demonstrating Swing MVC, JTable, JTabbedPane,
 * and dialog interaction with MySQL via JDBC.
 */
public class AdminDashboardFrame extends JFrame {

    private final SwingAdminDAO adminDAO;

    // Table Models
    private DefaultTableModel productModel;
    private DefaultTableModel categoryModel;
    private DefaultTableModel orderModel;
    private DefaultTableModel lowStockModel;

    // Tables
    private JTable productTable;
    private JTable categoryTable;
    private JTable orderTable;
    private JTable lowStockTable;

    public AdminDashboardFrame() {
        this.adminDAO = new SwingAdminDAO();

        setTitle("ShopSphere Enterprise - Swing Admin Management Console");
        setSize(950, 650);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel(new BorderLayout());

        // Top Header
        JPanel topBar = new JPanel(new BorderLayout());
        topBar.setBackground(new Color(15, 23, 42));
        topBar.setBorder(new EmptyBorder(15, 20, 15, 20));

        JLabel lblTitle = new JLabel("ShopSphere Desktop Management Console");
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 18));
        lblTitle.setForeground(Color.WHITE);

        JLabel lblViva = new JLabel("RTU Advanced Java Project (Swing MVC + JDBC)");
        lblViva.setFont(new Font("Segoe UI", Font.ITALIC, 12));
        lblViva.setForeground(new Color(148, 163, 184));

        topBar.add(lblTitle, BorderLayout.WEST);
        topBar.add(lblViva, BorderLayout.EAST);
        mainPanel.add(topBar, BorderLayout.NORTH);

        // Tabbed Pane
        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("Segoe UI", Font.BOLD, 13));

        tabbedPane.addTab("📦 Product Management", createProductPanel());
        tabbedPane.addTab("🏷️ Categories", createCategoryPanel());
        tabbedPane.addTab("🛒 Customer Orders", createOrderPanel());
        tabbedPane.addTab("⚠️ Low-Stock Alerts", createLowStockPanel());

        mainPanel.add(tabbedPane, BorderLayout.CENTER);
        add(mainPanel);

        // Initial Data Load
        refreshAll();
    }

    private JPanel createProductPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        String[] cols = {"ID", "Name", "Brand", "Category", "Price (₹)", "Discount %", "Stock", "Status"};
        productModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        productTable = new JTable(productModel);
        productTable.setRowHeight(26);
        productTable.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        productTable.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        JScrollPane scroll = new JScrollPane(productTable);
        panel.add(scroll, BorderLayout.CENTER);

        // Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        JButton btnAdd = new JButton("➕ Add Product");
        JButton btnRestock = new JButton("🔄 Update Stock");
        JButton btnDelete = new JButton("🗑️ Delete Product");
        JButton btnRefresh = new JButton("🔁 Refresh");

        btnAdd.addActionListener(e -> showAddProductDialog());
        btnRestock.addActionListener(e -> showRestockDialog());
        btnDelete.addActionListener(e -> deleteSelectedProduct());
        btnRefresh.addActionListener(e -> loadProducts());

        toolbar.add(btnAdd);
        toolbar.add(btnRestock);
        toolbar.add(btnDelete);
        toolbar.add(btnRefresh);

        panel.add(toolbar, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel createCategoryPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        String[] cols = {"ID", "Category Name", "Description", "Status"};
        categoryModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        categoryTable = new JTable(categoryModel);
        categoryTable.setRowHeight(26);
        categoryTable.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        categoryTable.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        panel.add(new JScrollPane(categoryTable), BorderLayout.CENTER);

        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        JButton btnAddCat = new JButton("➕ New Category");
        JButton btnRefresh = new JButton("🔁 Refresh");

        btnAddCat.addActionListener(e -> showAddCategoryDialog());
        btnRefresh.addActionListener(e -> loadCategories());

        toolbar.add(btnAddCat);
        toolbar.add(btnRefresh);
        panel.add(toolbar, BorderLayout.SOUTH);

        return panel;
    }

    private JPanel createOrderPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        String[] cols = {"Order ID", "Customer", "Total Amount (₹)", "Payment Method", "Status", "Date"};
        orderModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        orderTable = new JTable(orderModel);
        orderTable.setRowHeight(26);
        orderTable.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        orderTable.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        panel.add(new JScrollPane(orderTable), BorderLayout.CENTER);

        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        JLabel lblStatus = new JLabel("Set Status to:");
        JComboBox<String> cmbStatus = new JComboBox<>(new String[]{"PLACED", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"});
        JButton btnUpdateStatus = new JButton("Update Selected Order");
        JButton btnRefresh = new JButton("🔁 Refresh");

        btnUpdateStatus.addActionListener(e -> {
            int selectedRow = orderTable.getSelectedRow();
            if (selectedRow == -1) {
                JOptionPane.showMessageDialog(this, "Select an order to update.", "Selection Required", JOptionPane.WARNING_MESSAGE);
                return;
            }
            int orderId = (int) orderModel.getValueAt(selectedRow, 0);
            String newStatus = (String) cmbStatus.getSelectedItem();
            adminDAO.updateOrderStatus(orderId, newStatus);
            JOptionPane.showMessageDialog(this, "Order #SPH-" + orderId + " updated to " + newStatus, "Success", JOptionPane.INFORMATION_MESSAGE);
            loadOrders();
        });

        btnRefresh.addActionListener(e -> loadOrders());

        toolbar.add(lblStatus);
        toolbar.add(cmbStatus);
        toolbar.add(btnUpdateStatus);
        toolbar.add(btnRefresh);
        panel.add(toolbar, BorderLayout.SOUTH);

        return panel;
    }

    private JPanel createLowStockPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        String[] cols = {"Product ID", "Name", "Brand", "Current Units in Warehouse", "Urgency"};
        lowStockModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        lowStockTable = new JTable(lowStockModel);
        lowStockTable.setRowHeight(26);
        lowStockTable.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lowStockTable.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        panel.add(new JScrollPane(lowStockTable), BorderLayout.CENTER);

        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        JButton btnQuickRestock = new JButton("⚡ Restock +50 Units");
        JButton btnRefresh = new JButton("🔁 Refresh");

        btnQuickRestock.addActionListener(e -> {
            int selectedRow = lowStockTable.getSelectedRow();
            if (selectedRow == -1) {
                JOptionPane.showMessageDialog(this, "Select an item from the low stock list.", "Selection Required", JOptionPane.WARNING_MESSAGE);
                return;
            }
            int productId = (int) lowStockModel.getValueAt(selectedRow, 0);
            int currentStock = (int) lowStockModel.getValueAt(selectedRow, 3);
            adminDAO.updateStock(productId, currentStock + 50);
            JOptionPane.showMessageDialog(this, "Product #" + productId + " restocked with +50 units!", "Restock Successful", JOptionPane.INFORMATION_MESSAGE);
            refreshAll();
        });

        btnRefresh.addActionListener(e -> loadLowStock());

        toolbar.add(btnQuickRestock);
        toolbar.add(btnRefresh);
        panel.add(toolbar, BorderLayout.SOUTH);

        return panel;
    }

    private void showAddProductDialog() {
        JTextField txtName = new JTextField();
        JTextField txtBrand = new JTextField();
        JTextField txtPrice = new JTextField("999.00");
        JTextField txtDiscount = new JTextField("0");
        JTextField txtStock = new JTextField("25");

        List<CategoryItem> categories = adminDAO.getCategories();
        JComboBox<CategoryItem> cmbCat = new JComboBox<>(categories.toArray(new CategoryItem[0]));

        Object[] message = {
                "Product Name:", txtName,
                "Brand / Manufacturer:", txtBrand,
                "Category:", cmbCat,
                "Price (₹):", txtPrice,
                "Discount (%):", txtDiscount,
                "Stock Units:", txtStock
        };

        int option = JOptionPane.showConfirmDialog(this, message, "Add New Catalog Product", JOptionPane.OK_CANCEL_OPTION);
        if (option == JOptionPane.OK_OPTION) {
            try {
                String name = txtName.getText().trim();
                String brand = txtBrand.getText().trim();
                double price = Double.parseDouble(txtPrice.getText().trim());
                double discount = Double.parseDouble(txtDiscount.getText().trim());
                int stock = Integer.parseInt(txtStock.getText().trim());
                CategoryItem selCat = (CategoryItem) cmbCat.getSelectedItem();

                if (!name.isEmpty() && selCat != null) {
                    adminDAO.addProduct(selCat.getId(), name, brand, price, discount, stock);
                    JOptionPane.showMessageDialog(this, "Product added to catalog!", "Success", JOptionPane.INFORMATION_MESSAGE);
                    refreshAll();
                }
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Invalid number inputs: " + ex.getMessage(), "Input Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void showRestockDialog() {
        int selectedRow = productTable.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this, "Select a product to update stock.", "Selection Required", JOptionPane.WARNING_MESSAGE);
            return;
        }

        int productId = (int) productModel.getValueAt(selectedRow, 0);
        String name = (String) productModel.getValueAt(selectedRow, 1);
        int currentStock = (int) productModel.getValueAt(selectedRow, 6);

        String input = JOptionPane.showInputDialog(this, "Enter new stock units for '" + name + "':", currentStock);
        if (input != null && !input.trim().isEmpty()) {
            try {
                int newStock = Integer.parseInt(input.trim());
                adminDAO.updateStock(productId, newStock);
                JOptionPane.showMessageDialog(this, "Stock updated to " + newStock, "Updated", JOptionPane.INFORMATION_MESSAGE);
                refreshAll();
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Please enter a valid integer for stock.", "Input Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void deleteSelectedProduct() {
        int selectedRow = productTable.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this, "Select a product to delete.", "Selection Required", JOptionPane.WARNING_MESSAGE);
            return;
        }

        int productId = (int) productModel.getValueAt(selectedRow, 0);
        String name = (String) productModel.getValueAt(selectedRow, 1);

        int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to delete product '" + name + "'?", "Confirm Deletion", JOptionPane.YES_NO_OPTION);
        if (confirm == JOptionPane.YES_OPTION) {
            adminDAO.deleteProduct(productId);
            refreshAll();
        }
    }

    private void showAddCategoryDialog() {
        JTextField txtName = new JTextField();
        JTextField txtDesc = new JTextField();
        Object[] fields = {
                "Category Name:", txtName,
                "Description:", txtDesc
        };
        int opt = JOptionPane.showConfirmDialog(this, fields, "Create Category", JOptionPane.OK_CANCEL_OPTION);
        if (opt == JOptionPane.OK_OPTION) {
            String name = txtName.getText().trim();
            String desc = txtDesc.getText().trim();
            if (!name.isEmpty()) {
                adminDAO.addCategory(name, desc);
                loadCategories();
            }
        }
    }

    private void refreshAll() {
        loadProducts();
        loadCategories();
        loadOrders();
        loadLowStock();
    }

    private void loadProducts() {
        productModel.setRowCount(0);
        List<ProductItem> list = adminDAO.getProducts();
        for (ProductItem p : list) {
            productModel.addRow(new Object[]{
                    p.getId(), p.getName(), p.getBrand(), p.getCategoryName(),
                    p.getPrice(), p.getDiscount(), p.getStock(), p.getStatus()
            });
        }
    }

    private void loadCategories() {
        categoryModel.setRowCount(0);
        List<CategoryItem> list = adminDAO.getCategories();
        for (CategoryItem c : list) {
            categoryModel.addRow(new Object[]{c.getId(), c.getName(), c.getDescription(), c.getStatus()});
        }
    }

    private void loadOrders() {
        orderModel.setRowCount(0);
        List<OrderItem> list = adminDAO.getOrders();
        for (OrderItem o : list) {
            orderModel.addRow(new Object[]{o.getOrderId(), o.getCustomerName(), o.getAmount(), o.getPaymentMethod(), o.getOrderStatus(), o.getCreatedAt()});
        }
    }

    private void loadLowStock() {
        lowStockModel.setRowCount(0);
        List<ProductItem> list = adminDAO.getProducts();
        for (ProductItem p : list) {
            if (p.getStock() <= 15) {
                String urgency = p.getStock() <= 5 ? "CRITICAL REFILL" : "LOW";
                lowStockModel.addRow(new Object[]{p.getId(), p.getName(), p.getBrand(), p.getStock(), urgency});
            }
        }
    }
}

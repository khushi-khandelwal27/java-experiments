package com.shopsphere.swing.view;

import com.shopsphere.swing.dao.SwingAdminDAO;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

public class LoginFrame extends JFrame {

    private final JTextField txtEmail;
    private final JPasswordField txtPassword;
    private final SwingAdminDAO adminDAO;

    public LoginFrame() {
        this.adminDAO = new SwingAdminDAO();

        setTitle("ShopSphere Desktop Administration - Sign In");
        setSize(450, 360);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setResizable(false);

        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(new EmptyBorder(25, 30, 25, 30));
        mainPanel.setBackground(new Color(248, 250, 252));

        // Header Panel
        JPanel headerPanel = new JPanel(new GridLayout(2, 1));
        headerPanel.setOpaque(false);
        JLabel lblTitle = new JLabel("ShopSphere Admin Portal", SwingConstants.CENTER);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 20));
        lblTitle.setForeground(new Color(79, 70, 229));

        JLabel lblSub = new JLabel("RTU Advanced Java Swing Desktop Client", SwingConstants.CENTER);
        lblSub.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lblSub.setForeground(new Color(100, 116, 139));

        headerPanel.add(lblTitle);
        headerPanel.add(lblSub);
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // Form Panel
        JPanel formPanel = new JPanel(new GridLayout(4, 1, 8, 8));
        formPanel.setOpaque(false);

        JLabel lblEmail = new JLabel("Administrator Email:");
        lblEmail.setFont(new Font("Segoe UI", Font.BOLD, 12));
        txtEmail = new JTextField("admin@shopsphere.com");
        txtEmail.setFont(new Font("Segoe UI", Font.PLAIN, 13));

        JLabel lblPwd = new JLabel("Password:");
        lblPwd.setFont(new Font("Segoe UI", Font.BOLD, 12));
        txtPassword = new JPasswordField("admin123");
        txtPassword.setFont(new Font("Segoe UI", Font.PLAIN, 13));

        formPanel.add(lblEmail);
        formPanel.add(txtEmail);
        formPanel.add(lblPwd);
        formPanel.add(txtPassword);

        mainPanel.add(formPanel, BorderLayout.CENTER);

        // Buttons Panel
        JPanel buttonPanel = new JPanel(new GridLayout(2, 1, 8, 8));
        buttonPanel.setOpaque(false);

        JButton btnLogin = new JButton("Sign In to Management Console");
        btnLogin.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btnLogin.setBackground(new Color(79, 70, 229));
        btnLogin.setForeground(Color.WHITE);
        btnLogin.setFocusPainted(false);
        btnLogin.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnLogin.addActionListener(e -> attemptLogin());

        JButton btnQuickFill = new JButton("⚡ Viva Quick Fill: admin@shopsphere.com / admin123");
        btnQuickFill.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        btnQuickFill.setForeground(new Color(79, 70, 229));
        btnQuickFill.setContentAreaFilled(false);
        btnQuickFill.setBorderPainted(false);
        btnQuickFill.addActionListener(e -> {
            txtEmail.setText("admin@shopsphere.com");
            txtPassword.setText("admin123");
        });

        buttonPanel.add(btnLogin);
        buttonPanel.add(btnQuickFill);
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);

        add(mainPanel);
    }

    private void attemptLogin() {
        String email = txtEmail.getText().trim();
        String password = new String(txtPassword.getPassword()).trim();

        if (email.isEmpty() || password.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter both email and password.", "Validation Error", JOptionPane.WARNING_MESSAGE);
            return;
        }

        boolean success = adminDAO.authenticateAdmin(email, password);
        if (success) {
            JOptionPane.showMessageDialog(this, "Authentication successful! Opening Admin Console...", "Success", JOptionPane.INFORMATION_MESSAGE);
            this.dispose();
            SwingUtilities.invokeLater(() -> new AdminDashboardFrame().setVisible(true));
        } else {
            JOptionPane.showMessageDialog(this, "Invalid credentials or non-admin account.", "Access Denied", JOptionPane.ERROR_MESSAGE);
        }
    }
}

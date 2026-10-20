package com.shopsphere.swing;

import com.shopsphere.swing.view.LoginFrame;

import javax.swing.*;

/**
 * Entry point for ShopSphere Swing Desktop Admin Client.
 * Demonstrates Pluggable Look and Feel (Section 21 of syllabus).
 */
public class Main {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                // Set system pluggable look and feel
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception e) {
                System.err.println("Could not set system look and feel: " + e.getMessage());
            }

            LoginFrame frame = new LoginFrame();
            frame.setVisible(true);
        });
    }
}

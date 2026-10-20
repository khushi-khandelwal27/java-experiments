package com.shopsphere.listener;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.model.Category;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Application Lifecycle and Session Event Listener.
 * Demonstrates ServletContextListener and HttpSessionListener for syllabus requirements.
 */
@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    private final AtomicInteger activeSessions = new AtomicInteger(0);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.setAttribute("appName", "ShopSphere");
        context.setAttribute("appVersion", "1.0-ENTERPRISE");

        // Load categories into application scope for rapid navbar access
        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getActiveCategories();
            context.setAttribute("globalCategories", categories);
            System.out.println("[AppListener] ShopSphere initialized. Loaded " + categories.size() + " categories.");
        } catch (Exception e) {
            System.err.println("[AppListener] Error initializing categories: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppListener] ShopSphere application shutting down gracefully.");
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        int count = activeSessions.incrementAndGet();
        se.getSession().getServletContext().setAttribute("activeUserCount", count);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        int count = activeSessions.decrementAndGet();
        se.getSession().getServletContext().setAttribute("activeUserCount", Math.max(0, count));
    }
}

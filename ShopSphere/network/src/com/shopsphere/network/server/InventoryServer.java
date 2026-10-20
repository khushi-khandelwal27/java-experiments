package com.shopsphere.network.server;

import com.shopsphere.network.model.Product;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Multithreaded TCP Inventory Server using java.net.ServerSocket.
 * Demonstrates Client-Server Socket programming and Object Serialization for RTU Syllabus.
 */
public class InventoryServer {

    public static final int PORT = 5050;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/shopsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASS = System.getenv().getOrDefault("DB_PASSWORD", "root");

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("  ShopSphere java.net Inventory Server");
        System.out.println("  Listening on TCP Port: " + PORT);
        System.out.println("=================================================");

        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            while (true) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("[Server] Client connected from: " + clientSocket.getRemoteSocketAddress());
                new Thread(new ClientHandler(clientSocket)).start();
            }
        } catch (IOException e) {
            System.err.println("[Server Error] " + e.getMessage());
        }
    }

    private static Connection getDBConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    private static class ClientHandler implements Runnable {
        private final Socket socket;

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                 PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
                 ObjectOutputStream objOut = new ObjectOutputStream(socket.getOutputStream())) {

                writer.println("CONNECTED to ShopSphere Inventory Server. Available commands: GET_PRODUCT <id>, GET_STOCK <id>, SEARCH_PRODUCT <keyword>, UPDATE_STOCK <id> <qty>, QUIT");

                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if ("QUIT".equalsIgnoreCase(line)) {
                        writer.println("BYE");
                        break;
                    }

                    System.out.println("[Server Received] " + line);
                    String[] tokens = line.split("\\s+", 3);
                    String command = tokens[0].toUpperCase();

                    switch (command) {
                        case "GET_STOCK":
                            if (tokens.length >= 2) {
                                int pId = Integer.parseInt(tokens[1]);
                                int stock = queryStock(pId);
                                writer.println(stock >= 0 ? "STOCK: " + stock : "ERROR: Product not found");
                            } else {
                                writer.println("USAGE: GET_STOCK <productId>");
                            }
                            break;

                        case "GET_PRODUCT":
                            if (tokens.length >= 2) {
                                int pId = Integer.parseInt(tokens[1]);
                                Product prod = queryProduct(pId);
                                if (prod != null) {
                                    writer.println("SUCCESS: " + prod.toString());
                                    // Also send serialized object
                                    objOut.writeObject(prod);
                                    objOut.flush();
                                } else {
                                    writer.println("ERROR: Product not found");
                                }
                            } else {
                                writer.println("USAGE: GET_PRODUCT <productId>");
                            }
                            break;

                        case "SEARCH_PRODUCT":
                            if (tokens.length >= 2) {
                                String query = tokens[1];
                                List<Product> list = searchProducts(query);
                                writer.println("FOUND: " + list.size() + " products");
                                for (Product p : list) {
                                    writer.println(" - " + p.toString());
                                }
                            } else {
                                writer.println("USAGE: SEARCH_PRODUCT <keyword>");
                            }
                            break;

                        case "UPDATE_STOCK":
                            if (tokens.length >= 3) {
                                int pId = Integer.parseInt(tokens[1]);
                                int qty = Integer.parseInt(tokens[2]);
                                boolean updated = updateStock(pId, qty);
                                writer.println(updated ? "SUCCESS: Stock updated to " + qty : "ERROR: Update failed");
                            } else {
                                writer.println("USAGE: UPDATE_STOCK <productId> <newStock>");
                            }
                            break;

                        default:
                            writer.println("ERROR: Unknown command: " + command);
                            break;
                    }
                }
            } catch (Exception e) {
                System.out.println("[Client Handler Disconnected] " + e.getMessage());
            } finally {
                try {
                    socket.close();
                } catch (IOException ignored) {}
            }
        }

        private int queryStock(int productId) {
            String sql = "SELECT stock FROM products WHERE product_id = ?";
            try (Connection con = getDBConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("stock");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return -1;
        }

        private Product queryProduct(int productId) {
            String sql = "SELECT p.*, c.name AS cat_name FROM products p JOIN categories c ON p.category_id = c.category_id WHERE p.product_id = ?";
            try (Connection con = getDBConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return new Product(
                                rs.getInt("product_id"),
                                rs.getString("name"),
                                rs.getString("brand"),
                                rs.getDouble("price"),
                                rs.getInt("stock"),
                                rs.getString("cat_name")
                        );
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return null;
        }

        private List<Product> searchProducts(String term) {
            List<Product> list = new ArrayList<>();
            String sql = "SELECT p.*, c.name AS cat_name FROM products p JOIN categories c ON p.category_id = c.category_id " +
                         "WHERE LOWER(p.name) LIKE ? OR LOWER(p.brand) LIKE ?";
            try (Connection con = getDBConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                String match = "%" + term.toLowerCase() + "%";
                ps.setString(1, match);
                ps.setString(2, match);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(new Product(
                                rs.getInt("product_id"),
                                rs.getString("name"),
                                rs.getString("brand"),
                                rs.getDouble("price"),
                                rs.getInt("stock"),
                                rs.getString("cat_name")
                        ));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return list;
        }

        private boolean updateStock(int productId, int newStock) {
            String sql = "UPDATE products SET stock = ? WHERE product_id = ?";
            try (Connection con = getDBConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, newStock);
                ps.setInt(2, productId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        }
    }
}

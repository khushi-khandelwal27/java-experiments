package com.shopsphere.network.client;

import java.io.*;
import java.net.Socket;
import java.util.Scanner;

/**
 * Socket Client demonstrating java.net communication and command execution.
 */
public class InventoryClient {

    private static final String HOST = "localhost";
    private static final int PORT = 5050;

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("  ShopSphere java.net Inventory Client");
        System.out.println("  Connecting to Server at " + HOST + ":" + PORT);
        System.out.println("=================================================");

        try (Socket socket = new Socket(HOST, PORT);
             BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
             PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
             Scanner scanner = new Scanner(System.in)) {

            // Read welcome message
            String banner = reader.readLine();
            System.out.println("[Server Response] " + banner);

            // Automated Demonstration sequence
            System.out.println("\n--- Running Automated RTU Demonstration Tests ---");
            runDemoTest(writer, reader, "GET_STOCK 1");
            runDemoTest(writer, reader, "GET_PRODUCT 1");
            runDemoTest(writer, reader, "SEARCH_PRODUCT Sony");

            System.out.println("\n--- Entering Interactive Console Mode (type 'QUIT' to exit) ---");
            while (true) {
                System.out.print("\nShopSphere-Network> ");
                if (!scanner.hasNextLine()) break;
                String command = scanner.nextLine().trim();
                if (command.isEmpty()) continue;

                writer.println(command);
                String response = reader.readLine();
                System.out.println("[Server] " + response);

                if ("QUIT".equalsIgnoreCase(command) || "BYE".equalsIgnoreCase(response)) {
                    break;
                }
            }
        } catch (IOException e) {
            System.err.println("[Connection Error] Unable to connect to " + HOST + ":" + PORT + " (" + e.getMessage() + ")");
            System.err.println("Make sure InventoryServer is running first!");
        }
    }

    private static void runDemoTest(PrintWriter writer, BufferedReader reader, String cmd) throws IOException {
        System.out.println("[Client Sent] " + cmd);
        writer.println(cmd);
        String response = reader.readLine();
        System.out.println("[Server Response] " + response);
    }
}

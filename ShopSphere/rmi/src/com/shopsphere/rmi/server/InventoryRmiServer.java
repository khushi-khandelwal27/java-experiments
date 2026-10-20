package com.shopsphere.rmi.server;

import com.shopsphere.rmi.remote.InventoryService;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * Server executable that starts the RMI Registry and registers the InventoryService.
 */
public class InventoryRmiServer {

    public static final int RMI_PORT = 1099;
    public static final String SERVICE_NAME = "InventoryService";

    public static void main(String[] args) {
        try {
            System.out.println("=================================================");
            System.out.println("  ShopSphere Java RMI Registry Server");
            System.out.println("=================================================");

            // Create or get local RMI registry on port 1099
            Registry registry;
            try {
                registry = LocateRegistry.createRegistry(RMI_PORT);
                System.out.println("[RMI Server] Created new RMI Registry on port " + RMI_PORT);
            } catch (Exception e) {
                registry = LocateRegistry.getRegistry(RMI_PORT);
                System.out.println("[RMI Server] Located existing RMI Registry on port " + RMI_PORT);
            }

            // Instantiate and bind the remote implementation
            InventoryService service = new InventoryServiceImpl();
            registry.rebind(SERVICE_NAME, service);

            System.out.println("[RMI Server] Remote service bound as: '" + SERVICE_NAME + "'");
            System.out.println("[RMI Server] Ready for client invocations (Press Ctrl+C to terminate).");

        } catch (Exception e) {
            System.err.println("[RMI Server Exception] " + e.getMessage());
            e.printStackTrace();
        }
    }
}

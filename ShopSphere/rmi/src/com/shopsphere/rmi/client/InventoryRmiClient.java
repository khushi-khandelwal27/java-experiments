package com.shopsphere.rmi.client;

import com.shopsphere.rmi.remote.InventoryService;
import com.shopsphere.rmi.remote.ProductDTO;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.List;

/**
 * Java RMI Client demonstrating lookup and remote invocation.
 */
public class InventoryRmiClient {

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("  ShopSphere Java RMI Client");
        System.out.println("  Connecting to RMI Registry on localhost:1099");
        System.out.println("=================================================");

        try {
            Registry registry = LocateRegistry.getRegistry("localhost", 1099);
            InventoryService service = (InventoryService) registry.lookup("InventoryService");

            System.out.println("[RMI Client] Successfully looked up InventoryService stub!");

            // 1. Remote call: getStock
            int stock = service.getStock(1);
            System.out.println("\n[Remote Call] service.getStock(1): " + stock + " units in warehouse");

            // 2. Remote call: getProduct
            ProductDTO p = service.getProduct(1);
            System.out.println("[Remote Call] service.getProduct(1): " + p);

            // 3. Remote call: getAllProducts
            List<ProductDTO> products = service.getAllProducts();
            System.out.println("\n[Remote Call] service.getAllProducts(): Returned " + products.size() + " items:");
            for (ProductDTO prod : products) {
                System.out.println("  -> #" + prod.getProductId() + " " + prod.getName() + " | Stock: " + prod.getStock());
            }

            System.out.println("\n[RMI Client] All RMI tests completed successfully!");

        } catch (Exception e) {
            System.err.println("[RMI Client Exception] " + e.getMessage());
            System.err.println("Make sure InventoryRmiServer is running on port 1099 before executing client.");
        }
    }
}

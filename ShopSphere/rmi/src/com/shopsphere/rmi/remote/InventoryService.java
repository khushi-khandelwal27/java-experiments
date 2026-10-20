package com.shopsphere.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

/**
 * Remote Interface for ShopSphere Remote Inventory Service.
 * Fulfills RTU Syllabus Section 18: RMI Architecture & Remote Interface.
 */
public interface InventoryService extends Remote {

    ProductDTO getProduct(int productId) throws RemoteException;

    int getStock(int productId) throws RemoteException;

    boolean updateStock(int productId, int newStock) throws RemoteException;

    List<ProductDTO> getAllProducts() throws RemoteException;
}

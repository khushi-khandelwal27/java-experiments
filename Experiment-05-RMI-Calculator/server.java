package RMI;

import java.rmi.Naming;

public class server {
    public static void main(String[] args) {
        try {
            calcinterface obj = new calcimpli();

            Naming.rebind("rmi://localhost:5000/Calculator", obj);

            System.out.println(" RMI Server is ready.");
        } 
        catch (Exception e) {
            System.out.println("RMI Server failed: " + e);
        }
    }
}
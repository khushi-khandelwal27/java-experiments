package RMI;

import java.rmi.Naming;

public class client {
    public static void main(String[] args) {

        try {
            calcinterface obj = (calcinterface) Naming.lookup("rmi://localhost:5000/Calculator");

            System.out.println("Addition: " + obj.add(5, 3));

            System.out.println("Subtraction: " + obj.sub(5, 3));

        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
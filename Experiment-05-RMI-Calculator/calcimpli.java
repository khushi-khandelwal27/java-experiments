package RMI;

import java.rmi.server.UnicastRemoteObject;
import java.rmi.RemoteException;

public class calcimpli extends UnicastRemoteObject
        implements calcinterface {

    calcimpli() throws RemoteException {
        super();
    }

    public int add(int a, int b) throws RemoteException {
        return a + b;
    }

    public int sub(int a, int b) throws RemoteException {
        return a - b;
    }
}
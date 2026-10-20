package RMI;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface calcinterface extends Remote{
    
    public int add(int a, int b) throws RemoteException;

    public int sub(int a, int b) throws RemoteException;

}

import javax.swing.*;

public class viewscalculator extends JFrame {

JLabel a, b, result;
JTextField txta, txtb, txtresult;
JButton btnAdd, btnSub, btnMul, btnDiv;

    viewscalculator() {
        setSize(300, 220);
        setLayout(null);
        setTitle("Calculator");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setResizable(false);

        a = new JLabel("Enter a :");
        a.setBounds(20, 20, 80, 25);
        add(a);

        txta = new JTextField();
        txta.setBounds(110, 20, 150, 25);
        add(txta);

        b = new JLabel("Enter b :");
        b.setBounds(20, 55, 80, 25);
        add(b);

        txtb = new JTextField();
        txtb.setBounds(110, 55, 150, 25);
        add(txtb);

        btnAdd = new JButton("+");
        btnAdd.setBounds(20, 95, 50, 35);
        add(btnAdd);

        btnSub = new JButton("-");
        btnSub.setBounds(75, 95, 50, 35);
        add(btnSub);

        btnMul = new JButton("*");
        btnMul.setBounds(130, 95, 50, 35);
        add(btnMul);

        btnDiv = new JButton("/");
        btnDiv.setBounds(185, 95, 50, 35);
        add(btnDiv);

        result = new JLabel("Result :");
        result.setBounds(20, 145, 80, 25);
        add(result);

        txtresult = new JTextField();
        txtresult.setBounds(110, 145, 150, 25);
        txtresult.setEditable(false);
        add(txtresult);

        setVisible(true);
    }
}
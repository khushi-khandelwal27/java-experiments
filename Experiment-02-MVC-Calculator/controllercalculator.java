import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class controllercalculator implements ActionListener {
    viewscalculator vc;
    modelscalculator mc;

    controllercalculator(viewscalculator vc, modelscalculator mc) {
        this.vc = vc;
        this.mc = mc;

        vc.btnAdd.addActionListener(this);
        vc.btnSub.addActionListener(this);
        vc.btnMul.addActionListener(this);
        vc.btnDiv.addActionListener(this);
    }

    @Override
    public void actionPerformed(ActionEvent e){
        double b = Double.parseDouble(vc.txtb.getText());
        double a = Double.parseDouble(vc.txta.getText());

        double res = 0;

        if (e.getSource() == vc.btnAdd) {
            res = mc.add(a, b);
        } else if (e.getSource() == vc.btnSub) {
            res = mc.sub(a, b);
        } else if (e.getSource() == vc.btnMul) {
            res = mc.mul(a, b);
        } else if (e.getSource() == vc.btnDiv) {
            res = mc.div(a, b);
        }
        vc.txtresult.setText(String.valueOf(res));
    }
}
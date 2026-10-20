public class runcalculator {
      public static void main(String[] args){
        viewscalculator vc = new viewscalculator();
        modelscalculator mc = new modelscalculator();
        new controllercalculator(vc, mc);
    }
}
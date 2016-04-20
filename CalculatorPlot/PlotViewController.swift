import UIKit

class PlotViewController: UIViewController, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    
    var brain: CalculatorBrain!
    
    var changed = 100 {
        didSet{
            updateMaster();
        }
    }
    
    func updateMaster(){

        if (lineChart) != nil {
            if let data2: [CGFloat] = GetFloatArr(){
                print(data2);
                
                var delta: Int64 = 4 * Int64(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, delta)
                
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.lineChart.clear()
                    self.lineChart.addLine(data2)
                });
                
            }
        }
        else{
            updateUI();
        }
        
    }
    
    func updateUI(){

        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        

        if let data: [CGFloat] = GetFloatArr(){
            print("access in print data")
            print(data);

        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 2
        lineChart.y.grid.count = 8
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        
        self.view.setNeedsDisplay();

        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func GetFloatArr() -> [CGFloat]?{
        if let res =  brain?.evaluateFrom0To100(){
            return res;
        }
        else {
            return nil;
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
}
import UIKit

class PlotViewController: UIViewController, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    
    var brain: CalculatorBrain!
    
    var changed = 100 {
        didSet{
            updateUI(changed);
        }
    }
    
    func updateUI(num: Int){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        
//        brain.pushOperand(Double(num));
//        brain.pushOperand("M");
//        brain.performOperation("+");
//        brain.performOperation("√");
        if let data: [CGFloat] = GetFloatArr(){
            print("access in print data")
            print(data);

            
        //        let data: [CGFloat] = [1, 3, 5, 13, 17, 20]
        
        // simple line with custom x axis labels
        // let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 2
        lineChart.y.grid.count = 8
        //        lineChart.x.labels.values = xLabels
        //        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        //        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        
        self.view.setNeedsDisplay();
        
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
        //        var delta: Int64 = 4 * Int64(NSEC_PER_SEC)
        //        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        //
        //        dispatch_after(time, dispatch_get_main_queue(), {
        //            self.lineChart.clear()
        //            self.lineChart.addLine(data2)
        //        });
        
        //        var scale = LinearScale(domain: [0, 100], range: [0.0, 100.0])
        //        var linear = scale.scale()
        //        var invert = scale.invert()
        //        println(linear(x: 2.5)) // 50
        //        println(invert(x: 50)) // 2.5
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(changed);
        
        //        var views: [String: AnyObject] = [:]
        //
        //        label.text = "..."
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.textAlignment = NSTextAlignment.Center
        //        self.view.addSubview(label)
        //        views["label"] = label
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        //
        //        // simple arrays
        //
        //        brain.pushOperand(5.0);
        //        brain.pushOperand("M");
        //        brain.performOperation("+");
        //        brain.performOperation("√");
        //
        //        let data: [CGFloat] = GetFloatArr()!;
        //        print(data);
        //
        ////        let data: [CGFloat] = [1, 3, 5, 13, 17, 20]
        //
        //        // simple line with custom x axis labels
        ////        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        //
        //        lineChart = LineChart()
        //        lineChart.animation.enabled = true
        //        lineChart.area = true
        //        lineChart.x.labels.visible = true
        //        lineChart.x.grid.count = 2
        //        lineChart.y.grid.count = 8
        ////        lineChart.x.labels.values = xLabels
        ////        lineChart.y.labels.visible = true
        //        lineChart.addLine(data)
        ////        lineChart.addLine(data2)
        //
        //        lineChart.translatesAutoresizingMaskIntoConstraints = false
        //        lineChart.delegate = self
        //        self.view.addSubview(lineChart)
        //        views["chart"] = lineChart
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        //
        //        //        var delta: Int64 = 4 * Int64(NSEC_PER_SEC)
        //        //        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        //        //
        //        //        dispatch_after(time, dispatch_get_main_queue(), {
        //        //            self.lineChart.clear()
        //        //            self.lineChart.addLine(data2)
        //        //        });
        //
        //        //        var scale = LinearScale(domain: [0, 100], range: [0.0, 100.0])
        //        //        var linear = scale.scale()
        //        //        var invert = scale.invert()
        //        //        println(linear(x: 2.5)) // 50
        //        //        println(invert(x: 50)) // 2.5
        
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
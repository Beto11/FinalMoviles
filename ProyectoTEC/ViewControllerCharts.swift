//
//  ViewControllerCharts.swift
//  ProyectoTEC
//
//  Created by user198113 on 11/22/21.
//

import UIKit
import Charts

class ViewControllerCharts: UIViewController, ChartViewDelegate {

    var lineChart = LineChartView()
    
    override func viewDidLoad() {
          super.viewDidLoad()
          lineChart.delegate = self
      }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            lineChart.center = view.center
            view.addSubview(lineChart)

        var entries = [ChartDataEntry]()
        entries.append(ChartDataEntry(x: Double(1), y: Double(0.2)))
        entries.append(ChartDataEntry(x: Double(2), y: Double(0.4)))
        entries.append(ChartDataEntry(x: Double(3), y: Double(0.6)))
        entries.append(ChartDataEntry(x: Double(4), y: Double(1)))
        entries.append(ChartDataEntry(x: Double(5), y: Double(0.2)))
        entries.append(ChartDataEntry(x: Double(6), y: Double(0.4)))
        entries.append(ChartDataEntry(x: Double(7), y: Double(0.6)))
        entries.append(ChartDataEntry(x: Double(8), y: Double(0.8)))
        entries.append(ChartDataEntry(x: Double(9), y: Double(1)))
        entries.append(ChartDataEntry(x: Double(10), y: Double(0.2)))

            let set = LineChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.material() 
            let data = LineChartData(dataSet: set)
            lineChart.data = data
        }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

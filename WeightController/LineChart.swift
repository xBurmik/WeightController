//
//  LineChart.swift
//  WeightController
//
//  Created by Aleksey on 16.08.2021.
//

import UIKit
import Charts


class LineChart {
    
    func CreateLineChart (size : CGSize, weight: [Double], days: [Date]) -> UIView{
        
        
        var weight = weight
        var days = days
        let maxValues = 30
        
        while weight.count > maxValues {
            weight.removeFirst()
        }
        while days.count > maxValues {
            days.removeFirst()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        var daysFormatted = [String]()
        
        for day in days {
            daysFormatted.append(dateFormatter.string(from: day))
        }
        
        let lineChart = LineChartView(frame:
                                        CGRect(x: 0,
                                               y: 0,
                                               width: size.width - 10,
                                               height: size.height)
        )
        
        lineChart.doubleTapToZoomEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.labelFont = .boldSystemFont(ofSize: 10)
        lineChart.leftAxis.setLabelCount(6, force: false)
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysFormatted)
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        lineChart.xAxis.axisMaxLabels = 15
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.granularity = 1
        
        lineChart.legend.enabled = false
        
        
        lineChart.backgroundColor = .clear
        
        
        var entries = [ChartDataEntry]()
        
        for index in 0..<weight.count {
            
            entries.append(ChartDataEntry(x: Double(index), y: weight[index]))
        }
        let set = LineChartDataSet(entries: entries)
        
        set.drawCircleHoleEnabled = true
        set.circleRadius = 3.5
        set.circleHoleRadius = 0
        set.circleColors = ChartColorTemplates.colorful()
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.cubicIntensity = 0.05
        set.lineWidth = 4
        set.setColor(.systemIndigo)
        set.fill = Fill(color: .white)
        set.fillAlpha = 0.3
        set.drawFilledEnabled = true
        set.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
        
        return lineChart
    }
    
}

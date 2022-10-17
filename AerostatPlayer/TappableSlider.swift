//
//  TappableSlider.swift
//  AerostatPlayer
//
//  Created by Yuri Andrianov on 16.10.2022.
//

import SwiftUI

struct TappableSlider: View {
    
    var value: Binding<Double>
    var range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            Slider(value: value, in: range)
                .gesture(DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        let percent = min(max(0, Double(value.location.x / geometry.size.width * 1)), 1)
                        let newValue = range.lowerBound + round(percent * (range.upperBound - range.lowerBound))
                        
                        self.value.wrappedValue = newValue
                    })
        }
    }
}
